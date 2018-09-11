<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/common.jsp" %>
<!-- 
  - Author(s): tongwei
  - Date: 2017-07-07 13:27:05
  - Description:当日指令/建议（指令/建议跟踪）
-->
<head>
	<title>投资管理-指令</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/common/css/instruct.css"/>
    <script type="text/javascript" src="<%= request.getContextPath() %>/scripts/com.cjhxfund.js.base/utils/DateUtil.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/scripts/com.cjhxfund.js.base/utils/SaveCondition.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/riskMgr/js/riskMgrComm.js"></script>
    
</head>
<body style="height:100%; width:100%; overflow:hidden; margin:0;padding:0;">
<div id="layout1" class="mini-layout" style="width:100%; height:100%;"  borderStyle="border:0px;">
	<div>
		<!-- 查询条件开始 -->
		<div class="search-condition">
		   <div class="list">
				<!-- 委托方向:01-买入  02–卖出  -->
				<input class="nui-hidden" id="entrustDirection" name="entrustDirection" value="'3','4'"/>
				<!-- 指令/建议有效状态:1-有效, 2-无效-已修改   3-无效-已撤销    4-无效-被退回  -->
				<!-- <input class="nui-hidden" id="cIsValid" name="cIsValid" value="1,3,4"/> -->
				<input class="nui-hidden" id="bizType" name="bizType" value="1,2,3,4,8,9"/>
			    <div id="form_today_instruct" class="nui-form" style="height:10%;max-width:100%" align="left">
			    	<!-- 业务标签:1-投顾端、2-交易员端 -->
		   			<input class="nui-hidden" id="queryType" name="queryType" value="1"/>
	                <table id="instruct_follow_condition" border="0" cellpadding="1" cellspacing="1" style="width:100%;table-layout:fixed;">
	                	<tr>
	                		<td width="60px" align="right">
								产品名称:
	                        </td>
	                        <td colspan="1" width="15%" align="left">
	                            <input id="vcProductCode" class="nui-buttonedit" name="vcProductCode" emptyText="全部" showClose="true" oncloseclick="onCloseClick" onbuttonclick="ButtonClickGetFundName_todayInstruct" style="width:95%"/>
	                        </td>
							<td width="60px" align="right">业务类别:</td>
							<td colspan="1" width="15%" align="left">
								<input class="nui-dictcombobox" id="vcBizType" name="vcBizType" multiSelect="true"
									valueField="dictID" textField="dictName" dictTypeId="bizTypeTransaction" 
									emptyText="全部" showClose="true" oncloseclick="onCloseClick" style="width:95%"/>
							</td>
							<td width="60px" align="right">委托方向:</td>
							<td colspan="1" width="9%" align="left">
								<input class="nui-dictcombobox" id="vcEntrustDirection" name="vcEntrustDirection" 
									valueField="dictID" textField="dictName" dictTypeId="entrustDirectionTransaction" 
									emptyText="全部" showClose="true" oncloseclick="onCloseClick" style="width:95%"/>
							</td>
							<!-- <td width="60px" align="right">指令/建议序号:</td>
							<td colspan="1" width="20%" align="left">
								<input class="nui-textbox" id="instructNo" name="instructNo" showClose="true" oncloseclick="onCloseClick" style="width:95%"/>
							</td> -->
							<td width="60px" align="right">交易状态:</td>
							<td colspan="1" width="9%" align="left">
								<input class="nui-combobox" id="instructValid"
		                           name="instructValid"
		                           textField="text"
		                           valueField="cIsValid"
		                           data="[{cIsValid: '1', text: '有效'}, {cIsValid: '2', text: '无效-已修改'}, {cIsValid: '3', text: '无效-已撤销'}, {cIsValid: '4', text: '无效-被退回'}, {cIsValid: '5', text: '修改审核中'}, {cIsValid: '6', text: '无效-修改未通过'},{cIsValid: '7', text: '无效-已过期'},{cIsValid: '8', text: '作废'}]"
		                           multiSelect="true"
		                           emptyText="全部"
		                           style="width:100%"
		                           oncloseclick="onCloseClick"
		                           showClose="true"/>
		                	</td>
							<td class="form_label" width="60px" align="right">交易日期:</td>
							<td colspan="1" width="20%" align="left">
								<input class="nui-datepicker" name="lTradeDateMin" id="lTradeDateMin" style="width:45%;" showClose="true" oncloseclick="onCloseClick"/>
	                    		<span style="width:5%;">-</span>
								<input class="nui-datepicker" name="lTradeDateMax" id="lTradeDateMax" style="width:45%;" showClose="true" oncloseclick="onCloseClick"/>
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
		<%-- 查询条件结束!!! --%>
	
		<%-- 列表操作工具开始... --%>
		<div class="nui-toolbar" style="border-bottom:0;padding:0px;">
	    	<table style="width:100%;table-layout:fixed;">
	            <tr>
	                <td style="width:75%;">
	                	<a id="addInstruct" class='nui-button' plain='false' iconCls="icon-add" onclick="addInstruct()">增加</a>
	                	<a id="copyInstruct" enabled="false" class='nui-button' plain='false' iconCls="icon-add" onclick="copyInstruct()">复制增加</a>&nbsp;
	                    <a id="edit" enabled="false" class='nui-button' plain='false' iconCls="icon-edit" onclick="edit()">修改</a>&nbsp;
	                    <a id="remove" enabled="false" class='nui-button' plain='false' iconCls="icon-remove" onclick="onCancle()">撤销</a>&nbsp;
	                  	<!-- <a class='nui-button' plain='false' iconCls="icon-print" onclick="">生成成交单</a>&nbsp;
	                  	<a class='nui-button' plain='false' iconCls="icon-upload">上传附件</a>&nbsp;-->
	                	<a id="batchConfirm" enabled="false" class='nui-button' plain='false' iconCls="icon-ok" onclick="batchConfirmTasks()">确认</a>&nbsp;
	                	<a id="backConfirm" enabled="false" class='nui-button' plain='false' iconCls="icon-no" onclick="backTasks()">退回</a>&nbsp;
	                	<a id="viewFlowChart" enabled="false" class='nui-button' plain='false' iconCls="icon-search" onclick="viewFlowChart()">查看流程图</a>&nbsp;
	                  	<a class='nui-button' plain='false' iconCls="icon-download" id="export_todayInstruct" onclick="exportExcel()">导出</a>&nbsp;
	                  	<a id="riskProcess" enabled="false" class='nui-button' plain='false' iconCls="icon-add" onclick="startRiskProcess()">发起风控流程</a>&nbsp;
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
    
	    <%-- 列表操作工具结束... --%>
	    <div class="nui-fit" style="width:100%;height:100%;overflow:hidden;">
		    <div id="treegrid_todays_instruct" class="nui-treegrid" style="width:100%;height:100%;"
				 url="com.cjhxfund.ats.sm.comm.InstructionManager.queryCombineInstructInfo.biz.ext" 
				 dataField="insructInfos" treeColumn="lInstructNo"
				 showPager="true" pageSize="20" frozenStartColumn="0" frozenEndColumn="6"
				 showTreeIcon="false" showTreeLines="false" multiSelect="true"
				 sizeList="[20,50,100,200,500,1000]"
				 showReloadButton="false"
				 onselectionchanged="selectionchanged"
				 onbeforeload="onBeforeTreeLoad"
				 pagerButtons="#prompt_todays"
				 virtualScroll="true"
				 sortField="" sortOrder=""
				 enableHotTrack="false"
				 idField="lResultId"
	             onselect="onSelect"
	             ondeselect="onDeselect"
	             onload="onGridLoad"
				 >
			    <div property="columns">
			    	<div type="checkcolumn" ></div> 
		    		<div name="action" width="60px" align="center" headerAlign="center" headerallowSort="true" renderer="value">操作</div> 
		           <!--  <div field="cIsValid" headerAlign="center" allowSort="true" width="85px" renderer="renderInstructStatus">
		                指令/建议状态
		            </div>
		            <div field="vcRiskApproveStatus" headerAlign="center" allowSort="true" width="85px" renderer="renderRiskApproveStatus">
		                风控审批状态
		            </div>
		           <!--  <div field="vcInstructType" headerAlign="center" allowSort="true" width="85px" renderer="renderInstructType">
		                指令/建议类型
		            </div> -->
		            <div field="vcProductName" headerAlign="center" allowSort="true" width="130px">
		               产品名称
		            </div>
		            <div field="vcCombiName" headerAlign="center" allowSort="true" width="120px">
		                组合名称
		            </div>
		             <div field="vcSettleSpeed" headerAlign="center" allowSort="true" width="70px" renderer="renderSettleSpeed">
		                清算速度
		            </div>
		            <div field="vcBizType" headerAlign="center" allowSort="true" width="120px" renderer="renderBizType">
		                业务类别
		            </div>
		            <div field="vcEntrustDirection" headerAlign="center" allowSort="true" width="85px" renderer="renderEntrustDirection">
		                委托方向
		            </div>
		            <div field="vcCounterpartyName" headerAlign="center" allowSort="true" width="140px">
		                交易对手
		            </div>
		            <div field="vcStockCode" headerAlign="center" allowSort="true" width="85px">
		                债券代码
		            </div>
		             <div field="vcStockName" headerAlign="center" allowSort="true" width="120px">
		                债券名称
		            </div>
		            <!--<div field="vcMarket" headerAlign="center" allowSort="true" width="85px" renderer="renderMarket">
		                交易市场
		            </div>-->
		            <div field="enFaceAmount" headerAlign="center" allowSort="true" numberFormat="n2" align="right" width="100px">
		                券面金额（万元）
		            </div>
		            <div field="lResultDate" headerAlign="center" allowSort="true" width="135px">
		                录入日期
		            </div>
		            <div field="lTradeDate" headerAlign="center" allowSort="true" width="85px">
		                交易日
		            </div>
		            <div field="lFirstSettleDate" headerAlign="center" allowSort="true" width="85px">
		                结算日
		            </div>
		            <div field="enNetPrice" headerAlign="center" allowSort="true" align="right" width="85px">
		                净价
		            </div>
		            <div field="enFullPrice" headerAlign="center" allowSort="true" align="right" width="85px">
		               全价
		            </div>
		            <div field="enMaturityYield" headerAlign="center" allowSort="true" align="right" width="120px">
		                到期收益率（%）
		            </div>
		            <div field="enOptionYield" headerAlign="center" allowSort="true" align="right" width="120px">
		                行权收益率（%）
		            </div>
		            <div field="cIsValid" headerAlign="center" allowSort="true" align="center" width="95px" renderer="renderInstructStatus">
		                交易状态
		            </div>
		            <div field="tResultInputTime" headerAlign="center" allowSort="true" renderer="resultRenderReview" width="200px">
		                录入时间
		            </div>
		            <div field="vcAdviserConfirm" headerAlign="center" allowSort="true" width="200px">
		               复核时间
		            </div>
		            <div field="vcEntrustConfirm" headerAlign="center" allowSort="true" width="200px">
		                确认时间
		            </div>
		            <div field="tFsSendTime" headerAlign="center" allowSort="true" renderer="sendRenderReview" width="200px" >
		                投资经理确认时间
		            </div>
		            <!-- 
		            <div field="lFixValidStatus" headerAlign="center" allowSort="true" renderer="fixValidStatusRenderReview" width="200px">
		               指令/建议推送状态
		            </div>
		            <div field="tResultInputTime" headerAlign="center" allowSort="true" renderer="resultRenderReview" width="100px">
		                询价结果录入时间
		            </div> -->
		            <div field="tFsOperateTime" headerAlign="center" allowSort="true" renderer="operateRenderReview" width="200px">
		                前台录单时间
		            </div>
		            <div field="tFsCheckTime" headerAlign="center" allowSort="true" renderer="checkRenderReview" width="200px">
		                前台发送时间
		            </div>
		            <div field="tFsDealTime" headerAlign="center" allowSort="true"  dateFormat="yyyy-MM-dd HH:mm:ss" width="150px">
		                前台成交时间
		            </div>
		            <div field="vcBsDealStatus" headerAlign="center" allowSort="true" renderer="bsDealRenderReview" width="140px">
		                后台成交状态
		            </div>
			        <div field="lInstructNo" name="lInstructNo" headerAlign="center" allowSort="true" width="90px">
		                指令/建议序号
		            </div>
		            <div field="instructSource" headerAlign="center" allowSort="true" width="90px" renderer="rendererInstructResource">
		                指令/建议来源
		            </div>
		            <div field="vcRemark" headerAlign="center" allowSort="true" width="85px">
		                备注
		            </div>
			    </div> 
			</div>
		</div>
		
		<div id="prompt_todays">
	        <span class="separator"></span>
	        <div class="investdata"></div>
	   		<div style= "display:inline-block; margin-right: 8px;">投资经理已确认</div>
	       	<div class="transactionConfirmData"></div>
	       	<div style= "display:inline-block; margin-right: 8px;">交易已确认</div>
	       	<div class="waitdata"></div>
	        <div style= "display:inline-block; margin-right: 8px;">交易已发送</div>
	       	<div class="tradedate"></div>
	        <div style= "display:inline-block; margin-right: 8px;">前台已成交</div>
	      	<div class="closedata"></div>
	    	<div style= "display:inline-block;">后台已成交 </div>
	     	<div class="invaliddata"></div>
	        <div style= "display: inline-block; margin-right: 8px;">无效</div>
	       	<div class="backdata"></div>
	        <div style= "display:inline-block; margin-right: 8px;">已修改</div>
	        <div class="approvedata"></div>
	   		<div style= "display:inline-block; margin-right: 8px;">触发风控</div>
	        <div class="forbiddata"></div>
	        <div style= "display:inline-block; margin-right: 8px;">交易禁止</div>
		</div>
	</div>
		
	<%-- 详细开始... --%>
	<div title="指令/建议相关信息" region="south" showSplit="false" height="228px" showHeader="true" showSplitIcon="true" expanded="false">
		<div class="nui-fit">
		    <div id="tabs_instruct_follow_detail" class="nui-tabs" activeIndex="0" onactivechanged="activechanged" height="100%">
		    	<div title="指令/建议明细" name="instructDetailTab" url="<%= request.getContextPath() %>/sm/comm/instruct/tansaction_instruct/instructDetail.jsp"></div>
		    	<div title="成交明细" name="dealDetail" visible="false" url="<%= request.getContextPath() %>/sm/comm/instruct/tansaction_instruct/dealDetail.jsp"></div>
		    	<div title="触犯风控" name="riskDetailTab" url="<%= request.getContextPath() %>/sm/comm/instruct/violateRiskCtrl.jsp"></div>
		    	<div title="修改历史" name="editHistoryTab"  url="<%= request.getContextPath() %>/sm/comm/instruct/tansaction_instruct/reviseHistory.jsp"></div>
		    	<div title="流程审批信息" name="approveTab" url="<%= request.getContextPath() %>/sm/comm/instruct/processApproval.jsp"></div>
		    </div>
	    </div>
	</div>
    <%-- 详细结束... --%>  
