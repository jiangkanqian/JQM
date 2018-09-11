<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/JQMHistory/common/commscripts.jsp" %>	
<!-- 
  - Author(s): jiangkanqian
  - Date: 2018-05-16 14:00:29
  - Description:
-->
<head>
<title>交易管理出入金</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/common/css/instruct.css"/>
	<script type="text/javascript" src="<%= request.getContextPath() %>/instruction/instructionUtil/instruction.js"></script>
	<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/com.cjhxfund.js.base/utils/SaveCondition.js"></script>
</head>
<body style="width:100%;height:100%;">
<div style="margin:0px 2px 0px 2px;width:100%;height:100%;" >
	<div id="tab" activeIndex="0" onactivechanged="activechangedFun" style="width:100%;height:100%;">
			   <div class="search-condition">
				   <div class="list">
					   <div id="form_today_instruct" class="nui-form" style="padding:2px;" align="center" style="height:10%">
					   		<!-- 业务标签:1-投顾端、2-交易员端 -->
		   					<input class="nui-hidden" id="queryType" name="queryType" value="2"/>							
			                <table id="instruct_follow_condition" border="0" cellpadding="1" cellspacing="1" style="width:100%;table-layout:fixed;">
				                <tr>
			                		<td class="form_label" width="60px">
										产品名称:
			                        </td>
			                        <td colspan="1" width="200px">
			                            <input id="vcProductCode" class="nui-buttonedit" name="vcProductCode" emptyText="全部" showClose="true" oncloseclick="onCloseClick" onbuttonclick="ButtonClickGetFundName_todayInstruct" style="width:95%"/>
			                        </td>
									<td width="60px" class="form_label">委托方向:</td>
									<td colspan="1" width="180px">
										<input class="nui-dictcombobox" id="vcEntrustDirection" name="vcEntrustDirection" multiSelect="true"
											valueField="dictID" textField="dictName" dictTypeId="goldEentrustDirection" 
											emptyText="全部" showClose="true" oncloseclick="onCloseClick" style="width:95%"/>
									</td>
									<td class="form_label" width="60px">交易日期:</td>
									<td colspan="1" width="290px">
										<input class="nui-datepicker" name="lTradeDateMin" style="width:120px" id="lTradeDateMin" showClose="true" oncloseclick="onCloseClick"/>
			                    		<span style="width:50px;" align="left">-</span>
										<input class="nui-datepicker" name="lTradeDateMax" style="width:120px" id="lTradeDateMax" showClose="true" oncloseclick="onCloseClick"/>
									</td>
									<td width="60px" class="form_label">代理行:</td>
									<td colspan="1" width="200px">
										<input class="nui-combobox" id="vcAgentBank" name="vcAgentBank" multiSelect="true"
										url="com.cjhxfund.ats.instruction.InterestSwap.InterestSwapInstruction.queryAgentBank.biz.ext"
										textField="vcAgentBank" valueField="vcAgentBank" dataField="banks"/>
									</td>
								</tr>
								<tr>
									<td colspan="7" align="left">
				                		<input class='nui-button' plain='false' text="查询" iconCls="icon-search" onclick="search()"/>
				                		<input class='nui-button' plain='false' text="重置" iconCls="icon-reset" onclick="reset()"/>
				                		<a class="nui-menubutton " plain="false" menu="#popupMenu"
			                               id="searchCond"
			                               name="searchCond"
			                               data-options='{formId:"form_today_instruct"}'
			                               iconCls="icon-add">保存查询条件</a>
			                            <ul id="popupMenu" class="mini-menu" style="display:none;"></ul>
				                	</td>
								</tr>
							</table>
						</div>
				  </div>
			   </div>

		<%-- 列表操作工具开始... --%>
		<div class="nui-toolbar" style="border-bottom:0;padding:0px;">
	    	<table style="width:100%;table-layout:fixed;">
	            <tr>
	                <td style="width:75%;">
	                	<a id="viewFlowChart" enabled="false" class='nui-button' plain='false' iconCls="icon-search" onclick="viewFlowChart()">查看流程图</a>&nbsp;
	                  	<a class='nui-button' plain='false' iconCls="icon-download" id="export_todayInstruct" onclick="exportExcel()">导出</a>&nbsp;
	                <td align="right">
	                    <a class='nui-button' plain='false' iconCls="icon-reload" onclick="autoRefreshFun()">刷新</a>
	                    <input id="autoRefresh" class="nui-combobox" style="width:90px;" 
		                    value="180" showNullItem="false" allowInput="false"
		                    data="[
						    { id: 0, text: '不自动刷新' },
						    { id: 15, text: '每15秒刷新' },
						    { id: 30, text: '每30秒刷新' },
							{ id: 60, text: '每1分刷新' },
							{ id: 120, text: '每2分刷新' },
							{ id: 180, text: '每3分刷新' },
							{ id: 300, text: '每5分刷新' },
							{ id: 600, text: '每10分刷新' },
							{ id: 1200, text: '每20分刷新' },
							{ id: 1800, text: '每30分刷新' }]"/>&nbsp;&nbsp;
	            	</td>
	            </tr>
	        </table>
	    </div>
		        
		        <div class="nui-fit" style="width:100%;height:100%;overflow:hidden;">
		            <div id="treegrid_todays_instruct" class="nui-treegrid" style="width:100%;height:100%;"
				 		url="com.cjhxfund.ats.instruction.InterestSwap.InterestSwapInstruction.queryGoldInfo.biz.ext" 
				 		dataField="insructInfos" treeColumn="lInstructNo"
				 		showPager="true" pageSize="20" frozenStartColumn="0" frozenEndColumn="6"
				 		showTreeIcon="false" showTreeLines="false" multiSelect="true"
				 		sizeList="[20,50,100,200,500,1000]"
				 		showReloadButton="false"
				 		onbeforeload="onBeforeTreeLoad"
				 		onselectionchanged="selectionchanged"
				 		pagerButtons="#prompt_todays"
				 		virtualScroll="true"
				 		sortField="" sortOrder=""
				 		enableHotTrack="false"
				 		idField="lGoldId"
	             		onselect="onSelect"
	             		ondeselect="onDeselect"
	             		onload="onGridLoad"
				 	>		
		                    <div property="columns">
		                        <div type="checkcolumn"></div>
		                        <div name="action" width="60px" align="center" headerAlign="center" headerallowSort="true" renderer="operate">操作</div>
		                        <div field="vcProductName" headerAlign="center" allowSort="true" 
		                        align="center" width="200px">
		                            产品名称
		                        </div>
		                        <div field="vcCombiName" headerAlign="center" allowSort="true" 
		                        align="left">
		                           组合名称
		                        </div>
		                        <div field="lTradeDate" headerAlign="center" allowSort="true" 
		                        align="left">
		                            交易日期
		                        </div>
		                        <div field="vcEntrustDirection" headerAlign="center" allowSort="true" 
		                        align="center" renderer="vcEntrustDirectionRender">
		                            委托方向
		                        </div>
		                        <div field="lGoldCapital" headerAlign="center" allowSort="true" 
		                        align="center">
		                           金额（万元）
		                        </div>
		                        <div field="vcAgentBank" headerAlign="center" allowSort="true" 
		                        align="left" width="200px">
		                            代理行
		                        </div>
		                        <div field="vcAgentName" headerAlign="center" allowSort="true" 
		                        align="left" width="200px">
		                           代理行账户名称
		                        </div>		                        
		                        <div field="lAgentNo" width="200px" headerAlign="center" allowSort="true" align="left">
		                            代理行账号
		                        </div>		                        
		                        <div field="cIsValid" headerAlign="center" allowSort="true" 
		                        align="left" renderer="renderInstructStatus">
		                            交易状态
		                        </div>
		                        <div field="tInputTime" headerAlign="center" allowSort="true" 
		                        align="center" renderer="resultRenderInput" width="200px">
		                            录入时间
		                        </div>
		                        <div field="tReviewTime" headerAlign="center" allowSort="true" 
		                        align="center" renderer="RenderReviewTime" width="200px">
		                             复核时间
		                        </div>
		                        <div field="tClientTime" headerAlign="center" allowSort="true" 
		                        align="center" renderer="RenderClientTime" width="200px">
		                            确认时间
		                        </div>
		                        <div field="tTraderfTime" headerAlign="center" allowSort="true" 
		                        align="center" renderer="RenderTraderfTime" width="200px">
		                            交易员1确认时间
		                        </div>
		                        <div field="tTradesTime" headerAlign="center" allowSort="true" 
		                        align="center" renderer="RenderTradersTime" width="200px">
		                            交易员2复核时间
		                        </div>
		                        <div field="tInvestmanagerTime" headerAlign="center" allowSort="true" 
		                        align="center" renderer="RenderInvestTime" width="200px">
		                            投资经理审批时间
		                        </div>
		                        <div field="tComdepTime" headerAlign="center" allowSort="true" 
		                        align="center" renderer="RenderComdepTime" width="200px">
		                            综合部用印时间
		                        </div>
		                        <div field="tCapitalclearTime" headerAlign="center" allowSort="true" 
		                        align="center" renderer="RenderCapitalclearTime" width="200px">
		                            资金清算时间
		                        </div>	                        
		                        <div field="lInstructNo" headerAlign="center" allowSort="true" 
		                        align="center">
		                           指令/建议序号
		                        </div>
		                        <div field="vcInstructSource" headerAlign="center" allowSort="true" 
		                        align="center"  renderer="InstructResource">
		                           指令/建议来源
		                        </div>
		                        <div field="vcRemark" headerAlign="center" allowSort="true" 
		                        align="center" width="250px">
		                           备注
		                        </div>
		                     </div>
		                </div>
		                
		 <div id="prompt_todays">
	        <span class="separator"></span>
	        <div class="investdata"></div>
	   		<div style= "display:inline-block; margin-right: 8px;">录单已确认</div>
	       	<div class="tradedate"></div>
	        <div style= "display:inline-block; margin-right: 8px;">审批已通过</div>
	      	<div class="closedata"></div>
	    	<div style= "display:inline-block;">资金清算已完成 </div>
	     	<div class="invaliddata"></div>
	        <div style= "display: inline-block; margin-right: 8px;">无效</div>
	       	<div class="backdata"></div>
	        <div style= "display:inline-block; margin-right: 8px;">已修改</div>
		</div>
		                
		             </div>
		        </div>
	
		<!-- 导出参数 -->
	<div>
		<form id="export_FROM" method="post">
			<!-- 业务标签:当日指令/建议 -->
			<input class="nui-hidden" id="exportGoldId" name="paramObject/exportGoldId">
			<input class="nui-hidden" id="exportIselect" name="paramObject/exportIselect">
	   		<input class="nui-hidden" id="exportQueryType" name="paramObject/exportQueryType" value="2"/>
			<input class="nui-hidden" id="exportProductCode" name="paramObject/exportProductCode">
			<input class="nui-hidden" id="exportTradeDateMin" name="paramObject/exportTradeDateMin">
			<input class="nui-hidden" id="exportTradeDateMax" name="paramObject/exportTradeDateMax">
			<input class="nui-hidden" id="exportEntrustDir" name="paramObject/exportEntrustDir">
			<input class="nui-hidden" id="exportAgentBank" name="paramObject/exportAgentBank">				
		</form>	
	</div>
	<!-- 导出参数结束 -->
		            
	</div>
  	
  	<!--隐藏表单-->
	<form action="" name="openForm" method="post" target="_blank">
	</form>
  	
	<script type="text/javascript">
    	nui.parse();
    	
    	var date = new Date();
    	var todayDate = DateUtil.toNumStr(date);
		nui.get("lTradeDateMin").setValue(todayDate);
		nui.get("lTradeDateMax").setValue(todayDate);
		var isLoad = "true";
    	var today_instruct = new nui.Form("#form_today_instruct");
    	var todays_instruct_grid = nui.get("treegrid_todays_instruct");
    	var isSigleSelectChanged = false;
    	var selectArr = [];//已选的记录数组
    	
    	// 添加指令
		function addGold(){
    		nui.open({
	    		url:"<%=request.getContextPath() %>/instruction/interestSwap/newGold.jsp",
    			title:"下达投资指令/建议", 
    			width:600,
    			height:450, 			
    			ondestroy: function (action) {
					search();
    			}
    		});	
		}
    	
    	//自动刷新功能处理
    	var autoRefreshValOld = nui.get("autoRefresh").getValue();//获取默认自动刷新时间
	    var autoRefreshReturnVal= self.setInterval("autoRefreshFun()",eval(autoRefreshValOld)*1000);//设置自动刷新时间默认3分钟
    	//刷新
		function autoRefreshFun(){
	    	autoSearch();//同时刷新查询列表数据
	    	var autoRefreshVal = nui.get("autoRefresh").getValue();//获取最新自动刷新时间
	    	//若最新获取的自动刷新时间与历史自动刷新时间不等，则关闭之前的定时器，以新的自动刷新时间新建定时器，并将新值赋予历史自动刷新时间变量
	    	if(autoRefreshVal!=autoRefreshValOld){
	    		autoRefreshValOld = autoRefreshVal;//将新值赋予历史自动刷新时间变量
	    		clearInterval(autoRefreshReturnVal);//关闭之前的定时器
	    		if(autoRefreshValOld!="0"){
	    			autoRefreshReturnVal = setInterval("autoRefreshFun()", eval(autoRefreshValOld)*1000);//以新的自动刷新时间新建定时器
	    		}
	    	}
	    }
	    
	    //Grid加载完成后选中之前已选中的记录
	    function onGridLoad(e) {
    		var rows = selectArr;
	        if(rows) todays_instruct_grid.selects(rows);
	    }
	    
	    //行选中时发生
	    function onSelect(e){
	    	var record = e.record;
	    	var isExist = false;
	    	for(var i=0; i<selectArr.length; i++){
	    		var row = selectArr[i];
	    		if(row.lGoldId==record.lGoldId){
	    			selectArr[i] = record;
	    			isExist = true;//若之前已选中，则直接返回
	    			break;
	    		}
	    	}
	    	//若之前尚未选中该记录，则新增该记录到数组中
	    	if(isExist==false){
	    		selectArr.push(record);
	    	}
	    }
	    
	    //行取消选中时发生
	    function onDeselect(e){
	    	var record = e.record;
	    	var selectArrTemp = selectArr;//将原数组赋予临时数组
	    	selectArr = [];//将原数组清空，重新赋值
	    	for(var i=0; i<selectArrTemp.length; i++){
	    		var row = selectArrTemp[i];
	    		if(row.lGoldId!=record.lGoldId){//将原来数组中不等于取消选中行的记录重新放回去
	    			selectArr.push(row);
	    		}
	    	}
	    }
	    
	   //查询--所有业务通用
	function autoSearch() {
	//获取之前选中记录的主键ID，刷新后继续选中之前记录
	var rows_search = selectArr;
	var rowIds_search = "";
	for(var i=0; i<rows_search.length; i++){
		rowIds_search += rows_search[i].lGoldId;
		if(i<rows_search.length-1){
			rowIds_search += ",";
		}
	}
	//开始查找记录
    var form = new nui.Form(today_instruct);
    var json = form.getData(false,false);
    todays_instruct_grid.load(json,function(){
    	//选中刷新前选中的记录
    	var rows = todays_instruct_grid.findRows(function (row) {
    		var exist = false;
    		if(rowIds_search!=null && rowIds_search!=""){
    			var rowIdsArr = rowIds_search.split(",");
    			for(var i=0; i<rowIdsArr.length; i++){
    				if (row.lGoldId == rowIdsArr[i]){
	                	exist = true;
	                	break;
	                }
    			}
    		}
    		return exist;
        });
        todays_instruct_grid.selects(rows);
    	});
	}
	
	function onBeforeTreeLoad(e) {
        	var params = e.params;  //参数对象
        	
	        //可以传递自定义的属性
			var initParam = new nui.Form("#form_today_instruct").getData(false,false);
			//产品名称
			initParam["vcProductCode"] = splitString(initParam["vcProductCode"]);
        	//交易日期
        	if(initParam.lTradeDateMin != null && initParam.lTradeDateMin != ""){
        		initParam.lTradeDateMin = DateUtil.toNumStr(initParam.lTradeDateMin);
        	}else{
        		if(isLoad != "true")
        			initParam.lTradeDateMin = DateUtil.toNumStr(new Date());
        	}
        	if(initParam.lTradeDateMax != null && initParam.lTradeDateMax != ""){
        		initParam.lTradeDateMax = DateUtil.toNumStr(initParam.lTradeDateMax);
        	}else{
        		if(isLoad != "true")
        			initParam.lTradeDateMax = DateUtil.toNumStr(new Date());
        	}
        	//委托方向
        	if(initParam.vcEntrustDirection != null && initParam.vcEntrustDirection != ""){
        		initParam["vcEntrustDirection"] = nui.get("vcEntrustDirection").getValue();
        	}
        	//代理行
        	if(initParam.vcAgentBank != null && initParam.vcAgentBank != ""){
        		initParam["vcAgentBank"] = nui.get("vcAgentBank").getValue();
        	}     	       	
        	initParam["queryType"] = nui.get("queryType").getValue();
	        params.paramObject = initParam;
	   }
	
	   //设置指令/建议列表数据显示颜色
    	todays_instruct_grid.on("drawcell", function (e) {
	        var record = e.record,
	        	field = e.field,
        		value = e.value;
			//设置行样式，交易状态：1-有效；2-无效-已修改；3-无效-已撤销；4-有效-被退回；
			if(record.cIsValid=="2"){
				e.rowCls = "instructStatus_2_zlgl";
			}else if(record.cIsValid=="3"||record.cIsValid=="4"||record.cIsValid=="5"||record.cIsValid=="6"||record.cIsValid=="7"||record.cIsValid=="8"){
				e.rowCls = "instructStatus_3_4_5_6_zlgl";
			}else if(record.cIsValid=="4"){
				e.rowCls = "instructStatus_4_zlgl";
			}else if(record.cIsValid=="1"){
				if(record.vcProcessState=="1"){
					e.rowCls = "processStatus_5or6_zlgl";
				}else if(record.vcProcessState=="2" || record.vcProcessState=="4"){
					e.rowCls = "processStatus_8_zlgl";
				}else if(record.vcProcessState=="3"){
					e.rowCls = "processStatus_9_zlgl";
				}
			}
			
			if (e.column.name == "action") {
			e.cellStyle = "text-align:center";
			if(e.row.workitemId == '0'){
				var url = '<%=request.getContextPath() %>'
				+"/com.cjhxfund.fpm.bpsExpend.getTaskInfo.flow?processInstID="
				+e.row.lProcessinstId;
				e.cellHtml = "<a class='nui-button' plain='false' style='cursor:pointer;text-decoration:underline;color:blue;'  onclick='wfOpenWin(\""+url+"\")'>查看</a>";
			} else {
				var url = "/com.cjhxfund.fpm.bpsExpend.getTaskInfo.flow?workItemID="+e.row.workitemId;
				e.cellHtml = "<a class='nui-button' plain='false' style='cursor:pointer;text-decoration:underline;color:blue;'  onclick='wfOpenWin(\""+url+"\")'>确认</a>";
			}
		} 
			
	    });
	    
	    
	   function wfOpenWin(url) {
		var winFrm=document.openForm;
		var actionURL= "";
		actionURL = '<%=request.getContextPath() %>'+"/"+url; //目标页面
		
		winFrm.action=actionURL;
		var newwin = window.open('about:blank', 'newWindow', '');
		winFrm.target = 'newWindow';//这一句是关键
		winFrm.submit();
	}
	
	function search(){
    		todays_instruct_grid.reload("com.cjhxfund.ats.instruction.InterestSwap.InterestSwapInstruction.queryGoldInfo.biz.ext");
      }
      
      function InstructResource(e){
	    	return nui.getDictText("instructResource", e.row.vcInstructSource);
	    } 
      
      function renderInstructStatus(e){
	    	return nui.getDictText("instructStatus",e.row.cIsValid);
	    }
      
      function resultRenderInput(e){
	    	if(e.row.vcInitiatorName!=null || e.row.vcInitiatorName!=""){
	    		return (e.row.vcInitiatorName==null?"":e.row.vcInitiatorName) + "　" + nui.formatDate(e.row.tInputTime, "yyyy-MM-dd HH:mm:ss");
			}else{
				return (nui.formatDate(e.row.tInputTime, "yyyy-MM-dd HH:mm:ss"));
			}
		}
    	
    	function RenderReviewTime(e){
	    	if(e.row.vcReviewName!=null || e.row.vcReviewName!=""){
	    		return (e.row.vcReviewName==null?"":e.row.vcReviewName) + "　" + nui.formatDate(e.row.tReviewTime, "yyyy-MM-dd HH:mm:ss");
			}else{
				return (nui.formatDate(e.row.tReviewTime, "yyyy-MM-dd HH:mm:ss"));
			}
		}
		
		function RenderClientTime(e){
	    	if(e.row.vcClientName!=null || e.row.vcClientName!=""){
	    		return (e.row.vcClientName==null?"":e.row.vcClientName) + "　" + nui.formatDate(e.row.tClientTime, "yyyy-MM-dd HH:mm:ss");
			}else{
				return (nui.formatDate(e.row.tClientTime, "yyyy-MM-dd HH:mm:ss"));
			}
		}
		
		function RenderTraderfTime(e){
	    	if(e.row.vcTraderfName!=null || e.row.vcTraderfName!=""){
	    		return (e.row.vcTraderfName==null?"":e.row.vcTraderfName) + "　" + nui.formatDate(e.row.tTraderfTime, "yyyy-MM-dd HH:mm:ss");
			}else{
				return (nui.formatDate(e.row.tTraderfTime, "yyyy-MM-dd HH:mm:ss"));
			}
		}
		
		function RenderTradersTime(e){
	    	if(e.row.vcTradesName!=null || e.row.vcTradesName!=""){
	    		return (e.row.vcTradesName==null?"":e.row.vcTradesName) + "　" + nui.formatDate(e.row.tTradesTime, "yyyy-MM-dd HH:mm:ss");
			}else{
				return (nui.formatDate(e.row.tTradesTime, "yyyy-MM-dd HH:mm:ss"));
			}
		}
		
		function RenderInvestTime(e){
	    	if(e.row.vcInvestmanagerName!=null || e.row.vcInvestmanagerName!=""){
	    		return (e.row.vcInvestmanagerName==null?"":e.row.vcInvestmanagerName) + "　" + nui.formatDate(e.row.tInvestmanagerTime, "yyyy-MM-dd HH:mm:ss");
			}else{
				return (nui.formatDate(e.row.tInvestmanagerTime, "yyyy-MM-dd HH:mm:ss"));
			}
		}
		
		function RenderComdepTime(e){
	    	if(e.row.vcComdepName!=null || e.row.vcComdepName!=""){
	    		return (e.row.vcComdepName==null?"":e.row.vcComdepName) + "　" + nui.formatDate(e.row.tComdepTime, "yyyy-MM-dd HH:mm:ss");
			}else{
				return (nui.formatDate(e.row.tComdepTime, "yyyy-MM-dd HH:mm:ss"));
			}
		}
		
		function RenderCapitalclearTime(e){
	    	if(e.row.vcCapitalclearName!=null || e.row.vcCapitalclearName!=""){
	    		return (e.row.vcCapitalclearName==null?"":e.row.vcCapitalclearName) + "　" + nui.formatDate(e.row.tCapitalclearTime, "yyyy-MM-dd HH:mm:ss");
			}else{
				return (nui.formatDate(e.row.tCapitalclearTime, "yyyy-MM-dd HH:mm:ss"));
			}
		}
    	
    	function vcEntrustDirectionRender(e){
    		return nui.getDictText("goldEentrustDirection", e.row.vcEntrustDirection);
    	}
    	
    	//获取查询条件的产品名称
		function ButtonClickGetFundName_todayInstruct(e){
	        ButtonClickGetFundName(this);
		}
		
		//跨页多选选择表格获取产品
		function ButtonClickGetFundName(buttonEditObj){
	        nui.open({
	            url: "<%=request.getContextPath()%>/sm/comm/instruct/productInfoCombi.jsp",
	            title: "产品列表",
	            width: 450,
	            height: 380,
	            onload:function(){
	            	
	                var iframe = this.getIFrameEl();
	                var fundCodes = buttonEditObj.getValue();
	                var fundNames = buttonEditObj.getText();
	                var data = {
	                   fundCodes:fundCodes,
	                   fundNames:fundNames
	                };
	                iframe.contentWindow.SetData(data);
	            },
	            ondestroy: function (action) {
	            	
	                if (action == "ok") {
	                    var iframe = this.getIFrameEl();
	                    var data = iframe.contentWindow.GetData();
	                    data = nui.clone(data);
	                    buttonEditObj.setValue(data.vcProductCode);
	                    buttonEditObj.setText(data.vcProductName);
	                }
	            }
	        });
		}
		
		//重置
       	function reset(){
    		today_instruct.clear();
    		nui.get("queryType").setValue("2");
    		nui.get("lTradeDateMin").setValue(todayDate);
			nui.get("lTradeDateMax").setValue(todayDate);
    	}
    	
    	function onCloseClick(e){
	    	var obj = e.sender;
            obj.setText("");
            obj.setValue("");
	    }
	    
	    //复制指令/建议
		function copyInstruct(rowid){
            var row = todays_instruct_grid.getRow(rowid);
			if(rowid == undefined){
				row = todays_instruct_grid.getSelected();			
			}
			var tabIndex = 0;
		    nui.open({
					url: "<%=request.getContextPath() %>/instruction/interestSwap/newGold.jsp",
					title: "复制增加",
					width:870,
    				height:482,
					onload: function () {
						var iframe = this.getIFrameEl();
						row["operatorType"] = "2";//0-新建指令/建议 1-编辑指令/建议 2-复制指令
				        iframe.contentWindow.initWin(row);
					},
					ondestroy: function (action) {
    					search();
    					selectionchanged();
					},
			});

		}
    	
    	//选择改变
    	function selectionchanged(){
    		var rows = selectArr;
			nui.get("viewFlowChart").disable();
			if(rows.length == 1){
				var row = rows[0];			
				nui.get("viewFlowChart").enable();								
			}
    	} 
    	
    	//修改
	    function edit(){
	    	var rows = selectArr;
	    	if(rows.length != 1){
				nui.alert("请先选中一条记录","提示");
				return;
			}
			var row = rows[0];
					
			nui.open({
					url: "<%=request.getContextPath() %>/instruction/interestSwap/newGold.jsp",
					title: "修改投资指令/建议",
					width:870,
    				height:507,
					onload: function () {
						var iframe = this.getIFrameEl();
						row["operatorType"] = "1"; //0-新建指令/建议 1-编辑指令/建议
				        iframe.contentWindow.initWin(row);
					},
					ondestroy: function (action) {
    					search();
    					selectionchanged();
					},
			});
	    }
    	
    	// 指令撤销
	    function onCancle(){
	    	var rows = selectArr;	    	
	    	if(rows.length == 0){
				nui.alert("请先选中一条记录！","提示");
				return;
			}else if(rows.length > 1){
				nui.alert("请先选择一条记录,只支持单条撤销！","提示");
				return;
			}
			var row = rows[0];
			if(row.cIsValid != 1){
				nui.alert("该指令/建议已无效，无需再做撤销操作","提示");
				return;
			}
			if(row.vcInstructSource=="3"){
				nui.open({
					url : nui.context + "/instruction/interestSwap/onCancelReason.jsp",
					title : "指令撤销",
					width : 500,
					height : 200,
					onload : function() {
						var iframe = this.getIFrameEl();
						row["operatorType"] = "3";
						row["type"]="gold"
						iframe.contentWindow.setData(row);
					},
					ondestroy : function(action) {
			            var iframe = this.getIFrameEl();
			            //获取选中、编辑的结果
			            var returnJson = iframe.contentWindow.getData();
			            if(returnJson!= null){
				            returnJson = nui.clone(returnJson);    //必须。克隆数据。
					        if(returnJson.exception == null){
								if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_SUCCESS%>"){
									nui.alert("当前指令序号为"+"["+row.lInstructNo+"],处理结果如下：</br>"+returnJson.rtnMsg,"提示",function(action){
						    			if(action == "ok"){						
						    				search();
						    			}
									});
								}else if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ERROR%>"){
									nui.alert("当前指令序号为"+"["+row.lInstructNo+"],处理结果如下：</br>"+returnJson.rtnMsg,"提示",function(action){
						    			if(action == "ok"){						
						    				search();
						    			}
									});
								}else if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ORDER_NO_RCV_FR_O32%>"){
									nui.alert("当前指令序号为"+"["+row.lInstructNo+"],处理结果如下：</br>"+returnJson.rtnMsg,"提示",function(action){
						    			if(action == "ok"){						
						    				search();
						    			}
									});
								}else{
									nui.alert("系统异常","提示",function(action){
						    			if(action == "ok"){						
						    				search();
						    			}
									});
								}
							}else{
								nui.alert("系统异常","提示",function(action){
					    			if(action == "ok"){						
					    				search();
					    			}
								});
							}
			            }else{
			            	if(action == "ok"){						
			    				search();			    				
			    			}
			            }
			            selectionchanged();
					}
				});
			}	
	    }
    	
    	todays_instruct_grid.on("rowdblclick", function (e) {
	    	if(e.row.workitemId == '0'){
				var url = '<%=request.getContextPath() %>'
				+"/com.cjhxfund.fpm.bpsExpend.getTaskInfo.flow?processInstID="
				+e.row.lProcessinstId;
			} else {
				var url = "/com.cjhxfund.fpm.bpsExpend.getTaskInfo.flow?workItemID="+e.row.workitemId;
			}
			wfOpenWin(url);		
	    });
		
		//查看流程图
		function viewFlowChart(){
			window.open(nui.context+"/com.cjhxfund.foundation.task.ProcessChart.flow?processInstID="+selectArr[0].lProcessinstId);
		}
    	
    	// 导出
        function exportExcel(){
        	//清空列表
        	new nui.Form("#export_FROM").clear();
        	
			var rows = selectArr;
			// 定义指令/建议序号
			var lGoldId = "";
			var iselect = "false";
			var msg = "您未选中指令/建议，将导出全部指令/建议，确定要导出吗?";
			if(rows.length>0){
				var iselect = "true";
				msg = "确定要导出吗?";
				for(var i=0; i<rows.length; i++){
					lGoldId+= rows[i].lGoldId+",";
				}
				//去掉最后一个逗号
			    if (lGoldId.length > 0) {
			        lGoldId = lGoldId.substr(0, lGoldId.length - 1);
			    }
			}
		    
		    // 设置导出form参数
			var initParam = new nui.Form("#form_today_instruct").getData(false,false);
			var vcProductCode = initParam["vcProductCode"];
			//产品名称
			if(vcProductCode != null && vcProductCode != ""){
				document.getElementById("exportProductCode").value = vcProductCode;
			}
        	//交易日期
        	if(initParam.lTradeDateMin != null && initParam.lTradeDateMin != ""){
        		document.getElementById("exportTradeDateMin").value = DateUtil.toNumStr(initParam.lTradeDateMin);
        	}else{
        		document.getElementById("exportTradeDateMin").value = DateUtil.toNumStr(new Date());
        	}
        	if(initParam.lTradeDateMax != null && initParam.lTradeDateMax != ""){
        		document.getElementById("exportTradeDateMax").value = DateUtil.toNumStr(initParam.lTradeDateMax);
        	}else{
        		document.getElementById("exportTradeDateMax").value = DateUtil.toNumStr(new Date());
        	}
        	//委托方向
        	if(initParam.vcEntrustDirection != null && initParam.vcEntrustDirection != ""){
        		document.getElementById("exportEntrustDir").value = nui.get("vcEntrustDirection").getValue();
        	}
        	//代理行
        	if(initParam.vcAgentBank != null && initParam.vcAgentBank != ""){
        		document.getElementById("exportAgentBank").value = nui.get("vcAgentBank").getValue();
        	}    	
        	       	
        	document.getElementById("exportQueryType").value = nui.get("queryType").getValue();
        	document.getElementById("exportIselect").value = iselect;
        	if(iselect == "true"){
        		document.getElementById("exportGoldId").value = lGoldId;
        	}
        	
			// 页面流跳转
			nui.confirm(msg,"系统提示",function(action){
				if(action=="ok"){
					nui.get("export_todayInstruct").disable();//禁用“导出”按钮
					var form = document.getElementById("export_FROM");				
					form.action = "com.cjhxfund.ats.instruction.InterestSwap.goldExcle.flow";
			        form.submit();
			        //启用“导出”按钮
			        setTimeout("enableExport()",15000);
				}
			});
		}
    	
    	function enableExport(){
	  		nui.get("export_todayInstruct").enable();
		}
    	
    </script>
</body>
</html>