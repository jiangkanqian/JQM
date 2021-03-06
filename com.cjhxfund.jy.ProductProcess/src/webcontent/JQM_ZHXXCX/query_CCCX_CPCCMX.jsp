<%@page import="com.cjhxfund.commonUtil.DateUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/JQMHistory/common/commscripts.jsp" %>
<%@include file="/ProductProcess/zhxxcx/CFJY_zhxxcx_common.jsp" %>
<%
	//默认当天是交易日
	String businDay = DateUtil.currentDateString(DateUtil.YMD_NUMBER);
	//判断今天是否为交易日
	boolean isTradeDay = DateUtil.isTradeDay(null, DateUtil.currentDateString(DateUtil.YMD_NUMBER), null);
	//若当天不是交易日（周末或节假日），则业务日期获取下个交易日
	if(!isTradeDay){
		businDay = DateUtil.getCalculateTradeDay(null, DateUtil.currentDateString(DateUtil.YMD_NUMBER), null, 1);
	}
	//获取上一个交易日
	String preDate = DateUtil.getCalculateTradeDay(null, DateUtil.currentDateString(DateUtil.YMD_NUMBER), null, -1);
%>
<%--
- Author(s): huangmizhi
- Date: 2016-03-03 14:35:39
- Description: 综合信息查询（数据取自O32）
--%>
<head>
<title>产品持仓明细查询</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link id="css_icon" rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/coframe/org/css/org.css"/>
<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/com.cjhxfund.js.base/utils/DateUtil.js"></script>
</head>
<body style="width:99.6%;height:99.6%;">
<div style="margin:0px 2px 0px 2px;width:100%;height:100%;" >
		   <%-- 组合持仓查询条件开始... --%>
		   <div class="search-condition">
			   <div class="list">
				 <form id="form_ZHCC" method="post">
				 	<%-- 查询用户类型，若是投顾，则过滤产品权限 --%>
				 	<input class="nui-hidden" name="paramObject/queryUserType" value="<%=request.getParameter("queryUserType")%>">
				 	<%-- 查询类型 --%>
				 	<input class="nui-hidden" name="paramObject/queryType" value="ZHCCExtend">
				 	<%-- 查询子条件-交易市场代码 --%>
				 	<input class="nui-hidden" name="paramObject/cMarketNo" value="">
	                <table id="table1" class="table" style="height:30px;table-layout:fixed;">
	                	<tr>
	                        <td class="form_label" width="7%" align="right">
								业务日期:
	                        </td>
	                        <td colspan="1" width="20%">
	                            <!-- <input id="busiDateEnd_ZHCC" class="nui-datepicker" name="paramObject/busiDateEnd" required="true"/> -->
	                                                                                    从<input id="lDateBegin_ZHCC" class="nui-datepicker" name="paramObject/lDateBegin" width="100px" onvaluechanged="lDateBeginFun" required="true"/>
								到<input id="lDateEnd_ZHCC" class="nui-datepicker" name="paramObject/lDateEnd" width="100px" onvaluechanged="lDateEndFun" required="true"/>
	                        </td>
	                        <td class="form_label" width="7%" align="right">
								交易市场:
	                        </td>
	                        <td colspan="1" width="20%">
	                            <input id="cMarketName_ZHCC" class="nui-textbox" name="paramObject/cMarketName"/>
	                        </td>
	                        <td class="form_label" width="7%" align="right">
								基金名称:
	                        </td>
	                        <td colspan="1" width="20%">
	                            <input id="vCFundCode_ZHCC" class="nui-buttonedit" name="paramObject/vCFundCode" onbuttonclick="ButtonClickGetFundName_ZHCC"/>
	                        </td>
	                    </tr>
	                    <tr>
	                    	<td class="form_label" width="7%" align="right">
								证券代码/名称:
	                        </td>
	                        <td colspan="1" width="20%">
	                            <input id="vCReportCode_ZHCC" class="nui-autocomplete" popupWidth="300" popupHeight="200" name="paramObject/vCReportCode" searchField="searchKey" dataField="investProducts"
                        		valueField="investProductInfo" textField="investProduct" url="com.cjhxfund.jy.ProductProcess.CFJYProductProcessBiz.getInvestProductsByKey.biz.ext" value="" text="" enterQuery="false" onitemclick="investProductCodeOnItemClick"/>
	                        </td>
	                    	<td class="form_label" width="7%" align="right">
								证券名称:
	                        </td>
	                        <td colspan="1" width="20%">
	                            <input id="vCStockName_ZHCC" class="nui-textbox" name="paramObject/vCStockName" />
	                        </td>
	                        <!--<td class="form_label" width="7%">
								证券名称:
	                        </td>
	                        <td colspan="1" width="20%">
	                            <input id="vCStockName_ZHCC" class="nui-textbox" name="paramObject/vCStockName"/>
	                        </td>-->
	                        <td colspan="1" width="59px">
	                        </td>
	                        <td colspan="1" width="59px">
	                        	<input class='nui-button' plain='false' text="查询" iconCls="icon-search" onclick="search_ZHCC()"/>
	                        	&nbsp;
	                        	<input id="export_ZHCC" class='nui-button' plain='false' text="导出" iconCls="icon-download" onclick="export_ZHCC()"/>
	                        </td>
	                    </tr>
					</table>
				</form>
			  </div>
		   </div>
		   <%-- 组合持仓查询条件结束!!! --%>
		   
		   <%-- 组合持仓列表开始... --%>
           <div class="nui-fit">
                <div 
                        id="datagrid_ZHCC"
                        dataField="resultObjectList"
                        class="nui-datagrid"
                        style="width:100%;height:100%;"
                        url="com.cjhxfund.jy.ProductProcess.ZhxxcxUtilBiz.queryZHXX.biz.ext"
                        pageSize="50"
                        showPageInfo="true"
                        allowSortColumn="true"
                        frozenStartColumn="0"
                        frozenEndColumn="3"
                        sortMode="client"
                        enableHotTrack="true"
                        pagerButtons="#prompt_todays"
                        sizeList="[10,20,50,100]">

                    <div property="columns">
                        <div type="indexcolumn"></div>
                        <div field="L_DATE" headerAlign="center" allowSort="true" align="center" width="75px">
                            日期
                        </div>
                        <div field="VC_FUND_CODE" headerAlign="center" allowSort="true" align="center" width="75px">
                            基金代码
                        </div>
                        <div field="VC_FUND_NAME" headerAlign="center" allowSort="true" align="left" width="150px">
                            基金名称
                        </div>
                        <div field="L_FUND_ID" headerAlign="center" allowSort="true" align="left" width="75px">
                            基金编号
                        </div>
                        <div field="VC_COMBI_NAME" headerAlign="center" allowSort="true" align="left" width="100px">
                            组合名称
                        </div>
                        <div field="VC_COMBI_NO" headerAlign="center" allowSort="true" align="left" width="100px">
                            组合编号
                        </div>
                        <div field="VC_STOCKHOLDER_ID" headerAlign="center" allowSort="true" align="left" width="100px">
                            股东代码
                        </div>
                        <div field="VC_INTER_CODE" headerAlign="center" visible="false">
                            证券内码
                        </div>
                        <div field="VC_REPORT_CODE" headerAlign="center" allowSort="true" align="center" width="75px">
                            证券代码
                        </div>
                        <div field="VC_STOCK_NAME" headerAlign="center" allowSort="true" align="left" width="120px">
                            证券名称
                        </div>
                        <div field="VC_MARKET_NAME" headerAlign="center" allowSort="true" align="center" width="75px">
                            交易市场
                        </div>
                        <div field="L_CURRENT_AMOUNT" headerAlign="center" allowSort="true" align="right"width="120px">
                            持仓
                        </div>
                        <div field="C_POSITION_FLAG" headerAlign="center" allowSort="true" align="center" width="100px">
                            持仓多空标志
                        </div>
                        <div field="L_USABLE_AMOUNT" headerAlign="center" allowSort="true" align="right"width="120px">
                            可用数量
                        </div>
                        <div field="L_FROZEN_AMOUNT" headerAlign="center" allowSort="true" align="right" width="120px">
                            冻结数量
                        </div>
                        <div field="EN_LAST_PRICE" headerAlign="center" allowSort="true" align="right" width="120px">
                            最新价
                        </div>
                        <div field="EN_QJ" headerAlign="center" allowSort="true" align="right" width="80px">
                            全价
                        </div>
                        <div field="EN_JJ" headerAlign="center" allowSort="true" align="right" width="80px">
                            净价
                        </div>
                        <div field="EN_BEGIN_COST_PRICE" headerAlign="center" allowSort="true" align="right" width="80px">
                            成本价
                        </div>
                        <div field="D_QJCB" headerAlign="center" allowSort="true" align="right" width="120px">
                            全价成本
                        </div>
                        <div field="EN_VALUE_CURRENCY" headerAlign="center" allowSort="true" align="right" width="120px">
                            市值
                        </div>
                        <div field="D_QJSZ" headerAlign="center" allowSort="true" align="right" width="120px">
                            全价市值
                        </div>
                        <div field="EN_FLOAT_RATE" headerAlign="center" allowSort="true" align="right" width="120px">
                            盈亏率（%）
                        </div>
                        <div field="EN_TOTAL_PROFIT" headerAlign="center" allowSort="true" align="right" width="120px">
                            总体盈亏
                        </div>
                        <div field="D_QJFY" headerAlign="center" allowSort="true" align="right" width="120px">
                            全价浮盈
                        </div>
                        <div field="EN_CURRENCY_FUND" headerAlign="center" allowSort="true" align="right" width="120px">
                            市值比净值（%）
                        </div>
                        <div field="C_OUTER_APPRAISE" headerAlign="center" allowSort="true" align="center" width="80px">
                            外部评级
                        </div>
                        <div field="C_ISSUER_OUTER_APPRAISE" headerAlign="center" allowSort="true" align="center" width="100px">
                            发行人外部评级
                        </div>
                        <div field="ZPR" headerAlign="center" allowSort="true" align="center" width="100px">
                            债券摘牌日
                        </div>
                        <div field="DQR" headerAlign="center" allowSort="true" align="center" width="100px">
                            债券兑付日
                        </div>
                        <!-- 万得BBQ产品下架了 -->
                        <!-- 
                        <div field="RT_YIELD" headerAlign="center" allowSort="true" align="right">
                            成交价
                        </div>
                        <div field="RT_ASKYIELD" headerAlign="center" allowSort="true" align="right">
                            卖出收益价
                        </div>
                        <div field="RT_BIDYIELD" headerAlign="center" allowSort="true" align="right">
                            买入收益价
                        </div>
                        -->
                    </div>
                </div>
                <div id="prompt_todays">
			        <span class="separator"></span>
			       	<div style= "display:inline-block; color:red;margin-right: 8px;">红色字体代表“债券摘牌日”或“债券兑付日”等于当天</div>
				</div>
		<%-- 业务类型标签页结束!!! --%>
	</div>
