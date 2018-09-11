/**
 * 20170811
 * 正逆回购指令详细页面通用js
 * @author tongwei
 */

function riskControlTrial(){
	var a = nui.loading("正在处理中,请稍等...","提示");
	nui.ajax({
		url: "com.cjhxfund.ats.sm.comm.InstructionManager.approveRiskTrial.biz.ext",
		type: 'POST',
		data: {lProcessInstID:row.lProcessinstId, bonds: mortgage_info.getData()},
		cache: false,
		contentType: 'text/json',
		success: function (text) {
			nui.hideMessageBox(a);
			var returnJson = nui.decode(text);
			if(returnJson.exception == null){
		       var riskInfo = returnJson.riskMsg;
		       if (returnJson.rtnCode == ATS_SUCCESS){
					if(returnJson.rtnMsg!=null){
						nui.alert(returnJson.rtnMsg,"系统提示");
					}else{
						nui.alert("风控试算通过!","系统提示");
					}
		       }else if(returnJson.rtnCode == ATS_ORDER_USABLE_AMOUNT_INSUFFICIENT){
		    	   nui.alert(returnJson.rtnMsg,"投资指令/建议风险提示");//可用不足
		       }else if(returnJson.rtnCode == "203"){
		    	   nui.alert(returnJson.rtnMsg,"系统提示");//风控校验失败
		       }else if(returnJson.rtnCode == "301"){
		    	   //风险提示框start
		    	   riskInfo["alertMsg"]=returnJson.rtnMsg;
		    	   nui.open({
		    		   url:  nui.context +"/fix/riskControlDetailList.jsp",
		    		   title: "投资指令/建议风险提示",
		    		   width: 800,
		    		   height: 422,
		    		   onload: function () {
		    			   var iframe = this.getIFrameEl();
		    			   iframe.contentWindow.SetData(riskInfo,3);
		    		   }
		    	   });
		       }else{
		    	   //风险提示框start
		    	   nui.open({
		    		   url:  nui.context +"/fix/riskControlDetailList.jsp",
		    		   title: "投资指令/建议风险提示",
		    		   width: 800,
		    		   height: 380,
		    		   onload: function () {
		    			   var iframe = this.getIFrameEl();
		    			   iframe.contentWindow.SetData(riskInfo,3);
		    		   }
		    	   });
		    	   //风险提示框end
		       }
			}else{
				nui.alert("系统异常","系统提示");
			}
        }
	});
}


var backReturnJson = null;
function getData(){
	return backReturnJson;
}