</div>	
	<!-- 导出参数 -->
	<div>
		<form id="export_FROM" method="post">
			<!-- 业务标签:当日指令/建议 -->
	   		<input class="nui-hidden" id="queryType" name="queryType" value="1"/>
			<!-- 委托方向:01-买入  02–卖出  -->
			<input class="nui-hidden" name="exportVcBizType" id="exportVcBizType" value="">
			<input class="nui-hidden" name="sheetName" id="sheetName" value="债券买卖">
			<!--  导出类型（买卖指令/建议1,回购指令/建议2）-->
			<input class="nui-hidden" name="exportType" id="exportType" value="1">
			<input class="nui-hidden" name="exportVcEntrustDirection" id="exportVcEntrustDirection" value="">
			<input class="nui-hidden" name="exportVcProductCode" id="exportVcProductCode" value="">	
			<!--  页面类型:指令/建议查询1,指令/建议管理2 -->
			<input class="nui-hidden" name="webType" id="webType" value="2">
			<input class="nui-hidden" name="lInstructNo" id="lInstructNo" value="">
			<input class="nui-hidden" name="exportTradeDateMin" id="exportTradeDateMin" value="">
			<input class="nui-hidden" name="exportTradeDateMax" id="exportTradeDateMax" value="">
			<input class="nui-hidden" name="exportInstructValid" id="exportInstructValid" value="">
				
		</form>	
	</div>
	<!-- 导出参数结束 -->
	<script type="text/javascript">
    	nui.parse();
    	// 当天日期
    	var date = new Date();
    	var todayDate = DateUtil.toNumStr(date);
		nui.get("lTradeDateMin").setValue(todayDate);
		nui.get("lTradeDateMax").setValue(todayDate);
    	var today_instruct = new nui.Form("#form_today_instruct");
    	var todays_instruct_grid = nui.get("treegrid_todays_instruct");
    	var tabDetailRole = nui.get("tabs_instruct_follow_detail");//获取详情标签列表
    	var isSigleSelectChanged = false;
    	var viewFlowChartButton = nui.get("viewFlowChart");
    	 
    	var selectArr = [];//已选的记录数组
    	
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
	    		if(row.lResultId==record.lResultId){
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
	    		if(row.lResultId!=record.lResultId){//将原来数组中不等于取消选中行的记录重新放回去
	    			selectArr.push(row);
	    		}
	    	}
	    }
    	    	
    	function onBeforeTreeLoad(e) {
        	var params = e.params;  //参数对象
	        //可以传递自定义的属性
			var initParam = new nui.Form("#form_today_instruct").getData(false,false);
        	if(initParam.lTradeDateMin != null && initParam.lTradeDateMin != ""){
        		initParam.lTradeDateMin = DateUtil.toNumStr(initParam.lTradeDateMin);
        	}else{
        		initParam.lTradeDateMin = DateUtil.toNumStr(new Date());
        	}
        	if(initParam.lTradeDateMax != null && initParam.lTradeDateMax != ""){
        		initParam.lTradeDateMax = DateUtil.toNumStr(initParam.lTradeDateMax);
        	}else{
        		initParam.lTradeDateMax = DateUtil.toNumStr(new Date());
        	}
        	if(initParam.instructValid != null && initParam.instructValid != ""){
        		initParam["instructValid"] = nui.get("instructValid").getValue();
        	}else{
        		//initParam["instructValid"] = nui.get("cIsValid").getValue();
        	}
        	if(initParam.vcBizType != null && initParam.vcBizType != ""){
        		initParam["vcBizType"] = nui.get("vcBizType").getValue();
        	}else{
        		initParam["vcBizType"] = nui.get("bizType").getValue();
        	}
        	initParam["vcProductCode"] = splitString(initParam["vcProductCode"]);
        	initParam["queryType"] = nui.get("queryType").getValue();
        	//initParam["instructNo"] = initParam["instructNo"];
	        params.paramObject = initParam;
	    }
	    
	    function splitString(data){
    		var string = null;
    		if(data != null && data != ""){
    			var strs= data.split(",");
	    		if(strs.length>0){
	    			for(var i=0; i<strs.length; i++ ){ 
						if(i == 0){
							string = "'"+strs[i]+"'";
						}else{
							string += ",'"+strs[i]+"'";
						}
					} 
	    		}
    		}
			return string;
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
			}else if(record.cIsValid=="1"){//在指令/建议状态为有效的前提下控制流程样式
				//流程处理状态:0-询价结果待录入,1-询价结果已录入,2-指令/建议待复核,2A-预置指令/建议待确认,3-待投资经理确认,4-待风控审批,
				//5-待交易录单,6-待录单复核,7-待前台成交,8-前台已成交,9-后台已成交
				if((record.cRiskStatus=='0' || record.cRiskStatus=='1')&&record.vcRiskType=='2'){	//交易禁止
					e.rowCls = "processStatus_forbid_zlgl";
				}else if(record.vcProcessStatus=="4" || record.cRiskStatus=='0' || record.cRiskStatus=='1' || record.cRiskStatus=='6'){
					e.rowCls = "processStatus_4_zlgl";
				}else if(record.vcProcessStatus=="5"){
					e.rowCls = "processStatus_5or6_zlgl";
				}else if( record.vcProcessStatus=="6"){
					e.rowCls = "processStatus_5_zlgl";
				}else if(record.vcProcessStatus=="7"){
					e.rowCls = "processStatus_7_zlgl";
				}else if(record.vcProcessStatus=="8"){
					e.rowCls = "processStatus_8_zlgl";
				}else if(record.vcProcessStatus=="9"){
					e.rowCls = "processStatus_9_zlgl";
				}
			}
			if(field=="lResultDate" || field=="lTradeDate" || field=="lFirstSettleDate"){
				if(value){
					e.cellHtml = nui.formatDate(DateUtil.numStrToDate(value.toString()),"yyyy-MM-dd");
				}
			}
			if(field=="vcProductName" && record.vcAvailResult=="false"){
				e.cellHtml = '<span title="'+value+'，可用不足！"'
				+' style="background: url('+nui.context+'/common/nui/themes/default/images/messagebox/icon-warning.gif);'
				+'background-size:20px 15px;background-repeat:no-repeat; '
				+'padding-left: 24px;">'+value+'</span>';
			}
	    });
    	
    	//自动刷新功能处理
    	var autoRefreshValOld = nui.get("autoRefresh").getValue();//获取默认自动刷新时间
	    var autoRefreshReturnVal= self.setInterval("autoRefreshFun()",eval(autoRefreshValOld)*1000);//设置自动刷新时间默认3分钟
	    function autoRefreshFun(){
	    	autoSearch();
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
    	
    	function search(){
    		todays_instruct_grid.reload("com.cjhxfund.ats.sm.comm.InstructionManager.queryCombineInstructInfo.biz.ext");
    		clearDetail();
    	}
    	
    	function reset(){
    		today_instruct.clear();
    		nui.get("lTradeDateMin").setValue(todayDate);
			nui.get("lTradeDateMax").setValue(todayDate);
    	}
    	
    	function selectionchanged(){
    		var rows = selectArr;
			nui.get("remove").disable();
			nui.get("edit").disable();
			nui.get("batchConfirm").disable();
			nui.get("backConfirm").disable();
			nui.get("copyInstruct").disable();
			nui.get("riskProcess").disable();
			viewFlowChartButton.disable();
			if(rows.length == 1){
				var row = rows[0];
				// 3-二级债 其他为老机器猫
				if(row.vcInstructSource=="3"){
					tabDetailRole.updateTab("riskDetailTab",{visible:true});
					tabDetailRole.updateTab("approveTab",{visible:true});
					tabDetailRole.updateTab("editHistoryTab",{visible:true});
					if(row.cIsValid=="1"){
						var dealDetailTab = tabDetailRole.getTab("dealDetail");
			    		//判断是否成交（前台已成交=8，后台已成交=9）决定是否显示成交明细
			    		if(row.vcProcessStatus==8 || row.vcProcessStatus==9){		
			    			tabDetailRole.updateTab("dealDetail",{visible:true});
			    		}else{
			    			if(tabDetailRole.getActiveTab()==dealDetailTab){
								tabDetailRole.activeTab(tabDetailRole.getTab(0));
							}
							tabDetailRole.updateTab("dealDetail",{visible:false});
			    		}
					}
					if((row.vcProcessStatus == "2" || row.vcProcessStatus == "3") && row.workitemid!=null && row.workitemid!="" && row.lTradeDate >= nui.formatDate(new Date(), "yyyyMMdd")){
						nui.get("batchConfirm").enable();
						nui.get("backConfirm").enable();
					}
					if(row.smInputRelateTypeUser!= null){
					    nui.get("copyInstruct").enable();
						if(row.vcProcessStatus != "8" && row.vcProcessStatus != "9"){
							if(row.cIsValid=="1"){
								nui.get("remove").enable();
							}
							if(row.cIsValid!=="2"&&row.cIsValid!=="3"&&row.cIsValid!=="4"&&row.cIsValid!=="6"&&row.cIsValid!=="7"){
							    nui.get("edit").enable();
							}
						}
					}
					viewFlowChartButton.enable();
					//发起风控流程按钮可用控制
					if(row.instructSource!='2'){
						riskProcessBtnControl(row);
					}
				}else if(row.vcInstructSource=="1" || row.vcInstructSource=="2"){
					tabDetailRole.updateTab("riskDetailTab",{visible:false});
					tabDetailRole.updateTab("approveTab",{visible:false});
					tabDetailRole.updateTab("dealDetail",{visible:false});
					tabDetailRole.updateTab("editHistoryTab",{visible:false});
					
					var riskDetailTab = tabDetailRole.getTab("riskDetailTab");
					var approveTab = tabDetailRole.getTab("approveTab");
					var dealDetail = tabDetailRole.getTab("dealDetail");
					var editHistoryTab = tabDetailRole.getTab("editHistoryTab");
					if(tabDetailRole.getActiveTab()==riskDetailTab||tabDetailRole.getActiveTab()==approveTab||tabDetailRole.getActiveTab()==dealDetail||tabDetailRole.getActiveTab()==editHistoryTab){
						tabDetailRole.activeTab(tabDetailRole.getTab(0));
					}
					var hasPermission = false;
					if(row.vcProcessStatus=="2"){//流程在投顾复核确认
						var userIdRelaType07All = row.userIdRelaType07All!=null?row.userIdRelaType07All:"";//07-产品与投顾确认权限(全部人员)
        				var userIdRelaType07 = row.userIdRelaType07!=null?row.userIdRelaType07:"";//07-产品与投顾确认权限(过滤自己)
						var userIdRelaTypeA1 = row.userIdRelaTypeA1!=null?row.userIdRelaTypeA1:"";//A1-投顾录入确认可为同一人员
						if(userIdRelaType07All!=null && userIdRelaType07All!=""){//设置了复核人员
							var userIdRelaType07Arr = userIdRelaType07.split(",");//默认过滤自己
							if(userIdRelaTypeA1!=null && userIdRelaTypeA1!=""){//可为同一人员
								userIdRelaType07Arr = userIdRelaType07All.split(",");
							}
							for(var j=0; j<userIdRelaType07Arr.length; j++){
								var userIdTemp = userIdRelaType07Arr[j];
								if(userIdTemp==userId){
									hasPermission = true;
									break;
								};
							};
						}
						if(hasPermission==true && row.cIsValid=="1"){
							nui.get("batchConfirm").enable();
						};
					}else if(row.vcProcessStatus=="3"){//投资经理确认权限
						//若当前用户有权限处理该指令/建议单，则继续执行，否则终止并提示
						var userIdRelaType02 = row.userIdRelaType02;//该指令/建议单拥有投资经理下单权限的用户ID字符串
						if(userIdRelaType02!=null && userIdRelaType02!=""){
							var userIdRelaType02Arr = userIdRelaType02.split(",");
							for(var i=0; i<userIdRelaType02Arr.length; i++){
								var userIdTemp = userIdRelaType02Arr[i];
								if(userIdTemp==userId){
									hasPermission = true;
									break;
								};
							};
						}
						if(hasPermission==true && row.cIsValid=="1"){
							nui.get("batchConfirm").enable();
							nui.get("backConfirm").enable();
						}
					}
					viewFlowChartButton.disable();
				}
				showDetail(row);
			}else {
				var bacthConfirmCount = 0;
				var notBacthConfirmCount = 0;
				for(var i=0; i<rows.length; i++){
					if(rows[i].vcInstructSource=="3"){
						if(rows[i].cIsValid=="1"){
							if((rows[i].vcProcessStatus == "2" || rows[i].vcProcessStatus == "3") && rows[i].workitemid!=null && rows[i].workitemid!=""){
								bacthConfirmCount +=1;
							}else{
								notBacthConfirmCount +=1;
							}
						}else{
							notBacthConfirmCount +=1;
						}
					}else if(rows[i].vcInstructSource=="1" || rows[i].vcInstructSource=="2"){
						var hasPermission = false;
						if(rows[i].cIsValid=="1"){
							if(rows[i].vcProcessStatus=="2"){//流程在投顾复核确认
								var userIdRelaType07All = rows[i].userIdRelaType07All!=null?rows[i].userIdRelaType07All:"";//07-产品与投顾确认权限(全部人员)
		        				var userIdRelaType07 = rows[i].userIdRelaType07!=null?rows[i].userIdRelaType07:"";//07-产品与投顾确认权限(过滤自己)
								var userIdRelaTypeA1 = rows[i].userIdRelaTypeA1!=null?rows[i].userIdRelaTypeA1:"";//A1-投顾录入确认可为同一人员
								if(userIdRelaType07All!=null && userIdRelaType07All!=""){//设置了复核人员
									var userIdRelaType07Arr = userIdRelaType07.split(",");//默认过滤自己
									if(userIdRelaTypeA1!=null && userIdRelaTypeA1!=""){//可为同一人员
										userIdRelaType07Arr = userIdRelaType07All.split(",");
									}
									for(var j=0; j<userIdRelaType07Arr.length; j++){
										var userIdTemp = userIdRelaType07Arr[j];
										if(userIdTemp==userId){
											hasPermission = true;
											break;
										}
									}
									if(hasPermission){
										bacthConfirmCount += 1;
									}else{
										notBacthConfirmCount += 1;
									}
								}else{
									notBacthConfirmCount +=1;
								}
							}else if(rows[i].vcProcessStatus=="3"){//投资经理确认权限
								//若当前用户有权限处理该指令/建议单，则继续执行，否则终止并提示
								var userIdRelaType02 = rows[i].userIdRelaType02;//该指令/建议单拥有投资经理下单权限的用户ID字符串
								if(userIdRelaType02!=null && userIdRelaType02!=""){
									var userIdRelaType02Arr = userIdRelaType02.split(",");
									for(var k=0; k<userIdRelaType02Arr.length; k++){
										var userIdTemp = userIdRelaType02Arr[k];
										if(userIdTemp==userId){
											hasPermission = true;
											break;
										}
									}
									if(hasPermission){
										bacthConfirmCount += 1;
									}else{
										notBacthConfirmCount += 1;
									}
								}else{
									notBacthConfirmCount += 1;
								}
							}
						}else{
							notBacthConfirmCount += 1;
						}
						
					}
				}
				if(notBacthConfirmCount>0){
					nui.get("batchConfirm").disable();
				}else if(bacthConfirmCount>0){
					nui.get("batchConfirm").enable();
				}
				
				tabDetailRole.activeTab(tabDetailRole.getTab(0));
				tabDetailRole.updateTab("dealDetail",{visible:false});
				viewFlowChartButton.disable();
				clearDetail();
			}
    	}
    	
    	//显示详细信息
    	function showDetail(row){
    		isSigleSelectChanged = true;
    		var currentTabIFrameEl = tabDetailRole.getTabIFrameEl(tabDetailRole.getActiveTab());//重新获取当前显示的标签页
    		currentTabIFrameEl.contentWindow.detail(row);//调用当前显示的标签页的显示详情方法
    	}
    	
    	
    	//清除详细信息
    	function clearDetail(){
    		isSigleSelectChanged = false;
    		var currentTabIFrameEl = tabDetailRole.getTabIFrameEl(tabDetailRole.getActiveTab());//获取当前详情标签页
    		currentTabIFrameEl.contentWindow.clearDetail();
    	}
    	//详情子界面第一次加载时调用
    	function detailLoaded(){
    		var currentTabIFrameEl = tabDetailRole.getTabIFrameEl(tabDetailRole.getActiveTab());
    		if(isSigleSelectChanged == true){
    			currentTabIFrameEl.contentWindow.detail(todays_instruct_grid.getSelected());
    		}
    	}
    	//详情标签切换时处理逻辑
    	function activechanged(){
    		var currentTabIFrameEl = tabDetailRole.getTabIFrameEl(tabDetailRole.getActiveTab());
    		if(typeof(currentTabIFrameEl) != "undefined"){
    			if(isSigleSelectChanged == true){
    				currentTabIFrameEl.contentWindow.detail(todays_instruct_grid.getSelected());
    			}else{
    				currentTabIFrameEl.contentWindow.clearDetail();
    			}
    		}
    	}
	    
	    function edit(){
	    	var rows = selectArr;
	    	if(rows.length != 1){
				nui.alert("请先选中一条记录","提示");
				return;
			}
			var row = rows[0];
			// 3-二级债 其他为老机器猫
			if(row.vcInstructSource!="3"){
				nui.alert("该笔指令为老机器猫指令！","提示");
				return;
			}
			if(row.vcProcessStatus == "8"){
				nui.alert("该指令/建议前台已成交,不可修改","提示");
				return;
			}else if(row.vcProcessStatus == "9"){
				nui.alert("该指令/建议已完成,不可修改","提示");
				return;
			}
			if(row.smInputRelateTypeUser == null){
				nui.alert("您没有该产品的操作权限,请先确认！","提示");
				return;
			}
			var url = nui.context+"/transaction/invest/interbank_trade/instructIssue.jsp";
			var heigh = 465;
			if(row.vcBizType == "2"){//上海大宗
				url = nui.context+"/transaction/invest/sh_block_trade/instructIssue.jsp";
				heigh = 490;
			}else if(row.vcBizType == "3"){//上海固收平台
				url = nui.context+"/transaction/invest/sh_fixed_income/instructIssue.jsp";
				heigh = 490;
			}else if(row.vcBizType == "4"){//深圳综合协议平台
				url = nui.context+"/transaction/invest/sz_integrated_prot/instructIssue.jsp";
				heigh = 490;
			}
	    	nui.open({
    			url: url,
    			title: "修改投资指令/建议", width: 1070, height: heigh,
    			allowResize:false,
    			onload: function () {
			        var iframe = this.getIFrameEl();
			        row["operatorType"] = "1"; //0-新建指令/建议 1-编辑指令/建议
			        iframe.contentWindow.SetData(row);
    			},
    			ondestroy: function (action) {
					search();
    			}
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
			if(row.vcInstructSource!="3"){			// 3-二级债 其他为老机器猫
				nui.alert("请选择新二级债的指令做撤销！","提示");
				return;
			}
			if(row.lTradeDate < nui.formatDate(new Date(), "yyyyMMdd")){
				nui.alert("该指令/建议交易日期已过,不允许操作","提示");
				return;
			}
			if(row.vcProcessStatus == "8"){
				nui.alert("该指令/建议前台已成交,不可撤销","提示");
				return;
			}else if(row.vcProcessStatus == "9"){
				nui.alert("该指令/建议后台已成交,不可撤销","提示");
				return;
			}
			if(row.smInputRelateTypeUser == null){
				nui.alert("您没有该产品的操作权限,请先确认！","提示");
				return;
			}
			// 3-二级债 其他为老机器猫
			if(row.vcInstructSource=="3"){
				nui.open({
					url : nui.context + "/sm/comm/instruct/onCancleReason.jsp",
					title : "指令撤销",
					width : 500,
					height : 200,
					onload : function() {
						var iframe = this.getIFrameEl();
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
									nui.alert("当前指令序号为"+"["+row.lResultNo+"],处理结果如下：</br>"+returnJson.rtnMsg,"提示",function(action){
						    			if(action == "ok"){						
						    				search();
						    			}
									});
								}else if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ERROR%>"){
									nui.alert("当前指令序号为"+"["+row.lResultNo+"],处理结果如下：</br>"+returnJson.rtnMsg,"提示",function(action){
						    			if(action == "ok"){						
						    				search();
						    			}
									});
								}else if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ORDER_NO_RCV_FR_O32%>"){
									nui.alert("当前指令序号为"+"["+row.lResultNo+"],处理结果如下：</br>"+returnJson.rtnMsg,"提示",function(action){
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
					}
				});
			}	
	    }
		
		
	    //指令/建议操作权限判断
	    var authorityJudgmentData = {};
	    function authorityJudgment(data){
	    	if(typeof(authorityJudgmentData[data.vcProductCode]) !== "undefined"){
	    		return authorityJudgmentData[data.vcProductCode];
	    	}
	    	var result = false;
	    	nui.ajax({
				url : "com.cjhxfund.ats.sm.comm.InstructionManager.authorityJudgment.biz.ext",
				type : 'POST',
				data : {productCode:data.vcProductCode},
				cache : false,
				async: false,
				contentType : 'text/json',
				success : function(text) {
					var returnJson = nui.decode(text);
					if(returnJson.exception == null){
						var userIds= new Array(); 
						userIds=returnJson.userIds.split(",");
						for (var i=0; i<userIds.length; i++ ){ 
							if(userIds[i] == returnJson.userId){
								result = true;
								authorityJudgmentData[data.vcProductCode] = true;
								return;
							}
						} 
						result = false;
						authorityJudgmentData[data.vcProductCode] = result;
					}else{
						result = false;
					}
				}
			 });
			return result;
	    }
	    
		//指令/建议类别列字典翻译
	    function renderInstructType(e) {
			return nui.getDictText("instructType",e.row.vcInstructType);
		}
		
	    //指令/建议状态列字典翻译
	    function renderInstructStatus(e){
	    	return nui.getDictText("instructStatus",e.row.cIsValid);
	    }
	    
	    //业务类别列字典翻译
	    function renderBizType(e){
	    	return nui.getDictText("bizTypeTransaction",e.row.vcBizType);
	    }
	    //委托方向列字典翻译
	    function renderEntrustDirection(e){
	    	return nui.getDictText("entrustDirection",e.row.vcEntrustDirection);
	    }
	    
	    //交易市场列字典翻译
	    function renderMarket(e){
	    	return nui.getDictText("tradePlace",e.row.vcMarket);
	    }
	    
	    //清算速度列字典翻译
	    function renderSettleSpeed(e){
	    	return nui.getDictText("settleSpeed",e.row.vcSettleSpeed);
	    }
	    
	    //fix发送状态
	    function fixValidStatusRenderReview(e){
	    	if(e.value == null || e.value == "0"){
	    		return "未发送";
	    	}else if(e.value == "1"){
	    		return "不启用";
	    	}else if(e.value == "2"){
	    		return "发送中";
	    	}else if(e.value == "3"){
	    		return "发送成功";
	    	}else if(e.value == "4"){
	    		return "发送失败";
	    	}
	    	//return nui.getDictText("fixValidStatus",e.row.lFixValidStatus);
	    }
	    
	    function renderInstructStatus(e){
			return nui.getDictText("instructStatus",e.row.cIsValid);
		}
		
	    function renderRiskApproveStatus(e){
	    	if(e.value == null){
	    		return "--";
	    	}else{
	    		return nui.getDictText("riskApproveStatus",e.row.vcRiskApproveStatus);
	    	}
	    }
	    
	    //指令/建议下达时间显示处理
	    function initiateRenderReview(e){
			return (e.row.vcResultInputerName==null?"":e.row.vcResultInputerName) + "　" + nui.formatDate(e.row.tResultInputTime, "yyyy-MM-dd HH:mm:ss");
		}
		
		//询价结果录入时间显示处理
	    function resultRenderReview(e){
	    	if(e.row.vcResultInputerName!=null || e.row.tResultInputTime!=null){
	    		return (e.row.vcResultInputerName==null?"":e.row.vcResultInputerName) + "　" + nui.formatDate(e.row.tResultInputTime, "yyyy-MM-dd HH:mm:ss");
			}else{
				return "";
			}
		}
		//投资经理确认时间处理
	    function sendRenderReview(e){
	    	if(e.row.vcFsSenderName!=null && e.row.tFsSendTime!=null){
				return (e.row.vcFsSenderName==null?"":e.row.vcFsSenderName) + "　" + nui.formatDate(e.row.tFsSendTime, "yyyy-MM-dd HH:mm:ss");
			}else{
				return "";
			}
		}
		
		//录单确认时间处理
	    function operateRenderReview(e){
	    	if(e.row.vcFsOperatorName!=null && e.row.tFsOperateTime!=null){
				return (e.row.vcFsOperatorName==null?"":e.row.vcFsOperatorName) + "　" + nui.formatDate(e.row.tFsOperateTime, "yyyy-MM-dd HH:mm:ss");
			}else{
				return "";
			}
		}
		
		//录单复核时间处理
	    function checkRenderReview(e){
	    	if(e.row.vcFsCheckerName!=null && e.row.tFsCheckTime!=null){
				return (e.row.vcFsCheckerName==null?"":e.row.vcFsCheckerName) + "　" + nui.formatDate(e.row.tFsCheckTime, "yyyy-MM-dd HH:mm:ss");
			}else{
				return "";
			}
		}
		
		//翻译后台成交状态字典
	    function bsDealRenderReview(e){
	    	return nui.getDictText("bsSetmtStatus",e.row.vcBsDealStatus);
	    }
	    
	    function onCloseClick(e){
	    	var obj = e.sender;
            obj.setText("");
            obj.setValue("");
	    }
        
        // 导出指令/建议
        function exportExcel(){
        	var exportTradeDateMin = nui.get("lTradeDateMin").getValue();
			var exportTradeDateMax = nui.get("lTradeDateMax").getValue();
			var rows = selectArr;
			// 定义指令/建议序号
			var lInstructNo = "";
			// 定义弹窗提示信息
			//var msg = "您已选中 " + rows.length + " 条记录，确定要导出吗?";
			var msg = "您未选中指令/建议，将导出全部指令/建议，确定要导出吗?";
			//if(rows.length ==null || rows.length<=0){
			//	nui.alert("请先选择一条记录再导出","系统提示");
			//	return;
			//}
			if(rows.length>0){
				msg = "确定要导出吗?";
				// 拼接指令/建议序号
				for(var i=0; i<rows.length; i++){
					lInstructNo+= rows[i].lInstructNo+",";
				}
				//去掉最后一个逗号
			    if (lInstructNo.length > 0) {
			        lInstructNo = lInstructNo.substr(0, lInstructNo.length - 1);
			    }
			}
		   
			// 设置导出form参数
			if(lInstructNo != null){
				document.getElementById("lInstructNo").value = lInstructNo;
			}
			var cIsValid = nui.get("instructValid").getValue();
			var vcBizType = nui.get("vcBizType").getValue();
			var vcProductCode = nui.get("vcProductCode").getValue();
			var vcEntrustDirection = nui.get("vcEntrustDirection").getValue();
						
			if(exportTradeDateMin != null && exportTradeDateMin != ""){
        		document.getElementById("exportTradeDateMin").value = DateUtil.toNumStr(exportTradeDateMin);
        	}else{
        		document.getElementById("exportTradeDateMin").value = DateUtil.toNumStr(new Date());
        	}
        	if(exportTradeDateMax != null && exportTradeDateMax != ""){
        		document.getElementById("exportTradeDateMax").value = DateUtil.toNumStr(exportTradeDateMax);
        	}else{
        		document.getElementById("exportTradeDateMax").value = DateUtil.toNumStr(new Date());
        	}
        	if(cIsValid != null && cIsValid != ""){
        		document.getElementById("exportInstructValid").value = cIsValid;
        	}
        	if(vcBizType != null && vcBizType != ""){
        		document.getElementById("exportVcBizType").value = vcBizType;
        	}else{
        		document.getElementById("exportVcBizType").value = nui.get("bizType").getValue();
        	}
        	if(vcEntrustDirection != null && vcEntrustDirection != ""){
        		document.getElementById("exportVcEntrustDirection").value = vcEntrustDirection;
        	}else{
        		document.getElementById("exportVcEntrustDirection").value = nui.get("entrustDirection").getValue();;
        	}
        	if(vcProductCode != null && vcProductCode != ""){
        		document.getElementById("exportVcProductCode").value = splitString(vcProductCode);
        	}
        	
			// 页面流跳转
			nui.confirm(msg,"系统提示",function(action){
				if(action=="ok"){
					nui.get("export_todayInstruct").disable();//禁用“导出”按钮
					var form = document.getElementById("export_FROM");
					form.action = "com.cjhxfund.ats.sm.comm.instructExcle.flow";
			        form.submit();
			        //启用“导出”按钮
			        setTimeout("enableExport()",15000);
				}
			});
		}
		
		function enableExport(){
	  		nui.get("export_todayInstruct").enable();
		}
		
		//获取查询条件的产品名称
		function ButtonClickGetFundName_todayInstruct(e){
	        ButtonClickGetFundName(this);
		}
		
		//跨页多选选择表格获取产品
		function ButtonClickGetFundName(buttonEditObj){
	        nui.open({
	            url: "<%=request.getContextPath() %>/sm/comm/instruct/productInfoCombi.jsp",
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
		
		// 任务表格操作列内容定义
		function value(e){
			var s = null;
			var row = e.row;
			// 指令/建议流程状态为待审批复核，投资经理确认显示 操作按钮
			// 3-二级债 其他为老机器猫
			if(row.cIsValid == "1" && row.lTradeDate >= nui.formatDate(new Date(), "yyyyMMdd")){
				if(row.vcInstructSource=="3"){
					if(row.vcProcessStatus == "2" || row.vcProcessStatus == "3"){
						if(row.workitemid){
							s = '<a class="nui-button" style="color:#6959CD; cursor:pointer;text-decoration:underline;" onclick="goInstructDetail('+e.rowIndex+')">确认</a>';
						}
					}
				}
				// 机器猫指令
				else if(e.row.vcInstructSource=="1" || e.row.vcInstructSource=="2"){
					var hasPermission = false;
					if(row.vcProcessStatus=="1" || row.vcProcessStatus=="2"){//流程在投顾复核确认
						var userIdRelaType07All = row.userIdRelaType07All!=null?row.userIdRelaType07All:"";//07-产品与投顾确认权限(全部人员)
	    				var userIdRelaType07 = row.userIdRelaType07!=null?row.userIdRelaType07:"";//07-产品与投顾确认权限(过滤自己)
						var userIdRelaTypeA1 = row.userIdRelaTypeA1!=null?row.userIdRelaTypeA1:"";//A1-投顾录入确认可为同一人员
						if(userIdRelaType07All!=null && userIdRelaType07All!=""){//设置了复核人员
							var userIdRelaType07Arr = userIdRelaType07.split(",");//默认过滤自己
							if(userIdRelaTypeA1!=null && userIdRelaTypeA1!=""){//可为同一人员
								userIdRelaType07Arr = userIdRelaType07All.split(",");
							}
							for(var j=0; j<userIdRelaType07Arr.length; j++){
								var userIdTemp = userIdRelaType07Arr[j];
								if(userIdTemp==userId){
									hasPermission = true;
									break;
								};
							};
						}
						if(hasPermission==true){
							s = '<a class="nui-button" style="color:#6959CD; cursor:pointer;text-decoration:underline;" onclick="goInstructDetail('+e.rowIndex+')">确认</a>';
						};
					}else if(e.row.vcProcessStatus=="3"){//投资经理确认权限
						//若当前用户有权限处理该指令/建议单，则继续执行，否则终止并提示
						var userIdRelaType02 = row.userIdRelaType02;//该指令/建议单拥有投资经理下单权限的用户ID字符串
						if(userIdRelaType02!=null && userIdRelaType02!=""){
							var userIdRelaType02Arr = userIdRelaType02.split(",");
							for(var i=0; i<userIdRelaType02Arr.length; i++){
								var userIdTemp = userIdRelaType02Arr[i];
								if(userIdTemp==userId){
									hasPermission = true;
									break;
								};
							};
						}
						if(hasPermission==true){
							s = '<a class="nui-button" style="color:#6959CD; cursor:pointer;text-decoration:underline;" onclick="goInstructDetail('+e.rowIndex+')">确认</a>';
						}
					}
				}
			}
			// 风控审批中
			if(e.row.cIsValid != "5" && e.row.cIsValid != "1"){
				if(e.row.vcInstructSource=="3" && e.row.smInputRelateTypeUser != null){
					s = '<a class="nui-button" style="color:#6959CD; cursor:pointer;text-decoration:underline;" onclick="copyInstruct('+e.rowIndex+')">修改</a>';
				}
			}
			return s;
		}
		
		// 查询流程审批复核权限和投资经理确认权限
		function getProcessStatusApproveByProcessId(processId) {
			var url = "";
			var result = false;
			url = "com.cjhxfund.ats.sm.comm.TaskManager.queryProcessApproveUsersByProcessid.biz.ext";
			nui.ajax({
				url : url,
				type : 'POST',
				data : {
					processId : processId
				},
				cache : false,
				async : false,
				contentType : 'text/json',
				success : function(text) {
					var returnJson = nui.decode(text);
					if (returnJson.exception == null) {
						var userIds = new Array();
						userIds = returnJson.workItemInfo;					
						if(userIds.length>0){
							for (var i = 0; i < userIds.length; i++) {
								if (userIds[i].vcUserId == returnJson.userId) {
									workitemInfo = userIds[i];
									result = true;
									return;
								}
							}
						}else{
							result = false;
						}
					} else {
						result = false;
					}
				}
			});
			return result;
		}
		
		//退回操作
		function backTasks(){
			var rcds = selectArr;
		   	var row = rcds[0];
			// 判断是否选择数据
		   	if(rcds.length == 0){
		    	nui.alert("没有选择指令/建议信息，请先选择指令/建议信息！","提示");
		    	return;
		   	}
		   	if(rcds.length > 1){
		   		nui.alert("不支持多条退回，请重现选择一条指令/建议信息！","提示");
		    	return;
		   	}
		   	if(row.cIsValid!="1"){
		   		nui.alert("该指令/建议已无效，不能再做退回操作！","提示");
		    	return;
		   	}
			// 3-二级债 其他为老机器猫
			if(row.vcInstructSource=="3"){
				nui.open({
					url : nui.context + "/sm/comm/instruct/tansaction_instruct/backTaskReason.jsp",
					title : "指令退回",
					width : 500,
					height : 200,
					onload : function() {
						var iframe = this.getIFrameEl();
						iframe.contentWindow.setData(row);
					},
					ondestroy : function(action) {
						var iframe = this.getIFrameEl();
			            //获取选中、编辑的结果
			            var returnJson = iframe.contentWindow.getData();
			            returnJson = nui.clone(returnJson);    //必须。克隆数据。
			            if(returnJson!= null){
							if(returnJson.exception == null){
								if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_SUCCESS%>"){
		                    		var alsertMsg = "";
		                			if(returnJson.rtnMsg){
		                				alsertMsg = "</br>此单已退回！</br>退回原因："+returnJson.rtnMsg;
		                			}
		                			nui.alert("操作成功！"+alsertMsg,"系统提示",function(action){
						    			if(action == "ok"){
											search();
						    			}
					    			});
								}else if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ERROR%>"){
									nui.alert("审批失败</br>"+returnJson.rtnMsg,"系统提示",function(action){
										if(action == "ok"){
											search();
						    			}
									});
									
								}else if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ORDER_NO_RCV_FR_O32%>"){
					    			nui.alert("审批成功"+"</br>"+returnJson.rtnMsg,"系统提示",function(action){
						    			if(action == "ok"){
											search();
						    			}
					    			}); 
								}else if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_RISK_VIOLATE_FORBID_CTRL%>"){
									nui.alert("审批失败,触发禁止风控,风控信息如下：</br>"+returnJson.rtnMsg,"系统提示",function(action){
						    			if(action == "ok"){
											search();
						    			}
									});
									
								}else if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ORDER_USABLE_AMOUNT_INSUFFICIENT%>"){
									nui.alert("审批失败</br>"+returnJson.rtnMsg,"系统提示",function(action){
						    			if(action == "ok"){
											search();
						    			}
									});
								}else{
									nui.alert("操作异常","系统提示");
								}
							}else{
								nui.alert("系统异常","系统提示");
							}
						}else{
							if(action == "ok"){						
			    				search();
			    			}
						}
					}
				});
			}else if(row.vcInstructSource=="1" || row.vcInstructSource=="2"){	// 机器猫指令	
				goBack_common_confirm_ZQMM(row);
			}
		}
		
		// 机器猫老债券买卖确认
		function confirm_common_confirm_ZQMM(){
			var row = rows[0];			
			var hasPermission = false;//是否有权限，默认无
			if(row.vcProcessStatus=="1" || row.vcProcessStatus=="2"){//流程在投顾复核确认
				var userIdRelaType07All = row.userIdRelaType07All!=null?row.userIdRelaType07All:"";//07-产品与投顾确认权限(全部人员)
        		var userIdRelaType07 = row.userIdRelaType07!=null?row.userIdRelaType07:"";//07-产品与投顾确认权限(过滤自己)
				var userIdRelaTypeA1 = row.userIdRelaTypeA1!=null?row.userIdRelaTypeA1:"";//A1-投顾录入确认可为同一人员
				if(userIdRelaType07All!=null && userIdRelaType07All!=""){//设置了复核人员
					var userIdRelaType07Arr = userIdRelaType07.split(",");//默认过滤自己
					if(userIdRelaTypeA1!=null && userIdRelaTypeA1!=""){//可为同一人员
						userIdRelaType07Arr = userIdRelaType07All.split(",");
					}
					for(var j=0; j<userIdRelaType07Arr.length; j++){
						var userIdTemp = userIdRelaType07Arr[j];
						if(userIdTemp==userId){
							hasPermission = true;
							break;
						};
					};
				}else{
					hasPermission = true;
				}
				if(hasPermission!=true){
					nui.alert("您没有权限确认该指令/建议！","提示");
					return;
				};
			}else if(row.vcProcessStatus=="3"){//投资经理确认权限
				//若当前用户有权限处理该指令/建议单，则继续执行，否则终止并提示
				var userIdRelaType02 = row.userIdRelaType02;//该指令/建议单拥有投资经理下单权限的用户ID字符串
				if(userIdRelaType02!=null && userIdRelaType02!=""){
					var userIdRelaType02Arr = userIdRelaType02.split(",");
					for(var i=0; i<userIdRelaType02Arr.length; i++){
						var userIdTemp = userIdRelaType02Arr[i];
						if(userIdTemp==userId){
							hasPermission = true;
							break;
						};
					};
				}
				if(hasPermission==false){
					nui.alert("您没有权限确认该指令/建议","提示");
					return;
				};
			}else{//交易员
				nui.alert("您没有权限确认该指令/建议","提示");
				return;
			}
			nui.confirm("确定要确认所选的指令/建议吗？","系统提示",function(action){
				if(action=="ok"){
					var json = nui.encode({zhfwptjyzqmms:[{processId: row.lResultId}]});
					var a = nui.loading("正在处理中,请稍等...","提示");
					$.ajax({
	                    url:"com.cjhxfund.jy.ProductProcess.JY_ZQMM.JY_ZQMM_confirm.biz.ext",
	                    type:'POST',
	                    data:json,
	                    cache: false,
	                    contentType:'text/json',
	                    success:function(text){
	                    	nui.hideMessageBox(a);
	                        var returnJson = nui.decode(text);
	                        if(returnJson.exception == null){
	                        	var validStr = returnJson.validStr;//有效指令/建议单字符串
	                        	var invalidStr = returnJson.invalidStr;//无效指令/建议单字符串
	                        	var validCount = returnJson.validCount;//有效指令/建议单记录数
	                        	var invalidCount = returnJson.invalidCount;//无效指令/建议单记录数
	                        	var invalidFixStr = returnJson.invalidFixStr;//无效指令/建议单字符串（Fix错误信息）
	                        	var validFixFailReason = returnJson.validFixFailReason;//有效指令/建议单字符串（反馈报文失败原因[警告信息等]）
	                        	var msg = "";
	                        	var failReasonMsg = "";
	                        	var errorMsg = "";
	                        	if(validCount!=null && validCount!="" && validCount!="0"){
	                        		if(validFixFailReason!=null && validFixFailReason!=""){
	                        			var tempValidStrArr = validStr.split(",");
		                        		var tempValidFixFailReasonArr = validFixFailReason.split("★");
		                        		for(var i=0; i<tempValidStrArr.length; i++){
		                        			failReasonMsg += "【"+tempValidStrArr[i]+"触发以下风控：</br>"+tempValidFixFailReasonArr[i]+"】</br>";
		                        		}
		                        		if(failReasonMsg!=null && (failReasonMsg.indexOf("申请指令/建议审批")!=-1 || failReasonMsg.indexOf("申请风险阀值")!=-1)){
		                        			failReasonMsg += "<span class='warn_red_bold'>请联系人工审批！</span></br>";
		                        		}
	                        		}
	                        		msg += "确认成功 " + validCount + " 条</br>"+failReasonMsg;
	                        	}
	                        	if(invalidCount!=null && invalidCount!="" && invalidCount!="0"){
	                        		var tempInvalidStrArr = invalidStr.split(",");
	                        		var tempInvalidFixStrArr = invalidFixStr.split("★");
	                        		for(var i=0; i<tempInvalidStrArr.length; i++){
	                        			errorMsg += "【"+tempInvalidStrArr[i]+"-"+tempInvalidFixStrArr[i]+"】</br>";
	                        		}
	                        		msg += "确认失败 " + invalidCount + " 条</br>"+errorMsg;
	                        	}
	                        	search();
	                            nui.alert(msg, "系统提示", function(action){});
	                        }else{
	                           // grid_confirm.unmask();
	                            nui.alert("确认失败", "系统提示");
	                        }
	                    }
	                });
				}
			});
		}
		
		//退回--所有业务通用
		function goBack_common_confirm_ZQMM(record){
		    var combProductName = record.vcProductCode;//产品名称
			var investProductNum = record.lInstructNo;//编号
			var validStatus = record.cIsValid;//交易状态：0-有效；1-无效-修改；2-无效-废弃；3-有效-退回；4-无效-退回；
			var validStr = "";//有效无效验证字符串
			if(validStatus!="1"){
				validStr += "、" + investProductNum + "-" + combProductName;
			}
			if(validStr!=null && validStr!="" && validStr.length>0){
				validStr = validStr.substr(1,validStr.length);
				var msg = "【"+validStr+"】</br>指令/建议已无效或退回，请先剔除";
				nui.alert(msg,"提示");
				return;
			}
			//权限验证开始...
			var goBackStr = "";//该阶段不能退回字符串
			var permissionStr = "";//权限验证字符串
			var processStatus = record.vcProcessStatus;
	    	//投顾尚未确认
	    	if(processStatus=="1" || processStatus=="2"){
	    		goBackStr += "、" + investProductNum + "-" + combProductName;
	    	//投资经理下单操作权限认证
	    	}else if(processStatus=="3"){
	    		//若当前用户有权限处理该指令/建议单，则继续执行，否则记录下该产品
	    		var hasPermission = false;//是否有权限，默认无
				var userIdRelaType02 = record.userIdRelaType02;//该指令/建议单拥有投资经理下单权限的用户ID字符串
				if(userIdRelaType02!=null && userIdRelaType02!=""){
					var userIdRelaType02Arr = userIdRelaType02.split(",");
					for(var j=0; j<userIdRelaType02Arr.length; j++){
						var userIdTemp = userIdRelaType02Arr[j];
						if(userIdTemp==userId){
							hasPermission = true;
							break;
						}
					}
				}
				if(hasPermission==false){
					permissionStr += "、" + investProductNum + "-" + combProductName;
				}
	    	}else{//投资经理下单已确认
        		goBackStr += "、" + investProductNum + "-" + combProductName;
        	}
	    	if(goBackStr!=null && goBackStr!="" && goBackStr.length>0){
				goBackStr = goBackStr.substr(1,goBackStr.length);
				var msg = "【"+goBackStr+"】</br>指令/建议尚未确认或投资经理已下单，请先剔除";
				nui.alert(msg,"提示");
				return;
			}
			if(permissionStr!=null && permissionStr!="" && permissionStr.length>0){
				permissionStr = permissionStr.substr(1,permissionStr.length);
				var msg = "您没有权限退回【"+permissionStr+"】指令/建议，请先剔除";
				nui.alert(msg,"提示");
				return;
			}
			var msg = "确定要退回所选指令/建议吗？";
			nui.confirm(msg,"系统提示",function(action){
				if(action=="ok"){
					var json = nui.encode({zhfwptjyzqmms: [{processId: record.lResultId}], validStatus: "3"});
					var a = nui.loading("正在处理中,请稍等...","提示");
					$.ajax({
	                    url:"com.cjhxfund.jy.ProductProcess.JY_ZQMM.JY_ZQMM_updateValidStatus.biz.ext",
	                    type:'POST',
	                    data:json,
	                    cache: false,
	                    contentType:'text/json',
	                    success:function(text){
	                    	nui.hideMessageBox(a);
	                        var returnJson = nui.decode(text);
	                        if(returnJson.exception == null){
	                            search();
	                            nui.alert("退回成功", "系统提示", function(action){
	                            });
	                        }else{
	                            //grid_goBack.unmask();
	                            nui.alert("退回失败", "系统提示");
	                        }
	                    }
	                });
				}
			});
		}
		
		// 机器猫和二级债指令录单确认（批量）
		function batchConfirmTasks(){
			var rows = selectArr;
			if(rows.length>20){
				nui.alert("批量确认记录不能大于20条","提示");
				return;
			}
			var jsonParams = null;
    		var instructList = new Array();
        	// 开始处理
			if(rows.length>0){
				for (var i = 0; i < rows.length; i++) {
	    			var record = rows[i];//产品记录
					// 3-二级债 其他为老机器猫
					if(record.vcInstructSource=="3"){
						if(record.cIsValid!="1"){
					   		nui.alert("序号为"+rows[i].lResultNo+"指令/建议已无效，不能再做审批确认操作！","提示");
					    	return;
					   	}
						//封装主键ID字段传输到后台处理开始...
			    		jsonParams = {processId: rows[i].lResultId, vcInstructSource: rows[i].vcInstructSource, processStatus:rows[i].vcProcessStatus};
			    		instructList.push(jsonParams);
	    			}else{		//机器猫业务处理
	    			
	    			//----------------------机器猫业务开始--------------------------------------------------
	    				// 机器猫买卖指令参数
			    		var validStr = "";//有效无效验证字符串
						var combProductName = record.vcProductName;//产品名称
						var investProductNum = record.vcProductCode;//编号
			        	var validStatus = record.cIsValid;
			        	var processStatus = record.vcProcessStatus;
			        	
			        	if(validStatus!="1"){
			        		validStr += "、" + investProductNum + "-" + combProductName;
			        	}
			    		if(validStr!=null && validStr!="" && validStr.length>0){
			    			validStr = validStr.substr(1,validStr.length);
			    			var msg = "【"+validStr+"】</br>指令/建议已无效或退回，请先剔除";
			    			nui.alert(msg,"提示");
			    			return;
			    		}
			    		//有效无效验证结束!!!
			    		
			    		
			    		//权限验证开始...
			    		var permissionStr = "";//权限验证字符串
			        	//投顾尚未确认
			        	if(processStatus=="1" || processStatus=="2"){
			        		var userIdRelaType07All = record.userIdRelaType07All!=null?record.userIdRelaType07All:"";//07-产品与投顾确认权限(全部人员)
			        		var userIdRelaType07 = record.userIdRelaType07!=null?record.userIdRelaType07:"";//07-产品与投顾确认权限(过滤自己)
							var userIdRelaTypeA1 = record.userIdRelaTypeA1!=null?record.userIdRelaTypeA1:"";//A1-投顾录入确认可为同一人员
							if(userIdRelaType07All!=null && userIdRelaType07All!=""){//设置了复核人员
								var userIdRelaType07Arr = userIdRelaType07.split(",");//默认过滤自己
								if(userIdRelaTypeA1!=null && userIdRelaTypeA1!=""){//可为同一人员
									userIdRelaType07Arr = userIdRelaType07All.split(",");
								}
								for(var j=0; j<userIdRelaType07Arr.length; j++){
									var userIdTemp = userIdRelaType07Arr[j];
									if(userIdTemp==userId){
										hasPermission = true;
										break;
									};
								};
							}else{
								hasPermission = true;
							}
							if(hasPermission==false){
								permissionStr += "、" + investProductNum + "-" + combProductName;
							}
			        	//投资经理下单操作权限认证
			        	}else if(processStatus=="3"){
			        		//若当前用户有权限处理该指令/建议单，则继续执行，否则记录下该产品
			        		var hasPermission = false;//是否有权限，默认无
							var userIdRelaType02 = record.userIdRelaType02;//该指令/建议单拥有投资经理下单权限的用户ID字符串
							if(userIdRelaType02!=null && userIdRelaType02!=""){
								var userIdRelaType02Arr = userIdRelaType02.split(",");
								for(var j=0; j<userIdRelaType02Arr.length; j++){
									var userIdTemp = userIdRelaType02Arr[j];
									if(userIdTemp==userId){
										hasPermission = true;
										break;
									}
								}
								if(hasPermission==false){
									permissionStr += "、" + investProductNum + "-" + combProductName;
								}
							}
			        	}
			        	if(permissionStr!=null && permissionStr!="" && permissionStr.length>0){
			    			permissionStr = permissionStr.substr(1,permissionStr.length);
			    			var msg = "您没有权限确认【"+permissionStr+"】指令/建议，请先剔除";
			    			nui.alert(msg,"提示");
			    			return;
			    		}
			    		//权限验证结束!!!
			    		
			    		
			    		//封装主键ID字段传输到后台处理开始...
			    		jsonParams = {processId: record.lResultId, vcInstructSource: record.vcInstructSource, processStatus:record.vcProcessStatus};
			    		instructList.push(jsonParams);
	    			}
				}
				var msg = "确定要确认所选的 " + rows.length + " 条指令/建议吗？";
	    		nui.confirm(msg,"系统提示",function(action){
					if(action=="ok"){
						var a = nui.loading("正在处理中,请稍等...","提示");
						nui.ajax({
					    	url: "com.cjhxfund.ats.sm.comm.TaskManager.bacthSubmitWorkBiz.biz.ext",
					      	type: 'POST',
					      	data: {tasks:instructList, webType:'1'},			// webType:1买卖指令，2回购指令
					      	contentType: 'text/json',
					      	success: function(text){
					      		nui.hideMessageBox(a);
					      		var returnJson = nui.decode(text);
					      		if(returnJson.resultInfoList.length>0){
					      			nui.open({
							            url: "<%=request.getContextPath()%>/sm/comm/instruct/tansaction_instruct/instructApproveResultInfoList.jsp",
							            title: "审批返回信息",
							            width: 700,
							            height: 415,
							            onload: function () {
							                var iframe = this.getIFrameEl();
							                // 直接从页面获取，不用去后台获取
							                iframe.contentWindow.setFormData(returnJson.resultInfoList);
							            },
							            ondestroy: function (action) {//弹出页面关闭前
					    					search();
								        }
							        });
					      		}
					      	}
				 		});
					}
				});
			} else {
				nui.alert("请选中一条记录","提示");
			}
		}	
		
		function reloadData(){
			todays_instruct_grid.reload("com.cjhxfund.ats.sm.comm.InstructionManager.queryCombineInstructInfo.biz.ext");
			clearDetail();
		}
		
		//行双击时弹出页面展示该指令/建议明细信息
	    todays_instruct_grid.on("rowdblclick", function (e) {
	    	var row = e.record;
		    if (row) {
		    	nui.open({
		            url: "<%=request.getContextPath()%>/sm/comm/instruct/tansaction_instruct/instructDetailShow_zqmm_tg.jsp",
		            title: "指令/建议详细展示",
		            width: 700,
		            height: 400,
		            onload: function () {
		                var iframe = this.getIFrameEl();
		                // 直接从页面获取，不用去后台获取
		                iframe.contentWindow.setFormData(row);
		            },
		            ondestroy: function (action) {//弹出页面关闭前
    					var iframe = this.getIFrameEl();
			            //获取选中、编辑的结果
			            var returnJson = iframe.contentWindow.getData();
			            
			            returnJson = mini.clone(returnJson);    //必须。克隆数据。
			            if(returnJson!= null){
							if(returnJson.exception == null){
								if(returnJson.rtnCode == "0"){
		                    		var alsertMsg = "";
		                			if(returnJson.rtnMsg){
		                				alsertMsg = "</br>此单已退回！</br>退回原因："+returnJson.rtnMsg;
		                			}
		                			nui.alert("操作成功！"+alsertMsg,"系统提示",function(action){
						    			if(action == "ok"){
											search();
						    			}
					    			});
									nui.get("batchConfirm").disable();
							    	nui.get("backConfirm").disable();
									nui.get("edit").disable();
							    	nui.get("remove").disable();
								}else if(returnJson.rtnCode == "-1"){
									nui.alert("审批失败</br>"+returnJson.rtnMsg,"系统提示");
								}else if(returnJson.rtnCode == "0200"){
					    			nui.alert("审批成功"+"</br>"+returnJson.rtnMsg,"系统提示",function(action){
						    			if(action == "ok"){
											search();
						    			}
					    			}); 
									nui.get("batchConfirm").disable();
							    	nui.get("backConfirm").disable();
									nui.get("edit").disable();
							    	nui.get("remove").disable();
								}else if(returnJson.rtnCode == "0301"){
									nui.alert("审批失败,触发禁止风控,风控信息如下：</br>"+returnJson.rtnMsg,"系统提示");
								}else if(returnJson.rtnCode == "0202"){
									nui.alert("审批失败</br>"+returnJson.rtnMsg,"系统提示");
								}else{
									nui.alert("操作异常","系统提示");
								}
							}else{
								nui.alert("操作异常","系统提示");
							}
						}else{
		            		if(action == "ok"){
		    					search();
		    				}
						}
			        }
		        });
		    }
	    });
	    
	    //查看流程图
		function viewFlowChart(){
			window.open(nui.context+"/com.cjhxfund.foundation.task.ProcessChart.flow?processInstID="+selectArr[0].lProcessinstId);
		}
		
		// 添加指令/建议页面跳转
		function addInstruct(){
    		nui.open({
	    		url:"<%=request.getContextPath() %>/transaction/investNew/makeInstruct.jsp",
    			title:"下达投资指令/建议", 
    			width:1070,
    			height:507,
    			allowResize:false,
    			onload:function(){
    			    var iframe = this.getIFrameEl();
	    			var tabIndex=0;//激活第0个tab
				    iframe.contentWindow.initWin(tabIndex,null);
    			},
    			ondestroy: function (action) {
					search();
    			}
    		});	
		}
		
		//复制指令/建议
		function copyInstruct(rowid){
            var row = todays_instruct_grid.getRow(rowid);
			if(rowid == undefined){
				row = todays_instruct_grid.getSelected();			
			}
			var tabIndex = 0;
			if(row.vcInstructSource == "3"){//只能复制新平台的指令
			    if(row.vcBizType == "1"){//银行间现券买卖
					tabIndex=0;
				}else if(row.vcBizType == "2"){//上海大宗
					tabIndex=2;
				}else if(row.vcBizType == "3"){//上交所固收交易平台现券买卖
					tabIndex=1;
				}else if(row.vcBizType == "4"){//深交所综合协议平台现券买卖
					tabIndex=3;
				}
		    	nui.open({
					url: "<%=request.getContextPath() %>/transaction/investNew/makeInstruct.jsp",
					title: "复制增加",
					width:1070,
    			    height:507,
					onload: function () {
						var iframe = this.getIFrameEl();
						row["operatorType"] = "2";//0-新建指令/建议 1-编辑指令/建议 2-复制指令
				        iframe.contentWindow.initWin(tabIndex,row);
					},
					ondestroy: function (action) {
    					search();
					},
				});
			}else{
			    nui.alert("该笔指令为老机器猫指令！","系统提示");
			}
		}
		
		//翻译指令来源
	    function rendererInstructResource(e){
	    	return nui.getDictText("instructResource", e.row.instructSource);
	    }
	    
	    //全屏显示
		function fullScreen(){
			window.open('<%=request.getContextPath()%>/sm/comm/instruct/tansaction_instruct/transactionInstruct.jsp','newwindow','height=100,width=400,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
		}
		
		// 加载指令详情页面
	    function goInstructDetail(rowid){
	    	var row = todays_instruct_grid.getRow(rowid);
			if(rowid == undefined){
				row = todays_instruct_grid.getSelected();			
			}
		    if (row) {
		    	nui.open({
		            url: "<%=request.getContextPath()%>/sm/comm/instruct/tansaction_instruct/instructDetailShow_zqmm_tg.jsp",
		            title: "指令/建议详细展示",
		            width: 700,
		            height: 400,
		            onload: function () {
		                var iframe = this.getIFrameEl();
		                // 直接从页面获取，不用去后台获取
		                iframe.contentWindow.setFormData(row);
		            },
		            ondestroy: function (action) {//弹出页面关闭前
    					var iframe = this.getIFrameEl();
			            //获取选中、编辑的结果
			            var returnJson = iframe.contentWindow.getData();
			            
			            returnJson = mini.clone(returnJson);    //必须。克隆数据。
			            if(returnJson!= null){
							if(returnJson.exception == null){
								if(returnJson.rtnCode == "0"){
		                    		var alsertMsg = "";
		                			if(returnJson.rtnMsg){
		                				alsertMsg = "</br>此单已退回！</br>退回原因："+returnJson.rtnMsg;
		                			}
		                			nui.alert("操作成功！"+alsertMsg,"系统提示",function(action){
						    			if(action == "ok"){
											search();
						    			}
					    			});
									nui.get("batchConfirm").disable();
							    	nui.get("backConfirm").disable();
									nui.get("edit").disable();
							    	nui.get("remove").disable();
								}else if(returnJson.rtnCode == "-1"){
									nui.alert("审批失败</br>"+returnJson.rtnMsg,"系统提示");
								}else if(returnJson.rtnCode == "0200"){
					    			nui.alert("审批成功"+"</br>"+returnJson.rtnMsg,"系统提示",function(action){
						    			if(action == "ok"){
											search();
						    			}
					    			}); 
									nui.get("batchConfirm").disable();
							    	nui.get("backConfirm").disable();
									nui.get("edit").disable();
							    	nui.get("remove").disable();
								}else if(returnJson.rtnCode == "0301"){
									nui.alert("审批失败,触发禁止风控,风控信息如下：</br>"+returnJson.rtnMsg,"系统提示");
								}else if(returnJson.rtnCode == "0202"){
									nui.alert("审批失败</br>"+returnJson.rtnMsg,"系统提示");
								}else{
									nui.alert("操作异常","系统提示");
								}
							}else{
								nui.alert("操作异常","系统提示");
							}
						}else{
							if(action == "ok"){
		    					search();
		    				}
						}
						nui.get("batchConfirm").disable();
				    	nui.get("backConfirm").disable();	
			        }
		        });
		    }
	    }
	    
	    //查询--所有业务通用
		function autoSearch() {
			//获取之前选中记录的主键ID，刷新后继续选中之前记录
			var rows_search = selectArr;
			var rowIds_search = "";
			for(var i=0; i<rows_search.length; i++){
				rowIds_search += rows_search[i].lResultId;
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
		    				if (row.lResultId == rowIdsArr[i]){
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
    </script>
</body>
</html>