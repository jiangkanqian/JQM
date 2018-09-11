<%@page import="com.cjhxfund.commonUtil.DateUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String preDate = DateUtil.getCalculateTradeDay(null, DateUtil.currentDateString(DateUtil.YMD_NUMBER), null, 0);
	String preDateOne = DateUtil.getCalculateTradeDay(null, DateUtil.currentDateString(DateUtil.YMD_NUMBER), null, 5);
	String preDateTwo = DateUtil.getCalculateTradeDay(null, DateUtil.currentDateString(DateUtil.YMD_NUMBER), null, 10);
%>
<html>
<%@include file="/JQMHistory/common/commscripts.jsp" %>
<%@include file="/ProductProcess/zhxxcx/CFJY_zhxxcx_common.jsp" %>
<!-- 
  - Author(s): chendi
  - Date: 2017-06-12 09:19:14
  - Description:
-->
<head>
<title>头寸管理查询</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link id="css_icon" rel="stylesheetet" type="text/css" href="<%= request.getContextPath() %>/coframe/org/css/org.css"/>
<script src="<%= request.getContextPath() %>/ProductProcess/cashFlow/cashFlow_common.js" type="text/javascript"></script>
<link	rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/common/css/GridDetailBlock.css" />
<script	type="text/javascript" src="<%= request.getContextPath() %>/common/js/GridDetailBlock.js"></script>

