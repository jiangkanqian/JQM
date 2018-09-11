var doCloseParam = null;
var riskFlagParam = null;
var lResultIdParam = null;
var lRiskmgrIdParam = null;

//交易列表发起风控审批流程按钮可用控制
function riskProcessBtnControl(row){
	if(row.cIsValid=='1' || row.cIsValid=='5'){	//交易状态为有效或者修改审核中
		if(row.vcBizType=='1' || row.vcBizType=='5' || row.vcBizType=='6' || row.vcBizType=='2' || row.vcBizType=='3' || row.vcBizType=='4'){
			if(judgeRiskTest(null, row)){
				nui.ajax({
					url : "com.cjhxfund.ats.riskMgr.riskMgr.getRiskInfo.biz.ext",
					type : 'POST',
					data : {lResultId:row.lResultId},
					cache : false,
					async: true,
					contentType : 'text/json',
					success : function(text) {
						var returnJson = nui.decode(text);
						if(returnJson.exception == null){
							if((returnJson.riskInfo == null || returnJson.riskInfo.lRiskmgrId==null || returnJson.riskInfo.cStatus==0)
									&&(returnJson.riskInfo.cMistakeStatus!=1||returnJson.riskInfo.cMistakeStatus!=2)){
								nui.get("riskProcess").enable();
							}
						}
					}
				 });
			}
		}
	}
}

//一级债发起风控审批流程按钮可用控制
function riskProcessBtnControlByApplyStockInfo(row){
	console.log(row);
	if(row!=null && row.lApplyInstId!=null && row.lApplyInstId!=""){
		if(judgeRiskTest(null, row)){
			nui.ajax({
				url : "com.cjhxfund.ats.riskMgr.riskMgr.getRiskInfo.biz.ext",
				type : 'POST',
				data : {lResultId:row.lApplyInstId},
				cache : false,
				async: true,
				contentType : 'text/json',
				success : function(text) {
					var returnJson = nui.decode(text);
					if(returnJson.exception == null){
						if((returnJson.riskInfo == null || returnJson.riskInfo.lRiskmgrId==null || returnJson.riskInfo.cStatus==0)
								&&(returnJson.riskInfo.cMistakeStatus!=1||returnJson.riskInfo.cMistakeStatus!=2)){
							//nui.get("riskProcess").enable();
						}
					}
				}
			 });
		}
	}
}

//指令提交
function instructSub(json, doClose){
	if(judgeRiskTest(null, json.instructParameter)){	//判断是否接入风控管理
		checkRiskInfo(json);//riskMgrComm.js的方法
	}else{
		instructionAvailIssue(json,doClose);
	}
}


//判断产品是否需要提交时触发风控试算
function judgeRiskTest(workItemID, instructParameter){
	var returnVal= false;
	nui.ajax({
		url : "com.cjhxfund.ats.riskMgr.comm.checkProductHaveRiskAuth.biz.ext",
		type : 'POST',
		data : {workItemID:workItemID, instructParameter:instructParameter},
		cache : false,
		async: false,
		contentType : 'text/json',
		success : function(text) {
			returnVal = text.flag;
		}
 	});
	return returnVal;
	
}


//交易流程提交前判断
function judgeRiskInfo(workItemID, instructParameter){
	var returnJson = {rtnCode:'-1'};
	nui.ajax({
		url : "com.cjhxfund.ats.riskMgr.comm.judgeRiskInfo.biz.ext",
		type : 'POST',
		data : {workItemID:workItemID, instructParameter:instructParameter},
		cache : false,
		async: false,
		contentType : 'text/json',
		success : function(text) {
			returnJson = nui.decode(text);
			if(returnJson.exception != null ){
				returnJson.rtnObject = {rtnCode:'-1', rtnMsg:returnJson.exception};
			}else if(returnJson.rtnObject==null){
				returnJson.rtnObject = {rtnCode:'-1' , rtnMsg:'操作失败！'};
			}
		}
 	});
	return returnJson;
}


