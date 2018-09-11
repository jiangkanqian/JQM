/**
 * 
 */
package com.cjhxfund.ats.sm.comm;

import java.sql.Connection;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.lang.StringUtils;

import com.cjhxfund.cjapi.common.CommOperatorUtil;
import com.cjhxfund.cjapi.exception.AppException;
import com.cjhxfund.cjapi.exception.CJAPIConstants;
import com.cjhxfund.commonUtil.CacheUtil;
import com.cjhxfund.commonUtil.DateUtil;
import com.cjhxfund.commonUtil.JDBCUtil;
import com.cjhxfund.commonUtil.ParamConfig;
import com.cjhxfund.commonUtil.StrUtil;
import com.cjhxfund.foundation.fix.FixToUtil;
import com.eos.das.entity.criteria.CriteriaType;
import com.eos.data.datacontext.DataContextManager;
import com.eos.data.datacontext.IMUODataContext;
import com.eos.engine.component.ILogicComponent;
import com.eos.foundation.data.DataContextUtil;
import com.eos.foundation.data.DataObjectUtil;
import com.eos.foundation.database.DatabaseExt;
import com.eos.foundation.database.DatabaseUtil;
import com.eos.system.annotation.Bizlet;
import com.eos.workflow.api.BPSServiceClientFactory;
import com.eos.workflow.api.IBPSServiceClient;
import com.eos.workflow.api.IWFActivityInstManager;
import com.eos.workflow.api.IWFBackActivityManager;
import com.eos.workflow.data.WFActivityInst;
import com.primeton.cap.resource.helper.AppDataSourceHelper;
import com.primeton.ext.engine.component.LogicComponentFactory;
import com.primeton.workflow.api.WFServiceException;

import commonj.sdo.DataObject;

/**
 * @author 刘玉龙
 * @date 2016-10-27 14:31:22
 *
 */
@Bizlet("")
public class InstructionManagerUtil {
	public static String SM_TRIAL_PARAM_KEY = "ATS_SM_IS_TRIAL";//0-非试运营模式；1-试运营模式
	/**
	 * 判断是否使用fix接口
	 * @param instructParameter 投资建议下达传入的指令信息
	 * @return 
	 * @author liuyulong
	 */
	@Bizlet("")
	public static String fixEnable(DataObject instructParameter){
		
		Boolean isFixCanUse = FixToUtil.fixEnbleStatus(instructParameter.getString("vcProductCode"));
		String isSmTrial = ParamConfig.getValue(SM_TRIAL_PARAM_KEY);
		if(isFixCanUse && "0".equals(isSmTrial)){
			//fix可用且配置了相关产品使用fix的前提下判断相关业务是否需要使用fix(回购业务中的“交易所协议式回购”暂时不支持fix接口)
			String bizType = instructParameter.getString("vcBizType");
			//业务类别：1-银行间二级交易，2-上海大宗交易，3-上海固收平台，4-深圳综合协议平台，5-银行间质押式回购，6-银行间买断式回购，7-交易所协议式回购
			if(!"7".equals(bizType)){
				return "1";
			}

		}
		return "0";
	}
	
	
	/**
	 * 判断指令是否可被修改
	 * @param  srcInstruct 指令信息
	 * @return 
	 * @author liuyulong
	 */
	@Bizlet("")
	public static DataObject instructRevisability(DataObject instructParameter, DataObject srcInstruct){
		DataObject resultObject = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd"); 
		String sysDate = format.format(new Date().getTime());
		boolean isRevise = true;//是否可修改
		String resultMsg = null;//指令判断结果信息反馈
		DataObject lastInstructInfo = null;
		if(srcInstruct.getString("lResultId")!=null && !"".equals(srcInstruct.getLong("lResultId"))){
			lastInstructInfo = DataObjectUtil.createDataObject("com.cjhxfund.ats.sm.comm.atsSmData.TAtsInquiryResultInstruct");//询价结果信息
			lastInstructInfo.setLong("lResultId", srcInstruct.getLong("lResultId"));
			DatabaseUtil.expandEntity(JDBCUtil.DATA_SOURCE_DEFAULT, lastInstructInfo);
			//回填指令状态与流程状态
			if("1".equals(srcInstruct.getString("cIsValid"))){//传入时为有效状态
				if("1".equals(lastInstructInfo.getString("cIsValid"))){//最新状态为有效状态
					if("8".equals(lastInstructInfo.getString("vcProcessStatus")) || "9".equals(lastInstructInfo.getString("vcProcessStatus"))){//指令已前台成交
						isRevise = false;
						resultMsg = "修改失败，原指令前台已成交，不能修改，请先确认!";
					}else if(instructParameter.getInt("lTradeDate") > lastInstructInfo.getInt("lTradeDate") && sysDate.equals(lastInstructInfo.getString("lTradeDate")) && !"".equals(lastInstructInfo.getString("vcOrigordId")) && lastInstructInfo.getString("vcOrigordId")!=null){
						isRevise = false;
						resultMsg = "原指令已发送到O32且为有效，不允许将该指令改为预置指令！";
					}
				}else if("2".equals(lastInstructInfo.getString("cIsValid"))||"5".equals(lastInstructInfo.getString("cIsValid"))||"6".equals(lastInstructInfo.getString("cIsValid"))){
					isRevise = false;
					resultMsg = "原指令已被修改，请对最新记录进行修改!";
				}else if("3".equals(lastInstructInfo.getString("cIsValid"))){
					isRevise = false;
					resultMsg = "修改失败，原指令已被撤销，请先确认!";
				}else if("4".equals(lastInstructInfo.getString("cIsValid"))){
					isRevise = false;
					resultMsg = "修改失败，原指令已被退回，请先确认!";
				}
			}else if("5".equals(srcInstruct.getString("cIsValid"))){
				if("1".equals(lastInstructInfo.getString("cIsValid"))){
					isRevise = false;
					resultMsg = "修改失败，原指令被还原，请先确认!";
				}
			}
		}
		srcInstruct.setString("cIsValid", lastInstructInfo.getString("cIsValid"));
		srcInstruct.setString("vcInstructSource", lastInstructInfo.getString("vcInstructSource"));
		srcInstruct.setString("vcProcessStatus", lastInstructInfo.getString("vcProcessStatus"));
		if("1".equals(lastInstructInfo.getString("cIsValid"))){
			srcInstruct.setString("validOrigordId", lastInstructInfo.getString("vcOrigordId"));
			srcInstruct.setString("fixEnable", lastInstructInfo.getString("cFixEnable"));
		}else{
			srcInstruct.setString("lInquiryNo", null);
			srcInstruct.setString("lResultNo", null);
		}
		resultObject.setBoolean("isRevise", isRevise);
		resultObject.setString("resultMsg", resultMsg);
		return resultObject;
	}
	
