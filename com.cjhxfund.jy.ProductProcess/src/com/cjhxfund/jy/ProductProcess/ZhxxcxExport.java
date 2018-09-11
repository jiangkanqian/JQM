package com.cjhxfund.jy.ProductProcess;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFPalette;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.CellStyle;

import com.cjhxfund.commonUtil.CoframeSupplement;
import com.cjhxfund.commonUtil.ParamConfig;
import com.cjhxfund.commonUtil.StrUtil;
import com.eos.engine.component.ILogicComponent;
import com.eos.system.annotation.Bizlet;
import com.primeton.ext.engine.component.LogicComponentFactory;

import commonj.sdo.DataObject;

/**
 * 综合信息查询Excel导出功能
 * @author huangmizhi
 */
@Bizlet("")
public class ZhxxcxExport {
	
	/** Excel文件名称前缀：综合信息查询 */
	public static final String EXCEL_NAME_PREFIX = "";
	
	/**
	 * 生成Excel并导出
	 * @param exportData 导出数据
	 * @param paramObject 导出条件对象
	 * @return
	 * @throws Exception
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static String zhxxcxExport(List<DataObject> exportData, DataObject paramObject) throws Exception {
		try {
			//创建Excel文件
			HSSFWorkbook workbook = new HSSFWorkbook();
			
			//设置列头字体格式
			HSSFFont headFont = workbook.createFont();
			headFont.setFontName("宋体");
			headFont.setFontHeightInPoints((short) 11);// 字体大小
			headFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);// 加粗
			//设置列头字体对齐格式
			HSSFCellStyle sheetHeadFormat = workbook.createCellStyle();
			sheetHeadFormat.setFont(headFont);
			sheetHeadFormat.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中
			sheetHeadFormat.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中
			sheetHeadFormat.setLocked(true);
			sheetHeadFormat.setWrapText(true);// 自动换行			
			
			//设置字体格式
			HSSFFont columnHeadFont = workbook.createFont();
			columnHeadFont.setFontName("宋体");
			columnHeadFont.setFontHeightInPoints((short) 10);// 字体大小
			//左对齐
			HSSFCellStyle BoldUnderlineLEFT = workbook.createCellStyle();
			BoldUnderlineLEFT.setFont(columnHeadFont);
			BoldUnderlineLEFT.setLocked(true);
			BoldUnderlineLEFT.setWrapText(true);// 自动换行
			//右对齐
			HSSFCellStyle BoldUnderlineRight = workbook.createCellStyle();
			BoldUnderlineRight.setFont(columnHeadFont);
			BoldUnderlineRight.setAlignment(HSSFCellStyle.ALIGN_RIGHT);// 左右居中
			BoldUnderlineRight.setLocked(true);
			BoldUnderlineRight.setWrapText(true);// 自动换行
			//居中对齐
			HSSFCellStyle BoldUnderlineCENTRE = workbook.createCellStyle();
			BoldUnderlineCENTRE.setFont(columnHeadFont);
			BoldUnderlineCENTRE.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 左右居中
			BoldUnderlineCENTRE.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 上下居中
			BoldUnderlineCENTRE.setLocked(true);
			BoldUnderlineCENTRE.setWrapText(true);// 自动换行
			
			/**	综合信息查询-查询类型：
			 * 产品信息-CPXX
			 * 资金头寸-ZJTC
			 * 质押券-ZYQ
			 * 标准券-BZQ
			 * 交易所回购-JYSHG
			 * 银行间回购-YHJHG
			 * 组合持仓-ZHCC
			 * 产品交易流水-交易所-CPJYS
			 * 产品交易流水-银行间-CPYHJ
			 * 产品净值-CPJZ
			 * O32头寸检查表1-O32TCJC1
			 * 银行间回购明细表-YHJHGDetail
			 * 自动化头寸表-ZDHTCB
			 * 自动化头寸明细表-ZDHTCBDetail
			 * 估值系统估值表-HSFAGZB
			 * 组合持仓(产品持仓明细)扩展信息-ZHCCExtend
			 * 万得BBQ行情展示-WindBbqHq
			 * 科目余额表-HSKMYEB
			 * 头寸管理-定期存款到期浏览表-DQCKDQYLB
			 * 产品头寸风险测算-CPTCFXCSB
			 * 当日T+0头寸差额-银行间可用质押券明细-T0YHJ
			 * 现金流水记录信息-SGTZXJL
			 * 头寸管理信息-TCYCCX
			 * 头寸管理-头寸总和明细-FIRST_DETAIL_XJL
			 * 头寸管理-交易所、银行间、债券一级分销明细-SECOND_DETAIL_XJL
			 * 头寸管理-存款业务明细-THIRD_DETAIL_XJL
			 * 头寸管理-付息兑付业务明细-FOURTH_DETAIL_XJL
			 * 头寸管理-追加提取和期货保障金明细-FIFTH_DETAIL_XJL
			 * 综合报表-交易流水查询-交易所债券协议回购-BONDREPURCHASE
			 * 综合报表-交易流水查询-场外执行成交-OTCTRADE
			 * 投资管理-利率互换开仓-INTERESTSWAP
			 * 投资管理-利率互换冲销平仓-CHARGEAGAINST
			 * 投资管理-利率互换冲销统计-CHARGECOUNT
			 * 投资管理-利率互换出入金-DISCGOLD
			 */
			String queryType = paramObject.getString("queryType");//查询类型
			String busiDateEnd = paramObject.getString("busiDateEnd");//业务日期
			String sheetName = StrUtil.changeNull(paramObject.getString("sheetName"));//Excel文件Sheet名称
			String[] sheetHeadTitle = null;//Sheet列标题数组
			String[] columnKeyArr = null;//获取字段值关键key数组
			Object[] changeObjArr = null;//值转换格式对象数组
			HashMap<String, Object> map = new HashMap<String, Object>(); //传活跃数据
			