//交易列表发起风控审批流程
function startRiskProcess(){
	var rows = selectArr;
	if(rows.length != 1){
		nui.alert("请先选中一条记录","提示");
		return;
	}
	var row = rows[0];
	var lResultId = row.lResultId==null ? "" : row.lResultId;
	var lRiskmgrId = row.lRiskmgrId==null ? "" : row.lRiskmgrId;
	if(row.cIsValid=='1' || row.cIsValid=='5'){	//交易状态为有效或者修改审核中
		nui.ajax({
			url : "com.cjhxfund.ats.riskMgr.riskMgr.getRiskInfo.biz.ext",
			type : 'POST',
			data : {lResultId:lResultId},
			cache : false,
			async: false,
			contentType : 'text/json',
			success : function(text) {
				var returnJson = nui.decode(text);
				if(returnJson.exception == null){
					if(returnJson.riskInfo == null || (returnJson.riskInfo.cStatus!=1 && returnJson.riskInfo.cStatus!=2)){
						var url = nui.context+ "/riskMgr/riskProcess/addRiskPage.jsp?cBizType=2&lRiskmgrId="+lRiskmgrId+"&lResultId="+lResultId;
						window.open(url, "riskmgr"+lResultId);
					}else{
						nui.alert("已经发起过风控审批！");
					}
				}
			}
		 });
	}else{
		nui.alert("交易状态已变更！请刷新列表");
	}
}

//一级债列表发起风控审批流程
function startRiskProcessByApplyStockInfo(){
	
	var rows = grid.getSelecteds();
	if(rows.length != 1){
		nui.alert("请先选中一条记录","提示");
		return;
	}
	var row = rows[0];
	var lResultId = row.lApplyInstId==null ? "" : row.lApplyInstId;
	
	
	var  workItemID=row.workItemID;
	var  processInstID=row.lProcessInstId;
	var  biztypename="";
	
	var  vcProcessType=row.vcProcessType;
	if(vcProcessType=="1" ||vcProcessType=="5"){
		biztypename= "申购流程";
 	}else if(vcProcessType=="8"){
 		biztypename= "缴款流程";
 	}
	
	
	nui.ajax({
		url : "com.cjhxfund.ats.riskMgr.riskMgr.getRiskInfo.biz.ext",
		type : 'POST',
		data : {lResultId:lResultId},
		cache : false,
		async: false,
		contentType : 'text/json',
		success : function(text) {
			var returnJson = nui.decode(text);
			if(returnJson.exception == null){
				if(returnJson.riskInfo == null || (returnJson.riskInfo.cStatus!=1 && returnJson.riskInfo.cStatus!=2)){
					var lRiskmgrId = returnJson.riskInfo == null || returnJson.riskInfo.lRiskmgrId == null ? "" : returnJson.riskInfo.lRiskmgrId;
					//var url = nui.context+ "/riskMgr/riskProcess/addRiskPage.jsp?cBizType=1&lRiskmgrId="+lRiskmgrId+"&lResultId="+lResultId+"&biztypename="+biztypename;
					var url = nui.context+ "/riskMgr/riskProcess/addRiskPage.jsp?cBizType=1&lRiskmgrId="+lRiskmgrId+"&lResultId="+lResultId+"&biztypename="+biztypename+"&workItemID="+workItemID+"&processInstID="+processInstID;
					window.open(url, "riskmgr"+lResultId);
				}else{
					nui.alert("已经发起过风控审批！");
				}
			}
		}
	 });
}






//发起风控审批流程
function startRiskProcessInstruct(lResultId, lRiskmgrId, cBizType,cApplyInstType){
	
	debugger;
	if(lResultId==null || lResultId==""){
		nui.alert("风控流程发起失败！");
		return;
	}
	
	var  biztypename="";
	if(cApplyInstType=="F1"){
		biztypename= "申购流程";
 	}else if(cApplyInstType=="F2"){
 		biztypename= "缴款流程";
 	}
	
	
	lRiskmgrId = lRiskmgrId==null ? "" : lRiskmgrId;
	cBizType = cBizType==null ? "2" : cBizType;
	var url = nui.context+ "/riskMgr/riskProcess/addRiskPage.jsp?cBizType="+cBizType+"&lResultId="+lResultId+"&lRiskmgrId="+lRiskmgrId+"&biztypename="+biztypename;
	window.open(url, "riskmgr"+lResultId);	
}