	/**
	 * 重新拿取指令信息判断指令是否可被撤销
	 * @param  srcInstruct 指令信息
	 * @return 
	 * @author liuyulong
	 */
	@Bizlet("")
	public static DataObject instructRevoke(DataObject srcInstruct){
		DataObject resultObject = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
		boolean isRevise = true;//是否可修改
		String resultMsg = null;//指令判断结果信息反馈
		DataObject lastInstructInfo = null;
		if(srcInstruct.getString("lResultId")!=null && !"".equals(srcInstruct.getLong("lResultId"))){
			lastInstructInfo = DataObjectUtil.createDataObject("com.cjhxfund.ats.sm.comm.atsSmData.TAtsInquiryResultInstruct");//询价结果信息
			lastInstructInfo.setLong("lResultId", srcInstruct.getLong("lResultId"));
			DatabaseUtil.expandEntity(JDBCUtil.DATA_SOURCE_DEFAULT, lastInstructInfo);
			if(!"1".equals(lastInstructInfo.getString("cIsValid"))){
				isRevise = false;
				resultMsg = "原指令已无效,无需再撤销操作!";
			}else if("1".equals(lastInstructInfo.getString("cIsValid")) && ("8".equals(lastInstructInfo.getString("vcProcessStatus"))||"9".equals(lastInstructInfo.getString("vcProcessStatus")))){
				isRevise = false;
				resultMsg = "前台已成交,不可撤销!";
			}
		}
		srcInstruct.setString("vcInstructSource", lastInstructInfo.getString("vcInstructSource"));
		srcInstruct.setString("vcProcessStatus", lastInstructInfo.getString("vcProcessStatus"));
		resultObject.setBoolean("isRevise", isRevise);
		resultObject.setString("resultMsg", resultMsg);
		return resultObject;
	}
	
	
	/**
	 * 招行接口数据撤销，反馈指令状态
	 * @param  srcInstruct 指令信息
	 * @return 
	 * @author liuyulong
	 * @throws AppException 
	 */
	@Bizlet("")
	public static void orderOperateCallBack(DataObject instructParameter, String vcOrderStatus) throws AppException{
		String cjapiEntityName = null;
		if("1".equals(instructParameter.getString("vcBizType"))){//银行间买卖买卖
			cjapiEntityName = CJAPIConstants.BANK_SECOND_MARKET_ENTITY_NAME;//
		}else if("2".equals(instructParameter.getString("vcBizType")) || "3".equals(instructParameter.getString("vcBizType")) || "4".equals(instructParameter.getString("vcBizType"))){//交易所买卖
			cjapiEntityName = CJAPIConstants.EXCHANGE_SECOND_ENTITY_NAME;
		}
		if(cjapiEntityName!=null){
			try {
				String result = CommOperatorUtil.feedbackOrderStatus(cjapiEntityName, instructParameter.getString("lResultNo"), vcOrderStatus);
				if(result!=null && "00000".equals(result)){
					System.out.println("指令废弃接口操作成功,已废弃投资编号为【"+instructParameter.getString("lResultNo")+"】的指令");
				}
			} catch (Exception e) {
				if(e instanceof AppException){
					System.out.println("投资编号【"+instructParameter.getString("lResultNo")+"】指令废弃接口操作失败,失败原因："+((AppException) e).getMsg());
				}else{
					System.out.println("投资编号【"+instructParameter.getString("lResultNo")+"】指令废弃接口操作失败");
				}
			}
		}
	}
	
	
	/**
	 * 查询O32中的风控审批结果更改本地审批结果
	 * @author liuyulong
	 */
	@SuppressWarnings("unused")
	@Bizlet("")
	public static void riskApproveStatus(){
		//获取指令审批数据
		Connection conn=com.primeton.cap.resource.helper.DatabaseHelper.getConnection(CacheUtil.getO32CacheDataSourceName());
		//conn.
		DataSource ds=AppDataSourceHelper.getDataSource(CacheUtil.getO32CacheDataSourceName());
		//Connection conn =source.getConnection(username, password)
		DatabaseExt.queryByNamedSql(CacheUtil.getO32CacheDataSourceName(), 
				"com.cjhxfund.jy.BackStageTradeProcess.updateBackStageTraderStatus.queryClordid", 
				"12345647");
		DataObject[] approveResults = (DataObject[]) DatabaseExt.queryByNamedSql(CacheUtil.getO32CacheDataSourceName(), "com.cjhxfund.ats.sm.comm.instructionManage.riskApproveInfo", null);
		if(approveResults!=null && approveResults.length>0){
			for(int i=0; i< approveResults.length; i++){
				DataObject approveResult = approveResults[i];
				DataObject param = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
				param.set("vcClordId", approveResult.getString("vcSourceNo"));//第三方指令ID
				DataObject[] inquiryResults = (DataObject[]) DatabaseExt.queryByNamedSql(JDBCUtil.DATA_SOURCE_DEFAULT, "com.cjhxfund.ats.sm.comm.instructionManage.getInquiryResults", param);
				if(inquiryResults!=null && inquiryResults.length>0 && inquiryResults[0]!=null){
					DataObject inquiryResult = inquiryResults[0];
					//当指令为有效，流程状态为“待风控审批”状态时，驱动审批流程，更新相应状态
					if(inquiryResult.getString("cIsValid").equals("1") && inquiryResult.getString("vcProcessStatus").equals("4")){
						String componentName = "com.cjhxfund.ats.sm.comm.TaskManager";//逻辑构件名称
						String operationName = "finishActityInst";//逻辑流名称
						ILogicComponent logicComponent = LogicComponentFactory.create(componentName);
						int size = 1;
						// 逻辑流的输入参数
						Object[] params = new Object[size];
						DataObject paramData = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
						paramData.set("lProcessinstId", inquiryResult.getInt("lProcessinstId"));//流程实例Id
						paramData.set("vcUserName", approveResult.getString("vcOperatorName"));//审批人
						//paramData.set("dEndTime", approveResult.getString("lApproveTime"));//审批时间
						if(approveResult.getInt("cApproveResult")==3){
							paramData.set("vcOperateType", 1);//审批结果:审批通过
						}else if(approveResult.getInt("cApproveResult")==4){
							paramData.set("vcOperateType", 2);//审批结果:审批拒绝
						}
						paramData.set("vcComments", approveResult.getString("vcApprovePostil"));//审批备注或意见
						paramData.set("activityDefID", "autoActivity3");
						params[0] = paramData;
						try {
							logicComponent.invoke(operationName, params);
						} catch (Throwable e) {
							//LogUtil.logError("询价结果指令编号为【"+inquiryResult.getString("lResultId")+"】的指令风控审批操作异常",e, new Object[]{});
							e.printStackTrace();
						}

						
					}
				}
			}
		}
	}
	
	/**
	 * 回退前台已成交指令到待成交状态
	 * @param lProcessinstId 流程实例Id
	 * @param userId 用户Id
	 * @param userName 用户名称
	 * @return 流程中当前
	 * @throws WFServiceException 
	 * @throws ParseException 
	 */
	@Bizlet("回退流程")
	public static void backFSDealProcessStatus(long lProcessinstId, String userId, String userName) throws WFServiceException{
		BPSServiceClientFactory.getLoginManager().setCurrentUser(userId, userName); 
		IBPSServiceClient client;
		client = BPSServiceClientFactory.getDefaultClient();
		if(client.getProcessInstManager().getProcessInstState(lProcessinstId)==2){//流程为运行状态
			IWFActivityInstManager activityInstManager = client.getActivityInstManager(); 
			List<WFActivityInst> activityInsts = activityInstManager.queryActivityInstsByProcessInstID(lProcessinstId, null);
			for(WFActivityInst activityInst:activityInsts){
				String activityDefID = activityInst.getActivityDefID();
				if(activityInst.getCurrentState()==10 && "finishActivity".equals(activityDefID)){
					long activityInstId = activityInst.getActivityInstID();
					IWFBackActivityManager backActManager = client.getBackActivityManager();
					backActManager.backActivity(activityInstId,"frontDeal","path");
					DatabaseExt.executeNamedSql("default", "com.cjhxfund.ats.sm.comm.instructionManage.updateCancelInstruct", lProcessinstId);
				}
		 	}
		}
	}
	
