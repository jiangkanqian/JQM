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
<title>场外执行成交</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link id="css_icon" rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/coframe/org/css/org.css"/>
<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/com.cjhxfund.js.base/utils/DateUtil.js"></script>
</head>
<body style="width:99.6%;height:99.6%;">
<div style="margin:0px 2px 0px 2px;width:100%;height:100%;" >
		
		   <%-- 场外执行成交查询条件开始... --%>
		   <div class="search-condition">
			   <div class="list">
				 <form id="form_CWZXCJ" method="post">
				 	<%-- 查询用户类型，若是投顾，则过滤产品权限 --%>
				 	<input class="nui-hidden" name="paramObject/queryUserType" value="<%=request.getParameter("queryUserType")%>">
				 	<%-- 查询类型 --%>
				 	<input class="nui-hidden" name="paramObject/queryType" value="OTCTRADE">
	                <table id="table1" class="table" style="height:100%;table-layout:fixed;">
	                	<tr>
	                		<td class="form_label" width="10%">
								确认操作日期:
	                        </td>
	                        <td colspan="1" width="30%">
	                        	从<input id="lDateBegin_CWZXCJ" class="nui-datepicker" name="paramObject/lConfirmDateBegin" width="100px" />
								到<input id="lDateEnd_CWZXCJ" class="nui-datepicker" name="paramObject/lConfirmDateEnd" width="100px" />
	                        </td>
	                        <td class="form_label" width="7%">
								基金名称:
	                        </td>
	                        <td colspan="1" width="20%">
	                            <input id="vcFundName_CWZXCJ" class="nui-buttonedit" name="paramObject/vCFundCode" onbuttonclick="ButtonClickGetFundName_CWZXCJ"/>
	                        </td>
	                        <td class="form_label" width="7%">
								证券代码:
	                        </td>
	                        <td colspan="1" width="20%">
	                            <input id="vcReportCode_CWZXCJ" class="nui-textbox" name="paramObject/vCReportCode"/>
	                        </td>
	                        <td class="form_label" width="7%">
								证券名称:
	                        </td>
	                        <td colspan="1" width="20%">
	                            <input id="vcStockName_CWZXCJ" class="nui-textbox" name="paramObject/vCStockName"/>
	                        </td>
	                    </tr>
	                    <tr>
	                		<td class="form_label" width="10%">
								到账日期:
	                        </td>
	                        <td colspan="1" width="30%">
	                        	从<input id="lSettleDateBegin_CWZXCJ" class="nui-datepicker" name="paramObject/lSettleDateBegin" width="100px" required="false"/>
								到<input id="lSettleDateEnd_CWZXCJ" class="nui-datepicker" name="paramObject/lSettleDateEnd" width="100px" required="false"/>
	                        </td>
	                        <td class="form_label" width="7%">
								业务分类:
	                        </td>
	                        <td colspan="1" width="20%">
	                            <input id="cBusinClass_CWZXCJ" class="nui-combobox" name="paramObject/cBusinClass" 
	                            textField="itemName" valueField="lemmaItem" dataField="resData" multiSelect="true"
	                            url="com.cjhxfund.jy.ProductProcess.ZhxxcxUtilBiz.queryBusinClass.biz.ext"/>
	                        </td>
	                        <td class="form_label" width="7%">
								委托方向:
	                        </td>
	                        <td colspan="1" width="20%">
	                        	<input id="cEntrustDirection_CWZXCJ" class="nui-combobox" name="paramObject/cEntrustDirection" 
	                            textField="entrustName" valueField="entrustName" dataField="resData" multiSelect="true"
	                            url="com.cjhxfund.jy.ProductProcess.ZhxxcxUtilBiz.queryEntrustDirection.biz.ext"/>
	                        </td>
	                        <td colspan="4">
	                        	<input class='nui-button' plain='false' text="查询" iconCls="icon-search" onclick="search_CWZXCJ()"/>
	                        	<input class='nui-button' plain='false' text="重置" iconCls="icon-cancel"  onclick="resetDire_CWZXCJ()"/>
	                            <input id="export_CWZXCJ" class='nui-button' plain='false' text="导出" iconCls="icon-download" onclick="export_CWZXCJ()"/>
	                        </td>
	                    </tr>
	                    <tr>
	                    	<td class="form_label" width="7%">
								日期:
	                        </td>
	                        <td colspan="1" width="20%">
	                                                                     从<input id="lDateBegin_CWZXCJ" class="nui-datepicker" 
	                            name="paramObject/lDateBegin" width="100px" required="true"
	                            onvaluechanged="lDateBeginFun('lDateBegin_CWZXCJ','lDateEnd_CWZXCJ')" />
								到<input id="lDateEnd_CWZXCJ" class="nui-datepicker" 
								name="paramObject/lDateEnd" width="100px"  required="true"
								onvaluechanged="lDateEndFun('lDateBegin_CWZXCJ','lDateEnd_CWZXCJ')"/>
	                        </td>
	                    </tr>
					</table>
				</form>
			  </div>
		   </div>
		   <%-- 场外执行成交查询条件结束!!! --%>
		   
		   <%-- 场外执行成交列表开始... --%>
           <div class="nui-fit">
                <div 
                        id="datagrid_CWZXCJ"
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
                        <div field="VC_FUND_NAME" headerAlign="center" allowSort="true" align="left" width="150px">
                            基金名称
                        </div>
                        <div field="VC_COMBI_NAME" headerAlign="center" allowSort="true" align="left" width="100px">
                            组合名称
                        </div>
                        <div field="C_BUSIN_CLASS" headerAlign="center" allowSort="true" align="left" width="100px">
                            业务分类
                        </div>
                        <div field="VC_REPORT_CODE" headerAlign="center" allowSort="true" align="center" width="100px">
                            证券代码
                        </div>
                        <div field="VC_STOCK_NAME" headerAlign="center" allowSort="true" align="left" width="150px">
                            证券名称
                        </div>
                        <div field="VC_ENTRUSTDIR_NAME" headerAlign="center" allowSort="true" align="center" width="75px">
                            委托方向
                        </div>
                        <div field="EN_BALANCE" headerAlign="center" allowSort="true" align="right" width="120px">
                           金额
                        </div>
                        <div field="EN_AMOUNT" headerAlign="center" allowSort="true" align="right" width="120px">
                            数量
                        </div>
                        <div field="L_SETTLE_DATE" headerAlign="center" allowSort="true" align="center" width="85px">
                           到账日期
                        </div>
                        <div field="L_CONFIRM_DATE" headerAlign="center" allowSort="true" align="center" width="85px">
                           确认操作日期
                        </div>
                        <div field="L_DATE" headerAlign="center" allowSort="true" align="center" width="85px">
                          日期
                        </div>
                    </div>
                </div>
            </div>
            <%-- 场外执行成交列表结束!!! --%>
		</div>

