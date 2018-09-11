package com.cjhxfund.jy.ProductProcess;

import java.io.File;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.cjhxfund.commonUtil.CacheUtil;
import com.cjhxfund.commonUtil.DateUtil;
import com.cjhxfund.commonUtil.JDBCUtil;
import com.cjhxfund.commonUtil.StrUtil;
import com.cjhxfund.commonUtil.externalService.HttpClientService;
import com.eos.engine.component.ILogicComponent;
import com.eos.foundation.data.DataObjectUtil;
import com.eos.foundation.eoscommon.LogUtil;
import com.eos.system.annotation.Bizlet;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.primeton.ext.engine.component.LogicComponentFactory;
import com.primeton.workflow.commons.utility.StringUtil;

import commonj.sdo.DataObject;

/**
 * 综合信息查询处理公共类
 * @author huangmizhi
 * @date 2016-03-03 09:42:20
 */
@Bizlet("")
public class ZhxxcxUtil {

	/** 资金头寸查询SQL语句 */
	public static String SQL_ZJTC = "";
	/** 资金头寸查询SQL语句--历史查询 */
	public static String SQL_ZJTC_HIS = "";
	/** 质押券查询SQL语句 */
	public static String SQL_ZYQ = "";
	/** 质押券查询SQL语句--历史查询 */
	public static String SQL_ZYQ_HIS = "";
	/** 标准券查询SQL语句 */
	public static String SQL_BZQ = "";
	/** 标准券查询SQL语句--历史查询 */
	public static String SQL_BZQ_HIS = "";
	/** 交易所回购查询SQL语句 */
	public static String SQL_JYSHG = "";
	/** 交易所回购查询SQL语句--历史查询 */
	public static String SQL_JYSHG_HIS = "";
	/** 银行间回购查询SQL语句 */
	public static String SQL_YHJHG = "";
	/** 银行间回购导出查询SQL语句 */
	public static String SQL_YHJHG_DC = "";
	/** 银行间回购导出查询SQL语句_历史 */
	public static String SQL_YHJHG_HIS_DC = "";
	
	/** 银行间回购查询SQL语句--历史查询 */
	public static String SQL_YHJHG_HIS = "";
	/** 银行间回购-银行间回购明细表查询SQL语句 */
	public static String SQL_YHJHG_DETAIL = "";
	/** 组合持仓查询SQL语句 */
	public static String SQL_ZHCC = "";
	/** 债券协议回购查询SQL语句 */
	public static String SQL_BONDREPURCHASE = "";
	/** 债券协议回购查询历史SQL语句 */
	public static String SQL_BONDREPURCHASE_HIS = "";
	/** 场外执行成交查询SQL语句 */
	public static String SQL_OTCTRADE = "";
	/** 场外执行成交查询历史SQL语句 */
	public static String SQL_OTCTRADE_HIS = "";
	/** 产品交易流水-交易所查询SQL语句 */
	public static String SQL_CPJYS = "";
	/** 产品交易流水-交易所查询SQL语句_历史查询 */
	public static String SQL_CPJYS_HIS = "";
	/** 产品交易流水-银行间查询SQL语句 */
	public static String SQL_CPYHJ = "";
	/** 产品交易流水-银行间查询SQL语句_历史查询 */
	public static String SQL_CPYHJ_HIS = "";
	/** 产品净值查询SQL语句 */
	public static String SQL_CPJZ = "";
	/** 组合持仓查询SQL语句--历史查询 */
	public static String SQL_ZHCC_HIS = "";
	/** O32头寸检查表1查询SQL语句 */
	public static String SQL_O32TCJC1 = "";
	/** O32头寸检查表1查询SQL语句-新 */
	public static String SQL_O32TCJC1_NEW = "";
	/** 恒生估值系统估值表查询SQL语句 */
	public static String SQL_HSFAGZB = "";
	/** 科目余额表查询sql语句 */
	public static String SQL_HSKMYEB = "";
	/** 自动化头寸表查询SQL语句 */
	public static String SQL_ZDHTCB = "";
	/** 自动化头寸表按条件查询code SQL语句 */
	public static String SQL_ZDHTCB_CODE = "";
	/** 自动化头寸表按条件查询code SQL语句 (新)*/
	public static String SQL_ZDHTCB_CODE_NEW = "";
	/**自动化头寸表按产品查询*/
	public static String SQL_ZDHTCB_PROD = "";
	/**自动化头寸表按产品查询*/
	public static String SQL_ZDHTCB_PROD_NEW = "";
	/** 自动化头寸表-自动化头寸表明细表查询SQL语句 */
	public static String SQL_ZDHTCB_DETAIL = "";
	/** 自动化头寸表查询SQL语句-新 */
	public static String SQL_ZDHTCB_NEW = "";
	/** 自动化头寸表-自动化头寸表明细表查询SQL语句-新 */
	public static String SQL_ZDHTCB_DETAIL_NEW = "";
	/** 自动化头寸表-回款未交收资金明细表查询SQL语句-新 */
	public static String SQL_ZDHTCB_DETAIL2_NEW = "";
	/** 组合持仓(产品持仓明细)扩展信息查询SQL语句 */
	public static String SQL_ZHCC_EXTEND = "";
	/** 万得BBQ行情展示查询SQL语句 */
	public static String SQL_ZHCC_WIND_BBQ_HQ = "";
	/** 结算指令下载查询sql语句 */
	public static String SQL_JSZLXZ = "";
	/** 结算合同下载查询sql语句 */
	public static String SQL_JSHTXZ = "";
	/** 分销数据列表查询sql语句 */
	public static String SQL_FXSJLB = "";
	/** 买断式回购列表查询sql语句 */
	public static String SQL_MDSHGLB = "";
	/** 现券交易列表查询sql语句 */
	public static String SQL_XQJYLB = "";
	/** 质押式回购列表查询sql语句 */
	public static String SQL_ZYSHGLB = "";
	/** 全额结算指令列表查询sql语句 */
	public static String SQL_QEJSZL = "";
	/** 备付金查询sql语句 */
	public static String SQL_BFJ = "";
	/** 保证金查询sql语句 */
	public static String SQL_BZJ = "";
	/** 保证金明细查询sql语句 */
	public static String SQL_BZJ_DETAIL = "";
	/** 定期存款到期浏览表查询sql语句 */
	public static String SQL_TIME_DEPOSITS = "";

	/** 当前classpath的绝对URI路径 */
	public static String CLASS_PATH = "";
	/** 综合信息查询SQL文件存放路径 */
	public static String ZHXXCX_FILE_PATH = "";

	/** 默认起始日期：19000101 */
	public static final String DEFAULT_DATE_BEGIN = "19000101";
	/** 默认截至日期：29991231 */
	public static final String DEFAULT_DATE_END = "29991231";
	/** 起始日期参数字符串 */
	public static final String PARAM_BUSI_DATE_BEGIN = "PARAM_BUSI_DATE_BEGIN";
	/** 截至日期参数字符串 */
	public static final String PARAM_BUSI_DATE_END = "PARAM_BUSI_DATE_END";
	/** 起始日期参数02字符串 */
	public static final String PARAM_02_BUSI_DATE_BEGIN = "PARAM_02_BUSI_DATE_BEGIN";
	/** 截至日期参数02字符串 */
	public static final String PARAM_02_BUSI_DATE_END = "PARAM_02_BUSI_DATE_END";
	/** 当天参数字符串 */
	public static final String PARAM_BUSI_DATE_TODAY = "PARAM_BUSI_DATE_TODAY";
	/** 银行间回购流水号字符串 */
	public static final String PARAM_L_SERIAL_NO = "PARAM_L_SERIAL_NO";
	/** 轮询结束时间-执行O32存储过程 */
	private static Date endTime_callO32Procedure = null;
	/** 轮询结束时间-执行O32存储过程-新 */
	private static Date endTime_callO32ProcedureNew = null;
	/**回款未交收资金*/
	private static String HKWJSZJ="回款未交收资金";
	static {
		String os = System.getProperty("os.name");
		if(StringUtils.isNotEmpty(os) && os.toLowerCase().startsWith("win")){
			CLASS_PATH = ZhxxcxUtil.class.getResource("/").getPath().substring(1);
		}else{
			CLASS_PATH = ZhxxcxUtil.class.getResource("/").getPath();
		}
		ZHXXCX_FILE_PATH = CLASS_PATH + "confFile" + File.separator + "sqlFile" + File.separator + "zhxxcx" + File.separator;
	}


	/**
	 * 根据系统参数返回接口url
	 * @param action
	 * @return url
	 */
	public static String getUrl(String action){
		DataObject cacheparam = (DataObject) com.eos.foundation.eoscommon.CacheUtil.getValue("ReloadParamConf1","ATS_CASHFLOW_IP");
		String CashflowUrl = "";
		if(cacheparam !=null){
			String paramValue = cacheparam.getString("paramValue");
			if(("URL_ZJTC_YHJWJSJE").equals(action)){
				CashflowUrl = paramValue + "/pos/CashEnableDtl/getBankUnStlBal.action";
			}else if(("URL_ZJTC_SGTHGT").equals(action)){
				CashflowUrl = paramValue + "/pos/CashEnable/getCashEnableGgt.action";
			}
		}
		return CashflowUrl;
	}

	/**
	 * 获取当前日期，当前日期若不是交易日则获取下一交易日
	 * @param
	 * @return businDay 交易日
	 * @author jiangkanqian
	 */
	public static String getNextTradeDate(){
		//默认当天是交易日
		String businDay = DateUtil.currentDateString(DateUtil.YMD_NUMBER);
		//判断今天是否为交易日
		boolean isTradeDay = DateUtil.isTradeDay(null, DateUtil.currentDateString(DateUtil.YMD_NUMBER), null);
		//若当天不是交易日（周末或节假日），则业务日期获取下个交易日
		if(!isTradeDay){
			businDay = DateUtil.getCalculateTradeDay(null, DateUtil.currentDateString(DateUtil.YMD_NUMBER), null, 1);
		}
		return businDay;
	}

	/**
	 * 根据SQL文件名称获取SQL文件内容字符串
	 * @param sqlFile SQL文件名称
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static String getFileSql(String sqlFile){
		return StrUtil.findContentStr(ZHXXCX_FILE_PATH+sqlFile, null);
	}

	/**
	 * 执行O32计算T+0、T+1头寸指标值等存储过程
	 * @param pIntervalTime 轮询间隔时间，为空或格式错误时取默认5分钟
	 * @param pEndTime 轮询结束时间，为空或格式错误时取默认17:00
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static boolean callO32Procedure(String pIntervalTime, String pEndTime){
		System.out.println(DateUtil.currentDateTimeString()+"  [call o32_cj.to32_position()]调用O32存储过程开始...");
		//是否调用成功
		boolean isSuccess = false;
		Connection conn = null;
		CallableStatement cStmt = null;
		boolean execute = true;
		try {
			//获取轮询间隔时间，为空或格式错误时取默认5分钟
			int intervalTime = 5;
			if(StringUtils.isNotBlank(pIntervalTime)){
				try {
					intervalTime = Integer.valueOf(pIntervalTime.trim());
				} catch (NumberFormatException e) {
					LogUtil.logError("ZhxxcxUtil.callO32Procedure fail: 轮询间隔时间格式错误，取默认5分钟！", e, new Object[]{});
				}
			}else{
				LogUtil.logInfo("轮询间隔时间为空，取默认5分钟！", null, new Object[]{});
			}

			//获取轮询结束时间，为空或格式错误时取默认17:00
			String date = DateUtil.currentDateDefaultString();
			endTime_callO32Procedure = DateUtil.parse(date+" 17:00:00", DateUtil.YMDHMS_PATTERN);
			if(StringUtils.isNotBlank(pEndTime)){
				try {
					endTime_callO32Procedure = DateUtil.parse(date+" "+pEndTime.trim()+":00", DateUtil.YMDHMS_PATTERN);
				} catch (Exception e) {
					LogUtil.logError("ZhxxcxUtil.callO32Procedure fail: 轮询结束时间格式错误，取默认17:00！", e, new Object[]{});
				}
			}else{
				LogUtil.logInfo("轮询结束时间为空，取默认17:00！", null, new Object[]{});
			}


			String procedure = "{call o32_cj.to32_position()}";
			while(execute){
				conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getProdO32CacheDataSourceName());//重新获取连接
				try {
					//执行的O32存储过程
					cStmt = conn.prepareCall(procedure);
					cStmt.execute();
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					JDBCUtil.releaseResource(conn, cStmt, null);
				}
				Thread.sleep(intervalTime * 60000);//暂停设定的轮询间隔时间
				if(DateUtil.currentDate().after(endTime_callO32Procedure)){//若当前系统时间大于轮询结束时间，则跳出循环
					execute = false;
				}
			}
			//设置为调用成功
			isSuccess = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.releaseResource(conn, cStmt, null);
		}
		System.out.println(DateUtil.currentDateTimeString()+"  [call o32_cj.to32_position()]调用O32存储过程结束!!!");
		return isSuccess;
	}

	/**
	 * 执行O32计算T+0、T+1头寸指标值等存储过程-新（连接本地O32备库4.56）
	 * @param pIntervalTime 轮询间隔时间，为空或格式错误时取默认3分钟
	 * @param pEndTime 轮询结束时间，为空或格式错误时取默认17:00
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static boolean callO32ProcedureNew(String pIntervalTime, String pEndTime){
		System.out.println(DateUtil.currentDateTimeString()+"  [call o32_cj.to32_position()][4.56]调用O32存储过程开始...");
		//是否调用成功
		boolean isSuccess = false;
		Connection conn = null;
		CallableStatement cStmt = null;
		boolean execute = true;
		try {
			//获取轮询间隔时间，为空或格式错误时取默认3分钟
			int intervalTime = 3;
			if(StringUtils.isNotBlank(pIntervalTime)){
				try {
					intervalTime = Integer.valueOf(pIntervalTime.trim());
				} catch (NumberFormatException e) {
					LogUtil.logError("ZhxxcxUtil.callO32ProcedureNew fail: 轮询间隔时间格式错误，取默认3分钟！", e, new Object[]{});
				}
			}else{
				LogUtil.logInfo("轮询间隔时间为空，取默认3分钟！", null, new Object[]{});
			}

			//获取轮询结束时间，为空或格式错误时取默认17:00
			String date = DateUtil.currentDateDefaultString();
			endTime_callO32ProcedureNew = DateUtil.parse(date+" 17:00:00", DateUtil.YMDHMS_PATTERN);
			if(StringUtils.isNotBlank(pEndTime)){
				try {
					endTime_callO32ProcedureNew = DateUtil.parse(date+" "+pEndTime.trim()+":00", DateUtil.YMDHMS_PATTERN);
				} catch (Exception e) {
					LogUtil.logError("ZhxxcxUtil.callO32ProcedureNew fail: 轮询结束时间格式错误，取默认17:00！", e, new Object[]{});
				}
			}else{
				LogUtil.logInfo("轮询结束时间为空，取默认17:00！", null, new Object[]{});
			}


			String procedure = "{call o32_cj.to32_position()}";
			while(execute){
				conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getBakO32CacheDataSourceName());//重新获取连接
				try {
					//执行的O32存储过程
					cStmt = conn.prepareCall(procedure);
					cStmt.execute();
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					JDBCUtil.releaseResource(conn, cStmt, null);
				}
				Thread.sleep(intervalTime * 60000);//暂停设定的轮询间隔时间
				if(DateUtil.currentDate().after(endTime_callO32ProcedureNew)){//若当前系统时间大于轮询结束时间，则跳出循环
					execute = false;
				}
			}
			//设置为调用成功
			isSuccess = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			JDBCUtil.releaseResource(conn, cStmt, null);
		}
		System.out.println(DateUtil.currentDateTimeString()+"  [call o32_cj.to32_position()][4.56]调用O32存储过程结束!!!");
		return isSuccess;
	}

	/**
	 * 综合信息查询-产品信息查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryProducts(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_DEFAULT);

			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String searchKey = paramObject.getString("searchKey");//搜索关键字

			//拼接SQL语句
			sb.append("select distinct t.vc_product_code, ")//产品代码
			  .append("                t.vc_product_name, ")//产品名称
			  .append("                t.vc_product_code|| '-' ||t.vc_product_name productcodename ")//产品代码+产品名称
			  .append("  from t_ats_product_info t ")
			  .append(" where 1 = 1 ");

			//新增查询条件
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append(" and t.vc_product_code in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(searchKey)){
				sb.append(" and (t.vc_product_code like '%").append(searchKey).append("%' or t.vc_product_name like '%").append(searchKey).append("%') ");
			}
			//排序SQL语句
			String sqlOrder = " order by t.vc_product_code asc";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String vc_fund_code = map.get("VC_PRODUCT_CODE");
					String vc_fund_name = map.get("VC_PRODUCT_NAME");
					String fundCodeName = map.get("PRODUCTCODENAME");

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.CombProduct");
					obj.setString("fundCode", vc_fund_code);
					obj.setString("fundName", vc_fund_name);
					obj.setString("fundCodeName", fundCodeName);

					result.add(obj);
					obj = null;
				}
			}
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
	 * 综合信息查询-资金头寸查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryZJTC(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		List<DataObject> wjsresult = new ArrayList<DataObject>();
		List<DataObject> hsgtresult = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_ZJTC)){
				SQL_ZJTC = getFileSql("zhxxcx_zjtc.sql");
			}
//			if(StringUtils.isEmpty(SQL_ZJTC_HIS)){
//				SQL_ZJTC_HIS = getFileSql("zhxxcx_zjtc_his.sql");
//			}


			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String vCAssetName = paramObject.getString("vCAssetName");//资产单元


			//拼接SQL语句
			sb.append(SQL_ZJTC);
			//新增查询条件
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and tt.VC_FUND_CODE in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vCFundCode)){
				sb.append("   and tt.VC_FUND_CODE in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(vCAssetName)){
				sb.append("   and tt.VC_ASSET_NAME like '%" + vCAssetName + "%' ");
			}
			//排序SQL语句
			String sqlOrder = " order by tt.L_DATE desc, tt.VC_FUND_CODE asc, tt.VC_ASSET_NAME asc";


			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				String [] assetIdList = new String[list.size()];
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_DATE = map.get("L_DATE");//日期
					String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					String L_FUND_ID = map.get("L_FUND_ID");//基金编号
					String L_ASSET_ID = map.get("L_ASSET_ID");//单元编号
					String VC_ASSET_NAME = map.get("VC_ASSET_NAME");//资产单元
					String T0ZLKY = StrUtil.addThousandth(map.get("T0ZLKY"), StrUtil.df1);//T+0 指令可用
					String T0JYKY = StrUtil.addThousandth(map.get("T0JYKY"), StrUtil.df1);//T+0 交易可用
					String T1ZLKY = StrUtil.addThousandth(map.get("T1ZLKY"), StrUtil.df1);//T+1 指令可用
					String T1JYKY = StrUtil.addThousandth(map.get("T1JYKY"), StrUtil.df1);//T+1交易可用
					String T0ZLKY2 = StrUtil.addThousandth(map.get("T0ZLKY2"), StrUtil.df1);//不包含T+1变化的T+0可用
					String EN_BASIC_FROZEN_BALANCE = StrUtil.addThousandth(map.get("EN_BASIC_FROZEN_BALANCE"), StrUtil.df1);//交易保证金
					String EN_FROZEN_BALANCE = StrUtil.addThousandth(map.get("EN_FROZEN_BALANCE"), StrUtil.df1);//冻结金额
					String EN_BEGIN_CASH = StrUtil.addThousandth(map.get("EN_BEGIN_CASH"), StrUtil.df1);//期初现金余额
					String EN_BEGIN_T0_ENABLE = StrUtil.addThousandth(map.get("EN_BEGIN_T0_ENABLE"), StrUtil.df1);//日初T日可用金额
					String EN_BEGIN_T1_ENABLE = StrUtil.addThousandth(map.get("EN_BEGIN_T1_ENABLE"), StrUtil.df1);//日初T+1日可用金额
					String EN_FUTURES_BALANCE = StrUtil.addThousandth(map.get("EN_FUTURES_BALANCE"), StrUtil.df1);//期货保证金余额
					String EN_BANK_UNSTL_BALANCE = StrUtil.addThousandth(map.get("EN_BANK_UNSTL_BALANCE"), StrUtil.df1);//银行间入款未交收
					assetIdList[i] = L_ASSET_ID;//组装单元id数组

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("L_DATE", L_DATE);//日期
					obj.setString("VC_FUND_CODE", VC_FUND_CODE);//基金代码
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);//基金名称
					obj.setString("L_ASSET_ID", L_ASSET_ID);//单元编号
					obj.setString("L_FUND_ID", L_FUND_ID);//基金编号
					obj.setString("VC_ASSET_NAME", VC_ASSET_NAME);//资产单元
					obj.setString("T0ZLKY", T0ZLKY);//T+0 指令可用
					obj.setString("T0JYKY", T0JYKY);//T+0 交易可用
					obj.setString("T1ZLKY", T1ZLKY);//T+1 指令可用
					obj.setString("T1JYKY", T1JYKY);//T+1交易可用
					obj.setString("T0ZLKY2", T0ZLKY2);//不包含T+1变化的T+0可用
					obj.setString("EN_BASIC_FROZEN_BALANCE", EN_BASIC_FROZEN_BALANCE);//交易保证金
					obj.setString("EN_FROZEN_BALANCE", EN_FROZEN_BALANCE);//冻结金额
					obj.setString("EN_BEGIN_CASH", EN_BEGIN_CASH);//期初现金余额
					obj.setString("EN_BEGIN_T0_ENABLE", EN_BEGIN_T0_ENABLE);//日初T日可用金额
					obj.setString("EN_BEGIN_T1_ENABLE", EN_BEGIN_T1_ENABLE);//日初T+1日可用金额
					obj.setString("EN_FUTURES_BALANCE", EN_FUTURES_BALANCE);//期货保证金余额
					obj.setString("EN_BANK_UNSTL_BALANCE", EN_BANK_UNSTL_BALANCE);//银行间入款未交收

					result.add(obj);
					obj = null;
				}
				String [] settleDateList = new String[1];
				settleDateList[0] = result.get(0).getString("L_DATE");//组装交割日期数组
				//掉用接口的查询银行间未交收，港股通和深股通
				wjsresult = queryZJTC_Wjsje(assetIdList,settleDateList,"2");
				if(wjsresult != null){
					for(int i=0; i<result.size(); i++){
						for(int w=0; w<wjsresult.size(); w++){
							if(result.get(i).getString("L_ASSET_ID").equals(wjsresult.get(w).getString("lAssetId"))){
								result.get(i).set("EN_SETTLE_BALANCE", wjsresult.get(w).get("settleBalance"));
								break;
							}
						}
					}
				}
				hsgtresult = queryZJTC_GgtAndSgt(assetIdList);
				if(hsgtresult != null){
					for(int i=0; i<result.size(); i++){
						for(int w=0; w<hsgtresult.size(); w++){
							if(result.get(i).getString("L_ASSET_ID").equals(hsgtresult.get(w).getString("lAssetId"))){
								result.get(i).set("EN_BALANCE_HGT", hsgtresult.get(w).get("cashEnableBalanceHgt"));
								result.get(i).set("EN_BALANCE_INSTR_HGT", hsgtresult.get(w).get("cashEnableBalanceInstrHgt"));
								result.get(i).set("EN_BALANCE_SGT", hsgtresult.get(w).get("cashEnableBalanceSgt"));
								result.get(i).set("EN_BALANCE_INSTR_SGT", hsgtresult.get(w).get("cashEnableBalanceInstrSgt"));
								break;
							}
						}
					}
				}
			}
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
	 * 资金头寸-沪港通和深港通可用
	 * @param assetIdList
	 * @return
	 */
	public static List<DataObject> queryZJTC_GgtAndSgt(String [] assetIdList){
		//定义返回值
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			if(assetIdList != null && assetIdList.length>0){
				//调用接口沪港通和深港通数据
				String json = null;
				JsonObject object=new JsonObject();
				Gson gson = new Gson();
				String aList = gson.toJson(assetIdList);
				object.addProperty("assetIdList", aList);
				json = object.toString();
				String ret = HttpClientService.postByJson(getUrl("URL_ZJTC_SGTHGT"), json);
				//Json转换对象
				BaseCapitalPostion baseCapitalPostion = gson.fromJson(ret, BaseCapitalPostion.class);
				//成功返回数据,则正常处理。否则输出错误信息
				if("1".equals(baseCapitalPostion.getCode())){
					List<CapitalPositionData> postionList = baseCapitalPostion.getData();
					for(int i=0;i<postionList.size();i++){
						DataObject resultData = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
						//组装数据
						resultData.setString("lFundId", postionList.get(i).getFundId().toString());//基金编号
						resultData.setString("lAssetId", postionList.get(i).getAssetId().toString());//单元编号
						resultData.set("cashEnableBalanceHgt", postionList.get(i).getCashEnableBalanceHgt()==null?0.00:postionList.get(i).getCashEnableBalanceHgt());//沪港通交易端可用金额
						resultData.set("cashEnableBalanceInstrHgt", postionList.get(i).getCashEnableBalanceInstrHgt()==null?0.00:postionList.get(i).getCashEnableBalanceInstrHgt());//沪港通投资端可用金额
						resultData.set("cashEnableBalanceSgt", postionList.get(i).getCashEnableBalanceSgt()==null?0.00:postionList.get(i).getCashEnableBalanceSgt());//深港通交易端可用金额
						resultData.set("cashEnableBalanceInstrSgt", postionList.get(i).getCashEnableBalanceInstrSgt()==null?0.00:postionList.get(i).getCashEnableBalanceInstrSgt());//深港通投资端可用金额
						result.add(resultData);
					}
				}else{
					return null;
				}
			}else{
				return null;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 资金头寸-银行间未交收金额
	 * @param assetIdList
	 * @param settleDateList
	 * @param accountType
	 * @return
	 */
	public static List<DataObject> queryZJTC_Wjsje(String [] assetIdList, String [] settleDateList, String accountType){
		//定义返回值
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			if((assetIdList != null && assetIdList.length>0) &&
					(settleDateList != null && settleDateList.length>0) && StringUtils.isNotBlank(accountType)){
				//调用接口查询银行间未交收金额
				String json = null;
				JsonObject object=new JsonObject();
				Gson gson = new Gson();
				String aList = gson.toJson(assetIdList);
				String sList = gson.toJson(settleDateList);
				object.addProperty("accountIdList", aList);
				object.addProperty("accountType", accountType);
				object.addProperty("settleDateList", sList);
				json = object.toString();
				String ret = HttpClientService.postByJson(getUrl("URL_ZJTC_YHJWJSJE"), json);
				//Json转换对象
				BaseCapitalPostion baseCapitalPostion = gson.fromJson(ret, BaseCapitalPostion.class);
				//成功返回数据,则正常处理。否则输出错误信息
				if("1".equals(baseCapitalPostion.getCode())){
					List<CapitalPositionData> postionList = baseCapitalPostion.getData();
					for(int i=0;i<postionList.size();i++){
						DataObject resultData = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
						//组装数据
						resultData.setString("lFundId", postionList.get(i).getFundId().toString());//基金编号
						resultData.setString("lAssetId", postionList.get(i).getAssetId().toString());//单元编号
						resultData.set("settleBalance", postionList.get(i).getSettleBalance()==null?0.00:postionList.get(i).getSettleBalance());//未交收金额
						result.add(resultData);
					}
				}else{
					return null;
				}
			}else{
				return null;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 综合信息查询-质押券查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryZYQ(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_ZYQ)){
				SQL_ZYQ = getFileSql("zhxxcx_zyq.sql");
			}
//			if(StringUtils.isEmpty(SQL_ZYQ_HIS)){
//				SQL_ZYQ_HIS = getFileSql("zhxxcx_zyq_his.sql");
//			}


			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vcCombiNos = paramObject.getString("vcCombiNos");//可查看的组合代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String vcCombiName = paramObject.getString("vcCombiName");//组合名称
			String vCStockholderId = paramObject.getString("vCStockholderId");//股东代码
			String vCReportCode = paramObject.getString("vCReportCode");//证券代码
			String vCStockName = paramObject.getString("vCStockName");//证券名称


			//拼接SQL语句
			sb.append(SQL_ZYQ);
			//新增查询条件
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and tt.VC_FUND_CODE in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vcCombiNos)){
				sb.append("   and tt.VC_COMBI_NO in (").append(JDBCUtil.changeInStr(vcCombiNos)).append(") ");
			}
			if(StringUtils.isNotBlank(vCFundCode)){
				sb.append("   and tt.VC_FUND_CODE in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(vcCombiName)){
				sb.append("   and tt.VC_COMBI_NAME like '%" + vcCombiName + "%' ");
			}
			if(StringUtils.isNotBlank(vCStockholderId)){
				sb.append("   and tt.VC_STOCKHOLDER_ID like '%" + vCStockholderId + "%' ");
			}
			if(StringUtils.isNotBlank(vCReportCode)){
				sb.append("   and tt.VC_REPORT_CODE like '%" + vCReportCode + "%' ");
			}
			if(StringUtils.isNotBlank(vCStockName)){
				sb.append("   and tt.VC_STOCK_NAME like '%" + vCStockName + "%' ");
			}
			//排序SQL语句
			String sqlOrder = " order by tt.VC_FUND_CODE asc, tt.VC_COMBI_NAME asc, tt.VC_REPORT_CODE asc";


			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_DATE = map.get("L_DATE");//日期
					String L_FUND_ID = map.get("L_FUND_ID");//基金序号
					String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					String VC_COMBI_NAME = map.get("VC_COMBI_NAME");//组合名称
					String VC_STOCKHOLDER_ID = map.get("VC_STOCKHOLDER_ID");//股东代码
					String VC_REPORT_CODE = map.get("VC_REPORT_CODE");//证券代码
					String VC_STOCK_NAME = map.get("VC_STOCK_NAME");//证券名称
					String L_ENABLE_AMOUNT = StrUtil.addThousandth(map.get("L_ENABLE_AMOUNT"), StrUtil.df1);//可质押数量
					String L_IMPAWN_AMOUNT = StrUtil.addThousandth(map.get("L_IMPAWN_AMOUNT"), StrUtil.df1);//已质押数量
					String L_AMOUNT = StrUtil.addThousandth(map.get("L_AMOUNT"), StrUtil.df1);//持仓
					String L_RATIO = StrUtil.addThousandth(map.get("L_RATIO"), StrUtil.df1);//抵押比率（%）
					String L_IMPAWNSTD_AMOUNT = StrUtil.addThousandth(map.get("L_IMPAWNSTD_AMOUNT"), StrUtil.df1);//已转标准券数量
					String L_ENABLESTD_AMOUNT = StrUtil.addThousandth(map.get("L_ENABLESTD_AMOUNT"), StrUtil.df1);//可转标准券数量

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("L_DATE", L_DATE);//日期
					obj.setString("L_FUND_ID", L_FUND_ID);//基金序号
					obj.setString("VC_FUND_CODE", VC_FUND_CODE);//基金代码
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);//基金名称
					obj.setString("VC_COMBI_NAME", VC_COMBI_NAME);//组合名称
					obj.setString("VC_STOCKHOLDER_ID", VC_STOCKHOLDER_ID);//股东代码
					obj.setString("VC_REPORT_CODE", VC_REPORT_CODE);//证券代码
					obj.setString("VC_STOCK_NAME", VC_STOCK_NAME);//证券名称
					obj.setString("L_ENABLE_AMOUNT", L_ENABLE_AMOUNT);//可质押数量
					obj.setString("L_IMPAWN_AMOUNT", L_IMPAWN_AMOUNT);//已质押数量
					obj.setString("L_AMOUNT", L_AMOUNT);//持仓
					obj.setString("L_RATIO", L_RATIO);//抵押比率（%）
					obj.setString("L_IMPAWNSTD_AMOUNT", L_IMPAWNSTD_AMOUNT);//已转标准券数量
					obj.setString("L_ENABLESTD_AMOUNT", L_ENABLESTD_AMOUNT);//可转标准券数量

					result.add(obj);
					obj = null;
				}
			}
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
	 * 综合信息查询-标准券查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryBZQ(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_BZQ)){
				SQL_BZQ = getFileSql("zhxxcx_bzq.sql");
			}
