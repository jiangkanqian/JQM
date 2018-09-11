<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/common/js/commscripts.jsp" %>
<%--
- Author(s): CJ-WB-DT13
- Date: 2016-01-25 17:40:16
- Description:
    --%>
    <head>
        <title>
            已办
        </title>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <%
        String jurisdiction =  "All";
     %>
     <script type="text/javascript" src="<%=request.getContextPath() %>/common/js/commonjs.js"></script>
    </head>
    <body style="width:100%;height:100%;overflow: hidden; margin: 0px;">
<!--       <div class="nui-tabs" id="tabs" style="width:100%;height:100%;">
         <div title="申购缴款" > -->
           <div class="search-condition" >
			  <div class="list">
	            <div id="form1" class="nui-form"  align="center" >
	                <!-- 数据实体的名称 -->
	                <input class="nui-hidden" name="bizCriteria/_entity" value="com.cjhxfund.foundation.task.EntityDataSet.queryFinishWorkItems">
	                <input class="nui-hidden" name="wfCriteria/_entity" value="com.eos.workflow.data.WFWorkItem" />
	                
	                <input class="nui-hidden" name="jurisdiction" value="<%=jurisdiction %>"/>
	                <!-- 排序字段 -->
	                <table id="table1" class="table" style="width: 100%;" border="0">
	                    <tr>
	                        <td class="form_label" width="100px" align="right">
	                       业务日期:
	                        </td>
	                        <td colspan="1" style="width: 19%;" align="left">
	                            <input class="nui-datepicker" id="dApplicationTime" name="bizCriteria/_expr[1]/applicationTime" format="yyyy-MM-dd" 
	                            showClose="true" oncloseclick="onCloseClickValueEmpty" width="90%"/>
	                            <input class="nui-hidden" name="bizCriteria/_expr[1]/_op" value="=">
	                        </td>
	                        <td class="form_label" style="width: 100px;" align="right">
	                        产品名称:
	                        </td>
	                        <td colspan="1" style="width: 19%;" align="left">
	                          <input id="vCFundCode_ZJTC" class="nui-buttonedit" name="bizCriteria/_expr[2]/vcProductCode" id="combProductCode" onbuttonclick="ButtonClickGetFundName_ZJTC"
	                          showClose="true" oncloseclick="onCloseClickValueEmpty" width="90%"/>
	                          <input class="nui-hidden" name="bizCriteria/_expr[2]/_op" value="in">
	                        </td>
	                        <td class="form_label" style="width: 100px;" align="right">
	                            业务类别:
	                        </td>
	                        <td colspan="1" align="left" style="width: 15%;">
	                            <input class="nui-dictcombobox" dictTypeId="ATS_TASK_BIZ_TYPE" name="bizCriteria/_expr[3]/vcProcessType" id="vcProcessType" width="90%"
	                            emptyText="全部" nullItemText="全部" multiSelect="true" valueFromSelect="true" showClose="true" oncloseclick="onCloseClickValueEmpty"/>
	                            <input class="nui-hidden" name="bizCriteria/_expr[3]/_op" value="in">
	                        </td>
	                        <td class="form_label" align="right" style="width: 110px;">
								指令/建议编号:
			                </td>
			                <td colspan="1" align="left" style="width: 15%;">
								<input class="nui-textbox" name="bizCriteria/_expr[4]/lInvestNo" showClose="true" width="90%" oncloseclick="onCloseClickValueEmpty"/>
								<input class="nui-hidden"  name="bizCriteria/_expr[4]/_op" value="="/>
							</td>
	                   </tr>
	                   <tr>  
						  	<td class="form_label" align="right">
                        	证券代码:
                          	</td>
                          	<td colspan="1" align="left">
                          		<input class="nui-textbox" name="bizCriteria/_expr[5]/vcStockCode" id="vcStockCode"  width="90%"
                          		showClose="true" oncloseclick="onCloseClickValueEmpty"/>
                          		<input class="nui-hidden"  name="bizCriteria/_expr[5]/_op" value="like"/>
                          		<input class="nui-hidden"  name="bizCriteria/_expr[5]/_likeRule" value="all"/>
                          	</td>
                         	<td class="form_label" align="right">
                       		 证券名称:
                        	</td>
                        	<td colspan="1" align="left">
                          		<input class="nui-textbox" name="bizCriteria/_expr[6]/vcStockName" id="vcStockName"  width="90%"
                          		showClose="true" oncloseclick="onCloseClickValueEmpty"/>
                          		<input class="nui-hidden"  name="bizCriteria/_expr[6]/_op" value="like"/>
                          		<input class="nui-hidden"  name="bizCriteria/_expr[6]/_likeRule" value="all"/>
                        	</td>
							<td class="form_label" align="right">
								流程状态:
			                </td>
				            <td colspan="2" align="left">
								<div id="ck1" name="today" class="mini-checkbox" readOnly="false" value="true" text="当天已办流程"></div>
								&nbsp;
								<div id="productId" name="productId" class="mini-checkbox" value="true" readOnly="false" text="本人已办流程" ></div>  
								&nbsp;
								<div id="whetherindia" name="whetherindia" class="mini-checkbox" readOnly="false" text="已用印" ></div>   
							</td>
							<td colspan="1" align="left">
	                        	<input class='nui-button' plain='false' text="查询" iconCls="icon-search" onclick="search()" />
	                        	&nbsp;
	                        	<a id="query" class='nui-button' plain='false' iconCls="icon-reset" onclick="reset()">
					                                                重置
					      		</a> 
	                        </td>
	                    </tr>
	                </table>
	            </div>
          </div>
        </div>  
        <div class="nui-toolbar" style="border-bottom:0;padding:0px;">
                <table style="width:100%;">
                    <tr>
                        <td style="width:100%;">
                            <privilege:operation sourceId="ATS_RW_YB_FQ" sid="Abandoned" clazz="nui-button" onClick="Abandoned()" lableName="废弃"  iconCls="icon-remove" ></privilege:operation>
                            <privilege:operation sourceId="ATS_RW_YB_LCT" sid="flowChart" clazz="nui-button" onClick="flowChart()" lableName="查看流程图"  iconCls="icon-search" ></privilege:operation>
                            <privilege:operation sourceId="ATS_RW_YB_FJXZ" sid="fileDownload" clazz="nui-button" onClick="fileDownload()" lableName="附件下载"  iconCls="icon-download" ></privilege:operation>
                        </td>
                    </tr>
                </table>
            </div>
        <div class="nui-fit">
                <div id="datagrid1"
                        dataField="wflist"
                        class="nui-datagrid"
                        style="width:100%;height:100%;overflow: hidden;"
                        url="com.cjhxfund.foundation.task.common.queryFinishWorkItems.biz.ext"
                        pageSize="20"
                        onselectionchanged="selectionChanged"
                        onShowRowDetail="onShowRowDetailList"
                        showPageInfo="true"
                        multiSelect="true"
                        allowSortColumn="true"
                        sortField="dApplicationTime"
                        sortOrder="desc">

                    <div property="columns">
                        <div type="checkcolumn"></div>
                        <div type="expandcolumn"></div>
                        <div type="indexcolumn"></div>
                        <div name="action" width="40" align="center" headerAlign="center">操作</div>
                        <div field="lProcessInstId" headerAlign="center" width="20px" allowSort="true" visible="false">
                            流程编号
                        </div>
                        <div field="workitemid" headerAlign="center" width="20px" allowSort="true" visible="false">
                           工作项 编号
                        </div>
                        <div field="lBizId" headerAlign="center" width="20px" allowSort="true" visible="false">
                           业务编号
                        </div>
                        <div field="lApplyInstId" headerAlign="center" width="20px" allowSort="true" visible="false">
                            业务申购ID
                        </div>
                        <div field="actionurl" headerAlign="center" allowSort="true" visible="false">
                           url
                        </div>
                        <div field="workitemname" headerAlign="center" allowSort="true" width="150px" >
                           当前节点
                        </div>
                        <div field="dApplicationTime" headerAlign="center" align="center" width="140px" allowSort="true" dateFormat="yyyy-MM-dd HH:mm:ss">
                           业务日期
                        </div>
                        <div field="vcProductName" headerAlign="center" width="150px" allowSort="true" >
                            产品名称
                        </div>
                        <div field="vcCombiName" headerAlign="center" width="100px" allowSort="true" >
                            组合名称
                        </div>
                        <div field="lInvestNo" headerAlign="center" align="center" allowSort="true" width="50">
                            编号
                        </div>
                        <div field="vcStockCode" headerAlign="center" allowSort="true" width="100px">
                            证券代码
                        </div>
                        <div field="vcStockName" headerAlign="center" allowSort="true" width="150px">
                            证券简称
                        </div>
                        <div field="vcProductCode" headerAlign="center" allowSort="true" visible="false">
                            产品代码
                        </div>
                        <div field="vcCombiNo" headerAlign="center"  allowSort="true" visible="false">
                            组合代码
                        </div>
                        <div field="vcAbstract" headerAlign="center" allowSort="true" >
                          摘要
                        </div>
                        <div field="vcProcessType" headerAlign="center"  width="150px" allowSort="true" renderer="rendererVcProcessType">
                            流程类型
                        </div>
                        
                    </div>
                </div>
            </div>
 <!--         </div>
      </div> -->
 <!--隐藏表单-->
