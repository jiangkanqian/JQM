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
<title>银行间质押券查询</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link id="css_icon" rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/coframe/org/css/org.css"/>
<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/com.cjhxfund.js.base/utils/DateUtil.js"></script>
</head>
<body style="width:99.6%;height:99.6%;">
<div style="margin:0px 2px 0px 2px;width:100%;height:100%;" >
		   <%-- 银行间质押券查询条件开始... --%>
		   <div class="search-condition">
			   <div class="list">
				 <form id="form_YHJZYQ" method="post">
				 	<%-- 查询用户类型，若是投顾，则过滤产品权限 --%>
				 	<input class="nui-hidden" name="paramObject/queryUserType" value="<%=request.getParameter("queryUserType")%>">
				 	<%-- 查询类型 --%>
				 	<input class="nui-hidden" name="paramObject/queryType" value="ZHCC">
				 	<%-- 查询子条件-交易市场代码 --%>
				 	<input class="nui-hidden" name="paramObject/cMarketNo" value="5">
	                <table id="table1" class="table" style="height:100%;table-layout:fixed;">
	                	<tr>
	                        <td class="form_label" width="7%" align="right">
								业务日期:
	                        </td>
	                        <td colspan="1" width="20%">
	                                                        从<input id="lDateBegin_YHJZYQ" class="nui-datepicker" name="paramObject/lDateBegin" width="100px" onvaluechanged="lDateBeginFun" required="true"/>
								到<input id="lDateEnd_YHJZYQ" class="nui-datepicker" name="paramObject/lDateEnd" width="100px" onvaluechanged="lDateEndFun" required="true"/>
	                        </td>
	                        <td class="form_label" width="7%" align="right">
								基金名称:
	                        </td>
	                        <td colspan="1" width="20%">
	                            <input id="vCFundCode_YHJZYQ" class="nui-buttonedit" name="paramObject/vCFundCode" onbuttonclick="ButtonClickGetFundName_YHJZYQ"/>
	                        </td>
	                        <td class="form_label" width="7%" align="right">
								证券代码:
	                        </td>
	                        <td colspan="1" width="20%">
	                            <input id="vCReportCode_YHJZYQ" class="nui-textbox" name="paramObject/vCReportCode"/>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td class="form_label" width="7%" align="right">
								证券名称:
	                        </td>
	                        <td colspan="1" width="20%">
	                            <input id="vCStockName_YHJZYQ" class="nui-textbox" name="paramObject/vCStockName"/>
	                        </td>
	                        <td colspan="1" width="59px">
	                        </td>
	                        <td colspan="1" width="59px">
	                        	<input class='nui-button' plain='false' text="查询" iconCls="icon-search" onclick="search_YHJZYQ()"/>
	                        	&nbsp;
	                            <input id="export_YHJZYQ" class='nui-button' plain='false' text="导出" iconCls="icon-download" onclick="export_YHJZYQ()"/>
	                        </td>
	                    </tr>
					</table>
				</form>
			  </div>
		   </div>
		   <%-- 银行间质押券查询条件结束!!! --%>
		   
		   <%-- 银行间质押券列表开始... --%>
           <div class="nui-fit">
                <div 
                        id="datagrid_YHJZYQ"
                        dataField="resultObjectList"
                        class="nui-datagrid"
                        style="width:100%;height:100%;"
                        url="com.cjhxfund.jy.ProductProcess.ZhxxcxUtilBiz.queryZHXX.biz.ext"
                        pageSize="50"
                        showPageInfo="true"
                        allowSortColumn="true"
                        sortMode="client"
                        enableHotTrack="true"
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
                        <div field="VC_COMBI_NAME" headerAlign="center" allowSort="true" align="left" width="100px">
                            组合名称
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
                        <div field="L_USABLE_AMOUNT" headerAlign="center" allowSort="true" align="right"width="120px">
                            可用数量
                        </div>
                        <div field="EN_QJ" headerAlign="center" allowSort="true" align="right" width="80px">
                            全价
                        </div>
                        <div field="EN_JJ" headerAlign="center" allowSort="true" align="right" width="80px">
                            净价
                        </div>
                        <div field="C_OUTER_APPRAISE" headerAlign="center" allowSort="true" align="center" width="80px">
                            外部评级
                        </div>
                        <div field="C_ISSUER_OUTER_APPRAISE" headerAlign="center" allowSort="true" align="center" width="100px">
                            发行人外部评级
                        </div>
                    </div>
                </div>
            </div>
            <%-- 银行间质押券列表结束!!! --%>