//			if(StringUtils.isEmpty(SQL_BZQ_HIS)){
//				SQL_BZQ_HIS = getFileSql("zhxxcx_bzq_his.sql");
//			}


			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String cMarketNo = paramObject.getString("cMarketNo");//交易市场
			String vCReportCode = paramObject.getString("vCReportCode");//证券代码
			String vCStockName = paramObject.getString("vCStockName");//证券名称


			//拼接SQL语句
			sb.append(SQL_BZQ);
			//新增查询条件
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and tt.VC_FUND_CODE in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vCFundCode)){
				sb.append("   and tt.VC_FUND_CODE in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(cMarketNo)){
				sb.append("   and tt.C_MARKET_NO like '%" + cMarketNo + "%' ");
			}
			if(StringUtils.isNotBlank(vCReportCode)){
				sb.append("   and tt.VC_REPORT_CODE like '%" + vCReportCode + "%' ");
			}
			if(StringUtils.isNotBlank(vCStockName)){
				sb.append("   and tt.VC_STOCK_NAME like '%" + vCStockName + "%' ");
			}
			//排序SQL语句
			String sqlOrder = " order by tt.VC_FUND_CODE asc, tt.C_MARKET_NO asc";


			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_FUND_ID = map.get("L_FUND_ID");//基金序号
					String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					/*20180417:获取组合名称*/
					String VC_SSET_NAME = map.get("VC_SSET_NAME");//组合名称
					String C_MARKET_NO = map.get("C_MARKET_NO");//交易市场：1-上交所A；2-深交所A；
					String VC_REPORT_CODE = map.get("VC_REPORT_CODE");//证券代码
					String VC_STOCK_NAME = map.get("VC_STOCK_NAME");//证券名称
					String L_AMOUNT = StrUtil.addThousandth(map.get("L_AMOUNT"), StrUtil.df1);//库存数量
					String L_AVL_AMOUNT = StrUtil.addThousandth(map.get("L_AVL_AMOUNT"), StrUtil.df1);//可用数量

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("L_FUND_ID", L_FUND_ID);//基金序号
					obj.setString("VC_FUND_CODE", VC_FUND_CODE);//基金代码
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);//基金名称
					/*20180417:组装组合名称*/
					obj.setString("VC_SSET_NAME", VC_SSET_NAME);
					obj.setString("C_MARKET_NO", C_MARKET_NO);//交易市场：1-上交所A；2-深交所A；
					obj.setString("VC_REPORT_CODE", VC_REPORT_CODE);//证券代码
					obj.setString("VC_STOCK_NAME", VC_STOCK_NAME);//证券名称
					obj.setString("L_AMOUNT", L_AMOUNT);//库存数量
					obj.setString("L_AVL_AMOUNT", L_AVL_AMOUNT);//可用数量

					result.add(obj);
					obj = null;
				}
			}
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
	 * 综合信息查询-交易所回购查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryJYSHG(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			//conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_JYSHG)){
				SQL_JYSHG = getFileSql("zhxxcx_jyshg.sql");
			}


			//获取页面传进来的查询条件值
			String busiDateToday = DateUtil.currentDateString(DateUtil.YMD_NUMBER);
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vcCombiNos = paramObject.getString("vcCombiNos");//可查看的组合代码字符串，当有多条记录时，结果值以英文逗号分隔
			String busiDateBegin = DateUtil.format(paramObject.getDate("busiDateBegin"), DateUtil.YMD_NUMBER);//起始业务日期
			String busiDateEnd = DateUtil.format(paramObject.getDate("busiDateEnd"), DateUtil.YMD_NUMBER);//截至业务日期
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String vcCombiName = paramObject.getString("vcCombiName");//组合名称
			String lRedeemLiquidateBegin = DateUtil.format(paramObject.getDate("lRedeemLiquidateBegin"), DateUtil.YMD_NUMBER);//起始实际购回日期
			String lRedeemLiquidateEnd = DateUtil.format(paramObject.getDate("lRedeemLiquidateEnd"), DateUtil.YMD_NUMBER);//截至实际购回日期
			String vCReportCode = paramObject.getString("vCReportCode");//回购代码
			String vCEntrustdirName = paramObject.getString("vCEntrustdirName");//委托方向
			sb.append(SQL_JYSHG.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_TODAY, busiDateToday));
			//获取O32系统的数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			
			/*if(StringUtils.isNotBlank(busiDateBegin) && StringUtils.isNotBlank(busiDateEnd)){
				if(busiDateToday.equals(busiDateBegin) && busiDateToday.equals(busiDateEnd)){
					
				}else{
					sb.append(SQL_JYSHG_HIS.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_BEGIN, busiDateBegin).replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_END, busiDateEnd));
					//获取O32系统的数据库连接
					conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_SJZX);
				}
			}else{
				return result;
			}*/

			//拼接SQL语句
			//sb.append(SQL_JYSHG.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_BEGIN, busiDateBegin).replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_END, busiDateEnd).replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_TODAY, busiDateToday));
			//新增查询条件
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and tt.VC_FUND_CODE in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vcCombiNos)){
				sb.append("   and tt.VC_COMBI_NO in (").append(JDBCUtil.changeInStr(vcCombiNos)).append(") ");
			}
			if(StringUtils.isNotBlank(vCFundCode)){
				sb.append("   and tt.VC_FUND_CODE in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(vcCombiName)){
				sb.append("   and tt.VC_COMBI_NAME like '%" + vcCombiName + "%' ");
			}
			if(StringUtils.isNotBlank(vCReportCode)){
				sb.append("   and tt.VC_REPORT_CODE like '%" + vCReportCode + "%' ");
			}
			if(StringUtils.isNotBlank(vCEntrustdirName)){
				String[] vcEntrustdirNames = vCEntrustdirName.split(",");
				String vcEntrustdirNameStr = "";
				for(String str:vcEntrustdirNames){
					vcEntrustdirNameStr = vcEntrustdirNameStr + "'" + str + "',";
				}
				vcEntrustdirNameStr = vcEntrustdirNameStr.substring(0, vcEntrustdirNameStr.length()-1);
				sb.append("   and tt.VC_ENTRUSTDIR_NAME in (" + vcEntrustdirNameStr + ") ");
			}
			if(StringUtils.isNotBlank(lRedeemLiquidateBegin)){
				sb.append("   and tt.L_REDEEM_LIQUIDATE >= '" + lRedeemLiquidateBegin + "' ");
			}
			if(StringUtils.isNotBlank(lRedeemLiquidateEnd)){
				sb.append("   and tt.L_REDEEM_LIQUIDATE <= '" + lRedeemLiquidateEnd + "' ");
			}
			if(StringUtils.isNotBlank(busiDateBegin)){
				sb.append("   and tt.L_HG_DATE >= '" + busiDateBegin + "' ");
			}
			if(StringUtils.isNotBlank(busiDateEnd)){
				sb.append("   and tt.L_HG_DATE <= '" + busiDateEnd + "' ");
			}
			//排序SQL语句
			String sqlOrder = " order by tt.L_HG_DATE desc, tt.L_FUND_ID asc, tt.L_REDEEM_LIQUIDATE asc";


			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_HG_DATE = map.get("L_HG_DATE");//回购日期
					String L_FUND_ID = map.get("L_FUND_ID");//基金ID
					String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					String VC_COMBI_NAME = map.get("VC_COMBI_NAME");//组合名称
					String VC_REPORT_CODE = map.get("VC_REPORT_CODE");//回购代码
					String VC_ENTRUSTDIR_NAME = map.get("VC_ENTRUSTDIR_NAME");//委托方向
					String L_DEAL_AMOUNT = StrUtil.addThousandth(map.get("L_DEAL_AMOUNT"), StrUtil.df1);//数量
					String EN_NET_ZJ = StrUtil.addThousandth(map.get("EN_NET_ZJ"), StrUtil.df1);//净资金额
					String EN_INTEREST_RATE = StrUtil.addThousandth(map.get("EN_INTEREST_RATE"), StrUtil.df5);//平均利率(%)
					String EN_PROFIT = StrUtil.addThousandth(map.get("EN_PROFIT"), StrUtil.df1);//利润
					String L_REDEEM_LIQUIDATE = map.get("L_REDEEM_LIQUIDATE");//实际购回日期
					String L_SETTLE_DATE = map.get("L_SETTLE_DATE");//购回交割日期
					String L_USE_DAYS = map.get("L_USE_DAYS");//实际占款天数

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("L_HG_DATE", L_HG_DATE);//回购日期
					obj.setString("L_FUND_ID", L_FUND_ID);//基金ID
					obj.setString("VC_FUND_CODE", VC_FUND_CODE);//基金代码
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);//基金名称
					obj.setString("VC_COMBI_NAME", VC_COMBI_NAME);//组合名称
					obj.setString("VC_REPORT_CODE", VC_REPORT_CODE);//回购代码
					obj.setString("VC_ENTRUSTDIR_NAME", VC_ENTRUSTDIR_NAME);//委托方向
					obj.setString("L_DEAL_AMOUNT", L_DEAL_AMOUNT);//数量
					obj.setString("EN_NET_ZJ", EN_NET_ZJ);//净资金额
					obj.setString("EN_INTEREST_RATE", EN_INTEREST_RATE);//平均利率(%)
					obj.setString("EN_PROFIT", EN_PROFIT);//利润
					obj.setString("L_REDEEM_LIQUIDATE", L_REDEEM_LIQUIDATE);//实际购回日期
					obj.setString("L_SETTLE_DATE", L_SETTLE_DATE);//购回交割日期
					obj.setString("L_USE_DAYS", L_USE_DAYS);//实际占款天数

					result.add(obj);
					obj = null;
				}
			}
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
	 * 综合信息查询-银行间回购查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryYHJHG(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_YHJHG)){
				SQL_YHJHG = getFileSql("zhxxcx_yhjhg.sql");
			}
			


			//获取页面传进来的查询条件值
			String busiDateToday = JDBCUtil.getValueBySql(conn, "select a.l_init_date from trade.tsysteminfo a");//获取O32的当前业务日期
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vcCombiNos = paramObject.getString("vcCombiNos");//可查看的组合代码字符串，当有多条记录时，结果值以英文逗号分隔
			String busiDateBegin = DateUtil.format(paramObject.getDate("busiDateBegin"), DateUtil.YMD_NUMBER);//起始业务日期
			String busiDateEnd = DateUtil.format(paramObject.getDate("busiDateEnd"), DateUtil.YMD_NUMBER);//截至业务日期
			
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String vcCombiName = paramObject.getString("vcCombiName");//组合名称
			String lRedeemLiquidateBegin = DateUtil.format(paramObject.getDate("lRedeemLiquidateBegin"), DateUtil.YMD_NUMBER);//起始实际购回日期
			String lRedeemLiquidateEnd = DateUtil.format(paramObject.getDate("lRedeemLiquidateEnd"), DateUtil.YMD_NUMBER);//截至实际购回日期
			String vCReportCode = paramObject.getString("vCReportCode");//回购代码
			String vCEntrustdirName = paramObject.getString("vCEntrustdirName");//委托方向
			sb.append(SQL_YHJHG.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_TODAY, busiDateToday));

			/*if(StringUtils.isNotBlank(busiDateBegin) && StringUtils.isNotBlank(busiDateEnd)){
				sb.append(SQL_YHJHG.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_TODAY, busiDateToday));
					//获取O32系统的数据库连接
					conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
				}else{
					sb.append(SQL_YHJHG_HIS.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_BEGIN, busiDateBegin).replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_END, busiDateEnd));
					//获取O32系统的数据库连接
					conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_SJZX);
				}
			}else{
				return result;
			}*/

			//拼接SQL语句
			//sb.append(SQL_YHJHG.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_BEGIN, busiDateBegin).replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_END, busiDateEnd).replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_TODAY, busiDateToday));
			//新增查询条件
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and tt.VC_FUND_CODE in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vcCombiNos)){
				sb.append("   and tt.VC_COMBI_NO in (").append(JDBCUtil.changeInStr(vcCombiNos)).append(") ");
			}
			if(StringUtils.isNotBlank(vCFundCode)){
				sb.append("   and tt.VC_FUND_CODE in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(vcCombiName)){
				sb.append("   and tt.VC_COMBI_NAME like '%" + vcCombiName + "%' ");
			}
			if(StringUtils.isNotBlank(vCReportCode)){
				sb.append("   and tt.VC_REPORT_CODE like '%" + vCReportCode + "%' ");
			}
			if(StringUtils.isNotBlank(vCEntrustdirName)){
				String[] vcEntrustdirNames = vCEntrustdirName.split(",");
				String vcEntrustdirNameStr = "";
				for(String str:vcEntrustdirNames){
					vcEntrustdirNameStr = vcEntrustdirNameStr + "'" + str + "',";
				}
				vcEntrustdirNameStr = vcEntrustdirNameStr.substring(0, vcEntrustdirNameStr.length()-1);
				sb.append("   and tt.VC_ENTRUSTDIR_NAME in (" + vcEntrustdirNameStr + ") ");
			}
			if(StringUtils.isNotBlank(lRedeemLiquidateBegin)){
				sb.append("   and tt.L_REDEEM_LIQUIDATE >= '" + lRedeemLiquidateBegin + "' ");
			}
			if(StringUtils.isNotBlank(lRedeemLiquidateEnd)){
				sb.append("   and tt.L_REDEEM_LIQUIDATE <= '" + lRedeemLiquidateEnd + "' ");
			}
			if(StringUtils.isNotBlank(busiDateBegin)){
				sb.append("   and tt.L_HG_DATE >= '" + busiDateBegin + "' ");
			}
			if(StringUtils.isNotBlank(busiDateEnd)){
				sb.append("   and tt.L_HG_DATE <= '" + busiDateEnd + "' ");
			}
			//排序SQL语句
			String sqlOrder = " order by tt.L_HG_DATE desc, tt.L_FUND_ID asc, tt.L_REDEEM_LIQUIDATE asc";


			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_HG_DATE = map.get("L_HG_DATE");//回购日期
					String L_SERIAL_NO = map.get("L_SERIAL_NO");//流水号
					String L_FUND_ID = map.get("L_FUND_ID");//基金序号
					String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					String VC_COMBI_NAME = map.get("VC_COMBI_NAME");//组合名称
					String VC_REPORT_CODE = map.get("VC_REPORT_CODE");//回购代码
					String VC_ENTRUSTDIR_NAME = map.get("VC_ENTRUSTDIR_NAME");//委托方向
					String L_DEAL_AMOUNT = StrUtil.addThousandth(map.get("L_DEAL_AMOUNT"), StrUtil.df1);//数量
					String EN_NET_ZJ = StrUtil.addThousandth(map.get("EN_NET_ZJ"), StrUtil.df1);//净资金额
					String EN_RET_ZJ = StrUtil.addThousandth(map.get("EN_RET_ZJ"), StrUtil.df1);//返回金额
					String VC_RIVAL_NAME = map.get("VC_RIVAL_NAME");//交易对手
					String EN_INTEREST_RATE = StrUtil.addThousandth(map.get("EN_INTEREST_RATE"), StrUtil.df4);//平均利率(%)
					String EN_PROFIT = StrUtil.addThousandth(map.get("EN_PROFIT"), StrUtil.df1);//利润
					String L_REDEEM_LAWDATE = map.get("L_REDEEM_LAWDATE");//法定购回日期
					String L_REDEEM_LIQUIDATE = map.get("L_REDEEM_LIQUIDATE");//实际购回日期
					String L_SETTLE_DATE = map.get("L_SETTLE_DATE");//购回交割日期
					String C_STOCK_TYPE = map.get("C_STOCK_TYPE");//证券类别
					String VC_REAL_CODE = map.get("VC_REAL_CODE");//实际回购代码
					String C_TRUSTEE = map.get("C_TRUSTEE");//托管机构

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("L_HG_DATE", L_HG_DATE);//回购日期
					obj.setString("L_SERIAL_NO", L_SERIAL_NO);//流水号
					obj.setString("L_FUND_ID", L_FUND_ID);//基金序号
					obj.setString("VC_FUND_CODE", VC_FUND_CODE);//基金代码
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);//基金名称
					obj.setString("VC_COMBI_NAME", VC_COMBI_NAME);//组合名称
					obj.setString("VC_REPORT_CODE", VC_REPORT_CODE);//回购代码
					obj.setString("VC_ENTRUSTDIR_NAME", VC_ENTRUSTDIR_NAME);//委托方向
					obj.setString("L_DEAL_AMOUNT", L_DEAL_AMOUNT);//数量
					obj.setString("EN_NET_ZJ", EN_NET_ZJ);//净资金额
					obj.setString("EN_RET_ZJ", EN_RET_ZJ);//返回金额
					obj.setString("VC_RIVAL_NAME", VC_RIVAL_NAME);//交易对手
					obj.setString("EN_INTEREST_RATE", EN_INTEREST_RATE);//平均利率(%)
					obj.setString("EN_PROFIT", EN_PROFIT);//利润
					obj.setString("L_REDEEM_LAWDATE", L_REDEEM_LAWDATE);//法定购回日期
					obj.setString("L_REDEEM_LIQUIDATE", L_REDEEM_LIQUIDATE);//实际购回日期
					obj.setString("L_SETTLE_DATE", L_SETTLE_DATE);//购回交割日期
					obj.setString("C_STOCK_TYPE", C_STOCK_TYPE);//证券类别
					obj.setString("VC_REAL_CODE", VC_REAL_CODE);//实际回购代码
					obj.setString("C_TRUSTEE", C_TRUSTEE);//托管机构

					result.add(obj);
					obj = null;
				}
			}

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
	 * 综合信息查询-银行间回购导出查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryYHJHG_DC(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		System.out.println("SQL_YHJHG_DC");
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_YHJHG_DC)){
				SQL_YHJHG_DC = getFileSql("zhxxcx_yhjhg_dc.sql");
			}


			//获取页面传进来的查询条件值
			String busiDateToday = JDBCUtil.getValueBySql(conn, "select a.l_init_date from trade.tsysteminfo a");//获取O32的当前业务日期
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vcCombiNos = paramObject.getString("vcCombiNos");//可查看的组合代码字符串，当有多条记录时，结果值以英文逗号分隔
			String busiDateBegin = DateUtil.format(paramObject.getDate("busiDateBegin"), DateUtil.YMD_NUMBER);//起始业务日期
			String busiDateEnd = DateUtil.format(paramObject.getDate("busiDateEnd"), DateUtil.YMD_NUMBER);//截至业务日期
			
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String vcCombiName = paramObject.getString("vcCombiName");//组合名称
			String lRedeemLiquidateBegin = DateUtil.format(paramObject.getDate("lRedeemLiquidateBegin"), DateUtil.YMD_NUMBER);//起始实际购回日期
			String lRedeemLiquidateEnd = DateUtil.format(paramObject.getDate("lRedeemLiquidateEnd"), DateUtil.YMD_NUMBER);//截至实际购回日期
			String vCReportCode = paramObject.getString("vCReportCode");//回购代码
			String vCEntrustdirName = paramObject.getString("vCEntrustdirName");//委托方向
			sb.append(SQL_YHJHG_DC.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_TODAY, busiDateToday));
			/*if(StringUtils.isNotBlank(busiDateBegin) && StringUtils.isNotBlank(busiDateEnd)){
				if(busiDateToday.equals(busiDateBegin) && busiDateToday.equals(busiDateEnd)){
					
					//获取O32系统的数据库连接
					conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
				}else{
					sb.append(SQL_YHJHG_HIS_DC.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_BEGIN, busiDateBegin).replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_END, busiDateEnd));
					//获取O32系统的数据库连接
					conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_SJZX);
				}
			}else{
				return result;
			}*/

			//拼接SQL语句
			//sb.append(SQL_YHJHG_DC.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_BEGIN, busiDateBegin).replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_END, busiDateEnd).replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_TODAY, busiDateToday));
			//新增查询条件
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and tt.VC_FUND_CODE in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vcCombiNos)){
				sb.append("   and tt.VC_COMBI_NO in (").append(JDBCUtil.changeInStr(vcCombiNos)).append(") ");
			}
			if(StringUtils.isNotBlank(vCFundCode)){
				sb.append("   and tt.VC_FUND_CODE in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(vcCombiName)){
				sb.append("   and tt.VC_COMBI_NAME like '%" + vcCombiName + "%' ");
			}
			if(StringUtils.isNotBlank(vCReportCode)){
				sb.append("   and tt.VC_REPORT_CODE like '%" + vCReportCode + "%' ");
			}
			if(StringUtils.isNotBlank(vCEntrustdirName)){
				String[] vcEntrustdirNames = vCEntrustdirName.split(",");
				String vcEntrustdirNameStr = "";
				for(String str:vcEntrustdirNames){
					vcEntrustdirNameStr = vcEntrustdirNameStr + "'" + str + "',";
				}
				vcEntrustdirNameStr = vcEntrustdirNameStr.substring(0, vcEntrustdirNameStr.length()-1);
				sb.append("   and tt.VC_ENTRUSTDIR_NAME in (" + vcEntrustdirNameStr + ") ");
			}
			if(StringUtils.isNotBlank(lRedeemLiquidateBegin)){
				sb.append("   and tt.L_REDEEM_LIQUIDATE >= '" + lRedeemLiquidateBegin + "' ");
			}
			if(StringUtils.isNotBlank(busiDateBegin)){
				sb.append("   and tt.L_HG_DATE >= '" + busiDateBegin + "' ");
			}
			if(StringUtils.isNotBlank(busiDateEnd)){
				sb.append("   and tt.L_HG_DATE <= '" + busiDateEnd + "' ");
			}
			if(StringUtils.isNotBlank(lRedeemLiquidateEnd)){
				sb.append("   and tt.L_REDEEM_LIQUIDATE <= '" + lRedeemLiquidateEnd + "' ");
			}
			//排序SQL语句
			String sqlOrder = " order by tt.L_HG_DATE desc, tt.L_FUND_ID asc, tt.L_REDEEM_LIQUIDATE asc";


			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			List<String> serialList = new ArrayList<String>();
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_HG_DATE = map.get("L_HG_DATE");//回购日期
					String L_SERIAL_NO = map.get("L_SERIAL_NO");//流水号
					String L_FUND_ID = map.get("L_FUND_ID");//基金序号
					String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					String VC_COMBI_NAME = map.get("VC_COMBI_NAME");//组合名称
					String VC_REPORT_CODE = map.get("VC_REPORT_CODE");//回购代码
					String VC_ENTRUSTDIR_NAME = map.get("VC_ENTRUSTDIR_NAME");//委托方向
					String L_DEAL_AMOUNT = StrUtil.addThousandth(map.get("L_DEAL_AMOUNT"), StrUtil.df1);//数量
					String EN_NET_ZJ = StrUtil.addThousandth(map.get("EN_NET_ZJ"), StrUtil.df1);//净资金额
					String EN_RET_ZJ = StrUtil.addThousandth(map.get("EN_RET_ZJ"), StrUtil.df1);//返回金额
					String VC_RIVAL_NAME = map.get("VC_RIVAL_NAME");//交易对手
					String EN_INTEREST_RATE = StrUtil.addThousandth(map.get("EN_INTEREST_RATE"), StrUtil.df4);//平均利率(%)
					String EN_PROFIT = StrUtil.addThousandth(map.get("EN_PROFIT"), StrUtil.df1);//利润
					String L_REDEEM_LAWDATE = map.get("L_REDEEM_LAWDATE");//法定购回日期
					String L_REDEEM_LIQUIDATE = map.get("L_REDEEM_LIQUIDATE");//实际购回日期
					String L_SETTLE_DATE = map.get("L_SETTLE_DATE");//购回交割日期
					String C_STOCK_TYPE = map.get("C_STOCK_TYPE");//证券类别
					String VC_REAL_CODE = map.get("VC_REAL_CODE");//实际回购代码
					String C_TRUSTEE = map.get("C_TRUSTEE");//托管机构
					String L_DATE = map.get("L_DATE");//日期
					String VC_ZQ_CODE = map.get("VC_ZQ_CODE");//证券代码
					String VC_STOCK_NAME = map.get("VC_STOCK_NAME");//证券名称
					String EN_RATIO = StrUtil.addThousandth(map.get("EN_RATIO"), StrUtil.df1);//质押比例
					String L_MORTAGAGE_AMOUNT = StrUtil.addThousandth(map.get("L_MORTAGAGE_AMOUNT"), StrUtil.df1);//质押数量
					String C_INVEST_TYPE = map.get("C_INVEST_TYPE");//投资类型

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("L_DATE",L_DATE);//日期
					obj.setString("VC_ZQ_CODE",VC_ZQ_CODE);//证券代码
					obj.setString("VC_STOCK_NAME",VC_STOCK_NAME);//证券名称
					obj.setString("EN_RATIO",EN_RATIO);//质押比例
					obj.setString("L_MORTAGAGE_AMOUNT",L_MORTAGAGE_AMOUNT);//质押数量
					obj.setString("C_INVEST_TYPE",C_INVEST_TYPE);//投资类型
					if(!serialList.contains(L_SERIAL_NO)){
						serialList.add(L_SERIAL_NO);
						obj.setString("L_HG_DATE", L_HG_DATE);//回购日期
						obj.setString("L_SERIAL_NO", L_SERIAL_NO);//流水号
						obj.setString("L_FUND_ID", L_FUND_ID);//基金序号
						obj.setString("VC_FUND_CODE", VC_FUND_CODE);//基金代码
						obj.setString("VC_FUND_NAME", VC_FUND_NAME);//基金名称
						obj.setString("VC_COMBI_NAME", VC_COMBI_NAME);//组合名称
						obj.setString("VC_REPORT_CODE", VC_REPORT_CODE);//回购代码
						obj.setString("VC_ENTRUSTDIR_NAME", VC_ENTRUSTDIR_NAME);//委托方向
						obj.setString("L_DEAL_AMOUNT", L_DEAL_AMOUNT);//数量
						obj.setString("EN_NET_ZJ", EN_NET_ZJ);//净资金额
						obj.setString("EN_RET_ZJ", EN_RET_ZJ);//返回金额
						obj.setString("VC_RIVAL_NAME", VC_RIVAL_NAME);//交易对手
						obj.setString("EN_INTEREST_RATE", EN_INTEREST_RATE);//平均利率(%)
						obj.setString("EN_PROFIT", EN_PROFIT);//利润
						obj.setString("L_REDEEM_LAWDATE", L_REDEEM_LAWDATE);//法定购回日期
						obj.setString("L_REDEEM_LIQUIDATE", L_REDEEM_LIQUIDATE);//实际购回日期
						obj.setString("L_SETTLE_DATE", L_SETTLE_DATE);//购回交割日期
						obj.setString("C_STOCK_TYPE", C_STOCK_TYPE);//证券类别
						obj.setString("VC_REAL_CODE", VC_REAL_CODE);//实际回购代码
						obj.setString("C_TRUSTEE", C_TRUSTEE);//托管机构
					}
					result.add(obj);
					obj = null;
				}
			}

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
	 * 综合信息查询-银行间回购-银行间回购明细表查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryYHJHGDetail(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_YHJHG_DETAIL)){
				SQL_YHJHG_DETAIL = getFileSql("zhxxcx_yhjhg_detail.sql");
			}

			//获取页面传进来的查询条件值
			String lSerialNo = paramObject.getString("lSerialNo");//流水号
			//拼接SQL语句
			//拼接SQL语句
			sb.append(SQL_YHJHG_DETAIL.replaceAll(ZhxxcxUtil.PARAM_L_SERIAL_NO, lSerialNo));
			//排序SQL语句
			String sqlOrder = " order by l_date desc, vc_report_code asc";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_DATE = map.get("L_DATE");//日期
					String VC_REPORT_CODE = map.get("VC_REPORT_CODE");//证券代码
					String VC_STOCK_NAME = map.get("VC_STOCK_NAME");//证券名称
					String EN_RATIO = StrUtil.addThousandth(map.get("EN_RATIO"), StrUtil.df1);//抵押比例（%）
					String L_MORTAGAGE_AMOUNT = StrUtil.addThousandth(map.get("L_MORTAGAGE_AMOUNT"), StrUtil.df1);//质押数量
					String L_FUND_ID = map.get("L_FUND_ID");//基金编号
					String L_BASECOMBI_ID = map.get("L_BASECOMBI_ID");//组合序号
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					String VC_COMBI_NAME = map.get("VC_COMBI_NAME");//组合名称
					String C_INVEST_TYPE = map.get("C_INVEST_TYPE");//投资类型

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("L_DATE", L_DATE);//日期
					obj.setString("VC_REPORT_CODE", VC_REPORT_CODE);//证券代码
					obj.setString("VC_STOCK_NAME", VC_STOCK_NAME);//证券名称
					obj.setString("EN_RATIO", EN_RATIO);//抵押比例（%）
					obj.setString("L_MORTAGAGE_AMOUNT", L_MORTAGAGE_AMOUNT);//质押数量
					obj.setString("L_FUND_ID", L_FUND_ID);//基金编号
					obj.setString("L_BASECOMBI_ID", L_BASECOMBI_ID);//组合序号
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);//基金名称
					obj.setString("VC_COMBI_NAME", VC_COMBI_NAME);//组合名称
					obj.setString("C_INVEST_TYPE", C_INVEST_TYPE);//投资类型

					result.add(obj);
					obj = null;
				}
			}
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
	 * 综合信息查询-场外执行成交查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author jiangkanqian
	 */
	@Bizlet("")
	public static List<DataObject> queryOTCTrade(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统的数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_OTCTRADE)){
				SQL_OTCTRADE = getFileSql("zhxxcx_otc_trade.sql");
			}
			if(StringUtils.isEmpty(SQL_OTCTRADE_HIS)){
				SQL_OTCTRADE_HIS = getFileSql("zhxxcx_otc_trade_his.sql");
			}

			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vcCombiNos = paramObject.getString("vcCombiNos");//可查看的组合代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码
			String cBusinClass = paramObject.getString("cBusinClass");//业务分类
			String vCReportCode = paramObject.getString("vCReportCode");//证券代码
			String vCStockName = paramObject.getString("vCStockName");//证券名称
			String cEntrustDirection = paramObject.getString("cEntrustDirection");//委托方向
			String lSettleDateBegin = DateUtil.format(paramObject.getDate("lSettleDateBegin"), DateUtil.YMD_NUMBER);//到账起始日期
			String lSettleDateEnd = DateUtil.format(paramObject.getDate("lSettleDateEnd"), DateUtil.YMD_NUMBER);//到账截止日期
			String lConfirmDateBegin = DateUtil.format(paramObject.getDate("lConfirmDateBegin"), DateUtil.YMD_NUMBER);//起始日期
			String lConfirmDateEnd = DateUtil.format(paramObject.getDate("lConfirmDateEnd"), DateUtil.YMD_NUMBER);//截止日期
			String lDateBegin = DateUtil.format(paramObject.getDate("lDateBegin"), DateUtil.YMD_NUMBER);//起始日期
			String lDateEnd = DateUtil.format(paramObject.getDate("lDateEnd"), DateUtil.YMD_NUMBER);//截止日期
			String tradeDate = getNextTradeDate();//获取当前日期，若不是交易日则获取下一交易日

			/*
			if(tradeDate.equals(lDateBegin) && tradeDate.equals(lDateEnd)){
				sb.append(SQL_OTCTRADE.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_TODAY, tradeDate));
			}else{				
				if(StringUtils.isNotBlank(lDateBegin) && StringUtils.isNotBlank(lDateEnd)){
					sb.append(SQL_OTCTRADE_HIS.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_BEGIN, lDateBegin)
							.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_END, lDateEnd));
				}
				else if(StringUtils.isNotBlank(lDateBegin)){
					sb.append(SQL_OTCTRADE_HIS.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_BEGIN, lDateBegin)
							.replaceAll("and a.l_date <= PARAM_BUSI_DATE_END", ""));
				}	
				else if(StringUtils.isNotBlank(lDateEnd)){
					sb.append(SQL_OTCTRADE_HIS.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_END, lDateEnd)
							.replaceAll("and a.l_date >= PARAM_BUSI_DATE_BEGIN", ""));
				}
				else{
					sb.append(SQL_OTCTRADE_HIS.replaceAll("and a.l_date <= PARAM_BUSI_DATE_END", "")
							.replaceAll("and a.l_date >= PARAM_BUSI_DATE_BEGIN", ""));
				}
			}
			*/
			
			if(StringUtils.isNotBlank(lDateBegin) && StringUtils.isNotBlank(lDateEnd)){
				if(tradeDate.equals(lDateBegin) && tradeDate.equals(lDateEnd)){
					sb.append(SQL_OTCTRADE.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_TODAY, tradeDate));
				}else{
					sb.append(SQL_OTCTRADE_HIS.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_BEGIN, lDateBegin)
							.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_END, lDateEnd));
				}
			}else{
				return result;
			}
			
			//新增查询条件
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and tt.vc_fund_code in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vcCombiNos)){
				sb.append("   and tt.VC_COMBI_NO in (").append(JDBCUtil.changeInStr(vcCombiNos)).append(") ");
			}
			if(StringUtils.isNotBlank(vCFundCode)){
				sb.append("   and tt.vc_fund_code in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(cBusinClass)){
				sb.append("   and tt.c_busin_class in (").append(JDBCUtil.changeInStr(cBusinClass)).append(") ");
			}
			if(StringUtils.isNotBlank(vCReportCode)){
				sb.append("   and tt.vc_report_code like '%" + vCReportCode + "%' ");
			}
			if(StringUtils.isNotBlank(vCStockName)){
				sb.append("   and tt.vc_stock_name like '%" + vCStockName + "%' ");
			}
			if(StringUtils.isNotBlank(cEntrustDirection)){
				sb.append("   and tt.vc_entrustdir_name in (").append(JDBCUtil.changeInStr(cEntrustDirection)).append(") ");
			}
			if(StringUtils.isNotBlank(lSettleDateBegin)){
				sb.append("   and tt.l_settle_date >= '" + lSettleDateBegin + "'");
			}
			if(StringUtils.isNotBlank(lSettleDateEnd)){
				sb.append("   and tt.l_settle_date <= '" + lSettleDateEnd + "'");
			}
			if(StringUtils.isNotBlank(lConfirmDateBegin)){
				sb.append("   and tt.l_confirm_date >= '" + lConfirmDateBegin + "'");
			}
			if(StringUtils.isNotBlank(lConfirmDateEnd)){
				sb.append("   and tt.l_confirm_date <= '" + lConfirmDateEnd + "'");
			}
			if(StringUtils.isNotBlank(lDateBegin)){
				sb.append("   and tt.l_date >= '" + lDateBegin + "'");
			}
			if(StringUtils.isNotBlank(lDateEnd)){
				sb.append("   and tt.l_date <= '" + lDateEnd + "'");
			}
			
			//排序SQL语句
			String sqlOrder = " order by tt.L_FUND_ID asc,tt.VC_REPORT_CODE asc ";
			
			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("VC_FUND_NAME", map.get("VC_FUND_NAME"));//基金名称
					obj.setString("VC_COMBI_NAME", map.get("VC_COMBI_NAME"));//组合名称
					obj.setString("C_BUSIN_CLASS", map.get("C_BUSIN_CLASS"));//业务分类
					obj.setString("VC_REPORT_CODE", map.get("VC_REPORT_CODE"));//证券代码
					obj.setString("VC_STOCK_NAME", map.get("VC_STOCK_NAME"));//证券名称
					obj.setString("VC_ENTRUSTDIR_NAME", map.get("VC_ENTRUSTDIR_NAME"));//委托方向
					obj.setString("EN_BALANCE", StrUtil.addThousandth(map.get("EN_BALANCE"), StrUtil.df1));//金额
					obj.setString("EN_AMOUNT", StrUtil.addThousandth(map.get("EN_AMOUNT"), StrUtil.df4));//数量
					obj.setString("L_SETTLE_DATE", map.get("L_SETTLE_DATE"));//到账日期
					obj.setString("L_DATE", map.get("L_DATE"));//日期
					obj.setString("L_CONFIRM_DATE", map.get("L_CONFIRM_DATE"));//确认操作日期
					result.add(obj);
					obj = null;
				}
			}

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
	 * 综合信息查询-交易所债券协议回购查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author jiangkanqian
	 */
	@Bizlet("")
	public static List<DataObject> queryBondRepurchase(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统的数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_BONDREPURCHASE)){
				SQL_BONDREPURCHASE = getFileSql("zhxxcx_bond_repurchase.sql");
			}
			if(StringUtils.isEmpty(SQL_BONDREPURCHASE_HIS)){
				SQL_BONDREPURCHASE_HIS = getFileSql("zhxxcx_bond_repurchase_his.sql");
			}

			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vcCombiNos = paramObject.getString("vcCombiNos");//可查看的组合代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码
			String cEntrustDirection = paramObject.getString("cEntrustDirection");//委托方向
			String vCReportCode = paramObject.getString("vCReportCode");//质押券代码
			//String lDateBegin = DateUtil.format(paramObject.getDate("lDateBegin"), DateUtil.YMD_NUMBER);//起始日期
			//String lDateEnd = DateUtil.format(paramObject.getDate("lDateEnd"), DateUtil.YMD_NUMBER);//截止日期
			String lHgDateBegin = DateUtil.format(paramObject.getDate("lHgDateBegin"), DateUtil.YMD_NUMBER);//起始日期
			String lHgDateEnd = DateUtil.format(paramObject.getDate("lHgDateEnd"), DateUtil.YMD_NUMBER);//截止日期
			String lSecondSettleDateBegin = DateUtil.format(paramObject.getDate("lSecondSettleDateBegin"), DateUtil.YMD_NUMBER);//结算起始日期
			String lSecondSettleDateEnd = DateUtil.format(paramObject.getDate("lSecondSettleDateEnd"), DateUtil.YMD_NUMBER);//结算截止日期
			String tradeDate = getNextTradeDate();//获取当前日期，若不是交易日则获取下一交易日
			
			sb.append(SQL_BONDREPURCHASE.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_TODAY, tradeDate));
			
			/*
			if(StringUtils.isNotBlank(lDateBegin) && StringUtils.isNotBlank(lDateEnd)){
				if(tradeDate.equals(lDateBegin) && tradeDate.equals(lDateEnd)){
					sb.append(SQL_BONDREPURCHASE.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_TODAY, tradeDate));
				}else{
					sb.append(SQL_BONDREPURCHASE_HIS.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_BEGIN, lDateBegin)
							.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_END, lDateEnd));
				}
			}else{
				return result;
			}
			*/
			
			//新增查询条件
			if(StringUtils.isNotBlank(lHgDateBegin)){
				sb.append("   and t.l_hg_date >= '" + lHgDateBegin + "'");
			}
			if(StringUtils.isNotBlank(lHgDateEnd)){
				sb.append("   and t.l_hg_date <= '" + lHgDateEnd + "'");
			}
			if(StringUtils.isNotBlank(lSecondSettleDateBegin)){
				sb.append("   and t.l_second_settle_date >= '" + lSecondSettleDateBegin + "'");
			}
			if(StringUtils.isNotBlank(lSecondSettleDateEnd)){
				sb.append("   and t.l_second_settle_date <= '" + lSecondSettleDateEnd + "'");
			}
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and t.vc_fund_code in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vcCombiNos)){
				sb.append("   and t.VC_COMBI_NO in (").append(JDBCUtil.changeInStr(vcCombiNos)).append(") ");
			}
			if(StringUtils.isNotBlank(vCFundCode)){
				sb.append("   and t.vc_fund_code in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(vCReportCode)){
				sb.append("   and t.vc_report_code like '%" + vCReportCode + "%' ");
			}
			if(StringUtils.isNotBlank(cEntrustDirection)){
				sb.append("   and t.c_entrust_direction in (").append(JDBCUtil.changeInStr(cEntrustDirection)).append(") ");
			}
			//排序SQL语句
			String sqlOrder = " order by t.L_FUND_ID asc,t.VC_REPORT_CODE asc ";			
			
			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("L_FUND_ID", map.get("L_FUND_ID"));//基金序号
					obj.setString("VC_FUND_NAME", map.get("VC_FUND_NAME"));//基金名称
					obj.setString("VC_COMBI_NO", map.get("VC_COMBI_NO"));//组合编号
					obj.setString("VC_COMBI_NAME", map.get("VC_COMBI_NAME"));//组合名称
					obj.setString("C_ENTRUST_DIRECTION", map.get("C_ENTRUST_DIRECTION"));//委托方向
					obj.setString("C_HG_TYPE", map.get("C_HG_TYPE"));//回购类型
					obj.setString("VC_REPORT_CODE", map.get("VC_REPORT_CODE"));//质押券代码
					obj.setString("VC_STOCK_NAME", map.get("VC_STOCK_NAME"));//质押券简称
					obj.setString("L_DEAL_AMOUNT", StrUtil.addThousandth(map.get("L_DEAL_AMOUNT"), StrUtil.df2));//质押数量
					obj.setString("EN_BALANCE", StrUtil.addThousandth(map.get("EN_BALANCE"), StrUtil.df1));//质押券面值总额
					obj.setString("L_DATE", map.get("L_DATE"));//成交日期
					obj.setString("L_REDEEM_LAWDATE", map.get("L_REDEEM_LAWDATE"));//法定购回日期
					obj.setString("EN_FIRST_CLEAR_BALANCE", StrUtil.addThousandth(map.get("EN_FIRST_CLEAR_BALANCE"), StrUtil.df1));//成交金额
					obj.setString("EN_CONVERT", StrUtil.addThousandth(map.get("EN_CONVERT"), StrUtil.df1));//折算率
					obj.setString("EN_RATE", StrUtil.addThousandth(map.get("EN_RATE"), StrUtil.df4));//回购利率
					obj.setString("L_REDEEM_DAYS", map.get("L_REDEEM_DAYS"));//回购天数
					obj.setString("L_REDEEM_LIQUIDATE", map.get("L_REDEEM_LIQUIDATE"));//实际回购到期日
					obj.setString("L_USE_DAYS", map.get("L_USE_DAYS"));//实际占款天数
					obj.setString("EN_SECOND_CLEAR_BALANCE", StrUtil.addThousandth(map.get("EN_SECOND_CLEAR_BALANCE"), StrUtil.df1));//到期结算金额
					obj.setString("L_FIRST_SETTLE_DATE", map.get("L_FIRST_SETTLE_DATE"));//首期结算日
					obj.setString("L_SECOND_SETTLE_DATE", map.get("L_SECOND_SETTLE_DATE"));//到期结算日
					obj.setString("L_END_DATE", map.get("L_END_DATE"));//摘牌日
					obj.setString("L_NEXTPAYMENT_DATE", map.get("L_NEXTPAYMENT_DATE"));//下一付息日
					obj.setString("EN_BOND_INTEREST", StrUtil.addThousandth(map.get("EN_BOND_INTEREST"), StrUtil.df1));//本期结算利息
					obj.setString("VC_NAME", map.get("VC_NAME"));//对手方交易商简称
					obj.setString("C_MARKET_NO", map.get("C_MARKET_NO"));//交易所
					obj.setString("C_INSIDE_APPRAISE", map.get("C_INSIDE_APPRAISE"));//内部评级
					obj.setString("C_OUTER_APPRAISE", map.get("C_OUTER_APPRAISE"));//外部评级
					obj.setString("L_OPERATOR_NO", map.get("L_OPERATOR_NO"));//操作员
					obj.setString("VC_INTER_CODE", map.get("VC_INTER_CODE"));//证券内码
					obj.setString("L_RIVAL_ID", map.get("L_RIVAL_ID"));//交易对手ID
					obj.setString("L_HG_DATE", map.get("L_HG_DATE"));//回购日期
					obj.setString("C_FUND_TYPE", map.get("C_FUND_TYPE"));//基金类型
					obj.setString("L_BASECOMBI_ID", map.get("L_BASECOMBI_ID"));//组合序号
					obj.setString("L_ZYFUND_ID", map.get("L_ZYFUND_ID"));//基金序号
					obj.setString("L_ZYBASECOMBI_ID", map.get("L_ZYBASECOMBI_ID"));//组合序号
					
					result.add(obj);
					obj = null;
				}
			}

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
	 * 综合信息查询-组合持仓查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryZHCC(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		System.out.println("产品代码：" + paramObject.getString("vCFundCode"));
		try {
			//获取O32系统数据库连接
			//conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_ZHCC)){
				SQL_ZHCC = getFileSql("zhxxcx_zhcc.sql");
			}
			if(StringUtils.isEmpty(SQL_ZHCC_HIS)){
				SQL_ZHCC_HIS = getFileSql("zhxxcx_zhcc_his.sql");
			}


			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vcCombiNos = paramObject.getString("vcCombiNos");//可查看的组合代码字符串，当有多条记录时，结果值以英文逗号分隔
			String busiDateEnd = DateUtil.format(paramObject.getDate("busiDateEnd"), DateUtil.YMD_NUMBER);//截至业务日期
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String vCReportCode = paramObject.getString("vCReportCode");//证券代码
			String vCStockName = paramObject.getString("vCStockName");//证券名称
			String cMarketName = paramObject.getString("cMarketName");//交易市场
			String cMarketNo = paramObject.getString("cMarketNo");//交易市场代码
			String lDateBegin = DateUtil.format(paramObject.getDate("lDateBegin"), DateUtil.YMD_NUMBER);//起始日期
			String lDateEnd = DateUtil.format(paramObject.getDate("lDateEnd"), DateUtil.YMD_NUMBER);//截止日期
			String tradeDate = getNextTradeDate();//获取当前日期，若不是交易日则获取下一交易日

			if(StringUtils.isNotBlank(lDateBegin) && StringUtils.isNotBlank(lDateEnd)){
				if(tradeDate.equals(lDateBegin) && tradeDate.equals(lDateEnd)){
					sb.append(SQL_ZHCC.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_TODAY, tradeDate));
					//获取O32系统的数据库连接
					conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
				}else{
					sb.append(SQL_ZHCC_HIS);
					//若查询历史交易所的成交回报，则获取数据中心的数据库连接
					conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_SJZX);
				}
			}else{
				return result;
			}

			//拼接SQL语句
			//sb.append(SQL_ZHCC.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_BEGIN, busiDateEnd).replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_END, busiDateEnd));
			//新增查询条件
			if(StringUtils.isNotBlank(lDateBegin)){
				sb.append("   and tt1.l_date >= '" + lDateBegin + "'");
			}
			if(StringUtils.isNotBlank(lDateEnd)){
				sb.append("   and tt1.l_date <= '" + lDateEnd + "'");
			}
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and tt1.vc_fund_code in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vcCombiNos)){
				sb.append("   and tt1.VC_COMBI_NO in (").append(JDBCUtil.changeInStr(vcCombiNos)).append(") ");
			}
			if(StringUtils.isNotBlank(vCFundCode)){
				sb.append("   and tt1.vc_fund_code in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(vCReportCode)){
				sb.append("   and tt1.vc_report_code like '%" + vCReportCode + "%' ");
			}
			if(StringUtils.isNotBlank(vCStockName)){
				sb.append("   and tt1.vc_stock_name like '%" + vCStockName + "%' ");
			}
			if(StringUtils.isNotBlank(cMarketName)){
				sb.append("   and tt1.vc_market_name like '%" + cMarketName + "%' ");
			}
			if(StringUtils.isNotBlank(cMarketNo)){
				sb.append("   and tt1.C_MARKET_NO in (").append(JDBCUtil.changeInStr(cMarketNo)).append(") ");
			}
			//排序SQL语句
			String sqlOrder = " order by tt1.L_FUND_ID asc,tt1.VC_REPORT_CODE asc ";


			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_DATE = map.get("L_DATE");//日期
					String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					String VC_COMBI_NAME = map.get("VC_COMBI_NAME");//组合名称
					String VC_INTER_CODE = map.get("VC_INTER_CODE");//证券内码
					String VC_REPORT_CODE = map.get("VC_REPORT_CODE");//证券代码
					String VC_STOCK_NAME = map.get("VC_STOCK_NAME");//证券名称
					String VC_MARKET_NAME = map.get("VC_MARKET_NAME");//交易市场
					String L_CURRENT_AMOUNT = StrUtil.addThousandth(map.get("L_CURRENT_AMOUNT"), StrUtil.df1);//持仓
					String C_POSITION_FLAG = map.get("C_POSITION_FLAG_CN");//持仓多空标志
					String L_USABLE_AMOUNT = StrUtil.addThousandth(map.get("L_USABLE_AMOUNT"), StrUtil.df1);//可用数量
					String L_FROZEN_AMOUNT = StrUtil.addThousandth(map.get("L_FROZEN_AMOUNT"), StrUtil.df1);//冻结数量
					String C_OUTER_APPRAISE = map.get("C_OUTER_APPRAISE");//外部评级
					String C_ISSUER_OUTER_APPRAISE = map.get("C_ISSUER_OUTER_APPRAISE");//发行人外部评级
					String EN_QJ = StrUtil.addThousandth(map.get("EN_QJ"), StrUtil.df4);//全价
					String EN_JJ = StrUtil.addThousandth(map.get("EN_JJ"), StrUtil.df4);//净价
					String EN_BEGIN_COST_PRICE = StrUtil.addThousandth(map.get("EN_BEGIN_COST_PRICE"), StrUtil.df4);//成本价
					String D_QJCB = StrUtil.addThousandth(map.get("D_QJCB"), StrUtil.df1);//全价成本
					String D_QJSZ = StrUtil.addThousandth(map.get("D_QJSZ"), StrUtil.df1);//全价市值
					String D_QJFY = StrUtil.addThousandth(map.get("D_QJFY"), StrUtil.df1);//全价浮盈
					String L_FUND_ID = map.get("L_FUND_ID");//基金编号
					String VC_COMBI_NO = map.get("VC_COMBI_NO");//组合编号
					String VC_STOCKHOLDER_ID = map.get("VC_STOCKHOLDER_ID");//股东代码
					String EN_LAST_PRICE = map.get("EN_LAST_PRICE");//最新价
					String EN_VALUE_CURRENCY = map.get("EN_VALUE_CURRENCY");//市值
					String EN_FLOAT_RATE = map.get("EN_FLOAT_RATE");//盈亏率
					String EN_TOTAL_PROFIT = map.get("EN_TOTAL_PROFIT");//总体盈亏
					String EN_CURRENCY_FUND = map.get("EN_CURRENCY_FUND");//市值比净值


					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("L_DATE", L_DATE);//日期
					obj.setString("VC_FUND_CODE", VC_FUND_CODE);//基金代码
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);//基金名称
					obj.setString("VC_COMBI_NAME", VC_COMBI_NAME);//组合名称
					obj.setString("VC_INTER_CODE", VC_INTER_CODE);//证券内码
					obj.setString("VC_REPORT_CODE", VC_REPORT_CODE);//证券代码
					obj.setString("VC_STOCK_NAME", VC_STOCK_NAME);//证券名称
					obj.setString("VC_MARKET_NAME", VC_MARKET_NAME);//交易市场
					obj.setString("L_CURRENT_AMOUNT", L_CURRENT_AMOUNT);//持仓
					obj.setString("L_USABLE_AMOUNT", L_USABLE_AMOUNT);//可用数量
					obj.setString("L_FROZEN_AMOUNT", L_FROZEN_AMOUNT);//冻结数量
					obj.setString("C_OUTER_APPRAISE", C_OUTER_APPRAISE);//外部评级
					obj.setString("C_ISSUER_OUTER_APPRAISE", C_ISSUER_OUTER_APPRAISE);//发行人外部评级
					obj.setString("EN_QJ", EN_QJ);//全价
					obj.setString("EN_JJ", EN_JJ);//净价
					obj.setString("EN_BEGIN_COST_PRICE", EN_BEGIN_COST_PRICE);//成本价
					obj.setString("D_QJCB", D_QJCB);//全价成本
					obj.setString("D_QJSZ", D_QJSZ);//全价市值
					obj.setString("D_QJFY", D_QJFY);//全价浮盈
					obj.setString("L_FUND_ID", L_FUND_ID);//基金编号
					obj.setString("VC_COMBI_NO", VC_COMBI_NO);//组合编号
					obj.setString("VC_STOCKHOLDER_ID", VC_STOCKHOLDER_ID);//股东代码
					obj.setString("EN_LAST_PRICE", EN_LAST_PRICE);//最新价
					obj.setString("EN_VALUE_CURRENCY", EN_VALUE_CURRENCY);//市值
					obj.setString("EN_FLOAT_RATE", EN_FLOAT_RATE);//盈亏率
					obj.setString("EN_TOTAL_PROFIT", EN_TOTAL_PROFIT);//总体盈亏
					obj.setString("EN_CURRENCY_FUND", EN_CURRENCY_FUND);//市值比净值
					obj.setString("C_POSITION_FLAG", C_POSITION_FLAG);//持仓多空标志
					result.add(obj);
					obj = null;
				}
			}

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
	 * 综合信息查询-O32头寸检查表1查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryO32TCJC1(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_O32TCJC1)){
				SQL_O32TCJC1 = getFileSql("zhxxcx_o32tcjc1.sql");
			}


			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String vCAssetName = paramObject.getString("vCAssetName");//资产单元名称
			String vCSort = paramObject.getString("vCSort"); //排序条件

			//产品ID和资产单元ID
			String combProductIds = paramObject.getString("lFundIds");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String combAssetIds = paramObject.getString("lAssetIds");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			//拼接SQL语句
			sb.append(SQL_O32TCJC1);
			//新增查询条件
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and t0.VC_FUNDCODE in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vCFundCode)){
				sb.append("   and t0.VC_FUNDCODE in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(combProductIds)){
				sb.append("   and t0.L_FUND_ID in (").append(JDBCUtil.changeInStr(combProductIds)).append(") ");
			}
			if(StringUtils.isNotBlank(combAssetIds)){
				sb.append("   and t0.L_ASSET_ID in (").append(JDBCUtil.changeInStr(combAssetIds)).append(") ");
			}
			if(StringUtils.isNotBlank(vCAssetName)){
				sb.append("   and t0.VC_ASSETNAME like '%" + vCAssetName + "%' ");
			}
			//排序SQL语句
			String sqlOrder = " order by ";
			//组装排序SQL语句
			if(StringUtils.isNotBlank(vCSort)){		//判断排序字段是否为空
				//排序字段等于T0_BALANCE_ASC为T+0头寸升序
				if(vCSort.equalsIgnoreCase("T0_BALANCE_ASC")){
					sqlOrder += "t0.T0_BALANCE asc,";
				}
				//排序字段等于T0_BALANCE_DESC为T+0头寸降序
				if(vCSort.equalsIgnoreCase("T0_BALANCE_DESC")){
					sqlOrder += "t0.T0_BALANCE desc,";
				}
				//排序字段等于T1_BALANCE_ASC为T+1头寸升序
				if(vCSort.equalsIgnoreCase("T1_BALANCE_ASC")){
					sqlOrder += "t0.T1_BALANCE asc,";
				}
				//排序字段等于T1_BALANCE_DESC为T+1头寸降序
				if(vCSort.equalsIgnoreCase("T1_BALANCE_DESC")){
					sqlOrder += "t0.T1_BALANCE desc,";
				}
			}
			sqlOrder += "t0.VC_FUNDCODE asc";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");

					String L_FUND_ID = map.get("L_FUND_ID");//基金序号
					String VC_FUNDCODE = map.get("VC_FUNDCODE");//基金代码
					String VC_FUNDNAME = map.get("VC_FUNDNAME");//基金名称
					String L_ASSET_ID = map.get("L_ASSET_ID");//资产单元序号
					String VC_ASSETNAME = map.get("VC_ASSETNAME");//资产单元名称
					String JYSTC_SH = StrUtil.addThousandth0ToEmpty(map.get("JYSTC_SH"), StrUtil.df1);//交易所头寸情况(上交所)
					String JYSTC_SZ = StrUtil.addThousandth0ToEmpty(map.get("JYSTC_SZ"), StrUtil.df1);//交易所头寸情况(深交所)
					String T0_BALANCE = StrUtil.addThousandth0ToEmpty(map.get("T0_BALANCE"), StrUtil.df1);//T+0头寸情况F
					String T1_BALANCE = StrUtil.addThousandth0ToEmpty(map.get("T1_BALANCE"), StrUtil.df1);//T+1头寸情况G
					String EN_YHJ_ZQ = StrUtil.addThousandth0ToEmpty(map.get("EN_YHJ_ZQ"), StrUtil.df1);//当日T+0交易意向H
					String EN_YHJ_ZQ_T0CJ = StrUtil.addThousandth0ToEmpty(map.get("EN_YHJ_ZQ_T0CJ"), StrUtil.df1);//当日T+0前台成交I
					String EN_YHJ_ZQ_T1CJ = StrUtil.addThousandth0ToEmpty(map.get("EN_YHJ_ZQ_T1CJ"), StrUtil.df1);//昨日T+1资金流入J
					String EN_YHJ_RQGH = StrUtil.addThousandth0ToEmpty(map.get("EN_YHJ_RQGH"), StrUtil.df1);//当日逆回购到期K
					String EN_YHJ_DXDF = StrUtil.addThousandth0ToEmpty(map.get("EN_YHJ_DXDF"), StrUtil.df1);//当日债券兑付兑息L
					String EN_YHJ_TQDJ = StrUtil.addThousandth0ToEmpty(map.get("EN_YHJ_TQDJ"), StrUtil.df1);//次日正回购到期提前冻结M
					String EN_JYS_ZLZY1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_ZLZY1"), StrUtil.df1);//指令占用(上海)O
					String EN_JYS_ZLZY2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_ZLZY2"), StrUtil.df1);//指令占用(深圳)O
					String EN_JYS_QZMM1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_QZMM1"), StrUtil.df1);//股票权证买卖(上海)P
					String EN_JYS_QZMM2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_QZMM2"), StrUtil.df1);//股票权证买卖(深圳)P
					String EN_JYS_ZQMM1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_ZQMM1"), StrUtil.df1);//债券买卖(上海)Q
					String EN_JYS_ZQMM2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_ZQMM2"), StrUtil.df1);//债券买卖(深圳)Q
					String EN_JYS_RZHG1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RZHG1"), StrUtil.df1);//正回购首期(上海)R
					String EN_JYS_RZHG2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RZHG2"), StrUtil.df1);//正回购首期(深圳)R
					String EN_JYS_RZGH1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RZGH1"), StrUtil.df1);//正回购到期(上海)S
					String EN_JYS_RZGH2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RZGH2"), StrUtil.df1);//正回购到期(深圳)S
					String EN_JYS_RQHG1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RQHG1"), StrUtil.df1);//逆回购首期(上海)T
					String EN_JYS_RQHG2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RQHG2"), StrUtil.df1);//逆回购首期(深圳)T
					String EN_JYS_RQGH1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RQGH1"), StrUtil.df1);//逆回购到期(上海)U
					String EN_JYS_RQGH2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RQGH2"), StrUtil.df1);//逆回购到期(深圳)U
					String EN_JYS_FDBJS1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_FDBJS1"), StrUtil.df1);//非担保交收(上海)V
					String EN_JYS_FDBJS2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_FDBJS2"), StrUtil.df1);//非担保交收(深圳)V
					String EN_XX_CKZQK = StrUtil.addThousandth0ToEmpty(map.get("EN_XX_CKZQK"), StrUtil.df1);//存款支取款W
					String EN_WJS_JJSH = StrUtil.addThousandth0ToEmpty(map.get("EN_WJS_JJSH"), StrUtil.df1);//基金赎回款X
					String EN_WJS_WXSG = StrUtil.addThousandth0ToEmpty(map.get("EN_WJS_WXSG"), StrUtil.df1);//网下申购退款Y
					String EN_BFJ_TQDJ = StrUtil.addThousandth0ToEmpty(map.get("EN_BFJ_TQDJ"), StrUtil.df1);//备付金保证金提前冻结Z
					String EN_SH_TQDJ = StrUtil.addThousandth0ToEmpty(map.get("EN_SH_TQDJ"), StrUtil.df1);//赎回分红款提前冻结AA
					String EN_FYTQDJ = StrUtil.addThousandth0ToEmpty(map.get("EN_FYTQDJ"), StrUtil.df1);//费用提前冻结AB
					String EN_ZJSGDJ = StrUtil.addThousandth0ToEmpty(map.get("EN_ZJSGDJ"), StrUtil.df1);//资金手工冻结AC
					String EN_ZJJD = StrUtil.addThousandth0ToEmpty(map.get("EN_ZJJD"), StrUtil.df1);//资金手工解冻AD
					String EN_ZJTQ = StrUtil.addThousandth0ToEmpty(map.get("EN_ZJTQ"), StrUtil.df1);//追加提取AE
					String EN_YJXZ = StrUtil.addThousandth0ToEmpty(map.get("EN_YJXZ"), StrUtil.df1);//一级新债AF
					String EN_XYHG = StrUtil.addThousandth0ToEmpty(map.get("EN_XYHG"), StrUtil.df1);//协议回购AG
					String T0_POS = StrUtil.addThousandth0ToEmpty(map.get("T0_POS"), StrUtil.df1);//T+0交易头寸AH
					String T0_POS2 = StrUtil.addThousandth0ToEmpty(map.get("T0_POS2"), StrUtil.df1);//不包含T+1变化的T+0可用AI
					String T1_POS = StrUtil.addThousandth0ToEmpty(map.get("T1_POS"), StrUtil.df1);//T+1交易可用AJ
					String EN_BALANCE1 = StrUtil.addThousandth0ToEmpty(map.get("EN_BALANCE1"), StrUtil.df1);//手工调整金额(1-追加提取)
					String BZ1 = map.get("BZ1");//手工调整备注(1-追加提取)
					String EN_BALANCE2 = StrUtil.addThousandth0ToEmpty(map.get("EN_BALANCE2"), StrUtil.df1);//手工调整金额(2-一级新债)
					String BZ2 = map.get("BZ2");//手工调整备注(2-一级新债)
					String EN_BALANCE3 = StrUtil.addThousandth0ToEmpty(map.get("EN_BALANCE3"), StrUtil.df1);//手工调整金额(3-协议回购)
					String BZ3 = map.get("BZ3");//手工调整备注(3-协议回购)

					obj.setString("L_FUND_ID", L_FUND_ID);//基金序号
					obj.setString("VC_FUNDCODE", VC_FUNDCODE);//基金代码
					obj.setString("VC_FUNDNAME", VC_FUNDNAME);//基金名称
					obj.setString("L_ASSET_ID", L_ASSET_ID);//资产单元序号
					obj.setString("VC_ASSETNAME", VC_ASSETNAME);//资产单元名称
					obj.setString("JYSTC_SH", JYSTC_SH);//交易所头寸情况(上交所)
					obj.setString("JYSTC_SZ", JYSTC_SZ);//交易所头寸情况(深交所)
					obj.setString("T0_BALANCE", T0_BALANCE);//T+0头寸情况F
					obj.setString("T1_BALANCE", T1_BALANCE);//T+1头寸情况G
					obj.setString("EN_YHJ_ZQ", EN_YHJ_ZQ);//当日T+0交易意向H
					obj.setString("EN_YHJ_ZQ_T0CJ", EN_YHJ_ZQ_T0CJ);//当日T+0前台成交I
					obj.setString("EN_YHJ_ZQ_T1CJ", EN_YHJ_ZQ_T1CJ);//昨日T+1资金流入J
					obj.setString("EN_YHJ_RQGH", EN_YHJ_RQGH);//当日逆回购到期K
					obj.setString("EN_YHJ_DXDF", EN_YHJ_DXDF);//当日债券兑付兑息L
					obj.setString("EN_YHJ_TQDJ", EN_YHJ_TQDJ);//次日正回购到期提前冻结M
					obj.setString("EN_JYS_ZLZY1", EN_JYS_ZLZY1);//指令占用(上海)O
					obj.setString("EN_JYS_ZLZY2", EN_JYS_ZLZY2);//指令占用(深圳)O
					obj.setString("EN_JYS_QZMM1", EN_JYS_QZMM1);//股票权证买卖(上海)P
					obj.setString("EN_JYS_QZMM2", EN_JYS_QZMM2);//股票权证买卖(深圳)P
					obj.setString("EN_JYS_ZQMM1", EN_JYS_ZQMM1);//债券买卖(上海)Q
					obj.setString("EN_JYS_ZQMM2", EN_JYS_ZQMM2);//债券买卖(深圳)Q
					obj.setString("EN_JYS_RZHG1", EN_JYS_RZHG1);//正回购首期(上海)R
					obj.setString("EN_JYS_RZHG2", EN_JYS_RZHG2);//正回购首期(深圳)R
					obj.setString("EN_JYS_RZGH1", EN_JYS_RZGH1);//正回购到期(上海)S
					obj.setString("EN_JYS_RZGH2", EN_JYS_RZGH2);//正回购到期(深圳)S
					obj.setString("EN_JYS_RQHG1", EN_JYS_RQHG1);//逆回购首期(上海)T
					obj.setString("EN_JYS_RQHG2", EN_JYS_RQHG2);//逆回购首期(深圳)T
					obj.setString("EN_JYS_RQGH1", EN_JYS_RQGH1);//逆回购到期(上海)U
					obj.setString("EN_JYS_RQGH2", EN_JYS_RQGH2);//逆回购到期(深圳)U
					obj.setString("EN_JYS_FDBJS1", EN_JYS_FDBJS1);//非担保交收(上海)V
					obj.setString("EN_JYS_FDBJS2", EN_JYS_FDBJS2);//非担保交收(深圳)V
					obj.setString("EN_XX_CKZQK", EN_XX_CKZQK);//存款支取款W
					obj.setString("EN_WJS_JJSH", EN_WJS_JJSH);//基金赎回款X
					obj.setString("EN_WJS_WXSG", EN_WJS_WXSG);//网下申购退款Y
					obj.setString("EN_BFJ_TQDJ", EN_BFJ_TQDJ);//备付金保证金提前冻结Z
					obj.setString("EN_SH_TQDJ", EN_SH_TQDJ);//赎回分红款提前冻结AA
					obj.setString("EN_FYTQDJ", EN_FYTQDJ);//费用提前冻结AB
					obj.setString("EN_ZJSGDJ", EN_ZJSGDJ);//资金手工冻结AC
					obj.setString("EN_ZJJD", EN_ZJJD);//资金手工解冻AD
					obj.setString("EN_ZJTQ", EN_ZJTQ);//追加提取AE
					obj.setString("EN_YJXZ", EN_YJXZ);//一级新债AF
					obj.setString("EN_XYHG", EN_XYHG);//协议回购AG
					obj.setString("T0_POS", T0_POS);//T+0交易头寸AH
					obj.setString("T0_POS2", T0_POS2);//不包含T+1变化的T+0可用AI
					obj.setString("T1_POS", T1_POS);//T+1交易可用AJ
					obj.setString("EN_BALANCE1", EN_BALANCE1);//手工调整金额(1-追加提取)
					obj.setString("BZ1", BZ1);//手工调整备注(1-追加提取)
					obj.setString("EN_BALANCE2", EN_BALANCE2);//手工调整金额(2-一级新债)
					obj.setString("BZ2", BZ2);//手工调整备注(2-一级新债)
					obj.setString("EN_BALANCE3", EN_BALANCE3);//手工调整金额(3-协议回购)
					obj.setString("BZ3", BZ3);//手工调整备注(3-协议回购)

					result.add(obj);
					obj = null;
				}
			}
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
	 * 综合信息查询-手工调整O32头寸检查表1值
	 * @param paramObject 参数条件对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static void updateO32TCJC1(DataObject paramObject){
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<String> sqls = new ArrayList<String>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getProdO32CacheDataSourceName());

			//获取页面传进来的参数条件值
			String lFundIds = paramObject.getString("lFundIds");//基金ID
			String lAssetIds = paramObject.getString("lAssetIds");//资产单元ID
			String eNBalance1s = paramObject.getString("eNBalance1s");//手工调整金额(1-追加提取)
			String BZ1s = StrUtil.changeNull(paramObject.getString("BZ1s"));//备注信息(1-追加提取)
			String eNBalance2s = paramObject.getString("eNBalance2s");//手工调整金额(2-一级新债)
			String BZ2s = StrUtil.changeNull(paramObject.getString("BZ2s"));//备注信息(2-一级新债)
			String eNBalance3s = paramObject.getString("eNBalance3s");//手工调整金额(3-协议回购)
			String BZ3s = StrUtil.changeNull(paramObject.getString("BZ3s"));//备注信息(3-协议回购)

			if(StringUtils.isNotBlank(lFundIds)){
				String[] lFundIdArr = lFundIds.split("@");
				String[] lAssetIdArr = lAssetIds.split("@");
				String[] eNBalance1Arr = eNBalance1s.split("@");
				String[] BZ1Arr = BZ1s.split("@");
				String[] eNBalance2Arr = eNBalance2s.split("@");
				String[] BZ2Arr = BZ2s.split("@");
				String[] eNBalance3Arr = eNBalance3s.split("@");
				String[] BZ3Arr = BZ3s.split("@");

				for(int i=0; i<lFundIdArr.length; i++){
					String lFundId = lFundIdArr[i];
					String lAssetId = lAssetIdArr[i];
					String eNBalance1 = StrUtil.changeNull(eNBalance1Arr[i]).replaceAll(",", "");
					String BZ1 = StrUtil.changeNull(BZ1Arr[i]).replaceAll(ProductProcessUtil.DICT_ID_HS_NO_EXIST, "");
					String eNBalance2 = StrUtil.changeNull(eNBalance2Arr[i]).replaceAll(",", "");
					String BZ2 = StrUtil.changeNull(BZ2Arr[i]).replaceAll(ProductProcessUtil.DICT_ID_HS_NO_EXIST, "");
					String eNBalance3 = StrUtil.changeNull(eNBalance3Arr[i]).replaceAll(",", "");
					String BZ3 = StrUtil.changeNull(BZ3Arr[i]).replaceAll(ProductProcessUtil.DICT_ID_HS_NO_EXIST, "");

					//拼接SQL语句--将原手工调整值写入调整日志表备份
					sb.setLength(0);
					sb.append("insert into o32_cj.TO32_POS_CHECK_SGTZ_LOG ")
					  .append("  (L_FUND_ID, L_ASSET_ID, EN_BALANCE, XGRQ, BZ, TZTYPE) ")
					  .append("  select L_FUND_ID, L_ASSET_ID, EN_BALANCE, XGRQ, BZ, TZTYPE ")
					  .append("    from o32_cj.TO32_POS_CHECK_SGTZ t ")
					  .append("   where 1 = 1 ")
					  .append("     and t.L_FUND_ID = '" + lFundId + "' ")
					  .append("     and t.L_ASSET_ID = '" + lAssetId + "' ");
					sqls.add(sb.toString());

					//拼接SQL语句--删除原手工调整值
					sb.setLength(0);
					sb.append("delete from o32_cj.TO32_POS_CHECK_SGTZ t where t.L_FUND_ID = '" + lFundId + "' and t.L_ASSET_ID = '" + lAssetId + "' ");
					sqls.add(sb.toString());

					//拼接SQL语句--插入新手工调整值(1-追加提取)
					if(StringUtils.isNotBlank(eNBalance1) || StringUtils.isNotBlank(BZ1)){
						sb.setLength(0);
						sb.append("insert into o32_cj.TO32_POS_CHECK_SGTZ ")
						  .append("  (L_FUND_ID, L_ASSET_ID, EN_BALANCE, XGRQ, BZ, TZTYPE) ")
						  .append("values ")
						  .append("  ('" + lFundId + "', '" + lAssetId + "', '" + eNBalance1 + "', sysdate, '" + BZ1 + "', '1') ");
						sqls.add(sb.toString());
					}
					//拼接SQL语句--插入新手工调整值(2-一级新债)
					if(StringUtils.isNotBlank(eNBalance2) || StringUtils.isNotBlank(BZ2)){
						sb.setLength(0);
						sb.append("insert into o32_cj.TO32_POS_CHECK_SGTZ ")
						  .append("  (L_FUND_ID, L_ASSET_ID, EN_BALANCE, XGRQ, BZ, TZTYPE) ")
						  .append("values ")
						  .append("  ('" + lFundId + "', '" + lAssetId + "', '" + eNBalance2 + "', sysdate, '" + BZ2 + "', '2') ");
						sqls.add(sb.toString());
					}
					//拼接SQL语句--插入新手工调整值(3-协议回购)
					if(StringUtils.isNotBlank(eNBalance3) || StringUtils.isNotBlank(BZ3)){
						sb.setLength(0);
						sb.append("insert into o32_cj.TO32_POS_CHECK_SGTZ ")
						  .append("  (L_FUND_ID, L_ASSET_ID, EN_BALANCE, XGRQ, BZ, TZTYPE) ")
						  .append("values ")
						  .append("  ('" + lFundId + "', '" + lAssetId + "', '" + eNBalance3 + "', sysdate, '" + BZ3 + "', '3') ");
						sqls.add(sb.toString());
					}
				}

				JDBCUtil.executeUpdateBatchWithConn(conn, sqls);//执行插入
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			sb.setLength(0);
			sb = null;
			JDBCUtil.releaseResource(conn, null, null);
		}
	}

	/**
	 * 综合信息查询-O32头寸检查表1查询-新（跟queryO32TCJC1方法仅数据源不一致，其他完全一致）
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryO32TCJC1New(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getBakO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_O32TCJC1_NEW)){
				SQL_O32TCJC1_NEW = getFileSql("zhxxcx_o32tcjc1_new.sql");
			}


			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String vCAssetName = paramObject.getString("vCAssetName");//资产单元名称
			String vCSort = paramObject.getString("vCSort"); //排序条件

			//产品ID和资产单元ID
			String combProductIds = paramObject.getString("lFundIds");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String combAssetIds = paramObject.getString("lAssetIds");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			if(!"".equals(combProductIds) && combProductIds!=null){
				//验证是否为   ,,, 格式的数据
				String[] productIds=combProductIds.split(",");
				boolean isNull=true;
				for(int i=0;i<productIds.length;i++){
					if(!"".equals(productIds[i]) && productIds[i]!=null){
						isNull=false;
						break;
					}
				}
				if(isNull==true){
					combProductIds="-1";
					combAssetIds="-1";
				}
			}


			String queryGroupFunIds = paramObject.getString("queryGroupFunIds");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String queryGroupAssetIds = paramObject.getString("queryGroupAssetIds");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔

			if(!"".equals(queryGroupFunIds) && queryGroupFunIds!=null){
				//验证是否为   ,,, 格式的数据
				String[] productIds=queryGroupFunIds.split(",");
				boolean isNull=true;
				for(int i=0;i<productIds.length;i++){
					if(!"".equals(productIds[i]) && productIds[i]!=null){
						isNull=false;
						break;
					}
				}
				if(isNull==true){
					queryGroupFunIds="";
					queryGroupAssetIds="";
				}
			}

			//拼接SQL语句
			sb.append(SQL_O32TCJC1_NEW);
			//新增查询条件
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and t0.VC_FUNDCODE in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vCFundCode)){
				sb.append("   and t0.VC_FUNDCODE in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(combProductIds)){
				sb.append("   and t0.L_FUND_ID in (").append(JDBCUtil.changeInStr(combProductIds)).append(") ");
			}
			if(StringUtils.isNotBlank(combAssetIds)){
				sb.append("   and t0.L_ASSET_ID in (").append(JDBCUtil.changeInStr(combAssetIds)).append(") ");
			}
			//新增反选查询条件-其他
			//queryGroupFunIds,queryGroupAssetIds
			if(StringUtils.isNotBlank(queryGroupFunIds)){
				sb.append("   and t0.L_FUND_ID not in (").append(JDBCUtil.changeInStr(queryGroupFunIds)).append(") ");
			}
			if(StringUtils.isNotBlank(queryGroupAssetIds)){
				sb.append("   and t0.L_ASSET_ID not in (").append(JDBCUtil.changeInStr(queryGroupAssetIds)).append(") ");
			}
			if(StringUtils.isNotBlank(vCAssetName)){
				sb.append("   and t0.VC_ASSETNAME like '%" + vCAssetName + "%' ");
			}
			//排序SQL语句
			String sqlOrder = " order by ";
			//组装排序SQL语句
			if(StringUtils.isNotBlank(vCSort)){		//判断排序字段是否为空
				//排序字段等于T0_BALANCE_ASC为T+0头寸升序
				if(vCSort.equalsIgnoreCase("T0_BALANCE_ASC")){
					sqlOrder += "t0.T0_BALANCE asc,";
				}
				//排序字段等于T0_BALANCE_DESC为T+0头寸降序
				if(vCSort.equalsIgnoreCase("T0_BALANCE_DESC")){
					sqlOrder += "t0.T0_BALANCE desc,";
				}
				//排序字段等于T1_BALANCE_ASC为T+1头寸升序
				if(vCSort.equalsIgnoreCase("T1_BALANCE_ASC")){
					sqlOrder += "t0.T1_BALANCE asc,";
				}
				//排序字段等于T1_BALANCE_DESC为T+1头寸降序
				if(vCSort.equalsIgnoreCase("T1_BALANCE_DESC")){
					sqlOrder += "t0.T1_BALANCE desc,";
				}
			}
			sqlOrder += "t0.VC_FUNDCODE asc";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");

					String L_FUND_ID = map.get("L_FUND_ID");//基金序号
					String VC_FUNDCODE = map.get("VC_FUNDCODE");//基金代码
					String VC_FUNDNAME = map.get("VC_FUNDNAME");//基金名称
					String L_ASSET_ID = map.get("L_ASSET_ID");//资产单元序号
					String VC_ASSETNAME = map.get("VC_ASSETNAME");//资产单元名称
					String JYSTC_SH = StrUtil.addThousandth0ToEmpty(map.get("JYSTC_SH"), StrUtil.df1);//交易所头寸情况(上交所)
					String JYSTC_SZ = StrUtil.addThousandth0ToEmpty(map.get("JYSTC_SZ"), StrUtil.df1);//交易所头寸情况(深交所)
					String T0_BALANCE = StrUtil.addThousandth0ToEmpty(map.get("T0_BALANCE"), StrUtil.df1);//T+0头寸情况F
					String T1_BALANCE = StrUtil.addThousandth0ToEmpty(map.get("T1_BALANCE"), StrUtil.df1);//T+1头寸情况G
					String EN_YHJ_ZQ = StrUtil.addThousandth0ToEmpty(map.get("EN_YHJ_ZQ"), StrUtil.df1);//当日T+0交易意向H
					String EN_YHJ_ZQ_T0CJ = StrUtil.addThousandth0ToEmpty(map.get("EN_YHJ_ZQ_T0CJ"), StrUtil.df1);//当日T+0前台成交I
					String EN_YHJ_ZQ_T1CJ = StrUtil.addThousandth0ToEmpty(map.get("EN_YHJ_ZQ_T1CJ"), StrUtil.df1);//昨日T+1资金流入J
					String EN_YHJ_RQGH = StrUtil.addThousandth0ToEmpty(map.get("EN_YHJ_RQGH"), StrUtil.df1);//当日逆回购到期K
					String EN_YHJ_DXDF = StrUtil.addThousandth0ToEmpty(map.get("EN_YHJ_DXDF"), StrUtil.df1);//当日债券兑付兑息L
					String EN_YHJ_TQDJ = StrUtil.addThousandth0ToEmpty(map.get("EN_YHJ_TQDJ"), StrUtil.df1);//次日正回购到期提前冻结M
					String EN_JYS_ZLZY1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_ZLZY1"), StrUtil.df1);//指令占用(上海)O
					String EN_JYS_ZLZY2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_ZLZY2"), StrUtil.df1);//指令占用(深圳)O
					String EN_JYS_QZMM1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_QZMM1"), StrUtil.df1);//股票权证买卖(上海)P
					String EN_JYS_QZMM2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_QZMM2"), StrUtil.df1);//股票权证买卖(深圳)P
					String EN_JYS_ZQMM1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_ZQMM1"), StrUtil.df1);//债券买卖(上海)Q
					String EN_JYS_ZQMM2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_ZQMM2"), StrUtil.df1);//债券买卖(深圳)Q
					String EN_JYS_RZHG1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RZHG1"), StrUtil.df1);//正回购首期(上海)R
					String EN_JYS_RZHG2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RZHG2"), StrUtil.df1);//正回购首期(深圳)R
					String EN_JYS_RZGH1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RZGH1"), StrUtil.df1);//正回购到期(上海)S
					String EN_JYS_RZGH2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RZGH2"), StrUtil.df1);//正回购到期(深圳)S
					String EN_JYS_RQHG1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RQHG1"), StrUtil.df1);//逆回购首期(上海)T
					String EN_JYS_RQHG2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RQHG2"), StrUtil.df1);//逆回购首期(深圳)T
					String EN_JYS_RQGH1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RQGH1"), StrUtil.df1);//逆回购到期(上海)U
					String EN_JYS_RQGH2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_RQGH2"), StrUtil.df1);//逆回购到期(深圳)U
					String EN_JYS_FDBJS1 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_FDBJS1"), StrUtil.df1);//非担保交收(上海)V
					String EN_JYS_FDBJS2 = StrUtil.addThousandth0ToEmpty(map.get("EN_JYS_FDBJS2"), StrUtil.df1);//非担保交收(深圳)V
					String EN_XX_CKZQK = StrUtil.addThousandth0ToEmpty(map.get("EN_XX_CKZQK"), StrUtil.df1);//存款支取款W
					String EN_WJS_JJSH = StrUtil.addThousandth0ToEmpty(map.get("EN_WJS_JJSH"), StrUtil.df1);//基金赎回款X
					String EN_WJS_WXSG = StrUtil.addThousandth0ToEmpty(map.get("EN_WJS_WXSG"), StrUtil.df1);//网下申购退款Y
					String EN_BFJ_TQDJ = StrUtil.addThousandth0ToEmpty(map.get("EN_BFJ_TQDJ"), StrUtil.df1);//备付金保证金提前冻结Z
					String EN_SH_TQDJ = StrUtil.addThousandth0ToEmpty(map.get("EN_SH_TQDJ"), StrUtil.df1);//赎回分红款提前冻结AA
					String EN_FYTQDJ = StrUtil.addThousandth0ToEmpty(map.get("EN_FYTQDJ"), StrUtil.df1);//费用提前冻结AB
					String EN_ZJSGDJ = StrUtil.addThousandth0ToEmpty(map.get("EN_ZJSGDJ"), StrUtil.df1);//资金手工冻结AC
					String EN_ZJJD = StrUtil.addThousandth0ToEmpty(map.get("EN_ZJJD"), StrUtil.df1);//资金手工解冻AD
					String EN_ZJTQ = StrUtil.addThousandth0ToEmpty(map.get("EN_ZJTQ"), StrUtil.df1);//追加提取AE
					String EN_YJXZ = StrUtil.addThousandth0ToEmpty(map.get("EN_YJXZ"), StrUtil.df1);//一级新债AF
					String EN_XYHG = StrUtil.addThousandth0ToEmpty(map.get("EN_XYHG"), StrUtil.df1);//协议回购AG
					String T0_POS = StrUtil.addThousandth0ToEmpty(map.get("T0_POS"), StrUtil.df1);//T+0交易头寸AH
					String T0_POS2 = StrUtil.addThousandth0ToEmpty(map.get("T0_POS2"), StrUtil.df1);//不包含T+1变化的T+0可用AI
					String T1_POS = StrUtil.addThousandth0ToEmpty(map.get("T1_POS"), StrUtil.df1);//T+1交易可用AJ
					String EN_BALANCE1 = StrUtil.addThousandth0ToEmpty(map.get("EN_BALANCE1"), StrUtil.df1);//手工调整金额(1-追加提取)
					String BZ1 = map.get("BZ1");//手工调整备注(1-追加提取)
					String EN_BALANCE2 = StrUtil.addThousandth0ToEmpty(map.get("EN_BALANCE2"), StrUtil.df1);//手工调整金额(2-一级新债)
					String BZ2 = map.get("BZ2");//手工调整备注(2-一级新债)
					String EN_BALANCE3 = StrUtil.addThousandth0ToEmpty(map.get("EN_BALANCE3"), StrUtil.df1);//手工调整金额(3-协议回购)
					String BZ3 = map.get("BZ3");//手工调整备注(3-协议回购)
					String EN_ZZS_TQDJT3 = StrUtil.addThousandth0ToEmpty(map.get("EN_ZZS_TQDJT3"), StrUtil.df1);//T+3日冻结资金

					String EN_ZZS_TQDJT4 = StrUtil.addThousandth0ToEmpty(map.get("EN_ZZS_TQDJT4"), StrUtil.df1);//T+4日取消冻结资金
					String EN_DRSGDJ = StrUtil.addThousandth0ToEmpty(map.get("EN_DRSGDJ"), StrUtil.df1);//当日手工冻结
					//判断非0 ，最好的判断是当前日期是否为交易日
					if(EN_ZZS_TQDJT3.isEmpty() && (null != EN_ZZS_TQDJT4)&&(!EN_ZZS_TQDJT4.isEmpty())&&(!EN_ZZS_TQDJT4.equals("0"))){
						EN_ZZS_TQDJT3 = EN_ZZS_TQDJT4;
					}

					obj.setString("L_FUND_ID", L_FUND_ID);//基金序号
					obj.setString("VC_FUNDCODE", VC_FUNDCODE);//基金代码
					obj.setString("VC_FUNDNAME", VC_FUNDNAME);//基金名称
					obj.setString("L_ASSET_ID", L_ASSET_ID);//资产单元序号
					obj.setString("VC_ASSETNAME", VC_ASSETNAME);//资产单元名称
					obj.setString("JYSTC_SH", JYSTC_SH);//交易所头寸情况(上交所)
					obj.setString("JYSTC_SZ", JYSTC_SZ);//交易所头寸情况(深交所)
					obj.setString("T0_BALANCE", T0_BALANCE);//T+0头寸情况F
					obj.setString("T1_BALANCE", T1_BALANCE);//T+1头寸情况G
					obj.setString("EN_YHJ_ZQ", EN_YHJ_ZQ);//当日T+0交易意向H
					obj.setString("EN_YHJ_ZQ_T0CJ", EN_YHJ_ZQ_T0CJ);//当日T+0前台成交I
					obj.setString("EN_YHJ_ZQ_T1CJ", EN_YHJ_ZQ_T1CJ);//昨日T+1资金流入J
					obj.setString("EN_YHJ_RQGH", EN_YHJ_RQGH);//当日逆回购到期K
					obj.setString("EN_YHJ_DXDF", EN_YHJ_DXDF);//当日债券兑付兑息L
					obj.setString("EN_YHJ_TQDJ", EN_YHJ_TQDJ);//次日正回购到期提前冻结M
					obj.setString("EN_JYS_ZLZY1", EN_JYS_ZLZY1);//指令占用(上海)O
					obj.setString("EN_JYS_ZLZY2", EN_JYS_ZLZY2);//指令占用(深圳)O
					obj.setString("EN_JYS_QZMM1", EN_JYS_QZMM1);//股票权证买卖(上海)P
					obj.setString("EN_JYS_QZMM2", EN_JYS_QZMM2);//股票权证买卖(深圳)P
					obj.setString("EN_JYS_ZQMM1", EN_JYS_ZQMM1);//债券买卖(上海)Q
					obj.setString("EN_JYS_ZQMM2", EN_JYS_ZQMM2);//债券买卖(深圳)Q
					obj.setString("EN_JYS_RZHG1", EN_JYS_RZHG1);//正回购首期(上海)R
					obj.setString("EN_JYS_RZHG2", EN_JYS_RZHG2);//正回购首期(深圳)R
					obj.setString("EN_JYS_RZGH1", EN_JYS_RZGH1);//正回购到期(上海)S
					obj.setString("EN_JYS_RZGH2", EN_JYS_RZGH2);//正回购到期(深圳)S
					obj.setString("EN_JYS_RQHG1", EN_JYS_RQHG1);//逆回购首期(上海)T
					obj.setString("EN_JYS_RQHG2", EN_JYS_RQHG2);//逆回购首期(深圳)T
					obj.setString("EN_JYS_RQGH1", EN_JYS_RQGH1);//逆回购到期(上海)U
					obj.setString("EN_JYS_RQGH2", EN_JYS_RQGH2);//逆回购到期(深圳)U
					obj.setString("EN_JYS_FDBJS1", EN_JYS_FDBJS1);//非担保交收(上海)V
					obj.setString("EN_JYS_FDBJS2", EN_JYS_FDBJS2);//非担保交收(深圳)V
					obj.setString("EN_XX_CKZQK", EN_XX_CKZQK);//存款支取款W
					obj.setString("EN_WJS_JJSH", EN_WJS_JJSH);//基金赎回款X
					obj.setString("EN_WJS_WXSG", EN_WJS_WXSG);//网下申购退款Y
					obj.setString("EN_BFJ_TQDJ", EN_BFJ_TQDJ);//备付金保证金提前冻结Z
					obj.setString("EN_SH_TQDJ", EN_SH_TQDJ);//赎回分红款提前冻结AA
					obj.setString("EN_FYTQDJ", EN_FYTQDJ);//费用提前冻结AB
					obj.setString("EN_ZJSGDJ", EN_ZJSGDJ);//资金手工冻结AC
					obj.setString("EN_ZJJD", EN_ZJJD);//资金手工解冻AD
					obj.setString("EN_ZJTQ", EN_ZJTQ);//追加提取AE
					obj.setString("EN_YJXZ", EN_YJXZ);//一级新债AF
					obj.setString("EN_XYHG", EN_XYHG);//协议回购AG
					obj.setString("T0_POS", T0_POS);//T+0交易头寸AH
					obj.setString("T0_POS2", T0_POS2);//不包含T+1变化的T+0可用AI
					obj.setString("T1_POS", T1_POS);//T+1交易可用AJ
					obj.setString("EN_BALANCE1", EN_BALANCE1);//手工调整金额(1-追加提取)
					obj.setString("BZ1", BZ1);//手工调整备注(1-追加提取)
					obj.setString("EN_BALANCE2", EN_BALANCE2);//手工调整金额(2-一级新债)
					obj.setString("BZ2", BZ2);//手工调整备注(2-一级新债)
					obj.setString("EN_BALANCE3", EN_BALANCE3);//手工调整金额(3-协议回购)
					obj.setString("BZ3", BZ3);//手工调整备注(3-协议回购)
					obj.setString("EN_ZZS_TQDJT3", EN_ZZS_TQDJT3);
					obj.setString("EN_DRSGDJ", EN_DRSGDJ);

					// 获取产品分组，持仓，备注信息
					DataObject[] labelDataAll = null;
					DataObject[] groupDataAll = null;
					try {
						ILogicComponent comp = LogicComponentFactory.create("com.cjhxfund.jy.ProductProcess.o32tcjc");
						Object[] objArr = comp.invoke("queryGroupLbaelData", new String[] {"", "", "" });	//调用逻辑流的方法
						if (objArr != null && objArr.length > 0) {
							groupDataAll = (DataObject[]) objArr[0];
							labelDataAll = (DataObject[]) objArr[1];
						}
					} catch (Throwable e) {
						e.printStackTrace();
					}
					// 产品备注信息
					String vcLabelRemarks = "";
					// 产品持仓信息
					String vcLabelPosition = "";
					if(labelDataAll != null && labelDataAll.length>0){
						for(int a=0; a<labelDataAll.length; a++){
							String[] vcLabelSeqSplit2s = (labelDataAll[a].getString("vcLabelSeq")).split("\\.2.");
							String vcLabelSeqSplit2 = "";
							if(vcLabelSeqSplit2s.length == 1){
								vcLabelSeqSplit2 = vcLabelSeqSplit2s[0];
							}else{
								for(int j=0; j<vcLabelSeqSplit2s.length; j++){
									vcLabelSeqSplit2 += vcLabelSeqSplit2s[j];
								}
							}
							String[] vcLabelSeqSplit1s = (labelDataAll[a].getString("vcLabelSeq")).split("\\.1.");
							String vcLabelSeqSplit1 = "";
							if(vcLabelSeqSplit1s.length == 1){
								vcLabelSeqSplit1 = vcLabelSeqSplit1s[0];
							}else{
								for(int h=0; h<vcLabelSeqSplit1s.length; h++){
									vcLabelSeqSplit1 += vcLabelSeqSplit1s[h];
								}
							}
							if(L_FUND_ID.equals(labelDataAll[a].getString("vcProductId")) && L_ASSET_ID.equals(labelDataAll[a].getString("vcAssetId")) && vcLabelSeqSplit2 != labelDataAll[a].getString("vcLabelSeq")){
								vcLabelRemarks = labelDataAll[a].getString("vcLabelName");
							}
							if(L_FUND_ID.equals(labelDataAll[a].getString("vcProductId")) && L_ASSET_ID.equals(labelDataAll[a].getString("vcAssetId")) && vcLabelSeqSplit1 != labelDataAll[a].getString("vcLabelSeq")){
								vcLabelPosition =  labelDataAll[a].getString("vcLabelName");
							}
						}
					}
					// 产品分组信息
					String vcGroup = "";
					if(groupDataAll != null && groupDataAll.length>0){
						for(int b=0; b<groupDataAll.length; b++){
							if(L_FUND_ID.equals(groupDataAll[b].getString("vcProductId")) && L_ASSET_ID.equals(groupDataAll[b].getString("vcAssetId"))){
								vcGroup = groupDataAll[b].getString("vcGroupName");
							}
						}
					}
					/*定义分组、持仓、备注三列，三列数据为空*/
					obj.setString("vcGroup", vcGroup);//分组
					obj.setString("vcLabelPosition", vcLabelPosition);//持仓
					obj.setString("vcLabelRemarks", vcLabelRemarks);//备注

					result.add(obj);
					obj = null;
				}
			}
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
	 * 综合信息查询-手工调整O32头寸检查表1值-新（跟updateO32TCJC1方法仅数据源不一致，其他完全一致）
	 * @param paramObject 参数条件对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static void updateO32TCJC1New(DataObject paramObject){
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<String> sqls = new ArrayList<String>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getBakO32CacheDataSourceName());

			//获取页面传进来的参数条件值
			String lFundIds = paramObject.getString("lFundIds");//基金ID
			String lAssetIds = paramObject.getString("lAssetIds");//资产单元ID
			String eNBalance1s = paramObject.getString("eNBalance1s");//手工调整金额(1-追加提取)
			String BZ1s = StrUtil.changeNull(paramObject.getString("BZ1s"));//备注信息(1-追加提取)
			String eNBalance2s = paramObject.getString("eNBalance2s");//手工调整金额(2-一级新债)
			String BZ2s = StrUtil.changeNull(paramObject.getString("BZ2s"));//备注信息(2-一级新债)
			String eNBalance3s = paramObject.getString("eNBalance3s");//手工调整金额(3-协议回购)
			String BZ3s = StrUtil.changeNull(paramObject.getString("BZ3s"));//备注信息(3-协议回购)

			if(StringUtils.isNotBlank(lFundIds)){
				String[] lFundIdArr = lFundIds.split("@");
				String[] lAssetIdArr = lAssetIds.split("@");
				String[] eNBalance1Arr = eNBalance1s.split("@");
				String[] BZ1Arr = BZ1s.split("@");
				String[] eNBalance2Arr = eNBalance2s.split("@");
				String[] BZ2Arr = BZ2s.split("@");
				String[] eNBalance3Arr = eNBalance3s.split("@");
				String[] BZ3Arr = BZ3s.split("@");

				for(int i=0; i<lFundIdArr.length; i++){
					String lFundId = lFundIdArr[i];
					String lAssetId = lAssetIdArr[i];
					String eNBalance1 = StrUtil.changeNull(eNBalance1Arr[i]).replaceAll(",", "");
					String BZ1 = StrUtil.changeNull(BZ1Arr[i]).replaceAll(ProductProcessUtil.DICT_ID_HS_NO_EXIST, "");
					String eNBalance2 = StrUtil.changeNull(eNBalance2Arr[i]).replaceAll(",", "");
					String BZ2 = StrUtil.changeNull(BZ2Arr[i]).replaceAll(ProductProcessUtil.DICT_ID_HS_NO_EXIST, "");
					String eNBalance3 = StrUtil.changeNull(eNBalance3Arr[i]).replaceAll(",", "");
					String BZ3 = StrUtil.changeNull(BZ3Arr[i]).replaceAll(ProductProcessUtil.DICT_ID_HS_NO_EXIST, "");

					//拼接SQL语句--将原手工调整值写入调整日志表备份
					sb.setLength(0);
					sb.append("insert into o32_cj.TO32_POS_CHECK_SGTZ_LOG ")
					  .append("  (L_FUND_ID, L_ASSET_ID, EN_BALANCE, XGRQ, BZ, TZTYPE) ")
					  .append("  select L_FUND_ID, L_ASSET_ID, EN_BALANCE, XGRQ, BZ, TZTYPE ")
					  .append("    from o32_cj.TO32_POS_CHECK_SGTZ t ")
					  .append("   where 1 = 1 ")
					  .append("     and t.L_FUND_ID = '" + lFundId + "' ")
					  .append("     and t.L_ASSET_ID = '" + lAssetId + "' ");
					sqls.add(sb.toString());

					//拼接SQL语句--删除原手工调整值
					sb.setLength(0);
					sb.append("delete from o32_cj.TO32_POS_CHECK_SGTZ t where t.L_FUND_ID = '" + lFundId + "' and t.L_ASSET_ID = '" + lAssetId + "' ");
					sqls.add(sb.toString());

					//拼接SQL语句--插入新手工调整值(1-追加提取)
					if(StringUtils.isNotBlank(eNBalance1) || StringUtils.isNotBlank(BZ1)){
						sb.setLength(0);
						sb.append("insert into o32_cj.TO32_POS_CHECK_SGTZ ")
						  .append("  (L_FUND_ID, L_ASSET_ID, EN_BALANCE, XGRQ, BZ, TZTYPE) ")
						  .append("values ")
						  .append("  ('" + lFundId + "', '" + lAssetId + "', '" + eNBalance1 + "', sysdate, '" + BZ1 + "', '1') ");
						sqls.add(sb.toString());
					}
					//拼接SQL语句--插入新手工调整值(2-一级新债)
					if(StringUtils.isNotBlank(eNBalance2) || StringUtils.isNotBlank(BZ2)){
						sb.setLength(0);
						sb.append("insert into o32_cj.TO32_POS_CHECK_SGTZ ")
						  .append("  (L_FUND_ID, L_ASSET_ID, EN_BALANCE, XGRQ, BZ, TZTYPE) ")
						  .append("values ")
						  .append("  ('" + lFundId + "', '" + lAssetId + "', '" + eNBalance2 + "', sysdate, '" + BZ2 + "', '2') ");
						sqls.add(sb.toString());
					}
					//拼接SQL语句--插入新手工调整值(3-协议回购)
					if(StringUtils.isNotBlank(eNBalance3) || StringUtils.isNotBlank(BZ3)){
						sb.setLength(0);
						sb.append("insert into o32_cj.TO32_POS_CHECK_SGTZ ")
						  .append("  (L_FUND_ID, L_ASSET_ID, EN_BALANCE, XGRQ, BZ, TZTYPE) ")
						  .append("values ")
						  .append("  ('" + lFundId + "', '" + lAssetId + "', '" + eNBalance3 + "', sysdate, '" + BZ3 + "', '3') ");
						sqls.add(sb.toString());
					}
				}

				JDBCUtil.executeUpdateBatchWithConn(conn, sqls);//执行插入
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			sb.setLength(0);
			sb = null;
			JDBCUtil.releaseResource(conn, null, null);
		}
	}

	/**
	 * 综合信息查询-恒生估值系统估值表
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryHSFAGZB(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取估值系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_SJZX);
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_HSFAGZB)){
				SQL_HSFAGZB = getFileSql("zhxxcx_hsfagzb.sql");
			}

			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String busiDateEnd = DateUtil.format(paramObject.getDate("busiDateEnd"), DateUtil.YMD_NUMBER);//截至业务日期
			String busiDateBegin = null;
			if(paramObject.getString("busiDateBegin") == null || ("null").equals(paramObject.getString("busiDateBegin"))){
				busiDateBegin = busiDateEnd;
			}else{
				busiDateBegin = DateUtil.format(paramObject.getDate("busiDateBegin"), DateUtil.YMD_NUMBER);//开始业务日期
			}

			String vCKmdm = paramObject.getString("vCKmdm");//科目代码
			String vCKmmc = paramObject.getString("vCKmmc");//科目名称

			//拼接SQL语句
			sb.append(SQL_HSFAGZB);
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and t.VC_CPDM in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vCFundCode)){
				sb.append("   and t.VC_CPDM in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(busiDateBegin)){
				sb.append("   and to_char(t.d_ywrq, 'yyyyMMdd') >= '" + busiDateBegin + "'");
			}
			if(StringUtils.isNotBlank(busiDateEnd)){
				sb.append("   and to_char(t.d_ywrq, 'yyyyMMdd') <= '" + busiDateEnd + "'");
			}
			if(StringUtils.isNotBlank(vCKmdm)){
				sb.append("   and t.vc_kmdm like '" + vCKmdm + "%'");
			}
			if(StringUtils.isNotBlank(vCKmmc)){
				sb.append("   and t.vc_kmmc like '%" + vCKmmc + "%'");
			}

			//排序SQL语句
			String sqlOrder = " order by t.d_ywrq desc,t.vc_cpdm asc, t.l_bh asc";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					//创建实体对象
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");

					//获取参数值
					String VC_KMDM = map.get("VC_KMDM");   //科目代码
					String VC_KMMC = map.get("VC_KMMC");   //科目名称
					String L_SL = StrUtil.addThousandth0ToEmpty(map.get("L_SL"), StrUtil.df1);   //数量
					String EN_DWCB = StrUtil.addThousandth0ToEmpty(map.get("EN_DWCB"), StrUtil.df1);  //单位成本
					String EN_CB = StrUtil.addThousandth0ToEmpty(map.get("EN_CB"), StrUtil.df1);  //成本
					String EN_CBZJZ = StrUtil.addThousandth0ToEmpty(map.get("EN_CBZJZ"), StrUtil.df1); //成本占净值
					String EN_HQJZ = StrUtil.addThousandth0ToEmpty(map.get("EN_HQJZ"), StrUtil.df1); //行情价格
					String EN_SZ = StrUtil.addThousandth0ToEmpty(map.get("EN_SZ"), StrUtil.df1); //市值
					String EN_SZZJZ = StrUtil.addThousandth0ToEmpty(map.get("EN_SZZJZ"), StrUtil.df1); //市值占净值
					String EN_GZZZ = StrUtil.addThousandth0ToEmpty(map.get("EN_GZZZ"), StrUtil.df1); //估值增值
					String VC_TPXX = map.get("VC_TPXX"); //停牌信息

					//给对象赋值
					obj.setString("VC_KMDM", VC_KMDM);
					obj.setString("VC_KMMC", VC_KMMC);
					obj.setString("L_SL", L_SL);
					obj.setString("EN_DWCB", EN_DWCB);
					obj.setString("EN_CB", EN_CB);
					obj.setString("EN_CBZJZ", EN_CBZJZ);
					obj.setString("EN_HQJZ", EN_HQJZ);
					obj.setString("EN_SZ", EN_SZ);
					obj.setString("EN_SZZJZ", EN_SZZJZ);
					obj.setString("EN_GZZZ", EN_GZZZ);
					obj.setString("VC_TPXX",VC_TPXX);
					result.add(obj);
					obj = null;
				}
			}
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
	 * 综合信息查询-自动化头寸表查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryZDHTCB(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		StringBuffer sbs = new StringBuffer();
		String sqlOrder = "";
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_ZDHTCB)){
				SQL_ZDHTCB = getFileSql("zhxxcx_zdhtcb.sql");
			}
			//获取AK金额中（1 托管户，6 上清DVP，7 中债DVP）任意一项为负数的产品CODE的SQL语句
			if(StringUtils.isEmpty(SQL_ZDHTCB_CODE)){
				SQL_ZDHTCB_CODE = getFileSql("zhxxcx_zdhtcb_code.sql");
			}
			//产品筛选
			if(StringUtil.isEmpty(SQL_ZDHTCB_PROD)){
				SQL_ZDHTCB_PROD= getFileSql("zhxxcx_zdhtcb_prod.sql");
			}
			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String exclusivelyShowSection = paramObject.getString("exclusivelyShowSection");//是否只显示AK余额为负数,并且是"托管户"/"上清DVP"/"中债DVP"任意一种
			//拼接SQL语句

			//普通查询
			if("1".equals(exclusivelyShowSection)){
				sb.append(SQL_ZDHTCB);
				if(StringUtils.isNotBlank(combProductCodes)){
					sb.append("   and t1.vc_fund_code in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
				}
				if(StringUtils.isNotBlank(vCFundCode)){
					sb.append("   and t1.vc_fund_code in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
				}
				//排序SQL语句
				sqlOrder = " order by t1.l_fund_id, t1.xh";
			}

			//筛选查询
			if("2".equals(exclusivelyShowSection)){
				sbs.append(SQL_ZDHTCB_CODE);
				//获取AK金额中（1 托管户，6 上清DVP，7 中债DVP）任意一项为负数的产品CODE
				String vcFundCode = JDBCUtil.getListValueBySql(conn,sbs.toString());

			    if(!vcFundCode.isEmpty()){
			    	sb.append(SQL_ZDHTCB);
					//拼接查询条件为AK金额中（1 托管户，6 上清DVP，7 中债DVP）任意一项为负数的产品CODE
					sb.append("   and t1.vc_fund_code in (").append(JDBCUtil.changeInStr(vcFundCode)).append(") ");
					//拼接查询条件"1 托管户"/"6 上清DVP"/"7 中债DVP"
					sb.append( "and t1.xh in (1, 6, 7,8)");
					//排序SQL语句
					sqlOrder = " order by t1.l_fund_id, t1.xh";
			    }
			}
			//筛选查询
			if("3".equals(exclusivelyShowSection)){
				//拼接SQL语句
				sbs.append("select t1.vc_fund_code")//产品代码
				  .append("  from o32_cj.to32_js_rs t1 ")
				  .append(" where 1 = 1 ")
				  .append(" 	and t1.ak_col < 0 ")
				  .append(" 	and t1.xh = 1 ");
				//获取AK金额中 托管户为负数的产品CODE
				String vcFundCodeTGH = JDBCUtil.getListValueBySql(conn,sbs.toString());

			    if(!vcFundCodeTGH.isEmpty()){
			    	sb.append(SQL_ZDHTCB);
					//拼接查询条件为AK金额中托管户为负数的产品CODE
					sb.append("   and t1.vc_fund_code in (").append(JDBCUtil.changeInStr(vcFundCodeTGH)).append(") ");
					//拼接查询条件"1 托管户"/"6 上清DVP"/"7 中债DVP"
					sb.append( "and t1.xh in (1, 6, 7,8)");
					//排序SQL语句
					sqlOrder = " order by t1.l_fund_id, t1.xh";
			    }
			}
			//产品筛选
			if("4".equals(exclusivelyShowSection)){
				sbs.append(SQL_ZDHTCB_PROD);
				String fundIdStr=JDBCUtil.getListValueBySql(conn, sbs.toString());
				if(!StringUtil.isEmpty(fundIdStr)){
					sb.append(SQL_ZDHTCB);
					//拼接查询条件为AK金额中（1 托管户，6 上清DVP，7 中债DVP）任意一项为负数的产品CODE
					sb.append("   and t1.l_fund_id in (").append(JDBCUtil.changeInStr(fundIdStr)).append(") ");
					//拼接查询条件"1 托管户"/"6 上清DVP"/"7 中债DVP"
					sb.append( "and t1.xh in (1, 6, 7,8)");
					//排序SQL语句
					sqlOrder = " order by t1.l_fund_id, t1.xh";
				}
			}

			if(sb.length()>0 && StringUtils.isNotBlank(sb.toString())){
				//查询结果集
				List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
				if(!list.isEmpty() && list.size()>0){
					for(int i=0; i<list.size(); i++){
						Map<String, String> map = list.get(i);
						String L_FUND_ID = map.get("L_FUND_ID");//基金ID
						String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
						String VC_FUND_NAME = StrUtil.changeNull(map.get("VC_FUND_NAME")).trim().replace("（", "(").replace("）", ")");//基金名称
						String XH = map.get("XH");//序号
						String BZ = map.get("BZ");//备注
						String D_COL = StrUtil.addThousandth(map.get("D_COL"), StrUtil.df1);//D 期初余额
						String F_COL = StrUtil.addThousandth(map.get("F_COL"), StrUtil.df1);//F 银行间正回购，首次结算日为当日，金额为正
						String G_COL = StrUtil.addThousandth(map.get("G_COL"), StrUtil.df1);//G 银行间逆回购，首次结算日为当日，金额为负
						String H_COL = StrUtil.addThousandth(map.get("H_COL"), StrUtil.df1);//H T日成交的T+0银行间买券,结算日为当日，金额为负
						String I_COL = StrUtil.addThousandth(map.get("I_COL"), StrUtil.df1);//I T日成交的T+0银行间卖券,结算日为当日，金额为正
						String J_COL = StrUtil.addThousandth(map.get("J_COL"), StrUtil.df1);//J 银行间正回购到期，到期结算日为当日，金额为负
						String K_COL = StrUtil.addThousandth(map.get("K_COL"), StrUtil.df1);//K 银行间逆回购到期，到期结算日为当日，金额为正
						String L_COL = StrUtil.addThousandth(map.get("L_COL"), StrUtil.df1);//L T-1日成交的T+1交收的银行间买券，结算日为当日，金额为负
						String M_COL = StrUtil.addThousandth(map.get("M_COL"), StrUtil.df1);//M T-1日成交的T+1交收的银行间卖券，结算日为当日，金额为正
						String N_COL = StrUtil.addThousandth(map.get("N_COL"), StrUtil.df1);//N 银行间分销，金额为负
						String O_COL = StrUtil.addThousandth(map.get("O_COL"), StrUtil.df1);//O 交易所分销，金额为负
						String P_COL = StrUtil.addThousandth(map.get("P_COL"), StrUtil.df1);//P 基金申购，金额为负
						String Q_COL = StrUtil.addThousandth(map.get("Q_COL"), StrUtil.df1);//Q 基金赎回，赎回到账日为当日，金额为正
						String R_COL = StrUtil.addThousandth(map.get("R_COL"), StrUtil.df1);//R 红利到账，金额为正
						String S_COL = StrUtil.addThousandth(map.get("S_COL"), StrUtil.df1);//S 期货户入金,期货保证金调整的期货保证金增加，金额为负
						String T_COL = StrUtil.addThousandth(map.get("T_COL"), StrUtil.df1);//T 期货户出金,期货保证金调整的期货保证金减少，金额为正
						String U_COL = StrUtil.addThousandth(map.get("U_COL"), StrUtil.df1);//U 同业存款，即定期存款，金额为负
						String V_COL = StrUtil.addThousandth(map.get("V_COL"), StrUtil.df1);//V 同业存款到期，即定期存款到期，到期日为当日，金额为正
						String W_COL = StrUtil.addThousandth(map.get("W_COL"), StrUtil.df1);//W 当日债券兑付/付息（沪深），金额为正
						String X_COL = StrUtil.addThousandth(map.get("X_COL"), StrUtil.df1);//X 当日债券兑付/付息（非沪深），金额为正
						String Y_COL = StrUtil.addThousandth(map.get("Y_COL"), StrUtil.df1);//Y 追加，即当日资金管理手工增加资金，金额为正
						String Z_COL = StrUtil.addThousandth(map.get("Z_COL"), StrUtil.df1);//Z 提取，即当日资金管理手工减少资金，金额为负
						String AA_COL = StrUtil.addThousandth(map.get("AA_COL"), StrUtil.df1);//AA 当日TA申购，金额为正
						String AB_COL = StrUtil.addThousandth(map.get("AB_COL"), StrUtil.df1);//AB TA赎回，赎回款到账日为当日，金额为负
						String AC_COL = StrUtil.addThousandth(map.get("AC_COL"), StrUtil.df1);//AC 网下申购，金额为负
						String AD_COL = StrUtil.addThousandth(map.get("AD_COL"), StrUtil.df1);//AD 网下申购退款，金额为正
						String AE_COL = StrUtil.addThousandth(map.get("AE_COL"), StrUtil.df1);//AE RTGS非担保卖券,清算速度T+0，金额为正
						String AL_COL = StrUtil.addThousandth(map.get("AL_COL"), StrUtil.df1);//AL 费用支付，金额为负
						String AM_COL = StrUtil.addThousandth(map.get("AM_COL"), StrUtil.df1);//AM 新股配售交收，金额为负
						String AF_COL = StrUtil.addThousandth(map.get("AF_COL"), StrUtil.df1);//AF RTGS非担保买券,清算速度T+0，金额为负
						String AG_COL = StrUtil.addThousandth(map.get("AG_COL"), StrUtil.df1);//AG 调款
						String AI_COL = StrUtil.addThousandth(map.get("AI_COL"), StrUtil.df1);//AI 手工调整1
						String AJ_COL = StrUtil.addThousandth(map.get("AJ_COL"), StrUtil.df1);//AJ 手工调整2
						String AK_COL = StrUtil.addThousandth(map.get("AK_COL"), StrUtil.df1);//AK 余额
						String AN_COL = StrUtil.addThousandth(map.get("AN_COL"), StrUtil.df1);//AN 资金冻结，金额为正
						String AO_COL = StrUtil.addThousandth(map.get("AO_COL"), StrUtil.df1);//AO 资金冻结取消,金额为正
						String AP_COL = StrUtil.addThousandth(map.get("AP_COL"), StrUtil.df1);//AP 资金增加,金额为正
						String EN_BALANCE = StrUtil.addThousandth0ToEmpty(map.get("TZJE"), StrUtil.df1);//手工调整金额
						String SGTZ_BZ = map.get("SGTZ_BZ");//手工调整备注
						String AM1_COL = StrUtil.addThousandth0ToEmpty(map.get("AM1_COL"), StrUtil.df1);//AM1机器猫当日下单的追加,金额为正
						String AM2_COL = StrUtil.addThousandth0ToEmpty(map.get("AM2_COL"), StrUtil.df1);//AM2机器猫当日下单的提取,金额为正

						obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");

						//给对象赋值
						obj.setString("L_FUND_ID", L_FUND_ID);
						obj.setString("VC_FUND_CODE", VC_FUND_CODE);
						obj.setString("VC_FUND_NAME", VC_FUND_NAME);
						obj.setString("XH", XH);
						obj.setString("BZ", BZ);
						obj.setString("D_COL", D_COL);
						obj.setString("F_COL", F_COL);
						obj.setString("G_COL", G_COL);
						obj.setString("H_COL", H_COL);
						obj.setString("I_COL", I_COL);
						obj.setString("J_COL", J_COL);
						obj.setString("K_COL", K_COL);
						obj.setString("L_COL", L_COL);
						obj.setString("M_COL", M_COL);
						obj.setString("N_COL", N_COL);
						obj.setString("O_COL", O_COL);
						obj.setString("P_COL", P_COL);
						obj.setString("Q_COL", Q_COL);
						obj.setString("R_COL", R_COL);
						obj.setString("S_COL", S_COL);
						obj.setString("T_COL", T_COL);
						obj.setString("U_COL", U_COL);
						obj.setString("V_COL", V_COL);
						obj.setString("W_COL", W_COL);
						obj.setString("X_COL", X_COL);
						obj.setString("Y_COL", Y_COL);
						obj.setString("Z_COL", Z_COL);
						obj.setString("AA_COL", AA_COL);
						obj.setString("AB_COL", AB_COL);
						obj.setString("AC_COL", AC_COL);
						obj.setString("AD_COL", AD_COL);
						obj.setString("AL_COL", AL_COL);
						obj.setString("AM_COL", AM_COL);
						obj.setString("AE_COL", AE_COL);
						obj.setString("AF_COL", AF_COL);
						obj.setString("AG_COL", AG_COL);
						obj.setString("AI_COL", AI_COL);
						obj.setString("AJ_COL", AJ_COL);
						obj.setString("AK_COL", AK_COL);
						obj.setString("AN_COL", AN_COL);
						obj.setString("AO_COL", AO_COL);
						obj.setString("AP_COL", AP_COL);
						obj.setString("EN_BALANCE", EN_BALANCE);
						obj.setString("SGTZ_BZ", SGTZ_BZ);
						obj.setString("AM1_COL", AM1_COL);
						obj.setString("AM2_COL", AM2_COL);
						result.add(obj);
						obj = null;
					}
				}
			}
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
	 * 综合信息查询-自动化头寸表-自动化头寸表明细查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryZDHTCBDetail(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_ZDHTCB_DETAIL)){
				SQL_ZDHTCB_DETAIL = getFileSql("zhxxcx_zdhtcb_detail.sql");
			}

			//获取页面传进来的查询条件值
			String vCFundId = paramObject.getString("vCFundId");//基金ID
			String busiDesc = paramObject.getString("busiDesc"); //指标描述


			//拼接SQL语句
			sb.append(SQL_ZDHTCB_DETAIL);
			if(StringUtils.isNotBlank(vCFundId)){
				sb.append("   and t.l_fund_id in (").append(JDBCUtil.changeInStr(vCFundId)).append(") ");
			}
			if(StringUtils.isNotBlank(busiDesc)){
				sb.append("   and t.busi_desc like '%" + busiDesc +"%'");
			}
			//排序SQL语句
			String sqlOrder = "";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String EN_BALANCE = map.get("EN_BALANCE"); //指标金额
					String BZ = map.get("BZ"); //备注
					String BUSI_DESC = map.get("BUSI_DESC"); //指标描述

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("EN_BALANCE", EN_BALANCE);
					obj.setString("BZ", BZ);
					obj.setString("BUSI_DESC", BUSI_DESC);
					result.add(obj);
					obj = null;
				}
			}
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
	 * 综合信息查询-自动化头寸表-自动化头寸表明细查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author wzx
	 */
	@Bizlet("")
	public static List<DataObject> queryZDHTCBDetail2(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_ZDHTCB_DETAIL)){
				SQL_ZDHTCB_DETAIL = getFileSql("zhxxcx_zdhtcb_detail2.sql");
			}

			//获取页面传进来的查询条件值
			String vCFundId = paramObject.getString("vCFundId");//基金ID
			String busiDesc = paramObject.getString("busiDesc"); //指标描述


			//拼接SQL语句
			sb.append(SQL_ZDHTCB_DETAIL);
			if(StringUtils.isNotBlank(vCFundId)){
				sb.append("   and t.l_fund_id in (").append(JDBCUtil.changeInStr(vCFundId)).append(") ");
			}
			if(StringUtils.isNotBlank(busiDesc)){
				sb.append("   and t.busi_desc like '%" + busiDesc +"%'");
			}
			//排序SQL语句
			String sqlOrder = "";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String EN_BALANCE = map.get("EN_BALANCE"); //指标金额
					String BZ = map.get("BZ"); //备注
					String BUSI_DESC = map.get("BUSI_DESC"); //指标描述

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("EN_BALANCE", EN_BALANCE);
					obj.setString("BZ", BZ);
					obj.setString("BUSI_DESC", BUSI_DESC);
					result.add(obj);
					obj = null;
				}
			}
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
	 * 综合信息查询-手工调整自动化头寸表值
	 * @param paramObject 参数条件对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static void updateZDHTCB(DataObject paramObject){
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<String> sqls = new ArrayList<String>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getProdO32CacheDataSourceName());

			//获取页面传进来的参数条件值
			String lFundIds = paramObject.getString("lFundIds");//基金序号
			String XHs = paramObject.getString("XHs");//序号
			String TZJEs = paramObject.getString("TZJEs");//手工调整金额
			String BZs = StrUtil.changeNull(paramObject.getString("BZs"));//备注信息

			if(StringUtils.isNotBlank(lFundIds)){
				String[] lFundIdArr = lFundIds.split("@");
				String[] XHArr = XHs.split("@");
				String[] TZJEArr = TZJEs.split("@");
				String[] BZArr = BZs.split("@");

				for(int i=0; i<lFundIdArr.length; i++){
					String lFundId = lFundIdArr[i];
					String XH = XHArr[i];
					String TZJE = StrUtil.changeNull(TZJEArr[i]).replaceAll(",", "");
					String BZ = StrUtil.changeNull(BZArr[i]).replaceAll(ProductProcessUtil.DICT_ID_HS_NO_EXIST, "");

					//拼接SQL语句--将原手工调整值写入调整日志表备份
					sb.setLength(0);
					sb.append("insert into o32_cj.TO32_JS_SGTZ_LOG ")
					  .append("  (L_FUND_ID, XH, TZJE, TZSJ, BZ) ")
					  .append("  select L_FUND_ID, XH, TZJE, TZSJ, BZ ")
					  .append("    from o32_cj.TO32_JS_SGTZ t ")
					  .append("   where 1 = 1 ")
					  .append("     and t.l_fund_id = '" + lFundId + "' ")
					  .append("     and t.xh = '" + XH + "' ");
					sqls.add(sb.toString());

					//拼接SQL语句--删除原手工调整值
					sb.setLength(0);
					sb.append("delete from o32_cj.TO32_JS_SGTZ t where t.l_fund_id = '" + lFundId + "' and t.xh = '" + XH + "' ");
					sqls.add(sb.toString());

					//拼接SQL语句--插入新手工调整值
					sb.setLength(0);
					sb.append("insert into o32_cj.TO32_JS_SGTZ ")
					  .append("  (L_FUND_ID, XH, TZJE, TZSJ, BZ) ")
					  .append("values ")
					  .append("  ('" + lFundId + "', '" + XH + "', '" + TZJE + "', sysdate, '" + BZ + "') ");
					sqls.add(sb.toString());
				}
				JDBCUtil.executeUpdateBatchWithConn(conn, sqls);//执行插入
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			sb.setLength(0);
			sb = null;
			JDBCUtil.releaseResource(conn, null, null);
		}
	}

	/**
	 * 综合信息查询-自动化头寸表查询-新
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryZDHTCBNew(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		StringBuffer sbs = new StringBuffer();
		String sqlOrder = "";
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getBakO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_ZDHTCB_NEW)){
				SQL_ZDHTCB_NEW = getFileSql("zhxxcx_zdhtcb_new.sql");
			}
			//获取AK金额中（1 托管户，6 上清DVP，7 中债DVP）任意一项为负数的产品CODE的SQL语句
			if(StringUtils.isEmpty(SQL_ZDHTCB_CODE_NEW)){
				SQL_ZDHTCB_CODE_NEW = getFileSql("zhxxcx_zdhtcb_code_new.sql");
			}
			//产品筛选
			if(StringUtil.isEmpty(SQL_ZDHTCB_PROD_NEW)){
				SQL_ZDHTCB_PROD_NEW= getFileSql("zhxxcx_zdhtcb_prod_new.sql");
			}
			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String exclusivelyShowSection = paramObject.getString("exclusivelyShowSection");//是否只显示AK余额为负数,并且是"托管户"/"上清DVP"/"中债DVP"任意一种
			//拼接SQL语句

			//普通查询
			if("1".equals(exclusivelyShowSection)){
				sb.append(SQL_ZDHTCB_NEW);
				if(StringUtils.isNotBlank(combProductCodes)){
					sb.append("   and t1.vc_fund_code in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
				}
				if(StringUtils.isNotBlank(vCFundCode)){
					sb.append("   and t1.vc_fund_code in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
				}
				//排序SQL语句
				sqlOrder = " order by t1.l_fund_id, t1.xh";
			}

			//筛选查询
			if("2".equals(exclusivelyShowSection)){
				sbs.append(SQL_ZDHTCB_CODE_NEW);
				//获取AK金额中（1 托管户，6 上清DVP，7 中债DVP）任意一项为负数的产品CODE
				String vcFundCode = JDBCUtil.getListValueBySql(conn,sbs.toString());

			    if(!vcFundCode.isEmpty()){
			    	sb.append(SQL_ZDHTCB_NEW);
					//拼接查询条件为AK金额中（1 托管户，6 上清DVP，7 中债DVP）任意一项为负数的产品CODE
					sb.append("   and t1.vc_fund_code in (").append(JDBCUtil.changeInStr(vcFundCode)).append(") ");
					//拼接查询条件"1 托管户"/"6 上清DVP"/"7 中债DVP"
					sb.append( "and t1.xh in (1, 6, 7,8)");
					//排序SQL语句
					sqlOrder = " order by t1.l_fund_id, t1.xh";
			    }
			}
			//筛选查询
			if("3".equals(exclusivelyShowSection)){
				//拼接SQL语句
				sbs.append("select t1.vc_fund_code")//产品代码
				  .append("  from o32_cj.to32_js_rs t1 ")
				  .append(" where 1 = 1 ")
				  .append(" 	and t1.ak_col < 0 ")
				  .append(" 	and t1.xh = 1 ");
				//获取AK金额中 托管户为负数的产品CODE
				String vcFundCodeTGH = JDBCUtil.getListValueBySql(conn,sbs.toString());

			    if(!vcFundCodeTGH.isEmpty()){
			    	sb.append(SQL_ZDHTCB_NEW);
					//拼接查询条件为AK金额中托管户为负数的产品CODE
					sb.append("   and t1.vc_fund_code in (").append(JDBCUtil.changeInStr(vcFundCodeTGH)).append(") ");
					//拼接查询条件"1 托管户"/"6 上清DVP"/"7 中债DVP"
					sb.append( "and t1.xh in (1, 6, 7,8)");
					//排序SQL语句
					sqlOrder = " order by t1.l_fund_id, t1.xh";
			    }
			}

			//产品筛选
			if("4".equals(exclusivelyShowSection)){
				sbs.append(SQL_ZDHTCB_PROD_NEW);
				String fundIdStr=JDBCUtil.getListValueBySql(conn, sbs.toString());
				if(!StringUtil.isEmpty(fundIdStr)){
					sb.append(SQL_ZDHTCB_NEW);
					//拼接查询条件为AK金额中（1 托管户，6 上清DVP，7 中债DVP）任意一项为负数的产品CODE
					sb.append("   and t1.l_fund_id in (").append(JDBCUtil.changeInStr(fundIdStr)).append(") ");
					//拼接查询条件"1 托管户"/"6 上清DVP"/"7 中债DVP"
					sb.append( "and t1.xh in (1, 6, 7,8)");
					//排序SQL语句
					sqlOrder = " order by t1.l_fund_id, t1.xh";
				}
			}

			if(sb.length()>0 && StringUtils.isNotBlank(sb.toString())){
				//查询结果集
				List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
				if(!list.isEmpty() && list.size()>0){
					for(int i=0; i<list.size(); i++){
						Map<String, String> map = list.get(i);
						String L_FUND_ID = map.get("L_FUND_ID");//基金ID
						String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
						String VC_FUND_NAME = StrUtil.changeNull(map.get("VC_FUND_NAME")).trim().replace("（", "(").replace("）", ")");//基金名称
						String XH = map.get("XH");//序号
						String BZ = map.get("BZ");//备注
						String D_COL = StrUtil.addThousandth(map.get("D_COL"), StrUtil.df1);//D 期初余额
						String F_COL = StrUtil.addThousandth(map.get("F_COL"), StrUtil.df1);//F 银行间正回购，首次结算日为当日，金额为正
						String G_COL = StrUtil.addThousandth(map.get("G_COL"), StrUtil.df1);//G 银行间逆回购，首次结算日为当日，金额为负
						String H_COL = StrUtil.addThousandth(map.get("H_COL"), StrUtil.df1);//H T日成交的T+0银行间买券,结算日为当日，金额为负
						String I_COL = StrUtil.addThousandth(map.get("I_COL"), StrUtil.df1);//I T日成交的T+0银行间卖券,结算日为当日，金额为正
						String J_COL = StrUtil.addThousandth(map.get("J_COL"), StrUtil.df1);//J 银行间正回购到期，到期结算日为当日，金额为负
						String K_COL = StrUtil.addThousandth(map.get("K_COL"), StrUtil.df1);//K 银行间逆回购到期，到期结算日为当日，金额为正
						String L_COL = StrUtil.addThousandth(map.get("L_COL"), StrUtil.df1);//L T-1日成交的T+1交收的银行间买券，结算日为当日，金额为负
						String M_COL = StrUtil.addThousandth(map.get("M_COL"), StrUtil.df1);//M T-1日成交的T+1交收的银行间卖券，结算日为当日，金额为正
						String N_COL = StrUtil.addThousandth(map.get("N_COL"), StrUtil.df1);//N 银行间分销，金额为负
						String O_COL = StrUtil.addThousandth(map.get("O_COL"), StrUtil.df1);//O 交易所分销，金额为负
						String P_COL = StrUtil.addThousandth(map.get("P_COL"), StrUtil.df1);//P 基金申购，金额为负
						String Q_COL = StrUtil.addThousandth(map.get("Q_COL"), StrUtil.df1);//Q 基金赎回，赎回到账日为当日，金额为正
						String R_COL = StrUtil.addThousandth(map.get("R_COL"), StrUtil.df1);//R 红利到账，金额为正
						String S_COL = StrUtil.addThousandth(map.get("S_COL"), StrUtil.df1);//S 期货户入金,期货保证金调整的期货保证金增加，金额为负
						String T_COL = StrUtil.addThousandth(map.get("T_COL"), StrUtil.df1);//T 期货户出金,期货保证金调整的期货保证金减少，金额为正
						String U_COL = StrUtil.addThousandth(map.get("U_COL"), StrUtil.df1);//U 同业存款，即定期存款，金额为负
						String V_COL = StrUtil.addThousandth(map.get("V_COL"), StrUtil.df1);//V 同业存款到期，即定期存款到期，到期日为当日，金额为正
						String W_COL = StrUtil.addThousandth(map.get("W_COL"), StrUtil.df1);//W 当日债券兑付/付息（沪深），金额为正
						String X_COL = StrUtil.addThousandth(map.get("X_COL"), StrUtil.df1);//X 当日债券兑付/付息（非沪深），金额为正
						String Y_COL = StrUtil.addThousandth(map.get("Y_COL"), StrUtil.df1);//Y 追加，即当日资金管理手工增加资金，金额为正
						String Z_COL = StrUtil.addThousandth(map.get("Z_COL"), StrUtil.df1);//Z 提取，即当日资金管理手工减少资金，金额为负
						String AA_COL = StrUtil.addThousandth(map.get("AA_COL"), StrUtil.df1);//AA 当日TA申购，金额为正
						String AB_COL = StrUtil.addThousandth(map.get("AB_COL"), StrUtil.df1);//AB TA赎回，赎回款到账日为当日，金额为负
						String AC_COL = StrUtil.addThousandth(map.get("AC_COL"), StrUtil.df1);//AC 网下申购，金额为负
						String AD_COL = StrUtil.addThousandth(map.get("AD_COL"), StrUtil.df1);//AD 网下申购退款，金额为正
						String AE_COL = StrUtil.addThousandth(map.get("AE_COL"), StrUtil.df1);//AE RTGS非担保卖券,清算速度T+0，金额为正
						String AL_COL = StrUtil.addThousandth(map.get("AL_COL"), StrUtil.df1);//AL 费用支付，金额为负
						String AM_COL = StrUtil.addThousandth(map.get("AM_COL"), StrUtil.df1);//AM 新股配售交收，金额为负
						String AF_COL = StrUtil.addThousandth(map.get("AF_COL"), StrUtil.df1);//AF RTGS非担保买券,清算速度T+0，金额为负
						String AG_COL = StrUtil.addThousandth(map.get("AG_COL"), StrUtil.df1);//AG 调款
						String AI_COL = StrUtil.addThousandth(map.get("AI_COL"), StrUtil.df1);//AI 手工调整1
						String AJ_COL = StrUtil.addThousandth(map.get("AJ_COL"), StrUtil.df1);//AJ 手工调整2
						String AK_COL = StrUtil.addThousandth(map.get("AK_COL"), StrUtil.df1);//AK 余额
						String AN_COL = StrUtil.addThousandth(map.get("AN_COL"), StrUtil.df1);//AN 资金冻结，金额为正
						String AO_COL = StrUtil.addThousandth(map.get("AO_COL"), StrUtil.df1);//AO 资金冻结取消,金额为正
						String AP_COL = StrUtil.addThousandth(map.get("AP_COL"), StrUtil.df1);//AP 资金增加,金额为正
						String EN_BALANCE = StrUtil.addThousandth0ToEmpty(map.get("TZJE"), StrUtil.df1);//手工调整金额
						String SGTZ_BZ = map.get("SGTZ_BZ");//手工调整备注
						String AM1_COL = StrUtil.addThousandth(map.get("AM1_COL"), StrUtil.df1); 
						String AM2_COL = StrUtil.addThousandth(map.get("AM2_COL"), StrUtil.df1);

						obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");

						//给对象赋值
						obj.setString("L_FUND_ID", L_FUND_ID);
						obj.setString("VC_FUND_CODE", VC_FUND_CODE);
						obj.setString("VC_FUND_NAME", VC_FUND_NAME);
						obj.setString("XH", XH);
						obj.setString("BZ", BZ);
						obj.setString("D_COL", D_COL);
						obj.setString("F_COL", F_COL);
						obj.setString("G_COL", G_COL);
						obj.setString("H_COL", H_COL);
						obj.setString("I_COL", I_COL);
						obj.setString("J_COL", J_COL);
						obj.setString("K_COL", K_COL);
						obj.setString("L_COL", L_COL);
						obj.setString("M_COL", M_COL);
						obj.setString("N_COL", N_COL);
						obj.setString("O_COL", O_COL);
						obj.setString("P_COL", P_COL);
						obj.setString("Q_COL", Q_COL);
						obj.setString("R_COL", R_COL);
						obj.setString("S_COL", S_COL);
						obj.setString("T_COL", T_COL);
						obj.setString("U_COL", U_COL);
						obj.setString("V_COL", V_COL);
						obj.setString("W_COL", W_COL);
						obj.setString("X_COL", X_COL);
						obj.setString("Y_COL", Y_COL);
						obj.setString("Z_COL", Z_COL);
						obj.setString("AA_COL", AA_COL);
						obj.setString("AB_COL", AB_COL);
						obj.setString("AC_COL", AC_COL);
						obj.setString("AD_COL", AD_COL);
						obj.setString("AL_COL", AL_COL);
						obj.setString("AM_COL", AM_COL);
						obj.setString("AE_COL", AE_COL);
						obj.setString("AF_COL", AF_COL);
						obj.setString("AG_COL", AG_COL);
						obj.setString("AI_COL", AI_COL);
						obj.setString("AJ_COL", AJ_COL);
						obj.setString("AK_COL", AK_COL);
						obj.setString("AN_COL", AN_COL);
						obj.setString("AO_COL", AO_COL);
						obj.setString("AP_COL", AP_COL);
						obj.setString("EN_BALANCE", EN_BALANCE);
						obj.setString("SGTZ_BZ", SGTZ_BZ);
						obj.setString("AM1_COL", AM1_COL);
						obj.setString("AM2_COL", AM2_COL);
						result.add(obj);
						obj = null;
					}
				}
			}
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
	 * 综合信息查询-自动化头寸表-自动化头寸表明细查询-新
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryZDHTCBDetailNew(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getBakO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_ZDHTCB_DETAIL_NEW)){
				SQL_ZDHTCB_DETAIL_NEW = getFileSql("zhxxcx_zdhtcb_detail_new.sql");
			}

			//获取页面传进来的查询条件值
			String vCFundId = paramObject.getString("vCFundId");//基金ID
			String busiDesc = paramObject.getString("busiDesc"); //指标描述


			//拼接SQL语句
			sb.append(SQL_ZDHTCB_DETAIL_NEW);
			if(StringUtils.isNotBlank(vCFundId)){
				sb.append("   and t.l_fund_id in (").append(JDBCUtil.changeInStr(vCFundId)).append(") ");
			}
			if(StringUtils.isNotBlank(busiDesc)){
				sb.append("   and t.busi_desc like '%" + busiDesc +"%'");
			}
			//排序SQL语句
			String sqlOrder = "";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String EN_BALANCE = map.get("EN_BALANCE"); //指标金额
					String BZ = map.get("BZ"); //备注
					String BUSI_DESC = map.get("BUSI_DESC"); //指标描述

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("EN_BALANCE", EN_BALANCE);
					obj.setString("BZ", BZ);
					obj.setString("BUSI_DESC", BUSI_DESC);
					result.add(obj);
					obj = null;
				}
			}
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
	 * 综合信息查询-自动化头寸表-自动化头寸表回款未交收资金明细查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author wzx
	 */
	@Bizlet("")
	public static List<DataObject> queryZDHTCBDetail2New(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getBakO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_ZDHTCB_DETAIL2_NEW)){
				SQL_ZDHTCB_DETAIL2_NEW = getFileSql("zhxxcx_zdhtcb_detail2_new.sql");
			}

			//获取页面传进来的查询条件值
			String vCFundId = paramObject.getString("vCFundId");//基金ID
			String busiDesc = paramObject.getString("busiDesc"); //指标描述


			//拼接SQL语句
			sb.append(SQL_ZDHTCB_DETAIL2_NEW);
			if(StringUtils.isNotBlank(vCFundId)){
				sb.append("   and t.l_fund_id in (").append(JDBCUtil.changeInStr(vCFundId)).append(") ");
			}
			if(StringUtils.isNotBlank(busiDesc)){
				sb.append("   and t.busi_desc like '%" + busiDesc +"%'");
			}
			//排序SQL语句
			String sqlOrder = "";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String EN_BALANCE = map.get("EN_BALANCE"); //指标金额
					String BZ = map.get("BZ"); //备注
					String BUSI_DESC = map.get("BUSI_DESC"); //指标描述

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("EN_BALANCE", EN_BALANCE);
					obj.setString("BZ", BZ);
					obj.setString("BUSI_DESC", BUSI_DESC);
					result.add(obj);
					obj = null;
				}
			}
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
	 * 综合信息查询-手工调整自动化头寸表值-新
	 * @param paramObject 参数条件对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static void updateZDHTCBNew(DataObject paramObject){
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<String> sqls = new ArrayList<String>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getBakO32CacheDataSourceName());

			//获取页面传进来的参数条件值
			String lFundIds = paramObject.getString("lFundIds");//基金序号
			String XHs = paramObject.getString("XHs");//序号
			String TZJEs = paramObject.getString("TZJEs");//手工调整金额
			String BZs = StrUtil.changeNull(paramObject.getString("BZs"));//备注信息

			if(StringUtils.isNotBlank(lFundIds)){
				String[] lFundIdArr = lFundIds.split("@");
				String[] XHArr = XHs.split("@");
				String[] TZJEArr = TZJEs.split("@");
				String[] BZArr = BZs.split("@");

				for(int i=0; i<lFundIdArr.length; i++){
					String lFundId = lFundIdArr[i];
					String XH = XHArr[i];
					String TZJE = StrUtil.changeNull(TZJEArr[i]).replaceAll(",", "");
					String BZ = StrUtil.changeNull(BZArr[i]).replaceAll(ProductProcessUtil.DICT_ID_HS_NO_EXIST, "");

					//拼接SQL语句--将原手工调整值写入调整日志表备份
					sb.setLength(0);
					sb.append("insert into o32_cj.TO32_JS_SGTZ_LOG ")
					  .append("  (L_FUND_ID, XH, TZJE, TZSJ, BZ) ")
					  .append("  select L_FUND_ID, XH, TZJE, TZSJ, BZ ")
					  .append("    from o32_cj.TO32_JS_SGTZ t ")
					  .append("   where 1 = 1 ")
					  .append("     and t.l_fund_id = '" + lFundId + "' ")
					  .append("     and t.xh = '" + XH + "' ");
					sqls.add(sb.toString());

					//拼接SQL语句--删除原手工调整值
					sb.setLength(0);
					sb.append("delete from o32_cj.TO32_JS_SGTZ t where t.l_fund_id = '" + lFundId + "' and t.xh = '" + XH + "' ");
					sqls.add(sb.toString());

					//拼接SQL语句--插入新手工调整值
					sb.setLength(0);
					sb.append("insert into o32_cj.TO32_JS_SGTZ ")
					  .append("  (L_FUND_ID, XH, TZJE, TZSJ, BZ) ")
					  .append("values ")
					  .append("  ('" + lFundId + "', '" + XH + "', '" + TZJE + "', sysdate, '" + BZ + "') ");
					sqls.add(sb.toString());
				}

				JDBCUtil.executeUpdateBatchWithConn(conn, sqls);//执行插入
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			sb.setLength(0);
			sb = null;
			JDBCUtil.releaseResource(conn, null, null);
		}
	}

	/**
	 * 综合信息查询-组合持仓(产品持仓明细)扩展信息查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryZHCCExtend(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
//		List<DataObject> bbqList = new ArrayList<DataObject>();
		List<DataObject> objs = null;
		try {
			//获取产品持仓明细
			System.out.println("开始获取产品持仓明细:"+new Date());
			objs = queryZHCC(paramObject, page);
			System.out.println("结束获取产品持仓明细:"+new Date());
			//获取临时数据中心[10.201.4.43]数据库连接
			conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_SJZX);
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_ZHCC_EXTEND)){
				SQL_ZHCC_EXTEND = getFileSql("zhxxcx_zhcc_extend.sql");
			}

			String vCReoortCode = "";//证券代码
			String vCInterCode = ""; //证券内码
			//组装参数证券代码
			for(int i=0; i<objs.size(); i++){
				String VC_REPORT_CODE = objs.get(i).getString("VC_REPORT_CODE");  //证券代码
				String VC_INTER_CODE = objs.get(i).getString("VC_INTER_CODE");  //证券内码
				if(vCReoortCode == ""){  //判断是否为空
					vCReoortCode = VC_REPORT_CODE;
				}else if(vCReoortCode.indexOf(VC_REPORT_CODE) == -1){   //判断证券代码是否存在，存在不追加
					vCReoortCode += "," + VC_REPORT_CODE;
				}

				//组装证券内码查询条件
				if(vCInterCode == ""){  //判断是否为空
					vCInterCode = VC_INTER_CODE;
				}else if(vCInterCode.indexOf(VC_INTER_CODE) == -1){   //判断证券内码是否存在，存在不追加
					vCInterCode += "," + VC_INTER_CODE;
				}
			}

			if(StringUtils.isNotBlank(vCReoortCode)){
				//拼接SQL语句
				sb.append(SQL_ZHCC_EXTEND);
				if(StringUtils.isNotBlank(vCReoortCode)){
					//sb.append("  and t1.f16_1090 in (").append(JDBCUtil.changeInStr(vCReoortCode)).append(")");
					//sb.append("  and t1.f16_1090 in (").append(JDBCUtil.getOracleSQLIn(vCReoortCode)).append(")");
					sb.append(JDBCUtil.getSQLInOrIn(vCReoortCode, 1000, "t1.f16_1090"));
				}

				//查询结果集
				System.out.println("开始获取产品持仓拓展明细:"+new Date());
				List<Map<String, String>> list = JDBCUtil.queryWithConn(conn, sb.toString(), null);
				System.out.println("结束获取产品持仓拓展明细:"+new Date());
				if(!list.isEmpty() && list.size()>0){
					for(int i=0; i<list.size(); i++){
						Map<String, String> map = list.get(i);
						obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");

						String ZQDM = map.get("ZQDM"); //债券代码
						String ZPR = map.get("ZPR"); //债券摘牌日
						String DQR = map.get("DQR"); //债券兑付日

						obj.setString("ZQDM", ZQDM);
						obj.setString("ZPR", ZPR);
						obj.setString("DQR", DQR);

						result.add(obj);
						obj = null;
					}
			    }

				//万得BBQ产品下架了
//				sb.setLength(0);
//				sb.append("select t2.vc_inter_code, t1.RT_YIELD, t1.RT_ASKYIELD, t1.RT_BIDYIELD ")
//				  //.append("  from STAGE.wind_bbq_hq t1, STAGE.Fm_Thisstockinfo t2 ")//使用历史表语句备份
//				  .append("  from STAGE.wind_bbq_hq t1, STAGE.Fm_Tstockinfo t2 ")
//				  .append(" where t1.c_market_no = t2.c_market_no(+) ")
//				  .append("   and t1.src_code = t2.vc_report_code(+) ")
//				  //.append("   and t2.l_date = (select max(t.l_date) from STAGE.Fm_Thisstockinfo t) ")//使用历史表语句备份
//				  .append("   and t1.rt_time = (select max(t.rt_time) ")
//				  .append("                       from STAGE.wind_bbq_hq t ")
//				  .append("                      where t.src_code = t1.src_code ")
//				  .append("                        and t.c_market_no = t1.c_market_no) ");
//
//				//组装参数
//				if(StringUtils.isNotBlank(vCInterCode)){
//					//sb.append("   and t2.vc_inter_code in (").append(JDBCUtil.changeInStr(vCInterCode)).append(") ");
//					//sb.append("   and t2.vc_inter_code in (").append(JDBCUtil.getOracleSQLIn(vCInterCode)).append(") ");
//					sb.append(JDBCUtil.getSQLInOrIn(vCInterCode, 1000, "t2.vc_inter_code"));
//				}
//				sb.append(" group by t2.vc_inter_code, t1.RT_YIELD, t1.RT_ASKYIELD, t1.RT_BIDYIELD ");
//
//				//查询结果集
//				List<Map<String, String>> windList = JDBCUtil.queryWithConn(conn, sb.toString(), null);
//
//				if(!windList.isEmpty() && windList.size()>0){
//					for(int i=0; i<windList.size(); i++){
//						Map<String, String> map = windList.get(i);
//						obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
//
//						String RT_YIELD = map.get("RT_YIELD");  //成交价
//						String RT_ASKYIELD = map.get("RT_ASKYIELD"); //卖出收益价
//						String RT_BIDYIELD = map.get("RT_BIDYIELD"); //买入收益价
//						String VC_INTER_CODE = map.get("VC_INTER_CODE"); //证券内码
//
//						obj.set("RT_YIELD", RT_YIELD);
//						obj.set("RT_ASKYIELD", RT_ASKYIELD);
//						obj.set("RT_BIDYIELD", RT_BIDYIELD);
//						obj.set("VC_INTER_CODE", VC_INTER_CODE);
//
//						bbqList.add(obj);
//					}
//				}

				for(int k=0; k<objs.size(); k++){
					for(int j=0; j<result.size(); j++){
						//判断证券代码是否相等
						if(objs.get(k).getString("VC_REPORT_CODE").equals(result.get(j).getString("ZQDM"))){
							//追加参数债券摘牌日
							objs.get(k).setString("ZPR", result.get(j).getString("ZPR"));
							//追加参数债券兑付日
							objs.get(k).setString("DQR", result.get(j).getString("DQR"));
							break;
						}
					}

					//万得BBQ产品下架了
//					for(int z=0; z<bbqList.size(); z++){
//						if(objs.get(k).getString("VC_INTER_CODE").equals(bbqList.get(z).getString("VC_INTER_CODE"))){
//							//追加参数成交价
//							objs.get(k).setString("RT_YIELD", bbqList.get(z).getString("RT_YIELD"));
//							//追加参数卖出收益价
//							objs.get(k).setString("RT_ASKYIELD", bbqList.get(z).getString("RT_ASKYIELD"));
//							//追加参数买入收益价
//							objs.get(k).setString("RT_BIDYIELD", bbqList.get(z).getString("RT_BIDYIELD"));
//							break;
//						}
//					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			sb.setLength(0);
			sb = null;
			JDBCUtil.releaseResource(conn, null, null);
		}
		return objs;
	}

	/**
	 * 综合信息查询-组合持仓（产品持仓明细）-万得BBQ行情展示查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryWindBbqHq(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取临时数据中心[10.201.4.43]数据库连接
			conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_SJZX);
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_ZHCC_WIND_BBQ_HQ)){
				SQL_ZHCC_WIND_BBQ_HQ = getFileSql("zhxxcx_zhcc_wind_bbq_hq.sql");
			}

			//获取页面传进来的查询条件值
			String vCInterCode = paramObject.getString("vCInterCode");//证券内码

			//拼接SQL语句
			sb.append(SQL_ZHCC_WIND_BBQ_HQ);
			if(StringUtils.isNotBlank(vCInterCode)){
				sb.append("   and A.vc_inter_code in (").append(JDBCUtil.changeInStr(vCInterCode)).append(") ");
			}
			//排序SQL语句
			String sqlOrder = " order by A.rt_time desc";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");

					String BBQ_ID = map.get("BBQ_ID");  //序号
					String SEC_NAME = map.get("SEC_NAME");  //债券简称
					String RT_YIELD = map.get("RT_YIELD");  //成交价
					String RT_ASKYIELD = map.get("RT_ASKYIELD"); //卖出收益价
					String RT_BIDYIELD = map.get("RT_BIDYIELD"); //买入收益价
					String RT_ASIZE = map.get("RT_ASIZE"); //卖量
					String RT_BSIZE = map.get("RT_BSIZE"); //买量
					String SRC_CODE = map.get("SRC_CODE"); //报价机构代码
					String RT_TIME = map.get("RT_TIME"); //时间
					String CREATE_TIME = map.get("CREATE_TIME"); //创建时间
					String REMARK = map.get("REMARK");  //备注
					String YIELD_CNBD = map.get("YIELD_CNBD"); //估价收益率(中债)
					String COUPONRATE = map.get("COUPONRATE"); //票息，即票面利率
					String MATURITYDATE = map.get("MATURITYDATE"); //期限(天)

					obj.set("BBQ_ID", BBQ_ID);
					obj.set("SEC_NAME", SEC_NAME);
					obj.set("RT_YIELD", RT_YIELD);
					obj.set("RT_ASKYIELD", RT_ASKYIELD);
					obj.set("RT_BIDYIELD", RT_BIDYIELD);
					obj.set("RT_ASIZE", RT_ASIZE);
					obj.set("RT_BSIZE", RT_BSIZE);
					obj.set("SRC_CODE", SRC_CODE);
					obj.set("RT_TIME", RT_TIME);
					obj.set("CREATE_TIME", CREATE_TIME);
					obj.set("REMARK", REMARK);
					obj.set("YIELD_CNBD", YIELD_CNBD);
					obj.set("COUPONRATE", COUPONRATE);
					obj.set("MATURITYDATE", MATURITYDATE);

					result.add(obj);
					obj = null;
				}
			}
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
	 * 结算指令下载表查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author fengjunpei
	 */
	@Bizlet("")
	public static List<DataObject> queryJSZLXZ(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取数据库连接
			conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_DEFAULT);
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_JSZLXZ)){
				SQL_JSZLXZ = ZhxxcxUtil.getFileSql("zhxxcx_jszlxz.sql");
			}

			//获取页面传进来的查询条件值
			String vcOrgtrnm = paramObject.getString("vcOrgtrnm");//客户简称（查询条件传入）
			String vcCtrptynm = paramObject.getString("vcCtrptynm");//对手方简称（查询条件传入）
			String vcBiztp = paramObject.getString("vcBiztp");//业务类别描述（查询条件传入）
			String vcFrstdlvrydt = DateUtil.format(paramObject.getDate("vcFrstdlvrydt"), DateUtil.YMD_NUMBER);//首次交割日（查询条件传入）
			String vcScnddlvrydt = DateUtil.format(paramObject.getDate("vcScnddlvrydt"), DateUtil.YMD_NUMBER);//到期交割日/远期交割成交日（查询条件传入）
			String vcInstrsts = paramObject.getString("vcInstrsts");//指令状态描述（查询条件传入）
			//拼接SQL语句
			sb.append(SQL_JSZLXZ);
			if(StringUtils.isNotBlank(vcOrgtrnm)){
				sb.append("   and a.vc_orgtrnm like '%").append(vcOrgtrnm).append("%'");
			}
			if(StringUtils.isNotBlank(vcCtrptynm)){
				sb.append("   and a.vc_ctrptynm like '%").append(vcCtrptynm).append("%'");
			}
			if(StringUtils.isNotBlank(vcBiztp)){
				sb.append("   and a.vc_biztp like '%").append(vcBiztp).append("%'");
			}
			if(StringUtils.isNotBlank(vcFrstdlvrydt)){
				sb.append("   and a.vc_frstdlvrydt = ").append("'"+vcFrstdlvrydt+"'");
			}
			if(StringUtils.isNotBlank(vcScnddlvrydt)){
				sb.append("   and a.vc_scnddlvrydt = ").append("'"+vcScnddlvrydt+"'");
			}
			if(StringUtils.isNotBlank(vcInstrsts)){
				sb.append("   and a.vc_instrsts like '%").append(vcInstrsts).append("%'");
			}
			//排序SQL语句
			String sqlOrder = "";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					//创建实体对象
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");

					//获取参数值
					String VC_INSTRID = map.get("VC_INSTRID");   //指令编号
					String VC_ORGTRNM	 = map.get("VC_ORGTRNM");   //客户简称
					String VC_ORGTRSUBACCTID = map.get("VC_ORGTRSUBACCTID");   //本方分组合号
					String VC_ORGTRSUBNM	 = map.get("VC_ORGTRSUBNM");  //本方分组合简称
					String VC_ORGTRACCTID = map.get("VC_ORGTRACCTID");  //债券账号
					String VC_ACCTWTHDVPNETGCONFD = map.get("VC_ACCTWTHDVPNETGCONFD");  //预发行净额结算DVP被确认账号
					String VC_ACCTWTHMRGNBLCKGCONFD = map.get("VC_ACCTWTHMRGNBLCKGCONFD"); //保证金冻结确认被确认账号
					String VC_ACCTWHTMRGNUNBLCKGCONFD =  map.get("VC_ACCTWHTMRGNUNBLCKGCONFD"); //保证金解冻确认被确认账号
					String VC_CTRPTYNM =  map.get("VC_CTRPTYNM"); //对手方简称
					String VC_CTRPTYACCT =  map.get("VC_CTRPTYACCT"); //对手方账号
					String VC_BIZTPCD =  map.get("VC_BIZTPCD"); //业务类别编号
					String VC_BIZTP =  map.get("VC_BIZTP"); //业务类别描述
					String VC_TXDRCTN =  map.get("VC_TXDRCTN"); //交易方向描述
					String VC_CSHSTTLEMDRCTN =  map.get("VC_CSHSTTLEMDRCTN"); //现金了结方向描述
					String VC_CONFDCSHDRCTN = map.get("VC_CONFDCSHDRCTN"); //预发行净额结算DVP被确认款方向描述
					String VC_FRSTLEGCD = map.get("VC_FRSTLEGCD"); // 首次结算方式代码
					String VC_FRSTLEG = map.get("VC_FRSTLEG"); // 首次结算方式符号描述
					String VC_FRSTLEGINCHIN = map.get("VC_FRSTLEGINCHIN"); // 首次结算方式中文描述
					String VC_SCNDLEGCD = map.get("VC_SCNDLEGCD"); // 到期结算方式代码
					String VC_SCNDLEG = map.get("VC_SCNDLEG"); // 到期结算方式符号描述
					String VC_SCNDLEGINCHIN = map.get("VC_SCNDLEGINCHIN"); // 到期结算方式中文描述
					String VC_FRSTDLVRYDT = map.get("VC_FRSTDLVRYDT"); // 首次交割日
					String VC_SCNDDLVRYDT = map.get("VC_SCNDDLVRYDT"); // 到期交割日/远期交割成交日
					String VC_FRSTSTTLEMVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_FRSTSTTLEMVAL"), StrUtil.df1); // 首期资金清算额/净价金额/融资解押返还资金额(含融资利息)/BEPS调增、调减额度/BEPS置换换入额度
					String VC_CSHSTTLEMVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_CSHSTTLEMVAL"), StrUtil.df1); // 现金了结交割金额
					String VC_MRGNBLCKGVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_MRGNBLCKGVAL"), StrUtil.df1); // 	保证金冻结金额
					String VC_MRGNUNBLCKGVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_MRGNUNBLCKGVAL"), StrUtil.df1); // 保证金解冻金额
					String VC_SCNDSTTLEMVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_SCNDSTTLEMVAL"), StrUtil.df1); // 到期资金清算额/全价金额/融资解押融资利息/融资质押起点金额/BEPS置换换出额度
					String VC_FRSTLEGPRIC = StrUtil.addThousandth0ToEmpty(map.get("VC_FRSTLEGPRIC"), StrUtil.df1); // 首次结算价格/净价
					String VC_SCNDLEGPRIC = StrUtil.addThousandth0ToEmpty(map.get("VC_SCNDLEGPRIC"), StrUtil.df1); // 到期结算价格/全价
					String VC_TTLFACEAMT = StrUtil.addThousandth0ToEmpty(map.get("VC_TTLFACEAMT"), StrUtil.df1); // 债券面额合计
					String VC_TXID = map.get("VC_TXID"); // 业务标识号
					String VC_REPORATE = map.get("VC_REPORATE"); // 回购年利率
					String VC_OVRDUEDAYS = map.get("VC_OVRDUEDAYS"); // 逾期天数/融资解押资金使用天数
					String VC_SCTIESLNDGTERM = map.get("VC_SCTIESLNDGTERM"); // 质押融券期限
					String VC_ORGTRGRTETPCD = map.get("VC_ORGTRGRTETPCD"); // 发令方保证方式
					String VC_MRGNBLCKGIND = map.get("VC_MRGNBLCKGIND"); // 保证金冻结成功失败标志
					String VC_MRGNUNBLCKGIND = map.get("VC_MRGNUNBLCKGIND"); // 保证金解冻成功失败标志
					String VC_ORGTRGRTETP = map.get("VC_ORGTRGRTETP"); // 发令方保证方式描述
					String VC_CNTRPTYGRTETPCD = map.get("VC_CNTRPTYGRTETPCD"); // 对手方保证方式
					String VC_COLLSBSTITNIND = map.get("VC_COLLSBSTITNIND"); // 是否允许替换质押品
					String VC_CNTRPTYGRTETP = map.get("VC_CNTRPTYGRTETP"); // 对手方保证方式描述
					String VC_ORGTRGRTEBDSEQNB = map.get("VC_ORGTRGRTEBDSEQNB"); // 发令方保证券债券序号
					String VC_ORGTRGRTEBDID = map.get("VC_ORGTRGRTEBDID"); // 发令方保证券债券代码
					String VC_ORGTRGRTEBDSHRTNM = map.get("VC_ORGTRGRTEBDSHRTNM"); // 发令方保证券债券简称
					String VC_ORGTRGRTEBDFACEAMT = StrUtil.addThousandth0ToEmpty(map.get("VC_ORGTRGRTEBDFACEAMT"), StrUtil.df1); // 发令方保证券债券面额
					String VC_OTCBUYGFACEAMT = StrUtil.addThousandth0ToEmpty(map.get("VC_OTCBUYGFACEAMT"), StrUtil.df1); // 柜台专项结算买入面额
					String VC_ORGTRGRTEMRGN = StrUtil.addThousandth0ToEmpty(map.get("VC_ORGTRGRTEMRGN"), StrUtil.df1); // 发令方保证金
					String VC_OTCBUYGVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_OTCBUYGVAL"), StrUtil.df1); // 柜台专项结算买入金额
					String VC_CTRPTYGRTEBDSEQNB = map.get("VC_CTRPTYGRTEBDSEQNB"); // 对手方保证券债券序号
					String VC_CNTRPTYGRTEBDID = map.get("VC_CNTRPTYGRTEBDID"); // 对手方保证券债券代码
					String VC_CNTRPTYGRTEBDSHRTNM = map.get("VC_CNTRPTYGRTEBDSHRTNM"); // 对手方保证券债券简称
					String VC_CNTRPTYGRTEBDFACEAMT = StrUtil.addThousandth0ToEmpty(map.get("VC_CNTRPTYGRTEBDFACEAMT"), StrUtil.df1); // 对手方保证券债券面额
					String VC_OTCSELLGFACEAMT = StrUtil.addThousandth0ToEmpty(map.get("VC_OTCSELLGFACEAMT"), StrUtil.df1); // 柜台专项结算卖出面额
					String VC_CNTRPTYCSHCOLL = StrUtil.addThousandth0ToEmpty(map.get("VC_CNTRPTYCSHCOLL"), StrUtil.df1); // 对手方保证金
					String VC_OTCSELLGVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_OTCSELLGVAL"), StrUtil.df1); // 柜台专项结算卖出金额
					String VC_CROSSTRFAPLT = map.get("VC_CROSSTRFAPLT"); // 转托管申请人
					String VC_ORGNLCTRCTID = map.get("VC_ORGNLCTRCTID"); // 对应合同号
					String VC_ORGNLINSTRID = map.get("VC_ORGNLINSTRID"); // 对应指令号
					String VC_TRANSFEREEID = map.get("VC_TRANSFEREEID"); // 转入方账号
					String VC_TRANSFERORID = map.get("VC_TRANSFERORID"); // 转出方账号
					String VC_OPRTR = map.get("VC_OPRTR"); // 操作员
					String VC_CHCKER = map.get("VC_CHCKER"); // 复核员
					String VC_CNFRMOR = map.get("VC_CNFRMOR"); // 确认员
					String VC_INSTRACCPTTM = map.get("VC_INSTRACCPTTM"); // 指令接收时间
					String VC_INSTRCHCKTM = map.get("VC_INSTRCHCKTM"); // 指令复核时间
					String VC_INSTRCNFRMTM = map.get("VC_INSTRCNFRMTM"); // 指令确认时间
					String VC_INSTRSTSCD = map.get("VC_INSTRSTSCD"); // 指令状态
					String VC_INSTRSTS = map.get("VC_INSTRSTS"); // 指令状态描述
					String VC_LASTUPDTM = map.get("VC_LASTUPDTM"); // 最近更新时间
					String VC_GVRCSHLCTNCD = map.get("VC_GVRCSHLCTNCD"); // 付券方保证金保管地
					String VC_GVRCSHLCTN = map.get("VC_GVRCSHLCTN"); // 付券方保证金保管地描述
					String VC_TAKERCSHLCTNCD = map.get("VC_TAKERCSHLCTNCD"); // 收券方保证金保管地
					String VC_TAKERCSHLCTN = map.get("VC_TAKERCSHLCTN"); // 收券方保证金保管地描述
					String VC_COLLMDLCD = map.get("VC_COLLMDLCD"); // 担保模式代码
					String VC_COLLMDL = map.get("VC_COLLMDL"); // 担保模式描述

					//给对象赋值
					obj.setString("VC_INSTRID", VC_INSTRID);
					obj.setString("VC_ORGTRNM", VC_ORGTRNM);
					obj.setString("VC_ORGTRSUBACCTID", VC_ORGTRSUBACCTID);
					obj.setString("VC_ORGTRSUBNM", VC_ORGTRSUBNM);
					obj.setString("VC_ORGTRACCTID", VC_ORGTRACCTID);
					obj.setString("VC_ACCTWTHDVPNETGCONFD", VC_ACCTWTHDVPNETGCONFD);
					obj.setString("VC_ACCTWTHMRGNBLCKGCONFD", VC_ACCTWTHMRGNBLCKGCONFD);
					obj.setString("VC_ACCTWHTMRGNUNBLCKGCONFD", VC_ACCTWHTMRGNUNBLCKGCONFD);
					obj.setString("VC_CTRPTYNM", VC_CTRPTYNM);
					obj.setString("VC_CTRPTYACCT", VC_CTRPTYACCT);
					obj.setString("VC_BIZTPCD", VC_BIZTPCD);
					obj.setString("VC_BIZTP", VC_BIZTP);
					obj.setString("VC_TXDRCTN", VC_TXDRCTN);
					obj.setString("VC_CSHSTTLEMDRCTN", VC_CSHSTTLEMDRCTN);
					obj.setString("VC_CONFDCSHDRCTN", VC_CONFDCSHDRCTN);
					obj.setString("VC_FRSTLEGCD", VC_FRSTLEGCD);
					obj.setString("VC_FRSTLEG", VC_FRSTLEG);
					obj.setString("VC_FRSTLEGINCHIN", VC_FRSTLEGINCHIN);
					obj.setString("VC_SCNDLEGCD", VC_SCNDLEGCD);
					obj.setString("VC_SCNDLEG", VC_SCNDLEG);
					obj.setString("VC_SCNDLEGINCHIN", VC_SCNDLEGINCHIN);
					obj.setString("VC_FRSTDLVRYDT", VC_FRSTDLVRYDT);
					obj.setString("VC_SCNDDLVRYDT", VC_SCNDDLVRYDT);
					obj.setString("VC_FRSTSTTLEMVAL", VC_FRSTSTTLEMVAL);
					obj.setString("VC_CSHSTTLEMVAL", VC_CSHSTTLEMVAL);
					obj.setString("VC_MRGNBLCKGVAL", VC_MRGNBLCKGVAL);
					obj.setString("VC_MRGNUNBLCKGVAL", VC_MRGNUNBLCKGVAL);
					obj.setString("VC_SCNDSTTLEMVAL", VC_SCNDSTTLEMVAL);
					obj.setString("VC_FRSTLEGPRIC", VC_FRSTLEGPRIC);
					obj.setString("VC_SCNDLEGPRIC", VC_SCNDLEGPRIC);
					obj.setString("VC_TTLFACEAMT", VC_TTLFACEAMT);
					obj.setString("VC_TXID", VC_TXID);
					obj.setString("VC_REPORATE", VC_REPORATE);
					obj.setString("VC_OVRDUEDAYS", VC_OVRDUEDAYS);
					obj.setString("VC_SCTIESLNDGTERM", VC_SCTIESLNDGTERM);
					obj.setString("VC_ORGTRGRTETPCD", VC_ORGTRGRTETPCD);
					obj.setString("VC_MRGNBLCKGIND", VC_MRGNBLCKGIND);
					obj.setString("VC_MRGNUNBLCKGIND", VC_MRGNUNBLCKGIND);
					obj.setString("VC_ORGTRGRTETP", VC_ORGTRGRTETP);
					obj.setString("VC_CNTRPTYGRTETPCD", VC_CNTRPTYGRTETPCD);
					obj.setString("VC_COLLSBSTITNIND", VC_COLLSBSTITNIND);
					obj.setString("VC_CNTRPTYGRTETP", VC_CNTRPTYGRTETP);
					obj.setString("VC_ORGTRGRTEBDSEQNB", VC_ORGTRGRTEBDSEQNB);
					obj.setString("VC_ORGTRGRTEBDID", VC_ORGTRGRTEBDID);
					obj.setString("VC_ORGTRGRTEBDSHRTNM", VC_ORGTRGRTEBDSHRTNM);
					obj.setString("VC_ORGTRGRTEBDFACEAMT", VC_ORGTRGRTEBDFACEAMT);
					obj.setString("VC_OTCBUYGFACEAMT", VC_OTCBUYGFACEAMT);
					obj.setString("VC_ORGTRGRTEMRGN", VC_ORGTRGRTEMRGN);
					obj.setString("VC_OTCBUYGVAL", VC_OTCBUYGVAL);
					obj.setString("VC_CTRPTYGRTEBDSEQNB", VC_CTRPTYGRTEBDSEQNB	);
					obj.setString("VC_CNTRPTYGRTEBDID", VC_CNTRPTYGRTEBDID);
					obj.setString("VC_CNTRPTYGRTEBDSHRTNM", VC_CNTRPTYGRTEBDSHRTNM);
					obj.setString("VC_CNTRPTYGRTEBDFACEAMT", VC_CNTRPTYGRTEBDFACEAMT);
					obj.setString("VC_OTCSELLGFACEAMT", VC_OTCSELLGFACEAMT);
					obj.setString("VC_CNTRPTYCSHCOLL", VC_CNTRPTYCSHCOLL);
					obj.setString("VC_OTCSELLGVAL", VC_OTCSELLGVAL);
					obj.setString("VC_CROSSTRFAPLT", VC_CROSSTRFAPLT);
					obj.setString("VC_ORGNLCTRCTID", VC_ORGNLCTRCTID	);
					obj.setString("VC_ORGNLINSTRID", VC_ORGNLINSTRID);
					obj.setString("VC_TRANSFEREEID", VC_TRANSFEREEID);
					obj.setString("VC_TRANSFERORID", VC_TRANSFERORID);
					obj.setString("VC_OPRTR", VC_OPRTR);
					obj.setString("VC_CHCKER", VC_CHCKER);
					obj.setString("VC_CNFRMOR", VC_CNFRMOR);
					obj.setString("VC_INSTRACCPTTM", VC_INSTRACCPTTM);
					obj.setString("VC_INSTRCHCKTM", VC_INSTRCHCKTM);
					obj.setString("VC_INSTRCNFRMTM", VC_INSTRCNFRMTM);
					obj.setString("VC_INSTRSTSCD", VC_INSTRSTSCD);
					obj.setString("VC_INSTRSTS", VC_INSTRSTS);
					obj.setString("VC_LASTUPDTM", VC_LASTUPDTM);
					obj.setString("VC_GVRCSHLCTNCD", VC_GVRCSHLCTNCD);
					obj.setString("VC_GVRCSHLCTN", VC_GVRCSHLCTN);
					obj.setString("VC_TAKERCSHLCTNCD", VC_TAKERCSHLCTNCD);
					obj.setString("VC_TAKERCSHLCTN", VC_TAKERCSHLCTN);
					obj.setString("VC_COLLMDLCD", VC_COLLMDLCD);
					obj.setString("VC_COLLMDL", VC_COLLMDL);
					result.add(obj);
					obj = null;
				}
			}
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
	 * 结算合同下载表查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author fengjunpei
	 */
	@Bizlet("")
	public static List<DataObject> queryJSHTXZ(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取数据库连接
			conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_DEFAULT);
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_JSHTXZ)){
				SQL_JSHTXZ = ZhxxcxUtil.getFileSql("zhxxcx_jshtxz.sql");
			}

			//获取页面传进来的查询条件值
			String vcBdgvrnm = paramObject.getString("vcBdgvrnm");//付券方简称（查询条件传入）
			String vcBdtakernm = paramObject.getString("vcBdtakernm");//收券方简称（查询条件传入）
			String vcBiztp = paramObject.getString("vcBiztp");//业务类别描述（查询条件传入）
			String vcDlvrydt = DateUtil.format(paramObject.getDate("vcDlvrydt"), DateUtil.YMD_NUMBER);//交割日（查询条件传入）
			String vcCshsts = paramObject.getString("vcCshsts");//资金状态描述（查询条件传入）
			String vcCtrctsts = paramObject.getString("vcCtrctsts");//合同状态描述（查询条件传入）
			//拼接SQL语句
			sb.append(SQL_JSHTXZ);
			if(StringUtils.isNotBlank(vcBdgvrnm)){
				sb.append("   and a.VC_BDGVRNM like '%").append(vcBdgvrnm).append("%'");
			}
			if(StringUtils.isNotBlank(vcBdtakernm)){
				sb.append("   and a.VC_BDTAKERNM like '%").append(vcBdtakernm).append("%'");
			}
			if(StringUtils.isNotBlank(vcBiztp)){
				sb.append("   and a.VC_BIZTP like '%").append(vcBiztp).append("%'");
			}
			if(StringUtils.isNotBlank(vcDlvrydt)){
				sb.append("   and a.VC_DLVRYDT = ").append("'"+vcDlvrydt+"'");
			}
			if(StringUtils.isNotBlank(vcCshsts)){
				sb.append("   and a.VC_CSHSTS like '%").append(vcCshsts).append("%'");
			}
			if(StringUtils.isNotBlank(vcCtrctsts)){
				sb.append("   and a.VC_CTRCTSTS like '%").append(vcCtrctsts).append("%'");
			}
			//排序SQL语句
			String sqlOrder = "";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					//创建实体对象
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");

					// 获取参数值
					String VC_CTRCTID = map.get("VC_CTRCTID"); // 合同编号
					String VC_INSTRORGNACCT = map.get("VC_INSTRORGNACCT"); // 指令来源账号
					String VC_BDGVRACCT = map.get("VC_BDGVRACCT"); // 付券方账号
					String VC_ACCTWTHDVPNETGCONFD = map.get("VC_ACCTWTHDVPNETGCONFD"); // 预发行净额结算DVP被确认账号
					String VC_ACCTWTHMRGNBLCKGCONFD = map.get("VC_ACCTWTHMRGNBLCKGCONFD"); // 保证金冻结确认被确认账号
					String VC_ACCTWHTMRGNUNBLCKGCONFD = map.get("VC_ACCTWHTMRGNUNBLCKGCONFD"); // 保证金解冻确认被确认账号
					String VC_BDGVRNM = map.get("VC_BDGVRNM"); // 付券方简称
					String VC_BDGVRSUBACCT = map.get("VC_BDGVRSUBACCT"); // 付券方分组合号
					String VC_BDGVRSUBNM = map.get("VC_BDGVRSUBNM"); // 付券方分组合简称
					String VC_BDTAKERACCT = map.get("VC_BDTAKERACCT"); // 收券方账号
					String VC_BDTAKERNM = map.get("VC_BDTAKERNM"); // 收券方简称
					String VC_BDTAKERSUBACCT = map.get("VC_BDTAKERSUBACCT"); // 收券方分组合号
					String VC_BDTAKESUBRNM = map.get("VC_BDTAKESUBRNM"); // 收券方分组合简称
					String VC_TXID = map.get("VC_TXID"); // 业务标识号
					String VC_BIZTPCD = map.get("VC_BIZTPCD"); // 业务类别编号
					String VC_BIZTP = map.get("VC_BIZTP"); // 业务类别描述
					String VC_STTLMTPCD = map.get("VC_STTLMTPCD"); // 结算方式代码
					String VC_STTLMTP = map.get("VC_STTLMTP"); // 结算方式符号描述
					String VC_STTLMTPINCHIN = map.get("VC_STTLMTPINCHIN"); // 结算方式中文描述
					String VC_BDGVRGRTEBDID = map.get("VC_BDGVRGRTEBDID"); // 付券方保证券债券代码
					String VC_BDGVRGRTEBDSHRTNM = map.get("VC_BDGVRGRTEBDSHRTNM"); // 付券方保证券债券简称
					String VC_BDGVRGRTEBDFACEAMT = StrUtil.addThousandth0ToEmpty(map.get("VC_BDGVRGRTEBDFACEAMT"), StrUtil.df1); // 付券方保证券债券面额
					String VC_OTCBUYGFACEAMT = StrUtil.addThousandth0ToEmpty(map.get("VC_OTCBUYGFACEAMT"), StrUtil.df1); // 柜台专项结算买入面额
					String VC_BDGVRCSHCOLL = StrUtil.addThousandth0ToEmpty(map.get("VC_BDGVRCSHCOLL"), StrUtil.df1); // 付券方保证金/融资质押实际融资金额/BEPS质押增加待分配额度/BEPS置换换入额度
					String VC_OTCBUYGVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_OTCBUYGVAL"), StrUtil.df1); // 柜台专项结算买入金额
					String VC_BDTAKERGRTEBDID = map.get("VC_BDTAKERGRTEBDID"); // 收券方保证券债券代码
					String VC_BDTAKERGRTEBDSHRTNM = map.get("VC_BDTAKERGRTEBDSHRTNM"); // 收券方保证券债券简称
					String VC_BDTAKERGRTEBDFACEAMT = StrUtil.addThousandth0ToEmpty(map.get("VC_BDTAKERGRTEBDFACEAMT"), StrUtil.df1); // 收券方保证券债券面额
					String VC_OTCSELLGVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_OTCSELLGVAL"), StrUtil.df1); // 柜台专项结算卖出金额
					String VC_BDTAKERCSHCOLL = StrUtil.addThousandth0ToEmpty(map.get("VC_BDTAKERCSHCOLL"), StrUtil.df1); // 收券方保证金/融资质押起点金额/BEPS置换换出额度
					String VC_OTCSELLGFACEAMT = StrUtil.addThousandth0ToEmpty(map.get("VC_OTCSELLGFACEAMT"), StrUtil.df1); // 柜台专项结算卖出面额
					String VC_BLCKGPMTVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_BLCKGPMTVAL"), StrUtil.df1); // 冻结缴款金额
					String VC_BDCNT = map.get("VC_BDCNT"); // 债券数目
					String VC_TTLFACEAMT = StrUtil.addThousandth0ToEmpty(map.get("VC_TTLFACEAMT"), StrUtil.df1); // 债券总额
					String VC_CTRCTVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_CTRCTVAL"), StrUtil.df1); // 合同金额/BEPS调增、调减额度
					String VC_SCTIESLNDGFEES = StrUtil.addThousandth0ToEmpty(map.get("VC_SCTIESLNDGFEES"), StrUtil.df1); // 借贷业务融券费用
					String VC_RATE = StrUtil.addThousandth0ToEmpty(map.get("VC_RATE"), StrUtil.df1); // 回购利率
					String VC_DLVRYDT = map.get("VC_DLVRYDT"); // 交割日
					String VC_INSTRIDTOCTRCT = map.get("VC_INSTRIDTOCTRCT"); // 生成合同的指令编号
					String VC_ORGNLCTRCTID = map.get("VC_ORGNLCTRCTID"); // 原合同编号(期调、券置换、撤销合同时使用)
					String VC_ORGNLINSTRID = map.get("VC_ORGNLINSTRID"); // 原指令编号(撤销指令的指令时使用)
					String VC_GVRBDSTSCD = map.get("VC_GVRBDSTSCD"); // 付券方券状态
					String VC_GVRBDSTS = map.get("VC_GVRBDSTS"); // 付券方券状态描述
					String VC_GVRGRTEBDSTSCD = map.get("VC_GVRGRTEBDSTSCD"); // 付券方保证券状态
					String VC_GVRGRTEBDSTS = map.get("VC_GVRGRTEBDSTS"); // 付券方保证券状态描述
					String VC_TAKERBDSTSCD = map.get("VC_TAKERBDSTSCD"); // 收券方券状态
					String VC_TAKERBDSTS = map.get("VC_TAKERBDSTS"); // 收券方券状态描述
					String VC_TAKERGRTEBDSTSCD = map.get("VC_TAKERGRTEBDSTSCD"); // 收券方保证券状态
					String VC_TAKERGRTEBD = map.get("VC_TAKERGRTEBD"); // 收券方保证券状态描述
					String VC_CSHSTSCD = map.get("VC_CSHSTSCD"); // 资金状态
					String VC_CSHSTS = map.get("VC_CSHSTS"); // 资金状态描述
					String VC_BLCKDSTSCD = map.get("VC_BLCKDSTSCD"); // 冻结状态
					String VC_BLCKDSTS = map.get("VC_BLCKDSTS"); // 冻结状态描述
					String VC_EXCTDTM = map.get("VC_EXCTDTM"); // 过户时间/失败时间
					String VC_CTRCTSTSCD = map.get("VC_CTRCTSTSCD"); // 合同状态
					String VC_CTRCTSTS = map.get("VC_CTRCTSTS"); // 合同状态描述
					String VC_CTRCTCRETM = map.get("VC_CTRCTCRETM"); // 合同生成时间
					String VC_LASTUPDTM = map.get("VC_LASTUPDTM"); // 最近更新时间
					String VC_BDGVRCSHCOLLSTSCD = map.get("VC_BDGVRCSHCOLLSTSCD"); // 付券方保证金状态
					String VC_BDGVRCSHCOLLSTS = map.get("VC_BDGVRCSHCOLLSTS"); // 付券方保证金状态描述
					String VC_BDTAKERCSHCOLLSTSCD = map.get("VC_BDTAKERCSHCOLLSTSCD"); // 收券方保证金状态
					String VC_BDTAKERCSHCOLLSTS = map.get("VC_BDTAKERCSHCOLLSTS"); // 收券方保证金状态描述
					String VC_BDGVRCSHLCTNCD = map.get("VC_BDGVRCSHLCTNCD"); // 付券方保证金保管地
					String VC_BDGVRCSHLCTN = map.get("VC_BDGVRCSHLCTN"); // 付券方保证金保管地描述
					String VC_BDTAKERCSHLCTNCD = map.get("VC_BDTAKERCSHLCTNCD"); // 收券方保证金保管地
					String VC_BDTAKERCSHLCTN = map.get("VC_BDTAKERCSHLCTN"); // 收券方保证金保管地描述

					//给对象赋值
					obj.setString("VC_CTRCTID",VC_CTRCTID);
					obj.setString("VC_INSTRORGNACCT",VC_INSTRORGNACCT);
					obj.setString("VC_BDGVRACCT",VC_BDGVRACCT);
					obj.setString("VC_ACCTWTHDVPNETGCONFD",VC_ACCTWTHDVPNETGCONFD);
					obj.setString("VC_ACCTWTHMRGNBLCKGCONFD",VC_ACCTWTHMRGNBLCKGCONFD);
					obj.setString("VC_ACCTWHTMRGNUNBLCKGCONFD",VC_ACCTWHTMRGNUNBLCKGCONFD);
					obj.setString("VC_BDGVRNM",VC_BDGVRNM);
					obj.setString("VC_BDGVRSUBACCT",VC_BDGVRSUBACCT);
					obj.setString("VC_BDGVRSUBNM",VC_BDGVRSUBNM);
					obj.setString("VC_BDTAKERACCT",VC_BDTAKERACCT);
					obj.setString("VC_BDTAKERNM",VC_BDTAKERNM);
					obj.setString("VC_BDTAKERSUBACCT",VC_BDTAKERSUBACCT);
					obj.setString("VC_BDTAKESUBRNM",VC_BDTAKESUBRNM);
					obj.setString("VC_TXID",VC_TXID);
					obj.setString("VC_BIZTPCD",VC_BIZTPCD);
					obj.setString("VC_BIZTP",VC_BIZTP);
					obj.setString("VC_STTLMTPCD",VC_STTLMTPCD);
					obj.setString("VC_STTLMTP",VC_STTLMTP);
					obj.setString("VC_STTLMTPINCHIN",VC_STTLMTPINCHIN);
					obj.setString("VC_BDGVRGRTEBDID",VC_BDGVRGRTEBDID);
					obj.setString("VC_BDGVRGRTEBDSHRTNM",VC_BDGVRGRTEBDSHRTNM);
					obj.setString("VC_BDGVRGRTEBDFACEAMT",VC_BDGVRGRTEBDFACEAMT);
					obj.setString("VC_OTCBUYGFACEAMT",VC_OTCBUYGFACEAMT);
					obj.setString("VC_BDGVRCSHCOLL",VC_BDGVRCSHCOLL);
					obj.setString("VC_OTCBUYGVAL",VC_OTCBUYGVAL);
					obj.setString("VC_BDTAKERGRTEBDID",VC_BDTAKERGRTEBDID);
					obj.setString("VC_BDTAKERGRTEBDSHRTNM",VC_BDTAKERGRTEBDSHRTNM);
					obj.setString("VC_BDTAKERGRTEBDFACEAMT",VC_BDTAKERGRTEBDFACEAMT);
					obj.setString("VC_OTCSELLGVAL",VC_OTCSELLGVAL);
					obj.setString("VC_BDTAKERCSHCOLL",VC_BDTAKERCSHCOLL);
					obj.setString("VC_OTCSELLGFACEAMT",VC_OTCSELLGFACEAMT);
					obj.setString("VC_BLCKGPMTVAL",VC_BLCKGPMTVAL);
					obj.setString("VC_BDCNT",VC_BDCNT);
					obj.setString("VC_TTLFACEAMT",VC_TTLFACEAMT);
					obj.setString("VC_CTRCTVAL",VC_CTRCTVAL);
					obj.setString("VC_SCTIESLNDGFEES",VC_SCTIESLNDGFEES);
					obj.setString("VC_RATE",VC_RATE);
					obj.setString("VC_DLVRYDT",VC_DLVRYDT);
					obj.setString("VC_INSTRIDTOCTRCT",VC_INSTRIDTOCTRCT);
					obj.setString("VC_ORGNLCTRCTID",VC_ORGNLCTRCTID);
					obj.setString("VC_ORGNLINSTRID",VC_ORGNLINSTRID);
					obj.setString("VC_GVRBDSTSCD",VC_GVRBDSTSCD);
					obj.setString("VC_GVRBDSTS",VC_GVRBDSTS);
					obj.setString("VC_GVRGRTEBDSTSCD",VC_GVRGRTEBDSTSCD);
					obj.setString("VC_GVRGRTEBDSTS",VC_GVRGRTEBDSTS);
					obj.setString("VC_TAKERBDSTSCD",VC_TAKERBDSTSCD);
					obj.setString("VC_TAKERBDSTS",VC_TAKERBDSTS);
					obj.setString("VC_TAKERGRTEBDSTSCD",VC_TAKERGRTEBDSTSCD);
					obj.setString("VC_TAKERGRTEBD",VC_TAKERGRTEBD);
					obj.setString("VC_CSHSTSCD",VC_CSHSTSCD);
					obj.setString("VC_CSHSTS",VC_CSHSTS);
					obj.setString("VC_BLCKDSTSCD",VC_BLCKDSTSCD);
					obj.setString("VC_BLCKDSTS",VC_BLCKDSTS);
					obj.setString("VC_EXCTDTM",VC_EXCTDTM);
					obj.setString("VC_CTRCTSTSCD",VC_CTRCTSTSCD);
					obj.setString("VC_CTRCTSTS",VC_CTRCTSTS);
					obj.setString("VC_CTRCTCRETM",VC_CTRCTCRETM);
					obj.setString("VC_LASTUPDTM",VC_LASTUPDTM);
					obj.setString("VC_BDGVRCSHCOLLSTSCD",VC_BDGVRCSHCOLLSTSCD);
					obj.setString("VC_BDGVRCSHCOLLSTS",VC_BDGVRCSHCOLLSTS);
					obj.setString("VC_BDTAKERCSHCOLLSTSCD",VC_BDTAKERCSHCOLLSTSCD);
					obj.setString("VC_BDTAKERCSHCOLLSTS",VC_BDTAKERCSHCOLLSTS);
					obj.setString("VC_BDGVRCSHLCTNCD",VC_BDGVRCSHLCTNCD);
					obj.setString("VC_BDGVRCSHLCTN",VC_BDGVRCSHLCTN);
					obj.setString("VC_BDTAKERCSHLCTNCD",VC_BDTAKERCSHLCTNCD);
					obj.setString("VC_BDTAKERCSHLCTN",VC_BDTAKERCSHLCTN);

					result.add(obj);
					obj = null;
				}
			}
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
	 * 分销数据列表查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author fengjunpei
	 */
	@Bizlet("")
	public static List<DataObject> queryFXSJLB(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取数据库连接
			conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_DEFAULT);
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_FXSJLB)){
				SQL_FXSJLB = ZhxxcxUtil.getFileSql("zhxxcx_fxsjlb.sql");
			}

			//获取页面传进来的查询条件值
			String vcStocknm = paramObject.getString("vcStocknm");//证券简称（查询条件传入）
			String vcTradests = paramObject.getString("vcTradests");//交易状态（查询条件传入）
			String vcSellersts = paramObject.getString("vcSellersts");//卖方状态（查询条件传入）
			String vcBuyersts = paramObject.getString("vcBuyersts");//买方状态（查询条件传入）
			String vcSellernm = paramObject.getString("vcSellernm");//卖方持有人简称（查询条件传入）
			String vcBuyernm = paramObject.getString("vcBuyernm");//买方持有人简称（查询条件传入）
			String vcSttlmdt = DateUtil.format(paramObject.getDate("vcSttlmdt"), DateUtil.YMD_NUMBER);//结算日期（查询条件传入）