//	老机器猫交易员确认
function confirm_common_jyy_ZNHG(){
        	
	var jsonStatus = nui.encode({zhfwptjyznhg:{processId:row.lResultId}});
	$.ajax({
        url:"com.cjhxfund.jy.ProductProcess.JY_ZNHG.getProcessStatus_ZNHG.biz.ext",
        type:'POST',
        data:jsonStatus,
        cache:false,
        contentType:'text/json',
        success:function(text){
            var returnJsonStatus = nui.decode(text);
            
            //“投资经理下单确认”、“交易员填单确认”、“交易已发送”阶段投顾可以修改，修改之后投资经理下单、交易员填单、交易已发送需要重新确认；
        	//“前台已成交”阶段投顾可以将指令/建议单废弃，系统在备注记录废弃原因、时间等信息，“后台已成交”阶段单子不能做任何修改废弃；
        	//指令/建议流程处理状态：-2-指令/建议询价录入完成；-1-交易员填单指令/建议补齐完成；0-投资顾问录入完成；1-指令/建议录入确认完成；2-投资经理下单确认完成；3-交易员填单确认完成；4-交易已发送确认完成；5-前台已成交确认完成；6-后台已成交确认完成；
        	var processStatus = returnJsonStatus.processStatus;
        	
        	
        	if(processStatus=="-2" || processStatus=="-1" || processStatus=="0" || processStatus=="1"){
        		nui.alert("该指令/建议尚未确认，您还不能处理","提示");
				return;
			//交易确认阶段权限认证，若当前用户有权限处理该指令/建议单，则继续执行，否则终止并提示
        	}else if(processStatus=="2" || processStatus=="3" || processStatus=="4"){
        		var hasPermission = false;//是否有权限，默认无
				if(row.tradingConfirmAuthorityUserIds!=null && row.tradingConfirmAuthorityUserIds!=""){
					var tradingConfirmAuthorityUserIdsArr = row.tradingConfirmAuthorityUserIds.split(",");
					for(var i=0; i<tradingConfirmAuthorityUserIdsArr.length; i++){
						var userIdTemp = tradingConfirmAuthorityUserIdsArr[i];
						if(userIdTemp==userId){
							hasPermission = true;
							break;
						}
					}
				}
				if(hasPermission==false){
					nui.alert("您没有权限确认该指令/建议","提示");
					return;
				}
        	
        	//后台已成交确认阶段权限认证，若当前用户有权限处理该指令/建议单，则继续执行，否则终止并提示
        	}else if(processStatus=="5"){
        		var hasPermission = false;//是否有权限，默认无
				if(row.backstageConfirmAuthorityUserIds!=null && row.backstageConfirmAuthorityUserIds!=""){
					var backstageConfirmAuthorityUserIdsArr = row.backstageConfirmAuthorityUserIds.split(",");
					for(var i=0; i<backstageConfirmAuthorityUserIdsArr.length; i++){
						var userIdTemp = backstageConfirmAuthorityUserIdsArr[i];
						if(userIdTemp==userId){
							hasPermission = true;
							break;
						}
					}
				}
				if(hasPermission==false){
					nui.alert("您没有权限确认该指令/建议","提示");
					return;
				}
        	}
        	
        	
        	var msg = "";
        	if(processStatus=="-2" || processStatus=="-1" || processStatus=="0" || processStatus=="1"){
        		nui.alert("该指令/建议尚未确认，您还不能处理","提示");
				return;
        	}else if(processStatus=="2"){
        		msg = "该指令/建议现为投资经理下单完成阶段，确定要继续确认吗？";
        	}else if(processStatus=="3"){
        		msg = "该指令/建议现为交易员填单完成阶段，确定要继续确认吗？";
        	}else if(processStatus=="4"){
        		msg = "该指令/建议现为交易已发送阶段，确定要继续确认吗？";
        	}else if(processStatus=="5"){
        		msg = "该指令/建议现为前台已成交阶段，确定要继续确认吗？";
        	}else if(processStatus=="6"){
        		nui.alert("该指令/建议后台已成交，不能再做任何操作","提示");
        		return;
        	}
	    
	        nui.confirm(msg,"系统提示",
	        function(action){
	            if(action=="ok"){
	            	
	            	//提交之前再次实时查询指令/建议单有效状态，避免用户在操作界面停留时间太长导致界面数据状态与数据库不一致
	            	var jsonValidStatus = nui.encode({zhfwptjyznhg:{processId:row.lResultId}});
				  	$.ajax({
				          url:"com.cjhxfund.jy.ProductProcess.JY_ZNHG.getValidStatus_ZNHG.biz.ext",
				          type:'POST',
				          data:jsonValidStatus,
				          cache:false,
				          contentType:'text/json',
				          success:function(text){
				              var returnJsonValidStatus = nui.decode(text);
				              //交易状态：0-有效；1-无效-修改；2-无效-废弃；3-有效-退回；4-无效-退回；
				              var returnValidStatus = returnJsonValidStatus.validStatus;
				              
				              //若指令/建议单有效，则继续执行
				              if(returnValidStatus=="0"){
				              
				              	  	//封装主键ID、指令/建议流程处理状态字段传输到后台处理
				                    var json = nui.encode({zhfwptjyznhgs:[{processId:row.lResultId, processStatus:processStatus}]});
									var a = nui.loading("正在处理中,请稍等...","提示");
					                $.ajax({
					                    url:"com.cjhxfund.jy.ProductProcess.JY_ZNHG.JY_ZNHG_confirm.biz.ext",
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
					                            nui.alert(msg, "系统提示", function(action){
					                            	if(action=="ok"){
					                            		window.CloseWindow("ok");
					                            	}
					                            });
					                        }else{
				                                nui.alert("确认失败", "系统提示");
												return;
					                        }
					                    }
					                });
				              }else if(returnValidStatus=="3"){
								  nui.alert("该指令/建议已退回，您不能再确认", "提示");
								  return;
				              }else{
								  nui.alert("该指令/建议已无效，不能再做任何操作", "提示");
								  return;
				              }
				          }
				      });
	             }
	        });
        }
    });	
}