<script type="text/javascript">
    nui.parse();
    var businDay = '<%=businDay%>';//当前交易日
    var preDate = '<%=preDate%>';//上一个交易日
    
    var grid_CWZXCJ = nui.get("datagrid_CWZXCJ");//场外执行成交
    nui.get("lDateBegin_CWZXCJ").setValue(businDay);//设置默认起始日期
	nui.get("lDateEnd_CWZXCJ").setValue(businDay);//设置默认截止日期
    var refreshInt = true;//刚刚打开页面时，投顾默认刷新，交易员默认不刷新
    var queryUserTypeTemp = "<%=request.getParameter("queryUserType")%>";
	if(queryUserTypeTemp!=null && queryUserTypeTemp!="" && queryUserTypeTemp!="null"){
		refreshInt = false;
	}
    
    //tab标签切换时重新加载查询激活的tab标签的记录--所有业务通用
	function activechangedFun(){
		if(refreshInt==false){
			return;
		}
		search_CWZXCJ();
	}
	
	//系统自动刷新页面--所有业务通用
    function autoRefreshFun(){
    	refreshInt = true;//打开页面之后设置值为true
    	activechangedFun();//同时刷新查询列表数据
    }
    self.setInterval("autoRefreshFun()",60000*5);//设置自动刷新时间默认5分钟
	
	<%-- 场外执行成交查询开始... --%>
	//查询
	function search_CWZXCJ() {
		search(grid_CWZXCJ, "#form_CWZXCJ");
	}
	//获取查询条件的基金名称
	function ButtonClickGetFundName_CWZXCJ(e){
	
        ButtonClickGetFundName(this);
	}
	//表格行增加样式
	/*
	grid_CWZXCJ.on("drawcell", function (e) {
    	var record = e.record;
    	var dateStr = nui.formatDate(date,"yyyyMMdd");
		//设置行样式，当“法定购回日期”或“实际购回日期”或“购回交割日期”等于当天时，记录字体红色
		if(dateStr==record.L_REDEEM_LIQUIDATE || dateStr==record.L_SETTLE_DATE){
			e.rowCls = "warn_red";
		}
	});
	*/
	//导出
	function export_CWZXCJ(){
		exportSubmit("export_CWZXCJ", "form_CWZXCJ", "场外执行成交");
	}
	<%-- 场外执行成交查询结束!!! --%>
		//重置指令/建议信息
	function resetDire_CWZXCJ(){
		var form = new nui.Form("form_CWZXCJ");
		form.reset();
	}
</script>
</body>
</html>