</head>
<body style="width:99.6%;height:99.6%;">
<div style="margin:0px 2px 0px 2px;width:100%;height:100%;" >
	<div id="tab" activeIndex="0" onactivechanged="activechangedFun" style="width:100%;height:100%;">
				   <%-- 头寸管理查询条件开始... --%>
				   <div class="search-condition">
						   <div class="list">
							 <form id="form_TCYCCX" method="post">
							 	<%-- 查询用户类型，若是投顾，则过滤产品权限 --%>
							 	<input class="nui-hidden" name="paramObject/queryUserType" value="<%=request.getParameter("queryUserType")%>">
							 	<%-- 查询类型 --%>
							 	<input class="nui-hidden" name="paramObject/queryType" value="TCYCCX">
							 	<%--基金ID --%>
							 	<input id="lFundId_TCYCCX" class="nui-hidden" name="paramObject/lFundIds" value="">
							 	<%-- 开始日期 --%>
							 	<input id="beginDate" class="nui-hidden" name="paramObject/beginDate">
							 	<%-- 结束日期 --%>
								<input id="endDate" class="nui-hidden" name="paramObject/endDate">
		            <table id="table_TCYCCX" class="table" style="height:100%;table-layout:fixed;">
		            	<tr>
				            	<td class="form_label" width="60px" align="right">
										预测区间:
				                </td>
				                <td colspan="1" width="10%" align="left">
				                    <input id="interval_TCYCCX" class="nui-combobox" 
				                    name="paramObject/interval" 
				                    data="[{id:'01',text:'未来一周'},{id:'02',text:'未来两周'}]"
				                    value="01"
				                    onvaluechanged="setDate_TCYCCX"/>
				                </td>
				                <td class="form_label" width="40px" align="right">
										日期:
				                </td>
				                <td colspan="1" width="20%" align="left">
				                    <input id="dateOne" class="nui-datepicker" allowInput="false" name="paramObject/dateOne" valueType="String" />
									<span style="width:2%;">-</span>
									<input id="dateTwo" class="nui-datepicker" allowInput="false" name="paramObject/dateTwo" valueType="String" />
				                </td>
				        		<td class="form_label" width="60px" align="right">
										产品名称:
				                </td>
				                <td colspan="1" width="20%" align="left">
				                    <input id="vCFundCode_TCYCCX" width="100%" class="nui-buttonedit" name="paramObject/vCFundCode" onbuttonclick="ButtonClickGetFundName_TCYCCX"/>
				                </td>
				                <td width="30%">
			                		<input class='nui-button' plain='false' text="查询" iconCls="icon-search" onclick="search_TCYCCX()"/>
			                		<input class='nui-button' plain='false' text="重置" iconCls="icon-cancel"  onclick="resetDire_TCYCCX()"/>
			                    	<input class='nui-button' plain='false' id="export_TCYCCX" text="导出" iconCls="icon-download" onclick="export_TCYCCX()"/>
			                		<input class="mini-checkbox" text="自动隐藏无业务列" iconCls="icon-search" onvaluechanged="hideEmptyColums" />
			                		<input class="mini-checkbox" id="hideDetailColums" text="自动隐藏业务明细列" iconCls="icon-search" onvaluechanged="hideDetailColums" />
				                </td>
	            		</tr>
							</table>
						</form>
					  </div>
				   </div>
				   <%-- 头寸管理查询条件结束!!! --%>
		   
	   			 <%-- 头寸管理表列表开始... --%>
           <div class="nui-fit">
                <div 
                    id="datagrid_TCYCCX"
                    dataField="resultObjectList"
                    class="nui-datagrid"
                    style="width:100%;height:100%;"
                    url="com.cjhxfund.jy.ProductProcess.CashFlow.positionForecastManage.biz.ext"
                    pageSize="500"
                   	showPageInfo="true"
                    allowSortColumn="true"
                    sortMode="client"
                    enableHotTrack="true"
                    allowHeaderWrap="true"
                    sizeList="[10,20,50,500]"
                    allowCellEdit="true"
					allowCellSelect="true"
					enterNextCell="true"
					allowMoveColumn="true"
					editNextOnEnterKey="true"
					multiSelect="true"   
					showfooter="false"
					showSummaryRow="true"
					cellEditAction="celldblclick">
                    <div property="columns">
                        <div type="indexcolumn" width="40px">序号</div>
                        <div field="lDate" name="lDate" headerAlign="center" allowSort="true" align="left" width="80px">
            		 	日期
				        </div>
				        <div field="vcFundCode" name="vcFundCode" headerAlign="center" allowSort="true" align="left" width="80px">
            	 		产品代码
			            </div>
			            <div field="vcFundName" name="vcFundName" headerAlign="center" allowSort="true" align="left" width="180px">
        				产品名称
				        </div>
                        <div field="vcAssetName" name="vcAssetName" headerAlign="center" align="left" width="120px">
                                                                                    单元名称
                        </div>
                        <div field="beginCash" headerAlign="center" dataType="currency" align="right" width="120px">
               	 		期初现金
                        </div>
                        <div field="netInflowBal" headerAlign="center" dataType="currency" align="right" width="130px">
			 			净流入金额
                        </div>
                        <div field="t0CashEnableBalInvest" headerAlign="center" dataType="currency" align="right" width="120px">
                		T+0头寸-投资端
                        </div>
                        <div field="t1CashEnableBalInvest" headerAlign="center" dataType="currency" align="right" width="130px">
                		T+1头寸-投资端
                        </div>
                        <div field="t1CashEnableBalTrade" headerAlign="center" dataType="currency" align="right" width="130px">
                		T+1头寸-交易端
                        </div>
                        <div field="riskSettleMargin" headerAlign="center" dataType="currency" align="right" width="130px">
			  			风险备付金
                        </div>
                        <div field="settleReserveBal" headerAlign="center" dataType="currency" align="right" width="140px">
            			结算备付金
                        </div>
                <div header="最大可融资金额" headerAlign="center" visible="false">
	                <div property="columns">
                        <div field="M_COL"  headerAlign="center" dataType="currency" align="right" width="140px">
               	M 交易所
                        </div>
                        <div field="N_COL" headerAlign="center" dataType="currency" align="right" width="120px">
	  						N 中债登
			  								</div>
								  			<div field="O_COL" headerAlign="center" dataType="currency" align="right" width="120px">
	  						O 上清所
								  			</div>
                        <div field="P_COL" headerAlign="center" dataType="currency" align="right" width="120px">
	  						P 合计
                        </div>
                    </div>
	            </div>
	            <div header="沪深交易所业务" headerAlign="center">
	                <div property="columns">
                        <div field="netStlGuarBal" headerAlign="center" dataType="currency" align="right" width="130px">
	  					交易所担保净流入
                        </div>
                        <div field="netStlNonGuarBal" headerAlign="center" dataType="currency" align="right" width="130px">
	  					交易所非担保净流入
                        </div>
                        <div field="stockBuyBal" headerAlign="center" dataType="currency" align="right" width="120px">
	  					证券买入(非债券)
                        </div>
                        <div field="stockSaleBal" headerAlign="center" dataType="currency" align="right" width="120px">
	  					证券卖出(非债券)
                        </div>
                        <div field="bondBuyBalGuar" headerAlign="center" dataType="currency" align="right" width="120px">
	  					债券买入(担保)
                        </div>
                        <div field="bondSaleBalGuar" headerAlign="center" dataType="currency" align="right" width="120px">
	  					债券卖出(担保)
                        </div>
                        <div field="bondBuyBalNonGuar" headerAlign="center" dataType="currency" align="right" width="150px">
	  					债券买入(非担保)
                        </div>
                        <div field="bondSaleBalNonGuar" headerAlign="center" dataType="currency" align="right" width="150px">
	  					债券卖出(非担保)
                        </div>
                        <div field="rzhgBal" headerAlign="center"  dataType="currency" align="right" width="150px">
                                                                                    场内正回购首期
                		</div>
                        <div field="rzhgExpireBal" dataType="currency" headerAlign="center" align="right" width="150px">
	  					场内正回购到期
                        </div>
                        <div field="rqhgBal" dataType="currency" headerAlign="center" align="right" width="150px">
	  					场内逆回购首期
                        </div>
                        <div field="rqhgExpireBal" headerAlign="center" dataType="currency" align="right" width="150px">
	  					场内逆回购到期
                        </div>
                        <div field="rzhgPactBal" headerAlign="center"  dataType="currency" align="right" width="150px">
            	                            协议正回购首期
                		</div>
                        <div field="rzhgExpireBalPact" headerAlign="center" dataType="currency" align="right" width="150px">
	  					协议正回购到期
                        </div>
                        <div field="rqhgBalPact" headerAlign="center" dataType="currency" align="right" width="150px">
	  					协议逆回购首期
                        </div>
                        <div field="rqhgExpireBalPact" headerAlign="center" dataType="currency" align="right" width="150px">
	  					协议逆回购到期
                        </div>
                   </div>
	            </div>
	            <div header="银行间业务" headerAlign="center">
	                <div property="columns">
                        <div field="netStlBalCibmZzd" headerAlign="center" dataType="currency" align="right" width="120px">
	  					银行间中债登净流入
                        </div>
                        <div field="netStlBalCibmSqs" headerAlign="center" dataType="currency" align="right" width="120px">
	  					银行间上清所净流入
                        </div>
                        <div field="bondBuyBalCibm" headerAlign="center" dataType="currency" align="right" width="120px">
  						债券买入
                        </div>
                        <div field="bondSaleBalCibm" headerAlign="center" dataType="currency" align="right" width="120px">
  						债券卖出
                        </div>
                        <div field="rzhgBalCibm" headerAlign="center" dataType="currency" align="right" width="150px">
	  					正回购首期
                        </div>
                        <div field="rzhgExpireBalCibm" headerAlign="center" dataType="currency" align="right" width="150px">
	  					正回购到期
                        </div>
                        <div field="rqhgBalCibm" headerAlign="center" dataType="currency" align="right" width="150px">
	  					逆回购首期
                        </div>
                        <div field="rqhgExpireBalCibm" headerAlign="center" dataType="currency" align="right" width="150px">
	 					逆回购到期
                        </div>
                     </div>
	            </div>
	            <div header="存款业务" headerAlign="center">
	                <div property="columns">
	                	<div field="depositBal" headerAlign="center" dataType="currency" align="right" width="130px">
	  					存款存入
                        </div>
                        <div field="depositExpireBal" headerAlign="center" dataType="currency" align="right" width="130px">
	  					存款到期
                        </div>
	                </div>
	            </div>
	            <div header="场外基金" headerAlign="center">
	                <div property="columns">
	                	<div field="applyFundBal" headerAlign="center" dataType="currency" align="right" width="130px">
	  					场外开基申购
                        </div>
                        <div field="redeemFundBal" headerAlign="center" dataType="currency" align="right" width="130px">
	  					场外开基赎回
                        </div>
	                </div>
	            </div>
	            <div header="港股业务" headerAlign="center" visible="false">
	                <div property="columns">
	                	<div field="shareBuyBalHgt" headerAlign="center" dataType="currency" align="right" width="130px">
	  					沪港通股票买入金额
                        </div>
                        <div field="shareSaleBalHgt" headerAlign="center" dataType="currency" align="right" width="130px">
	  					沪港通股票卖出金额
                        </div>
                        <div field="shareBuyBalSgt" headerAlign="center" dataType="currency" align="right" width="130px">
	  					深港通股票买入金额
                        </div>
                        <div field="shareSaleBalSgt" headerAlign="center" dataType="currency" align="right" width="130px">
	  					深港通股票卖出金额
                        </div>
                        <div field="shareBuyBalGgt" headerAlign="center" dataType="currency" align="right" width="130px">
	  					港股通股票买入金额
                        </div>
                        <div field="shareSaleBalGgt" headerAlign="center" dataType="currency" align="right" width="130px">
	  					港股通股票卖出金额
                        </div>
	                </div>
	            </div>
	            <div field="distributeBuyBal" headerAlign="center" dataType="currency" align="right" width="130px">
	  					新债分销买入
                </div>
            	<div header="付息兑付业务" headerAlign="center">
	                <div property="columns">
                        <div field="bondDxDfBalCsi" headerAlign="center" dataType="currency" align="right" width="150px">
	  					交易所债券兑付息
                        </div>
                        <div field="bondDxDfBalCibm" headerAlign="center" dataType="currency" align="right" width="150px">
	  					银行间债券兑付息
                        </div>
                        <div field="bondDxDfBal" headerAlign="center" dataType="currency" align="right" width="130px">
	  					债券兑付息
                        </div>
                    </div>
	            </div>
	            <div header="追加提取业务" headerAlign="center">
	                <div property="columns">
                        <div field="appendBal" headerAlign="center" dataType="currency" align="right" width="130px">
	  					追加
                        </div>
                        <div field="extractBal" headerAlign="center" dataType="currency" align="right" width="130px">
	  					提取
                        </div>
                        <div field="appendExtractBal" headerAlign="center" dataType="currency" align="right" width="130px">
	  					净追加
                        </div>
                    </div>
	            </div>
                        <div field="futuresMarginBal" headerAlign="center" dataType="currency" align="right" width="130px">
	  					期货保证金调整
                        </div>
                        <div field="otherBal" headerAlign="center" dataType="currency" align="right" width="130px">
	  					其他业务
                        </div>
                        <div field="manualAdjustBal" headerAlign="center" dataType="currency" align="right" width="130px">
	  					手工调整金额
                        </div>
                		</div>
                		<div field="lFundId" visible="false" headerAlign="center" align="false" width="130px">
            	 产品ID
                		</div>
                		<div field="lAssetId" visible="false" headerAlign="center" align="false" width="130px">
             	单元ID
                		</div>
                		<div field="lSettleDate" visible="false" headerAlign="center" align="false" width="130px">
             	交割日期
                		</div>
                </div>
            </div>
            <%-- 头寸管理表列表结束!!! --%>
	</div>