			if("CPXX".equalsIgnoreCase(queryType)){
				
			}else if("ZJTC".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号", "日期", "基金代码", "基金名称", "资产单元", "T+0指令可用", "T+0交易可用", "T+1指令可用", "T+1交易可用", "不包含T+1变化的T+0可用", "交易保证金", "冻结金额", "期初现金余额", "日初T日可用金额", "日初T+1日可用金额", "期货保证金余额" ,"银行间入款未交收金额" ,"沪港通交易端可用金额","沪港通投资端可用金额","深港通交易端可用金额"," 深港通投资端可用金额"};
				columnKeyArr = new String[]{"L_DATE", "VC_FUND_CODE", "VC_FUND_NAME", "VC_ASSET_NAME", "T0ZLKY", "T0JYKY", "T1ZLKY", "T1JYKY", "T0ZLKY2", "EN_BASIC_FROZEN_BALANCE", "EN_FROZEN_BALANCE", "EN_BEGIN_CASH", "EN_BEGIN_T0_ENABLE", "EN_BEGIN_T1_ENABLE", "EN_FUTURES_BALANCE","EN_SETTLE_BALANCE","EN_BALANCE_HGT","EN_BALANCE_INSTR_HGT","EN_BALANCE_SGT","EN_BALANCE_INSTR_SGT"};
				changeObjArr = new Object[]{null, null, null, null, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1};
				
			}else if("ZYQ".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号", "日期", "基金序号", "基金代码", "基金名称", "组合名称", "股东代码", "证券代码", "证券名称", "可质押数量", "已质押数量", "持仓", "抵押比率（%）", "已转标准券数量", "可转标准券数量"};
				columnKeyArr = new String[]{"L_DATE", "L_FUND_ID", "VC_FUND_CODE", "VC_FUND_NAME", "VC_COMBI_NAME", "VC_STOCKHOLDER_ID", "VC_REPORT_CODE", "VC_STOCK_NAME", "L_ENABLE_AMOUNT", "L_IMPAWN_AMOUNT", "L_AMOUNT", "L_RATIO", "L_IMPAWNSTD_AMOUNT", "L_ENABLESTD_AMOUNT"};
				changeObjArr = new Object[]{null, null, null, null, null, null, null, null, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1};
				
			}else if("BZQ".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号", "基金序号", "基金代码", "基金名称", "组合名称","交易市场", "证券代码", "证券名称", "库存数量", "可用数量"};
				columnKeyArr = new String[]{"L_FUND_ID", "VC_FUND_CODE", "VC_FUND_NAME","VC_SSET_NAME", "C_MARKET_NO", "VC_REPORT_CODE", "VC_STOCK_NAME", "L_AMOUNT", "L_AVL_AMOUNT"};
				changeObjArr = new Object[]{null, null, null, null,null, null, null, StrUtil.df1, StrUtil.df1};
				
			}else if("JYSHG".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号", "回购日期", "基金ID", "基金代码", "基金名称", "组合名称", "回购代码", "委托方向", "数量", "净资金额", "平均利率(%)", "利润", "实际购回日期", "购回交割日期", "实际占款天数"};
				columnKeyArr = new String[]{"L_HG_DATE", "L_FUND_ID", "VC_FUND_CODE", "VC_FUND_NAME", "VC_COMBI_NAME", "VC_REPORT_CODE", "VC_ENTRUSTDIR_NAME", "L_DEAL_AMOUNT", "EN_NET_ZJ", "EN_INTEREST_RATE", "EN_PROFIT", "L_REDEEM_LIQUIDATE", "L_SETTLE_DATE", "L_USE_DAYS"};
				changeObjArr = new Object[]{null, null, null, null, null, null, null, StrUtil.df1, StrUtil.df1, StrUtil.df5, StrUtil.df1, null, null, null};
				
			}else if("YHJHG".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号", "回购日期", "流水号", "基金序号", "基金代码", "基金名称", "组合名称", "回购代码", "委托方向", "数量", "净资金额", "返回金额", "交易对手", "平均利率(%)", "利润", "法定购回日期", "实际购回日期", "购回交割日期", "证券类别", "实际回购代码", "托管机构"};
				columnKeyArr = new String[]{"L_HG_DATE", "L_SERIAL_NO", "L_FUND_ID", "VC_FUND_CODE", "VC_FUND_NAME", "VC_COMBI_NAME", "VC_REPORT_CODE", "VC_ENTRUSTDIR_NAME", "L_DEAL_AMOUNT", "EN_NET_ZJ", "EN_RET_ZJ", "VC_RIVAL_NAME", "EN_INTEREST_RATE", "EN_PROFIT", "L_REDEEM_LAWDATE", "L_REDEEM_LIQUIDATE", "L_SETTLE_DATE", "C_STOCK_TYPE", "VC_REAL_CODE", "C_TRUSTEE"};
				changeObjArr = new Object[]{null, null, null, null, null, null, null, null, StrUtil.df1, StrUtil.df1, StrUtil.df1, null, StrUtil.df4, StrUtil.df1, null, null, null, null, null, null};
				
			}else if("YHJHG_DC".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号", "回购日期", "流水号", "基金序号", "基金代码", "基金名称", "组合名称", "回购代码", "委托方向", "数量", "净资金额", "返回金额", "交易对手", "平均利率(%)", "利润", "法定购回日期", "实际购回日期", "购回交割日期", "证券类别", "实际回购代码", "托管机构","日期","证券代码","证券名称","质押比例","质押数量","投资类型"};
				columnKeyArr = new String[]{"L_HG_DATE", "L_SERIAL_NO", "L_FUND_ID", "VC_FUND_CODE", "VC_FUND_NAME", "VC_COMBI_NAME", "VC_REPORT_CODE", "VC_ENTRUSTDIR_NAME", "L_DEAL_AMOUNT", "EN_NET_ZJ", "EN_RET_ZJ", "VC_RIVAL_NAME", "EN_INTEREST_RATE", "EN_PROFIT", "L_REDEEM_LAWDATE", "L_REDEEM_LIQUIDATE", "L_SETTLE_DATE", "C_STOCK_TYPE", "VC_REAL_CODE", "C_TRUSTEE","L_DATE","VC_ZQ_CODE","VC_STOCK_NAME","EN_RATIO","L_MORTAGAGE_AMOUNT","C_INVEST_TYPE"};
				changeObjArr = new Object[]{null, null, null, null, null, null, null, null, StrUtil.df1, StrUtil.df1, StrUtil.df1, null, StrUtil.df4, StrUtil.df1, null, null, null, null, null, null,null, null, null, StrUtil.df1, StrUtil.df1, null};
				
			}else if("ZHCC".equalsIgnoreCase(queryType) || "ZHCCExtend".equalsIgnoreCase(queryType)){
				if(sheetName.contains("银行间质押券")){
					sheetHeadTitle = new String[]{"序号", "日期", "基金代码", "基金名称", "组合名称", "证券代码", "证券名称", "交易市场", "持仓", "可用数量", "外部评级", "发行人外部评级", "全价", "净价"};
					columnKeyArr = new String[]{"L_DATE", "VC_FUND_CODE", "VC_FUND_NAME", "VC_COMBI_NAME", "VC_REPORT_CODE", "VC_STOCK_NAME", "VC_MARKET_NAME", "L_CURRENT_AMOUNT", "L_USABLE_AMOUNT", "C_OUTER_APPRAISE", "C_ISSUER_OUTER_APPRAISE", "EN_QJ", "EN_JJ"};
					changeObjArr = new Object[]{null, null, null, null, null, null, null, StrUtil.df1, StrUtil.df1, null, null, StrUtil.df4, StrUtil.df4};
					
				}else{
					sheetHeadTitle = new String[]{"序号", "日期", "基金代码", "基金名称", "基金编号", "组合名称", "组合编号", "股东代码", "证券代码", "证券名称", "交易市场", "持仓","持仓多空标志","可用数量", "冻结数量", "最新价", "全价", "净价", "成本价", "全价成本", "市值", "全价市值", "盈亏率(%)", "总体盈亏", "全价浮盈", "市值比净值(%)", "外部评级", "发行人外部评级", "债券摘牌日", "债券兑付日", "成交价", "卖出收益价", "买入收益价"};
					columnKeyArr = new String[]{"L_DATE", "VC_FUND_CODE", "VC_FUND_NAME", "L_FUND_ID", "VC_COMBI_NAME", "VC_COMBI_NO", "VC_STOCKHOLDER_ID", "VC_REPORT_CODE", "VC_STOCK_NAME", "VC_MARKET_NAME", "L_CURRENT_AMOUNT","C_POSITION_FLAG", "L_USABLE_AMOUNT", "L_FROZEN_AMOUNT", "EN_LAST_PRICE", "EN_QJ", "EN_JJ", "EN_BEGIN_COST_PRICE", "D_QJCB", "EN_VALUE_CURRENCY", "D_QJSZ", "EN_FLOAT_RATE", "EN_TOTAL_PROFIT", "D_QJFY", "EN_CURRENCY_FUND", "C_OUTER_APPRAISE", "C_ISSUER_OUTER_APPRAISE", "ZPR", "DQR", "RT_YIELD", "RT_ASKYIELD", "RT_BIDYIELD"};
					changeObjArr = new Object[]{null, null, null, null, null, null, null, null, null, null, StrUtil.df1,null,null,StrUtil.df1,StrUtil.df1, null, StrUtil.df4, StrUtil.df4, StrUtil.df4, StrUtil.df1, null, null, null, StrUtil.df1, null, null, null, null, null, StrUtil.df1, null, null};
				}
			}else if("O32TCJC1".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{};
				columnKeyArr = new String[]{};
				changeObjArr = new Object[]{};
				
			}else if("YHJHGDetail".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号", "日期", "证券代码", "证券名称", "抵押比例（%）", "质押数量", "基金编号", "组合序号", "基金名称", "组合名称", "投资类型"};
				columnKeyArr = new String[]{"L_DATE", "VC_REPORT_CODE", "VC_STOCK_NAME", "EN_RATIO", "L_MORTAGAGE_AMOUNT", "L_FUND_ID", "L_BASECOMBI_ID", "VC_FUND_NAME", "VC_COMBI_NAME", "C_INVEST_TYPE"};
				changeObjArr = new Object[]{null, null, null, StrUtil.df1, StrUtil.df1, null, null, null, null, null};
			
			}else if("HSFAGZB".equalsIgnoreCase(queryType)){
				HSSFPalette palette = workbook.getCustomPalette();
				palette.setColorAtIndex(HSSFColor.RED.index, (byte) 255, (byte) 255, (byte) 153);
				sheetHeadFormat.setFillForegroundColor(HSSFColor.RED.index);
				sheetHeadFormat.setFillPattern(CellStyle.SOLID_FOREGROUND);
				BoldUnderlineLEFT.setWrapText(false);// 自动换行
				
				map.put("sheetName", sheetName);
				map.put("queryType", queryType);
				map.put("busiDateEnd", busiDateEnd);
				sheetHeadTitle = new String[]{"序号", "科目代码", "科目名称", "数量", "单位成本", "成本", "成本占净值(%)", "市价", "市值", "市值占净值（%）", "估值增值", "停牌信息"};
				columnKeyArr = new String[]{"VC_KMDM", "VC_KMMC", "L_SL", "EN_DWCB", "EN_CB", "EN_CBZJZ", "EN_HQJZ", "EN_SZ", "EN_SZZJZ", "EN_GZZZ", "VC_TPXX"};
				changeObjArr = new Object[]{null, null, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, null};
				
				//判断是否需要特殊处理
				boolean isHandle = isHandle(paramObject.getString("vCFundCode"));
				if(isHandle){
					map.put("sheetName", "证券投资基金估值表");//大标题
					map.put("sheetName1", "创金合信_" + paramObject.getString("sheetName") + "_专用表");//小标题
				}
				
				map.put("isHandle", isHandle);//是否处理
				
			}else if("ZDHTCB".equalsIgnoreCase(queryType)){
				
				sheetHeadTitle = new String[]{"序号", "基金ID", "基金代码", "基金名称", "序号", "备注", "D 期初余额", "AK 余额", "净追加等手工调整(流入为正,流出为负)", "手工调整备注", "F 银行间正回购,首次结算日为当日,金额为正", "G 银行间逆回购,首次结算日为当日,金额为负", "H T日成交的T+0银行间买券,结算日为当日,金额为负", "I T日成交的T+0银行间卖券,结算日为当日,金额为正", "J 银行间正回购到期,到期结算日为当日,金额为负", "K 银行间逆回购到期,到期结算日为当日,金额为正", "L T-1日成交的T+1交收的银行间买券,结算日为当日,金额为负", "M T-1日成交的T+1交收的银行间卖券,结算日为当日,金额为正", "N 银行间分销,金额为负", "O 交易所分销,金额为负", "P 基金申购,金额为负", "Q 基金赎回,赎回到账日为当日,金额为正", "R 红利到账,金额为正", "S 期货户入金,期货保证金调整的期货保证金增加,金额为负", "T 期货户出金,期货保证金调整的期货保证金减少,金额为正", "U 同业存款,即定期存款,金额为负", "V 同业存款到期,即定期存款到期,到期日为当日,金额为正", "W 当日债券兑付/付息/部分兑付/部分提前兑付(沪深),金额为正", "X 当日债券兑付/付息/部分兑付/部分提前兑付(非沪深),金额为正", "Y 追加,即当日资金管理手工增加资金,金额为正", "Z 提取,即当日资金管理手工减少资金,金额为负", "AA 当日TA申购,金额为正", "AB TA赎回,赎回款到账日为当日,金额为负", "AC 网下申购,金额为负", "AD 网下申购退款,金额为正", "AL 费用支付，金额为负", "AM 新股配售交收，金额为负", "AE RTGS非担保卖券,清算速度T+0,金额为正", "AF RTGS非担保买券,清算速度T+0,金额为负", "AG 调款", "AN 资金冻结，金额为正", "AO 资金冻结取消,金额为正", "AP 资金增加,金额为正"};
				columnKeyArr = new String[]{"L_FUND_ID", "VC_FUND_CODE", "VC_FUND_NAME", "XH", "BZ", "D_COL", "AK_COL", "EN_BALANCE", "SGTZ_BZ", "F_COL", "G_COL", "H_COL", "I_COL", "J_COL", "K_COL", "L_COL", "M_COL", "N_COL", "O_COL", "P_COL", "Q_COL", "R_COL", "S_COL", "T_COL", "U_COL", "V_COL", "W_COL", "X_COL", "Y_COL", "Z_COL", "AA_COL", "AB_COL", "AC_COL", "AD_COL", "AL_COL", "AM_COL", "AE_COL", "AF_COL", "AG_COL", "AN_COL", "AO_COL", "AP_COL"};
				changeObjArr = new Object[]{null, null, null, null, null, StrUtil.df1, StrUtil.df1, StrUtil.df1, null, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1};
			}else if("ZDHTCBNew".equalsIgnoreCase(queryType)){
				
				sheetHeadTitle = new String[]{"序号", "基金ID", "基金代码", "基金名称", "序号", "备注", "D 期初余额", "AK 余额", "净追加等手工调整(流入为正,流出为负)", "手工调整备注", "F 银行间正回购,首次结算日为当日,金额为正", "G 银行间逆回购,首次结算日为当日,金额为负", "H T日成交的T+0银行间买券,结算日为当日,金额为负", "I T日成交的T+0银行间卖券,结算日为当日,金额为正", "J 银行间正回购到期,到期结算日为当日,金额为负", "K 银行间逆回购到期,到期结算日为当日,金额为正", "L T-1日成交的T+1交收的银行间买券,结算日为当日,金额为负", "M T-1日成交的T+1交收的银行间卖券,结算日为当日,金额为正", "N 银行间分销,金额为负", "O 交易所分销,金额为负", "P 基金申购,金额为负", "Q 基金赎回,赎回到账日为当日,金额为正", "R 红利到账,金额为正", "S 期货户入金,期货保证金调整的期货保证金增加,金额为负", "T 期货户出金,期货保证金调整的期货保证金减少,金额为正", "U 同业存款,即定期存款,金额为负", "V 同业存款到期,即定期存款到期,到期日为当日,金额为正", "W 当日债券兑付/付息/部分兑付/部分提前兑付(沪深),金额为正", "X 当日债券兑付/付息/部分兑付/部分提前兑付(非沪深),金额为正", "Y 追加,即当日资金管理手工增加资金,金额为正", "Z 提取,即当日资金管理手工减少资金,金额为负", "AA 当日TA申购,金额为正", "AB TA赎回,赎回款到账日为当日,金额为负", "AC 网下申购,金额为负", "AD 网下申购退款,金额为正", "AL 费用支付，金额为负", "AM 新股配售交收，金额为负", "AE RTGS非担保卖券,清算速度T+0,金额为正", "AF RTGS非担保买券,清算速度T+0,金额为负", "AG 调款", "AN 资金冻结，金额为正", "AO 资金冻结取消,金额为正", "AP 资金增加,金额为正"};
				columnKeyArr = new String[]{"L_FUND_ID", "VC_FUND_CODE", "VC_FUND_NAME", "XH", "BZ", "D_COL", "AK_COL", "EN_BALANCE", "SGTZ_BZ", "F_COL", "G_COL", "H_COL", "I_COL", "J_COL", "K_COL", "L_COL", "M_COL", "N_COL", "O_COL", "P_COL", "Q_COL", "R_COL", "S_COL", "T_COL", "U_COL", "V_COL", "W_COL", "X_COL", "Y_COL", "Z_COL", "AA_COL", "AB_COL", "AC_COL", "AD_COL", "AL_COL", "AM_COL", "AE_COL", "AF_COL", "AG_COL", "AN_COL", "AO_COL", "AP_COL"};
				changeObjArr = new Object[]{null, null, null, null, null, StrUtil.df1, StrUtil.df1, StrUtil.df1, null, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1};
			}else if("HSKMYEB".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号", "科目代码", "科目名称", "产品代码", "产品名称", "产品全称", "账套编号", "日期", "年初余额", "期初余额", "本期借方发生（当日）", "本期贷方发生（当日）","累计借方发生","累计贷方发生","期末余额","来源系统","写入时间"};
				columnKeyArr = new String[]{"VC_KMDM", "VC_KMMC", "CPDM", "CPMC", "CPQC", "L_FUNDID", "L_DATE", "NCYE", "QCYE", "BQJFFSE", "BQDFFSE","LJJFFSE","LJDFFSE","QMYE","SRCSYS","INSERTTIME"};
				changeObjArr = new Object[]{null, null, null, null, null, null, null, null, StrUtil.df1, StrUtil.df1, StrUtil.df1,StrUtil.df1,StrUtil.df1,StrUtil.df1,null,null};
				
			}else if("CPJYS".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号", "业务日期", "基金代码", "基金名称", "证券代码", "证券名称", "委托方向", "市场成交均价", "成交数量", "成交金额", "成交均价", "成交均价(全价)", "交易市场", "业务类型"};
				columnKeyArr = new String[]{"L_DATE", "VC_FUND_CODE", "VC_FUND_NAME", "VC_REPORT_CODE", "VC_STOCK_NAME", "VC_ENTRUSTDIR_NAME", "EN_AVG_PRICE", "L_DEAL_AMOUNT", "EN_DEAL_BALANCE", "EN_AVG_DEALPRICE", "EN_AVG_DEALPRICE_FULL", "VC_MARKET_NAME", "C_BUSIN_CLASS_NAME"};
				changeObjArr = new Object[]{null, null, null, null, null, null, StrUtil.df4, StrUtil.df1, StrUtil.df1, StrUtil.df4, StrUtil.df4, null, null};
			}
			else if("CPYHJ".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号", "日期", "成交编号", "基金代码", "基金名称", "证券代码", "证券名称", "委托方向", "回购利率(%)", "成交数量", "成交金额", "到期清算金额", "回购天数", "实际占款天数", "清算速度", "首次交割日", "到期交割日", "交易对手", "净价价格", "全价价格", "到期收益率(%)", "托管机构", "成交时间"};
				columnKeyArr = new String[]{"L_DATE", "VC_DEAL_NO", "VC_FUND_CODE", "VC_FUND_NAME", "VC_REPORT_CODE", "VC_STOCK_NAME", "VC_ENTRUSTDIR_NAME", "EN_RATE", "L_DEAL_AMOUNT", "EN_FIRST_CLEAR_BALANCE", "EN_SECOND_CLEAR_BALANCE", "L_HG_DAYS", "L_USE_DAYS", "L_SETTLE_SPEED", "L_FIRST_SETTLE_DATE", "L_SECOND_SETTLE_DATE", "L_TRADE_RIVAL_NO", "EN_FIRST_NET_PRICE", "EN_FIRST_FULL_PRICE", "EN_SECOND_MATURE_YIELD", "C_TRUSTEE", "L_TIME"};
				changeObjArr = new Object[]{null, null, null, null, null, null, null, StrUtil.df4, null, StrUtil.df1, StrUtil.df1, null, null, null, null, null, null, StrUtil.df4, StrUtil.df4, StrUtil.df4, null, null};
			}
			else if("CPJZ".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号", "统计日期", "基金名称", "净值", "单位净值", "累计单位净值","总资产"};
				columnKeyArr = new String[]{"L_DATE", "VC_FUND_NAME", "EN_FUND_VALUE", "EN_NAV", "EN_TOTAL_NAV","EN_TOTAL_ZC"};
				changeObjArr = new Object[]{null, null, StrUtil.df1, StrUtil.df4, StrUtil.df4,StrUtil.df1};
			}
			else if("BZJ".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","日期","基金代码","基金名称"," 资产单元名称","结算参与人代码","预测保证金","月初存出保证金","预测需调整金额","下月需冻结保证金","预测备付金加保证金金额","基金序号"," 资产单元序号"};
				columnKeyArr = new String[]{"L_DATE","VC_FUND_CODE","VC_FUND_NAME","VC_ASSET_NAME","VC_SEQUARE_CODE","CURRENT_BZJ","MONTH_BEGIN_BZJ","MARGIN_BZJ","PREDICT_BZJ",null,"L_FUND_ID","L_DEFAULT_ASSET"};
				changeObjArr = new Object[]{null, null, null, null, null,null, null, null, null,null,null,null};
			}
			else if("BFJ".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","日期","基金代码","基金名称","资产单元名称","业务类型","成交金额","预测备付金","月初存出备付金","预测调整金额","月初需冻结金额","是否分组估值","是否分资产单元","基金序号","资产单元序号"};
				columnKeyArr = new String[]{"L_DATE","VC_FUND_CODE","VC_FUND_NAME","VC_ASSET_NAME","VC_BUSIN_FLAG","EN_DEAL_BALANCE","EN_BFJ_LASTDAY","EN_BFJ_LASTMON","EN_BFJ_GAP","EN_BFJ_PREDICT","C_GROUP_FLAG","ASSET_FLAG","L_FUND_ID","L_ASSET_ID"};
				changeObjArr = new Object[]{null, null, null, null, null,null, null, null, null, null,null, null,null,null};
			}else if("CPTCFXCSB".equals(queryType)){
				sheetHeadTitle = new String[]{"序号","基金代码","基金名称","基金净资产","基金总资产","融资回购占净资产比例(%)","融资回购占净资产比例_未到期(%)","财务杠杆率(%)","交易所担保交收头寸覆盖率(%)","交易所担保交收头寸覆盖率_全部(%)","交易所非担保交收头寸覆盖率(%)","银行间头寸覆盖率(%)","银行间头寸覆盖率_质押券(%)","银行间T+0可变现覆盖率","T+0可变现覆盖率","交易所正回购到期余额","交易所逆回购到期余额","交易所正回购未到期余额","交易所协议正回购到期余额","交易所协议逆回购到期余额","交易所协议正回购未到期余额","银行间正回购到期余额","银行间逆回购到期余额","银行间正回购未到期余额","存款到期兑付金额","基金赎回款","昨日T+1银行间卖券金额","T+0可变现金额","T+0可变现金额_上海固收平台","T+0可变现金额_深圳协议平台","T+0可变现金额_银行间市场","T+0可变现金额_银行间市场_中债","T+0可变现金额_银行间市场_上清","T+1可变现金额","T+1可变现金额_标准券可用金额","T+1可变现金额_可质押入库数量","T+1可变现金额_可质押入库金额","委托人","上层资金来源","上层资金概率","上层资金额度","手工调整备注"};
				columnKeyArr = new String[]{"VC_FUND_CODE","VC_FUND_NAME","AK_COL","AL_COL","D_COL", "E_COL", "F_COL", "G_COL", "H_COL", "I_COL", "J_COL", "K_COL", "L_COL", "TL_COL", "M_COL", "N_COL", "AM_COL", "O_COL", "P_COL", "AN_COL", "Q_COL", "R_COL", "AO_COL", "S_COL", "T_COL", "U_COL", "V_COL", "W_COL", "X_COL", "Y_COL", "Z_COL", "AA_COL", "AB_COL", "AC_COL", "AD_COL","AE_COL","AF_COL","AG_COL","AH_COL","AI_COL","AJ_COL"};
				changeObjArr = new Object[]{null, null, null, null, null,null, null, null, null, null,null,null, null,null,null,null, null, null, null, null,null, null, null, null, null,null, null,null,null,null,null,null,null,null,null,null,null,null,null,null,null};
			}else if("T0YHJ".equals(queryType)){
				sheetHeadTitle = new String[]{"序号","基金代码","基金名称","债券代码","债券名称","托管机构","债项评级","主体评级","可用数量(元)","企业性质","Wind一级债券类型","Wind二级债券类型"};
				columnKeyArr = new String[]{"VC_FUND_CODE","VC_FUND_NAME","VC_REPORT_CODE","VC_STOCK_NAME","TRUSTEESHIP","C_BOND_RATING", "C_SUBJECT_RATING", "L_SALE_AMOUNT", "C_ISSUER_TYPE", "VC_BOND_TYPE_WIND_FIRST","VC_BOND_TYPE_WIND_SECOND"};
				changeObjArr = new Object[]{null, null, null, null, null,null, null,StrUtil.df1,null,null,null};
			}else if("T0JYS".equals(queryType)){
					sheetHeadTitle = new String[]{"序号","基金代码","基金名称","债券代码","债券名称","交易市场","债项评级","主体评级","可用数量(元)","企业性质","Wind一级债券类型","Wind二级债券类型"};
					columnKeyArr = new String[]{"VC_FUND_CODE","VC_FUND_NAME","VC_REPORT_CODE","VC_STOCK_NAME","VC_MARKET_NO","C_BOND_RATING", "C_SUBJECT_RATING", "L_SALE_AMOUNT", "C_ISSUER_TYPE", "VC_BOND_TYPE_WIND_FIRST","VC_BOND_TYPE_WIND_SECOND"};
					changeObjArr = new Object[]{null, null, null, null, null,null, null,StrUtil.df1,null,null,null};
			}else if("T1JYSKY".equals(queryType)){
				sheetHeadTitle = new String[]{"序号","基金代码","基金名称","交易市场","T+0可用数量","T+1可用数量"};
				columnKeyArr = new String[]{"VC_FUND_CODE","VC_FUND_NAME","VC_MARKET_NO","L_ENABLE_AMOUNT","L_ENABLE_AMOUNT_NEXT"};
				changeObjArr = new Object[]{null, null, null, StrUtil.df1, StrUtil.df1};
			}else if("T1KTJZYQ".equals(queryType)){
				sheetHeadTitle = new String[]{"序号","基金代码","基金名称","债券代码","债券名称","交易市场","数量","折算T+0标准券数量","折算T+1标准券数量"};
				columnKeyArr = new String[]{"VC_FUND_CODE","VC_FUND_NAME","VC_REPORT_CODE","VC_STOCK_NAME","VC_MARKET_NO","L_PLEDGE_AMOUNT", "L_CONVERTED_STANDARD_AMOUNT", "L_CONVERTED_STANDARD_AMOUNT_NEXT"};
				changeObjArr = new Object[]{null, null, null, null, null,StrUtil.df1,StrUtil.df1,StrUtil.df1};
			}else if("T1JYSDB".equals(queryType)){
				sheetHeadTitle = new String[]{"序号","基金代码","基金名称","债券代码","债券名称","交易市场","可用数量","债项评级","主体评级","Wind一级债券类型","Wind二级债券类型"};
				columnKeyArr = new String[]{"VC_FUND_CODE","VC_FUND_NAME","VC_REPORT_CODE","VC_STOCK_NAME","VC_MARKET_NO","L_SALE_AMOUNT","C_BOND_RATING","C_SUBJECT_RATING","VC_BOND_TYPE_WIND_FIRST","VC_BOND_TYPE_WIND_SECOND"};
				changeObjArr = new Object[]{null, null, null, null, null,StrUtil.df1, null,null,null,null};
			}else if("DQCKDQYLB".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","基金代码","基金名称","资产类别","对手方","证券代码","证券简称","存单金额(元)","存款期限(天)","起息日","到期日","到期本息兑付日","利率(%)","提前支取限制", "协议存款/存单状态"};
				columnKeyArr = new String[]{"VC_FUND_CODE","VC_FUND_NAME","C_ASSET_CLASS","VC_BANK_NAME","VC_REPORT_CODE","VC_STOCK_NAME","EN_BALANCE","L_LIMIT_TIME","L_BEGIN_DATE","L_END_DATE","L_PAYMENT_DATE","EN_RATE","C_ADVANCE_LIMIT_FLAG","DEPOSITRECEIPT_STATUS"};
				changeObjArr = new Object[]{null, null, null, null, null, null, StrUtil.df1, StrUtil.df2, null, null, null, null, null, null};
			}else if("SGTZXJL".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","资金变动日期","产品名称","单元名称","调整金额","调整说明","调整人","调整时间"};
				columnKeyArr = new String[]{"lDate","vcProductName","vcAssetName","enAdjustAmount","vcAdjustRemark","vcAdjusterName","dAdjustTime"};
				changeObjArr = new Object[]{null, null, null, StrUtil.df1, null, null, null};
			}else if("TCYCCX".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","日期","产品编号","产品代码","产品名称","单元编号","单元名称","期初现金","净流入金额","T+0头寸-投资端","T+1头寸-投资端","T+1头寸-交易端","风险备付金","结算备付金",
						"交易所担保净流入","交易所非担保净流入","证券买入(非债券)","证券卖出(非债券)","债券买入(担保)","债券卖出(担保)","债券买入(非担保)","债券卖出(非担保)","场内正回购首期","场内正回购到期","场内逆回购首期","场内逆回购到期","协议正回购首期","协议正回购到期","协议逆回购首期","协议逆回购到期",
						"银行间中债登净流入","银行间上清所净流入","债券买入","债券卖出","正回购首期","正回购到期","逆回购首期","逆回购到期",
						"存款存入","存款到期","场外开基申购","场外开基赎回",
						"新债分销买入","交易所债券兑付息","银行间债券兑付息","债券兑付息","追加","提取","净追加","沪港通证券买入",
						"沪港通证券卖出","沪港通风控资金","深港通证券买入","深港通证券卖出","深港通风控资金","TA申购","TA赎回","TA分红",
						"增值税","期货保证金调整","其他业务","手工调整金额"};
				
