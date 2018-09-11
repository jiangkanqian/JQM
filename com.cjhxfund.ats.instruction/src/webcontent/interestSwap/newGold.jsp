<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" %>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/JQMHistory/common/commscripts.jsp" %>
<%@include file="/ProductProcess/CFJYProductProcessForm_common.jsp" %>
<html>
<!-- 
  - Author(s): jiangkanqian
  - Date: 2018-05-30 18:42:40
  - Description:
-->
<head>
<title>新增出入金</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <link id="css_icon" rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/coframe/org/css/org.css"/>
    <script type="text/javascript" src="<%= request.getContextPath() %>/JQMHistory/common/common.js"></script>  
</head>
<body>
<div id="newGoldForm" style="padding-top:5px;width: 100%;">
	<input class="nui-hidden" name="newGold.lInstructNo" id="lInstructNo"/>
	<input class="nui-hidden" name="newGold.operatorType" id="operatorType" value="0"/>	
	<input class="nui-hidden" name="newGold.vcProcessState" id="vcProcessState"/>
	<input class="nui-hidden" name="newGold.cIsValid" id="cIsValid"/>	
	<input class="nui-hidden" name="newGold.lGoldId" id="lGoldId"/>
	<input class="nui-hidden" name="newGold.lProcessinstId" id="lProcessinstId"/>
	<input class="nui-hidden" name="newGold.lAttachId" id="lAttachId"/>	 
	<table class="instructTable" border="0" style="width: 100%;">
		<tr>
			<td align="right" width="60px"><span style="color:red">*</span>
				产品名称:
			</td>
			<td colspan="1" width="80px">
				<div name="newGold.vcProductCode" class="mini-autocomplete" pinyinField="ID" id="vcProductCode"
		                             textField="TEXT" valueField="ID"
		                             searchField="productCode"
		                             url="com.cjhxfund.commonUtil.applyInstUtil.QueryTAtsProductInfoMatchSort.biz.ext"
		                             showNullItem="false"
		                             allowInput="true"
		                             emptyText="请输入产品代码或产品名称..."
		                             nullItemText="请输入产品代码或产品名称..."
		                             valueFromSelect="true"
		                             showClose="true"
		                             onvaluechanged="selectFunds"
		                             oncloseclick="onCloseClick"
		                             popupWidth="300"
		                             required="true">
		                            <div property="columns">
		                                <div header="产品代码" field="ID" width="40px"></div>
		                                <div header="产品名称" field="TEXT"></div>
		                            </div>
		                        </div>
		                 <div class="nui-hidden" type="hidden" id="lProductId" name="newGold.lProductId" ></div>
		                 <div class="nui-hidden" id="vcProductName" name="newGold.vcProductName" ></div>
			</td>
			<td align="right" class="form_label" width="60px"><span style="color:red">*</span>
				组合名称:
			</td>
			<td colspan="1" width="100px">
				<input name="newGold.vcCombiCode" class="nui-combobox" id="vcCombiCode"
                           textField="TEXT" valueField="ID"
                           dataField="data"
                           showNullItem="false"
                           allowInput="false"
                           required="true"
                           emptyText="请选择..."
                           nullItemText="请选择..."
                           showClose="true"
                           oncloseclick="onCloseClick"/>
                           <div class="nui-hidden" id="lCombiId" name="newGold.lCombiId" ></div>
                           <div class="nui-hidden" id="vcCombiName" name="newGold.vcCombiName" ></div>
			</td>
		</tr>
		<tr></tr><tr></tr><tr>
		<tr>
			<td align="right" class="form_label" width="60px"><span style="color:red">*</span>
				委托方向:
			</td>
			<td colspan="1" width="80px">
				<input id="vcEntrustDirection" class="nui-radiobuttonlist" name="newGold.vcEntrustDirection" 
				required="true" 
				data="[{id: '0', text: '出金'}, {id: '1', text: '入金'}]"/>
			</td>
			<td align="right" class="form_label" width="60px"><span style="color:red">*</span>
				金额（万元）:
			</td>
			<td colspan="1" width="100px">
				<input id="lGoldCapital" class="nui-textbox" name="newGold.lGoldCapital" required="true"
				 onblur="lFixedRateTrans" onvalidation="fixRateCheck"/>
			</td>
		</tr>
		<tr></tr><tr></tr><tr>
		<tr>
			<td align="right" class="form_label" width="60px"><span style="color:red">*</span>
				代理行:
			</td>
			<td colspan="1" width="80px">
				<input id="vcAgentBank" class="nui-combobox" name="newGold.vcAgentBank" 
				url="com.cjhxfund.ats.instruction.InterestSwap.InterestSwapInstruction.queryAgentBank.biz.ext"
				required="true" style="width:95%" onValuechanged="bankChanged"
				textField="vcAgentBank" valueField="vcAgentBank" dataField="banks"/>
			</td>
			<td align="right" class="form_label" width="60px"><span style="color:red">*</span>
				交易日期:
			</td>
			<td colspan="1" width="100px">
				<input id="lTradeDate" class="nui-datepicker" name="newGold.lTradeDate" 
				required="true" format="yyyyMMdd"/>
			</td>		
		</tr>
		<tr></tr><tr></tr><tr>
		<tr>
			<td align="right" class="form_label" width="60px"><span style="color:red">*</span>
				代理行账号:
			</td>
			<td colspan="1" width="80px">
				<input id="lAgentNo" class="nui-textbox" name="newGold.lAgentNo" 
				required="true" style="width:95%" onvalidation="bankNoCheck"/>
			</td>
			<td align="right" class="form_label" width="80px"><span style="color:red">*</span>
				代理行账户名称:
			</td>
			<td colspan="1" width="100px">
				<input id="vcAgentName" class="nui-textbox" name="newGold.vcAgentName" 
				required="true" />
			</td>
		</tr>
	</table>
	
	<div class="nui-toolbar" align="left" borderStyle="border:0;"><strong>附件:</strong></div>
	<div colspan="3" class="td">
		<iframe id="prodIfm" name="prodIfm" width="98%"  height="120px" frameborder="no" 
		border="0" marginwidth="0" marginheight="0" scolling="no"></iframe>
	</div>
	
	<div class="nui-toolbar" align="left" borderStyle="border:0;"><strong>备注:</strong></div>
	<div colspan="5">
        <input class="nui-textarea"  name="newGold.vcRemark" id="vcRemark" width="100%" height="90px"/>
    </div>
	
	<div class="nui-toolbar" borderStyle="border:0;">
		<div align="center" class="submitDiv">
			<a class="nui-button"  iconCls="icon-ok" plain="true"  id="exactCommit" onclick="commit(this,1)">提交</a>  
			<a class="nui-button"  iconCls="icon-cancel" plain="true"  onclick="onCancel()">取消</a>
		</div>
	</div>