//调用风控
function checkRiskInfo(instructJson){
	var risktip = nui.loading("风控测算中,请稍等...","提示");
	instructJson.instructParameter.callRiskType = "3";//风控校验类型：1-风控试算，2-投资/建议下达，3-对接风控管理
	nui.ajax({
	 	url: "com.cjhxfund.ats.riskMgr.comm.checkInstructRiskInfo.biz.ext",
        type: 'POST',
        data: instructJson,
        cache: false,
        async: true,
        contentType: 'text/json',
        success: function (text) {
			nui.hideMessageBox(risktip);
        	returnJson = nui.decode(text);
        	subData(returnJson, instructJson);
		}
	});
}

//审批页面调用风控
function checkRiskInfoApprove(workItemID, checkRiskInfo){
	var risktip = nui.loading("风控测算中,请稍等...","提示");
	var json = {workItemID:workItemID, checkRiskInfo:checkRiskInfo};
	nui.ajax({
	 	url: "com.cjhxfund.ats.riskMgr.comm.approveCheckInstructRiskInfo.biz.ext",
        type: 'POST',
        data: json,
        cache: false,
        async: true,
        contentType: 'text/json',
        success: function (text) {
			nui.hideMessageBox(risktip);
        	returnJson = nui.decode(text);
        	subData(returnJson, returnJson);
		}
	});
}

//询价审批页面调用风控
function checkRiskInfoInquiryApprove(instructJson, checkRiskInfo){
	if(instructJson.instructParameter){
		instructJson.instructParameter.checkRiskInfo = checkRiskInfo;
	}
	var risktip = nui.loading("风控测算中,请稍等...","提示");
	nui.ajax({
	 	url: "com.cjhxfund.ats.riskMgr.comm.approveCheckInquiryRiskInfo.biz.ext",
        type: 'POST',
        data: instructJson,
        cache: false,
        async: true,
        contentType: 'text/json',
        success: function (text) {
			nui.hideMessageBox(risktip);
        	returnJson = nui.decode(text);
        	subData(returnJson, returnJson);
		}
	});
}

//一级债审批页面调用风控
function checkRiskInfoApplyStock(json){
	var returnJson = {};
	nui.ajax({
	    url: "com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.windControlTrial.biz.ext",
	    type: "post",
	    data: json,
	    async: true,
	    dataType:"json",
	    success: function (text) {
	    	returnJson = nui.decode(text);
	    	subData(returnJson);
	    }
	});
	return returnJson;
}


