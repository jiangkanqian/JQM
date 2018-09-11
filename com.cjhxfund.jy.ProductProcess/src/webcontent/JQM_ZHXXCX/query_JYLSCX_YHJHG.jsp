<%@page import="com.cjhxfund.commonUtil.DateUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/JQMHistory/common/commscripts.jsp" %>
<%@include file="/ProductProcess/zhxxcx/CFJY_zhxxcx_common.jsp" %>
<%--
- Author(s): huangmizhi
- Date: 2016-03-03 14:35:39
- Description: 综合信息查询（数据取自O32）
--%>
<head>
<title>综合信息查询</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link id="css_icon" rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/coframe/org/css/org.css"/>
<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/com.cjhxfund.js.base/utils/DateUtil.js"></script>
</head>
<body style="width:99.6%;height:99.6%;">
<div style="margin:0px 2px 0px 2px;width:100%;height:100%;" >
		   <%-- 银行间回购查询条件开始... --%>
		   <div class="search-condition">
			   <div class="list">
				 <form id="form_YHJHG" method="post">
				 	<%-- 查询用户类型，若是投顾，则过滤产品权限 --%>
				 	<input class="nui-hidden" name="paramObject/queryUserType" value="<%=request.getParameter("queryUserType")%>">
				 	<%-- 查询类型 --%>
				 	<input class="nui-hidden" name="paramObject/queryType" value="YHJHG">
	                <table id="table1" class="table" style="height:100%;table-layout:fixed;">
	                	<tr>
	                        <td class="form_label" width="10%">
								回购日期:
	                        </td>
	                        <td colspan="1" width="25%">
	                        	从<input id="busiDateBegin_YHJHG" class="nui-datepicker" name="paramObject/busiDateBegin" width="100px"  required="false"/>
								到<input id="busiDateEnd_YHJHG" class="nui-datepicker" name="paramObject/busiDateEnd" width="100px"  required="false"/>
	                        </td>
	                        <td class="form_label" width="7%">
								基金名称:
	                        </td>
	                        <td colspan="1" width="15%">
	                            <input id="vCFundCode_YHJHG" class="nui-buttonedit" name="paramObject/vCFundCode" onbuttonclick="ButtonClickGetFundName_YHJHG"/>
	                        </td>
	                        <td class="form_label" width="7%">
								组合名称:
	                        </td>
	                        <td colspan="1" width="15%">
	                            <input id="vcCombiName_YHJHG" class="nui-textbox" name="paramObject/vcCombiName"/>
	                        </td>
	                        <td colspan="2" align="center">
	                        	导出模式
	                        </td>
	                        <td colspan="1">
	                            <input class='nui-button' plain='false' text="查询" iconCls="icon-search" onclick="search_YHJHG()"/>
	                        </td>
	                    </tr>
	                    <tr>
	                    	<td class="form_label" width="10%">
								实际购回日期:
	                        </td>
	                        <td colspan="1" width="20%">
	                        	从<input id="lRedeemLiquidateBegin_YHJHG" class="nui-datepicker" name="paramObject/lRedeemLiquidateBegin" width="100px" required="false"/>
								到<input id="lRedeemLiquidateEnd_YHJHG" class="nui-datepicker" name="paramObject/lRedeemLiquidateEnd" width="100px" required="false"/>
	                        </td>
	                        <td class="form_label" width="7%">
								回购代码:
	                        </td>
	                        <td colspan="1" width="15%">
	                            <input id="vCReportCode_YHJHG" class="nui-textbox" name="paramObject/vCReportCode"/>
	                        </td>
	                        <td class="form_label" width="7%">
								委托方向:
	                        </td>
	                        <td colspan="1" width="15%">
	                            <!-- <input id="vCEntrustdirName_YHJHG" class="nui-textbox" name="paramObject/vCEntrustdirName"/> -->
	                            <input class="nui-combobox"  name="paramObject/vCEntrustdirName"  textField="VAL" valueField="id" 
    data="[{ id: '融资回购', VAL: '融资回购' }, { id: '融券回购', VAL: '融券回购'}]" emptyText="请选择"  multiSelect="true"  />
	                        </td>
	                        <td colspan="2">
	                            <input class="nui-radiobuttonlist" name="paramObject/type"  textField="VAL" valueField="id" 
    data="[{ id: 'y', VAL: '无质押券' }, { id: 'n', VAL: '含质押券'}]" value="y"/>
	                        </td> 
	                        <td>
	                            <input id="export_YHJHG" class='nui-button' plain='false' text="导出" iconCls="icon-download" onclick="export_YHJHG()"/>
	                        </td>
	                    </tr>
					</table>
				</form>
			  </div>
		   </div>
		   <%-- 银行间回购查询条件结束!!! --%>
		   
		   <%-- 银行间回购列表开始... --%>
           <div class="nui-fit">
                <div 
                        id="datagrid_YHJHG"
                        dataField="resultObjectList"
                        class="nui-datagrid"
                        style="width:100%;height:100%;"
                        url="com.cjhxfund.jy.ProductProcess.ZhxxcxUtilBiz.queryZHXX.biz.ext"
                        pageSize="50"
                        showPageInfo="true"
                        allowSortColumn="true"
                        sortMode="client"
                        enableHotTrack="true"
                        pagerButtons="#prompt_todays"
                        sizeList="[10,20,50,100]">

                    <div property="columns">
                        <div type="indexcolumn"></div>
                        <div field="L_HG_DATE" headerAlign="center" allowSort="true" align="center" width="75px">
                            回购日期
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
                            回购代码
                        </div>
                        <div field="VC_ENTRUSTDIR_NAME" headerAlign="center" allowSort="true" align="center" width="75px">
                            委托方向
                        </div>
                        <div field="L_DEAL_AMOUNT" headerAlign="center" allowSort="true" align="right" width="120px">
                            数量
                        </div>
                        <div field="EN_NET_ZJ" headerAlign="center" allowSort="true" align="right" width="120px">
                            净资金额
                        </div>
                        <div field="EN_RET_ZJ" headerAlign="center" allowSort="true" align="right" width="120px">
                            返回金额
                        </div>
                        <div field="VC_RIVAL_NAME" headerAlign="center" allowSort="true" align="left" width="150px">
                            交易对手
                        </div>
                        <div field="EN_INTEREST_RATE" headerAlign="center" allowSort="true" align="right" width="80px">
                            平均利率(%)
                        </div>
                        <div field="EN_PROFIT" headerAlign="center" allowSort="true" align="right" width="120px">
                            利润
                        </div>
                        <div field="L_REDEEM_LAWDATE" headerAlign="center" allowSort="true" align="center" width="85px">
                            法定购回日期
                        </div>
                        <div field="L_REDEEM_LIQUIDATE" headerAlign="center" allowSort="true" align="center" width="85px">
                            实际购回日期
                        </div>
                        <div field="L_SETTLE_DATE" headerAlign="center" allowSort="true" align="center" width="85px">
                            购回交割日期
                        </div>
                        <div field="C_STOCK_TYPE" headerAlign="center" allowSort="true" align="center" width="75px">
                            证券类别
                        </div>
                        <div field="VC_REAL_CODE" headerAlign="center" allowSort="true" align="center" width="85px">
                            实际回购代码
                        </div>
                        <div field="C_TRUSTEE" headerAlign="center" allowSort="true" align="center" width="85px">
                            托管机构
                        </div>
                    </div>
                </div>
            </div>
            <div id="prompt_todays">
		        <span class="separator"></span>
		       	<div style= "display:inline-block; color:red;margin-right: 8px;">红色字体代表“法定购回日期”或“实际购回日期”或“购回交割日期”等于当天</div>
			</div>
            <%-- 银行间回购列表结束!!! --%>
		</div>