//			String vcTxdt =  DateUtil.format(paramObject.getDate("vcTxdt"), DateUtil.YEAR_MONTH_DAY_SLASH);//成交日期（查询条件传入）
			//拼接SQL语句
			sb.append(SQL_FXSJLB);
			if(StringUtils.isNotBlank(vcStocknm)){
				sb.append("   and a.vc_Stocknm like '%").append(vcStocknm).append("%'");
			}
			if(StringUtils.isNotBlank(vcTradests)){
				sb.append("   and a.vc_Tradests like '%").append(vcTradests).append("%'");
			}
			if(StringUtils.isNotBlank(vcSellersts)){
				sb.append("   and a.vc_Sellersts like '%").append(vcSellersts).append("%'");
			}
			if(StringUtils.isNotBlank(vcBuyersts)){
				sb.append("   and a.vc_Buyersts like '%").append(vcBuyersts).append("%'");
			}
			if(StringUtils.isNotBlank(vcSellernm)){
				sb.append("   and a.vc_Sellernm like '%").append(vcSellernm).append("%'");
			}
			if(StringUtils.isNotBlank(vcBuyernm)){
				sb.append("   and a.vc_Buyernm like '%").append(vcBuyernm).append("%'");
			}
			if(StringUtils.isNotBlank(vcSttlmdt)){
				sb.append("   and a.vc_Sttlmdt = ").append("'"+vcSttlmdt+"'");
			}