</div>

<script type="text/javascript">
    nui.parse();
    var businDay = '<%=businDay%>';//当前交易日
    var preDate = '<%=preDate%>';//上一个交易日
    var grid_YHJZYQ = nui.get("datagrid_YHJZYQ");//银行间质押券
    nui.get("lDateBegin_YHJZYQ").setValue(businDay);//设置默认日期-银行间质押券-起始日期
	nui.get("lDateEnd_YHJZYQ").setValue(businDay);//设置默认日期-银行间质押券-截止日期
    
    var refreshInt = true;//刚刚打开页面时，投顾默认刷新，交易员默认不刷新
    var queryUserTypeTemp = "<%=request.getParameter("queryUserType")%>";
	if(queryUserTypeTemp!=null && queryUserTypeTemp!="" && queryUserTypeTemp!="null"){
		refreshInt = false;
	}
	
	//系统自动刷新页面--所有业务通用
    function autoRefreshFun(){
    	if(refreshInt==false){
			return;
		}
		search_YHJZYQ();
    }
    self.setInterval("autoRefreshFun()",60000*5);//设置自动刷新时间默认5分钟
	
	<%-- 银行间质押券查询开始... --%>
	//查询
	function search_YHJZYQ() {
		search(grid_YHJZYQ, "#form_YHJZYQ");
	}
	//获取查询条件的基金名称
	function ButtonClickGetFundName_YHJZYQ(e){
        ButtonClickGetFundName(this);
	}
	//导出
	function export_YHJZYQ(){
		exportSubmit("export_YHJZYQ", "form_YHJZYQ", "银行间质押券");
	}
	<%-- 银行间质押券查询结束!!! --%>
	
	
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
	
	//时间判断
	function lDateBeginFun(){
		var lDateBegin_YHJZYQ = DateUtil.toNumStr(nui.get("lDateBegin_YHJZYQ").getValue());
		var lDateEnd_YHJZYQ = DateUtil.toNumStr(nui.get("lDateEnd_YHJZYQ").getValue());
		if(null != lDateBegin_YHJZYQ && null !=lDateEnd_YHJZYQ ){
			if(lDateBegin_YHJZYQ > lDateEnd_YHJZYQ){
				nui.alert("起始日期不能大于截止日期！","提示");
				//日期校验
				nui.get("lDateBegin_YHJZYQ").setValue(businDay);
				nui.get("lDateEnd_YHJZYQ").setValue(businDay);
				return;
			}
			if(lDateBegin_YHJZYQ < lDateEnd_YHJZYQ){
				if(lDateEnd_YHJZYQ == businDay){
					if(lDateBegin_YHJZYQ > preDate){
						nui.get("lDateBegin_YHJZYQ").setValue(preDate);
						nui.get("lDateEnd_YHJZYQ").setValue(preDate);
						return;
					}else{
						nui.alert("仅能查询当天或历史的交易流水！","提示");
						nui.get("lDateEnd_YHJZYQ").setValue(preDate);
						return;
					}
				}
				
			}
		}
	}
	
	//时间判断
	function lDateEndFun(){
		var lDateBegin_YHJZYQ = DateUtil.toNumStr(nui.get("lDateBegin_YHJZYQ").getValue());
		var lDateEnd_YHJZYQ = DateUtil.toNumStr(nui.get("lDateEnd_YHJZYQ").getValue());
		if(lDateEnd_YHJZYQ < lDateBegin_YHJZYQ){
			//起始时间不能大于截止时间
			nui.get("lDateBegin_YHJZYQ").setValue(lDateEnd_YHJZYQ);
		}
		if(lDateBegin_YHJZYQ < lDateEnd_YHJZYQ){
			if(lDateBegin_YHJZYQ > preDate){
				nui.get("lDateBegin_YHJZYQ").setValue(preDate);
				nui.get("lDateEnd_YHJZYQ").setValue(preDate);
				nui.alert("仅能查询当天或历史的交易流水！","提示");
				return;
			}else{
				if((lDateEnd_YHJZYQ >= businDay) || (preDate < lDateEnd_YHJZYQ && lDateEnd_YHJZYQ < businDay)){
					nui.get("lDateEnd_YHJZYQ").setValue(preDate);
					nui.alert("仅能查询当天或历史的交易流水！","提示");
					return;
				}
			}
		}
	}
	
</script>
</body>
</html>