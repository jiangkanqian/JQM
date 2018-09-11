package com.cjhxfund.jy.ProductProcess;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.cjhxfund.commonUtil.CacheUtil;
import com.cjhxfund.commonUtil.JDBCUtil;
import com.cjhxfund.commonUtil.StrUtil;
import com.cjhxfund.commonUtil.externalService.HttpClientService;
import com.eos.foundation.data.DataObjectUtil;
import com.eos.foundation.database.DatabaseExt;
import com.eos.system.annotation.Bizlet;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import commonj.sdo.DataObject;

/**
 * 综合产品头寸风险测算信息查询处理公共类
 * @author huangmizhi
 * @date 2016-03-03 09:42:20
 */
@Bizlet("")
public class TccxUtil {
	
	/**产品头寸风险预算查询sql语句**/
	public static String SQL_CPTCFXYC = "";
	/**当日T+0头寸差额-银行间可用质押券明细查询sql语句**/
	public static String SQL_T0YHJ = "";
	/**当日T+0头寸差额-交易所非担保交易债券明细查询sql语句**/
	public static String SQL_T0JYS = "";
	/**当日T+1头寸差额：交易所可用标准券数量查询sql语句**/
	public static String SQL_T1JYSKY = "";
	/**当日T+1头寸差额：交易所可提交质押债券明细查询sql语句**/
	public static String SQL_T1KTJZYQ = "";
	/**当日T+1头寸差额：交易所担保交易债券明细查询sql语句**/
	public static String SQL_T1JYSDB = "";
	/**产品头寸风险预算明细查询sql语句**/
	public static String SQL_CPTCFXYC_DETAIL = "";
	
	
	/** 当前classpath的绝对URI路径 */
	public static String CLASS_PATH = "";
	/** 综合信息查询SQL文件存放路径 */
	public static String SQL_FILE_PATH = "";
	
	/** 默认起始日期：19000101 */
	public static final String DEFAULT_DATE_BEGIN = "19000101";
	/** 默认截至日期：29991231 */
	public static final String DEFAULT_DATE_END = "29991231";
	/** 起始日期参数字符串 */
	public static final String PARAM_BUSI_DATE_BEGIN = "PARAM_BUSI_DATE_BEGIN";
	/** 截至日期参数字符串 */
	public static final String PARAM_BUSI_DATE_END = "PARAM_BUSI_DATE_END";
	/** 当天参数字符串 */
	public static final String PARAM_BUSI_DATE_TODAY = "PARAM_BUSI_DATE_TODAY";
	/** 银行间回购流水号字符串 */
	public static final String PARAM_L_SERIAL_NO = "PARAM_L_SERIAL_NO";
	