//触发风控处理
function showRiskInfo(returnJson, instructJson, inquiryType){
	if(returnJson.exception == null){
		var instructParameterData = instructJson.instructParameter;
		var riskMsg = returnJson.riskMsg;
		if(riskMsg!=null){
			instructParameterData.availResult = riskMsg.availResult;
			instructParameterData.availResultMsg = riskMsg.availResultMsg;
		}
		if (returnJson.rtnCode == nui.ATS_SUCCESS){
        	//风控通过
			return '1';
		}else if(returnJson.rtnCode == nui.ATS_ERROR){
        	//出错
        	if(riskMsg!=null && riskMsg.isAgainstRisk){//触发了风控
        		riskMsg["alertMsg"]="投资指令/建议下达失败！";
        			nui.open({
        				url: nui.context+"/riskMgr/riskInfo/riskCheckDetailList.jsp",
        				title: "投资指令/建议风控信息",
        				width: 800,
        				height: 410,
        				onload: function () {
        					var iframe = this.getIFrameEl();
        					iframe.contentWindow.SetData('1', riskMsg, instructParameterData);
        				}
        			});
        	}else{
        		window.parent.nui.alert(returnJson.rtnMsg,"系统提示");
        	}
    		return '-1';
		}else if(returnJson.rtnCode == nui.ATS_ORDER_USABLE_AMOUNT_INSUFFICIENT){
			//可用不足
			window.parent.nui.confirm(returnJson.rtnMsg+"</br>是否继续下单？","提示", function(action){
	            if(action == "ok"){
	            	var ret = saveAvailInfoByInstruct(instructParameterData);	//保存禁止交易
	    			if(ret.lResultId!=null && ret.lResultId!=''){
	    				instructJson.instructParameter.lResultId = ret.lResultId;
	    			}
	            	riskControl('1', instructJson);
	            }
			});
        }else if(returnJson.rtnCode == "203" || returnJson.rtnCode == "302"){
        	//风控校验失败 || 可用不足且风控校验失败
        	window.parent.nui.alert(returnJson.rtnMsg,"系统提示");
        	return '-1';
        }else if(returnJson.rtnCode == "301"){  
        	//触发可用且触发风控
        	returnJson.riskMsg["alertMsg"]=returnJson.rtnMsg;
            nui.open({
                url: nui.context+"/riskMgr/riskInfo/riskCheckDetailList.jsp",
                title: "投资指令/建议风险提示",
                width: 800,
                height: 430,
                onload: function () {
                    var iframe = this.getIFrameEl();
                    iframe.contentWindow.SetData('3', returnJson.riskMsg, instructParameterData, null, inquiryType);
                },
                ondestroy: function (retAction) {
                	var action = retAction.action;
                	instructJson.instructParameter.lResultId = retAction.lResultId;
                	instructJson.instructParameter.lRiskmgrId = retAction.lRiskmgrId;
                	if(action=='-1'){
                		//留在当前节点，不做操作
                	}else if(action=='0' || action=='1'){
                		//确定、继续 或者 进入复核节点
                		riskControl('1', instructJson);
                	}else if(action=='2'){
                		riskControl('2', instructJson);
                	}
                }
            });
        }else{  
        	//触发风控
            nui.open({
            	url: nui.context+"/riskMgr/riskInfo/riskCheckDetailList.jsp",
                title: "投资指令/建议风险提示",
                width: 800,
                height: 380,
                onload: function () {
                    var iframe = this.getIFrameEl();
                    iframe.contentWindow.SetData('3', returnJson.riskMsg, instructParameterData, null, inquiryType);
                },
                ondestroy: function (retAction) {
                	var action = retAction.action;
                	instructJson.instructParameter.lResultId = retAction.lResultId;
                	instructJson.instructParameter.lRiskmgrId = retAction.lRiskmgrId;
                	if(action=='-1'){
                		//留在当前节点，不做操作
                	}else if(action=='0' || action=='1'){
                		//确定、继续 或者 进入复核节点
                		riskControl('1', instructJson);
                	}else if(action=='2'){
                		riskControl('2', instructJson);
                	}
                }
            });
        }
	}else{
		nui.alert("系统异常","系统提示");
		return '-1';
	}
	return '-1';
}

//审批页面触发风控处理
function showRiskInfoApprove(returnJson, instructJson){
	if(returnJson.exception == null){
		var instructParameterData = instructJson.instructParameter;
		var riskMsg = returnJson.riskMsg;
		if (returnJson.rtnCode == nui.ATS_SUCCESS){
        	//风控通过
			return '1';
		}else if(returnJson.rtnCode == nui.ATS_ERROR){
        	//出错
        	if(riskMsg!=null && riskMsg.isAgainstRisk){//触发了风控
        		riskMsg["alertMsg"]="投资指令/建议下达失败！";
    			nui.open({
    				url: nui.context+"/riskMgr/riskInfo/riskCheckDetailList.jsp",
    				title: "投资指令/建议风控信息",
    				width: 800,
    				height: 410,
    				onload: function () {
    					var iframe = this.getIFrameEl();
    					iframe.contentWindow.SetData('1', riskMsg, instructParameterData, workItemID);
    				}
    			});
        	}else{
        		window.parent.nui.alert(returnJson.rtnMsg,"系统提示");
        	}
    		return '-1';
		}else if(returnJson.rtnCode == nui.ATS_ORDER_USABLE_AMOUNT_INSUFFICIENT){
			//可用不足
			window.parent.nui.alert("审批失败</br>"+returnJson.rtnMsg,"系统提示",function(action){
    			if(action == "ok"){
    				saveAvailInfoByInstruct(instructParameterData);	//保存禁止交易
    				return '-1';
    			}
			});
        }else if(returnJson.rtnCode == "203" || returnJson.rtnCode == "302"){
        	//风控校验失败 || 可用不足且风控校验失败
        	window.parent.nui.alert(returnJson.rtnMsg,"系统提示");
        	return '-1';
        }else if(returnJson.rtnCode == "301"){  
        	//触发可用且触发风控
        	returnJson.riskMsg["alertMsg"]="审批失败</br>"+returnJson.rtnMsg;
            nui.open({
                url: nui.context+"/riskMgr/riskInfo/riskCheckDetailList.jsp",
                title: "投资指令/建议风险提示",
                width: 800,
                height: 460,
                onload: function () {
                    var iframe = this.getIFrameEl();
                    iframe.contentWindow.SetData('1', returnJson.riskMsg, instructParameterData, workItemID);
                }
            });
            return '-1';
        }else{	//触发风控
			nui.open({
            	url: nui.context+"/riskMgr/riskInfo/riskCheckDetailList.jsp",
                title: "投资指令/建议风险提示",
                width: 800,
                height: 380,
                onload: function () {
                    var iframe = this.getIFrameEl();
                    iframe.contentWindow.SetData('3', returnJson.riskMsg, instructParameterData, null, workItemID);
                },
                ondestroy: function (retAction) {
                	var action = retAction.action;
                	instructJson.instructParameter.lResultId = retAction.lResultId;
                	instructJson.instructParameter.lRiskmgrId = retAction.lRiskmgrId;
                	if(action=='-1'){
                		//留在当前节点，不做操作
                	}else if(action=='0' || action=='1'){
                		//确定、继续 或者 进入复核节点
                		riskControl('1', instructJson);
                	}else if(action=='2'){
                		riskControl('2', instructJson);
                	}
                }
            });
		}
	}else{
		nui.alert("系统异常","系统提示");
		return '-1';
	}
	return '-1';
}