<script type="text/javascript">
    nui.parse();
    var grid_YHJHG = nui.get("datagrid_YHJHG");//银行间回购
    var refreshInt = true;//刚刚打开页面时，投顾默认刷新，交易员默认不刷新
    var queryUserTypeTemp = "<%=request.getParameter("queryUserType")%>";
	if(queryUserTypeTemp!=null && queryUserTypeTemp!="" && queryUserTypeTemp!="null"){
		refreshInt = false;
	}
	//初始化查询条件业务日期值为当天
    var date = new Date();
    
    //tab标签切换时重新加载查询激活的tab标签的记录--所有业务通用
	function activechangedFun(){
		if(refreshInt==false){
			return;
		}
		search_YHJHG();
	}
	
	//系统自动刷新页面--所有业务通用
    function autoRefreshFun(){
    	refreshInt = true;//打开页面之后设置值为true
    	activechangedFun();//同时刷新查询列表数据
    }
    self.setInterval("autoRefreshFun()",60000*5);//设置自动刷新时间默认5分钟
	
	<%-- 银行间回购查询开始... --%>
	//查询
	function search_YHJHG() {
		search(grid_YHJHG, "#form_YHJHG");
	}
	//获取查询条件的基金名称
	function ButtonClickGetFundName_YHJHG(e){
        ButtonClickGetFundName(this);
	}
	//表格行增加样式
	grid_YHJHG.on("drawcell", function (e) {
    	var record = e.record;
    	var dateStr = nui.formatDate(date,"yyyyMMdd");
		//设置行样式，当“法定购回日期”或“实际购回日期”或“购回交割日期”等于当天时，记录字体红色
		if(dateStr==record.L_REDEEM_LAWDATE || dateStr==record.L_REDEEM_LIQUIDATE || dateStr==record.L_SETTLE_DATE){
			e.rowCls = "warn_red";
		}
	});
	//行双击时弹出页面展示银行间回购明细表
    grid_YHJHG.on("rowdblclick", function (e) {
    	rowdblclickFun("CFJY_zhxxcx_yhjhg_detail.jsp", "银行间回购明细表", 710, 300, e, grid_YHJHG);
    });
    //导出
	function export_YHJHG(){
		exportSubmit("export_YHJHG", "form_YHJHG", "银行间回购");
	}
	<%-- 银行间回购查询结束!!! --%>
	
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
	
	
</script>
</body>
</html>