	static {
		String os = System.getProperty("os.name");
		if(StringUtils.isNotEmpty(os) && os.toLowerCase().startsWith("win")){
			CLASS_PATH = TccxUtil.class.getResource("/").getPath().substring(1);
		}else{
			CLASS_PATH = TccxUtil.class.getResource("/").getPath();
		}
		SQL_FILE_PATH = CLASS_PATH + "confFile" + File.separator + "sqlFile" + File.separator + "zhxxcx" + File.separator;
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
			if(("URL_TCFXCSB").equals(action)){
				CashflowUrl = paramValue + "/stock/RiskForecast/getBondRealizeAbility.action";
			}
		}
		return CashflowUrl;
	}
	
	/**
	 * 根据SQL文件名称获取SQL文件内容字符串
	 * @param sqlFile SQL文件名称
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static String getFileSql(String sqlFile){
		return StrUtil.findContentStr(SQL_FILE_PATH+sqlFile, null);
	}
	
	/**
	 * 头寸信息查询-产品头寸预算表
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @return
	 * @author chendi
	 */
	@Bizlet("")
	public static List<DataObject> queryCPTCFXCSB(DataObject paramObject, DataObject page, String sortField, String sortOrder){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		String sqlOrder = "";
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getBakO32CacheDataSourceName());
			//获取内存中的查询SQL语句
			if(StringUtils.isEmpty(SQL_CPTCFXYC)){
				SQL_CPTCFXYC = getFileSql("tccx_tcfxys.sql");
			}

			//获取页面传进来的查询条件值
			String combProductCodes = paramObject.getString("combProductCodes");//可查看的产品代码字符串，当有多条记录时，结果值以英文逗号分隔
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String exclusivelyShowSection = paramObject.getString("exclusivelyShowSection");//是否只显示AK余额为负数,并且是"托管户"/"上清DVP"/"中债DVP"任意一种
			//拼接SQL语句
			
			//普通查询
			if("1".equals(exclusivelyShowSection)){
				sb.append(SQL_CPTCFXYC);
				if(StringUtils.isNotBlank(combProductCodes) && (!("NoPermission").equals(combProductCodes))){
					sb.append("   and t1.vc_fund_code in (").append(JDBCUtil.changeInStr(combProductCodes)).append(") ");
				}
				if(StringUtils.isNotBlank(vCFundCode)){
					sb.append("   and t1.vc_fund_code in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
				}
				//排序SQL语句
				if(sortField != null && sortOrder != null && sortOrder != "" && sortField != ""){
					sqlOrder = " order by " + sortField +" "+ sortOrder;
				}
			}
			
			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_FUND_ID = map.get("L_FUND_ID");//基金ID
					String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
					String VC_FUND_NAME = StrUtil.changeNull(map.get("VC_FUND_NAME")).trim().replace("（", "(").replace("）", ")");//基金名称
					String AK_COL = StrUtil.addThousandth(map.get("AK_COL"), StrUtil.df1);//AK 基金净资产
					String AL_COL = StrUtil.addThousandth(map.get("AL_COL"), StrUtil.df1);//AL 基金总资产
					String D_COL = changeNullOrEmpty(map.get("D_COL"));//D 融资回购占净资产比例
					String E_COL = changeNullOrEmpty(map.get("E_COL"));//E 融资回购占净资产比例_未到期
					String F_COL = changeNullOrEmpty(map.get("F_COL"));//F 财务杠杆率
					String G_COL = changeNullOrEmpty(map.get("G_COL"));//G 交易所担保交收头寸覆盖率
					String H_COL = changeNullOrEmpty(map.get("H_COL"));//H 交易所担保交收头寸覆盖率_全部
					String I_COL = changeNullOrEmpty(map.get("I_COL"));//I 交易所非担保交收头寸覆盖率
					String J_COL = changeNullOrEmpty(map.get("J_COL"));//J 银行间头寸覆盖率
					String K_COL = changeNullOrEmpty(map.get("K_COL"));//K 银行间头寸覆盖率_质押券
					String L_COL = changeNullOrEmpty(map.get("L_COL"));//L 银行间T+0可变现覆盖率
					String TL_COL = changeNullOrEmpty(map.get("TL_COL"));//TL T+0可变现覆盖率
					String M_COL = StrUtil.addThousandth(map.get("M_COL"), StrUtil.df1);//M 交易所正回购到期余额
					String N_COL = StrUtil.addThousandth(map.get("N_COL"), StrUtil.df1);//N 交易所逆回购到期余额
					String AM_COL = StrUtil.addThousandth(map.get("AM_COL"), StrUtil.df1);//AM 交易所正回购未到期余额
					String O_COL = StrUtil.addThousandth(map.get("O_COL"), StrUtil.df1);//O 交易所协议正回购到期余额
					String P_COL = StrUtil.addThousandth(map.get("P_COL"), StrUtil.df1);//P 交易所协议逆回购到期余额
					String AN_COL = StrUtil.addThousandth(map.get("AN_COL"), StrUtil.df1);//AN 交易所协议正回购未到期余额
					String Q_COL = StrUtil.addThousandth(map.get("Q_COL"), StrUtil.df1);//Q 银行间正回购到期余额
					String R_COL = StrUtil.addThousandth(map.get("R_COL"), StrUtil.df1);//R 银行间逆回购到期余额
					String AO_COL = StrUtil.addThousandth(map.get("AO_COL"), StrUtil.df1);//AO 银行间正回购未到期余额
					String S_COL = StrUtil.addThousandth(map.get("S_COL"), StrUtil.df1);//S 存款到期兑付金额
					String T_COL = StrUtil.addThousandth(map.get("T_COL"), StrUtil.df1);//T 基金赎回款
					String U_COL = StrUtil.addThousandth(map.get("U_COL"), StrUtil.df1);//U 昨日T+1银行间卖券金额
					String V_COL = StrUtil.addThousandth(map.get("V_COL"), StrUtil.df1);//V T+0可变现金额
					String W_COL = StrUtil.addThousandth(map.get("W_COL"), StrUtil.df1);//W T+0可变现金额_上海固收平台
					String X_COL = StrUtil.addThousandth(map.get("X_COL"), StrUtil.df1);//X T+0可变现金额_深圳协议平台
					String Y_COL = StrUtil.addThousandth(map.get("Y_COL"), StrUtil.df1);//Y T+0可变现金额_银行间市场
					String Z_COL = StrUtil.addThousandth(map.get("Z_COL"), StrUtil.df1);//Z T+0可变现金额_银行间市场_中债
					String AA_COL = StrUtil.addThousandth(map.get("AA_COL"), StrUtil.df1);//AA T+0可变现金额_银行间市场_上清
					String AB_COL = StrUtil.addThousandth(map.get("AB_COL"), StrUtil.df1);//AB T+1可变现金额
					String AC_COL = StrUtil.addThousandth(map.get("AC_COL"), StrUtil.df1);//AC T+1可变现金额_标准券可用金额
					String AD_COL = StrUtil.addThousandth(map.get("AD_COL"), StrUtil.df1);//AD T+1可变现金额_可质押入库数量
					String AE_COL = StrUtil.addThousandth(map.get("AE_COL"), StrUtil.df1);//AE T+1可变现金额_可质押入库金额
					String AF_COL = map.get("AF_COL");//AF 委托人
					String AG_COL = map.get("AG_COL");//AG 上层资金来源
					String AH_COL = StrUtil.addThousandth(map.get("AH_COL"), StrUtil.df1);//AB 上层资金概率
					String AI_COL = StrUtil.addThousandth(map.get("AI_COL"), StrUtil.df1);//AC 上层资金额度
					String AJ_COL = map.get("AJ_COL");//AJ 手工调整备注
					
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					
					//给对象赋值
					obj.setString("L_FUND_ID", L_FUND_ID);
					obj.setString("VC_FUND_CODE", VC_FUND_CODE);
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);
					obj.setString("D_COL", ("0.00").equals(D_COL)?"":D_COL);
					obj.setString("E_COL", ("0.00").equals(E_COL)?"":E_COL);
					obj.setString("F_COL", ("0.00").equals(F_COL)?"":F_COL);
					obj.setString("G_COL", ("0.00").equals(G_COL)?"":G_COL);
					obj.setString("H_COL", ("0.00").equals(H_COL)?"":H_COL);
					obj.setString("I_COL", ("0.00").equals(I_COL)?"":I_COL);
					obj.setString("J_COL", ("0.00").equals(J_COL)?"":J_COL);
					obj.setString("K_COL", ("0.00").equals(K_COL)?"":K_COL);
					obj.setString("L_COL", ("0.00").equals(L_COL)?"":L_COL);
					obj.setString("TL_COL", ("0.00").equals(TL_COL)?"":TL_COL);
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
					obj.setString("AE_COL", AE_COL);
					obj.setString("AF_COL", AF_COL);
					obj.setString("AG_COL", AG_COL);
					obj.setString("AH_COL", AH_COL);
					obj.setString("AI_COL", AI_COL);
					obj.setString("AJ_COL", AJ_COL);
					obj.setString("AK_COL", AK_COL);
					obj.setString("AL_COL", AL_COL);
					obj.setString("AM_COL", AM_COL);
					obj.setString("AN_COL", AN_COL);
					obj.setString("AO_COL", AO_COL);
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
	 * 报表类数据显示处理0的显示为空，空的显示为-
	 * @param val
	 * @return 
	 */
	public static String changeNullOrEmpty(String val){
		if(val == null || ("").equals(val)){
			return "-";
		}else{
			return StrUtil.addThousandth(String.valueOf(Float.parseFloat((val).toString())*100), StrUtil.df1);
		}
	}
	
	/**
	 * 产品头寸预算手工录入数据更新
	 * @param paramObject 参数条件对象
	 * @author chendi
	 */
	@Bizlet("产品头寸预算手工录入数据更新")
	public static void updateCPTCFXCSB(DataObject paramObject){
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		List<String> sqls = new ArrayList<String>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getBakO32CacheDataSourceName());
			
			//获取页面传进来的参数条件值
			String lFundIds = paramObject.getString("lFundIds");//基金序号
			String WTRs = paramObject.getString("WTRs");//委托人
			String SCZJLYs = StrUtil.changeNull(paramObject.getString("SCZJLYs"));//上层资金来源
			String SCZJZJGLs = StrUtil.changeNull(paramObject.getString("SCZJZJGLs"));//上层追加资金概率
			String SCZJZJEDs = StrUtil.changeNull(paramObject.getString("SCZJZJEDs"));//上层追加资金额度
			String BZs = StrUtil.changeNull(paramObject.getString("BZs"));//备注
			
			if(StringUtils.isNotBlank(lFundIds)){
				String[] lFundIdArr = lFundIds.split("@");
				String[] WTRArr = WTRs.split("@");
				String[] SCZJLYArr = SCZJLYs.split("@");
				String[] SCZJZJGLArr = SCZJZJGLs.split("@");
				String[] SCZJZJEDArr = SCZJZJEDs.split("@");
				String[] BZArr = BZs.split("@");
				
				for(int i=0; i<lFundIdArr.length; i++){
					String lFundId = lFundIdArr[i];
					String WTR = StrUtil.changeNull(WTRArr[i]).replaceAll(",", "");
					String SCZJLY = StrUtil.changeNull(SCZJLYArr[i]).replaceAll(",", "");
					String SCZJZJGL = StrUtil.changeNull(SCZJZJGLArr[i]).replaceAll(",", "");
					String SCZJZJED = StrUtil.changeNull(SCZJZJEDArr[i]).replaceAll(",", "");
					String BZ = StrUtil.changeNull(BZArr[i]).replaceAll(ProductProcessUtil.DICT_ID_HS_NO_EXIST, "");
					
					//拼接SQL语句--将原手工调整值写入调整日志表备份
					sb.setLength(0);
					sb.append("insert into o32_cj.TO32_SJ_SCZJZJ_LOG ")
					  .append("  (L_FUND_ID, WTR, SCZJLY, SCZJZJGL, SCZJZJED, TZSJ, BZ) ")
					  .append("  select L_FUND_ID, WTR, SCZJLY, SCZJZJGL, SCZJZJED, TZSJ, BZ ")
					  .append("    from o32_cj.TO32_SJ_SCZJZJ t ")
					  .append("   where 1 = 1 ")
					  .append("     and t.l_fund_id = '" + lFundId + "' ");
					sqls.add(sb.toString());
					
					//拼接SQL语句--删除原手工调整值
					sb.setLength(0);
					sb.append("delete from o32_cj.TO32_SJ_SCZJZJ t where t.l_fund_id = '" + lFundId + "' ");
					sqls.add(sb.toString());
					
					//拼接SQL语句--插入新手工调整值
					sb.setLength(0);
					sb.append("insert into o32_cj.TO32_SJ_SCZJZJ ")
					  .append("  (L_FUND_ID, WTR, SCZJLY, SCZJZJGL, SCZJZJED, TZSJ, BZ) ")
					  .append("values ")
					  .append("  ('" + lFundId + "', '" + WTR + "', '" + SCZJLY + "', '" + SCZJZJGL + "', '" + SCZJZJED + "', sysdate, '" + BZ + "') ");
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
	 * 头寸信息查询：当日T+0头寸差额
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @param type 1银行间可用质押券明细2交易所非担保交易债券明细
	 * @return
	 * @author chendi
	 */
	@Bizlet("")
	public static List<DataObject> queryT0PositionDiff(DataObject paramObject, DataObject page,String type){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		String sqlOrder = "";
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String vCReportCode = paramObject.getString("vCReportCode");//债券代码（查询条件传入）
			String vCStockName = paramObject.getString("vCStockName");//债券名称（查询条件传入）
			String preDate = paramObject.getString("preDate");//当前交易日期（查询条件默认传入）
			
			if("1".equals(type)){
				//获取内存中的查询SQL语句--T0银行间担保交易债券明细
				if(StringUtils.isEmpty(SQL_T0YHJ)){
					SQL_T0YHJ = getFileSql("tccx_t0yhjkyzyqmx.sql");
				}
				sb.append(SQL_T0YHJ);
			}else if("2".equals(type)){
				//获取内存中的查询SQL语句--T0交易所担保交易债券明细
				if(StringUtils.isEmpty(SQL_T0JYS)){
					SQL_T0JYS = getFileSql("tccx_t0jysfdbjyzqmx.sql");
				}
				sb.append(SQL_T0JYS);
			}
			if(StringUtils.isNotBlank(vCFundCode)){
				sb.append("   and t1.vc_fund_code in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
			}
			if(StringUtils.isNotBlank(vCReportCode)){
				sb.append("   and t1.VC_REPORT_CODE like '%" + vCReportCode + "%' ");
			}
			if(StringUtils.isNotBlank(vCStockName)){
				sb.append("   and t1.VC_STOCK_NAME like '%" + vCStockName + "%' ");
			}
			//默认取tbondinfo表中当前业务日期
			if(StringUtils.isNotBlank(preDate)){
				sb.append("   and to_char(t1.L_TRADE_DATE) = '" + preDate + "' ");
			}
			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					String L_FUND_ID = map.get("L_FUND_ID");//基金ID
					String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					String VC_REPORT_CODE = map.get("VC_REPORT_CODE");//债券代码
					String VC_STOCK_NAME = StrUtil.changeNull(map.get("VC_STOCK_NAME")).trim().replace("（", "(").replace("）", ")");//债券名称
					String VC_MARKET_NO = map.get("VC_MARKET_NO");//交易市场
					String C_BOND_RATING = map.get("C_BOND_RATING");//债项评级
					String C_SUBJECT_RATING = map.get("C_SUBJECT_RATING");//主体评级
					String L_SALE_AMOUNT_COUNT = StrUtil.addThousandth(map.get("L_SALE_AMOUNT_COUNT"), StrUtil.df1);//可用数量总额
					String L_SALE_AMOUNT = StrUtil.addThousandth(map.get("L_SALE_AMOUNT"), StrUtil.df1);//可用数量
					String C_ISSUER_TYPE = map.get("C_ISSUER_TYPE");//企业性质
					String VC_BOND_TYPE_WIND_FIRST = map.get("VC_BOND_TYPE_WIND_FIRST");//Wind一级债券类型
					String VC_BOND_TYPE_WIND_SECOND = map.get("VC_BOND_TYPE_WIND_SECOND");//Wind二级债券类型
					
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					
					//给对象赋值
					obj.setString("L_FUND_ID", L_FUND_ID);
					obj.setString("VC_FUND_CODE", VC_FUND_CODE);
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);
					obj.setString("VC_REPORT_CODE", VC_REPORT_CODE);
					obj.setString("VC_STOCK_NAME", VC_STOCK_NAME);
					obj.setString("VC_MARKET_NO", VC_MARKET_NO);
					obj.setString("C_BOND_RATING", C_BOND_RATING);
					obj.setString("C_SUBJECT_RATING", C_SUBJECT_RATING);
					obj.setString("L_SALE_AMOUNT_COUNT", L_SALE_AMOUNT_COUNT);
					obj.setString("L_SALE_AMOUNT", L_SALE_AMOUNT);
					obj.setString("C_ISSUER_TYPE", C_ISSUER_TYPE);
					obj.setString("VC_BOND_TYPE_WIND_FIRST", VC_BOND_TYPE_WIND_FIRST);
					obj.setString("VC_BOND_TYPE_WIND_SECOND", VC_BOND_TYPE_WIND_SECOND);
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
	 * 头寸信息查询：当日T+1头寸差额
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @param type 3交易所可用标准券数量4可提交质押债券明细5交易所担保交易债券明细
	 * @return
	 * @author chendi
	 */
	@Bizlet("")
	public static List<DataObject> queryT1PositionDiff(DataObject paramObject, DataObject page,String type){
		DataObject obj = null;
		Connection conn = null;
		StringBuffer sb = new StringBuffer();
		String sqlOrder = "";
		List<DataObject> result = new ArrayList<DataObject>();
		try {
			//获取O32系统数据库连接
			conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
			String vCFundCode = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
			String vCReportCode = paramObject.getString("vCReportCode");//债券代码（查询条件传入）
			String vCStockName = paramObject.getString("vCStockName");//债券名称（查询条件传入）
			String preDate = paramObject.getString("preDate");//当前交易日期（查询条件默认传入）
			
			//判断是哪个页面过来的数据，获取不同的查询语句
			if("3".equals(type)){
				//获取内存中的查询SQL语句--T1交易所可用
				if(StringUtils.isEmpty(SQL_T1JYSKY)){
					SQL_T1JYSKY = getFileSql("tccx_t1jyskybzqsl.sql");
				}
				sb.append(SQL_T1JYSKY);
				if(StringUtils.isNotBlank(vCFundCode)){
					sb.append("   and t1.vc_fund_code in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
				}
			}else if("4".equals(type)){
				//获取内存中的查询SQL语句--t1可用提交质押券
				if(StringUtils.isEmpty(SQL_T1KTJZYQ)){
					SQL_T1KTJZYQ = getFileSql("tccx_t1kzyzqmx.sql");
				}
				sb.append(SQL_T1KTJZYQ);
				if(StringUtils.isNotBlank(vCFundCode)){
					sb.append("   and t1.vc_fund_code in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
				}
				if(StringUtils.isNotBlank(vCReportCode)){
					sb.append("   and t1.VC_REPORT_CODE like '%" + vCReportCode + "%' ");
				}
				if(StringUtils.isNotBlank(vCStockName)){
					sb.append("   and t1.VC_STOCK_NAME like '%" + vCStockName + "%' ");
				}
			}else if("5".equals(type)){
				//获取内存中的查询SQL语句--t1交易所担保质押券明细
				if(StringUtils.isEmpty(SQL_T1JYSDB)){
					SQL_T1JYSDB = getFileSql("tccx_t1jysdbjyzqmx.sql");
				}
				sb.append(SQL_T1JYSDB);
				if(StringUtils.isNotBlank(vCFundCode)){
					sb.append("   and t1.vc_fund_code in (").append(JDBCUtil.changeInStr(vCFundCode)).append(") ");
				}
				if(StringUtils.isNotBlank(vCReportCode)){
					sb.append("   and t1.VC_REPORT_CODE like '%" + vCReportCode + "%' ");
				}
				if(StringUtils.isNotBlank(vCStockName)){
					sb.append("   and t1.VC_STOCK_NAME like '%" + vCStockName + "%' ");
				}
				//默认取tbondinfo表中当前业务日期
				if(StringUtils.isNotBlank(preDate)){
					sb.append("   and to_char(t1.L_TRADE_DATE) = '" + preDate + "' ");
				}
			}
			
			//查询结果集
			List<Map<String, String>> list = JDBCUtil.queryWithConnPage(conn, sb, sqlOrder, page);
			if(!list.isEmpty() && list.size()>0){
				for(int i=0; i<list.size(); i++){
					Map<String, String> map = list.get(i);
					obj = DataObjectUtil.createDataObject("com.cjhxfund.jy.ProductProcess.customEntityDataset.ZhxxcxEntity");
					String L_FUND_ID = map.get("L_FUND_ID");//基金ID
					String VC_FUND_CODE = map.get("VC_FUND_CODE");//基金代码
					String VC_FUND_NAME = map.get("VC_FUND_NAME");//基金名称
					String VC_MARKET_NO = map.get("VC_MARKET_NO");//交易市场
					//给对象赋值
					obj.setString("L_FUND_ID", L_FUND_ID);
					obj.setString("VC_FUND_CODE", VC_FUND_CODE);
					obj.setString("VC_FUND_NAME", VC_FUND_NAME);
					obj.setString("VC_MARKET_NO", VC_MARKET_NO);
					
					if("3".equals(type)){
						String L_ENABLE_AMOUNT_COUNT = StrUtil.addThousandth(map.get("L_ENABLE_AMOUNT_COUNT"), StrUtil.df1);//总数量
						String L_ENABLE_AMOUNT = StrUtil.addThousandth(map.get("L_ENABLE_AMOUNT"), StrUtil.df1);//数量
						obj.setString("L_ENABLE_AMOUNT_COUNT", L_ENABLE_AMOUNT_COUNT);
						obj.setString("L_ENABLE_AMOUNT", L_ENABLE_AMOUNT);
					}else if("4".equals(type)){
						String VC_REPORT_CODE = map.get("VC_REPORT_CODE");//债券代码
						String VC_STOCK_NAME = StrUtil.changeNull(map.get("VC_STOCK_NAME")).trim().replace("（", "(").replace("）", ")");//债券名称
						String L_PLEDGE_AMOUNT_COUNT = StrUtil.addThousandth(map.get("L_PLEDGE_AMOUNT_COUNT"), StrUtil.df1);//数量总额
						String L_PLEDGE_AMOUNT = StrUtil.addThousandth(map.get("L_PLEDGE_AMOUNT"), StrUtil.df1);//数量
						String L_STANDARD_AMOUNT_COUNT = StrUtil.addThousandth(map.get("L_STANDARD_AMOUNT_COUNT"), StrUtil.df1);//折算标准券数量总额
						String L_CONVERTED_STANDARD_AMOUNT = StrUtil.addThousandth(map.get("L_CONVERTED_STANDARD_AMOUNT"), StrUtil.df1);//折算标准券数量
						
						obj.setString("VC_REPORT_CODE", VC_REPORT_CODE);
						obj.setString("VC_STOCK_NAME", VC_STOCK_NAME);
						obj.setString("L_PLEDGE_AMOUNT_COUNT", L_PLEDGE_AMOUNT_COUNT);
						obj.setString("L_PLEDGE_AMOUNT", L_PLEDGE_AMOUNT);
						obj.setString("L_STANDARD_AMOUNT_COUNT", L_STANDARD_AMOUNT_COUNT);
						obj.setString("L_CONVERTED_STANDARD_AMOUNT", L_CONVERTED_STANDARD_AMOUNT);
					}else if("5".equals(type)){
						String VC_REPORT_CODE = map.get("VC_REPORT_CODE");//债券代码
						String VC_STOCK_NAME = StrUtil.changeNull(map.get("VC_STOCK_NAME")).trim().replace("（", "(").replace("）", ")");//债券名称
						String L_SALE_AMOUNT_COUNT = StrUtil.addThousandth(map.get("L_SALE_AMOUNT_COUNT"), StrUtil.df1);//可用数量总数
						String L_SALE_AMOUNT = StrUtil.addThousandth(map.get("L_SALE_AMOUNT"), StrUtil.df1);//可用数量
						String C_BOND_RATING = map.get("C_BOND_RATING");//债项评级
						String C_SUBJECT_RATING = map.get("C_SUBJECT_RATING");//主体评级
						String VC_BOND_TYPE_WIND_FIRST = map.get("VC_BOND_TYPE_WIND_FIRST");//Wind一级债券类型
						String VC_BOND_TYPE_WIND_SECOND = map.get("VC_BOND_TYPE_WIND_SECOND");//Wind二级债券类型
						
						obj.setString("C_BOND_RATING", C_BOND_RATING);
						obj.setString("C_SUBJECT_RATING", C_SUBJECT_RATING);
						obj.setString("VC_BOND_TYPE_WIND_FIRST", VC_BOND_TYPE_WIND_FIRST);
						obj.setString("VC_BOND_TYPE_WIND_SECOND", VC_BOND_TYPE_WIND_SECOND);
						obj.setString("L_SALE_AMOUNT_COUNT", L_SALE_AMOUNT_COUNT);
						obj.setString("L_SALE_AMOUNT", L_SALE_AMOUNT);
						obj.setString("VC_REPORT_CODE", VC_REPORT_CODE);
						obj.setString("VC_STOCK_NAME", VC_STOCK_NAME);
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
	 * 返回一个空的list
	 * @return
	 * @author jiangkanqian
	 */
	@Bizlet("")
	public static List<DataObject> emptyList(){
		List<DataObject> result = new ArrayList<DataObject>();
		return result;
	}
	
	/**
	 * 头寸信息查询：当日T+1头寸差额
	 * @param paramObject 查询条件对象
	 * @param page 分页对象
	 * @param type 3交易所可用标准券数量4可提交质押债券明细5交易所担保交易债券明细
	 * @return
	 * @author chendi
	 */
	@Bizlet("")
	public static List<DataObject> queryTCFXCSB(DataObject paramObject, DataObject page,String type){
		//定义返回值
		List<DataObject> result = new ArrayList<DataObject>();
		String vcFundCodes = paramObject.getString("vCFundCode");//基金代码（查询条件传入）
		String vCReportCode = paramObject.getString("vCReportCode");//债券代码（查询条件传入）
		String vCStockName = paramObject.getString("vCStockName");//债券名称（查询条件传入）
		String vcproductCodes = paramObject.getString("combProductCodes");//基金代码（产品权限）
		
		if(StringUtils.isNotBlank(vcproductCodes)){
			if(vcproductCodes.indexOf("All Products,") > -1){
				vcproductCodes = vcproductCodes.replace("All Products,", "");
			}
			String[] produtcodes=vcproductCodes.split(",");
			String ret = null;
			try {
				String json = null;
				JsonObject object=new JsonObject();
				Gson gson = new Gson();
				String produtList = gson.toJson(produtcodes);
				if(StringUtils.isNotBlank(vcFundCodes)){
					String[] FundCodes=vcFundCodes.split(",");
					String fundCodeList = gson.toJson(FundCodes);
					object.addProperty("fundCodeList", fundCodeList);
				}else{
					object.addProperty("fundCodeList", produtList);
				}
				if(("1").equals(type)){
					String [] markets = new String[]{"5"};
					String marketTypeList = gson.toJson(markets);
					object.addProperty("marketTypeList", marketTypeList);
					object.addProperty("calcType", "2");
					json = object.toString();
					ret = HttpClientService.postByJson(getUrl("URL_TCFXCSB"), json);
				}else if(("2").equals(type)){
					String [] markets = new String[]{"1","2"};
					String marketTypeList = gson.toJson(markets);
					object.addProperty("marketTypeList", marketTypeList);
					object.addProperty("calcType", "2");
					json = object.toString();
					ret = HttpClientService.postByJson(getUrl("URL_TCFXCSB"), json);
				}else if(("3").equals(type)){
					String [] markets = new String[]{"1","2"};
					String marketTypeList = gson.toJson(markets);
					object.addProperty("marketTypeList", marketTypeList);
					object.addProperty("calcType", "4");
					json = object.toString();
					ret = HttpClientService.postByJson(getUrl("URL_TCFXCSB"), json);
				}else if(("4").equals(type)){
					String [] markets = new String[]{"1","2"};
					String marketTypeList = gson.toJson(markets);
					object.addProperty("marketTypeList", marketTypeList);
					object.addProperty("calcType", "3");
					json = object.toString();
					ret = HttpClientService.postByJson(getUrl("URL_TCFXCSB"), json);
				}else if(("5").equals(type)){
					String [] markets = new String[]{"1","2"};
					String marketTypeList = gson.toJson(markets);
					object.addProperty("marketTypeList", marketTypeList);
					object.addProperty("calcType", "1");
					json = object.toString();
					ret = HttpClientService.postByJson(getUrl("URL_TCFXCSB"), json);
				}
				
				//调试
				/*ret = "";
				File filename = new File("C:\\Users\\jiangkanqian\\Desktop\\cj0237报文");
                InputStreamReader reader = new InputStreamReader(  
                        new FileInputStream(filename));
                BufferedReader br = new BufferedReader(reader);  
                String line = "";  
                while (line != null) {  
                    line = br.readLine(); 
                    if(line != null)
                    	ret += line;
                }  
                System.out.println(ret);
                br.close();
                reader.close();*/
                
				BaseRiskPostion baseRiskPostion = gson.fromJson(ret, BaseRiskPostion.class);
				
				//成功返回数据,则正常处理。否则输出错误信息
				if("1".equals(baseRiskPostion.getCode())){
					//获取列表大小
					//组装新的list(先拆分原来的list,将页面需要的元素重新放在新的List<dataObject>中)
					for(int i=0;i<baseRiskPostion.getData().size();i++){
						DataObject resultData = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
						if((vcFundCodes !=null && vcFundCodes !="") || (vCReportCode !=null && vCReportCode !="")|| (vCStockName !=null && vCStockName !="")){
							if(StringUtils.isNotBlank(vcFundCodes) && StringUtils.isNotBlank(vCReportCode) && StringUtils.isNotBlank(vCStockName)){
										if((vcFundCodes.indexOf(baseRiskPostion.getData().get(i).getFundCode().toString()) > -1) &&
												baseRiskPostion.getData().get(i).getBondCode().indexOf(vCReportCode) > -1&& 
												baseRiskPostion.getData().get(i).getBondName().indexOf(vCStockName) > -1){
											resultData.setString("L_FUND_ID", baseRiskPostion.getData().get(i).getFundId().toString());//基金序号
											resultData.setString("VC_FUND_CODE", baseRiskPostion.getData().get(i).getFundCode().toString());//基金代码
											resultData.setString("VC_FUND_NAME", baseRiskPostion.getData().get(i).getFundName().toString());//基金名称
											resultData.setString("VC_MARKET_NO", getMarketName(baseRiskPostion.getData().get(i).getMarketNo()));
											resultData.set("TRUSTEESHIP", getTrusteeShip(baseRiskPostion.getData().get(i).getTrusteeShip()));
											resultData.setString("VC_REPORT_CODE", baseRiskPostion.getData().get(i).getBondCode());
											resultData.setString("VC_STOCK_NAME", baseRiskPostion.getData().get(i).getBondName());
											//resultData.set("CURRENT_AMOUNT", baseRiskPostion.getData().get(i).getCurrentAmount());
											//resultData.set("FROZEN_AMOUNT", baseRiskPostion.getData().get(i).getFrozenAmount());
											//resultData.set("UNFROZEN_AMOUNT", baseRiskPostion.getData().get(i).getUnfrozenAmount());
											resultData.set("L_SALE_AMOUNT", baseRiskPostion.getData().get(i).getEnableAmount());
											resultData.set("L_ENABLE_AMOUNT", baseRiskPostion.getData().get(i).getEnableAmount());
											resultData.set("L_ENABLE_AMOUNT_NEXT", baseRiskPostion.getData().get(i).getEnableAmountNext());
											resultData.set("L_CONVERTED_STANDARD_AMOUNT", baseRiskPostion.getData().get(i).getConvertStdAmount());
											resultData.set("L_CONVERTED_STANDARD_AMOUNT_NEXT", baseRiskPostion.getData().get(i).getConvertStdAmountNext());
											//resultData.set("FAPRICE", baseRiskPostion.getData().get(i).getFaPrice());
											resultData.setString("VC_BOND_TYPE_WIND_FIRST", baseRiskPostion.getData().get(i).getBondTypeWindFirst());
											resultData.setString("VC_BOND_TYPE_WIND_SECOND", baseRiskPostion.getData().get(i).getBondTypeWindSecond());
											resultData.setString("C_BOND_RATING", baseRiskPostion.getData().get(i).getBondAppraise());
											resultData.setString("C_SUBJECT_RATING", baseRiskPostion.getData().get(i).getIssuerAppraise());
											resultData.setString("C_ISSUER_TYPE", baseRiskPostion.getData().get(i).getIssuerProperty());
											result.add(resultData);
										}
							}else if(StringUtils.isNotBlank(vCReportCode) && StringUtils.isNotBlank(vCStockName)){
								if(baseRiskPostion.getData().get(i).getBondCode().indexOf(vCReportCode) >-1 && 
										baseRiskPostion.getData().get(i).getBondName().indexOf(vCStockName) > -1){
									resultData.setString("L_FUND_ID", baseRiskPostion.getData().get(i).getFundId().toString());//基金序号
									resultData.setString("VC_FUND_CODE", baseRiskPostion.getData().get(i).getFundCode().toString());//基金代码
									resultData.setString("VC_FUND_NAME", baseRiskPostion.getData().get(i).getFundName().toString());//基金名称
									resultData.setString("VC_MARKET_NO", getMarketName(baseRiskPostion.getData().get(i).getMarketNo()));
									resultData.set("TRUSTEESHIP", getTrusteeShip(baseRiskPostion.getData().get(i).getTrusteeShip()));
									resultData.setString("VC_REPORT_CODE", baseRiskPostion.getData().get(i).getBondCode());
									resultData.setString("VC_STOCK_NAME", baseRiskPostion.getData().get(i).getBondName());
									//resultData.set("CURRENT_AMOUNT", baseRiskPostion.getData().get(i).getCurrentAmount());
									//resultData.set("FROZEN_AMOUNT", baseRiskPostion.getData().get(i).getFrozenAmount());
									//resultData.set("UNFROZEN_AMOUNT", baseRiskPostion.getData().get(i).getUnfrozenAmount());
									resultData.set("L_SALE_AMOUNT", baseRiskPostion.getData().get(i).getEnableAmount());
									resultData.set("L_ENABLE_AMOUNT", baseRiskPostion.getData().get(i).getEnableAmount());
									resultData.set("L_ENABLE_AMOUNT_NEXT", baseRiskPostion.getData().get(i).getEnableAmountNext());
									resultData.set("L_CONVERTED_STANDARD_AMOUNT", baseRiskPostion.getData().get(i).getConvertStdAmount());
									resultData.set("L_CONVERTED_STANDARD_AMOUNT_NEXT", baseRiskPostion.getData().get(i).getConvertStdAmountNext());
									//resultData.set("FAPRICE", baseRiskPostion.getData().get(i).getFaPrice());
									resultData.setString("VC_BOND_TYPE_WIND_FIRST", baseRiskPostion.getData().get(i).getBondTypeWindFirst());
									resultData.setString("VC_BOND_TYPE_WIND_SECOND", baseRiskPostion.getData().get(i).getBondTypeWindSecond());
									resultData.setString("C_BOND_RATING", baseRiskPostion.getData().get(i).getBondAppraise());
									resultData.setString("C_SUBJECT_RATING", baseRiskPostion.getData().get(i).getIssuerAppraise());
									resultData.setString("C_ISSUER_TYPE", baseRiskPostion.getData().get(i).getIssuerProperty());
									result.add(resultData);
								}
							}else if(StringUtils.isNotBlank(vcFundCodes) && StringUtils.isNotBlank(vCStockName)){
								if(vcFundCodes.indexOf(baseRiskPostion.getData().get(i).getFundCode()) > -1 && 
										baseRiskPostion.getData().get(i).getBondName().indexOf(vCStockName) > -1){
									resultData.setString("L_FUND_ID", baseRiskPostion.getData().get(i).getFundId().toString());//基金序号
									resultData.setString("VC_FUND_CODE", baseRiskPostion.getData().get(i).getFundCode().toString());//基金代码
									resultData.setString("VC_FUND_NAME", baseRiskPostion.getData().get(i).getFundName().toString());//基金名称
									resultData.setString("VC_MARKET_NO", getMarketName(baseRiskPostion.getData().get(i).getMarketNo()));
									resultData.set("TRUSTEESHIP", getTrusteeShip(baseRiskPostion.getData().get(i).getTrusteeShip()));
									resultData.setString("VC_REPORT_CODE", baseRiskPostion.getData().get(i).getBondCode());
									resultData.setString("VC_STOCK_NAME", baseRiskPostion.getData().get(i).getBondName());
									//resultData.set("CURRENT_AMOUNT", baseRiskPostion.getData().get(i).getCurrentAmount());
									//resultData.set("FROZEN_AMOUNT", baseRiskPostion.getData().get(i).getFrozenAmount());
									//resultData.set("UNFROZEN_AMOUNT", baseRiskPostion.getData().get(i).getUnfrozenAmount());
									resultData.set("L_SALE_AMOUNT", baseRiskPostion.getData().get(i).getEnableAmount());
									resultData.set("L_ENABLE_AMOUNT", baseRiskPostion.getData().get(i).getEnableAmount());
									resultData.set("L_ENABLE_AMOUNT_NEXT", baseRiskPostion.getData().get(i).getEnableAmountNext());
									resultData.set("L_CONVERTED_STANDARD_AMOUNT", baseRiskPostion.getData().get(i).getConvertStdAmount());
									resultData.set("L_CONVERTED_STANDARD_AMOUNT_NEXT", baseRiskPostion.getData().get(i).getConvertStdAmountNext());
									//resultData.set("FAPRICE", baseRiskPostion.getData().get(i).getFaPrice());
									resultData.setString("VC_BOND_TYPE_WIND_FIRST", baseRiskPostion.getData().get(i).getBondTypeWindFirst());
									resultData.setString("VC_BOND_TYPE_WIND_SECOND", baseRiskPostion.getData().get(i).getBondTypeWindSecond());
									resultData.setString("C_BOND_RATING", baseRiskPostion.getData().get(i).getBondAppraise());
									resultData.setString("C_SUBJECT_RATING", baseRiskPostion.getData().get(i).getIssuerAppraise());
									resultData.setString("C_ISSUER_TYPE", baseRiskPostion.getData().get(i).getIssuerProperty());
									result.add(resultData);
								}
							}else if(StringUtils.isNotBlank(vcFundCodes) && StringUtils.isNotBlank(vCReportCode)){
								if((vcFundCodes.indexOf(baseRiskPostion.getData().get(i).getFundCode())) > -1 && 
										(baseRiskPostion.getData().get(i).getBondCode().indexOf(vCReportCode)) > -1){
									resultData.setString("L_FUND_ID", baseRiskPostion.getData().get(i).getFundId().toString());//基金序号
									resultData.setString("VC_FUND_CODE", baseRiskPostion.getData().get(i).getFundCode().toString());//基金代码
									resultData.setString("VC_FUND_NAME", baseRiskPostion.getData().get(i).getFundName().toString());//基金名称
									resultData.setString("VC_MARKET_NO", getMarketName(baseRiskPostion.getData().get(i).getMarketNo()));
									resultData.set("TRUSTEESHIP", getTrusteeShip(baseRiskPostion.getData().get(i).getTrusteeShip()));
									resultData.setString("VC_REPORT_CODE", baseRiskPostion.getData().get(i).getBondCode());
									resultData.setString("VC_STOCK_NAME", baseRiskPostion.getData().get(i).getBondName());
									//resultData.set("CURRENT_AMOUNT", baseRiskPostion.getData().get(i).getCurrentAmount());
									//resultData.set("FROZEN_AMOUNT", baseRiskPostion.getData().get(i).getFrozenAmount());
									//resultData.set("UNFROZEN_AMOUNT", baseRiskPostion.getData().get(i).getUnfrozenAmount());
									resultData.set("L_ENABLE_AMOUNT", baseRiskPostion.getData().get(i).getEnableAmount());
									resultData.set("L_ENABLE_AMOUNT_NEXT", baseRiskPostion.getData().get(i).getEnableAmountNext());
									resultData.set("L_CONVERTED_STANDARD_AMOUNT", baseRiskPostion.getData().get(i).getConvertStdAmount());
									resultData.set("L_CONVERTED_STANDARD_AMOUNT_NEXT", baseRiskPostion.getData().get(i).getConvertStdAmountNext());
									//resultData.set("FAPRICE", baseRiskPostion.getData().get(i).getFaPrice());
									resultData.setString("VC_BOND_TYPE_WIND_FIRST", baseRiskPostion.getData().get(i).getBondTypeWindFirst());
									resultData.setString("VC_BOND_TYPE_WIND_SECOND", baseRiskPostion.getData().get(i).getBondTypeWindSecond());
									resultData.setString("C_BOND_RATING", baseRiskPostion.getData().get(i).getBondAppraise());
									resultData.setString("C_SUBJECT_RATING", baseRiskPostion.getData().get(i).getIssuerAppraise());
									resultData.setString("C_ISSUER_TYPE", baseRiskPostion.getData().get(i).getIssuerProperty());
									result.add(resultData);
								}
							}else if(StringUtils.isNotBlank(vcFundCodes)){
								if((vcFundCodes.indexOf(baseRiskPostion.getData().get(i).getFundCode().toString()) > -1)){
									resultData.setString("L_FUND_ID", baseRiskPostion.getData().get(i).getFundId().toString());//基金序号
									resultData.setString("VC_FUND_CODE", baseRiskPostion.getData().get(i).getFundCode().toString());//基金代码
									resultData.setString("VC_FUND_NAME", baseRiskPostion.getData().get(i).getFundName().toString());//基金名称
									resultData.setString("VC_MARKET_NO", getMarketName(baseRiskPostion.getData().get(i).getMarketNo()));
									resultData.set("TRUSTEESHIP", getTrusteeShip(baseRiskPostion.getData().get(i).getTrusteeShip()));
									resultData.setString("VC_REPORT_CODE", baseRiskPostion.getData().get(i).getBondCode());
									resultData.setString("VC_STOCK_NAME", baseRiskPostion.getData().get(i).getBondName());
									//resultData.set("CURRENT_AMOUNT", baseRiskPostion.getData().get(i).getCurrentAmount());
									//resultData.set("FROZEN_AMOUNT", baseRiskPostion.getData().get(i).getFrozenAmount());
									//resultData.set("UNFROZEN_AMOUNT", baseRiskPostion.getData().get(i).getUnfrozenAmount());
									resultData.set("L_SALE_AMOUNT", baseRiskPostion.getData().get(i).getEnableAmount());
									resultData.set("L_ENABLE_AMOUNT", baseRiskPostion.getData().get(i).getEnableAmount());
									resultData.set("L_ENABLE_AMOUNT_NEXT", baseRiskPostion.getData().get(i).getEnableAmountNext());
									resultData.set("L_CONVERTED_STANDARD_AMOUNT", baseRiskPostion.getData().get(i).getConvertStdAmount());
									resultData.set("L_CONVERTED_STANDARD_AMOUNT_NEXT", baseRiskPostion.getData().get(i).getConvertStdAmountNext());
									//resultData.set("FAPRICE", baseRiskPostion.getData().get(i).getFaPrice());
									resultData.setString("VC_BOND_TYPE_WIND_FIRST", baseRiskPostion.getData().get(i).getBondTypeWindFirst());
									resultData.setString("VC_BOND_TYPE_WIND_SECOND", baseRiskPostion.getData().get(i).getBondTypeWindSecond());
									resultData.setString("C_BOND_RATING", baseRiskPostion.getData().get(i).getBondAppraise());
									resultData.setString("C_SUBJECT_RATING", baseRiskPostion.getData().get(i).getIssuerAppraise());
									resultData.setString("C_ISSUER_TYPE", baseRiskPostion.getData().get(i).getIssuerProperty());
									result.add(resultData);
								}
							}else if(StringUtils.isNotBlank(vCReportCode)){
								if((baseRiskPostion.getData().get(i).getBondCode().indexOf(vCReportCode)) > -1){
									resultData.setString("L_FUND_ID", baseRiskPostion.getData().get(i).getFundId().toString());//基金序号
									resultData.setString("VC_FUND_CODE", baseRiskPostion.getData().get(i).getFundCode().toString());//基金代码
									resultData.setString("VC_FUND_NAME", baseRiskPostion.getData().get(i).getFundName().toString());//基金名称
									resultData.setString("VC_MARKET_NO", getMarketName(baseRiskPostion.getData().get(i).getMarketNo()));
									resultData.set("TRUSTEESHIP", getTrusteeShip(baseRiskPostion.getData().get(i).getTrusteeShip()));
									resultData.setString("VC_REPORT_CODE", baseRiskPostion.getData().get(i).getBondCode());
									resultData.setString("VC_STOCK_NAME", baseRiskPostion.getData().get(i).getBondName());
									//resultData.set("CURRENT_AMOUNT", baseRiskPostion.getData().get(i).getCurrentAmount());
									//resultData.set("FROZEN_AMOUNT", baseRiskPostion.getData().get(i).getFrozenAmount());
									//resultData.set("UNFROZEN_AMOUNT", baseRiskPostion.getData().get(i).getUnfrozenAmount());
									resultData.set("L_SALE_AMOUNT", baseRiskPostion.getData().get(i).getEnableAmount());
									resultData.set("L_ENABLE_AMOUNT", baseRiskPostion.getData().get(i).getEnableAmount());
									resultData.set("L_ENABLE_AMOUNT_NEXT", baseRiskPostion.getData().get(i).getEnableAmountNext());
									resultData.set("L_CONVERTED_STANDARD_AMOUNT", baseRiskPostion.getData().get(i).getConvertStdAmount());
									resultData.set("L_CONVERTED_STANDARD_AMOUNT_NEXT", baseRiskPostion.getData().get(i).getConvertStdAmountNext());
									//resultData.set("FAPRICE", baseRiskPostion.getData().get(i).getFaPrice());
									resultData.setString("VC_BOND_TYPE_WIND_FIRST", baseRiskPostion.getData().get(i).getBondTypeWindFirst());
									resultData.setString("VC_BOND_TYPE_WIND_SECOND", baseRiskPostion.getData().get(i).getBondTypeWindSecond());
									resultData.setString("C_BOND_RATING", baseRiskPostion.getData().get(i).getBondAppraise());
									resultData.setString("C_SUBJECT_RATING", baseRiskPostion.getData().get(i).getIssuerAppraise());
									resultData.setString("C_ISSUER_TYPE", baseRiskPostion.getData().get(i).getIssuerProperty());
									result.add(resultData);
								}
							}else if(StringUtils.isNotBlank(vCStockName)){
								if((baseRiskPostion.getData().get(i).getBondName().indexOf(vCStockName)) > -1){
									resultData.setString("L_FUND_ID", baseRiskPostion.getData().get(i).getFundId().toString());//基金序号
									resultData.setString("VC_FUND_CODE", baseRiskPostion.getData().get(i).getFundCode().toString());//基金代码
									resultData.setString("VC_FUND_NAME", baseRiskPostion.getData().get(i).getFundName().toString());//基金名称
									resultData.setString("VC_MARKET_NO", getMarketName(baseRiskPostion.getData().get(i).getMarketNo()));
									resultData.set("TRUSTEESHIP", getTrusteeShip(baseRiskPostion.getData().get(i).getTrusteeShip()));
									resultData.setString("VC_REPORT_CODE", baseRiskPostion.getData().get(i).getBondCode());
									resultData.setString("VC_STOCK_NAME", baseRiskPostion.getData().get(i).getBondName());
									//resultData.set("CURRENT_AMOUNT", baseRiskPostion.getData().get(i).getCurrentAmount());
									//resultData.set("FROZEN_AMOUNT", baseRiskPostion.getData().get(i).getFrozenAmount());
									//resultData.set("UNFROZEN_AMOUNT", baseRiskPostion.getData().get(i).getUnfrozenAmount());
									resultData.set("L_SALE_AMOUNT", baseRiskPostion.getData().get(i).getEnableAmount());
									resultData.set("L_ENABLE_AMOUNT", baseRiskPostion.getData().get(i).getEnableAmount());
									resultData.set("L_ENABLE_AMOUNT_NEXT", baseRiskPostion.getData().get(i).getEnableAmountNext());
									resultData.set("L_CONVERTED_STANDARD_AMOUNT", baseRiskPostion.getData().get(i).getConvertStdAmount());
									resultData.set("L_CONVERTED_STANDARD_AMOUNT_NEXT", baseRiskPostion.getData().get(i).getConvertStdAmountNext());
									//resultData.set("FAPRICE", baseRiskPostion.getData().get(i).getFaPrice());
									resultData.setString("VC_BOND_TYPE_WIND_FIRST", baseRiskPostion.getData().get(i).getBondTypeWindFirst());
									resultData.setString("VC_BOND_TYPE_WIND_SECOND", baseRiskPostion.getData().get(i).getBondTypeWindSecond());
									resultData.setString("C_BOND_RATING", baseRiskPostion.getData().get(i).getBondAppraise());
									resultData.setString("C_SUBJECT_RATING", baseRiskPostion.getData().get(i).getIssuerAppraise());
									resultData.setString("C_ISSUER_TYPE", baseRiskPostion.getData().get(i).getIssuerProperty());
									result.add(resultData);
								}
							}
						}else{
							resultData.setString("L_FUND_ID", baseRiskPostion.getData().get(i).getFundId().toString());//基金序号
							resultData.setString("VC_FUND_CODE", baseRiskPostion.getData().get(i).getFundCode().toString());//基金代码
							resultData.setString("VC_FUND_NAME", baseRiskPostion.getData().get(i).getFundName().toString());//基金名称
							resultData.setString("VC_MARKET_NO", getMarketName(baseRiskPostion.getData().get(i).getMarketNo()));
							resultData.set("TRUSTEESHIP", getTrusteeShip(baseRiskPostion.getData().get(i).getTrusteeShip()));
							resultData.setString("VC_REPORT_CODE", baseRiskPostion.getData().get(i).getBondCode());
							resultData.setString("VC_STOCK_NAME", baseRiskPostion.getData().get(i).getBondName());
							//resultData.set("CURRENT_AMOUNT", baseRiskPostion.getData().get(i).getCurrentAmount());
							//resultData.set("FROZEN_AMOUNT", baseRiskPostion.getData().get(i).getFrozenAmount());
							//resultData.set("UNFROZEN_AMOUNT", baseRiskPostion.getData().get(i).getUnfrozenAmount());
							resultData.set("L_SALE_AMOUNT", baseRiskPostion.getData().get(i).getEnableAmount());
							resultData.set("L_ENABLE_AMOUNT", baseRiskPostion.getData().get(i).getEnableAmount());
							resultData.set("ENABLE_AMOUNT_NEXT", baseRiskPostion.getData().get(i).getEnableAmountNext());
							resultData.set("L_CONVERTED_STANDARD_AMOUNT", baseRiskPostion.getData().get(i).getConvertStdAmount());
							//resultData.set("FAPRICE", baseRiskPostion.getData().get(i).getFaPrice());
							resultData.setString("VC_BOND_TYPE_WIND_FIRST", baseRiskPostion.getData().get(i).getBondTypeWindFirst());
							resultData.setString("VC_BOND_TYPE_WIND_SECOND", baseRiskPostion.getData().get(i).getBondTypeWindSecond());
							resultData.setString("C_BOND_RATING", baseRiskPostion.getData().get(i).getBondAppraise());
							resultData.setString("C_SUBJECT_RATING", baseRiskPostion.getData().get(i).getIssuerAppraise());
							resultData.setString("C_ISSUER_TYPE", baseRiskPostion.getData().get(i).getIssuerProperty());
							result.add(resultData);
						}
					}
				}else{
					System.out.println(baseRiskPostion.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return result;
	}
	/**
	 * 获取交易市场名称
	 * @param marketNo
	 * @return
	 */
	public static String getMarketName(String marketNo){
		String marketName = null;
		//根据交易市场编号返回O32交易市场名称
		Object[] rtnData = DatabaseExt.queryByNamedSql(CacheUtil.getO32CacheDataSourceName(),
				"com.cjhxfund.jy.ProductProcess.cashFlowInfo.queryMarketInfo",marketNo);
		if(rtnData[0]!=null){
			marketName = (String)rtnData[0];
		}
		return marketName;
	}
	/**
	 * 交易来源字典翻译
	 * @param data
	 * @return
	 */
	public static String getTrusteeShip(String data){
		String trusteeShip = null;
		if("0".equals(data)){
			trusteeShip = "中证登";
		}else if("1".equals(data)){
			trusteeShip = "中债登";
		}else if("2".equals(data)){
			trusteeShip = "上清所";
		}
		return trusteeShip;
	}
}