//			if(StringUtils.isNotBlank(vcTxdt)){
//				sb.append("   and a.vc_Txdt = ").append("'"+vcTxdt+"'");
//			}
			//排序SQL语句
			String sqlOrder = "";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					//创建实体对象
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");

					// 获取参数值
					String VC_TXID = map.get("VC_TXID");// 源交易编号
					String VC_TXCD = map.get("VC_TXCD"); // 成交编号
					String VC_TXDT = map.get("VC_TXDT"); // 成交日期
					String VC_TRADESTS = map.get("VC_TRADESTS"); // 交易状态
					String VC_TRADESTSREM = map.get("VC_TRADESTSREM");// 交易状态备注
					String VC_STTLMDT = map.get("VC_STTLMDT"); // 结算日期
					String VC_STOCKCD = map.get("VC_STOCKCD"); // 证券代码
					String VC_STOCKNM = map.get("VC_STOCKNM"); // 证券简称
					String VC_BUYERACCT = map.get("VC_BUYERACCT"); // 买方持有人账号
					String VC_BUYERNM = map.get("VC_BUYERNM"); // 买方持有人简称
					String VC_SELLERACCT = map.get("VC_SELLERACCT"); // 卖方持有人账号
					String VC_SELLERNM = map.get("VC_SELLERNM"); // 卖方持有人简称
					String VC_TXFACEAMT = StrUtil.addThousandth0ToEmpty(map.get("VC_TXFACEAMT"), StrUtil.df1); // 成交面额(万元)
					String VC_STTLMVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_STTLMVAL"), StrUtil.df1); // 结算金额(元)
					String VC_PERCLPRIC = StrUtil.addThousandth0ToEmpty(map.get("VC_PERCLPRIC"), StrUtil.df1);// 百元净价(元)
					String VC_PEROHPRIC = StrUtil.addThousandth0ToEmpty(map.get("VC_PEROHPRIC"), StrUtil.df1); // 百元全价(元)
					String VC_INTEREST = StrUtil.addThousandth0ToEmpty(map.get("VC_INTEREST"), StrUtil.df1); // 应计利息(元)
					String VC_CLTP = map.get("VC_CLTP"); // 清算方式
					String VC_STTLMTP = map.get("VC_STTLMTP"); // 结算方式
					String VC_BUYERSTS = map.get("VC_BUYERSTS"); // 买方状态
					String VC_BUYERSTSREM = map.get("VC_BUYERSTSREM"); // 买方状态备注
					String VC_SELLERSTS = map.get("VC_SELLERSTS"); // 卖方状态
					String VC_SELLERSTSREM = map.get("VC_SELLERSTSREM"); // 卖方状态备注
					String VC_TRADESRC = map.get("VC_TRADESRC"); // 交易来源

					//给对象赋值
					obj.setString("VC_TXID", VC_TXID);
					obj.setString("VC_TXCD", VC_TXCD);
					obj.setString("VC_TXDT", VC_TXDT);
					obj.setString("VC_TRADESTS", VC_TRADESTS);
					obj.setString("VC_TRADESTSREM", VC_TRADESTSREM);
					obj.setString("VC_STTLMDT",VC_STTLMDT);
					obj.setString("VC_STOCKCD",VC_STOCKCD);
					obj.setString("VC_STOCKNM",VC_STOCKNM);
					obj.setString("VC_BUYERACCT",VC_BUYERACCT);
					obj.setString("VC_BUYERNM",VC_BUYERNM);
					obj.setString("VC_SELLERACCT",VC_SELLERACCT);
					obj.setString("VC_SELLERNM",VC_SELLERNM);
					obj.setString("VC_TXFACEAMT",VC_TXFACEAMT);
					obj.setString("VC_STTLMVAL",VC_STTLMVAL);
					obj.setString("VC_PERCLPRIC",VC_PERCLPRIC);
					obj.setString("VC_PEROHPRIC",VC_PEROHPRIC);
					obj.setString("VC_INTEREST",VC_INTEREST);
					obj.setString("VC_CLTP",VC_CLTP);
					obj.setString("VC_STTLMTP",VC_STTLMTP);
					obj.setString("VC_BUYERSTS",VC_BUYERSTS);
					obj.setString("VC_BUYERSTSREM",VC_BUYERSTSREM);
					obj.setString("VC_SELLERSTS",VC_SELLERSTS);
					obj.setString("VC_SELLERSTSREM",VC_SELLERSTSREM);
					obj.setString("VC_TRADESRC",VC_TRADESRC);

					result.add(obj);
					obj = null;
				}
			}
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
	 * 买断式回购列表查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author fengjunpei
	 */
	@Bizlet("")
	public static List<DataObject> queryMDSHGLB(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取数据库连接
			conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_DEFAULT);
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_MDSHGLB)){
				SQL_MDSHGLB = ZhxxcxUtil.getFileSql("zhxxcx_mdshglb.sql");
			}
			//获取页面传进来的查询条件值
			String vcTxdt = DateUtil.format(paramObject.getDate("VC_TXDT"), DateUtil.YMD_NUMBER);//成交日期（查询条件传入）
			String vcTradests = paramObject.getString("VC_TRADESTS");//交易状态（查询条件传入）
			String vcStocknm = paramObject.getString("VC_STOCKNM");//证券简称（查询条件传入）
			String vcSellreponm = paramObject.getString("VC_SELLREPONM");//正回购方持有人简称（查询条件传入）
			String vcRevreponm = paramObject.getString("VC_REVREPONM");//逆回购方持有人简称（查询条件传入）
			String vcFrststtlmdt = DateUtil.format(paramObject.getDate("VC_FRSTSTTLMDT"), DateUtil.YMD_NUMBER);//首期结算日期（查询条件传入）
			String vcScndsttlmdt = DateUtil.format(paramObject.getDate("VC_SCNDSTTLMDT"), DateUtil.YMD_NUMBER);//到期结算日期（查询条件传入）
			String vcSellreposts = paramObject.getString("VC_SELLREPOSTS");//正回购方状态（查询条件传入）
			String vcRevreposts =  paramObject.getString("VC_REVREPOSTS");//逆回购方状态（查询条件传入）
			//拼接SQL语句
			sb.append(SQL_MDSHGLB);
			if(StringUtils.isNotBlank(vcTxdt)){
				sb.append("   and a.vc_txdt like '%").append(vcTxdt).append("%'");
			}
			if(StringUtils.isNotBlank(vcTradests)){
				sb.append("   and a.vc_tradests like '%").append(vcTradests).append("%'");
			}
			if(StringUtils.isNotBlank(vcStocknm)){
				sb.append("   and a.vc_stocknm like '%").append(vcStocknm).append("%'");
			}
			if(StringUtils.isNotBlank(vcSellreponm)){
				sb.append("   and a.vc_sellreponm like '%").append(vcSellreponm).append("%'");
			}
			if(StringUtils.isNotBlank(vcRevreponm)){
				sb.append("   and a.vc_revreponm like '%").append(vcRevreponm).append("%'");
			}
			if(StringUtils.isNotBlank(vcFrststtlmdt)){
				sb.append("   and a.vc_frststtlmdt = ").append("'"+vcFrststtlmdt+"'");
			}
			if(StringUtils.isNotBlank(vcScndsttlmdt)){
				sb.append("   and a.vc_scndsttlmdt = ").append("'"+vcScndsttlmdt+"'");
			}
			if(StringUtils.isNotBlank(vcTxdt)){
				sb.append("   and a.vc_sellreposts like '%").append(vcSellreposts).append("%'");
			}
			if(StringUtils.isNotBlank(vcRevreposts)){
				sb.append("   and a.vc_revreposts like '%").append(vcRevreposts).append("%'");
			}
			//排序SQL语句
			String sqlOrder = "";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					//创建实体对象
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");

					// 获取参数值
					String VC_TXID = map.get("VC_TXID");// 源交易编号
					String VC_TXCD = map.get("VC_TXCD");// 成交编号
					String VC_TXDT = map.get("VC_TXDT"); // 成交日期
					String VC_TRADESTS = map.get("VC_TRADESTS"); // 交易状态
					String VC_TRADERSTSEM = map.get("VC_TRADERSTSEM"); // 交易状态备注
					String VC_STOCKCD = map.get("VC_STOCKCD"); // 证券代码
					String VC_STOCKNM = map.get("VC_STOCKNM"); // 证券简称
					String VC_SELLREPOACCT = map.get("VC_SELLREPOACCT"); // 正回购方持有人账号
					String VC_SELLREPONM = map.get("VC_SELLREPONM"); // 正回购方持有人简称
					String VC_REVREPOACCT = map.get("VC_REVREPOACCT"); // 逆回购方持有人账号
					String VC_REVREPONM = map.get("VC_REVREPONM"); // 逆回购方持有人简称
					String VC_REPODAYS = map.get("VC_REPODAYS"); // 回购天数
					String VC_CLTP = map.get("VC_CLTP"); // 清算方式
					String VC_STTLMVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_STTLMVAL"), StrUtil.df1); // 成交面额(万元)
					String VC_FRSTSTTLMVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_FRSTSTTLMVAL"), StrUtil.df1); // 首期结算金额(元)
					String VC_FRSTSTTLMTP = map.get("VC_FRSTSTTLMTP"); // 首期结算方式
					String VC_FRSTSTTLMDT = map.get("VC_FRSTSTTLMDT"); // 首期结算日期
					String VC_SCNDSTTLMVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_SCNDSTTLMVAL"), StrUtil.df1); // 到期结算金额(元)
					String VC_SCNDSTTLMTP = map.get("VC_SCNDSTTLMTP"); // 到期结算方式
					String VC_SCNDSTTLMDT = map.get("VC_SCNDSTTLMDT"); // 到期结算日期
					String VC_SELLREPOSTS = map.get("VC_SELLREPOSTS"); // 正回购方状态
					String VC_SELLREPOSTSREM = map.get("VC_SELLREPOSTSREM"); // 正回购方状态备注
					String VC_REVREPOSTS = map.get("VC_REVREPOSTS"); // 逆回购方状态
					String VC_REVREPOSTSREM = map.get("VC_REVREPOSTSREM"); // 逆回购方状态备注
					String VC_TRADESRC = map.get("VC_TRADESRC"); // 交易来源
					//给对象赋值
					obj.setString("VC_TXID", VC_TXID);
					obj.setString("VC_TXCD", VC_TXCD);
					obj.setString("VC_TXDT", VC_TXDT);
					obj.setString("VC_TRADESTS", VC_TRADESTS);
					obj.setString("VC_TRADERSTSEM", VC_TRADERSTSEM);
					obj.setString("VC_STOCKCD", VC_STOCKCD);
					obj.setString("VC_STOCKNM", VC_STOCKNM);
					obj.setString("VC_SELLREPOACCT", VC_SELLREPOACCT);
					obj.setString("VC_SELLREPONM", VC_SELLREPONM);
					obj.setString("VC_REVREPOACCT", VC_REVREPOACCT);
					obj.setString("VC_REVREPONM", VC_REVREPONM);
					obj.setString("VC_REPODAYS", VC_REPODAYS);
					obj.setString("VC_CLTP", VC_CLTP);
					obj.setString("VC_STTLMVAL", VC_STTLMVAL);
					obj.setString("VC_FRSTSTTLMVAL", VC_FRSTSTTLMVAL);
					obj.setString("VC_FRSTSTTLMTP", VC_FRSTSTTLMTP);
					obj.setString("VC_FRSTSTTLMDT", VC_FRSTSTTLMDT);
					obj.setString("VC_SCNDSTTLMVAL", VC_SCNDSTTLMVAL);
					obj.setString("VC_SCNDSTTLMTP", VC_SCNDSTTLMTP);
					obj.setString("VC_SCNDSTTLMDT", VC_SCNDSTTLMDT);
					obj.setString("VC_SELLREPOSTS", VC_SELLREPOSTS);
					obj.setString("VC_SELLREPOSTSREM", VC_SELLREPOSTSREM);
					obj.setString("VC_REVREPOSTS", VC_REVREPOSTS);
					obj.setString("VC_REVREPOSTSREM", VC_REVREPOSTSREM);
					obj.setString("VC_TRADESRC", VC_TRADESRC);
					result.add(obj);
					obj = null;
				}
			}
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
	 * 现券交易列表查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author fengjunpei
	 */
	@Bizlet("")
	public static List<DataObject> queryXQJYLB(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取数据库连接
			conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_DEFAULT);
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_XQJYLB)){
				SQL_XQJYLB = ZhxxcxUtil.getFileSql("zhxxcx_xqjylb.sql");
			}
			//获取页面传进来的查询条件值