//询价管理-确认页面触发风控处理
function showRiskInfoInquiryApprove(returnJson, instructJson){
	if(returnJson.exception == null){
		var instructParameterData = instructJson.instructParameter;
		var riskMsg = returnJson.riskMsg;
		if (returnJson.rtnCode == nui.ATS_SUCCESS){
        	//风控通过
			return '1';
		}else if(returnJson.rtnCode == nui.ATS_ERROR){
        	//出错
        	if(riskMsg!=null && riskMsg.isAgainstRisk){//触发了风控
        		riskMsg["alertMsg"]="投资指令/建议下达失败！";
    			nui.open({
    				url: nui.context+"/riskMgr/riskInfo/riskCheckDetailList.jsp",
    				title: "投资指令/建议风控信息",
    				width: 800,
    				height: 410,
    				onload: function () {
    					var iframe = this.getIFrameEl();
    					iframe.contentWindow.SetData('1', riskMsg, instructParameterData);
    				}
    			});
        	}else{
        		window.parent.nui.alert(returnJson.rtnMsg,"系统提示");
        	}
    		return '-1';
		}else if(returnJson.rtnCode == nui.ATS_ORDER_USABLE_AMOUNT_INSUFFICIENT){
			//可用不足
			window.parent.nui.alert("审批失败</br>"+returnJson.rtnMsg,"系统提示",function(action){
    			if(action == "ok"){
    				saveAvailInfoByInstruct(instructParameterData);	//保存禁止交易
    				return '-1';
    			}
			});
        }else if(returnJson.rtnCode == "203" || returnJson.rtnCode == "302"){
        	//风控校验失败 || 可用不足且风控校验失败
        	window.parent.nui.alert(returnJson.rtnMsg,"系统提示");
        	return '-1';
        }else if(returnJson.rtnCode == "301"){  
        	//触发可用且触发风控
        	returnJson.riskMsg["alertMsg"]="审批失败</br>"+returnJson.rtnMsg;
            nui.open({
                url: nui.context+"/riskMgr/riskInfo/riskCheckDetailList.jsp",
                title: "投资指令/建议风险提示",
                width: 800,
                height: 460,
                onload: function () {
                    var iframe = this.getIFrameEl();
                    iframe.contentWindow.SetData('1', returnJson.riskMsg, instructParameterData);
                }
            });
            return '-1';
        }else{	//触发风控
			nui.open({
            	url: nui.context+"/riskMgr/riskInfo/riskCheckDetailList.jsp",
                title: "投资指令/建议风险提示",
                width: 800,
                height: 380,
                onload: function () {
                    var iframe = this.getIFrameEl();
                    iframe.contentWindow.SetData('3', returnJson.riskMsg, instructParameterData, null, null);
                },
                ondestroy: function (retAction) {
                	var action = retAction.action;
                	instructJson.instructParameter.lResultId = retAction.lResultId;
                	instructJson.instructParameter.lRiskmgrId = retAction.lRiskmgrId;
                	if(action=='-1'){
                		//留在当前节点，不做操作
                	}else if(action=='0' || action=='1'){
                		//确定、继续 或者 进入复核节点
                		riskControl('1', instructJson);
                	}else if(action=='2'){
                		riskControl('2', instructJson);
                	}
                }
            });
		}
	}else{
		nui.alert("系统异常","系统提示");
		return '-1';
	}
	return '-1';
}