	/**
	 * 将反馈报文失败原因格式化若触发风控判断风控类型
	 * @param str 反馈报文失败原因（警告信息等）
	 * @param newlineFlag 换行标志
	 * @return
	 * @author 刘玉龙
	 */
	@SuppressWarnings("unused")
	@Bizlet("")
	public static DataObject changeFailReason(String str, String newlineFlag){
		DataObject resultDataObject = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
		String riskType = "0";
		int operation = 0;//触警操作为“无”的个数
		int alertOperation = 0;//触警操作为“预警”的个数
		int forbidOperation = 0;//触警操作为“禁止”的个数
		int approveOperation = 0;//触警操作为“申请指令审批”的个数
		int askOperation = 0;//触警操作为“申请风险阀值”的个数
		Boolean isAgainstRisk = false;
		
		if(StringUtils.isBlank(str)){
			return null;
		}
		/** 从返回报文XML格式字符串提取出失败类型、失败原因等 */
		Map<String,String> map = FixToUtil.readStringXmlOut(str);
		/** Type属性值域，2-风控 */
		String failReasonType = map.get("failReasonType");
		//String reasonCount = map.get("reasonCount");
		/**1-可用Reason信息：组合编号|申报代码|交易市场|投资类型|可用不足提示说明
		 * 2-风控Reason信息：触警级别|触警操作|组合编号|证券编码|交易所|风控编号|风控类型|设置值|实际值|风控说明
		 */
		String reason = map.get("reason");
		StringBuffer sb = new StringBuffer();
		StringBuffer sbMsg = new StringBuffer();
		String[] arr = reason.split(FixToUtil.REASON_SPLIT);
		for(int i=0; i<arr.length; i++){
			sbMsg.setLength(0);
			/** 1-可用Reason信息 */
			if("1".equals(failReasonType)){
				if(StringUtils.isNotBlank(arr[i]) && arr[i].split("\\|").length>=5){
					sbMsg.append(arr[i].split("\\|")[4]).append("；");
				}
				
			/** 2-风控Reason信息 */
			}else if("2".equals(failReasonType)){
				if(StringUtils.isNotBlank(arr[i])){
					String[] arrTemp = arr[i].split("\\|");
					if(arrTemp.length>=10){
						isAgainstRisk = true;
						DataObject riskObject = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
						riskObject.setString("vcThreshhold", arrTemp[0]);//触警级别
						riskObject.setString("cRiskOperation", arrTemp[1]);//触警操作
						riskObject.setString("vcCombiNo", arrTemp[2]);//组合代码
						Object[] productResults = DatabaseExt.queryByNamedSql("default", "com.cjhxfund.foundation.fix.model.interfaceMessageManager.getProductInfoByCombiNo", riskObject);
						if(productResults[0]!=null){
							DataObject productInfo = (DataObject) productResults[0];
							riskObject.setString("vcProductCode", productInfo.getString("VC_PRODUCT_CODE"));//产品代码
							riskObject.setString("vcProductName", productInfo.getString("VC_PRODUCT_NAME"));//产品名称
							riskObject.setString("vcCombiName", productInfo.getString("VC_COMBI_NAME"));//组合名称
						}
						riskObject.setString("vcSymbol", arrTemp[3]);//证券申报代码
						riskObject.setString("vcMarketCode", arrTemp[4]);//市场标识
						Object[] stockResults = DatabaseExt.queryByNamedSql(CacheUtil.getO32CacheDataSourceName(), "com.cjhxfund.foundation.fix.model.interfaceMessageManager.getO32StockName", riskObject);
						if(stockResults[0]!=null){
							DataObject stockInfo = (DataObject) stockResults[0];
							riskObject.setString("vcStockName", stockInfo.getString("VC_STOCK_NAME"));//证券申报名称
							riskObject.setString("vcExDestination", stockInfo.getString("C_MARKET_NO"));//交易场所
						}
						riskObject.setString("vcRuleId", arrTemp[5]);//风控编号
						riskObject.setString("vcRiskType", arrTemp[6]);//风控类型
						riskObject.setString("vcSettingValue", arrTemp[7]);//设置值
						riskObject.setString("vcRealValue", arrTemp[8]);//实际值
						riskObject.setString("vcRiskSummary", arrTemp[9]);//风控说明
						DataContextUtil.appendObject("riskMsgs", riskObject, false);
						
						String riskOperation = "";
						//根据触警操作判断触警类型，并记录各类触警个数
						if(arrTemp[1] !=null){
							if("0".equals(arrTemp[1])){//触警操作为“无”
								operation+=1;
							}else if("1".equals(arrTemp[1])){//触警操作为“预警”
								alertOperation+=1;
								riskOperation="-预警";
							}else if("2".equals(arrTemp[1])){//触警操作为“禁止”
								forbidOperation+=1;
								riskOperation="-禁止";
							}else if("3".equals(arrTemp[1])){//触警操作为“申请指令审批”
								approveOperation+=1;
								riskOperation="-申请指令审批";
							}else if("4".equals(arrTemp[1])){//触警操作为“申请风险阀值”
								askOperation+=1;
								riskOperation="-申请风险阀值";
							}
						}
						/** 示例：组合[1001_000]证券[100005]触发风控[375]：债券成交收益率不超过公允收益率60bp； */
						//sbMsg.append("组合[").append(arrTemp[2]).append("]证券[").append(arrTemp[3]).append("]触发风控[").append(arrTemp[5]).append("]：").append(arrTemp[9]).append("；");
						sbMsg.append("[").append(arrTemp[2]).append("][").append(arrTemp[3]).append("]触发[").append(arrTemp[5]).append(riskOperation).append("]：").append(arrTemp[9]).append("；");
					}
				}
			}
			sb.append(i+1).append("、").append(StrUtil.addNewlineFlag(sbMsg.toString(), newlineFlag, 60));
			if(i<arr.length-1){
				sb.append(newlineFlag);
			}
		}
		if(forbidOperation!=0){
			riskType="3";//风控结果为禁止
		}else{
			if(approveOperation != 0){
				riskType="2";//风控结果为审批
			}else if(alertOperation != 0){
				riskType="1";//风控结果为预警
			}
		}
		resultDataObject.setBoolean("isAgainstRisk", isAgainstRisk);
		resultDataObject.set("riskType", riskType);
		resultDataObject.set("failReason", sb.toString());
		return resultDataObject;
	}
	
	
	/**
	 * 若失败是由于风控原因产生，将风控说明
	 * @param str 反馈报文失败原因（警告信息等）
	 * @param newlineFlag 换行标志
	 * @return
	 * @author 刘玉龙
	 */
	@Bizlet("")
	public static DataObject mergeO32FailReson(String fail, String str, String newlineFlag){
		DataObject resultDataObject = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
		if(StringUtils.isBlank(str)){
			resultDataObject.setString("fail", fail);
			return resultDataObject;
			//return fail;
		}
		/** 从返回报文XML格式字符串提取出失败类型、失败原因等 */
		Map<String,String> map = FixToUtil.readStringXmlOut(str);
		/** Type属性值域，2-风控 */
		String failReasonType = map.get("failReasonType");
		//String reasonCount = map.get("reasonCount");
		/**1-可用Reason信息：组合编号|申报代码|交易市场|投资类型|可用不足提示说明
		 * 2-风控Reason信息：触警级别|触警操作|组合编号|证券编码|交易所|风控编号|风控类型|设置值|实际值|风控说明
		 */
		Boolean isAgainstRisk = false;
		
		String reason = map.get("reason");
		StringBuffer sb = new StringBuffer();
		StringBuffer sbMsg = new StringBuffer();
		String[] arr = reason.split(FixToUtil.REASON_SPLIT);
		for(int i=0; i<arr.length; i++){
			sbMsg.setLength(0);
			/** 1-可用Reason信息 */
			
			/** 2-风控Reason信息 */
			if("2".equals(failReasonType)){
				isAgainstRisk = true;
				if(StringUtils.isNotBlank(arr[i])){
					String[] arrTemp = arr[i].split("\\|");
					if(arrTemp.length>=10){
						DataObject riskObject = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
						riskObject.setString("vcThreshhold", arrTemp[0]);//触警级别
						riskObject.setString("cRiskOperation", arrTemp[1]);//触警操作
						riskObject.setString("vcCombiNo", arrTemp[2]);//组合代码
						Object[] productResults = DatabaseExt.queryByNamedSql("default", "com.cjhxfund.foundation.fix.model.interfaceMessageManager.getProductInfoByCombiNo", riskObject);
						if(productResults[0]!=null){
							DataObject productInfo = (DataObject) productResults[0];
							riskObject.setString("vcProductCode", productInfo.getString("VC_PRODUCT_CODE"));//产品代码
							riskObject.setString("vcProductName", productInfo.getString("VC_PRODUCT_NAME"));//产品名称
							riskObject.setString("vcCombiName", productInfo.getString("VC_COMBI_NAME"));//组合名称
						}
						riskObject.setString("vcSymbol", arrTemp[3]);//证券申报代码
						riskObject.setString("vcMarketCode", arrTemp[4]);//市场标识
						Object[] stockResults = DatabaseExt.queryByNamedSql(CacheUtil.getO32CacheDataSourceName(), "com.cjhxfund.foundation.fix.model.interfaceMessageManager.getO32StockName", riskObject);
						if(stockResults[0]!=null){
							DataObject stockInfo = (DataObject) stockResults[0];
							riskObject.setString("vcStockName", stockInfo.getString("VC_STOCK_NAME"));//证券申报名称
							riskObject.setString("vcExDestination", stockInfo.getString("C_MARKET_NO"));//交易场所
						}
						riskObject.setString("vcRuleId", arrTemp[5]);//风控编号
						riskObject.setString("vcRiskType", arrTemp[6]);//风控类型
						riskObject.setString("vcSettingValue", arrTemp[7]);//设置值
						riskObject.setString("vcRealValue", arrTemp[8]);//实际值
						riskObject.setString("vcRiskSummary", arrTemp[9]);//风控说明
						DataContextUtil.appendObject("riskMsgs", riskObject, false);
						
						sbMsg.append(arrTemp[9]).append("；");
					}
				}
				if(i==0){
					sb.append(newlineFlag).append("反馈说明：");
				}
				sb.append(i+1).append("、").append(sbMsg.toString());
			}
		}
		resultDataObject.setString("fail", fail+sb.toString());
		resultDataObject.setBoolean("isAgainstRisk", isAgainstRisk);
		System.out.println(StrUtil.addNewlineFlag(sb.toString(), newlineFlag, 60));
		return resultDataObject;
	}
	