//			String vcTxdt = DateUtil.format(paramObject.getDate("vcTxdt"), DateUtil.YEAR_MONTH_DAY_SLASH);//交易日期（查询条件传入）
			String vcTradests = paramObject.getString("vcTradests");//交易状态（查询条件传入）
			String vcBuyernm = paramObject.getString("vcBuyernm");//买方持有人简称（查询条件传入）
			String vcSellernm = paramObject.getString("vcSellernm");//卖方持有人简称（查询条件传入）
			String vcBuyersts = paramObject.getString("vcBuyersts");//买方状态（查询条件传入）
			String vcSellersts = paramObject.getString("vcSellersts");//卖方状态（查询条件传入）
//			String vcSttlmdt = DateUtil.format(paramObject.getDate("vcSttlmdt"), DateUtil.YEAR_MONTH_DAY_SLASH);//结算日期（查询条件传入）
			String vcStocknm =  paramObject.getString("vcStocknm");//证券简称（查询条件传入）
			//拼接SQL语句
			sb.append(SQL_XQJYLB);
//			if(StringUtils.isNotBlank(vcTxdt)){
//				sb.append("   and a.vc_Txdt = ").append("'"+vcTxdt+"'");
//			}
			if(StringUtils.isNotBlank(vcTradests)){
				sb.append("   and a.vc_Tradests like '%").append(vcTradests).append("%'");
			}
			if(StringUtils.isNotBlank(vcBuyernm)){
				sb.append("   and a.vc_Buyernm like '%").append(vcBuyernm).append("%'");
			}
			if(StringUtils.isNotBlank(vcBuyersts)){
				sb.append("   and a.vc_Buyersts like '%").append(vcBuyersts).append("%'");
			}
			if(StringUtils.isNotBlank(vcSellernm)){
				sb.append("   and a.vc_Sellernm like '%").append(vcSellernm).append("%'");
			}
			if(StringUtils.isNotBlank(vcSellersts)){
				sb.append("   and a.vc_Sellersts like '%").append(vcSellersts).append("%'");
			}