// 老机器猫投顾确认
function confirm_comm_tg_ZNHG(){
	var jsonStatus = nui.encode({zhfwptjyznhg:{processId:row.lResultId}});
	$.ajax({
        url:"com.cjhxfund.jy.ProductProcess.JY_ZNHG.getProcessStatus_ZNHG.biz.ext",
        type:'POST',
        data:jsonStatus,
        cache:false,
        contentType:'text/json',
        success:function(text){
            var returnJsonStatus = nui.decode(text);
        	var record = row;//产品记录
            //“投资经理下单确认”、“交易员填单确认”、“交易已发送”阶段投顾可以修改，修改之后投资经理下单、交易员填单、交易已发送需要重新确认；
        	//“前台已成交”阶段投顾可以将指令/建议单废弃，系统在备注记录废弃原因、时间等信息，“后台已成交”阶段单子不能做任何修改废弃；
        	//指令/建议流程处理状态：-2-指令/建议询价录入完成；-1-交易员填单指令/建议补齐完成；0-投资顾问录入完成；1-指令/建议录入确认完成；2-投资经理下单确认完成；3-交易员填单确认完成；4-交易已发送确认完成；5-前台已成交确认完成；6-后台已成交确认完成；
        	var processStatus = returnJsonStatus.processStatus;
        	var userIdRelaType07All = record.userIdRelaType07All!=null?record.userIdRelaType07All:"";//07-产品与投顾确认权限(全部人员)
			var userIdRelaType07 = record.userIdRelaType07!=null?record.userIdRelaType07:"";//07-产品与投顾确认权限(过滤自己)
			var userIdRelaTypeA1 = record.userIdRelaTypeA1!=null?record.userIdRelaTypeA1:"";//A1-投顾录入确认可为同一人员
    		// 指令还未下达
    		if(processStatus=="-2"){
    			nui.alert("该指令/建议尚未下达，您还不能处理","提示");
    			return;
    			
    		//投顾确认	
    		}else if(processStatus=="-1" || processStatus=="0"){
				//无权限确认的记录
	        	var hasPermission = false;
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
				}
				if(hasPermission == false){
					nui.alert("您没有权限确认该指令/建议","提示");
					return;
				}
        	
        	//投资经理下单操作权限认证
			}else if(processStatus=="1"){
        		//若当前用户有权限处理该指令/建议单，则继续执行，否则终止并提示
        		var hasPermission = false;//是否有权限，默认无
				var userIdRelaType02 = row.userIdRelaType02;//该指令/建议单拥有投资经理下单权限的用户ID字符串
				if(userIdRelaType02!=null && userIdRelaType02!=""){
					var userIdRelaType02Arr = userIdRelaType02.split(",");
					for(var i=0; i<userIdRelaType02Arr.length; i++){
						var userIdTemp = userIdRelaType02Arr[i];
						if(userIdTemp==userId){
							hasPermission = true;
							break;
						}
					}
				}
				if(hasPermission==false){
					nui.alert("您没有权限确认该指令/建议","提示");
					return;
				}
        	}else{
        		nui.alert("您没有权限确认该指令/建议","提示");
				return;
        	}
        	
        	
        	var msg = "";
        	if(processStatus=="-2" || processStatus=="-1" || processStatus=="0"){
        		msg = "该指令/建议现为指令录入完成阶段，确定要继续确认吗？";
        	}else if(processStatus=="1"){
        		msg = "该指令/建议现为确认完成阶段，确定要继续确认吗？";
        	}else if(processStatus=="2"){
        		msg = "该指令/建议现为投资经理下单完成阶段，确定要继续确认吗？";
        	}else if(processStatus=="3"){
        		msg = "该指令/建议现为交易员填单完成阶段，确定要继续确认吗？";
        	}else if(processStatus=="4"){
        		msg = "该指令/建议现为交易已发送阶段，确定要继续确认吗？";
        	}else if(processStatus=="5"){
        		msg = "该指令/建议现为前台已成交阶段，确定要继续确认吗？";
        	}else if(processStatus=="6"){
        		nui.alert("该指令/建议后台已成交，不能再做任何操作","提示");
        		return;
        	}
	    
	        nui.confirm(msg,"系统提示",
	        function(action){
	            if(action=="ok"){
	            	
	            	//提交之前再次实时查询指令/建议单有效状态，避免用户在操作界面停留时间太长导致界面数据状态与数据库不一致
	            	var jsonValidStatus = nui.encode({zhfwptjyznhg:{processId:row.lResultId}});
				  	$.ajax({
				          url:"com.cjhxfund.jy.ProductProcess.JY_ZNHG.getValidStatus_ZNHG.biz.ext",
				          type:'POST',
				          data:jsonValidStatus,
				          cache:false,
				          contentType:'text/json',
				          success:function(text){
				              var returnJsonValidStatus = nui.decode(text);
				              //交易状态：0-有效；1-无效-修改；2-无效-废弃；3-有效-退回；4-无效-退回；
				              var returnValidStatus = returnJsonValidStatus.validStatus;
				              
				              //若指令/建议单有效，则继续执行
				              if(returnValidStatus=="0"){
				              
				              	  	//封装主键ID、指令/建议流程处理状态字段传输到后台处理
				                    var json = nui.encode({zhfwptjyznhgs:[{processId:row.lResultId, processStatus:processStatus}]});
									var a = nui.loading("正在处理中,请稍等...","提示");
					                $.ajax({
					                    url:"com.cjhxfund.jy.ProductProcess.JY_ZNHG.JY_ZNHG_confirm.biz.ext",
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
					                            nui.alert(msg, "系统提示", function(action){
					                            	if(action=="ok"){
					                            		window.CloseWindow("ok");
					                            	}
					                            });
					                        }else{
				                                nui.alert("确认失败", "系统提示");
				                                return;
					                        }
					                    }
					                });
				              }else if(returnValidStatus=="3"){
								  nui.alert("该指令/建议已退回，您不能再确认","提示");
								  return;
				              }else{
								  nui.alert("该指令/建议已无效，不能再做任何操作","提示");
								  return;
				              }
				          }
				      });
	             }
	        });
        }
    });
}