</div>

<script type="text/javascript">
    nui.parse();
    var businDay = '<%=businDay%>';//当前交易日
    var preDate = '<%=preDate%>';//上一个交易日
    
    var grid_ZHCC = nui.get("datagrid_ZHCC");//组合持仓
    nui.get("lDateBegin_ZHCC").setValue(businDay);//设置默认日期-交易所成交回报-起始日期
	nui.get("lDateEnd_ZHCC").setValue(businDay);//设置默认日期-交易所成交回报-截止日期
    
    var refreshInt = true;//刚刚打开页面时，投顾默认刷新，交易员默认不刷新
    var queryUserTypeTemp = "<%=request.getParameter("queryUserType")%>";
	if(queryUserTypeTemp!=null && queryUserTypeTemp!="" && queryUserTypeTemp!="null"){
		refreshInt = false;
	}
	//初始化查询条件业务日期值为当天
    var date = new Date();
    
    
	//系统自动刷新页面--所有业务通用
    function autoRefreshFun(){
    	if(refreshInt==false){
			return;
		}
    	search_ZHCC();
    }
  //self.setInterval("autoRefreshFun()",60000*5);//设置自动刷新时间默认5分钟

    <%-- 组合持仓查询开始... --%>
	//查询
	function search_ZHCC() {
		search(grid_ZHCC, "#form_ZHCC");
	}
	//获取查询条件的基金名称
	function ButtonClickGetFundName_ZHCC(e){
        ButtonClickGetFundName(this);
	}
	//表格行增加样式
	grid_ZHCC.on("drawcell", function (e) {
    	var record = e.record;
    	var dateStr = nui.formatDate(date,"yyyyMMdd");
		//设置行样式，当“债券摘牌日”或“债券兑付日”等于当天时，记录字体红色
		if(dateStr==record.ZPR || dateStr==record.DQR){
			e.rowCls = "warn_red";
		}
	});
	//导出
	function export_ZHCC(){
		exportSubmit("export_ZHCC", "form_ZHCC", "产品持仓明细");
	}
	//行双击时弹出页面展示万得BBQ实时行情--万得BBQ产品下架了
    //grid_ZHCC.on("rowdblclick", function (e) {
    //	var row = e.record;
    //	rowdblclickFun("CFJY_zhxxcx_zhcc_wind_bbq_hq.jsp", row.VC_REPORT_CODE + "-" + row.VC_STOCK_NAME + "  万得BBQ实时行情", 800, 300, e, grid_ZHCC);
    //});
	<%-- 组合持仓查询结束!!! --%>
	
	//日期转换
	function dateRen(e){
		if(e.value == 0){
			return "";
		}
		if(e.value){
			return DateUtil.numStrToDateStr(e.value);
		}
		return "";
	}
	
	//时间转换
	function timeRen(e){
		if(e.value == 0){
			return "";
		}
		if(e.value){
			return DateUtil.numStrToTimeStr(e.value);
		}
		return "";
	}
	
	//重置指令/建议信息
	function resetDire_CPJZ(){
		var form = new nui.Form("form_CPJZ");
		form.reset();
	}
	
	//债券代码下拉项点击时触发函数
    function investProductCodeOnItemClick(){
        var investProductCode = nui.get("vCReportCode_ZHCC").getValue();//投资产品信息
        if(investProductCode!=null && investProductCode!=""){
        
        	//通过交易市场编号、证券申报代码到O32系统查找投资的债券、股票等产品信息（包含债券评级等债券属性）
        	var paramArr = investProductCode.split(",");
	    	$.ajax({
	            url:"com.cjhxfund.jy.ProductProcess.CFJYProductProcessBiz.getInvestProductInfoByMarketNoAndReportCode.biz.ext",
	            type:'POST',
	            data:nui.encode({marketNo:paramArr[2], reportCode:paramArr[0]}),
	            cache:false,
	            contentType:'text/json',
	            success:function(text){
	                var returnJson = nui.decode(text);
	                if(returnJson.exception == null){
	                	var investProductInfo = returnJson.investProductInfo;//投资产品信息（债券代码,债券名称,债券类别代码,债券评级代码,主体评级代码,评级机构代码）
	                	
	                	//投资产品信息（债券代码,债券名称,债券类别代码,债券评级代码,主体评级代码,评级机构代码）
	                	var investProductCodeArr = investProductInfo.split(",");
	                	var investProductCodeVal = investProductCodeArr[0];//债券代码
	                	//var investProductNameVal = investProductCodeArr[1];//债券名称
	                	
		                nui.get("vCReportCode_ZHCC").setText(investProductCodeVal);
		                nui.get("vCReportCode_ZHCC").setValue(investProductCodeVal);
		                //nui.get("investProductName").setValue(investProductNameVal);
	                }else{
	                    nui.alert("债券详细信息获取失败", "系统提示");
	                }
	            }
	        });
            
        }else{
        	nui.get("vCReportCode_ZHCC").setText(null);
            nui.get("vCReportCode_ZHCC").setValue(null);
        }
    }

	//时间判断
	function lDateBeginFun(){
		var lDateBegin_ZHCC = DateUtil.toNumStr(nui.get("lDateBegin_ZHCC").getValue());
		var lDateEnd_ZHCC = DateUtil.toNumStr(nui.get("lDateEnd_ZHCC").getValue());
		if(null != lDateBegin_ZHCC && null !=lDateEnd_ZHCC ){
			if(lDateBegin_ZHCC > lDateEnd_ZHCC){
				nui.alert("起始日期不能大于截止日期！","提示");
				//日期校验
				nui.get("lDateBegin_ZHCC").setValue(businDay);
				nui.get("lDateEnd_ZHCC").setValue(businDay);
				return;
			}
			if(lDateBegin_ZHCC < lDateEnd_ZHCC){
				if(lDateEnd_ZHCC == businDay){
					if(lDateBegin_ZHCC > preDate){
						nui.get("lDateBegin_ZHCC").setValue(preDate);
						nui.get("lDateEnd_ZHCC").setValue(preDate);
						return;
					}else{
						nui.alert("仅能查询当天或历史的持仓！","提示");
						nui.get("lDateEnd_ZHCC").setValue(preDate);
						return;
					}
				}
				
			}
		}
	}
	
	//时间判断
	function lDateEndFun(){
		var lDateBegin_ZHCC = DateUtil.toNumStr(nui.get("lDateBegin_ZHCC").getValue());
		var lDateEnd_ZHCC = DateUtil.toNumStr(nui.get("lDateEnd_ZHCC").getValue());
		if(lDateEnd_ZHCC < lDateBegin_ZHCC){
			//起始时间不能大于截止时间
			nui.get("lDateBegin_ZHCC").setValue(lDateEnd_ZHCC);
		}
		if(lDateBegin_ZHCC < lDateEnd_ZHCC){
			if(lDateBegin_ZHCC > preDate){
				nui.get("lDateBegin_ZHCC").setValue(preDate);
				nui.get("lDateEnd_ZHCC").setValue(preDate);
				nui.alert("仅能查询当天或历史的持仓！","提示");
				return;
			}else{
				if((lDateEnd_ZHCC >= businDay) || (preDate < lDateEnd_ZHCC && lDateEnd_ZHCC < businDay)){
					nui.get("lDateEnd_ZHCC").setValue(preDate);
					nui.alert("仅能查询当天或历史的持仓！","提示");
					return;
				}
			}
		}
	}
</script>
</body>
</html>