//			if(StringUtils.isNotBlank(vcSttlmdt)){
//				sb.append("   and a.vc_Sttlmdt = ").append("'"+vcSttlmdt+"'");
//			}
			if(StringUtils.isNotBlank(vcStocknm)){
				sb.append("   and a.vc_Stocknm like '%").append(vcStocknm).append("%'");
			}
			//排序SQL语句
			String sqlOrder = "";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					//创建实体对象
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");

					// 获取参数值
					String VC_TXID = map.get("VC_TXID"); // 源交易编号
					String VC_TXCD = map.get("VC_TXCD"); // 成交编号
					String VC_TXDT = map.get("VC_TXDT"); // 交易日期
					String VC_TRADESTS = map.get("VC_TRADESTS"); // 交易状态
					String VC_TRADESTSREM = map.get("VC_TRADESTSREM"); // 交易状态备注
					String VC_STTLMDT = map.get("VC_STTLMDT"); // 结算日期
					String VC_STOCKCD = map.get("VC_STOCKCD"); // 证券代码
					String VC_STOCKNM = map.get("VC_STOCKNM"); // 证券简称
					String VC_BUYERACCT = map.get("VC_BUYERACCT"); // 买方持有人账号
					String VC_BUYERNM = map.get("VC_BUYERNM"); // 买方持有人简称
					String VC_SELLERACCT = map.get("VC_SELLERACCT"); // 卖方持有人账号
					String VC_SELLERNM = map.get("VC_SELLERNM"); // 卖方持有人简称
					String VC_TXFACEAMT = StrUtil.addThousandth0ToEmpty(map.get("VC_TXFACEAMT"), StrUtil.df1); // 成交面额(万元)
					String VC_STTLMVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_STTLMVAL"), StrUtil.df1); // 结算金额(元)
					String VC_PERCLPRIC = StrUtil.addThousandth0ToEmpty(map.get("VC_PERCLPRIC"), StrUtil.df1); // 百元净价(元)
					String VC_PEROHPRIC = StrUtil.addThousandth0ToEmpty(map.get("VC_PEROHPRIC"), StrUtil.df1); // 百元全价(元)
					String VC_INTEREST = StrUtil.addThousandth0ToEmpty(map.get("VC_INTEREST"), StrUtil.df1); // 应计利息(元)
					String VC_CLTP = map.get("VC_CLTP"); // 清算方式
					String VC_STTLMTP = map.get("VC_STTLMTP"); // 结算方式
					String VC_BUYERSTS = map.get("VC_BUYERSTS"); // 买方状态
					String VC_BUYERSTSREM = map.get("VC_BUYERSTSREM"); // 买方状态备注
					String VC_SELLERSTS = map.get("VC_SELLERSTS"); // 卖方状态
					String VC_SELLERSTSREM = map.get("VC_SELLERSTSREM"); // 卖方状态备注
					String VC_TRADESRC = map.get("VC_TRADESRC"); // 交易来源
					// 给对象赋值
					obj.setString("VC_TXID", VC_TXID);
					obj.setString("VC_TXCD", VC_TXCD);
					obj.setString("VC_TXDT", VC_TXDT);
					obj.setString("VC_TRADESTS", VC_TRADESTS);
					obj.setString("VC_TRADESTSREM", VC_TRADESTSREM);
					obj.setString("VC_STTLMDT", VC_STTLMDT);
					obj.setString("VC_STOCKCD", VC_STOCKCD);
					obj.setString("VC_STOCKNM", VC_STOCKNM);
					obj.setString("VC_BUYERACCT", VC_BUYERACCT);
					obj.setString("VC_BUYERNM", VC_BUYERNM);
					obj.setString("VC_SELLERACCT", VC_SELLERACCT);
					obj.setString("VC_SELLERNM", VC_SELLERNM);
					obj.setString("VC_TXFACEAMT", VC_TXFACEAMT);
					obj.setString("VC_STTLMVAL", VC_STTLMVAL);
					obj.setString("VC_PERCLPRIC", VC_PERCLPRIC);
					obj.setString("VC_PEROHPRIC", VC_PEROHPRIC);
					obj.setString("VC_INTEREST", VC_INTEREST);
					obj.setString("VC_CLTP", VC_CLTP);
					obj.setString("VC_STTLMTP", VC_STTLMTP);
					obj.setString("VC_BUYERSTS", VC_BUYERSTS);
					obj.setString("VC_BUYERSTSREM", VC_BUYERSTSREM);
					obj.setString("VC_SELLERSTS", VC_SELLERSTS);
					obj.setString("VC_SELLERSTSREM", VC_SELLERSTSREM);
					obj.setString("VC_TRADESRC", VC_TRADESRC);

					result.add(obj);
					obj = null;
				}
			}
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
	 * 质押式回购列表查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author fengjunpei
	 */
	@Bizlet("")
	public static List<DataObject> queryZYSHGLB(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取数据库连接
			conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_DEFAULT);
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_ZYSHGLB)){
				SQL_ZYSHGLB = ZhxxcxUtil.getFileSql("zhxxcx_zyshglb.sql");
			}
			//获取页面传进来的查询条件值
			String vcTxdt = DateUtil.format(paramObject.getDate("VC_TXDT"), DateUtil.YMD_NUMBER);//成交日期（查询条件传入）
			String vcTradests = paramObject.getString("VC_TRADESTS");//交易状态（查询条件传入）
			String vcSellreponm = paramObject.getString("VC_SELLREPONM");//正回购方持有人简称（查询条件传入）
			String vcRevreponm = paramObject.getString("VC_REVREPONM");//逆回购方持有人简称（查询条件传入）
			String vcFrststtlmdt = DateUtil.format(paramObject.getDate("VC_FRSTSTTLMDT"), DateUtil.YMD_NUMBER);//首期结算日期（查询条件传入）
			String vcScndsttlmdt = DateUtil.format(paramObject.getDate("VC_SCNDSTTLMDT"), DateUtil.YMD_NUMBER);//到期结算日期（查询条件传入）
			String vcSellreposts = paramObject.getString("VC_SELLREPOSTS");//正回购方状态（查询条件传入）
			String vcRevreposts =  paramObject.getString("VC_REVREPOSTS");//逆回购方状态（查询条件传入）
			//拼接SQL语句
			sb.append(SQL_ZYSHGLB);
			if(StringUtils.isNotBlank(vcTxdt)){
				sb.append("   and a.vc_txdt like '%").append(vcTxdt).append("%'");
			}
			if(StringUtils.isNotBlank(vcTradests)){
				sb.append("   and a.vc_tradests like '%").append(vcTradests).append("%'");
			}
			if(StringUtils.isNotBlank(vcSellreponm)){
				sb.append("   and a.vc_sellreponm like '%").append(vcSellreponm).append("%'");
			}
			if(StringUtils.isNotBlank(vcRevreponm)){
				sb.append("   and a.vc_revreponm like '%").append(vcRevreponm).append("%'");
			}
			if(StringUtils.isNotBlank(vcFrststtlmdt)){
				sb.append("   and a.vc_frststtlmdt = ").append("'"+vcFrststtlmdt+"'");
			}
			if(StringUtils.isNotBlank(vcScndsttlmdt)){
				sb.append("   and a.vc_scndsttlmdt = ").append("'"+vcScndsttlmdt+"'");
			}
			if(StringUtils.isNotBlank(vcTxdt)){
				sb.append("   and a.vc_sellreposts like '%").append(vcSellreposts).append("%'");
			}
			if(StringUtils.isNotBlank(vcRevreposts)){
				sb.append("   and a.vc_revreposts like '%").append(vcRevreposts).append("%'");
			}
			//排序SQL语句
			String sqlOrder = "";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					//创建实体对象
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");

					// 获取参数值
					String VC_TXID = map.get("VC_TXID"); // 源交易编号
					String VC_TXCD = map.get("VC_TXCD"); // 成交编号
					String VC_TXDT = map.get("VC_TXDT"); // 成交日期
					String VC_TRADESTS = map.get("VC_TRADESTS"); // 交易状态
					String VC_TRADEREM = map.get("VC_TRADEREM"); // 交易状态备注
					String VC_SELLREPOACCT = map.get("VC_SELLREPOACCT"); // 正回购方持有人账号
					String VC_SELLREPONM = map.get("VC_SELLREPONM"); // 正回购方持有人简称
					String VC_REVREPOACCT = map.get("VC_REVREPOACCT"); // 逆回购方持有人账号
					String VC_REVREPONM = map.get("VC_REVREPONM"); // 逆回购方持有人简称
					String VC_REPODAYS = map.get("VC_REPODAYS"); // 回购天数
					String VC_CLTP = map.get("VC_CLTP"); // 清算方式
					String VC_FRSTSTTLMVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_FRSTSTTLMVAL"), StrUtil.df1); // 首期结算金额(元)
					String VC_FRSTSTTLMTP = map.get("VC_FRSTSTTLMTP"); // 首期结算方式
					String VC_FRSTSTTLMDT = map.get("VC_FRSTSTTLMDT"); // 首期结算日期
					String VC_SCNDSTTLMVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_SCNDSTTLMVAL"), StrUtil.df1); // 到期结算金额(元)
					String VC_SCNDSTTLMTP = map.get("VC_SCNDSTTLMTP"); // 到期结算方式
					String VC_SCNDSTTLMDT = map.get("VC_SCNDSTTLMDT"); // 到期结算日期
					String VC_SELLREPOSTS = map.get("VC_SELLREPOSTS"); // 正回购方状态
					String VC_SELLREPOSTSREM = map.get("VC_SELLREPOSTSREM"); // 正回购方状态备注
					String VC_REVREPOSTS = map.get("VC_REVREPOSTS"); // 逆回购方状态
					String VC_REVREPOSTSREM = map.get("VC_REVREPOSTSREM"); // 逆回购方状态备注
					String VC_TRADESRC = map.get("VC_TRADESRC"); // 交易来源

					// 给对象赋值
					obj.setString("VC_TXID", VC_TXID);
					obj.setString("VC_TXCD", VC_TXCD);
					obj.setString("VC_TXDT", VC_TXDT);
					obj.setString("VC_TRADESTS", VC_TRADESTS);
					obj.setString("VC_TRADEREM", VC_TRADEREM);
					obj.setString("VC_SELLREPOACCT", VC_SELLREPOACCT);
					obj.setString("VC_SELLREPONM", VC_SELLREPONM);
					obj.setString("VC_REVREPOACCT", VC_REVREPOACCT);
					obj.setString("VC_REVREPONM", VC_REVREPONM);
					obj.setString("VC_REPODAYS", VC_REPODAYS);
					obj.setString("VC_CLTP", VC_CLTP);
					obj.setString("VC_FRSTSTTLMVAL", VC_FRSTSTTLMVAL);
					obj.setString("VC_FRSTSTTLMTP", VC_FRSTSTTLMTP);
					obj.setString("VC_FRSTSTTLMDT", VC_FRSTSTTLMDT);
					obj.setString("VC_SCNDSTTLMVAL", VC_SCNDSTTLMVAL);
					obj.setString("VC_SCNDSTTLMTP", VC_SCNDSTTLMTP);
					obj.setString("VC_SCNDSTTLMDT", VC_SCNDSTTLMDT);
					obj.setString("VC_SELLREPOSTS", VC_SELLREPOSTS);
					obj.setString("VC_SELLREPOSTSREM", VC_SELLREPOSTSREM);
					obj.setString("VC_REVREPOSTS", VC_REVREPOSTS);
					obj.setString("VC_REVREPOSTSREM", VC_REVREPOSTSREM);
					obj.setString("VC_TRADESRC", VC_TRADESRC);
					result.add(obj);
					obj = null;
				}
			}
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
	 * 全额结算指令列表查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author fengjunpei
	 */
	@Bizlet("")
	public static List<DataObject> queryQEJSZL(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取数据中心数据库连接
			conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_DEFAULT);
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_QEJSZL)){
				SQL_QEJSZL = ZhxxcxUtil.getFileSql("zhxxcx_qejszl.sql");
			}
			//获取页面传进来的查询条件值
			String vcBiztp = paramObject.getString("vcBiztp");//业务品种（查询条件传入）
			String vcSttlmordersts = paramObject.getString("vcSttlmordersts");//结算指令状态（查询条件传入）
			String vcProdsttlmsts = paramObject.getString("vcProdsttlmsts");//产品结算状态（查询条件传入）
			String vcFundsttlmsts = paramObject.getString("vcFundsttlmsts");//资金结算状态（查询条件传入）
			String vcBuyershortnm = paramObject.getString("vcBuyershortnm");//买/融入/逆回购方简称（查询条件传入）
			String vcSellershortnm = paramObject.getString("vcSellershortnm");//卖/融出/正回购方简称（查询条件传入）
			String vcStocknm = paramObject.getString("vcStocknm");//证券简称（查询条件传入）