//一级债-页面触发风控处理
function showRiskInfoApplyStock(returnJson, applyInfo){
	if (returnJson.returnCode == '-1'){	//风控测算失败
		nui.alert(returnJson.rtnMsg,"系统提示");
		return '-1';
	}else if(returnJson.returnCode != 0){
		//触发风控
        nui.open({
        	url: nui.context+"/riskMgr/riskInfo/riskCheckDetailList.jsp",
            title: "投资指令/建议风险提示",
            width: 800,
            height: 380,
            onload: function () {
                var iframe = this.getIFrameEl();
                iframe.contentWindow.SetDataForApplyStock('3', returnJson.riskMsg, applyInfo);
            },
            ondestroy: function (retAction) {
            	var action = retAction.action;
            	if(action=='0' || action=='1'){
            		//确定、继续 或者 进入复核节点
            		riskControl('1', retAction.lResultId, retAction.lRiskmgrId);
            	}else if(action=='2'){
            		//发起风控审批
            		riskControl('2', retAction.lResultId, retAction.lRiskmgrId);
            	}
            }
        });
	}
}

//二级债指令审批提交
function finishInstructWorkitem(workItemID, checkResult, checkComments){
	var json = {workItemID:workItemID, checkResult:checkResult, checkComments:checkComments};
	var tip = nui.loading("正在处理中,请稍等...","提示");
	nui.ajax({
	 	url: "com.cjhxfund.ats.sm.comm.TaskManager.finishWorkBiz.biz.ext",
        type: 'POST',
        data: json,
        cache: false,
        async: true,
        contentType: 'text/json',
        success: function (text) {
			nui.hideMessageBox(tip);
        	returnJson = nui.decode(text);
        	if(returnJson.exception == null){
        		if(returnJson.rtnCode == nui.ATS_SUCCESS){
        			nui.alert("审批成功","系统提示",function(action){
		    			if(action == "ok"){
	        				finishInstructWorkitemFisish();
		    			}
	    			}); 
        		}else if(returnJson.rtnCode == nui.ATS_ERROR){
        			nui.alert("审批失败</br>"+returnJson.rtnMsg,"系统提示",function(action){
						if(action == "ok"){
		    				window.CloseWindow("ok");
		    			}
					});
        		}else if(returnJson.rtnCode == nui.ATS_ORDER_NO_RCV_FR_O32){
        			nui.alert("审批成功"+"</br>"+returnJson.rtnMsg,"系统提示",function(action){
        				if(action == "ok"){
	        				finishInstructWorkitemFisish();
		    			}
	    			}); 
        		}else{
        			nui.alert("系统异常","系统提示");
        		}
        	}else{
        		nui.alert("系统异常","系统提示");
        	}
		}
	});
}

//保存风控信息
function saveRiskInfoByInstruct(instructParameter, riskMsg, cStatus){
	var rtn = {lResultId:'', lRiskmgrId:''};
	nui.ajax({
		url : "com.cjhxfund.ats.riskMgr.riskMgr.saveRiskInfoByInstruct.biz.ext",
		type : 'POST',
		data : {instructParameter:instructParameter, riskMsg:riskMsg, cStatus:cStatus},
		cache : false,
		async: false,
		contentType : 'text/json',
		success : function(text) {
			var returnJson = nui.decode(text);
			if(returnJson.exception==null && returnJson.rtnObject!=null){
				if(returnJson.rtnObject.rtnCode!='-1'){
					rtn.lResultId = returnJson.riskMgrInfo.lResultId;
					rtn.lRiskmgrId = returnJson.riskMgrInfo.lRiskmgrId;
				}
			}
		}
 	});
 	return rtn;
}