//关闭窗口
function CloseWindow(action) {
    if (window.CloseOwnerWindow)
    return window.CloseOwnerWindow(action);
    else window.close();
}

// 查询二级债录单查询权限
function getProductHandleByDealEnter(vcProductCode) {
	var url = "";
	var result = false;
	url = "com.cjhxfund.ats.sm.comm.InstructionManager.getProductHandleByProductCodeAndRelateType.biz.ext";
	nui.ajax({
		url : url,
		type : 'POST',
		data : {
			productCode : vcProductCode,
			relateType : "04"
		},
		cache : false,
		async : false,
		contentType : 'text/json',
		success : function(text) {
			var returnJson = nui.decode(text);
			if (returnJson.exception == null) {
				var userIds = new Array();
				userIds = returnJson.userIds.split(",");
				for (var i = 0; i < userIds.length; i++) {
					if (userIds[i] == returnJson.userId) {
						result = true;
						return;
					}
				}
				result = false;
			} else {
				result = false;
			}
		}
	});
	return result;
}
	
// 查询二级债录单复核权限
function getProductHandleByDealCheck(resultId) {
	var url = "";
	var result = false;
	url = "com.cjhxfund.ats.sm.comm.InstructionManager.queryCheckUsersByInstructResultId.biz.ext";
	nui.ajax({
		url : url,
		type : 'POST',
		data : {
			lResultId : resultId
		},
		cache : false,
		async : false,
		contentType : 'text/json',
		success : function(text) {
			var returnJson = nui.decode(text);
			if (returnJson.exception == null) {
				var userIds = new Array();
				userIds = returnJson.userIds;
				for (var i = 0; i < userIds.length; i++) {
					if (userIds[i].vcUserId == returnJson.userId) {
						result = true;
						return;
					}
				}
				result = false;
			} else {
				result = false;
			}
		}
	});
	return result;
}