//			String vcSttlmdt =  DateUtil.format(paramObject.getDate("vcSttlmdt"), DateUtil.YEAR_MONTH_DAY_SLASH);//结算日（查询条件传入）
//			String vcOdrgnrtdate = DateUtil.format(paramObject.getDate("vcOdrgnrtdate"), DateUtil.YEAR_MONTH_DAY_SLASH);//指令生成日（查询条件传入）
			//拼接SQL语句
			sb.append(SQL_QEJSZL);
			if(StringUtils.isNotBlank(vcBiztp)){
				sb.append("   and a.vc_biztp like '%").append(vcBiztp).append("%'");
			}
			if(StringUtils.isNotBlank(vcSttlmordersts)){
				sb.append("   and a.vc_sttlmordersts like '%").append(vcSttlmordersts).append("%'");
			}
			if(StringUtils.isNotBlank(vcProdsttlmsts)){
				sb.append("   and a.vc_prodsttlmsts like '%").append(vcProdsttlmsts).append("%'");
			}
			if(StringUtils.isNotBlank(vcFundsttlmsts)){
				sb.append("   and a.vc_fundsttlmsts like '%").append(vcFundsttlmsts).append("%'");
			}
			if(StringUtils.isNotBlank(vcBuyershortnm)){
				sb.append("   and a.vc_buyershortnm like '%").append(vcBuyershortnm).append("%'");
			}
			if(StringUtils.isNotBlank(vcSellershortnm)){
				sb.append("   and a.vc_sellershortnm like '%").append(vcSellershortnm).append("%'");
			}
			if(StringUtils.isNotBlank(vcStocknm)){
				sb.append("   and a.vc_stocknm like '%").append(vcStocknm).append("%'");
			}
//			if(StringUtils.isNotBlank(vcSttlmdt)){
//				sb.append("   and a.vc_sttlmdt = ").append("'"+vcSttlmdt+"'");
//			}
//			if(StringUtils.isNotBlank(vcOdrgnrtdate)){
//				sb.append("   and a.vc_odrgnrtdate = ").append("'"+vcOdrgnrtdate+"'");
//			}
			//排序SQL语句
			String sqlOrder = "";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					//创建实体对象
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");

					// 获取参数值
					String VC_TXID = map.get("VC_TXID");// 源交易编号
					String VC_STTLMORDERCD = map.get("VC_STTLMORDERCD");// 结算指令编号
					String VC_TXDT = map.get("VC_TXDT");// 成交编号
					String VC_FRSTORSCND = map.get("VC_FRSTORSCND");// 首期/到期
					String VC_BIZTP = map.get("VC_BIZTP");// 业务品种
					String VC_STTLMTP = map.get("VC_STTLMTP");// 结算方式
					String VC_STTLMORDERSTS = map.get("VC_STTLMORDERSTS");// 结算指令状态
					String VC_PRODSTTLMSTS = map.get("VC_PRODSTTLMSTS");// 产品结算状态
					String VC_FUNDSTTLMSTS = map.get("VC_FUNDSTTLMSTS");// 资金结算状态
					String VC_BUYERACCT = map.get("VC_BUYERACCT");// 买/融入/逆回购方账号
					String VC_BUYERSHORTNM = map.get("VC_BUYERSHORTNM");// 买/融入/逆回购方简称
					String VC_BUYERAGNTACCT = map.get("VC_BUYERAGNTACCT");// 买/融入/逆回购方代理账号
					String VC_BUYERAGNTSHORTNM = map.get("VC_BUYERAGNTSHORTNM");// 买/融入/逆回购方代理简称
					String VC_SELLERACCT = map.get("VC_SELLERACCT");// 卖/融出/正回购方账号
					String VC_SELLERSHORTNM = map.get("VC_SELLERSHORTNM");// 卖/融出/正回购方简称
					String VC_SELLERAGNTACCT = map.get("VC_SELLERAGNTACCT");// 卖/融出/正回购方代理账号
					String VC_SELLERAGNTSHORTNM = map.get("VC_SELLERAGNTSHORTNM");// 卖/融出/正回购方代理简称
					String VC_STOCKCD = map.get("VC_STOCKCD");// 证券代码
					String VC_STOCKNM = map.get("VC_STOCKNM");// 证券简称
					String VC_STOCKFACEAMT = StrUtil.addThousandth0ToEmpty(map.get("VC_STOCKFACEAMT"), StrUtil.df1);// 证券面额(万元)
					String VC_FUNDSTTLMVAL = StrUtil.addThousandth0ToEmpty(map.get("VC_FUNDSTTLMVAL"), StrUtil.df1);// 资金结算金额(元)
					String VC_STTLMDT = map.get("VC_STTLMDT");// 结算日
					String VC_ODRGNRTDATE = map.get("VC_ODRGNRTDATE");// 指令生成日
					String VC_ODRFRSTGNRTTM = map.get("VC_ODRFRSTGNRTTM");// 指令首次创建时间
					String VC_ODRUPDATETM = map.get("VC_ODRUPDATETM");// 指令更新时间
					String VC_PRODSTTLMGRACE = map.get("VC_PRODSTTLMGRACE");// 产品结算宽限期
					String VC_FUNDSTTLMGRACE = map.get("VC_FUNDSTTLMGRACE");// 资金结算宽限期
					String VC_RCVPMTCFMER = map.get("VC_RCVPMTCFMER");// 收付款确认人
					String VC_RCVPMTCFMCHECKER = map.get("VC_RCVPMTCFMCHECKER");// 收付款确认复核人
					String VC_ODRREVOCATIONSIDE = map.get("VC_ODRREVOCATIONSIDE");// 指令撤销方
					String VC_REVOCATIONTM = map.get("VC_REVOCATIONTM");// 撤销时间
					String VC_REVOCATIONCFMER = map.get("VC_REVOCATIONCFMER");// 撤销确认方
					String VC_REVOCATIONCFMTM = map.get("VC_REVOCATIONCFMTM");// 撤销确认时间
					String VC_REVOCATIONRSLT = map.get("VC_REVOCATIONRSLT");// 撤销处理结果

					// 给对象赋值
					obj.setString("VC_TXID", VC_TXID);
					obj.setString("VC_STTLMORDERCD", VC_STTLMORDERCD);
					obj.setString("VC_TXDT", VC_TXDT);
					obj.setString("VC_FRSTORSCND", VC_FRSTORSCND);
					obj.setString("VC_BIZTP", VC_BIZTP);
					obj.setString("VC_STTLMTP", VC_STTLMTP);
					obj.setString("VC_STTLMORDERSTS", VC_STTLMORDERSTS);
					obj.setString("VC_PRODSTTLMSTS", VC_PRODSTTLMSTS);
					obj.setString("VC_FUNDSTTLMSTS", VC_FUNDSTTLMSTS);
					obj.setString("VC_BUYERACCT", VC_BUYERACCT);
					obj.setString("VC_BUYERSHORTNM", VC_BUYERSHORTNM);
					obj.setString("VC_BUYERAGNTACCT", VC_BUYERAGNTACCT);
					obj.setString("VC_BUYERAGNTSHORTNM", VC_BUYERAGNTSHORTNM);
					obj.setString("VC_SELLERACCT", VC_SELLERACCT);
					obj.setString("VC_SELLERSHORTNM", VC_SELLERSHORTNM);
					obj.setString("VC_SELLERAGNTACCT", VC_SELLERAGNTACCT);
					obj.setString("VC_SELLERAGNTSHORTNM", VC_SELLERAGNTSHORTNM);
					obj.setString("VC_STOCKCD", VC_STOCKCD);
					obj.setString("VC_STOCKNM", VC_STOCKNM);
					obj.setString("VC_STOCKFACEAMT", VC_STOCKFACEAMT);
					obj.setString("VC_FUNDSTTLMVAL", VC_FUNDSTTLMVAL);
					obj.setString("VC_STTLMDT", VC_STTLMDT);
					obj.setString("VC_ODRGNRTDATE", VC_ODRGNRTDATE);
					obj.setString("VC_ODRFRSTGNRTTM", VC_ODRFRSTGNRTTM);
					obj.setString("VC_ODRUPDATETM", VC_ODRUPDATETM);
					obj.setString("VC_PRODSTTLMGRACE", VC_PRODSTTLMGRACE);
					obj.setString("VC_FUNDSTTLMGRACE", VC_FUNDSTTLMGRACE);
					obj.setString("VC_RCVPMTCFMER", VC_RCVPMTCFMER);
					obj.setString("VC_RCVPMTCFMCHECKER", VC_RCVPMTCFMCHECKER);
					obj.setString("VC_ODRREVOCATIONSIDE", VC_ODRREVOCATIONSIDE);
					obj.setString("VC_REVOCATIONTM", VC_REVOCATIONTM);
					obj.setString("VC_REVOCATIONCFMER", VC_REVOCATIONCFMER);
					obj.setString("VC_REVOCATIONCFMTM", VC_REVOCATIONCFMTM);
					obj.setString("VC_REVOCATIONRSLT", VC_REVOCATIONRSLT);

					result.add(obj);
					obj = null;
				}
			}
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
	 * 关闭执行O32存储过程功能
	 * @author fengjunpei
	 */
	@Bizlet("")
	public static boolean closeCallO32Procedure(){
		endTime_callO32Procedure = DateUtil.getNow();
		System.out.println(DateUtil.currentDateTimeString()+"  关闭执行O32存储过程功能成功，结束时间："+endTime_callO32Procedure);
		return true;
	}

	/**
	 * 关闭执行O32存储过程-新功能
	 * @author fengjunpei
	 */
	@Bizlet("")
	public static boolean closeCallO32ProcedureNew(){
		endTime_callO32ProcedureNew = DateUtil.getNow();
		System.out.println(DateUtil.currentDateTimeString()+"  关闭执行O32存储过程-新功能成功，结束时间："+endTime_callO32ProcedureNew);
		return true;
	}


	/**
	 * 综合信息查询-恒生科目余额表
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author fengjunpei
	 */
	@Bizlet("")
	public static List<DataObject> queryHSKMYEB(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取数据中心数据库连接
			conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_SJZX);
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_HSKMYEB)){
				SQL_HSKMYEB = getFileSql("zhxxcx_hskmyeb.sql");
			}

			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String busiDateEnd = DateUtil.format(paramObject.getDate("busiDateEnd"), DateUtil.YMD_NUMBER);//截至业务日期
			String vCKmdm = paramObject.getString("vCKmdm");//科目代码
			String vCKmmc = paramObject.getString("vCKmmc");//科目名称

			//拼接SQL语句
			sb.append(SQL_HSKMYEB);
			if(StringUtils.isNotBlank(busiDateEnd)){
				sb.append("   and a.l_date = ").append(busiDateEnd);
			}
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and b.vc_code in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vCFundCode)){
				sb.append("   and b.vc_code in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(vCKmdm)){
				sb.append("   and a.vc_code like '%" + vCKmdm + "%'");
			}
			if(StringUtils.isNotBlank(vCKmmc)){
				sb.append("   and a.vc_name like '%" + vCKmmc + "%'");
			}
			sb.append(" order by a.l_date desc, a.l_fundid asc, a.vc_code asc");

			//排序SQL语句
			String sqlOrder = "";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					//创建实体对象
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");

					//获取参数值
					String VC_KMDM = map.get("VC_CODE");   //科目代码
					String VC_KMMC = map.get("VC_NAME");   //科目名称
					String CPDM = map.get("CPDM");   //产品代码
					String CPMC = map.get("CPMC");  //产品名称
					String CPQC = map.get("CPQC");  //产品全称
					String L_FUNDID = map.get("L_FUNDID");  //账套编号
					String L_DATE = map.get("L_DATE"); //日期
					String NCYE = StrUtil.addThousandth0ToEmpty(map.get("NCYE"), StrUtil.df1); //年初余额
					String QCYE = StrUtil.addThousandth0ToEmpty(map.get("QCYE"), StrUtil.df1); //期初余额
					String BQJFFSE = StrUtil.addThousandth0ToEmpty(map.get("BQJFFSE"), StrUtil.df1); //本期借方发生（当日）
					String BQDFFSE = StrUtil.addThousandth0ToEmpty(map.get("BQDFFSE"), StrUtil.df1); //本期贷方发生（当日）
					String LJJFFSE = StrUtil.addThousandth0ToEmpty(map.get("LJJFFSE"), StrUtil.df1); //累计借方发生
					String LJDFFSE = StrUtil.addThousandth0ToEmpty(map.get("LJDFFSE"), StrUtil.df1); //累计贷方发生
					String QMYE = StrUtil.addThousandth0ToEmpty(map.get("QMYE"), StrUtil.df1); //期末余额
					String SRCSYS = map.get("SRCSYS"); //来源系统
					String INSERTTIME = map.get("INSERTTIME"); //写入时间

					//给对象赋值
					obj.setString("VC_KMDM", VC_KMDM);
					obj.setString("VC_KMMC", VC_KMMC);
					obj.setString("CPDM", CPDM);
					obj.setString("CPMC", CPMC);
					obj.setString("CPQC", CPQC);
					obj.setString("L_FUNDID", L_FUNDID);
					obj.setString("L_DATE", L_DATE);
					obj.setString("NCYE", NCYE);
					obj.setString("QCYE", QCYE);
					obj.setString("BQJFFSE", BQJFFSE);
					obj.setString("BQDFFSE",BQDFFSE);
					obj.setString("LJJFFSE",LJJFFSE);
					obj.setString("LJDFFSE",LJDFFSE);
					obj.setString("QMYE",QMYE);
					obj.setString("SRCSYS",SRCSYS);
					obj.setString("INSERTTIME",INSERTTIME);
					result.add(obj);
					obj = null;
				}
			}
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
	 * 综合信息查询-产品交易流水-交易所查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static List<DataObject> queryCPJYS(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_CPJYS)){
				SQL_CPJYS = getFileSql("zhxxcx_cpjys.sql");
			}
			if(StringUtils.isEmpty(SQL_CPJYS_HIS)){//查询历史数据
				SQL_CPJYS_HIS = getFileSql("zhxxcx_cpjyshis.sql");
			}
			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String lDateBegin = DateUtil.format(paramObject.getDate("lDateBegin"), DateUtil.YMD_NUMBER);//起始日期
			String lDateEnd = DateUtil.format(paramObject.getDate("lDateEnd"), DateUtil.YMD_NUMBER);//截止日期
			String vcFundCode = paramObject.getString("vcFundCode");//基金名称（查询条件传入）
			String vcReportCode = paramObject.getString("vcReportCode");//证券代码
			String vcStockName = paramObject.getString("vcStockName");//证券名称
			String vcEntrustdirName = paramObject.getString("vcEntrustdirName");//委托方向
			String cBusinClassName = paramObject.getString("cBusinClassName");//业务类型名称
