<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" session="false" %>	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/bpsExpend/common/processCommon.jsp"%>

	<head>
	 <style type="text/css">
	     .mini-grid-cell2{
	     	text-align: center;
	     	color: red;
	     	font-size: 12pt;
	     }
	     #processTable td{
	     	vertical-align: middle;
	     }
	     .comm-comments-text-ellipsis .mini-grid-rows-content table,
	     .comm-comments-text-ellipsis .mini-grid-rows-content tbody,
	     .comm-comments-text-ellipsis .mini-grid-rows-content tr,
	     .comm-comments-text-ellipsis .mini-grid-rows-content td{
	     	    display: block; 
	     } 
	     .comm-comments-text-ellipsis .mini-grid-rows-content,
	     .comm-comments-text-ellipsis .mini-listbox-view{
	     		overflow: hidden;
	     }
	     .comm-comments-text-ellipsis .mini-grid-rows-content tr .mini-listbox-checkbox{
	     	    display: none; 
	     } 
	</style>
	<title>我的任务</title>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<!-- 
	  - Author(s): zengjing
	  - Date: 2017-08-03 10:33:56
	  - Description:
	-->
	</head>
    <body style="width: 100%;height:99%;">
		<div id="processForm" style="padding-top: 5px;" >
	  		<!-- 流程缓存属性开始 -->
	        <input type="hidden" class="nui-hidden" name="workitem.workItemID" />
	        <input type="hidden" class="nui-hidden" name="workitem.processInstID" />
	        <input type="hidden" class="nui-hidden" name="workitem.activityInstID" />
	        <input type="hidden" class="nui-hidden" name="workitem.activityInstName" />
	        <input type="hidden" class="nui-hidden" name="workitem.activityDefID" />
	        <input type="hidden" class="nui-hidden" name="workitem.processInstName" />
	        <input type="hidden" class="nui-hidden" name="workitem.rootProcInstID" />
	        <input type="hidden" class="nui-hidden" name="workitem.processDefID" />
	        <!-- 流程缓存属性结束 -->
	
	        <%-- 分支条件 --%>
	        <input type="hidden" class="nui-hidden" id="branchYN"  value="<b:write property="YN" />"/>
	        
	        	<table id="processTable"  style="width: 98%;  table-layout: fixed;" class="nui-form-table">
					<tr class="odd">
						<th class="nui-form-label" style="width: 13%">流程名称：</th>
						<td colspan="3">
						    <b:write property="processInst/processInstName" />
						</td>
					</tr>
					<tr>
						<th class="nui-form-label"  style="width: 13%">当前参与者：</th>
						<td colspan="1"	style="vertical-align: middle;" id="nextActorTd">
						    <b:write property="nextActor"/>
						</td>
						<th class="nui-form-label"  style="width: 13%"><l:notEmpty property="lastActor">上一参与者：</l:notEmpty></th>
						<td id="lastActorTd" style="vertical-align: top;">
						    <b:write property="lastActor" />				
						</td>						
					</tr>
					<l:equal property="workitem/processDefName" targetValue="com.cjhxfund.fpm.design.publicProductDesignFlow">
				    <l:in property="workitem/activityDefID" propertyType="scope" targetValue="manualActivitym2b1,manualActivitym2b2" seperator=",">
		    			<tr>
		    				<th></th>
			    			<td><font style="color:blue;">(大于2/3评审人同意即可通过会签)</font>
					    	</td>
				    	</tr>
				    </l:in>
				    </l:equal>
					<!-- 流程操作控制 -->
					<tr  class="odd" id="operateTypeTr">
						<th class="nui-form-label">操作：</th>
						<td colspan="3" class="radio-border-top-none">
								<input name="bpsParam.operateType" id="operateType" class="nui-radiobuttonlist" onitemclick="operateCheck(this)" />
								<input id="bpsAuth_vetoAuth" class="nui-hidden" value="<b:write property="bpsAuth/vetoAuth" />"/>
								<input class="nui-hidden" name="bpsParam.sendMailAuth"/>
						</td>						
					</tr>
					
					<!-- 流程退办控制 -->
					<tr id="backActivity_tr" style="display: none;">
						<th class="nui-form-label" style="width:13%">退办：</th>
						<td colspan="1"  style="width:30%">
	    					<span id="noActivitySpan" style="display: none;color: blue;">无可退办环节</span>
	    					<input id="backActivity" name="bpsParam.backActivity" class="nui-combobox" textField="activityinstname" valueField="activitydefid"  style="width:100%">
						</td>
						<td colspan="2" style="width:57%" >
	    					<div  id="isReAudit" name="bpsParam.isReAudit" class="nui-radiobuttonlist" 
	    					style="display: none;width:100%" 
	    					data="[{id: '0', text: '驳回后流程重新流转'},{id: '1', text: '驳回的节点通过后直接回到本人'}]" ></div>
						</td>
					</tr>
					
					<!-- 流程转办 -->
					<tr id="handlerActor_tr" style="display: none;">
	                        <th class="nui-form-label" id="handlerActor_td">
	                        <font style="color: red;">*</font><span id="handlerActorTitle">请选择转办人员</span>：
	                        </th>
	                        <td colspan="3" align="left" style="padding-left: 5px;">
	                          <input class="nui-buttonedit" id="handlerActor"  name="bpsParam.handlerActor" onclick="selectSingleEmp" style="width:30%">
	                        </td>
	                </tr>
	                
	                <!-- 流程征求意见-->
					<tr id="helpActor_tr" style="display: none;">
	                        <th class="nui-form-label" id="helpActor_td">
	                        <font style="color: red;">*</font><span id="helpActorTitle">请选择征求意见人员</span>：
	                        </th>
	                        <td colspan="3" align="left" style="padding-left: 5px;">
	                          <input class="nui-buttonedit" id="helpActor"  name="bpsParam.helpActor" onclick="selectMutiEmp" style="width:30%">
	                        </td>
	                </tr>
	                
	                
	                <!-- 是否评审小组再次征求意见控制 -->
	             		<l:equal property="bpsAuth/againAuth" targetValue="1">
	             		<%--处于征求意见--%>
	                 	<l:equal property="workitem/helpState" targetValue="0">
	                 	<tr id="again_tr" >
	                            <th class="nui-form-label" id="again_td">
	                            <font style="color: red;">*</font><span id="againTitle"><b:write property="bpsAuth/againTitle"/></span>：
	                            </th>
	                            <td colspan="3" class="radio-border-top-none">
	                            	<input id="isAgain" name="bpsParam.isAgain" class="nui-radiobuttonlist" onitemclick="againSelectUser(this)" data="[{id: 'Y', text: '是'}, {id: 'N', text: '否'}]"/>
	                            </td>
	                    </tr>
	                    </l:equal>
	                 </l:equal>                
	                
	                <!-- 流程分支控制 -->
	                 <l:equal property="bpsAuth/ynAuth" targetValue="1">
	                 	<%--处于征求意见--%>
	                 	<l:equal property="workitem/helpState" targetValue="0">
	                 	<tr id="yn_tr" >
	                            <th class="nui-form-label" id="yn_td">
	                            <font style="color: red;">*</font><span id="ynTitle"><b:write property="bpsAuth/ynTitle"/></span>
	                            </th>
	                            <td colspan="3" class="radio-border-top-none">
	                            	<input id="yn" name="bpsParam.yn" class="nui-radiobuttonlist"  onitemclick="setCommentBySelect('yn','ynTitle')" data="[{id: 'Y', text: '是'}, {id: 'N', text: '否'}]"/>
	                            </td>
	                    </tr>
	                    </l:equal>
	                    
	                 </l:equal>
	                 
	                 <!-- 显示流程分支控制 -->
	                 <!-- show为true时显示，show的值在页面流中根据实际情况设置 -->
	                 <l:equal property="ynMap/show" targetValue="true">
	                    <tr>
	                        <th class="nui-form-label" id="yn_td">
	                            <span id="ynMapTitle"><b:write property="ynMap/title"/></span>
	                        </th>
	                        <td colspan="3" class="radio-border-top-none">
	                            <l:equal property="ynMap/yn" targetValue="Y">是</l:equal>
	                            <l:equal property="ynMap/yn" targetValue="N">否</l:equal>
	                        </td>
	                    </tr>
	                 </l:equal>
	                 
	               <!-- 流程选择参与者控制 -->  
	               <l:equal property="bpsAuth/participantAuth" targetValue="1">
	               		<%--处于征求意见--%>
	                 	<l:equal property="workitem/helpState" targetValue="0">
	                    <tr id="participant_tr" >
	                            <th class="nui-form-label" id="participant_td">
	                            <font style="color: red;">*</font><span id="participantTitle"><b:write property="bpsAuth/participantTitle"/></span>：
	                            <input class="nui-hidden"  id="selectUserName" name="bpsParam.selectUserName"  >
	                            </th>
	                            <td colspan="3">
	                            <l:equal property="bpsAuth/participantType" targetValue="1">
	                          			<input class="nui-buttonedit" id="selectUser"  name="bpsParam.selectUser" onclick="selectSingleEmp" style="width:300px">
	                            </l:equal>
	                         	<l:equal property="bpsAuth/participantType" targetValue="2">
		                              	<input class="nui-buttonedit"  id="selectUser"  name="bpsParam.selectUser"  onclick="selectMutiEmp" style="width:300px"/>
		                              	<input class="nui-hidden"  id="empsName"  value="${empsName}"/>
		                              	<input class="nui-hidden"  id="empsValue"  value="${bpsParam.selectUser}"/>
	                            </l:equal>
	                            </td>
	                    </tr>
	                     </l:equal>
	                </l:equal>
	                
	                <%--<!-- 流程抄送人员控制 -->
	                <l:equal property="bpsAuth/sendAuth" targetValue="1">
	                	<!--处于征求意见-->
	                 	<l:equal property="workitem/helpState" targetValue="0">--%>
	                    	<tr id="send_tr" >    
	                            <th class="nui-form-label" id="masterid" >
	                            	抄送方式：
		                        </th>
		                    	<td colspan="1">
		                    		<div id="cbl1" class="nui-checkboxlist"name="bpsParam.sendType" onvaluechanged="showHideSend"data="[{text:'系统通知',id:'notice'},{text:'邮件',id:'mail'},{text:'传真',id:'fix'}]" style="width:100%"/>
		                    	</td>  
		                    </tr>
	                    	<!-- 邮件信息 -->
							<tr id="send_info_tr1" >
								<th class="nui-form-label" id="masterid" >邮件主题：</th>
								<td colspan="1">
									<input class="nui-textbox" name="bpsParam.mailTitle" id="mailTitle" width="80%" value=""/>
								</td>
								<th class="nui-form-label" id="masterid" ><label style="color: red;">*</label>邮件主送:</th>
								<td colspan="1">
									<input class="nui-textbox" name="bpsParam.to" id="mailTo"  width="80%"/>
								</td>
							</tr>
							<tr id="send_info_tr2" >
								<th class="nui-form-label" id="masterid">邮件抄送：</th>
								<td colspan="1">
									<input class="nui-textbox" name="bpsParam.cc" id="mailCc" width="80%" />
								</td>
							</tr>
							<tr id="send_info_tr3" >
								<th class="nui-form-label" id="masterid">邮件正文：</th>
								<td colspan="3">
									<input class="nui-textarea" name="bpsParam.mailContent" id="mailContent" width="80%" height="60px"/>
								</td>
							</tr>
	                    <%--</l:equal>
	                </l:equal>--%>
	                <!-- 流程信息其它特殊的控制 -->
	          </table>
	         <!-- TODO 引用问题 --> 
	        <l:equal property="workitem/processDefName" targetValue="com.cjhxfund.fpm.openAccount.openAccount">
		    	<l:equal property="workitem/activityDefID" targetValue="manualActivitym2">
					 <table style="width: 98%; table-layout: fixed; border-collapse: collapse;" id="allot" >		
							<tr style="border-top: 1px solid #DCDCDC;">
					           		<th class="nui-form-label" style="vertical-align: top;width:13%;"> 
					           		<table style="height: 100%; width:100%;  table-layout: fixed; border-collapse: collapse;">
					           			<tr style="height: 20px;"><td><font style="color: red;" >*</font><span>一起指派的流程：</span></td></tr>
					           			<div class="nui-radiobuttonlist" id="queryTypeRadio">
					           			<tr style="height: 10px;"><td><input type="radio" name="assignType" value="prodName" checked>&nbsp同产品&nbsp&nbsp&nbsp</td>
					           			<tr style="height: 10px;"><td><input type="radio" name="assignType" value="prodType" >&nbsp同类型&nbsp&nbsp&nbsp</td>
					           			</div>
					           		</table>
						           				
					           		</th>
					           		<td colspan="3" style="padding-left: 8px">
					           			<div id="dataTaskId" class="nui-datagrid" style=" width: 100%;height: 250px;"  showPager="true"
										url="com.cjhxfund.fpm.bpsUtil.task.queryTask4All.biz.ext" 	multiSelect="true"   allowUnselect="true" 
										dataField="tasks" pageSize="20">
										    <div property="columns">
										    	<div  type="checkcolumn" width="5%"></div>
										        <div field="processInstName" headerAlign="center"   width="95%">任务名称  </div>
										    </div>
										</div>
									</td>
							</tr>
					</table>
			    </l:equal>
		    </l:equal>
		      <table id="processTable"  style="width: 98%;  table-layout: fixed;" class="nui-form-table">
	                <tr>
						<th class="nui-form-label" style="width: 13%" >处理意见：</th>
						<td colspan="3">
							常用意见：<input class="nui-combobox" id="comm_comments" name="comm_comments" 
								dataField="result" textField="dictName" valueField="dictName" 
								emptyText="请选择..."  showNullItem="true" nullItemText="请选择..."
								onvaluechanged="changeCommentBySelect(this)" specialClass="comm-comments-text-ellipsis"
								url="com.cjhxfund.fpm.bpsExpend.comment.queryCommComments.biz.ext" >  <a class="nui-button" plain="true" iconCls="icon-add" onclick="addComment()" >自定义</a>
							  <input id="comments" onvaluechanged="cleanTheSpace" class="nui-textarea" style="width: 100%; height: 70px" maxLength="512" name="pmprcaprvinfo.comments"/>
						</td>
					</tr>
	                <tr>
				        <th class="nui-form-label" style="vertical-align: top;"> 附件： </th>
			            <td colspan="3">
			            	<!--TODO 暂不修改，以后切换到新的文件管理功能 引用问题 --> 
						</td>
		            </tr>
	        </table>    
			 <table style="width: 98%; table-layout: fixed; border-collapse: collapse; " >
				<tr >
	           		<th class="nui-form-label" style="vertical-align: top;width:13%;">审批意见：</th>
	           		<td colspan="3" style="padding: 5px 12px 5px 12px;">
	           		</td>           		
	           	</tr>
	           	<tr>         	
	           		<td colspan="5"  style="padding-left: 38px">
	           			<div id="processGrid" class="nui-datagrid" dataField="pmprcaprvinfos" style="width: 99%; min-height:150px; max-height:270px;" height="270px"
	           				url="com.cjhxfund.fpm.bpsExpend.aprvInfo.queryAprvInfo.biz.ext"
							multiSelect="true" allowSortColumn="false" showPager="false" allowCellSelect="true"
							allowResizeColumn="false"  allowCellWrap="true">						
							<div style="overflow:auto;" property="columns" >
								<div field="workItemName" headerAlign="center" allowSort="true" width="13%"		visible="true">任务项</div>
								<div field="userName" name="userName" headerAlign="center"  width="7%"	allowSort="true" visible="true">参与者</div>
								<div field="operateType" headerAlign="center" allowSort="true" renderer="onOperateType"  width="7%">操作</div>
								<div field="operatePeople" headerAlign="center" allowSort="true"  width="10%">转办/征求接收人</div>
								<div field="comments" headerAlign="center" allowSort="true" width="33%"	 	visible="true">处理意见</div>
								<div field="startTime" headerAlign="center" allowSort="true" width="13%"		visible="true" dateFormat="yyyy-MM-dd HH:mm:ss ">开始时间</div>
								<div field="endTime" headerAlign="center" allowSort="true" width="13%"	visible="true" dateFormat="yyyy-MM-dd HH:mm:ss ">结束时间</div>
							</div>						
						</div>  
	           		</td>           		
	           	</tr>
	           	<tr style="height: 50px"><td ></td></tr>
			</table>
			
			<div class="nui-toolbar" style="width:99%; border-bottom:2;padding:0px;position: fixed;bottom: 0px; z-index: 99;">
	                <table  style="width:100%; table-layout:fixed;">
	                    <tr>
	                        <td id="excute" style="text-align:center;" colspan="6">
	                            <a class="nui-button" id="processSubBtn" iconCls="icon-ok" onclick="processSubmit()">提交</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	                        	<l:equal property="bizProcess/processCreator"  targetProperty="currentUserId" >
								<a class="nui-button" id="abandon" iconCls="icon-close" onclick="abandonPro('<b:write property="processInst/processInstID"/>','<b:write property="pageType"/>','<b:write property="parTabId"/>')">废弃</a>
								</l:equal>
	                        </td>
	                    </tr>
	                </table>
	        </div>
       </div>
    </body> 