// 获取机器猫业务交易员确认权限
function getJqmConfrimProductHandle(row){
	var url = "";
	var result = false;
	if(row.vcProcessStatus == "5" || row.vcProcessStatus == "6" || row.vcProcessStatus == "7"){
		url = "com.cjhxfund.ats.sm.comm.InstructionManager.getProductHandleUsersByRelateType.biz.ext";
		nui.ajax({
			url : url,
			type : 'POST',
			data : {
				productCode : "",
				relateType : "99"
			},
			cache : false,
			async : false,
			contentType : 'text/json',
			success : function(text) {
				var returnJson = nui.decode(text);
				if (returnJson.exception == null) {
					var userIds = new Array();
					userIds = returnJson.userIds.split(",");
					for (var i = 0; i < userIds.length; i++) {
						if (userIds[i] == returnJson.userId) {
							result = true;
							return;
						}
					}
				}
			}
		});
	}
	return result;
}

//退回操作
function goBack(){
	// 3-二级债 其他为老机器猫

	if(row.cIsValid!="1"){
   		nui.alert("该指令/建议已无效，不能再做退回操作！","提示");
    	return;
   	}else{
   		if(row.vcInstructSource=="3"){
   			nui.open({
   				url : nui.context + "/sm/comm/instruct/inStructBackTaskReason.jsp",
   				title : "指令退回",
   				width : 500,
   				height : 200,
   				onload : function() {
   					var iframe = this.getIFrameEl();
   					iframe.contentWindow.setData(row);
   				},
   				ondestroy : function(action) {
   					var iframe = this.getIFrameEl();
   					var returnJson = iframe.contentWindow.getData();
   					backReturnJson = mini.clone(returnJson);    //必须。克隆数据。
   					window.CloseWindow("ok");
   				}
			});
   		}else if(row.vcInstructSource=="1" || row.vcInstructSource=="2"){	// 机器猫指令	
   			goBack_common_confirm_ZNHG(row);
   		}
   	}
}