</div>	


	<script type="text/javascript">
    	nui.parse();
		var originalInstructionInfo = null;//修改指令/建议时校验是否修改
    	$(function() {
	    	$("#vcProductCode>span>input").attr("placeholder","请输入产品名称...");
	    	showFile();
		});	
    	
    	function showFile(data){
           		var uuid = guid();
           		nui.get("lAttachId").setValue(uuid);
           		$("#prodIfm").attr("src", nui.context + "/fm/baseinfo/fileuploadComm/any_upload.jsp?attachType=77&attachBusType=3&bizId="+uuid);
           }
        
        //生成uuid
        function guid() {
    		var time = new Date().getTime();
    		var random = GetRandomNum(1,999);
    		var uuid = time.toString() + random.toString();
    		return uuid;
		}
    	
    	function GetRandomNum(Min,Max) {   
			var Range = Max - Min;   
			var Rand = Math.random();   
			return(Min + Math.round(Rand * Range));   
		} 
        
        //产品名称
    	function selectFunds(e){
     		var fundCodeCombo = nui.get("vcProductCode");
    		var vcCombiCombo = nui.get("vcCombiCode");
       		var id = fundCodeCombo.getValue();
       		if(!id){
       			vcCombiCombo.setValue(null);
       			vcCombiCombo.setText(null);
       		}
    		nui.ajax({
        		data:{vcProductCode:id},
        		url:"com.cjhxfund.commonUtil.applyInstUtil.queryCombiInfo.biz.ext",
        		success:function(resp){
        			var returnJson = nui.decode(resp);
					if(returnJson.exception == null){
						var combis = resp.data;
			            if(combis){
		                    vcCombiCombo.load(combis);
		                    if(typeof e === "object"){
		                    	vcCombiCombo.select(0);
		                    }else{
		                    	var combiInList = false;
		                    	for(var i = 0,len = combis.length; i < len;i++){
									if(combis[i].VC_COMBI_NO==e){
										combiInList = true;
							    		vcCombiCombo.setValue(e);
							    	}
								}
								if(!combiInList){
									vcCombiCombo.setValue(null);
       								vcCombiCombo.setText(null);
								}
		                    }
		             	 }
					}else{
						nui.alert("系统异常","系统提示");
					}
	              },
	            //有错误码之后，把后面的错误提醒补齐。
	            fail:function(resp){
	                alert(resp);
	            }
		    });
		    
		    //赋值
		    var funds = fundCodeCombo.getData();	
			for(var i = 0,len = funds.length; i < len;i++){
				if(funds[i].ID==nui.get("vcProductCode").getValue()){
					nui.get("lProductId").setValue(funds[i].L_PRODUCT_ID);
		    	}
			}
			var text = fundCodeCombo.getText();	
			nui.get("vcProductName").setValue(text);			
    	};
    	
    	//组合名称
    	function onCombiChange(){
    		var combis = nui.get("vcCombiCode").getData();
			for(var i = 0, len = combis.length; i < len;i++){
				var asset = combis[i];
				if(asset.ID==nui.get("vcCombiCode").getValue()){
					alert(asset.L_COMBI_ID);
		    		nui.get("lCombiId").setValue(asset.L_COMBI_ID);
		    	}
			}
			alert(nui.get("vcCombiCode").getText());
			nui.get("vcCombiName").setValue(nui.get("vcCombiCode").getText());
    	}
    	
    	//页面X的删除功能
		function onCloseClick(e) {
		    var obj = e.sender;
		    obj.setText(null);
		    obj.setValue(null);
		    obj.doValueChanged();
		}
		
		function initWin(data){
    		var data = nui.clone(data);	  
	        if(data!=null){
	        	nui.get("lProductId").setValue(data.lProductId);//产品Id
	        	nui.get("vcProductCode").setValue(data["vcProductCode"]); //产品代码
				nui.get("vcProductCode").setText(data["vcProductName"]); //产品名称		
	        	nui.get("vcProductName").setValue(data.vcProductName);//产品名称		
				selectFunds(data["vcCombiCode"]);			
				nui.get("lTradeDate").setValue(data["lTradeDate"].toString());//交易日期
				nui.get("vcRemark").setValue(data.vcRemark);//备注
				nui.get("operatorType").setValue(data.operatorType);//操作类型
				nui.get("lInstructNo").setValue(data.lInstructNo);//指令编号
				nui.get("vcCombiCode").setValue(data.vcCombiCode);//
				nui.get("lCombiId").setValue(data.lCombiId);//
				nui.get("vcCombiName").setValue(data.vcCombiName);//
				nui.get("vcProcessState").setValue(data.vcProcessState);//
				nui.get("cIsValid").setValue(data.cIsValid);//
				nui.get("lProcessinstId").setValue(data.lProcessinstId);
				nui.get("vcEntrustDirection").setValue(data.vcEntrustDirection);
				nui.get("lGoldCapital").setValue(data.lGoldCapital);
				nui.get("vcAgentBank").setValue(data.vcAgentBank);
				nui.get("lAgentNo").setValue(data.lAgentNo);
				nui.get("vcAgentName").setValue(data.vcAgentName);
				var operatorType = data.operatorType;				
				if(operatorType == "1"){
					nui.get("lGoldId").setValue(data.lGoldId);
				}
				originalInstructionInfo = new nui.Form("#newGoldForm").getData(false,false);
				
				/*
				var lAttachId = data.lAttachId;
				nui.get("lAttachId").setValue(lAttachId);
				if(operatorType == "1" || operatorType == "2"){
					$("#prodIfm").attr("src", nui.context + "/fm/baseinfo/fileuploadComm/any_upload.jsp?attachType=77&attachBusType=1&bizId="+lAttachId);
				}
				*/
				
	        }
    	}
        
        function capsulationInstructParameter(){			 
				var combis = nui.get("vcCombiCode").getData();
				for(var i = 0, len = combis.length; i < len;i++){
					var asset = combis[i];
					if(asset.ID==nui.get("vcCombiCode").getValue()){
		    			nui.get("lCombiId").setValue(asset.L_COMBI_ID);
		    		}
				}
				nui.get("vcCombiName").setValue(nui.get("vcCombiCode").getText());							 				
	   	 }
        
        //提交
 		function commit(instructJson,doClose){
 			 doCloseParam = doClose;
 			 capsulationInstructParameter();
		 	 var dataForm = new nui.Form("#newGoldForm");
    		 dataForm.validate();
			 if(dataForm.isValid()==false){
				 return;
			 } 			 
			 var data = dataForm.getData(false, true);
			 
			 //判断修改指令/建议是否有做修改			
			if(nui.get("operatorType").getValue() == "1"){
				var flag = false;
				var instructs = new nui.Form("#newGoldForm").getData(false,false);
				for(var key1 in originalInstructionInfo){
					for(var key in instructs){
						if(key1 == key){
							if(key1 && key){
								if(originalInstructionInfo[key1] != instructs[key]){
									flag = true;
								}
							}
						}
					}
				}
				if(!flag){
					nui.alert("未做任何修改","提示");
					return;
				}
			}
			
			 //格式转换			 
			 data.newGold.lTradeDate = nui.formatDate(nui.get("lTradeDate").value, "yyyyMMdd");
			 data.newGold.lGoldCapital = nui.get("lGoldCapital").getValue().replace(/,/g,'');
			 var agentNo = parseInt(nui.get("lAgentNo").getValue().toString());
			 data.newGold.lAgentNo = agentNo;
			 				 
			 var instructJson = nui.encode(data);				 
 			 var tooltip = nui.loading("正在处理中,请稍等...","提示");
 			 nui.ajax({
 				url: "com.cjhxfund.ats.instruction.InterestSwap.InterestSwapInstruction.goldProcess.biz.ext",
	            type: 'POST',
	            data: instructJson,
	            cache: false,
	            contentType: 'text/json',
	            success: function (text) {
	            	nui.hideMessageBox(tooltip);
	            	var returnJson = nui.decode(text);
	            	if(returnJson.exception == null){
	            		if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_SUCCESS%>"){
	            			var riskMsg = returnJson.riskMsg;
	            			if(riskMsg!=null && riskMsg.isAgainstRisk){
	            				riskMsg["alertMsg"]="投资指令/建议下达成功！";
	            				nui.open({
			                        url: "<%=request.getContextPath()%>/fix/riskControlDetailList.jsp",
			                        title: "投资指令/建议风控信息",
			                        width: 800,
			                        height: 422,
			                        onload: function () {
			                            var iframe = this.getIFrameEl();
			                            iframe.contentWindow.SetData(riskMsg,3);
			                        },
			                        ondestroy: function (action) {
			                        	if(doClose){
			                        		window.CloseOwnerWindow();
			                        	}
			                        }
			                    });
	            			}else{
		            			nui.alert("投资指令/建议下达成功！","提示",function(){
		            				if(doClose){
		            					window.CloseOwnerWindow();
		            				}
	                            	
	                            });
	            			}
	            		}else if(returnJson.rtnCode == "203" || returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ORDER_USABLE_AMOUNT_INSUFFICIENT%>"){//校验存在问题
	            			window.parent.parentConfirm(returnJson.rtnMsg+"</br>是否继续下单？","提示", function(action){
		                		if(action == "ok") {
                                	formalInstructionEntry(instructJson,doClose);
                                }
		                	});
	            		}else if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ERROR%>"){
	            			var riskMsg = returnJson.riskMsg;
	            			if(riskMsg!=null && riskMsg.isAgainstRisk){//触发了风控
	            				riskMsg["alertMsg"]="投资指令/建议下达失败！";
	            				nui.open({
			                        url: "<%=request.getContextPath()%>/fix/riskControlDetailList.jsp",
			                        title: "投资指令/建议风控信息",
			                        width: 800,
			                        height: 422,
			                        onload: function () {
			                            var iframe = this.getIFrameEl();
			                            iframe.contentWindow.SetData(riskMsg,3);
			                        }
			                    });
	            			}else{
	            				nui.alert(returnJson.rtnMsg,"提示",function(){
		            					window.CloseOwnerWindow();
	                            	
	                            });
	            			}
	            		}else if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ORDER_NO_RCV_FR_O32%>"){
	            			nui.alert("投资指令/建议下达成功！"+returnJson.rtnMsg,"提示",function(){
                            	if(doClose){
                            		window.CloseOwnerWindow();
                            	}
                            });
	            		}else if(returnJson.rtnCode == "301"){
	            			var riskInfo = returnJson.riskMsg;
	            			riskInfo["alertMsg"]=returnJson.rtnMsg;
	            			nui.open({
		                        url: "<%=request.getContextPath()%>/fix/riskControlDetailList.jsp",
		                        title: "投资指令/建议风险提示",
		                        width: 800,
		                        height: 422,
		                        onload: function () {
		                            var iframe = this.getIFrameEl();
		                            iframe.contentWindow.SetData(riskInfo,1);
		                        },
		                        ondestroy: function (action) {
		                            if (action == "ok") {
	                                    formalInstructionEntry(instructJson,doClose);
	                                }
		                        }
		                    });
	            		}else{//触发风控，弹出风险提示框，展示风险信息
	            			var riskInfo = returnJson.riskMsg;
	            			nui.open({
		                        url: "<%=request.getContextPath()%>/fix/riskControlDetailList.jsp",
		                        title: "投资指令/建议风险提示",
		                        width: 800,
		                        height: 380,
		                        onload: function () {
		                            var iframe = this.getIFrameEl();
		                            iframe.contentWindow.SetData(riskInfo,1);
		                        },
		                        ondestroy: function (action) {
		                            if (action == "ok") {
	                                    formalInstructionEntry(instructJson,doClose);
	                                }
		                        }
		                    });
	            		}
	            	}else{
	            	   nui.alert("系统异常","系统提示");
	            	}
	            }
 			 });
 			 
   		 }
         
         function fixRateCheck(e){
			var reg= /^(-?\d+)(\.\d+)?$/;
        	var value = e.sender.value;
        	if(!reg.test(value.replace(/,/g,''))){
        		//e.sender.setValue("");
        		e.errorText = "请输入数字";
        	 	e.isValid = false;
        	 	return true;
        	}
        	
		}
        
        function bankChanged(){
			var bank = nui.get("vcAgentBank").getValue();
			var vcAgentBank = {vcAgentBank:bank};
			nui.ajax({
					    url: "com.cjhxfund.ats.instruction.InterestSwap.InterestSwapInstruction.queryAgentBank.biz.ext",
					    type: 'POST',
					    data: {param:vcAgentBank},		
					    contentType: 'text/json',
					    success: function(text){
					      		var returnJson = nui.decode(text);
					      		var bank = returnJson.banks[0];
					      		if(bank!=null){
					      			if(bank.lAgentNo != null){
					      				nui.get("lAgentNo").setValue(bank.lAgentNo);
					      			}
					      			else{
					      				nui.get("lAgentNo").setValue(null);
					      			}
					      			
					      			if(bank.vcAgentName != null){
					      				nui.get("vcAgentName").setValue(bank.vcAgentName);
					      			}
					      			else{
					      				nui.get("vcAgentName").setValue(null);
					      			}
					      		}
					      	}
				 		});       
        }
        
        function lFixedRateTrans(){
 			var num = nui.get("lGoldCapital").getValue();
 			if(num == "" || num == null || num == undefined){}
 			else{
 				var numTrans = formatNumber(num, 4, 1);
 				nui.get("lGoldCapital").setValue(numTrans);
 			}
 		}       
        
		function bankNoCheck(e){
			var reg= /^([1-9][0-9]{0,18})$/;
        	var value = e.sender.value;
        	if(!reg.test(value.replace(/,/g,''))){
        		//e.sender.setValue("");
        		e.errorText = "请输入低于19位的整数";
        	 	e.isValid = false;
        	 	return true;
        	}
        	
		}
        
    </script>
</body>
</html>