</div>	

<script type="text/javascript">
	nui.parse();
	nui.get("dateOne").disable();
	//定义全局变量，记录无业务列下标
	var noDataCols = 0;
	//设置默认时间 
	var preDate = "<%=preDate%>";
	var preDateOne = "<%=preDateOne%>";
	var preDateTwo = "<%=preDateTwo%>";
	nui.get("dateOne").setValue(preDate);
	nui.get("dateTwo").setValue(preDateOne);
	var grid_TCYCCX = nui.get("datagrid_TCYCCX");//产品头寸风险预测表
	
	//左下角提示语
	prompt();
	function prompt(){
		var lasttr = $('#datagrid_TCYCCX > div > div:eq(1) > div:eq(4)> div:eq(1) > table > tbody > tr:eq(1)');
		lasttr.html("<td colspan='6'><p style=color:red>&nbsp;&nbsp;提示：双击金额可查看业务详情。</p></td>");
	}
	
	var refreshInt = true;//刚刚打开页面时，投顾默认刷新，交易员默认不刷新
    var queryUserTypeTemp = "<%=request.getParameter("queryUserType")%>";
	if(queryUserTypeTemp!=null && queryUserTypeTemp!="" && queryUserTypeTemp!="null"){
		refreshInt = false;
	}
		
	//设置区间日期
	function setDate_TCYCCX(e){
		//预测未来两周数据
		if(e.value=="02"){
			nui.get("dateOne").setValue(preDate);
			nui.get("dateTwo").setValue(preDateTwo);
		}else{
			//预测未来一周数据
			nui.get("dateOne").setValue(preDate);
			nui.get("dateTwo").setValue(preDateOne);
		}
	}
	
	//查询
	function search_TCYCCX(){
		var fundCode = nui.get("vCFundCode_TCYCCX").getValue();
		if(fundCode==null || fundCode==""){
			nui.alert("查询条件中的产品名称不能为空！");
		}else{
			//设置默认开始和结束日期 
			var beginDate = DateUtil.toNumStr(nui.get("dateOne").getValue());
			var endDate = DateUtil.toNumStr(nui.get("dateTwo").getValue());
			nui.get("beginDate").setValue(beginDate);
			nui.get("endDate").setValue(endDate);
			if(beginDate>endDate){
				nui.alert("起始日期不能大于截止日期！");
				return;
			}
			search(grid_TCYCCX, "#form_TCYCCX");
		}
	}
	
	//重置查询条件
	function resetDire_TCYCCX(){
		var form = new nui.Form("form_TCYCCX");
		form.reset();
		//设置默认的起始日期
		nui.get("dateOne").setValue(preDate);
	}
	
	//自动隐藏显示明细列
	function hideDetailColums(e){
		var checked = false;
		if(this.checked == undefined){
			checked = e.checked;
		}else{
			checked = this.checked;//复选框是否被选中
		}	
		var detailColumns=new Array("stockBuyBal","stockSaleBal","bondBuyBalGuar","bondSaleBalGuar","bondBuyBalNonGuar","bondSaleBalNonGuar","rzhgBal","rzhgExpireBal","rqhgBal","rqhgExpireBal","rzhgPactBal","rzhgExpireBalPact","rqhgBalPact","rqhgExpireBalPact","bondBuyBalCibm","bondSaleBalCibm","rzhgBalCibm","rzhgExpireBalCibm","rqhgBalCibm","rqhgExpireBalCibm");
		var cols = grid_TCYCCX.columns;//获取列对象
		var lengthCols = cols.length;//总列数(多列合并列之后记为一列)
		//隐藏无业务列
		if(checked){
			//从1开始循环(忽略掉序号列)
			for(var i=1;i<lengthCols;i++){
				//获取列名的key值
				col = cols[i].field;
				//判断是否为合并列
				var isMerge = grid_TCYCCX.columns[i].columns;
				if(isMerge!=undefined){
					//合并单元格，再次双重遍历合并单元格的列行
					var mergeLength = grid_TCYCCX.columns[i].columns.length;
					for(var ii=0;ii<mergeLength;ii++){
						//获取列名的key值
						col = cols[i].columns[ii].field;
						//遍历明细列，看是不是要隐藏的明细列
						for(var j=0;j<detailColumns.length;j++){
							if(detailColumns[j] == col){
								grid_TCYCCX.hideColumn(cols[i].columns[ii]);
								break;
							}
						}
					}
				}
			}
		}else{
			for(var i=1;i<lengthCols;i++){
				//获取列名的key值
				col = cols[i].field;
				//判断是否为合并列
				var isMerge = grid_TCYCCX.columns[i].columns;
				if(isMerge!=undefined){
					//合并单元格，再次双重遍历合并单元格的列行
					var mergeLength = grid_TCYCCX.columns[i].columns.length;
					for(var ii=0;ii<mergeLength;ii++){
						//获取列名的key值
						col = cols[i].columns[ii].field;
						//遍历明细列，看是不是要隐藏的明细列
						for(var j=0;j<detailColumns.length;j++){
							if(detailColumns[j] == col){
								grid_TCYCCX.showColumn(cols[i].columns[ii]);
								break;
							}
						}
					}
				}
			}
		}
		//加上提示
		prompt();
	}
	
	//自动隐藏显示无业务列
	function hideEmptyColums(e){
		var checked = this.checked;//复选框是否被选中
		var cols = grid_TCYCCX.columns;//获取列对象
		var rows = grid_TCYCCX.data;//获取行对象
		var lengthCols = cols.length;//总列数(多列合并列之后记为一列)
		var lengthRows = rows.length;//总行数
		//隐藏无业务列
		if(checked){
			//从1开始循环(忽略掉序号列)
			for(var i=1;i<lengthCols;i++){
				//记录每一个非合并单元格的无数据列总行数
				var count=0;
				//获取列名的key值
				col = cols[i].field;
				//判断是否为合并列
				var isMerge = grid_TCYCCX.columns[i].columns;
				if(isMerge==undefined){
					//行遍历，并记录此列中有多少行数据为空
					for(var j=0;j<lengthRows;j++){
						if(rows[j][cols[i].field]==null||rows[j][cols[i].field]==""||rows[j][cols[i].field]=="0.00"){
							count++;
						}
					}
					//隐藏无数据列(非合并单元格)
					if(count==lengthRows){
						grid_TCYCCX.hideColumn(cols[i]);
					}
				}else{
					//合并单元格，再次双重遍历合并单元格的列行
					var mergeLength = grid_TCYCCX.columns[i].columns.length;
					for(var ii=0;ii<mergeLength;ii++){
						//记录每个合并单元格的无数据列总行数
						var mergeCount = 0;
						//获取列名的key值
						col = cols[i].columns[ii].field;
						//行遍历，并记录此列中有多少行数据为空
						for(var jj=0;jj<lengthRows;jj++){
							if(rows[jj][col]==null||rows[jj][col]==""||rows[jj][col]=="0.00"){
								mergeCount++;
							}
						}
						//隐藏无数据列(合并单元格)
						if(mergeCount==lengthRows){
							cols[i].columns[ii].visible=false;
						}
					}
				}
			}
		}else{
			//显示所有列
			for(var i=1;i<lengthCols;i++){
				//获取列是否为合并列
				var isMerge = grid_TCYCCX.columns[i].columns;
				if(isMerge==undefined){
					//将隐藏列显示(针对非合并列)
					if(cols[i].visible==false){
						grid_TCYCCX.showColumn(cols[i]);
					}
				}else{
					//合并单元格，遍历合并单元格的列行
					var mergeLength = grid_TCYCCX.columns[i].columns.length;
					for(var ii=0;ii<mergeLength;ii++){
						//将隐藏列显示(针对合并列)
						if(cols[i].columns[ii].visible==false){
							grid_TCYCCX.showColumn(cols[i].columns[ii]);
						}
					}
				}
			}
			var ischeck = nui.get("hideDetailColums").getValue();
			if(ischeck){
				hideDetailColums(nui.get("hideDetailColums"));
			}
		}
		//加上提示
		prompt();
	}
	
	//系统自动刷新页面--所有业务通用
	function autoRefreshFun(){
		refreshInt = true;//打开页面之后设置值为true
		activechangedFun();//同时刷新查询列表数据
	}
	//self.setInterval("autoRefreshFun()",60000*3);//设置自动刷新时间默认5分钟
	
	function activechangedFun(){
		search_TCYCCX();
	}
	<%-- 自动化头寸表开始... --%>
	//获取查询条件的基金名称
	function ButtonClickGetFundName_TCYCCX(e){
        ButtonClickGetFundName(this, null);
	}
	//合并单元格
	grid_TCYCCX.on("load", function () {
    	grid_TCYCCX.mergeColumns(["vcFundName","vcFundCode"]);
    	if(grid_TCYCCX.data.length == 0 ){
    		nui.alert("没有符合筛选的数据！");
    	}
    });
    //导出最新现金流水记录
    function export_TCYCCX(){
    	//导出
	    exportSubmit("export_TCYCCX", "form_TCYCCX", "T+N头寸预测查询表","TCYCCX");
    }
	<%-- 头寸预测表结束!!! --%>
	
	<%-- 双击击单元格明细处理 --%>
	grid_TCYCCX.on("celldblclick", function (e) {
		//获取表格对象
    	var row = e.row;
    	//获取列对象
    	var column = e.column;
    	var colField = column.field;
    	if(colField=="beginCash"){
    		var valDate = row.lDate;
    		if(valDate!=preDate){
    			return;
    		}
    		firstDetail(row,colField);
    	}else if(colField=="t0CashEnableBalInvest"||colField=="t1CashEnableBalTrade" ||colField=="t1CashEnableBalInvest"){
    		firstDetail(row,colField);
				//J净流入金额、交易所业务、银行间业务、债券一级业务、追加提取
    	}else if(colField=="applyFundBal"||colField=="redeemFundBal" || colField=="distributeBuyBal"){
    		secondDetail(row,colField);
    	}else if(colField=="depositBal"||colField=="depositExpireBal"){
    		//存款业务
    		thirdDetail(row,colField);
    	}else if(colField=="bondDxDfBalCsi"||colField=="bondDxDfBalCibm"){
    		//付息兑付业务
    		fourthDetail(row,colField);
    	}else if(colField=="appendBal"||colField=="extractBal"||colField=="futuresMarginBal"){
    		//追加提取、期货保障金业务
    		fifthDetail(row,colField);
    	}else if( colField=="bondBuyBalCibm"||colField=="bondSaleBalCibm"||colField=="rzhgBalCibm"
    			||colField=="rzhgExpireBalCibm"||colField=="rqhgBalCibm"||colField=="rqhgExpireBalCibm"){
    		//银行间业务
    		sixthDetail(row,colField);
    	}else if(  colField=="stockBuyBal"||colField=="stockSaleBal"||colField=="bondBuyBalGuar"||
 				colField=="bondSaleBalGuar"||colField=="bondBuyBalNonGuar"||colField=="bondSaleBalNonGuar"){
    		//交易所业务担保和非担保
			seventhDetail(row,colField);
    	}else if(  colField=="rzhgPactBal"||colField=="rzhgExpireBalPact"||
 				colField=="rqhgBalPact"||colField=="rqhgExpireBalPact"){
    		//交易所业务协议回购
			eighthDetail(row,colField);
    	}else if(  colField=="rzhgBal"||colField=="rzhgExpireBal"||
 				colField=="rqhgBal"||colField=="rqhgExpireBal"){
    		//交易所业务质押式回购
			ninthDetail(row,colField);
    	}
    	
    	
    });
    
    //交易所业务质押式回购
	function ninthDetail(row,colField){
			//跳转到详情页面
			nui.open({
			    	url : "<%=request.getContextPath() %>/ProductProcess/cashFlow/ninthDetail.jsp",
					title : "交易所业务明细",
					width : 1100,
					height: 500,
					onload: function () {
						var iframe = this.getIFrameEl();
						var data = { colType:colField,record:{secondData:row}};
						iframe.contentWindow.setData(data);
					},
					ondestroy: function (action) {
					}
				});
	}
    //交易所业务-协议回购
	function eighthDetail(row,colField){
			//跳转到详情页面
			nui.open({
			    	url : "<%=request.getContextPath() %>/ProductProcess/cashFlow/eighthDetail.jsp",
					title : "交易所业务明细",
					width : 1100,
					height: 500,
					onload: function () {
						var iframe = this.getIFrameEl();
						var data = { colType:colField,record:{secondData:row}};
						iframe.contentWindow.setData(data);
					},
					ondestroy: function (action) {
					}
				});
	}
    //交易所业务担保和非担保
	function seventhDetail(row,colField){
			//跳转到详情页面
			nui.open({
			    	url : "<%=request.getContextPath() %>/ProductProcess/cashFlow/seventhDetail.jsp",
					title : "交易所业务明细",
					width : 1100,
					height: 500,
					onload: function () {
						var iframe = this.getIFrameEl();
						var data = { colType:colField,record:{secondData:row}};
						iframe.contentWindow.setData(data);
					},
					ondestroy: function (action) {
					}
				});
	}
    //银行间业务
	function sixthDetail(row,colField){
			//跳转到详情页面
			nui.open({
			    	url : "<%=request.getContextPath() %>/ProductProcess/cashFlow/sixthDetail.jsp",
					title : "银行间业务明细",
					width : 1100,
					height: 500,
					onload: function () {
						var iframe = this.getIFrameEl();
						var data = { colType:colField,record:{secondData:row}};
						iframe.contentWindow.setData(data);
					},
					ondestroy: function (action) {
					}
				});
	}
    
	//期初存款、T+0头寸、T+1头寸明细展示
	function firstDetail(row,colField){
    //跳转到详情页面
		nui.open({
		    url : "<%=request.getContextPath() %>/ProductProcess/cashFlow/firstDetail.jsp",
			title : "总头寸计算明细",
			width : 1100,
			height: 500,
			onload: function () {
				var iframe = this.getIFrameEl();
				var data = { colType:colField,record:{firstData:row}};
				iframe.contentWindow.setData(data);
    		},
			ondestroy: function (action) {
				//grid_TCYCCX.reload();
			}
		});
	}
	//交易所业务、银行间业务、债券一级分销业务
	function secondDetail(row,colField){
		var secondTitle = "";
		if(colField=="applyFundBal"||colField=="redeemFundBal"){
			secondTitle = "场外业务明细";
		}else if(colField=="distributeBuyBal"){
			secondTitle = "债券一级分销业务明细";
		}
		//跳转到详情页面
		nui.open({
		    	url : "<%=request.getContextPath() %>/ProductProcess/cashFlow/secondDetail.jsp",
				title : secondTitle,
				width : 1100,
				height: 500,
				onload: function () {
					var iframe = this.getIFrameEl();
					var data = { colType:colField,record:{secondData:row}};
					iframe.contentWindow.setData(data);
				},
				ondestroy: function (action) {
					//grid_TCYCCX.reload();
				}
			});
	}
			//存款业务明细展示
	function thirdDetail(row,colField){
		//跳转到详情页面
		nui.open({
	    	url : "<%=request.getContextPath() %>/ProductProcess/cashFlow/thirdDetail.jsp",
			title : "存款业务明细",
			width : 1100,
			height: 500,
			onload: function () {
				var iframe = this.getIFrameEl();
				var data = { colType:colField,record:{thirdData:row}};
				iframe.contentWindow.setData(data);
    		},
			ondestroy: function (action) {
				//grid_TCYCCX.reload();
			}
		});
	}
	//付息兑付业务明细展示
	function fourthDetail(row,colField){
		//跳转到详情页面
		nui.open({
		    url : "<%=request.getContextPath() %>/ProductProcess/cashFlow/fourthDetail.jsp",
			title : "付息兑付业务明细",
			width : 1100,
			height: 500,
			onload: function () {
				var iframe = this.getIFrameEl();
				var data = { colType:colField,record:{fourthData:row}};
				iframe.contentWindow.setData(data);
			},
			ondestroy: function (action) {
				//grid_TCYCCX.reload();
			}
		});
	}
	//追加提取、期货保证金业务
	function fifthDetail(row,colField){
		var fifthTitle = "";
		if(colField=="appendBal"){
			fifthTitle = "委托人追加业务明细";
		}else if(colField=="extractBal"){
			fifthTitle = "委托人提取业务明细";
		}else if(colField=="futuresMarginBal"){
			fifthTitle = "期货保证金调整金额明细";
		}
		//跳转到详情页面
		nui.open({
		    url : "<%=request.getContextPath() %>/ProductProcess/cashFlow/fifthDetail.jsp",
			title : fifthTitle,
			width : 1100,
			height: 500,
			onload: function () {
				var iframe = this.getIFrameEl();
				var data = { colType:colField,record:{fifthData:row}};
				iframe.contentWindow.setData(data);
			},
			ondestroy: function (action) {
				//grid_TCYCCX.reload();
			}
		});
	}
	function columnWidthAutoResize(grid){  
               var cls=new Array("vcFundCode","vcFundName","vcAssetName","beginCash","netInflowBal","t0CashEnableBalInvest","t1CashEnableBalInvest","t1CashEnableBalTrade","riskSettleMargin","settleReserveBal");//需要自适应的列的名称
               var columns = grid.getColumns();
               var colToIndex = {};
               //得到需要自动适应宽度的列的id
               for(var i =0;i<columns.length;i++){
               		if(columns[i]._id){
               			colToIndex[columns[i].field] = columns[i]._id;
               		}
               };
               
               var rows=grid.data;//得到行数据  
                 var columnMaxCharacter=new Array();//该列最大字符数  
                  //遍历所有行数据,获得该列数据的最大字符数  
                  for(var i=0;i<rows.length;i++){  
                     for(var j=0;j<cls.length;j++){//遍历需要设置的列  
                         var s=eval("rows["+i+"]."+cls[j])+"";  
                         //屏蔽html标签  
                          s=s.replace("<center>","");  
                          s=s.replace("</center>","");  
                         if((typeof columnMaxCharacter[cls[j]])=='undefined'){  
                             columnMaxCharacter[cls[j]]=0;  
                         }  
                           
                        if(s.length>columnMaxCharacter[cls[j]]){  
                            columnMaxCharacter[cls[j]]=s.length;  
                         }  
                          
                     }  
                  }  
                        
                  //设置列宽度和字体  
                  for(var j=0;j<cls.length;j++){  
                      var fontSize=12;  
                      var w=fontSize*(columnMaxCharacter[cls[j]]);//求出宽度  
                      //设定该列的宽度  
                      //设置表头的宽度
                      
                      $("#"+colToIndex[cls[j]]).width(w);
                      //设置表body的宽度
                      var tr = $('#datagrid_TCYCCX> div > div:eq(1) > div:eq(3)> div:eq(1) > div > table > tbody > tr:eq(0)');
                      for(var i=0;i<tr.children().length;i++){
                      		if(tr.children()[i].id == colToIndex[cls[j]]){
                      			$(tr.children()[i]).css({"width":w});
                      			break;
                      		}
                      }
                      
                  }  
         }
         
        var detailData = new Array();
		detailData[6] = "当日：期初现金=日初活期存款+当日上午场内清算款-风险备付金。风险备付金=净资产*1%，取整且不超过300万。预测日：期初现金=上一交易日的“T+1头寸-投资端”。";
		detailData[7] = "该行各业务类型资金净流入的汇总金额。当日的净流入金额不包含当日上午的场内清算款；预测日的净流入金额包括预测日上午的场内清算款。";
		detailData[8] = "在‘期初现金”的基础上，场外和交易所非担保等投资指令下达（包含买入和卖出），则头寸实时增减。包含指令未成交和指令已成交部分。";
		detailData[9] = "在“T+0头寸-投资端”的基础上，场内担保结算的投资指令下达（包含买入和卖出），则头寸实时增减。包含指令未成交和指令已成交部分。";
		detailData[10] = "在“T+0头寸-投资端”的基础上，场内担保结算的交易前台成交（包含买入和卖出），则头寸实时增减。只包含指令已成交部分。";
		
		//dategrid渲染完毕后自动适应列 
		grid_TCYCCX.on("update", function () {
			//columnWidthAutoResize(grid_TCYCCX);
			onHeaderShowDetail('datagrid_TCYCCX',detailData); 
			prompt();
			drawRows();
        }); 
        
        //表格行增加样式
		grid_TCYCCX.on("drawcell", function (e) {
			var field = e.field,
		   	value = e.value;
			//设置行样式
			if(field == "t0CashEnableBalInvest" || field == "t1CashEnableBalTrade" || field == "t1CashEnableBalInvest"){
				if(value< 0){
						e.cellStyle="color:#FF0000";
		    		}
			}
		});
		//绘画行的线
		function drawRows(){
		var rows = grid_TCYCCX.data;//获取行对象
		var lengthRows = rows.length;//总行数
			for(var i=0;i<lengthRows-1;i++){
				//找到产品的合并行的最后一行在第几行
				if(rows[i].vcFundCode != rows[i+1].vcFundCode){
					//datagrid自身有两行属性行，从下一个产品的上边框加粗所以行号要+3
					var taketr1 = $('#datagrid_TCYCCX> div > div:eq(1) > div:eq(3)> div:eq(1) > div > table > tbody > tr:eq('+(i+3)+')').children();
					taketr1.css({
						"border-top":"solid",
						"border-top-width": "3px",
						"border-top-color": "#D2D2D2"
					});
				}
			}
		}
				
</script>
</body>
</html>