//			String nowDate = DateUtil.format(DateUtil.currentDate(), DateUtil.YMD_NUMBER);//获取系统当前时间
			String nowDate = getNextTradeDate();
			if(!StringUtils.isNotBlank(lDateBegin)){
				lDateBegin = "20130101";
			}
			if(StringUtils.isNotBlank(lDateBegin) && StringUtils.isNotBlank(lDateEnd)){
				if(nowDate.equals(lDateBegin) && nowDate.equals(lDateEnd)){
					sb.append(SQL_CPJYS.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_TODAY, nowDate));
					//若查询当天交易所的成交回报，则获取O32系统的数据库连接
					conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getProdO32CacheDataSourceName());
				}else{
					sb.append(SQL_CPJYS_HIS);
					//若查询历史交易所的成交回报，则获取数据中心的数据库连接
					conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_SJZX);
				}
			}else{
				return result;
			}
			//拼接SQL语句
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and ttt.vc_fund_code in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vcFundCode)){
				sb.append("   and ttt.vc_fund_code in (").append(JDBCUtil.changeInStr(vcFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(vcReportCode)){
				sb.append("   and ttt.vc_report_code like '%" + vcReportCode + "%' ");
			}
			if(StringUtils.isNotBlank(vcStockName)){
				sb.append("   and ttt.vc_stock_name like '%" + vcStockName + "%' ");
			}
			if(StringUtils.isNotBlank(vcEntrustdirName)){
				String[] vcEntrustdirNames = vcEntrustdirName.split(",");
				String vcEntrustdirNameStr = "";
				for(String str:vcEntrustdirNames){
					vcEntrustdirNameStr = vcEntrustdirNameStr + "'" + str + "',";
				}
				vcEntrustdirNameStr = vcEntrustdirNameStr.substring(0, vcEntrustdirNameStr.length()-1);
				sb.append("   and ttt.vc_entrustdir_name in (" + vcEntrustdirNameStr + ") ");
			}
			if(StringUtils.isNotBlank(cBusinClassName)){
				String[] vcBusinClassNames = cBusinClassName.split(",");
				String vcBusinClassNameStr = "";
				for(String str:vcBusinClassNames){
					vcBusinClassNameStr = vcBusinClassNameStr + "'" + str + "',";
				}
				vcBusinClassNameStr = vcBusinClassNameStr.substring(0, vcBusinClassNameStr.length()-1);
				sb.append("   and ttt.c_busin_class_name in (" + vcBusinClassNameStr + ") ");
			}
			if(StringUtils.isNotBlank(lDateBegin)){
				sb.append("   and ttt.l_date >= '" + lDateBegin + "'");
			}
			if(StringUtils.isNotBlank(lDateEnd)){
				sb.append("   and ttt.l_date <= '" + lDateEnd + "'");
			}

			//排序SQL语句
			String sqlOrder = " order by ttt.l_date desc, ttt.vc_fund_code asc, ttt.vc_report_code asc";


			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_DATE = map.get("L_DATE");//业务日期
					String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					String VC_REPORT_CODE = map.get("VC_REPORT_CODE");//证券代码
					String VC_STOCK_NAME = map.get("VC_STOCK_NAME");//证券名称
					String VC_ENTRUSTDIR_NAME = map.get("VC_ENTRUSTDIR_NAME");//委托方向
					String EN_AVG_PRICE = StrUtil.addThousandth(map.get("EN_AVG_PRICE"), StrUtil.df4);//市场成交均价
					String L_DEAL_AMOUNT = StrUtil.addThousandth(map.get("L_DEAL_AMOUNT"), StrUtil.df2);//成交数量
					String EN_DEAL_BALANCE = StrUtil.addThousandth(map.get("EN_DEAL_BALANCE"), StrUtil.df1);//成交金额
					String EN_AVG_DEALPRICE = StrUtil.addThousandth(map.get("EN_AVG_DEALPRICE"), StrUtil.df4);//成交均价
					String EN_AVG_DEALPRICE_FULL = StrUtil.addThousandth(map.get("EN_AVG_DEALPRICE_FULL"), StrUtil.df4);// 成交均价(全价)
					String VC_MARKET_NAME = map.get("VC_MARKET_NAME");//交易市场
					String C_BUSIN_CLASS = map.get("C_BUSIN_CLASS");//业务类型代码
					String C_BUSIN_CLASS_NAME = map.get("C_BUSIN_CLASS_NAME");//业务类型名称

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("L_DATE", L_DATE);//发生日期
					obj.setString("VC_FUND_CODE", VC_FUND_CODE);//基金代码
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);//基金名称
					obj.setString("VC_REPORT_CODE", VC_REPORT_CODE);//证券代码
					obj.setString("VC_STOCK_NAME", VC_STOCK_NAME);//证券名称
					obj.setString("VC_ENTRUSTDIR_NAME", VC_ENTRUSTDIR_NAME);//委托方向
					obj.setString("EN_AVG_PRICE", EN_AVG_PRICE);//市场成交均价
					obj.setString("L_DEAL_AMOUNT", L_DEAL_AMOUNT);//成交数量
					obj.setString("EN_DEAL_BALANCE", EN_DEAL_BALANCE);//成交金额
					obj.setString("EN_AVG_DEALPRICE", EN_AVG_DEALPRICE);//成交均价
					obj.setString("EN_AVG_DEALPRICE_FULL", EN_AVG_DEALPRICE_FULL);//成交均价(全价)
					obj.setString("VC_MARKET_NAME", VC_MARKET_NAME);//交易市场
					obj.setString("C_BUSIN_CLASS", C_BUSIN_CLASS);//业务类型代码
					obj.setString("C_BUSIN_CLASS_NAME", C_BUSIN_CLASS_NAME);//业务类型名称
					result.add(obj);
					obj = null;
				}
			}

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
	 * 综合信息查询-产品交易流水-银行间查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author fengjunpei
	 */
	@Bizlet("")
	public static List<DataObject> queryCPYHJ(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			//conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_CPYHJ)){
				SQL_CPYHJ = getFileSql("zhxxcx_cpyhj.sql");
			}
			if(StringUtils.isEmpty(SQL_CPYHJ_HIS)){//查询历史数据
				SQL_CPYHJ_HIS = getFileSql("zhxxcx_cpyhjhis.sql");
			}

			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			//String lDate = DateUtil.format(paramObject.getDate("lDate"), DateUtil.YMD_NUMBER);//日期
			String vcFundCode = paramObject.getString("vcFundCode");//基金名称（查询条件传入）
			String vcReportCode = paramObject.getString("vcReportCode");//证券代码
			String vcStockName = paramObject.getString("vcStockName");//证券名称
			String vcEntrustdirName = paramObject.getString("vcEntrustdirName");//委托方向
			String lFirstSettleDateBegin = DateUtil.format(paramObject.getDate("lFirstSettleDateBegin"), DateUtil.YMD_NUMBER);//起始首次交割日
			String lFirstSettleDateEnd = DateUtil.format(paramObject.getDate("lFirstSettleDateEnd"), DateUtil.YMD_NUMBER);//截至首次交割日
			String lSecondSettleDateBegin = DateUtil.format(paramObject.getDate("lSecondSettleDateBegin"), DateUtil.YMD_NUMBER);//起始到期交割日
			String lSecondSettleDateEnd = DateUtil.format(paramObject.getDate("lSecondSettleDateEnd"), DateUtil.YMD_NUMBER);//截至到期交割日
			String lDateBegin = DateUtil.format(paramObject.getDate("lDateBegin"), DateUtil.YMD_NUMBER);//起始日期
			String lDateEnd = DateUtil.format(paramObject.getDate("lDateEnd"), DateUtil.YMD_NUMBER);//截止日期
			String tradeDate = getNextTradeDate();//获取当前日期，若不是交易日则获取下一交易日
			if(!StringUtils.isNotBlank(lDateBegin)){
				lDateBegin = "20130101";
			}
			if(StringUtils.isNotBlank(lDateBegin) && StringUtils.isNotBlank(lDateEnd)){
				if(tradeDate.equals(lDateBegin) && tradeDate.equals(lDateEnd)){
					sb.append(SQL_CPYHJ.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_BEGIN, tradeDate).replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_END, tradeDate));
					//获取O32系统的数据库连接
					conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
				}else{
					sb.append(SQL_CPYHJ_HIS.replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_BEGIN, lDateBegin).replaceAll(ZhxxcxUtil.PARAM_BUSI_DATE_END, lDateEnd));
					//获取O32系统的数据库连接
					conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_SJZX);
				}
			}else{
				return result;
			}

			//拼接SQL语句
			//sb.append(SQL_CPYHJ);
			//新增查询条件
//			if(StringUtils.isNotBlank(lDate)){
//				sb.append(" and t.l_date = '" + lDate + "'");
//			}
			if(StringUtils.isNotBlank(lDateBegin)){
				sb.append("   and t.l_date >= '" + lDateBegin + "'");
			}
			if(StringUtils.isNotBlank(lDateEnd)){
				sb.append("   and t.l_date <= '" + lDateEnd + "'");
			}
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append(" and t.vc_fund_code in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vcFundCode)){
				sb.append(" and t.vc_fund_code in (").append(JDBCUtil.changeInStr(vcFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(vcReportCode)){
				sb.append(" and t.vc_report_code like '%" + vcReportCode + "%' ");
			}
			if(StringUtils.isNotBlank(vcStockName)){
				sb.append(" and t.vc_stock_name like '%" + vcStockName + "%' ");
			}
			if(StringUtils.isNotBlank(vcEntrustdirName)){
				String[] vcEntrustdirNames = vcEntrustdirName.split(",");
				String vcEntrustdirNameStr = "";
				for(String str:vcEntrustdirNames){
					vcEntrustdirNameStr = vcEntrustdirNameStr + "'" + str + "',";
				}
				vcEntrustdirNameStr = vcEntrustdirNameStr.substring(0, vcEntrustdirNameStr.length()-1);
				sb.append(" and t.vc_entrustdir_name in (" + vcEntrustdirNameStr + ") ");
			}
			if(StringUtils.isNotBlank(lFirstSettleDateBegin)){
				sb.append("  and t.l_first_settle_date >= '" + lFirstSettleDateBegin + "' ");
			}
			if(StringUtils.isNotBlank(lFirstSettleDateEnd)){
				sb.append("  and t.l_first_settle_date <= '" + lFirstSettleDateEnd + "' ");
			}
			if(StringUtils.isNotBlank(lSecondSettleDateBegin)){
				sb.append("  and t.l_second_settle_date >= '" + lSecondSettleDateBegin + "' ");
			}
			if(StringUtils.isNotBlank(lSecondSettleDateEnd)){
				sb.append("  and t.l_second_settle_date <= '" + lSecondSettleDateEnd + "' ");
			}
			//排序SQL语句
			String sqlOrder = " order by t.L_DATE desc, t.VC_FUND_CODE asc, t.VC_DEAL_NO asc";


			//查询结果集
			//System.out.println(sb);
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_DATE = map.get("L_DATE");//日期
					String VC_DEAL_NO = map.get("VC_DEAL_NO");//成交编号
					String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					String VC_REPORT_CODE = map.get("VC_REPORT_CODE");//证券代码
					String VC_STOCK_NAME = map.get("VC_STOCK_NAME");//证券名称
					String VC_ENTRUSTDIR_NAME = map.get("VC_ENTRUSTDIR_NAME");//委托方向
					String EN_RATE = StrUtil.addThousandth(map.get("EN_RATE"), StrUtil.df4);//回购利率(%)
					String L_DEAL_AMOUNT = StrUtil.addThousandth(map.get("L_DEAL_AMOUNT"), StrUtil.df2);//成交数量
					String EN_FIRST_CLEAR_BALANCE = StrUtil.addThousandth(map.get("EN_FIRST_CLEAR_BALANCE"), StrUtil.df1);//成交金额
					String EN_SECOND_CLEAR_BALANCE = StrUtil.addThousandth(map.get("EN_SECOND_CLEAR_BALANCE"), StrUtil.df1);//到期清算金额
					String L_HG_DAYS = map.get("L_HG_DAYS");//  回购天数
					String L_USE_DAYS = map.get("L_USE_DAYS");//实际占款天数
					String L_SETTLE_SPEED = map.get("L_SETTLE_SPEED");//清算速度
					String L_FIRST_SETTLE_DATE = map.get("L_FIRST_SETTLE_DATE");//首次交割日
					String L_SECOND_SETTLE_DATE = map.get("L_SECOND_SETTLE_DATE");//到期交割日
					String L_TRADE_RIVAL_NO = map.get("L_TRADE_RIVAL_NAME");//交易对手
					String EN_FIRST_NET_PRICE = StrUtil.addThousandth(map.get("EN_FIRST_NET_PRICE"), StrUtil.df4);//净价价格
					String EN_FIRST_FULL_PRICE = StrUtil.addThousandth(map.get("EN_FIRST_FULL_PRICE"), StrUtil.df4);//全价价格
					String EN_SECOND_MATURE_YIELD = StrUtil.addThousandth(map.get("EN_SECOND_MATURE_YIELD"), StrUtil.df4);//到期收益率(%)
					String C_TRUSTEE = map.get("C_TRUSTEENAME");//托管机构
					String L_TIME = map.get("L_TIME");//成交时间


					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("L_DATE", L_DATE);//日期
					obj.setString("VC_DEAL_NO", VC_DEAL_NO);//成交编号
					obj.setString("VC_FUND_CODE", VC_FUND_CODE);//基金代码
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);//基金名称
					obj.setString("VC_REPORT_CODE", VC_REPORT_CODE);//证券代码
					obj.setString("VC_STOCK_NAME", VC_STOCK_NAME);//证券名称
					obj.setString("VC_ENTRUSTDIR_NAME", VC_ENTRUSTDIR_NAME);//委托方向
					obj.setString("EN_RATE", EN_RATE);//回购利率(%)
					obj.setString("L_DEAL_AMOUNT", L_DEAL_AMOUNT);//成交数量
					obj.setString("EN_FIRST_CLEAR_BALANCE", EN_FIRST_CLEAR_BALANCE);//成交金额
					obj.setString("EN_SECOND_CLEAR_BALANCE", EN_SECOND_CLEAR_BALANCE);//到期清算金额
					obj.setString("L_HG_DAYS", L_HG_DAYS);//回购天数
					obj.setString("L_USE_DAYS", L_USE_DAYS);//实际占款天数
					obj.setString("L_SETTLE_SPEED", "T+" + L_SETTLE_SPEED);//清算速度
					obj.setString("L_FIRST_SETTLE_DATE", L_FIRST_SETTLE_DATE);//首次交割日
					obj.setString("L_SECOND_SETTLE_DATE", L_SECOND_SETTLE_DATE);//到期交割日
					obj.setString("L_TRADE_RIVAL_NO", L_TRADE_RIVAL_NO);//交易对手
					obj.setString("EN_FIRST_NET_PRICE", EN_FIRST_NET_PRICE);//净价价格
					obj.setString("EN_FIRST_FULL_PRICE", EN_FIRST_FULL_PRICE);//全价价格
					obj.setString("EN_SECOND_MATURE_YIELD", EN_SECOND_MATURE_YIELD);//到期收益率(%)
					obj.setString("C_TRUSTEE", C_TRUSTEE);//托管机构
					obj.setString("L_TIME", L_TIME);//成交时间
					result.add(obj);
					obj = null;
				}
			}

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
	 * 综合信息查询-产品净值查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author fengjunpei
	 */
	@Bizlet("")
	public static List<DataObject> queryCPJZ(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(JDBCUtil.DATA_SOURCE_SJZX);
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_CPJZ)){
				SQL_CPJZ = getFileSql("zhxxcx_cpjz.sql");
			}

			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vcFundCode = paramObject.getString("vcFundCode");//基金名称（查询条件传入）
			String lDateBegin = DateUtil.format(paramObject.getDate("lDateBegin"), DateUtil.YMD_NUMBER);//起始日期
			String lDateEnd = DateUtil.format(paramObject.getDate("lDateEnd"), DateUtil.YMD_NUMBER);//截至日期

			//拼接SQL语句
			sb.append(SQL_CPJZ);
			//新增查询条件
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append(" and t.vc_fund_code in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vcFundCode)){
				sb.append(" and t.vc_fund_code in (").append(JDBCUtil.changeInStr(vcFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(lDateBegin)){
				sb.append("  and t.l_date >= '" + lDateBegin + "' ");
			}
			if(StringUtils.isNotBlank(lDateEnd)){
				sb.append("  and t.l_date <= '" + lDateEnd + "' ");
			}
			sb.append("  group by t.l_date, t.vc_fund_code, t.vc_fund_name");
			//排序SQL语句
			String sqlOrder = "  order by t.vc_fund_code asc, t.l_date desc ";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_DATE = map.get("L_DATE");//统计日期
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					String EN_FUND_VALUE = StrUtil.addThousandth(map.get("EN_FUND_VALUE"), StrUtil.df1);//净值
					String EN_NAV = StrUtil.addThousandth(map.get("EN_NAV"), StrUtil.df4);// 单位净值
					String EN_TOTAL_NAV = StrUtil.addThousandth(map.get("EN_TOTAL_NAV"), StrUtil.df4);//累计单位净值
					/*20180417:获取总资产*/
					String EN_TOTAL_ZC = StrUtil.addThousandth(map.get("EN_TOTAL_ZC"), StrUtil.df1);//总资产

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("L_DATE", L_DATE);//日期
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);//基金名称
					obj.setString("EN_FUND_VALUE", EN_FUND_VALUE);//净值
					obj.setString("EN_NAV", EN_NAV);//单位净值
					obj.setString("EN_TOTAL_NAV", EN_TOTAL_NAV);//累计单位净值
					/*20180417:组装总资产*/
					obj.setString("EN_TOTAL_ZC", EN_TOTAL_ZC);//总资产
					result.add(obj);
					obj = null;
				}
			}

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
	 * 备付金保证金预估查询-备付金查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author heyi
	 */
	@Bizlet("")
	public static List<DataObject> queryBFJ(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getBakO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_BFJ)){
				SQL_BFJ = getFileSql("zhxxcx_bfj.sql");
			}

			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vcFundCode = paramObject.getString("vcFundCode");//基金名称（查询条件传入）
			String lDateBegin = DateUtil.format(paramObject.getDate("lDateBegin"), DateUtil.YMD_NUMBER);//起始日期
			String lDateEnd = DateUtil.format(paramObject.getDate("lDateEnd"), DateUtil.YMD_NUMBER);//截至日期
			String vcBusinFlag = paramObject.getString("vcBusinFlag");//业务类型名称

			//拼接SQL语句
			sb.append(SQL_BFJ);
			//新增查询条件
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and a.vc_fund_code in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vcFundCode)){
				sb.append("   and a.vc_fund_code in (").append(JDBCUtil.changeInStr(vcFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(vcBusinFlag)){
				sb.append("   and a.vc_busin_flag like '%").append(vcBusinFlag).append("%'");
			}
			if(StringUtils.isNotBlank(lDateBegin)){
				sb.append("   and a.l_date >= '" + lDateBegin + "' ");
			}
			if(StringUtils.isNotBlank(lDateEnd)){
				sb.append("   and a.l_date <= '" + lDateEnd + "' ");
			}
			//排序SQL语句
			String sqlOrder = " order by a.l_date desc, a.vc_fund_code asc";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_DATE = map.get("L_DATE");//统计日期
					String L_FUND_ID = map.get("L_FUND_ID");//基金序号
					String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					String L_ASSET_ID = map.get("L_ASSET_ID");//资产单元序号
					String VC_ASSET_NAME = map.get("VC_ASSET_NAME");//资产单元名称
					String VC_BUSIN_FLAG = map.get("VC_BUSIN_FLAG");//业务类型名称
					String EN_DEAL_BALANCE = StrUtil.addThousandth(map.get("EN_DEAL_BALANCE"), StrUtil.df1);//成交金额
					String EN_BFJ_LASTDAY = StrUtil.addThousandth(map.get("EN_BFJ_LASTDAY"), StrUtil.df1);//预测备付金
					String EN_BFJ_LASTMON = StrUtil.addThousandth(map.get("EN_BFJ_LASTMON"), StrUtil.df1);//月初存出备付金
					String EN_BFJ_GAP = StrUtil.addThousandth(map.get("EN_BFJ_GAP"), StrUtil.df1);//预测调整金额
					String EN_BFJ_PREDICT = StrUtil.addThousandth(map.get("EN_BFJ_PREDICT"), StrUtil.df1);//月初需冻结金额
					String C_GROUP_FLAG = map.get("L_DC_GROUP_FLAGATE");//是否分组估值
					String ASSET_FLAG = map.get("ASSET_FLAG");//是否分资产单元

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("L_DATE", L_DATE);
					obj.setString("L_FUND_ID", L_FUND_ID);
					obj.setString("VC_FUND_CODE", VC_FUND_CODE);
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);
					obj.setString("L_ASSET_ID", L_ASSET_ID);
					obj.setString("VC_ASSET_NAME", VC_ASSET_NAME);
					obj.setString("VC_BUSIN_FLAG", VC_BUSIN_FLAG);
					obj.setString("EN_DEAL_BALANCE", EN_DEAL_BALANCE);
					obj.setString("EN_BFJ_LASTDAY",EN_BFJ_LASTDAY );
					obj.setString("EN_BFJ_LASTMON", EN_BFJ_LASTMON);
					obj.setString("EN_BFJ_GAP", EN_BFJ_GAP);
					obj.setString("EN_BFJ_PREDICT", EN_BFJ_PREDICT);
					obj.setString("C_GROUP_FLAG", C_GROUP_FLAG);
					obj.setString("ASSET_FLAG", ASSET_FLAG);
					result.add(obj);
					obj = null;
				}
			}
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
	 * 备付金保证金预估查询-保证金查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author heyi
	 */
	@Bizlet("")
	public static List<DataObject> queryBZJ(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getBakO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_BZJ)){
				SQL_BZJ = getFileSql("zhxxcx_bzj.sql");
			}

			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vcFundCode = paramObject.getString("vcFundCode");//基金名称（查询条件传入）
			String lDateBegin = DateUtil.format(paramObject.getDate("lDateBegin"), DateUtil.YMD_NUMBER);//起始日期
			String lDateEnd = DateUtil.format(paramObject.getDate("lDateEnd"), DateUtil.YMD_NUMBER);//截至日期

			//拼接SQL语句
			sb.append(SQL_BZJ);
			//新增查询条件
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and a.vc_fund_code in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vcFundCode)){
				sb.append("   and a.vc_fund_code in (").append(JDBCUtil.changeInStr(vcFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(lDateBegin)){
				sb.append("   and a.l_date >= '" + lDateBegin + "' ");
			}
			if(StringUtils.isNotBlank(lDateEnd)){
				sb.append("   and a.l_date <= '" + lDateEnd + "' ");
			}
			//排序SQL语句
			String sqlOrder = " order by a.l_date desc, a.vc_fund_code asc";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_DATE = map.get("L_DATE");//统计日期
					String L_FUND_ID = map.get("L_FUND_ID");//基金序号
					String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					String L_DEFAULT_ASSET = map.get("L_DEFAULT_ASSET");//资产单元序号
					String VC_ASSET_NAME = map.get("VC_ASSET_NAME");//资产单元名称
					String VC_SEQUARE_CODE = map.get("VC_SEQUARE_CODE");//结算参与人代码
					String CURRENT_BZJ = StrUtil.addThousandth(map.get("CURRENT_BZJ"), StrUtil.df1);//预测保证金
					String MONTH_BEGIN_BZJ = StrUtil.addThousandth(map.get("MONTH_BEGIN_BZJ"), StrUtil.df1);//月初存出保证金
					String MARGIN_BZJ = StrUtil.addThousandth(map.get("MARGIN_BZJ"), StrUtil.df1);//预测需调整金额
					String PREDICT_BZJ = StrUtil.addThousandth(map.get("PREDICT_BZJ"), StrUtil.df1);//下月需冻结保证金

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("L_DATE", L_DATE);
					obj.setString("L_FUND_ID", L_FUND_ID);
					obj.setString("VC_FUND_CODE", VC_FUND_CODE);
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);
					obj.setString("L_DEFAULT_ASSET", L_DEFAULT_ASSET);
					obj.setString("VC_ASSET_NAME", VC_ASSET_NAME);
					obj.setString("VC_SEQUARE_CODE", VC_SEQUARE_CODE);
					obj.setString("CURRENT_BZJ",CURRENT_BZJ );
					obj.setString("MONTH_BEGIN_BZJ", MONTH_BEGIN_BZJ);
					obj.setString("MARGIN_BZJ", MARGIN_BZJ);
					obj.setString("PREDICT_BZJ", PREDICT_BZJ);
					result.add(obj);
					obj = null;
				}
			}

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
	 * 备付金保证金预估查询-保证金-保证金明细查询
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author heyi
	 */
	@Bizlet("")
	public static List<DataObject> queryBZJDetail(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getBakO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_BZJ_DETAIL)){
				SQL_BZJ_DETAIL = getFileSql("zhxxcx_bzj_detail.sql");
			}

			//获取页面传进来的查询条件值
			String L_DATE = paramObject.getString("L_DATE");//日期
			String L_FUND_ID = paramObject.getString("L_FUND_ID");//基金代码
			String VC_FUND_CODE = paramObject.getString("VC_FUND_CODE");//基金代码

			//拼接SQL语句
			sb.append(SQL_BZJ_DETAIL);
			sb.append("   and a.l_date = '" + L_DATE + "'");
			sb.append("   and a.l_fund_id = '" + L_FUND_ID + "'");
			sb.append("   and a.vc_fund_code = '" + VC_FUND_CODE + "'");
			//排序SQL语句
			String sqlOrder = " order by a.vc_report_code asc";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String VC_BUSIN_CAPTION = map.get("VC_BUSIN_CAPTION");//业务类型
					String VC_REPORT_CODE = map.get("VC_REPORT_CODE");//证券代码
					String VC_STOCK_NAME = map.get("VC_STOCK_NAME");//证券名称
					String EN_DEAL_BALANCE = StrUtil.addThousandth(map.get("EN_DEAL_BALANCE"), StrUtil.df1);//成交金额
					String L_CAL_RATIO = StrUtil.addThousandth(map.get("L_CAL_RATIO"), StrUtil.df4);//保证金比例

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("VC_BUSIN_CAPTION", VC_BUSIN_CAPTION);
					obj.setString("VC_REPORT_CODE", VC_REPORT_CODE);
					obj.setString("VC_STOCK_NAME", VC_STOCK_NAME);
					obj.setString("EN_DEAL_BALANCE", EN_DEAL_BALANCE);
					obj.setString("L_CAL_RATIO", L_CAL_RATIO);
					result.add(obj);
					obj = null;
				}
			}
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
	 * 综合报表->O32定期存款到期浏览表
	 * @param paramObject
	 * @param page
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("定期存款到期游览表查询")
	public static List<DataObject> queryDQCKDQYLB(DataObject paramObject, DataObject page){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_TIME_DEPOSITS)){
				SQL_TIME_DEPOSITS = getFileSql("zhxxcx_dqckdqylb.sql");
			}

			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码
			String LBeginDateStart = DateUtil.format(paramObject.getDate("LBeginDateStart"), DateUtil.YMD_NUMBER);//起息日开始时间
			String LBeginDateEnd = DateUtil.format(paramObject.getDate("LBeginDateEnd"), DateUtil.YMD_NUMBER);//起息日结束时间
			String LEndDateStart = DateUtil.format(paramObject.getDate("LEndDateStart"), DateUtil.YMD_NUMBER); //到期日开始时间
			String LEndDateEnd = DateUtil.format(paramObject.getDate("LEndDateEnd"), DateUtil.YMD_NUMBER); //到期日结束时间
			String vCBankName = paramObject.getString("vCBankName"); //对手方
			String vcDepositreceiptStatus = paramObject.getString("vcDepositreceiptStatus"); //协议存款/存单状态

			//拼接SQL语句
			sb.append(SQL_TIME_DEPOSITS);
			if(StringUtils.isNotBlank(combProductCodes)){
				sb.append("   and b.vc_fund_code in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
			}
			if(StringUtils.isNotBlank(vCFundCode)){
				sb.append("   and b.vc_fund_code in (").append(JDBCUtil.changeInStr(vCFundCode)).append(")");
			}
			if(StringUtils.isNotBlank(LBeginDateStart)){
				sb.append("   and a.l_begin_date >= '" + LBeginDateStart + "'");
			}
			if(StringUtils.isNotBlank(LBeginDateEnd)){
				sb.append("   and a.l_begin_date <= '" + LBeginDateEnd + "'");
			}
			if(StringUtils.isNotBlank(LEndDateStart)){
				sb.append("   and a.l_end_date >= '" + LEndDateStart + "'");
			}
			if(StringUtils.isNotBlank(LEndDateEnd)){
				sb.append("   and a.l_end_date <= '" + LEndDateEnd + "'");
			}
			if(StringUtils.isNotBlank(vCBankName)){
				sb.append("   and d.vc_bank_name like '%" + vCBankName + "%'");
			}
			if(StringUtils.isNotBlank(vcDepositreceiptStatus)){
				sb.append("   and a.c_status in (").append(JDBCUtil.changeInStr(vcDepositreceiptStatus)).append(")");
			}
			//排序SQL语句
			String sqlOrder = " order by b.vc_fund_code asc, a.l_end_date desc";

			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_FUND_ID = map.get("L_FUND_ID");//基金序号
					String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					String C_ASSET_CLASS = map.get("C_ASSET_CLASS");//资产类别
					String VC_BANK_NAME = map.get("VC_BANK_NAME");//对手方
					String VC_REPORT_CODE = map.get("VC_REPORT_CODE");//证券代码
					String VC_STOCK_NAME = map.get("VC_STOCK_NAME");//证券名称
					String EN_BALANCE = StrUtil.addThousandth(map.get("EN_BALANCE"), StrUtil.df1);;//存单金额
					String L_LIMIT_TIME = StrUtil.addThousandth(map.get("L_LIMIT_TIME"), StrUtil.df2);//存款期限(天)
					String L_BEGIN_DATE = map.get("L_BEGIN_DATE");//起息日
					String L_END_DATE = map.get("L_END_DATE");//到期日
					String L_PAYMENT_DATE = map.get("L_PAYMENT_DATE");//到期本息兑付日
					String EN_RATE = StrUtil.addThousandth(map.get("EN_RATE"),StrUtil.df1);//存款利率
					String C_ADVANCE_LIMIT_FLAG = map.get("C_ADVANCE_LIMIT_FLAG");//提前支取限制
					String C_STATUS = map.get("C_STATUS");//协议存款/存单状态
					String DEPOSITRECEIPT_STATUS = map.get("DEPOSITRECEIPT_STATUS");//协议存款/存单状态

					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					obj.setString("L_FUND_ID", L_FUND_ID);
					obj.setString("VC_FUND_CODE", VC_FUND_CODE);
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);
					obj.setString("C_ASSET_CLASS", C_ASSET_CLASS);
					obj.setString("VC_BANK_NAME", VC_BANK_NAME);
					obj.setString("VC_REPORT_CODE", VC_REPORT_CODE);
					obj.setString("VC_STOCK_NAME", VC_STOCK_NAME);
					obj.setString("EN_BALANCE", EN_BALANCE);
					obj.setString("L_LIMIT_TIME", L_LIMIT_TIME);
					obj.setString("L_BEGIN_DATE", L_BEGIN_DATE);
					obj.setString("L_END_DATE", L_END_DATE);
					obj.setString("L_PAYMENT_DATE", L_PAYMENT_DATE);
					obj.setString("EN_RATE", EN_RATE);
					obj.setString("C_ADVANCE_LIMIT_FLAG", C_ADVANCE_LIMIT_FLAG);
					obj.setString("C_STATUS", C_STATUS);
					obj.setString("DEPOSITRECEIPT_STATUS", DEPOSITRECEIPT_STATUS);

					result.add(obj);
					obj = null;
				}
			}
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
	 * 组装实体的主键
	 * @param objs
	 * @return
	 */
	@Bizlet("组装实体的主键")
	public DataObject[] setUserColSetTobKey(DataObject[] objs){

		for (int i = 0; i < objs.length; i++) {
			com.eos.foundation.database.DatabaseExt.getPrimaryKey(objs[i]);
		}
		return objs;
	}


}