//老机器猫退回
function goBack_common_confirm_ZNHG(record){
	//有效无效验证开始...
	var validStr = "";//有效无效验证字符串
	var combProductName = record.vcProductName;//产品名称
	var investProductNum = record.lResultNo;//编号
	var validStatus = record.cIsValid;//交易状态：0-有效；1-无效-修改；2-无效-废弃；3-有效-退回；4-无效-退回；
    var processStatus = record.vcProcessStatus;//指令/建议流程处理状态：-2-指令/建议询价录入完成；-1-交易员填单指令/建议补齐完成；0-投资顾问录入完成；1-指令/建议录入确认完成；2-投资经理下单确认完成；3-交易员填单确认完成；4-交易已发送确认完成；5-前台已成交确认完成；6-后台已成交确认完成；
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
	var goBackStr = "";//该阶段不能退回字符串
	var permissionStr = "";//权限验证字符串
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
	//投资经理下单已确认
	}else{
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
	//权限验证结束!!!
	
	
	
	//封装主键ID字段传输到后台处理开始...
	var processIdArr = new Array();
	var processIdTemp = {processId: record.lResultId};//封装指令/建议单主键ID
	processIdArr.push(processIdTemp);
	var msg = "确定要退回所选的指令/建议吗？";
	nui.confirm(msg,"系统提示",function(action){
		if(action=="ok"){
            var json = nui.encode({zhfwptjyznhgs: processIdArr, validStatus: "3"});
			var a = nui.loading("正在处理中,请稍等...","提示");
            $.ajax({
                url:"com.cjhxfund.jy.ProductProcess.JY_ZNHG.JY_ZNHG_updateValidStatus.biz.ext",
                type:'POST',
                data:json,
                cache: false,
                contentType:'text/json',
                success:function(text){					      		
                	nui.hideMessageBox(a);
                    var returnJson = nui.decode(text);
                    if(returnJson.exception == null){
                        nui.alert("退回成功", "系统提示", function(action){
                        	if(action=="ok"){
                        		window.CloseWindow("ok");
                        	}
                        });
                    }else{
                        nui.alert("退回失败", "系统提示");
                        return;
                    }
                }
            });
		}
	});
}


// 确认按钮分发
function goConfirm_jyy(){
	var json = "";
	delete row.lTradeDate;
	delete row.lFirstSettleDate;
	delete row.lMaturitySettleDate;
	// 3-二级债 其他为老机器猫
	if(row.vcInstructSource=="3"){
		// 5录单确认，6复核确认
		if(row.vcProcessStatus =="5"){
			if(instructCheckUser!=""){
				json = {param:row, userIdList:instructCheckUser};
				singleConfirm(json);
			}else{
				// 获取默认复核人
		  		nui.ajax({
	                url: "com.cjhxfund.ats.sm.comm.InstructionManager.getDefaultCheckUser.biz.ext",
	                type: 'POST',
	                contentType:'text/json',
	                success: function (text) {
	                	var returnJson = nui.decode(text);
						if(returnJson.exception == null){
							if(returnJson != null && returnJson != ""){
								if(returnJson.data.length>0){
									// 调用录单确认逻辑
									json = {param:row, userIdList:returnJson.data};
									singleConfirm(json);
								}else{
									nui.alert("默认复核人为空，请先设置","系统提示");
									return;
								}
							}else{
								nui.alert("默认复核人为空，请先设置","系统提示");
								return;
							}
						}else{
							nui.alert("操作异常","系统提示");
							return;
						}
	                }
	            });
			}
		}else if(row.vcProcessStatus =="6"){
			// 调用复核确认逻辑
			json = {param:row};
			singleConfirm(json);
		}
	}else if(row.vcInstructSource=="1" || row.vcInstructSource=="2"){	// 机器猫指令	
		confirm_common_jyy_ZNHG();
	}
}

// 二级债指令交易员确认
function singleConfirm(json){
	var a = nui.loading("正在处理中,请稍等...","提示");
 	nui.ajax({
    	url: "com.cjhxfund.ats.sm.comm.InstructionManager.updateCheckEnteringStatus.biz.ext",
      	type: 'POST',
      	data: json,
      	contentType: 'text/json',
      	success: function(text){
      		nui.hideMessageBox(a);
      		var returnJson = nui.decode(text);
			if(returnJson.exception == null){
				if(returnJson.rtnCode == "0"){
					nui.alert(returnJson.rtnMsg,"系统提示",  function(action){
						if(action == "ok"){
							window.CloseWindow("ok");
						}	
					});
				}else if(returnJson.rtnCode == "-1"){
					nui.alert(returnJson.rtnMsg,"系统提示",  function(action){
						if(action == "ok"){
							window.CloseWindow("ok");
						}	
					});
				}else{
					nui.alert("操作异常","系统提示");
					return;
				}
			}else{
				nui.alert("系统异常","系统提示");
				return;
			}
      	}
	});
}