	/**
	 * 将数组数据拼装成字符串
	 * @param arr
	 * @param 
	 * @return
	 * @author liuyulong
	 */
	@Bizlet("")
	public static String switchArrToString(String[] arr){
		String result = "";
		for(int i=0; i < arr.length; i++){
			if(i==arr.length-1){
				result += "'"+arr[i]+"'";
			}else{
				result += "'"+arr[i]+"',";
			}
		}
		return result;
	}

	/**
	 * 根据第三方指令ID获取O32成交明细
	 * @param String vcClordIds 包含一个或多个第三方指令ID且用逗号隔开
	 * @return
	 * @author liuyulong
	 */
	@Bizlet("")
	public static List<DataObject> getDealDetail(String vcClordIds){
		List<DataObject> result = new ArrayList<DataObject>();
		StringBuffer sb = new StringBuffer();
		DataObject obj = null;
		Connection conn = null;
		try {
			//获取默认连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//拼接SQL语句
			sb.append("select l_trade_rival_no, ")//交易对手
			  .append("       vc_rivaltrader_name, ")//对方交易员名称
			  .append("       en_balance,")//券面总额
			  .append("       en_second_mature_yield, ")//到期收益率
			  .append("       en_deal_balance, ")//交易金额
			  .append("       en_first_net_price, ")// 首次交易净价价格
			  .append("       en_first_full_price ")//首次交易全价价格
			  .append("from trade.TBANKREALDEAL")
			  .append(" where vc_source_no in (") .append(vcClordIds).append(")");
			
			List<Map<String, String>> list = JDBCUtil.queryWithConn(conn, sb.toString(), null);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					obj = DataObjectUtil.createDataObject("com.cjhxfund.ats.sm.comm.commEntity.consumEntity");
					obj.setString("lTradeRivalNo", map.get("L_TRADE_RIVAL_NO"));
					obj.setString("vcRivaltraderName", map.get("VC_RIVALTRADER_NAME"));
					obj.setString("enBalance", map.get("EN_BALANCE"));
					obj.setString("enSecondMatureYield", map.get("EN_SECOND_MATRUE_YIELD"));
					obj.setString("enDealBalance", map.get("EN_DEAL_BALANCE"));
					obj.setString("enFrstNetPrice", map.get("EN_FIRST_NET_PRICE"));
					obj.setString("enFirstFullPrice", map.get("EN_FIRST_FULL_PRICE"));
					result.add(obj);
					obj = null;
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.releaseResource(conn, null, null);
		}
		return result;
	}
	