//保存可用信息
function saveAvailInfoByInstruct(instructParameterData){
	var rtn = {lResultId:'', lRiskmgrId:''};
	nui.ajax({
		url : "com.cjhxfund.ats.riskMgr.riskMgr.saveAvailInfoByInstruct.biz.ext",
		type : 'POST',
		data : {instructParameter:instructParameterData},
		cache : false,
		async: false,
		contentType : 'text/json',
		success : function(text) {
			var returnJson = nui.decode(text);
			if(returnJson.exception==null && returnJson.rtnObject!=null){
				if(returnJson.rtnObject.rtnCode!='-1'){
					rtn.lResultId = returnJson.availInfo.lResultId;
				}
			}
		}
 	});
 	return rtn;
}

//更新风控状态
function updateRiskStatus(lRiskmgrId, lProcessinstId, lResultId, cStatus){
	nui.ajax({
		url : "com.cjhxfund.ats.riskMgr.riskMgr.updateRiskStatus.biz.ext",
		type : 'POST',
		data : {lRiskmgrId:lRiskmgrId, lProcessinstId:lProcessinstId, lResultId:lResultId, cStatus:cStatus},
		cache : false,
		async: true,
		contentType : 'text/json',
		success : function(text) {
		}
 	});
}

//更新可用状态
function updateAvailResult(lResultId){
	nui.ajax({
		url : "com.cjhxfund.ats.riskMgr.riskMgr.updateAvailResult.biz.ext",
		type : 'POST',
		data : {lResultId:lResultId},
		cache : false,
		async: true,
		contentType : 'text/json',
		success : function(text) {
		}
 	});
}


//根据产品代码获得产品信息
function getProductInfo(vcProductCode){
	nui.ajax({
	 	url: "com.cjhxfund.ats.fm.baseinfo.ProductManager.getProductInfoByCode.biz.ext",
        type: 'POST',
        data: {vcProductCode:vcProductCode},
        cache: false,
        async: false,
        contentType: 'text/json',
        success: function (text) {
        	returnJson = nui.decode(text);
		}
	});
	return returnJson.productInfo;
}


//
function getRiskInfo(lResultId){
	var riskInfo = null;
	nui.ajax({
		url : "com.cjhxfund.ats.riskMgr.riskMgr.getRiskInfo.biz.ext",
		type : 'POST',
		data : {lResultId:lResultId},
		cache : false,
		async: false,
		contentType : 'text/json',
		success : function(text) {
			var returnJson = nui.decode(text);
			if(returnJson.exception == null){
				riskInfo = returnJson.riskInfo;
			}
		}
	 });
	return riskInfo;
}





//【投资管理】【一级新债】【转债申购】债券申购列表,发起风控审批流程


function startRiskProcessByApplyStockInfoTab(){
	debugger;
	var rows = grid.getSelecteds();
	if(rows.length != 1){
		nui.alert("请先选中一条记录","提示");
		return;
	}
	var row = rows[0];
	var lResultId = row.lApplyInstId==null ? "" : row.lApplyInstId;
	
	
	var  workItemID=row.workItemID;
	var  processInstID=row.processinstid;
	var  bizId=row.bizId;
	var  biztypename="转债申购";
	
	
	nui.ajax({
		url : "com.cjhxfund.ats.riskMgr.riskMgr.getRiskInfo.biz.ext",
		type : 'POST',
		data : {lResultId:lResultId},
		cache : false,
		async: false,
		contentType : 'text/json',
		success : function(text) {
			var returnJson = nui.decode(text);
			if(returnJson.exception == null){
				if(returnJson.riskInfo == null || (returnJson.riskInfo.cStatus!=1 && returnJson.riskInfo.cStatus!=2)){
					var lRiskmgrId = returnJson.riskInfo == null || returnJson.riskInfo.lRiskmgrId == null ? "" : returnJson.riskInfo.lRiskmgrId;
				
					var url = nui.context+ "/riskMgr/riskProcess/addRiskPage.jsp?cBizType=1&lRiskmgrId="+lRiskmgrId+"&lResultId="+lResultId+"&biztypename="+biztypename+"&workItemID="+workItemID+"&processInstID="+processInstID;
					window.open(url, "riskmgr"+lResultId);
				}else{
					nui.alert("已经发起过风控审批！");
				}
			}
		}
	 });
}