<form action="" name="openForm" method="post" target="_blank">
  <input type="hidden" name="workItemID" id="workItemID"/>
  <input type="hidden" name="processInstID" id="processinstid"/>
  <input type="hidden" name="bizId" id="bizId"/>
  <input type="hidden" name="pageType" id="pageType" value="2"/>
  <input type="hidden" name="investNo" id="investNo"/>
  <input type="hidden" name="currentState" id="currentState"/>
  <input type="hidden" name="processType" id="processType"/>
  <input type="hidden" name="vcExchangeNo" id="vcExchangeNo"/>
  <input type="hidden" name="vcType" id="vcType" value="finish"/>
</form>

<!-- 文档下载  -->
<form id="file_download" method="post">
	<!-- 数据实体的名称 -->
	<input class="nui-hidden" name="processId" id="processId"/>
	<input class="nui-hidden" name="lBizId"  id="lBizId"/>
</form>

<script type="text/javascript">
	nui.parse();
	var grid = nui.get("datagrid1");
	
	//当选择列时
	function selectionChanged(){
		var rows = grid.getSelecteds();
		if(rows.length>1){
			//nui.get("Abandoned").disable();
			nui.get("flowChart").disable();
			nui.get("fileDownload").disable();
			//nui.get("retracement").disable();
		}else{
			//nui.get("Abandoned").enable();
			nui.get("flowChart").enable();
			nui.get("fileDownload").enable();
			//nui.get("retracement").enable();
		}
	}
	
	//渲染行对象
	grid.on("drawcell", function (e) {
		column = e.column,
		row=e.row;

		//action列，超连接操作按钮
		if (column.name == "action") {
			var workItemID = row.workitemid;
			if(workItemID == undefined){
			  workItemID = 0;
			}
 			e.cellStyle = "text-align:left";
			if(row.vcProcessType&&(row.vcProcessType=='11'||row.vcProcessType=='12'||row.vcProcessType=='13'||row.vcProcessType=='14'||row.vcProcessType=='15')){
				var url = '<%=request.getContextPath() %>'+"/com.cjhxfund.fpm.bpsExpend.getTaskInfo.flow?processInstID="+e.row.lProcessInstId;
				e.cellHtml = "<a class='nui-button' plain='false' style='cursor:pointer;text-decoration:underline;'  onclick='wfOpenWin(\""+url+"\")'>查看</a>";
			} else {
				e.cellHtml = "<a class='nui-button' plain='false' style='cursor:pointer;text-decoration:underline;'  onclick='wfOpenWin(\""+row.actionurl+"\",\""+row.lProcessInstId+"\",\""+workItemID+"\",\""+row.lBizId+"\",\""+row.vcProcessType+"\",\""+row.lInvestNo+"\",\""+row.currentstate+"\",\""+row.vcPaymentPlace+"\")'>详情</a>";
			}
		}       
	});
	
		
	//行双击时弹出页面展示该指令/建议详细信息
	grid.on("rowdblclick", function (e) {
	alert();
	debugger;
		if(e.row.vcProcessType&&(e.row.vcProcessType=='11'||e.row.vcProcessType=='12'||row.vcProcessType=='13'||row.vcProcessType=='14'||row.vcProcessType=='15')){
			var url = '<%=request.getContextPath() %>'+"/com.cjhxfund.fpm.bpsExpend.getTaskInfo.flow?processInstID="+e.row.lProcessInstId;
			wfOpenWin(url);
		} else {
		
		
			wfOpenWin(e.row.actionurl,e.row.lProcessInstId,e.row.workitemid,e.row.lBizId,e.row.vcProcessType,e.row.lInvestNo,row.currentstate,row.vcPaymentPlace,"100%","100%");
		}
	});
    
    //打开审批界面
	function wfOpenWin(url,processInstID,workItemID,bizId,vcProcessType,investno,currentState,vcExchangeNo,vcType,width,height) {
		var winFrm=document.openForm;
		document.getElementById("processinstid").value=processInstID;
		document.getElementById("investNo").value=investno;
		document.getElementById("currentState").value = currentState;
		document.getElementById("vcExchangeNo").value = vcExchangeNo;
		
		if(workItemID == undefined){
			workItemID = 0;
		}
		document.getElementById("workItemID").value=workItemID;
		document.getElementById("bizId").value=bizId;
		//var businessType = nui.get("vcProcessType").getValue();
	 	if(vcProcessType == '101' || vcProcessType == '102' || vcProcessType == '103'){
			url = '<%=request.getContextPath() %>'  + url;
		}
		if(vcProcessType == '9'){
			var data={processInstID:processInstID};
			var json=nui.encode(data);
			$.ajax({
				url:"com.cjhxfund.foundation.task.common.queryFinishMyWork.biz.ext",
				type:'POST',
				data:json,
				contentType:'text/json',
				success:function(text){
					var returnJson = nui.decode(text);
					if(returnJson.workDatas.length > 1){
						nui.open({
				        	url:"<%= request.getContextPath() %>/task/chooseWork.jsp?processInstID="+processInstID,
				            title: "选择查询的已办环节",
				            width: 500,
				            height: 380,
			                ondestroy: function (action) {
		                    	if (action == "ok") {
		                        	var iframe = this.getIFrameEl();
		                        	var data = iframe.contentWindow.GetData();
		                        	data = nui.clone(data);    //必须
		                        	var actionUrl=data.ACTIONURL; //获取选择的环节的URL
		                        	//获取选择环节的工作项
		                        	var workItemID=returnJson.workDatas[0].WORKITEMID;
									//重置表单的workitemid
									document.getElementById("workItemID").value=workItemID;
		                        	url = '<%=request.getContextPath() %>'  + actionUrl;
									var actionURL=url; //目标页面
									winFrm.action=actionURL;
									var newwin = window.open('about:blank', 'newWindow'+bizId);
									winFrm.target = 'newWindow'+bizId;//这一句是关键
									winFrm.submit();
		                    	}
			
			                }
            			});
					}else if(returnJson.workDatas.length== 1){
						var actionUrl=returnJson.workDatas[0].ACTIONURL;
						var workItemID=returnJson.workDatas[0].WORKITEMID;
						document.getElementById("workItemID").value=workItemID;
						url = '<%=request.getContextPath() %>'  + actionUrl;
						var actionURL=url; //目标页面
						winFrm.action=actionURL;
						var newwin = window.open('about:blank', 'newWindow'+bizId);
						winFrm.target = 'newWindow'+bizId;//这一句是关键
						winFrm.submit();
					}
				}
			});
		}else{
			var actionURL=url; //目标页面
			winFrm.action=actionURL;
			var newwin = window.open('about:blank', 'newWindow'+bizId);
			winFrm.target = 'newWindow'+bizId;//这一句是关键
			winFrm.submit();  
		}
		  
		
	}
		
		
	function rendererWorkitemName(e){
		if(e.row.workitemNames == null){
			return "流程已结束";
		}else{
			return e.row.workitemNames;
		}
	}
		
	//指令/建议废弃
	function Abandoned(){
		var rows = grid.getSelected();
			if(rows){
				if(rows.currentstate == 7 || rows.currentstate == 8){
					nui.alert("该指令/建议已经结束,不能再次废弃!","系统提示");
					return;
				}
				var vcProcessType = rows.vcProcessType;
				var vcProcessTypeName = nui.getDictText("ATS_TASK_BIZ_TYPE",vcProcessType);
     			if(vcProcessType <= 8){
					nui.confirm("确定要废弃选中的指令/建议吗？","系统提示",
					function(action){
						if(action=="ok"){
							nui.prompt("请输入废弃原因：", "请输入",
								function (action, value) {
						            if (action == "ok") {
										if(value==null || value==""){
											nui.alert("请输入废弃原因再提交！");
						                    return;
						                }
											var json = nui.encode({processinstid:rows.lProcessInstId,lInvestNo:rows.lInvestNo,comments:value,workitemId:rows.workitemid,bizId:rows.lBizId});
											grid.loading("正在废弃中,请稍等...");
											$.ajax({
												url:"com.cjhxfund.ats.fm.instr.FirstGradeBond.firstGradeBondeAbandoned.biz.ext",
												type:'POST',
												data:json,
												cache: false,
												contentType:'text/json',
												success:function(text){
													var returnJson = nui.decode(text);
													if(returnJson.returnValue == "yes"){
														grid.reload();
														nui.alert("指令/建议:"+rows.lInvestNo+",废弃成功", "系统提示", function(action){});
													}else if(returnJson.returnValue == "12"){
														grid.unmask();
														nui.alert("流程已结束，不能废弃", "系统提示");
													}else if (returnJson.returnValue ="timeWait"){
														grid.unmask();
														nui.alert("当前流程正在审批中，请耐心等待！");
													}else{
														grid.unmask();
														nui.alert("废弃失败", "系统提示");
													}
												}
											});
										}
									},
					            	true
								);
							}
						}
					);	
				}else{
					nui.alert(vcProcessTypeName + "业务不能废弃指令/建议!","系统提示");
					return ;
				}	         	
			}else{
				nui.alert("请选择一条指令/建议。","提示");
			}
	}
    
    //查看流程图 --所有业务通用
    function flowChart(){
        var rows = grid.getSelected();
        if(rows != null){
  			//process/processGraph.jsp
        	window.open("<%=request.getContextPath() %>/com.cjhxfund.foundation.task.ProcessChart.flow?processInstID="+rows.lProcessInstId);
        }else{
            nui.alert("请先选择指令/建议.","系统提示");
        }
    }    
	var jurisdiction = '<%=request.getParameter("jurisdiction") %>';
	if(jurisdiction =="All"){
		//nui.get("retracement").disable();
	}
	
	//附件下载--所有流程通用
	function fileDownload(){
		var rows = grid.getSelected();
		if(rows != null){
			//设置参数
			nui.get("processId").setValue(rows.lProcessInstId);
			nui.get("lBizId").setValue(rows.lBizId);
			var json = nui.encode({map:{bizId:rows.lBizId}});
			$.ajax({
				url:"com.cjhxfund.ats.fm.comm.attachUitlFunction.queryAttachmentList.biz.ext",
				type:'POST',
				data:json,
				cache: false,
				contentType:'text/json',
				success:function(text){
					var returnJson = nui.decode(text);
					if(returnJson.total > 0){
						//给出提示并调用下载逻辑
						nui.confirm("确认要下载吗？","系统提示",function(action){
							if(action=="ok"){
								var form = document.getElementById("file_download");
								form.action = "com.cjhxfund.foundation.task.FileDownload.flow";
			        			form.submit();
							}
						});
					}else{
						nui.alert("当前指令/建议下没有附件。","系统提示");
						return;
					}
				}
			});		
		}else{
		   nui.alert("请先选择指令/建议.","系统提示");
		}
	}
	
	function onvcPaymentPlace(e){
	  	return nui.getDictText("CF_JY_DJTGCS",e.row.vcPaymentPlace);;
	}
</script>
<script src="<%= request.getContextPath() %>/task/util/firstGradeDebt.js" type="text/javascript"></script>
  </body>
</html>