/**风控管理开始**/
function subData(riskReturn, instructJson){
	var riskFlag = showRiskInfoApprove(riskReturn, instructJson);
	riskControl(riskFlag, instructJson);
}
function riskControl(riskFlag, instructJson){
	riskFlagParam = riskFlag;
	lResultIdParam = instructJson.instructParameter.lResultId;
	lRiskmgrIdParam = instructJson.instructParameter.lRiskmgrId;
	if(riskFlag=='-1'){
		return;
	}else if(riskFlag=='1'){
		finishInstructWorkitem(workItemID, '1', '');
	}else if(riskFlag=='2'){
		finishInstructWorkitem(workItemID, '1', '');
	}
}
function finishInstructWorkitemFisish(){
	if(riskFlagParam=='2'){
		startRiskProcessInstruct(lResultIdParam, lRiskmgrIdParam);
	}
	window.CloseWindow("ok");
}
/**风控管理结束**/

//二级债投顾指令确认
function submitApprove() {
    //checkResult审批结果1通过，0不通过
    var checkResult = "1";
    
    /**风控管理开始**/
    if(row.instructSource!='2' && (row.vcBizType == "5" || row.vcBizType == "6") && judgeRiskTest(workItemID) ){
		var returnJson = judgeRiskInfo(workItemID, null);	//判断是否有复核节点
		
		if(returnJson.rtnObject.rtnCode=='-1'){		//投资经理不存在
			alert(returnJson.rtnObject.rtnMsg);		//不允许提交
		}else if(returnJson.rtnObject.rtnCode=='1' || returnJson.rtnObject.rtnCode=='2'){	//风控管理存在数据
			if(returnJson.riskInfo.cStatus=='2'){	//风控通过
				checkRiskInfoApprove(workItemID, false);	//校验可用
			}else if(returnJson.workItemDetail.activityDefID=="manualActivity2A"){	//投资经理节点
				nui.alert("风控流程审批未通过，暂不能提交！");
			}else if(returnJson.riskInfo.cStatus=='0' || returnJson.riskInfo.cStatus=='5'){
				checkRiskInfoApprove(workItemID);	//重新调用风控接口
			}else{
				if(returnJson.workItemDetail.activityDefID=="manualActivity1" || returnJson.workItemDetail.activityDefID=="manualActivity111"){
					nui.confirm("风控流程未审批完成，复核通过后会停留在下一节点！","系统提示",function(action){
						if(action=="ok"){
							checkRiskInfoApprove(workItemID, false);	//校验可用
						}
					});
				}else{
					checkRiskInfoApprove(workItemID, false);	//校验可用
				}
			}
		}else{	//风控管理不存在数据
			if(returnJson.workItemDetail.activityDefID=="manualActivity2A"){	//投资经理节点
				checkRiskInfoApprove(workItemID, false);	//校验可用
			}else{	//非投资经理节点
				checkRiskInfoApprove(workItemID);	//重新调用风控接口
			}
		}
		
		return;
	}
    /**风控管理结束**/
    
    var a = nui.loading("正在处理中,请稍等...","提示");
    nui.ajax({
        url: "com.cjhxfund.ats.sm.comm.TaskManager.approveAvailValidate.biz.ext",
        type: "post",
        contentType:'text/json',
        data:{workItemID:workItemID, checkResult:checkResult, checkComments:""},
        success: function (text) {
        	nui.hideMessageBox(a);
        	var returnJson = nui.decode(text);
        	if(returnJson.exception == null){
				if(returnJson.rtnCode == "0"){
            		var alsertMsg = "";
            		if(checkResult=="0"){
            			if(returnJson.rtnMsg){
            				alsertMsg = "</br>此单已退回！</br>退回原因："+returnJson.rtnMsg;
            			}
            			nui.alert("操作成功！"+alsertMsg,"系统提示",function(action){
			    			if(action == "ok"){
			    				window.CloseWindow("ok");
			    			}
		    			});
            		}else{
            			if(returnJson.rtnMsg){
                			alsertMsg = "</br>【该投资建议/指令触发以下风控：</br>"+returnJson.rtnMsg+"】</br>";
                		}
                		nui.alert("审批成功"+alsertMsg,"系统提示",function(action){
			    			if(action == "ok"){
			    				window.CloseWindow("ok");
			    			}
		    			}); 
            		}
            		
				}else if(returnJson.rtnCode == "-1"){
					nui.alert("审批失败</br>"+returnJson.rtnMsg,"系统提示");
					return;
				}else if(returnJson.rtnCode == "0200"){
	    			nui.alert("审批成功"+"</br>"+returnJson.rtnMsg,"系统提示",function(action){
		    			if(action == "ok"){
		    				window.CloseWindow("ok");
		    			}
	    			}); 
				}else if(returnJson.rtnCode == "0301"){
					nui.alert("审批失败,触发禁止风控,风控信息如下：</br>"+returnJson.rtnMsg,"系统提示");
					return;
				}else if(returnJson.rtnCode == "0202"){
					nui.alert("审批失败</br>"+returnJson.rtnMsg,"系统提示");
					return;
				}else{
					nui.alert("操作异常","系统提示");
					return;
				}
			}else{
				nui.alert("系统异常","系统提示");
				return;
			}
        }
    });
}