				columnKeyArr = new String[]{"lDate","lFundId","vcFundCode","vcFundName","lAssetId","vcAssetName","beginCash","netInflowBal","t0CashEnableBalInvest","t1CashEnableBalInvest","t1CashEnableBalTrade","riskSettleMargin","settleReserveBal",
						"netStlGuarBal","netStlNonGuarBal","stockBuyBal","stockSaleBal","bondBuyBalGuar","bondSaleBalGuar","bondBuyBalNonGuar","bondSaleBalNonGuar","rzhgBal","rzhgExpireBal","rqhgBal","rqhgExpireBal","rzhgPactBal","rzhgExpireBalPact","rqhgBalPact","rqhgExpireBalPact",
						"netStlBalCibmZzd","netStlBalCibmSqs","bondBuyBalCibm","bondSaleBalCibm","rzhgBalCibm","rzhgExpireBalCibm","rqhgBalCibm","rqhgExpireBalCibm",
						"depositBal","depositExpireBal","applyFundBal","redeemFundBal",
						"distributeBuyBal","bondDxDfBalCsi","bondDxDfBalCibm","bondDxDfBal","appendBal","extractBal",
						"appendExtractBal","stockBuyBalHgt","stockSaleBalHgt","riskBalHgt","stockBuyBalSgt",
						"stockSaleBalSgt","riskBalSgt","applyTaBal","redeemTaBal","dividendTaBal","vatBal","futuresMarginBal",
						"otherBal","manualAdjustBal"};
				