	/**
	 * 获取债券净价、全价、收益率（可以必填其一，选填其他，输入一个另外两个数据可以系统自动算出来）
	 * @param processDate 业务日期
	 * @param interCode 证券内码
	 * @param netPrice 净价（元/百元面值）
	 * @param fullPrice 全价（元/百元面值）
	 * @param interestRate 收益率（%）
	 * @param interestRateType 收益率类型：[1-到期;2-行权日]
	 * @param tradingPlace 交易场所：[01-银行间;02-上交所固收平台;03-深交所综合协议平台|上交所大宗;]
	 * @param clearingSpeed 清算速度：T+0、T+1
	 * @return 返回结果：净价，全价，收益率，收益率类型，交易场所，清算速度
	 * @author wuyanfei
	 */
	@Bizlet("")
	public static String getLinkageValue(String processDate, String interCode, String netPrice, String fullPrice, String interestRate, String interestRateType, String tradingPlace, String clearingSpeed){
		//返回结果：净价，全价，收益率，收益率类型，交易场所，清算速度
		String result = StrUtil.changeNull(netPrice) + "@" + StrUtil.changeNull(fullPrice) + "@" + StrUtil.changeNull(interestRate) + "@" + StrUtil.changeNull(interestRateType) + "@" + StrUtil.changeNull(tradingPlace)  + "@" + StrUtil.changeNull(clearingSpeed);
		if(StringUtils.isBlank(processDate) || StringUtils.isBlank(interCode)
				|| (StringUtils.isBlank(netPrice)&&StringUtils.isBlank(fullPrice)&&StringUtils.isBlank(interestRate))){
			return result;
		}
		processDate = processDate.replaceAll("-", "");
		//若不传入“收益率类型”值，则取“1-到期”
		if(!"1".equals(interestRateType) && !"2".equals(interestRateType)){
			interestRateType = "1";
		}
		Connection conn = null;
		Connection connJqm = null;
		try {
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());//获取O32系统数据库连接
			connJqm = JDBCUtil.getConnByDataSourceId("default");//获取O32系统数据库连接
			//获取“证券内码”、“百元债券利息”、“当日利息”
			String sql_bond_info = "select t1.vc_inter_code,nvl(t1.EN_BOND_INTEREST,0) EN_BOND_INTEREST,nvl(t1.EN_TODAY_INTEREST,0) EN_TODAY_INTEREST,nvl(t1.EN_NEXT_BOND_INTEREST,0) EN_NEXT_BOND_INTEREST from trade.TBONDPROPERTY t1 where t1.vc_inter_code='" + interCode + "'";
			String jqm_stock = "select t.c_market_no_1,t.c_is_flat_trading,t.l_endincal_date from t_ats_all_stock_info t where t.vc_inter_code_o32='" + interCode + "'";
			String val_bond_info = JDBCUtil.getRecordValueBySql(conn, sql_bond_info);
			String val_stock_info = JDBCUtil.getRecordValueBySql(connJqm, jqm_stock);
			
			//若查找到“证券内码”、“百元债券利息”、“当日利息”，则继续执行，否则直接结束返回
			if(StringUtils.isNotEmpty(val_bond_info)&&StringUtils.isNotEmpty(val_stock_info)){
				String[] val_bond_info_arr = val_bond_info.split(",");
				String[] val_stock_info_arr = val_stock_info.split(",");
				String vc_inter_code = val_bond_info_arr[0];//证券内码
				String val_en_bond_interest = val_bond_info_arr[1];//“百元债券利息”
				String en_today_interest = val_bond_info_arr[2];//“当日利息”
				String en_next_interest = val_bond_info_arr[3];//“下日利息”
				String c_is_flat_trading = val_stock_info_arr[1];//是否净价 1：净价 2：全价
				String l_endincal_date = val_stock_info_arr[2];//债券结束日期
				
				String busiDate = processDate;//计算业务日期，默认使用传入的业务日期
				String bond_interest = val_en_bond_interest;//应计利息，默认使用“百元债券利息”
				//若清算速度为T+1，则计算业务日期取T+1日，应计利息取“当日利息”
				if("T+1".equals(clearingSpeed)){
					if(tradingPlace.equals("01")){
						busiDate = DateUtil.getCalculateTradeDay(conn, processDate, null, 1);
						bond_interest = en_next_interest;
					}else{
						bond_interest = en_today_interest;
					}
				}else{
					clearingSpeed = "T+0";//默认计算T+0的值
				}
				
				//若传入净价，优先使用净价计算全价、收益率
				if(StringUtils.isNotBlank(netPrice)){
					netPrice = netPrice.replaceAll(",", "").trim();
					//计算全价，全价=净价+百元债券利息
					fullPrice = String.valueOf(Double.parseDouble(netPrice.trim()) + Double.parseDouble(bond_interest));
					double price = 0.0;
					if(c_is_flat_trading.equals("1")){
						price = Double.parseDouble(netPrice.trim());
					}else{
						price = Double.parseDouble(fullPrice.trim());
					}
					//根据债券价格[净价]计算债券到期收益率（统计日期，债券代码[内码]，单券债券委托价格[净价]，计算到指定日期的收益率[默认0]，计算到到期还是到行权日[1-到期;2-行权日]）
					//sf_get_bond_yield(l_date_p,vc_inter_code_p,en_price_p,l_design_end_date_p,c_type_p)
					String sql_sf_get_bond_yield_expire = "select 100*round(trade.sf_get_bond_yield("+busiDate+",'"+vc_inter_code+"',"+price+","+Integer.valueOf(l_endincal_date)+",'"+1+"'),6) bond_yield from dual";
					String val_yield_expire = JDBCUtil.getValueBySql(conn, sql_sf_get_bond_yield_expire);
					
					//根据债券价格[净价]计算债券行权收益率（统计日期，债券代码[内码]，单券债券委托价格[净价]，计算到指定日期的收益率[默认0]，计算到到期还是到行权日[1-到期;2-行权日]）
					String sql_sf_get_bond_yield_exercise = "select 100*round(trade.sf_get_bond_yield("+busiDate+",'"+vc_inter_code+"',"+price+","+Integer.valueOf(l_endincal_date)+",'"+2+"'),6) bond_yield from dual";
					String val_yield_exercise = JDBCUtil.getValueBySql(conn, sql_sf_get_bond_yield_exercise);
					
					//返回结果：净价，全价，到期收益率，收益率类型，交易场所，清算速度，行权收益率
					result = netPrice.trim() + "@" + fullPrice + "@" + val_yield_expire + "@" + interestRateType + "@" 
					+ StrUtil.changeNull(tradingPlace)  + "@" + StrUtil.changeNull(clearingSpeed) +"@"+val_yield_exercise + 
					"@" + bond_interest;
					
				//若净价为空，存在全价，则使用全价计算净价、收益率
				}else if(StringUtils.isNotBlank(fullPrice)){
					fullPrice = fullPrice.replaceAll(",", "").trim();
					//计算净价，净价=全价-百元债券利息
					double dNetPrice = Double.parseDouble(fullPrice.trim()) - Double.parseDouble(bond_interest);
					double price = 0.0;
					if(c_is_flat_trading.equals("1")){
						price = dNetPrice;
					}else{
						price = Double.parseDouble(fullPrice.trim());
					}
					
					//根据债券价格[净价]计算债券到期收益率（统计日期，债券代码[内码]，单券债券委托价格[净价]，计算到指定日期的收益率[默认0]，计算到到期还是到行权日[1-到期;2-行权日]）
					//sf_get_bond_yield(l_date_p,vc_inter_code_p,en_price_p,l_design_end_date_p,c_type_p)
					String sql_sf_get_bond_yield_expire = "select 100*round(trade.sf_get_bond_yield("+busiDate+",'"+vc_inter_code+"',"+price+","+Integer.valueOf(l_endincal_date)+",'"+1+"'),6) bond_yield from dual";
					String val_yield_expire = JDBCUtil.getValueBySql(conn, sql_sf_get_bond_yield_expire);
					
					//根据债券价格[净价]计算债券行权收益率（统计日期，债券代码[内码]，单券债券委托价格[净价]，计算到指定日期的收益率[默认0]，计算到到期还是到行权日[1-到期;2-行权日]）
					String sql_sf_get_bond_yield_exercise = "select 100*round(trade.sf_get_bond_yield("+busiDate+",'"+vc_inter_code+"',"+price+","+Integer.valueOf(l_endincal_date)+",'"+2+"'),6) bond_yield from dual";
					String val_yield_exercise = JDBCUtil.getValueBySql(conn, sql_sf_get_bond_yield_exercise);
					
					//返回结果：净价，全价，到期收益率，收益率类型，交易场所，清算速度，行权收益率
					result = String.valueOf(dNetPrice) + "@" + fullPrice + "@" + val_yield_expire + "@" + interestRateType 
							+ "@" + StrUtil.changeNull(tradingPlace)  + "@" + StrUtil.changeNull(clearingSpeed) + "@" 
							+ val_yield_exercise+ "@" + bond_interest;
					
					
				//若净价、全价为空，存在收益率，则使用收益率计算净价、全价
				}else if(StringUtils.isNotBlank(interestRate)){
					interestRate = interestRate.replaceAll(",", "").trim();
					
					//根据债券收益率计算债券价格[全价]（统计日期，基金编号，债券代码[内码]，到期收益率，计算到到期还是到行权日[1-到期;2-行权日]）
					String sql_sf_get_bond_price = "select trade.sf_get_bond_price("+busiDate+",null,'"+vc_inter_code+"',"+Double.parseDouble(interestRate)/100+",'"+interestRateType+"') bond_price from dual";
					String val_sf_get_bond_price = JDBCUtil.getValueBySql(conn, sql_sf_get_bond_price);
					//计算净价，净价=全价-百元债券利息
					netPrice = String.valueOf(Double.parseDouble(val_sf_get_bond_price) - Double.parseDouble(bond_interest));
					double price = 0.0;
					if(c_is_flat_trading.equals("1")){
						price = Double.parseDouble(netPrice.trim());
					}else{
						price = Double.parseDouble(val_sf_get_bond_price.trim());
					}
					String val_yield;
					if("2".equals(interestRateType)){
						//根据债券价格[净价]计算债券行权收益率（统计日期，债券代码[内码]，单券债券委托价格[净价]，计算到指定日期的收益率[默认0]，计算到到期还是到行权日[1-到期;2-行权日]）
						String sql_sf_get_bond_yield = "select 100*round(trade.sf_get_bond_yield("+busiDate+",'"+vc_inter_code+"',"+price+","+Integer.valueOf(l_endincal_date)+",'"+2+"'),6) bond_yield from dual";
						val_yield = JDBCUtil.getValueBySql(conn, sql_sf_get_bond_yield);
						//返回结果：净价，全价，到期收益率，收益率类型，交易场所，清算速度，行权收益率
						result = netPrice + "@" + val_sf_get_bond_price + "@" + interestRate + "@" + interestRateType + 
								"@" + StrUtil.changeNull(tradingPlace)  + "@" + StrUtil.changeNull(clearingSpeed) + "@" 
								+val_yield+ "@" + bond_interest;
					}else{
						//根据债券价格[净价]计算债券到期收益率（统计日期，债券代码[内码]，单券债券委托价格[净价]，计算到指定日期的收益率[默认0]，计算到到期还是到行权日[1-到期;2-行权日]）
						String sql_sf_get_bond_yield = "select 100*round(trade.sf_get_bond_yield("+busiDate+",'"+vc_inter_code+"',"+price+","+Integer.valueOf(l_endincal_date)+",'"+1+"'),6) bond_yield from dual";
						val_yield = JDBCUtil.getValueBySql(conn, sql_sf_get_bond_yield);
						//返回结果：净价，全价，到期收益率，收益率类型，交易场所，清算速度，行权收益率
						result = netPrice + "@" + val_sf_get_bond_price + "@" + val_yield + "@" + interestRateType + 
								"@" + StrUtil.changeNull(tradingPlace)  + "@" + StrUtil.changeNull(clearingSpeed) + 
								"@" +interestRate+ "@" + bond_interest;
					}
				}
				
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.releaseResource(conn, null, null);
			JDBCUtil.releaseResource(connJqm, null, null);
		}
		return result;
	}
	