//确认按钮分发(投顾)
function goConfirm_tg(){
	if(row.vcInstructSource=="3"){
		submitApprove();
	}else if(row.vcInstructSource=="1" || row.vcInstructSource=="2"){	// 机器猫指令	
		confirm_comm_tg_ZNHG();
	}
}

//查询回退权限
function getProductHandleByRollBack(lResultId) {
	var url = "";
	var result = false;
	url = "com.cjhxfund.ats.sm.comm.InstructionManager.getRollBackInstructHandleByResultId.biz.ext";
	nui.ajax({
		url : url,
		type : 'POST',
		data : {
			lResultId : lResultId
		},
		cache : false,
		async : false,
		contentType : 'text/json',
		success : function(text) {
			var returnJson = nui.decode(text);
			if (returnJson.exception == null) {
				var userIds = new Array();
				userIds = returnJson.userIds;
				for (var i = 0; i < userIds.length; i++) {
					if (userIds[i].vcFsOperator == returnJson.userId) {
						result = true;
						return;
					}
				}
				result = false;
			} else {
				result = false;
			}
		}
	});
	return result;
}





//列表中转译托管机构
function depository(e){
	return nui.getDictText("CF_JY_DJTGCS",e.row.vcDepository);
}
//评级展望
function lRatingForecastRD(e){
	return nui.getDictText("ratingOutlook",e.row.lRatingForecast);
}
// 发行人性质
function atsFmIssueProperty(e){
	return nui.getDictText("ATS_FM_ISSUE_PROPERTY",e.row.vcIssueProperty);
}
//交易市场显示
function renderTradePlace(e){
	return nui.getDictText("tradePlace",e.row.vcExchange);
}
//列表中转译托管机构
function renderDepository(e){
	return nui.getDictText("CF_JY_DJTGCS",e.row.vcDepository);
}
//列表中转译债券评级
function renderBondAppraise(e){
	return nui.getDictText("creditRating",e.row.vcBondAppraise);
}
//列表中转译主体评级
function renderIssueAppraise(e){
	return nui.getDictText("issuerRating",e.row.vcIssueAppraise);
}
//列表中转译债券评级机构
function renderBondAppraiseOrgan(e){
	return nui.getDictText("outRatingOrgan",e.row.vcBondAppraiseOrgan);
}