				changeObjArr = new Object[]{null, null, null, null, null, null, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, 
											StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1,   
											StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1, StrUtil.df1};
			}else if("SECOND_DETAIL_XJL".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","产品名称","单元名称","交易场所","委托方向","交易平台","证券代码","证券名称","发生金额","指令状态","交易日期","交割日期"};
				columnKeyArr = new String[]{"fundName","assetName","marketNo","entrustDirection","businClass","stockCode","stockName","occurBal","dataSource","tradeDate","settleDate"};
				changeObjArr = new Object[]{null, null,null, null, null, null, null,StrUtil.df1, null,null,null};
			}else if("FIRST_DETAIL_XJL".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","产品名称","单元名称","交易市场","委托方向","证券代码","证券名称","交易金额(元)","指令状态","业务类型","交割日期"};
				columnKeyArr = new String[]{"fundName","assetName","marketNo","entrustDirection","stockCode","stockName","settleBalance","dataSource","businTypeName","settleDate"};
				changeObjArr = new Object[]{null, null, null, null, null, null,StrUtil.df1, null,null,null};
			}else if("THIRD_DETAIL_XJL".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","产品名称","单元名称","业务类型","存款金额(元)","存款利率","存款到期交割金额(元)","指令状态","起息日期","到息日期"};
				columnKeyArr = new String[]{"fundName","assetName","businTypeName","dpstBalance","dpstRatio","dpstStlBal","dataSource","beginDate","endDate"};
				changeObjArr = new Object[]{null, null, null, StrUtil.df1, null,  StrUtil.df1,null, null, null};
			}else if("FOURTH_DETAIL_XJL".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","产品名称","单元名称","交易市场","交易平台","证券代码","证券名称","发生金额(元)","指令状态","交易日期","交割日期"};
				columnKeyArr = new String[]{"fundName","assetName","marketNo","businClass","stockCode","stockName","occurBal","dataSource","tradeDate","settleDate"};
				changeObjArr = new Object[]{null, null, null, null, null, null, StrUtil.df1,null,null,null};
			}else if("FIFTH_DETAIL_XJL".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","产品名称","单元名称","交易平台","发生金额(元)","指令状态","交割日期"};
				columnKeyArr = new String[]{"fundName","assetName","businFlag","occurBal","dataSource","settleDate"};
				changeObjArr = new Object[]{null, null, null,StrUtil.df1, null,null};
			}else if("SIXTH_DETAIL_XJL".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","产品名称","单元名称","托管机构","委托方向","证券代码","证券名称","发生金额","交易对手","指令状态","交易日期","交割日期"};
				columnKeyArr = new String[]{"fundName","assetName","trusteeShip","entrustDirection","stockCode","stockName","occurBal","tradeRivalName","dataSource","tradeDate","settleDate"};
				changeObjArr = new Object[]{null, null,null, null, null, null, null,StrUtil.df1, null,null,null,null};
			}else if("SEVENTH_DETAIL_XJL".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","产品名称","单元名称","交易场所","交易平台","委托方向","证券代码","证券名称","发生金额","指令状态","交易日期","交割日期"};
				columnKeyArr = new String[]{"fundName","assetName","marketNo","businClass","entrustDirection","stockCode","stockName","occurBal","dataSource","tradeDate","settleDate"};
				changeObjArr = new Object[]{null,null, null, null, null, null, null,StrUtil.df1,null,null,null};
			}else if("EIGHTH_DETAIL_XJL".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","产品名称","单元名称","交易场所","委托方向","证券代码","证券名称","发生金额","交易对手","指令状态","交易日期","交割日期"};
				columnKeyArr = new String[]{"fundName","assetName","marketNo","entrustDirection","stockCode","stockName","occurBal","tradeRivalName","dataSource","tradeDate","settleDate"};
				changeObjArr = new Object[]{null,null, null, null, null, null, StrUtil.df1,null,null,null,null};
			}else if("NINTH_DETAIL_XJL".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","产品名称","单元名称","交易场所","委托方向","证券名称","发生金额","指令状态","交易日期","交割日期"};
				columnKeyArr = new String[]{"fundName","assetName","marketNo","entrustDirection","stockName","occurBal","dataSource","tradeDate","settleDate"};
				changeObjArr = new Object[]{null,null, null, null, null, StrUtil.df1,null,null,null};
			}else if("O32TCJC1New".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{
						"序号",
						"基金序号",
						"基金代码",
						"基金名称",
						"资产单元序号",
						"资产单元名称",
						"头寸情况_交易所头寸情况（上交所）",
						"头寸情况_交易所头寸情况（深交所）",
						"头寸情况_T+0头寸情况 F",
						"头寸情况_T+1头寸情况 G",
						"银行间交易_当日T+0交易意向 H",
						"银行间交易_当日T+0前台成交 I",
						"银行间交易_昨日T+1资金流入 J",
						"银行间交易_当日逆回购到期  K",
						"银行间交易_当日债券兑付兑息 L",
						"银行间交易_次日正回购到期提前冻结 M",
						"交易所交易_指令占用(上海) O",
						"交易所交易_指令占用(深圳) O",
						"交易所交易_股票权证买卖(上海) P",
						"交易所交易_股票权证买卖(深圳) P",
						"交易所交易_债券买卖(上海) Q",
						"交易所交易_债券买卖(深圳) Q",
						"交易所交易_正回购首期(上海) R",
						"交易所交易_正回购首期(深圳) R",
						"交易所交易_正回购到期(上海) S",
						"交易所交易_正回购到期(深圳) S",
						"交易所交易_逆回购首期(上海) T",
						"交易所交易_逆回购首期(深圳) T",
						"交易所交易_逆回购到期(上海) U",
						"交易所交易_逆回购到期(深圳) U",
						"交易所交易_非担保交收(上海) V",
						"交易所交易_非担保交收(深圳) V",
						"线下交易_存款支取款 W",
						"线下交易_基金赎回款 X",
						"线下交易_网下申购退款 Y",
						"其他_备付金保证金提前冻结 Z",
						"其他_赎回分红款提前冻结 AA",
						"其他_费用提前冻结 AB",
						"其他_风险备付金 AC",
						"其他_资金手工解冻 AD",
						"其他_增值税与附加税",
						"其他_当日手工冻结",
						"或有事项_追加提取 AE",
						"或有事项_一级新债 AF",
						"或有事项_协议回购 AG",
						"O32系统头寸_T+0交易头寸 AH",
						"O32系统头寸_不包含T+1变化的T+0可用 AI",
						"O32系统头寸_T+1交易可用 AJ",
						"手工调整_手工调整金额(1-追加提取)",
						"手工调整_手工调整备注(1-追加提取)",
						"手工调整_手工调整金额(2-一级新债)",
						"手工调整_手工调整金额(2-一级新债)",
						"手工调整_手工调整备注(2-一级新债)",
						"手工调整_手工调整金额(3-协议回购)",
						"手工调整_手工调整备注(3-协议回购)",
						"分组名称",
						"持仓标签",
						"备注标签"
						};
				columnKeyArr = new String[]{
						"L_FUND_ID",
						"VC_FUNDCODE",
						"VC_FUNDNAME",
						"L_ASSET_ID",
						"VC_ASSETNAME",
						"JYSTC_SH",
						"JYSTC_SZ",
						"T0_BALANCE",
						"T1_BALANCE",
						"EN_YHJ_ZQ",
						"EN_YHJ_ZQ_T0CJ",
						"EN_YHJ_ZQ_T1CJ",
						"EN_YHJ_RQGH",
						"EN_YHJ_DXDF",
						"EN_YHJ_TQDJ",
						"EN_JYS_ZLZY1",
						"EN_JYS_ZLZY2",
						"EN_JYS_QZMM1",
						"EN_JYS_QZMM2",
						"EN_JYS_ZQMM1",
						"EN_JYS_ZQMM2",
						"EN_JYS_RZHG1",
						"EN_JYS_RZHG2",
						"EN_JYS_RZGH1",
						"EN_JYS_RZGH2",
						"EN_JYS_RQHG1",
						"EN_JYS_RQHG2",
						"EN_JYS_RQGH1",
						"EN_JYS_RQGH2",
						"EN_JYS_FDBJS1",
						"EN_JYS_FDBJS2",
						"EN_XX_CKZQK",
						"EN_WJS_JJSH",
						"EN_WJS_WXSG",
						"EN_BFJ_TQDJ",
						"EN_SH_TQDJ",
						"EN_FYTQDJ",
						"EN_ZJSGDJ",
						"EN_ZJJD",
						"EN_ZZS_TQDJT3",
						"EN_DRSGDJ",
						"EN_ZJTQ",
						"EN_YJXZ",
						"EN_XYHG",
						"T0_POS",
						"T0_POS2",
						"T1_POS",
						"en_balance1",
						"bz1",
						"en_balance2",
						"en_balance",
						"bz2",
						"en_balance3",
						"bz3",
						"vcGroup",
						"vcLabelPosition",
						"vcLabelRemarks"
						};
				changeObjArr = new Object[]{null, null, null, null, null, null, null, null, null,null,null, null, null, null, null, null, null, null,null,null, null, null, null, null, null, null, null,null,null,
						null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null};
			}
			else if("BONDREPURCHASE".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","基金名称","组合名称","委托方向","回购类型","质押券代码","质押券简称",
						"质押数量（手）","质押券面值总额","成交日期","法定购回日期","成交金额","折算率(%)","回购利率","回购天数",
						"实际回购到期日","实际占款天数","到期结算金额","首期结算日","到期结算日","摘牌日","下一付息日","本期结算利息",
						"对手方交易商简称","交易所","内部评级","外部评级","操作员"};
				columnKeyArr = new String[]{"VC_FUND_NAME","VC_COMBI_NAME","C_ENTRUST_DIRECTION","C_HG_TYPE",
						"VC_REPORT_CODE","VC_STOCK_NAME","L_DEAL_AMOUNT","EN_BALANCE","L_DATE","L_REDEEM_LAWDATE",
						"EN_FIRST_CLEAR_BALANCE","EN_CONVERT","EN_RATE","L_REDEEM_DAYS","L_REDEEM_LIQUIDATE",
						"L_USE_DAYS","EN_SECOND_CLEAR_BALANCE","L_FIRST_SETTLE_DATE","L_SECOND_SETTLE_DATE",
						"L_END_DATE","L_NEXTPAYMENT_DATE","EN_BOND_INTEREST","VC_NAME","C_MARKET_NO",
						"C_INSIDE_APPRAISE","C_OUTER_APPRAISE","L_OPERATOR_NO"};
				changeObjArr = new Object[]{null,null,null,null,null,null,StrUtil.df2,StrUtil.df1,null,null,StrUtil.df1,
						StrUtil.df1,StrUtil.df4,null,null,null,StrUtil.df1,null,null,null,null,StrUtil.df1,null,null,null,
						null,null};
			}
			else if("OTCTRADE".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","基金名称","组合名称","业务分类","证券代码","证券名称","委托方向","金额",
						"数量","到账日期","确认操作日期"};
				columnKeyArr = new String[]{"VC_FUND_NAME","VC_COMBI_NAME","C_BUSIN_CLASS","VC_REPORT_CODE",
						"VC_STOCK_NAME","VC_ENTRUSTDIR_NAME","EN_BALANCE","EN_AMOUNT","L_SETTLE_DATE","L_CONFIRM_DATE"};
				changeObjArr = new Object[]{null,null,null,null,null,null,StrUtil.df1,StrUtil.df4,null,null};
			}
			else if("INTERESTSWAP".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","产品名称" ,"组合名称","交易日期","业务方向","业务名称","名义本金（万元）","固定利率（%）","参考利率","期限","对手方","交易状态","录入时间","复核时间","确认时间","投资经理审批时间","前台录单时间","前台发送时间","前台成交时间","交易后平台确认时间","指令/建议序号","指令/建议来源","备注"};
				columnKeyArr = new String[]{"vcProductName","vcCombiName","lTradeDate","vcBusinType","vcBusinName","lNominalCapital","lFixedRate","vcReferRate","lLeftDays","vcCounterpartyName","cIsValid","tInputTime","tReviewTime","tClientTime","tInvestmanagerTime","tFsOperateTime","tFsReviewTime","tFsDealTime","tBsDealTime","lInstructNo","vcInstructSource","vcRemark"};
				changeObjArr = new Object[]{null,null,null,null,null,StrUtil.df2,StrUtil.df4,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null};
			}
			else if("CHARGEAGAINST".equalsIgnoreCase(queryType)){
				sheetHeadTitle = new String[]{"序号","产品名称","组合名称","名义本金（万元）","冲销类型","冲销金额（万元）","开仓指令/建议序号","累计冲销金额（万元）","可冲销金额（万元）","本次已冲销金额（万元）","冲销日期","参考利率","期限","对手方","交易状态","录入时间","复核时间","确认时间","交易员1确认时间","交易员2复核时间","投资经理审批时间","交易部审批时间","风控审批时间","综合部审批时间","冲销执行时间","冲销结果确认时间","冲销结果复核时间","资金清算时间","指令/建议序号","指令/建议来源","备注"};
				columnKeyArr = new String[]{"vcProductName","vcCombiName","openNominalCapital","vcChargeType","lChargeCapital","openInstructNo","lSpendCapital","lLeftCapital","lActuChargeCapital","lTradeDate","openvcReferRate","openlLeftDays","openvcCounterPartyName","cIsValid","tInputTime","tReviewTime","tClientTime","tTraderfTime","tTradesTime","tInvestmanagerTime","tTradedepTime","tRiskmanagerTime","tComdepTime","tChargeimplTime","tChargeconfirmTime","tChargereviewTime","tCapitalclearTime","lChargeNo","vcInstructSource","vcRemark"};
				changeObjArr = new Object[]{null,null,StrUtil.df2,null,StrUtil.df2,null,StrUtil.df2,StrUtil.df2,StrUtil.df2,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null};
			}
			else if("CHARGECOUNT".equalsIgnoreCase(queryType)){				
				sheetHeadTitle = new String[]{"序号","产品名称","组合名称","业务名称","业务类别","名义本金（万元）","开仓指令/建议序号","开仓时间","累计冲销金额（万元）","可冲销金额（万元）"};
				columnKeyArr = new String[]{"vcProductName","vcCombiName","vcBusinName","vcBusinType","lNominalCapital","lInstructNo","tFsDealTime","lActuSpendCapital","lLeftCapital"};
				changeObjArr = new Object[]{null,null,null,null,StrUtil.df2,null,null,StrUtil.df2,StrUtil.df2};
			}
			else if("DISCGOLD".equalsIgnoreCase(queryType)){				
				sheetHeadTitle = new String[]{"序号","产品名称","组合名称","交易日期","委托方向","金额（万元）","代理行","代理行账户名称","代理行账号","交易状态","录入时间","复核时间","确认时间","交易员1确认时间","交易员2复核时间","投资经理审批时间","综合部用印时间","资金清算时间","指令/建议序号","指令建议来源","备注"};
				columnKeyArr = new String[]{"vcProductName","vcCombiName","lTradeDate","vcEntrustDirection","lGoldCapital","vcAgentBank","vcAgentName","lAgentNo","cIsValid","tInputTime","tReviewTime","tClientTime","tTraderfTime","tTradesTime","tInvestmanagerTime","tComdepTime","tCapitalclearTime","lInstructNo","vcInstructSource","vcRemark"};
				changeObjArr = new Object[]{null,null,null,null,StrUtil.df2,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null};
			}
			
			//写入数据并关闭文件
			//ByteArrayOutputStream out = new ByteArrayOutputStream();
			//workbook.write(out);
			//byte[] data = out.toByteArray();
			//out.close();
			
			String fileName = "";
			if("HSFAGZB".equalsIgnoreCase(queryType)){
				CoframeSupplement.createGzbExcel(workbook, map, sheetHeadTitle, columnKeyArr, changeObjArr, exportData, sheetHeadFormat, BoldUnderlineCENTRE, BoldUnderlineLEFT);
				fileName = sheetName + ".xls";
			}else{
				CoframeSupplement.createExcelSheet(workbook, sheetName, sheetHeadTitle, columnKeyArr, changeObjArr, exportData, sheetHeadFormat, BoldUnderlineCENTRE, BoldUnderlineLEFT ,BoldUnderlineRight);
				fileName = ZhxxcxExport.EXCEL_NAME_PREFIX + sheetName + ".xls";
			}
			
			String pageUrl = ProductProcessExport.exportExcel(workbook, fileName);
			return pageUrl;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public static boolean isHandle(String VC_FUND_CODE) {
		String ATS_VALUATION_PRODUCT_EXPORT = ParamConfig.getValue("ATS_VALUATION_PRODUCT_EXPORT");

		if (StringUtils.isEmpty(ATS_VALUATION_PRODUCT_EXPORT) || StringUtils.isEmpty(VC_FUND_CODE))
			return false;

		String[] ATS_VALUATION_PRODUCT_EXPORTS = ATS_VALUATION_PRODUCT_EXPORT.split(",");

		for (int i = 0; i < ATS_VALUATION_PRODUCT_EXPORTS.length; i++) {
			if (VC_FUND_CODE.trim().equals(ATS_VALUATION_PRODUCT_EXPORTS[i].trim())) {
				return true;
			}
		}

		return false;
	}
	
	
	/**
	 * 生成zip并导出
	 * @param exportData 导出数据
	 * @param paramObject 导出条件对象
	 * @return
	 * @throws Exception
	 * @author zhanglu
	 */
	@Bizlet("")
	public static List<String> gzbplExport(DataObject paramObject) throws Exception {
		List<String> exclPage = new ArrayList<String>();
		String queryType = paramObject.getString("queryType");//查询类型
		String fundCodeArr = paramObject.getString("fundCodeArr");	//产品代码
		String fundNameArr = paramObject.getString("fundNameArr");	//产品名称
		String busDateArr = paramObject.getString("busDateArr");	//业务日期
		if("HSFAGZB".equalsIgnoreCase(queryType)){
			String [] fundcodes = fundCodeArr.split(",");
			String [] fundnames = fundNameArr.split(",");
			String [] busdatescode = busDateArr.split(",");
			for(int i=0;i<busdatescode.length;i++){
				String fundname = "";
				for(int j=0;j<fundcodes.length;j++){
					if(busdatescode[i].indexOf(fundcodes[j])>0){
						fundname = fundnames[j];
					}
				}
				String [] busdates = busdatescode[i].split("_");
				//for(int j=0;j<fundcodes.length;j++){
					String sheetName = "";
					String busiDate = busdates[0].substring(0, 4)+"年"+busdates[0].substring(5, 7)+"月"+busdates[0].substring(8, 10)+"日";
					paramObject.setString("busiDateEnd", busdates[0]);
					paramObject.setString("vCFundCode", busdates[1]);
					
					sheetName = fundname+busiDate+busdates[1]+"估值表";
					paramObject.setString("sheetName", sheetName);
					String componentName = "com.cjhxfund.jy.ProductProcess.ZhxxcxUtilBiz";/*逻辑构建名称*/
                    String operationName = "queryZHXX";/*逻辑流名称*/
                    ILogicComponent comp = LogicComponentFactory.create(componentName);
                    Object[] params = new Object[]{paramObject,null,0,10000000};
                    try {
						Object[] result = (Object[])comp.invoke(operationName,params);
						if(result.length>0 && result[0] != null){
						 List<DataObject> list  =  (List<DataObject>) result[0];
						 String page = zhxxcxExport(list,paramObject);
						 exclPage.add(page);
						}
					} catch (Throwable e) {
						e.printStackTrace();
					}finally{
						sheetName = null;
						busiDate = null;
						params = null;
						comp = null;
						componentName = null;
						operationName = null;
					}
				}
			}
		//}
		return exclPage;
	}
	public static void main(String[] args) {
	}
}