</html>
<script type="text/javascript">
	nui.parse();
	var processForm = new nui.Form("#processForm"); 
	
	var backActivityDefaultValue = "";	
	
	var processDefName = '<b:write property="workitem/processDefName" />';
	var processInstID = '<b:write property="workitem/processInstID"/>';
	var wProcessInstID = '<b:write property="processInst/processInstID"/>';
	var activityInstID = '<b:write property="workitem/activityInstID"/>';
	var activityDefID = '<b:write property="workitem/activityDefID"/>';
	var activityInstName = '<b:write property="workitem/activityInstName" />';
	var workItemID = '<b:write property="workitem/workItemID"/>';
	var bizId = '<b:write property="bizId" />';
	var bizCode = '<b:write property="bizCode" />';
	var fileNameZip = '<b:write property="fileNameZip" />';	
	var parTabId = '<b:write property="parTabId" />';	
	//流程附件定时器
	var fileInterval = setInterval(initProcessFile,1000);
	//防止页面出错，定时器无法结束的情况
	setTimeout(closeAllInterval,5000);
	
	/*--------------------业务页面调用方法-------------------------------*/
	//初始化流程
	initProcess();
	
	//获取是否展示废弃权限
	var resultCheck=null;
	
	//获取操作选项	
	function getOperateType(){
		return nui.get("operateType").getValue();
	}	
	//获取征求意见状态
	function getIsHelpState(){
		//是否处于征求意见状态
		return "<b:write property='workitem/helpState'/>";
	}	
	
	//流程提交方法
	function processSubmit(){
		var busIfr = window.parent.getBusTabIframe();
		//业务页面写了提交方法
		if(busIfr.contentWindow.processSubmit!=null){
			busIfr.contentWindow.processSubmit();
		}else{
			processBaseSubmit();
		}
	}
	
	//纯流程提交
	function processBaseSubmit(){
		var processData = getProcessFormData();
		//流程js验证
		if(checkProcessForm()==false) return false;
		
		var json = nui.encode(processData);
		var urlStr = "com.cjhxfund.fpm.bpsExpend.task.submitTask.biz.ext";
    		nui.ajax({
    			type:"post",
    			url:urlStr,
    			data:json,
    			cache:false,
    			async:false,
    			contentType:'text/json',
    			success:function(text){
    				//关闭tab页面或返回我的任务
                    removeTabOrBackMyTasks("processNew",parTabId);
    			}
    		});
	
	}
	
	//获取流程表单数据
	function getProcessFormData(){
		processForm.setChanged(false);  
		//获取表单数据
		var data = processForm.getData(false,true);
		//获取附件ID	    	
		data.fileIds = getProcessFileIds();
		return data;
	}
	
	
	function initProcess(){
		var jsonstr;
		var thisProcessInstID = processInstID;
		if(processInstID == null){
			thisProcessInstID = wProcessInstID;
		}
		//审批意见
		var processGrid = nui.get("processGrid");
    	jsonstr = {processinstid:thisProcessInstID};
    	processGrid.load(jsonstr);    	
    	//初始化操作权限
    	loadAuditOprate();
    	//因调用时间长，所以取消页面加载
		//初始化回退环节
		//loadActivities();	
		//设置默认人员
		setDefaultEmp();
		//初始化参与者显示
		reSetActor();
		//初始化流程参数
		initProcessParam();
	}
	
	/*设置操作权限
	 * 权限说明：-1,不可退办；0，正常权限，不可废弃；1,废弃权限
	 * 
	 */
	function loadAuditOprate(){
		var operateRight = nui.get("bpsAuth_vetoAuth").value;
		var operateType = nui.get("operateType");
		var operateData = [];
		var agreeVeto = {id:'1',text:'同意'};
		var backVeto = {id:'2',text:'退办'};
		var delegVeto = {id:'3',text:'转办'};
		var helpVeto = {id:'4',text:'征求意见'};
		var rejectVeto = {id:'5',text:'废弃'};
		var disAgreeVeto = {id:'6',text:'不同意'};
		var orAgreeVeto = {id:'7',text:'有条件通过'};
		var suspendVeto = {id:'8',text:'暂缓'};
		//挂起   拟同意 	同意 	退办 	转办	 征求意见 废弃 不同意   (按钮显隐按数字相加值设置)
		//128  64   32  16  8    4    2   1
		if((operateRight&64)==64){//拟同意
			operateData.push(orAgreeVeto);
		}
		if((operateRight&32)==32){//同意
			operateData.push(agreeVeto);
		}
		if((operateRight&16)==16){//退办
			operateData.push(backVeto);
		}
		if((operateRight&8)==8){//转办
			operateData.push(delegVeto);
		}
		if((operateRight&4)==4){//征求意见
			operateData.push(helpVeto);
		}
		if((operateRight&128)==128){//挂起
			operateData.push(suspendVeto);
		}
		if((operateRight&2)==2){//废弃
			operateData.push(rejectVeto);
		}
		if((operateRight&1)==1){//不同意
			operateData.push(disAgreeVeto);
		}
		
		if(operateData==null||operateData==""){
			operateData.push(agreeVeto);//同意
			operateData.push(backVeto);//退办
			operateData.push(delegVeto);//转办
			operateData.push(helpVeto);//征求意见
		} else if (operateData.length==1&&operateData[0].id==1){
			$("#operateTypeTr").css("display","none");//只有同意按钮时隐藏操作行
		}
	    //如果是子流程需要判断显示隐藏
	    var urlStr="com.cjhxfund.fpm.bpsExpend.abandon.checkAbandonProcessInst.biz.ext";
        var json = nui.encode({processInstID:processInstID});
        resultCheck = pm_ajax(json,urlStr,false);
        //console.log(resultCheck);
        //console.log(resultCheck.procFlag);
        if(resultCheck!=null && resultCheck.procFlag=="Y"){
                //console.log(operateData);
            	operateType.load(operateData);	
        }else{
           // 过虑产品名称变更子流程不能废弃
           if(resultCheck!=null && resultCheck.processType=="12"){
	           var currentOperData = new Array();
	           //console.log(operateData);
	           for(var i=0;i<operateData.length;i++){
	               if(operateData[i].text !="废弃"){
	                   currentOperData[i]={id:operateData[i].id,text:operateData[i].text};
	               }
	               
	           }
	           	operateType.load(currentOperData);	
	        }else{
	            operateType.load(operateData);	
	        }
           
        }
	}

	//取回退的活动实例
	function loadActivities(){
		//避免多次调用
		if(nui.get(backActivity).getValue()==null){
			var urlStr = contextPath + "/com.cjhxfund.fpm.bpsExpend.rollback.getRollBackActivitys.biz.ext";
	    	var json = nui.encode({processInstID:processInstID,currentActivityInstID:activityInstID});
	    	$.ajax({
	            url:urlStr,
	            data:json,
	            type:'POST',
	            contentType:'text/json',
	            cache:false,
	            async:false,
	            success:function(d){
	            	if(d && d.activitys) {
	            		var data = d.activitys;
	            		var backActivityCombo = nui.get("backActivity");
	                	backActivityCombo.load(data);
	                	if(data && data.length > 0){
	                		backActivityDefaultValue = data[0].activitydefid;
	                		nui.get("backActivity").setValue(backActivityDefaultValue);
	                		nui.get("isReAudit").show();
	                		nui.get("isReAudit").setValue("0");
	                	}
	            	}else{
	            		jQuery("#noActivitySpan").show();
	            		nui.get("isReAudit").hide();	
	            		nui.get("backActivity").hide();
	            	}
	            }
	            
	       });
       }
	}
	
	//初始化流程参数
	function initProcessParam(){
		var url1 = "com.cjhxfund.fpm.bpsExpend.process.getProcessInfos.biz.ext";
		var json = nui.encode({workitemID:workItemID});
		//common/commonUtil.js 通用方法
		var d1 = pm_ajax(json,url1,false);	
		var data = {workitem:d1.workitem,bpsParam:d1.bpsParam,pmprcaprvinfo:{comments:"同意"}};
		data.bpsParam.operateType = 1;
		//加载表单信息
		processForm.setData(data);
	}
	
	
	//初始化流程附件
	function initProcessFile(){
		var busIfr = window.parent.getBusTabIframe();  
		//console.log("fileInterval执行");
		if(busIfr!=null&&busIfr.contentWindow!=null){
			var thisProcessInstID = processInstID;
			if(processInstID == null||processInstID == ""){
				thisProcessInstID = wProcessInstID;
			}
			if(busIfr.contentWindow.getBizId!=null){
				bizId = busIfr.contentWindow.getBizId();
			}
			if(busIfr.contentWindow.getBizCode!=null){
				bizCode = busIfr.contentWindow.getBizCode();
			}
			if(bizId!=null&&bizId!=""){
				loadProcessFileFrmSrc(bizId,bizCode,thisProcessInstID,activityDefID);
			}
			clearInterval(fileInterval);
			//console.log("fileInterval终止");
		}
	}
	
	//结束所有定时器
	function closeAllInterval(){
		//console.log("closeInterval");
		if(empInterval!=null){
			//console.log(empInterval);
			clearInterval(empInterval);
		}
		if(fileInterval!=null){
			//console.log(fileInterval);
			clearInterval(fileInterval);
		}
	}
	
   //检查表单
	function checkProcessForm() {
		var flag = true;
		var operateType = nui.getbyName("bpsParam.operateType").getValue();
		
		if(operateType==2){//退办
			if(nui.get("backActivity").getValue()==null || nui.get("backActivity").getValue()==""){
				alert("无可退办节点");
				flag = false;
			}
		}
		
	  	if(operateType==3){//转办
	       var size=nui.getbyName("bpsParam.handlerActor").getValue();
	     	if(size.length<=0){
	        	alert("请选择转办人员");
	       		flag = false;
	        }	
		}
		
		if(operateType==4){//征求意见
	       var size=nui.getbyName("bpsParam.helpActor").getValue();
	     	if(size.length<=0){
	        	alert("请选择征求意见人员");
	        	flag = false;
	        }	
		}
		
		if(operateType==5){//废弃
		     	if(!confirm("确认要废弃该流程？")){
		        	flag = false;
		        }	
			}
		
		if(operateType==6){//不同意
		       var size=nui.get("comments").getValue();
		     	if(size.length<=0){
		        	alert("请填写不同意的理由");
		        	flag = false;
		        }	
			}
		
		if(operateType==7){//拟同意
		       var size=nui.get("comments").getValue();
		     	if(size.length<=0){
		        	alert("请填写 有条件通过 的理由");
		        	flag = false;
		        }	
			}
		
		if(document.getElementById("isAgain")!=null&&operateType==1){//是否多人征求意见不为空且同意时才验证
			var size = nui.getbyName("bpsParam.isAgain").getValue();
			var againTitle = document.getElementById("againTitle").innerHTML;
	     	if(size.length<=0){
	        alert("请选择"+againTitle);
	        	flag = false;
	        }
		}
		
		if(document.getElementById("selectUser")!=null&&operateType==1){//流程参与者不为空且同意时才验证
			var size = nui.getbyName("bpsParam.selectUser").getValue();
			var participantTitle = document.getElementById("participantTitle").innerHTML;
			var isAgainFlag = size.length<=0?true:false;
			if(nui.get("isAgain")&&nui.get("isAgain").getValue()=="N"){ //不征求意见时不验证
				isAgainFlag = false;
			}
	     	if(isAgainFlag){
	     		alert("请选择"+participantTitle);
	        	flag = false;
	        }
		}
		
		if(document.getElementById("yn")!=null&&operateType==1){//流程选择不为空且同意时才验证
			var size = nui.getbyName("bpsParam.yn").getValue();
			var ynTitle = document.getElementById("ynTitle").innerHTML;
			var isYNFlag = size.length<=0?true:false;
			if(document.getElementById("selectUser")!=null&&nui.get("isAgain").getValue()=="Y"){//当isAgain存在时并且选择Y，则不验证isYN
				isYNFlag = false;
			}
	     	if(isYNFlag){
	        alert("请选择"+ynTitle);
	        	flag = false;
	        }
		}
		if(nui.get("sendUser")&&nui.get("sendUser").getValue()!=null&&nui.get("sendUser").getValue()!=""&&operateType==1){//选择抄送人员后验证选择抄送方法
			var size = nui.getbyName("bpsParam.sendType").getValue();
	     	if(size.length<=0){
	        alert("请选择抄送方式");
	        	flag = false;
	        }
		}
		
		return flag;
	}
	
	//废弃功能
    //将localType参数，改为pageType参数，杨志文，20161020
    function abandonPro(processInstID,pageType,parTabId){
        var isRunOper=1;
        var urlStr="com.cjhxfund.fpm.bpsExpend.abandon.checkAbandonProcessInst.biz.ext";
        var json = nui.encode({processInstID:processInstID});
        resultCheck = pm_ajax(json,urlStr,false);
        //console.log(resultCheck);
        //console.log(resultCheck.procFlag);
        if(resultCheck!=null && resultCheck.procFlag=="Y"){
                isRunOper=0;
        }else{
           // 过虑产品名称变更子流程不能废弃
           if(resultCheck!=null && resultCheck.processType=="12"){
                isRunOper=1;
           }else{
                isRunOper=0;
           }
           
        }
        if(isRunOper==0){
	    	if(confirm("是否确定废弃该流程？")){
	    		var urlStr = "com.cjhxfund.fpm.bpsExpend.abandon.abandonProcessInstByProcessInstID.biz.ext";
	    		var json = nui.encode({processInstID:processInstID});
	    		nui.ajax({
	    			type:"post",
	    			url:urlStr,
	    			data:json,
	    			cache:false,
	    			async:false,
	    			contentType:'text/json',
	    			success:function(text){
	    				//关闭tab页面或返回我的任务
	                    removeTabOrBackMyTasks('processNew',parTabId);
	    			}
	    		});
	    	 }else{
	    		 return false;
	    	 }
	     }else{
	         nui.alert("子流程不能被废弃","提示");
	     } 
      }
	
	/*
		*流程处理公共方法
		*/
		function operateCheck(ck) {
			var operateType = ck.value;
			//清除自动设置值
			changeOperateCleanStr();
			var commentsVal = nui.get("comments").getValue();
			 if(operateType == 1){//同意
				if(commentsVal==null || commentsVal=="退办" || commentsVal=="转办" || commentsVal=="征求意见" || commentsVal=="废弃"|| commentsVal=="不同意"|| commentsVal==""){
					nui.get("comments").setValue("同意");
				}
				jQuery("#allot").show();
			    jQuery("#handlerActor_tr").hide();
			    jQuery("#backActivity_tr").hide();
			    jQuery("#helpActor_tr").hide();
			    
			    if(document.getElementById("participant_tr")!=null){
		        	jQuery("#participant_tr").show();	
		        	if(document.getElementById("isAgain")!=null&&nui.get("isAgain").getValue()=='N'){//如果有选择联动，且选项是否
		        		jQuery("#participant_tr").hide();
		        	}
		        }
			    if(document.getElementById("send_tr")!=null){
		        	jQuery("#send_tr").show();	
		        }
			    if(document.getElementById("yn_tr")!=null){
		        	jQuery("#yn_tr").show();	
		        }
			    if(document.getElementById("again_tr")!=null){
			    	jQuery("#again_tr").show();
			    	if(nui.get("isAgain")&&nui.get("isAgain").getValue()=="Y")jQuery("#yn_tr").hide();	
			    }
			    
			    if(document.getElementById("openAccountPart_tr2")!=null){
			        jQuery("#openAccountPart_tr2").show();
		        }
			    
			    
			 }else if (operateType == 2){//退办
				//设置默认选中
				if(nui.get("backActivity").getValue()==null&& backActivityDefaultValue!=""){
					nui.get("backActivity").setValue(backActivityDefaultValue);
					nui.get("isReAudit").setValue("0");
				} else {
					setTimeout(loadActivities,100);	
				}
				if(commentsVal==null || commentsVal=="同意" || commentsVal=="转办" || commentsVal=="征求意见" || commentsVal=="废弃"|| commentsVal=="不同意"|| commentsVal==""){ 
					nui.get("comments").setValue("退办");
				}
				 jQuery("#allot").hide();
		        jQuery("#backActivity_tr").show();
		        jQuery("#handlerActor_tr").hide();
		        jQuery("#helpActor_tr").hide();
		        
		        if(document.getElementById("participant_tr")!=null){
		        	jQuery("#participant_tr").hide();	
		        }
		        if(document.getElementById("send_tr")!=null){
		        	jQuery("#send_tr").hide();	
		        }
		        if(document.getElementById("yn_tr")!=null){
		        	jQuery("#yn_tr").hide();	
		        }
		        if(document.getElementById("again_tr")!=null){
		        	jQuery("#again_tr").hide();	
		        }
		        if(document.getElementById("openAccountPart_tr2")!=null){
			        jQuery("#openAccountPart_tr2").hide();
		        }
		        
			} else if (operateType == 3) {//转办
				if(commentsVal==null || commentsVal=="退办" || commentsVal=="同意" || commentsVal=="征求意见" || commentsVal=="废弃"|| commentsVal=="不同意"|| commentsVal==""){
					nui.get("comments").setValue("转办");
				}
				jQuery("#allot").hide();
			    jQuery("#handlerActor_tr").show();
			    jQuery("#backActivity_tr").hide();
			    jQuery("#helpActor_tr").hide();
			    
			    document.getElementById("handlerActorTitle").innerHTML="请选择转办人员";	
			    if(document.getElementById("participant_tr")!=null){
		        	jQuery("#participant_tr").hide();	
		        }	
			    if(document.getElementById("send_tr")!=null){
		        	jQuery("#send_tr").hide();	
		        }
			    if(document.getElementById("yn_tr")!=null){
		        	jQuery("#yn_tr").hide();	
		        }
			    if(document.getElementById("again_tr")!=null){
			    	jQuery("#again_tr").hide();	
			    }
			    if(document.getElementById("openAccountPart_tr2")!=null){
			        jQuery("#openAccountPart_tr2").hide();
		        }
			    
			} else if (operateType == 4) {//征求意见
				if(commentsVal==null || commentsVal=="退办" || commentsVal=="转办" || commentsVal=="同意" || commentsVal=="废弃"|| commentsVal=="不同意"|| commentsVal==""){
					nui.get("comments").setValue("征求意见");
				}
				jQuery("#allot").hide();
			  	jQuery("#backActivity_tr").hide();
			  	jQuery("#handlerActor_tr").hide();
			  	jQuery("#helpActor_tr").show();
			  	
			  	document.getElementById("helpActorTitle").innerHTML="请选择征求意见人员";
			  	if(document.getElementById("participant_tr")!=null){
		        	jQuery("#participant_tr").hide();	
		        }
			  	if(document.getElementById("send_tr")!=null){
			        jQuery("#send_tr").hide();	
			    }
			  	if(document.getElementById("yn_tr")!=null){
		        	jQuery("#yn_tr").hide();	
		        }
			  	if(document.getElementById("again_tr")!=null){
			  		jQuery("#again_tr").hide();	
			  	}
			  	if(document.getElementById("openAccountPart_tr2")!=null){
			        jQuery("#openAccountPart_tr2").hide();
		        }
			  
			}else if (operateType == 5) {//废弃
				if(commentsVal==null || commentsVal=="退办" || commentsVal=="转办" || commentsVal=="征求意见" || commentsVal=="同意"|| commentsVal=="不同意"|| commentsVal==""){
					nui.get("comments").setValue("废弃");
				}
				jQuery("#allot").hide();
				jQuery("#handlerActor_tr").hide();
				jQuery("#backActivity_tr").hide();
				jQuery("#helpActor_tr").hide();
				
				if(document.getElementById("participant_tr")!=null){
		        	jQuery("#participant_tr").hide();	
		        }
				if(document.getElementById("send_tr")!=null){
			        jQuery("#send_tr").hide();	
			    }
				if(document.getElementById("yn_tr")!=null){
		        	jQuery("#yn_tr").hide();	
		        }
				if(document.getElementById("again_tr")!=null){
			  		jQuery("#again_tr").hide();	
			  	}
				if(document.getElementById("openAccountPart_tr2")!=null){
			        jQuery("#openAccountPart_tr2").hide();
		        }
				
			}else if(operateType==6){
				if(commentsVal==null || commentsVal=="同意" || commentsVal=="退办" || commentsVal=="转办" || commentsVal=="征求意见" || commentsVal=="废弃"|| commentsVal==""){
					nui.get("comments").setValue("不同意");
				}
				jQuery("#handlerActor_tr").hide();
			    jQuery("#backActivity_tr").hide();
			    jQuery("#helpActor_tr").hide();
			    
			    if(document.getElementById("participant_tr")!=null){
		        	jQuery("#participant_tr").hide();	
		        }
				if(document.getElementById("send_tr")!=null){
			        jQuery("#send_tr").hide();	
			    }
				if(document.getElementById("yn_tr")!=null){
		        	jQuery("#yn_tr").hide();	
		        }
				if(document.getElementById("again_tr")!=null){
			  		jQuery("#again_tr").hide();	
			  	}
				if(document.getElementById("openAccountPart_tr2")!=null){
			        jQuery("#openAccountPart_tr2").hide();
		        }
				
			}else if(operateType==7){
				if(commentsVal==null || commentsVal=="同意" || commentsVal=="退办" || commentsVal=="转办" || commentsVal=="征求意见" || commentsVal=="废弃"|| commentsVal=="不同意"|| commentsVal==""){
					nui.get("comments").setValue("");
				}
				jQuery("#allot").show();
			    jQuery("#handlerActor_tr").hide();
			    jQuery("#backActivity_tr").hide();
			    jQuery("#helpActor_tr").hide();
			    
			    if(document.getElementById("participant_tr")!=null){
		        	jQuery("#participant_tr").show();	
		        }
			    if(document.getElementById("send_tr")!=null){
		        	jQuery("#send_tr").show();	
		        }
			    if(document.getElementById("yn_tr")!=null){
		        	jQuery("#yn_tr").show();	
		        }
			    if(document.getElementById("again_tr")!=null){
			    	jQuery("#again_tr").show();
			    	if(nui.get("isAgain")&&nui.get("isAgain").getValue()=="Y")jQuery("#yn_tr").hide();	
			    }
			    
			    if(document.getElementById("openAccountPart_tr2")!=null){
			        jQuery("#openAccountPart_tr2").show();
		        }
			}
		}
		
		//控制选择评审/会签人员
		function againSelectUser(e){
			var selectItem = e.value;
			 //根据分支选择框改变处理意见1
			setCommentBySelect("isAgain","againTitle");
			if(selectItem == "N"){
				jQuery("#participant_tr").hide();
				if(document.getElementById("yn_tr")!=null){
					jQuery("#yn_tr").show();
					//根据分支选择框改变处理意见(两个分支)
					setCommentBySelect('yn','ynTitle');
				}
			} else if(selectItem == "Y"){
				jQuery("#participant_tr").show();	
				if(document.getElementById("yn_tr")!=null){
					jQuery("#yn_tr").hide();	
					cleanStr("ynTitle");//清除是否召开总办会值
				}
			}
		}
		
       //根据分支选择框改变处理意见
		function setCommentBySelect(radioId,titleId){
			var title = $("#"+titleId).text().replace("：","");
			var newComment = "";
			var tempComment = "";
			var select = nui.get(radioId).getValue();//选择框的值（Y/N）
			var comments = nui.get("comments");//处理意见框
			var commentStr = comments.getValue();
			if(select=="Y"){
				newComment = title==null||title==""?"":" —— "+title.replace("是否","");
				tempComment = title==null||title==""?"":" —— "+title.replace("是否","不");
			}else if(select=="N"){
				newComment = title==null||title==""?"":" —— "+title.replace("是否","不");
				tempComment = title==null||title==""?"":" —— "+title.replace("是否","");
			}
			if(title!=null||title!=""){
				if(commentStr.indexOf(newComment)>-1) return;
				if(title.indexOf("助理协助")>-1){
					tempComment=tempComment==null||tempComment==""?"":tempComment.replace("不","无需");
					newComment=newComment==null||newComment==""?"":newComment.replace("不","无需");
				}
				if(commentStr.indexOf(tempComment)>-1) {
					var com = commentStr.replace(tempComment,newComment);
					comments.setValue(com);
				}else{
					var com = commentStr+newComment;
					comments.setValue(com);
				}
			}
		}
		//清除控制选择“评审/会签人员”时的“是否召开总办会”的自动设置值
		function cleanStr(titleId){
			var comments = nui.get("comments");//处理意见框
			var commentStr = comments.getValue();
			var title = $("#"+titleId).text().replace("：","");
			var yStr = title==null||title==""?"":" —— "+title.replace("是否","");
			var nStr = title==null||title==""?"":" —— "+title.replace("是否","不");
			if(commentStr.indexOf(yStr)>-1) {commentStr = commentStr.replace(yStr,"");}
			if(commentStr.indexOf(nStr)>-1) {commentStr = commentStr.replace(nStr,"");}
			comments.setValue(commentStr);
		}
		//改变操作时清除自动设置值
		function changeOperateCleanStr(){
			cleanStr("ynTitle");
			cleanStr("againTitle");
		}
		
       //选择单人人员
      function selectSingleEmp(e){ 
               var btnEdit = this;
                nui.open({
                url: contextPath+ "/util/multselet_main.jsp",
                title: "员工列表",
                width: 650,
                height: 480,
                onload: function () {
                    var iframe = this.getIFrameEl();
                    var btnEditValue = btnEdit.getValue();
                    var data = [];
                    if(btnEditValue!=null&&btnEditValue!=""){
                    	var empArr = btnEditValue.split(";");
                    	if(empArr!=null&&empArr.length>0){
                    		for(var i=0;i<empArr.length;i++){
                    			var emp = empArr[i];
                    			if(emp!=null&&emp!=""){
                    				var eArr = emp.split(",");
                    				var json = {"empid":eArr[0],"username":eArr[1]};
                    				data.push(json);
                    			}
                    		}
                    		
                    	}
                    }
                    iframe.contentWindow.setData(data);
                },
                ondestroy: function (action) {
                    if (action == "ok") {
                        var iframe = this.getIFrameEl();
                        var emps = iframe.contentWindow.getData();
                        emps = nui.clone(emps);    //必须
                        if (emps&&emps.data&&emps.data.length>0) {
                            btnEdit.setValue(emps.data[0].empid+','+emps.data[0].username);
                            btnEdit.setText(emps.data[0].username);
                        }else{
                        	btnEdit.setValue("");
                            btnEdit.setText("");
                        }
                    }
                }
            });   			
      }
      
       //选择多人人员
      function selectMutiEmp(e){ 
               var btnEdit = this;
                nui.open({
                url: contextPath +"/util/multSeletSend.jsp",
                title: "员工列表",
                width: 650,
                height: 480,
                onload: function () {
                    var iframe = this.getIFrameEl();
                    var btnEditValue = btnEdit.getValue();
                    var data = [];
                    if(btnEditValue!=null&&btnEditValue!=""){
                    	var empArr = btnEditValue.split(";");
                    	if(empArr!=null&&empArr.length>0){
                    		for(var i=0;i<empArr.length;i++){
                    			var emp = empArr[i];
                    			if(emp!=null&&emp!=""){
                    				var eArr = emp.split(",");
                    				var json = {"empid":eArr[0],"username":eArr[1]};
                    				data.push(json);
                    			}
                    		}
                    		
                    	}
                    }
                    iframe.contentWindow.setData(data);
                },
                ondestroy: function (action) {
                    if (action == "ok") {
                        var iframe = this.getIFrameEl();
                        var emps = iframe.contentWindow.getData();
                        emps = nui.clone(emps); 
                        if (emps) {
                        	var empValue = "";
                        	 var empValueArr =	emps.value.split(",");
                             var empNameArr =	emps.name.split(","); 	
                        	for(var i=0;i<empValueArr.length;i++){
                        		if(empValueArr[i]!=""&&empValueArr[i]!="")
                        			empValue += empValueArr[i] +","+empNameArr[i];
                        		if(i<empValueArr.length-1){
                        			empValue += ";";
                        		}
                        	}
                            btnEdit.setValue(empValue);
                            btnEdit.setText(emps.name);
                        }
                    }
                }
            });   			
      }
      
      //设置默认人员
      function setDefaultEmp(){
    	  if(nui.get("empsName")&&nui.get("empsValue")){
	    	  var empsName = nui.get("empsName").getValue();
			  var empsValue  = nui.get("empsValue").getValue();
	    	  if(empsName){
	    		  var btnEdit = nui.get("selectUser");
	    		  btnEdit.setValue(empsValue);
	    		  btnEdit.setText(empsName);
	    	  }
    	  }
      }
      
      //控制显示回退后的提示
      function displayReAduit(e){
	        if(this.getChecked()){
	        	jQuery("#isReAuditSpan").show();
	        }else{
	        	jQuery("#isReAuditSpan").hide();
	        }
      }
      
      /**
  	 * 弹出提示框，在指定时间后自动消失
  	 * @params message 提示消息
  	 * @params title 提示标题，默认为"提示"
  	 * @params timeout 提示框多长时间后消失，单位毫秒，默认为500毫秒
  	 */
  	function alertTip(message, title, timeout) {
  		title = title || "提示";
  		timeout = timeout || 2000;
  		var messageid = nui.loading(message, title);
  		setTimeout(function() {
  			nui.hideMessageBox(messageid);
  		}, timeout);
  	}
  	
  	function onOperateType(e){
  		return nui.getDictText("ATS_OPERATE_TYPE", e.row.operateType);
  	}  
  	
	function showRowDetail(e){
    	//显示行详细
    	var grid = e.sender;
    	var currentCell = grid.getCurrentCell();
		var field = currentCell[1].field;
		var header = currentCell[1].header;
		if(!grid.isShowRowDetail(e.row)){
			if(field=="comments"&&e.row[field]!=null){
				grid.showRowDetail(e.row);
				var td = grid.getRowDetailCellEl(e.record);
				td.parentNode.style.backgroundColor="#ADDFFE";
				td.className="mini-grid-cell2";
				td.innerHTML="";
				var node=document.createElement("div"); 
				node.innerHTML=header+":　"+e.row[field];
				td.appendChild(node);
			}
		}else{
			grid.hideRowDetail(e.row);
		}
    }

  	
    //返回我的代办页面
	//TODO 去掉刷新
    function processBackSubmit(flag){
    	//fanghb 20161123 点击“返回”按钮后，弹窗为“是”“否”两个按钮
    	 nui.showMessageBox({
    		 showHeader: true,
             width: 250,
             title: "系统提示",
             buttons: ["yes", "no"],
             message: "是否返回至上一页面",
             iconCls: "mini-messagebox-warning",
             callback:  function(action){
                 if(action == "yes"){
                     closeflag=true;
                     if(flag=="designtList"){ //产品设计列表
                    	 window.location.href = contextPath+"/design/commJsp/queryDesigntList.jsp";
                     } else if(flag=="prodResList"){ //产品储备列表
                    	 window.location.href = contextPath+"/draft/pmProdResInfoQuery.jsp";
                     } else {
                    	//关闭tab页面或返回我的任务
                         removeTabOrBackMyTasks("back");
                     }
                 }else{
                 	return;
                 }
             }
         });
    }
    
	//获取子页面的fileid字符串
    function getProcessFileIds(){
    	var iframe = document.getElementById("processIframe").contentWindow;
    	var fileIds = iframe.getFileIds();
    	return fileIds;
    }
    
    //获取判断是否有新上传文件
    function getIsNewUpload(){
    	var iframe = document.getElementById("processIframe").contentWindow;
    	var flag = iframe.isUpload();
    	return flag;
    }
    
    //判断文件是否上传
    function isUploadByFileName(fileName){
    	var iframe = document.getElementById("processIframe").contentWindow;
    	var flag = iframe.isUploadByFileName(fileName);
    	return flag;
    }
    
     //判断文件是否上传
    function isUploadByActivityDefID(activityDefID){
    	var iframe = document.getElementById("processIframe").contentWindow;
    	var flag = iframe.isUploadByActivityDefID(activityDefID);
    	return flag;
    }
    
    //添加附件页面动态加载附件
    function loadProcessFileFrmSrc(bizId,bizCode,processInstID,activityDefID){
		var url = contextPath + "/attach/commonFileUpload/updatePrcAprv.jsp?attachBusType=process"
							  + "&bizId="+bizId+"&bizCode="+bizCode+"&processInstID="+processInstID+"&activityDefID="+activityDefID;
		var iframe = document.getElementById("processIframe");
		iframe.src = url;
    }
    
   	function reloadFrame(TabIframe){
   		TabIframe = window.parent.getBusTabIframe();
   		while(!TabIframe){
    		clearInterval(interval);  		
    	}
   	}
    
    /*
	*调整文件的iframe窗口大小
	*/
	function setProcessFileFrmHeight(fileSize){
		document.getElementById("processIframe").style.height = getFileFrameSize(fileSize) + "px";
	}
	
	//处理意见设值
	function cleanTheSpace(e){
		var newValue = e.value.trim();
		var thisId = e.sender.id;
		nui.get(thisId).setValue(newValue);
	}
	
	//判读是否用印，选是时，显示用印方法
	function checkIsSeal(){
		var operateType = nui.getbyName("bpsParam.operateType").getValue();
		if(document.getElementById("isSeal")!=null){//流程选择不为空且同意时才验证
			var size = nui.getbyName("isSeal").getValue();
			if(size == 'y'&&operateType=="1"){
				$("#openAccountPart_tr3").show();
			}else{
				$("#openAccountPart_tr3").hide();
			}
		}
	}
	//选择抄送方式显隐模块
	function showHideSend(){
		var value = nui.get("cbl1").getValue();
		if(value&&value.indexOf("mail")>-1){//邮件模块
			$("#send_info_tr1").show();
			$("#send_info_tr2").show();
			$("#send_info_tr3").show();
		} else {
			$("#send_info_tr1").hide();
			$("#send_info_tr2").hide();
			$("#send_info_tr3").hide();
			nui.get("mailTitle").setValue("");
			nui.get("mailTo").setValue("");
			nui.get("mailCc").setValue("");
			nui.get("mailContent").setValue("");
		}
	}
	
	//重新设置下一参与者人员
	function reSetActor(){
		if(document.getElementById("nextActorTd")!=null){
			var nextActor = document.getElementById("nextActorTd").innerHTML;
			nextActor = nextActor.replaceAll("@","<br>");
			document.getElementById("nextActorTd").innerHTML = nextActor;
		}
			//上一参与者
		if(document.getElementById("lastActorTd")!=null){
			var nextActor = document.getElementById("lastActorTd").innerHTML;
			if(nextActor.indexOf("@")!=-1){
			    nextActor = nextActor.replaceAll("@","<br>");
			}
			document.getElementById("lastActorTd").innerHTML = nextActor;
		}
	}
	
	
	/*
	*联动常用处理意见
	*/
	function changeCommentBySelect(e) {
		//清除自动设置值
		changeOperateCleanStr();
		nui.get("comments").setValue(nui.get("comm_comments").getValue());
	}
	
	//增加审批语
	function addComment() {
		nui.open({
			url: contextPath+"/bpsExpend/processFunction/comment/ownSugguset.jsp",
			title: "自定义常用处理意见", width: 700, height: 500,
				onload:function(){
			},
			onload: function () {
			},
			ondestroy: function (action) {
				if (action=="ok"){
				    nui.get("comm_comments").load("com.cjhxfund.fpm.bpsExpend.comment.queryCommComments.biz.ext");
				}
			}
		});
			
	}
		
</script>