	@Bizlet("联动到期净价、全价")
	public static String getLinkageLastValue(String processDate,String endDate,String marketNo,String reportCode,String interCode,String netPrice,String fullPrice,String payment){
		//返回结果：净价，全价，收益率，收益率类型，交易场所，清算速度
		String result = StrUtil.changeNull(netPrice) + "@" + StrUtil.changeNull(fullPrice);
		if(StringUtils.isBlank(marketNo) || StringUtils.isBlank(interCode)
				|| (StringUtils.isBlank(netPrice)&&StringUtils.isBlank(fullPrice)&&StringUtils.isBlank(reportCode))){
			return result;
		}
		Connection conn = null;
		try {
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());//获取O32系统数据库连接
						
			String sql_bond_info = "select a.vc_inter_code,a.c_market_no,a.c_pay_interest_type,a.c_interest_type,a.l_begincal_date,a.l_end_date,"+
			"a.en_pay_inteval,a.en_curr_face_price,a.en_year_rate,a.en_publish_price from trade.tbondproperty a, trade.tstockinfo b where a.c_market_no = '"+marketNo+"'"+
             "and b.vc_report_code = '"+reportCode+"' and a.c_market_no = b.c_market_no and a.vc_inter_code = '"+interCode+"'";
			String val_bond_info = JDBCUtil.getRecordValueBySql(conn, sql_bond_info);
			if(StringUtils.isNotEmpty(val_bond_info)){
				String[] val_bond_info_arr = val_bond_info.split(",");
				String vc_inter_code = val_bond_info_arr[0];  //债券内码
				String c_market_no = val_bond_info_arr[1];  //市场
				String c_pay_interest_type = val_bond_info_arr[2];  //付息类型
				String c_interest_type = val_bond_info_arr[3];  //利率类型
				String l_begincal_date = val_bond_info_arr[4];  //起息日期
				String l_end_date = val_bond_info_arr[5];  //结束日期
				String en_pay_inteval = val_bond_info_arr[6];  //付息次数
				Double en_curr_face_price = null;
				if(!val_bond_info_arr[7].isEmpty()){
					 en_curr_face_price = Double.parseDouble(val_bond_info_arr[7]);
					 if(payment != null){
						 en_curr_face_price = en_curr_face_price - Double.parseDouble(payment); 
					 }
				}
				String en_year_rate = val_bond_info_arr[8];  //年利率
				String en_publish_price = val_bond_info_arr[9]; //发行价
				
				//根据债券价格[净价]计算债券行权收益率（统计日期，债券代码[内码]，单券债券委托价格[净价]，计算到指定日期的收益率[默认0]，计算到到期还是到行权日[1-到期;2-行权日]）
				String sql_sf_get_bond_yield_exercise = "select round(trade.sf_get_bankbond_lastinterest('"
				+processDate+"','"+vc_inter_code+"','"+c_market_no+"','"+c_pay_interest_type+"','"+c_interest_type+"','"+l_begincal_date+"','"+
				l_end_date+"','"+en_pay_inteval+"','"+en_curr_face_price+"','"+en_year_rate+"','"+en_publish_price+"'),8) bond_yield from dual";
			    //（统计日期，债券代码[内码]，单券债券委托价格[净价]，计算到指定日期的收益率[默认0]，计算到到期还是到行权日[1-到期;2-行权日]）
				String sql_sf_get_bond_yield_expire = 
						"select 100*round(trade.sf_get_bond_yield("+endDate+",'"+vc_inter_code+"',"+netPrice+",0,'"+1+"'),6) bond_yield from dual";
				
				String val_yield_exercise = JDBCUtil.getValueBySql(conn, sql_sf_get_bond_yield_exercise);
				String [] exercises = val_yield_exercise.split(",");
				String bond_interest = exercises[0];
				
				
				String val_yield_expire = JDBCUtil.getValueBySql(conn, sql_sf_get_bond_yield_expire);
				String [] expires = val_yield_expire.split(",");
				String bond_interest_expire = expires[0];
				
				//若传入净价，优先使用净价计算全价、收益率
				if(StringUtils.isNotBlank(netPrice)){
					netPrice = netPrice.replaceAll(",", "").trim();
					//计算全价，全价=净价+百元债券利息
					fullPrice = String.valueOf(Double.parseDouble(netPrice.trim()) + Double.parseDouble(bond_interest));
					//返回结果：净价，全价，到期收益率，收益率类型，交易场所，清算速度，行权收益率
					result = netPrice.trim() + "@" + fullPrice  +"@"+val_yield_exercise + "@" +bond_interest_expire + "@" +bond_interest;
					//若净价、全价为空，存在收益率，则使用收益率计算净价、全价
				}else if(StringUtils.isNotBlank(fullPrice)){
					fullPrice = fullPrice.replaceAll(",", "").trim();
					//计算净价，净价=全价-百元债券利息
					double dNetPrice = Double.parseDouble(fullPrice.trim()) - Double.parseDouble(bond_interest);
					//返回结果：净价，全价，到期收益率，收益率类型，交易场所，清算速度，行权收益率
					result = dNetPrice + "@" + fullPrice  +"@"+val_yield_exercise + "@" + bond_interest_expire + "@" +bond_interest;
				}
			}
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.releaseResource(conn, null, null);
		}
		return result;
	}
	
	@Bizlet("根据日期查询债券当期应计利息")
	/**
	 * 根据日期查询债券当期应计利息
	 * @param processDate	付息日
	 * @param marketNo		市场代码
	 * @param reportCode	债券代码
	 * @param interCode		债券内码
	 * @return	当期应计利息
	 */
	public static Double getInterestByDate(String processDate,String marketNo,String reportCode,String interCode){
		Double result = 0.0;
		if(StringUtils.isBlank(processDate) || StringUtils.isBlank(marketNo) || StringUtils.isBlank(reportCode) || StringUtils.isBlank(interCode)){
			return result;
		}
		Connection conn = null;
		try {
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());//获取O32系统数据库连接
			String sql_bond_info = "select a.vc_inter_code,a.c_market_no,a.c_pay_interest_type,a.c_interest_type,a.l_begincal_date,a.l_end_date,"+
			"a.en_pay_inteval,a.en_curr_face_price,a.en_year_rate,a.en_publish_price from trade.tbondproperty a, trade.tstockinfo b where a.c_market_no = '"+marketNo+"'"+
             "and b.vc_report_code = '"+reportCode+"' and a.c_market_no = b.c_market_no and a.vc_inter_code = '"+interCode+"'";
			String val_bond_info = JDBCUtil.getRecordValueBySql(conn, sql_bond_info);
			if(StringUtils.isNotEmpty(val_bond_info)){
				String[] val_bond_info_arr = val_bond_info.split(",");
				String vc_inter_code = val_bond_info_arr[0];  //债券内码
				String c_market_no = val_bond_info_arr[1];  //市场
				String c_pay_interest_type = val_bond_info_arr[2];  //付息类型
				String c_interest_type = val_bond_info_arr[3];  //利率类型
				String l_begincal_date = val_bond_info_arr[4];  //起息日期
				String l_end_date = val_bond_info_arr[5];  //结束日期
				String en_pay_inteval = val_bond_info_arr[6];  //付息次数
				String en_curr_face_price = val_bond_info_arr[7];  //面值
				String en_year_rate = "";
				if(!StringUtils.isBlank(val_bond_info_arr[8])){
					en_year_rate = String.valueOf(Double.parseDouble(val_bond_info_arr[8]));  //年利率
				}
				String en_publish_price = val_bond_info_arr[9]; //发行价
				String sql_sf_bankbond_lastinterest = "select round(trade.sf_get_bankbond_lastinterest('"
				+processDate+"','"+vc_inter_code+"','"+c_market_no+"','"+c_pay_interest_type+"','"+c_interest_type+"','"+l_begincal_date+"','"+
				l_end_date+"','"+en_pay_inteval+"','"+en_curr_face_price+"','"+en_year_rate+"','"+en_publish_price+"','1'),8) bond_yield from dual";
				String val_bankbond_lastinterest = JDBCUtil.getValueBySql(conn, sql_sf_bankbond_lastinterest);
				if(StringUtils.isBlank(val_bankbond_lastinterest)){
					return 0.0;
				}
				String [] lastinterest = val_bankbond_lastinterest.split(",");
				if(!StringUtils.isBlank(lastinterest[0])){
					result = Double.parseDouble(lastinterest[0]);  //年利率
				}
			}
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.releaseResource(conn, null, null);
		}
		return result;
	}
	
	@Bizlet("查询一个时间段内某债券的还本金额")
	/**
	 * 查询一个时间段内某债券的还本总额
	 * @param startDate		起始日期
	 * @param endDate		结束日期
	 * @param interCode		债券内码
	 * @return	还本金额
	 */
	public static String getPaymentByDateToDate(String startDate,String endDate,String interCode){
		String result = "";
		if(StringUtils.isBlank(startDate)|| StringUtils.isBlank(endDate)|| StringUtils.isBlank(interCode)){
			return result;
		}
		Connection conn = null;
		try {
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());//获取O32系统数据库连接
				String sql_getPaymentByDateToDate = "select sum（a.en_pay_ratio * 100) from trade.tbondpayratio a where a.vc_inter_code = '" + interCode
						+ "' and a.l_pay_date > '" + startDate
						+ "' and a.l_pay_date <= '" + endDate + "'";
				String val_payment = JDBCUtil.getValueBySql(conn, sql_getPaymentByDateToDate);
				if(StringUtils.isEmpty(val_payment)){
					return "";
				}
				String [] payment = val_payment.split(",");
				result = payment[0];
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.releaseResource(conn, null, null);
		}
		return result;
	}
	
	/**
	 * 通过债券代码、交易市场编号到O32系统查找投资的债券信息
	 * @param vcReportCode 债券代码
	 * @param cMarketNo 市场编号
	 * @return
	 * @author wuyanfei
	 */
	@Bizlet("")
	public static String getInvestProductsByReportCodeAndMarketNo(String vcReportCode, String cMarketNo){
		String result = "";
		StringBuffer sb = new StringBuffer();
		Connection conn = null;
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			
			//拼接SQL语句，投资产品信息（债券代码,债券名称,交易市场编号,证券内码）
			sb.append("select distinct t.vc_report_code || ',' || t.vc_stock_name || ',' || ")
			  .append("                t.c_market_no || ',' || t.vc_inter_code investProductInfo ")
			  .append("  from trade.TSTOCKINFO t ")
			  .append(" where 1 = 1 ")
			  .append("   and t.vc_report_code = '" + vcReportCode + "' ")
			  .append("   and t.c_market_no = '" + cMarketNo + "' ")
			  .append("   and rownum = 1 ");
			
			result = JDBCUtil.getValueBySql(conn, sb.toString());
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			sb.setLength(0);
			sb = null;
			JDBCUtil.releaseResource(conn, null, null);
		}
		return result;
	}
	
	/**
	 * 录单回退功能数据组装
	 * @param data	指令信息
	 * @return	resultObject 组装后的数据
	 * @author tongwei
	 * 
	 */
	@Bizlet("录单回退功能数据组装")
	public List<DataObject> assembleQueryData(DataObject[] data){
		List<DataObject> resultObject = new ArrayList<DataObject>();
		String lProcessinstId = "";
		String enterCheck = "enterCheck";
		String lResultId = "";
		if(data.length >0){
			for(int i=0; i<data.length; i++){
				DataObject obj = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
				lProcessinstId = data[i].getString("lProcessinstId");
				lResultId = data[i].getString("lResultId");
				obj.setString("lProcessinstId", lProcessinstId);
				obj.setString("enterCheck", enterCheck);
				obj.setString("lInstructId", lResultId);
				resultObject.add(obj);
			}
		}else{
			return resultObject;
		}
		return resultObject;
	}
	
	/**
	 *	根据页面传的委托方向和业务类别组合编号 分别查出对应的委托方向，业务类别
	 * @param str	业务类别
	 * @return
	 */
	@Bizlet()
	public static DataObject stringToDataObject(String str){
		//先把str转换成list， 取当前list第i个查询当前委托方向和业务代码，拼接到value中
		DataObject resultObj = null;
		String bizType = "";
		String entrustDirection = "";
		if(str != null){
			resultObj = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
			String[] arr = str.split(",");
		    DataObject bizDirectionInfo = null;
		    try {

			    List<String> list = Arrays.asList(arr);
			    for(int i=0; i<list.size(); i++){
			    	DataObject param = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
					param.set("bizDirectionNo", list.get(i));
					// 查询业务类别和委托方向关系映射表信息
					Object[] bizDirections = DatabaseExt.queryByNamedSql(JDBCUtil.DATA_SOURCE_DEFAULT, "com.cjhxfund.ats.sm.comm.instructionManage.getBizDirectionInfoByBizDirectionNo", param);
			    	if(bizDirections.length >0){
						bizDirectionInfo = (DataObject) bizDirections[0];
					}
					entrustDirection+= bizDirectionInfo.getString("vcDirectionNo") +",";
					bizType+= bizDirectionInfo.getString("vcBiztypeNo") +",";
					
			    }
			    // 去掉最后一个','号
				entrustDirection = entrustDirection.substring(0, entrustDirection.length() - 1);
				bizType = bizType.substring(0, bizType.length() - 1);
				resultObj.set("entrustDirection", entrustDirection);
				resultObj.set("bizType", bizType);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return resultObj;
	} 

	/**
	 * 撤销成功后返回信息分析
	 * @param vcProductCode 产品代码，lUserId 用户ID， isCancelO32 是已否同步撤销O32， lFixValidStatus fix调用状态 ， approveProIns 修改审核中流程实例ID，vcRejectReason 撤销原因
	 * @return 撤销结果
	 */
	@Bizlet()
	public static String revocationMsgResolve(String vcProductCode, String lUserId, String isCancelO32, String lFixValidStatus, long approveProIns, String vcRejectReason, String vcProcessStatus){
		DataObject resultObject = DataObjectUtil.createDataObject("com.cjhxfund.ats.sm.comm.atsSmData.TAtsInquiryResultInstruct");
		int result = 0;
		if(approveProIns!=0){//获取审批中指令
			CriteriaType criteria = CriteriaType.FACTORY.create();
			criteria.set_entity("com.cjhxfund.ats.sm.comm.atsSmData.TAtsInquiryResultInstruct");
			criteria.set("_expr[1]/lProcessinstId", approveProIns);
			criteria.set("_expr[1]/_op", "=");
			result = DatabaseUtil.expandEntityByCriteriaEntity("default", criteria, resultObject);
		}
		if(result==1){
			vcProcessStatus = resultObject.getString("vcProcessStatus");
		}
		String checkInvestManager = ConditionRule.checkInvestManager(lUserId, vcProductCode);
		String resMsg = "撤销成功!";
		if(vcRejectReason!=null && !"".equals(vcRejectReason)){
			vcRejectReason = "</br>撤销原因："+vcRejectReason;
		}else{
			vcRejectReason = "";
		}
		if(isCancelO32!=null && !"".equals(isCancelO32)){
			if("6".equals(vcProcessStatus) || "7".equals(vcProcessStatus)){
				resMsg = "撤销成功并同步撤销O32指令！【紧急】请提醒相关交易员"+vcRejectReason;
			}else{
				resMsg = "撤销成功并同步撤销O32指令！【警示】请提醒相关交易员"+vcRejectReason;
			}
		}else{
			if("true".equals(checkInvestManager)){//投资经理撤单
				//当前指令未通过FIX且指令流程已过投资经理确认
				if("1".equals(lFixValidStatus)){//当前指令流程已过投资经理，O32未撤销，提示主动去撤销O32
					if("6".equals(vcProcessStatus) || "7".equals(vcProcessStatus)){
						resMsg = "本地撤销成功但O32未同步撤销，如已在O32录入该指令，请至O32撤销相应指令！【紧急】并提醒相关交易员"+vcRejectReason;
					}else{
						resMsg = "本地撤销成功但O32未同步撤销，如已在O32录入该指令，请至O32撤销相应指令！【警示】并提醒相关交易员"+vcRejectReason;
					}
				}else{
					if(result==1 && "1".equals(resultObject.getString("lFixValidStatus"))){//审核中指令已过投资经理
						if("6".equals(vcProcessStatus) || "7".equals(vcProcessStatus)){
							resMsg = "本地撤销成功但O32未同步撤销，如已在O32录入该指令，请至O32撤销相应指令！【紧急】请提醒相关交易员"+vcRejectReason;
						}else{
							resMsg = "本地撤销成功但O32未同步撤销，如已在O32录入该指令，请至O32撤销相应指令！【警示】并提醒相关交易员"+vcRejectReason;
						}
					}else{
						resMsg = "撤销成功，此单已撤销！"+vcRejectReason;
					}
				}
			}else{//投顾撤单
				if("1".equals(lFixValidStatus)){
					if("6".equals(vcProcessStatus) || "7".equals(vcProcessStatus)){
						resMsg = "本地撤销成功但O32未同步撤销，如已在O32录入该指令，请通知相关投资经理至O32撤销相应指令！【紧急】并提醒相关交易员"+vcRejectReason;
					}else{
						resMsg = "本地撤销成功但O32未同步撤销，如已在O32录入该指令，请通知相关投资经理至O32撤销相应指令！【警示】并提醒相关交易员"+vcRejectReason;
					}
				}else{
					if(result==1 && "1".equals(resultObject.getString("lFixValidStatus"))){
						if("6".equals(vcProcessStatus) || "7".equals(vcProcessStatus)){
							resMsg = "本地撤销成功但O32未同步撤销，如已在O32录入该指令，请通知相关投资经理至O32撤销相应指令！【紧急】并提醒相关交易员"+vcRejectReason;
						}else{
							resMsg = "本地撤销成功但O32未同步撤销，如已在O32录入该指令，请通知相关投资经理至O32撤销相应指令！【警示】并提醒相关交易员"+vcRejectReason;
						}
					}else{
						resMsg = "撤销成功，此单已撤销！"+vcRejectReason;
					}
				}
			}
		}
		return resMsg;
	}
	
	/**
	 * 撤销和退回返回信息处理
	 * @param paramObj 入参条件
	 * @return resultObj(rtnMsg,rtnCode)
	 */
	@Bizlet()
	public static DataObject revocationAndBackRtnmsg(DataObject paramObj){
		DataObject resultObj = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
		// 查询投资经理权限条件
		DataObject query02HandleParam = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
		// 查询投顾权限条件
		DataObject query07HandleParam = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
		IMUODataContext muoContext = DataContextManager.current().getMUODataContext();
		String userId = (String) muoContext.getAttributes().get("EXTEND_USER_ID");
		
		if(paramObj != null){
			// 1.O32发送状态 lFixValidStatus
			// 2.操作类型 operateType（1撤销）
			// 3.操作结果 rtnCode
			// 4.退回原因 vcRejectReason
			String operateType = paramObj.getString("operateType");
			String vcProductCode = paramObj.getString("vcProductCode");
			String lFixValidStatus = paramObj.getString("lFixValidStatus");
			String vcRejectReason = paramObj.getString("vcRejectReason");
			
			// 审批通过
			if("1".equals(operateType)){
				// 投资经理权限
				query02HandleParam.setString("realType", "02");
				query02HandleParam.setString("vcProductCode", vcProductCode);
				query02HandleParam.setString("userId", userId);
				Object[] productHandleUsers02 = DatabaseExt.queryByNamedSql("default",
						"com.cjhxfund.ats.sm.comm.instructionManage.getProductHandleByUseridAndRealTypeAndProductCode",query02HandleParam);
				// 投顾权限
				query07HandleParam.setString("realType", "07");
				query07HandleParam.setString("vcProductCode", vcProductCode);
				query07HandleParam.setString("userId", userId);
				Object[] productHandleUsers07 = DatabaseExt.queryByNamedSql("default",
						"com.cjhxfund.ats.sm.comm.instructionManage.getProductHandleByUseridAndRealTypeAndProductCode",query07HandleParam);
				// rtnCode处理结果(1撤销成功，2操作失败（O32撤销失败），3请求超时，4操作失败)
				String rtnCode = paramObj.getString("rtnCode");
				// 指令已下达至O32
				if(lFixValidStatus !=null || lFixValidStatus !=""){
					if("1".equals(lFixValidStatus)){
						if("1".equals(rtnCode)){
							if(productHandleUsers02.length>0){
								resultObj.set("rtnMsg", "操作成功"+"</br>"+"此单已撤销"+"</br>"+"请至O32撤销该指令！"+"</br>"+"撤销原因："+vcRejectReason);
							}else if(productHandleUsers07.length>0){
								resultObj.set("rtnMsg", "操作成功"+"此单已撤销"+"</br>"+"请通知投资经理至O32撤销该指令！"+"</br>"+"撤销原因："+vcRejectReason);
							}
						}else if("2".equals(rtnCode)){
							resultObj.set("rtnMsg", "操作失败"+"</br>"+"撤销原因："+vcRejectReason);
						}else if("3".equals(rtnCode)){
							resultObj.set("rtnMsg", "请求超时，请再试一次。如已超时多次，请联系管理员！");
						}else if("4".equals(rtnCode)){
							resultObj.set("rtnMsg", "操作失败！"+"</br>"+"请通知系统管理员！");
						}else{
							resultObj.set("rtnMsg", "系统异常");
						}
					}
				}
			}
		}
		return resultObj;
	}
	
	/**
	 * 撤销和退回返回信息处理
	 * @param paramObj 入参条件
	 * @return resultObj(rtnMsg,rtnCode)
	 */
	@Bizlet()
	public DataObject convertRiskMsgs(DataObject[] riskMsgs, Boolean isAgainstRisk){
		DataObject[] convertMsgs = riskMsgs;
		DataObject resultObj = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
		if(isAgainstRisk==null){
			isAgainstRisk=false;
		}
		resultObj.setBoolean("isAgainstRisk", isAgainstRisk);
		resultObj.set("resultDetail", convertMsgs);
		return resultObj;
	}
	
	/**
	 * 检测O32中是否已录入类似指令
	 * @param instructInfo 指令基本信息   bonds 质押券信息
	 * @return 返回结果：true-O32已录入类似指令，  false-O32没有类似指令
	 */
	@Bizlet()
	public Boolean checkO32IsExist(DataObject instructInfo, DataObject[] bonds){
		String fixEnable = InstructionManagerUtil.fixEnable(instructInfo);//1-使用FIX下单  0-不通过fix下单
		//
		Boolean checkAssert = false;
		if((instructInfo.getString("vcOrigordId")==null || "".equals(instructInfo.getString("vcOrigordId"))) 
				&& (instructInfo.getString("cFixEnable")==null || "".equals(instructInfo.getString("cFixEnable"))) 
				&& "1".equals(fixEnable)){//确保指对于O32为新增指令并且通过FIX下单       
			DataObject instructParam = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
			
			instructParam.setString("vcCombiNo", instructInfo.getString("vcCombiCode"));
			instructParam.setString("cBusinClass", instructInfo.getString("businClass"));
			instructParam.setString("cEntrustDirection", instructInfo.getString("vcEntrustDirection"));
			instructParam.setString("lBeginDate", instructInfo.getString("lTradeDate"));
			if("3".equals(instructInfo.getString("vcEntrustDirection")) || "4".equals(instructInfo.getString("vcEntrustDirection"))){
				instructParam.setString("vcReportCode", instructInfo.getString("vcStockCode"));
			}else{
				instructParam.setString("lHgDays", instructInfo.getString("lRepoDays"));
			}
			instructParam.setString("lAmount",  String.valueOf(StrUtil.delThousandthEmptyTo0(instructInfo.getString("enFaceAmount"))*10000/100));
			instructParam.setString("enPrice1", instructInfo.getString("enPrice"));
			instructParam.setString("lTradeRivalNo", instructInfo.getString("vcCounterpartyId"));
			int resultCount = 0;
			Object[] checkResult = DatabaseExt.queryByNamedSql(CacheUtil.getO32CacheDataSourceName(),
					"com.cjhxfund.ats.sm.comm.instructionManage.checkInstructO32Exist",instructParam);
			if(checkResult.length>0){
				resultCount = (Integer) checkResult[0];
			}
			if(resultCount>0){
				checkAssert = true;
			}
		}
		return checkAssert;
	}

	public static void main(String[] args) {
		// TODO 自动生成的方法存根
		DataObject testObj = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
		testObj.setString("operateType", "1");
		testObj.setString("lFixValidStatus", "2");
		testObj.setString("vcProductCode", "CJSSX9");
		testObj.setString("vcRejectReason", "测试");
		testObj.setString("rtnCode", "1");
		revocationAndBackRtnmsg(testObj);
	}
}
