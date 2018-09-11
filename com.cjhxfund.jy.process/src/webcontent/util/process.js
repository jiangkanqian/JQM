	function inintProcess(type){
		//附件列表
		var file_grid = nui.get("file_grid");
		var file_Form = new nui.Form("#file_Form").getData(false,false);
		file_grid.load(file_Form);
	     
		//初始化回退环节
		loadActivities();
		//根据选项展示行权年与关联交易报备信息 
		if(type != "no"){ 
			if(resaleRight == 1){
				document.getElementById("resaleYear").style.display = "block";
			}
			if(redemptionRight == 1){
				document.getElementById("redemptionYear").style.display = "block";
			}
			if(isInquiry == 1){
				document.getElementById("associationRemark").style.display = "block";
			}
		}
	}
	
	function inintProcessView(){
		var jsonstr;
		var thisProcessInstID = processInstID;
		if(processInstID == null||processInstID==""){
			thisProcessInstID = wProcessInstID;
		}
		//审批意见
		var processGrid = nui.get("processGrid");
    	jsonstr = {processinstid:thisProcessInstID};
    	processGrid.load(jsonstr); 	
		//流程图
		var processGraphObj = nui.get("processgraph");
		processGraphObj.setProcInstID(thisProcessInstID);
		processGraphObj.load();
	}
	
	//取回退的活动实例
	function loadActivities(){
		var urlStr = contextPath + "/com.cjhxfund.jy.process.wf.getRollBackActivitys.biz.ext";
    	var json = nui.encode({processInstID:nui.get("processinstid").getValue(),workItemID:nui.get("workItemID").getValue()});
    	$.ajax({
            url:urlStr,
            data:json,
            type:'POST',
            contentType:'text/json',
            cache:false,
            success:function(d){
            	if(d && d.activitys) {
            		var data = d.activitys;
            		var backActivityCombo = nui.get("backActivity");
                	backActivityCombo.load(data);
            	}
            }
       });
	}
	
	//检查表单
	function checkForm() {
		var flag = true;
		var operateType = nui.getbyName("bpsParam.operateType").getValue();
		
		if(operateType == null){
			nui.alert("操作选项不能为空，请选择。","系统提示");
			flag = false;
		}
		
		if(operateType==2){//退办
			if(nui.get("backActivity").getValue()==null){
				nui.alert("无可退办节点","系统提示");
				flag = false;
			}
		}
		
	  	if(operateType==3){//转办
	       var size=nui.getbyName("bpsParam.handlerActor").getValue();
	     	if(size.length<=0){
	     		nui.alert("请选择转办人员","系统提示");
	       		flag = false;
	        }	
		}
		
		if(operateType==4){//征求意见
	       var size=nui.getbyName("bpsParam.handlerActor").getValue();
	     	if(size.length<=0){
	     		nui.alert("请选择征求意见人员","系统提示");
	        	flag = false;
	        }	
		}
		
		if(operateType==5){//否决
		     	if(!confirm("确认要否决该流程！")){
		        	flag = false;
		       }	
		}

		return flag;
	}
	
	
	/*
	*流程处理公共方法
	*/
	function operateCheck(ck) {
		var operateType = ck.value;
		if(operateType == 1){//同意
			nui.get("comments").setValue(ck.getSelected().text);
			jQuery("#handlerActor").hide();
			jQuery("#backActivity_tr").hide();
			jQuery("#handlerActorTitle").hide();
		} else if (operateType == 2){//退办
			if(nui.get("backActivity").getText() == ""){
				nui.get("comments").setValue("退办");
			} else {
				nui.get("comments").setValue( "退办 : " + "'"+ nui.get("backActivity").getText() +"'环节");
			}
			jQuery("#backActivity_tr").show();
			jQuery("#handlerActor").hide();	
			jQuery("#handlerActorTitle").hide();
			if(document.getElementById("selectUser")!=null){
				jQuery("#selectUser").hide();	
			}
			if(document.getElementById("sendUser")!=null){
				jQuery("#sendUser").hide();	
			}
			if(document.getElementById("yn_tr")!=null){
				jQuery("#yn_tr").hide();	
			}
		} else if (operateType == 3) {//转办
			if(nui.get("handlerActor").getText() == ""){
				nui.get("comments").setValue("转办");
			} else {
				nui.get("comments").setValue("转办 : " + "'"+ nui.get("handlerActor").getText() +"'");
			}
			jQuery("#handlerActor").show();
			jQuery("#backActivity_tr").hide();
			jQuery("#handlerActorTitle").show();
			document.getElementById("handlerActorTitle").innerHTML="请选择转办人员:";	
			if(document.getElementById("selectUser")!=null){
				jQuery("#selectUser").hide();	
			}	
			if(document.getElementById("sendUser")!=null){
				jQuery("#sendUser").hide();	
			}
			if(document.getElementById("yn_tr")!=null){
				jQuery("#yn_tr").hide();	
			}
		} else if (operateType == 4) {//征求意见
			if(nui.get("handlerActor").getText() == ""){
				nui.get("comments").setValue("征求意见");
			} else {
				nui.get("comments").setValue("征求意见 : " + "'"+ nui.get("handlerActor").getText() +"'");
			}
			jQuery("#handlerActor").show();
			jQuery("#backActivity_tr").hide();
			jQuery("#handlerActorTitle").show();
			document.getElementById("handlerActorTitle").innerHTML="请选择征求意见人员:";
			if(document.getElementById("selectUser")!=null){
				jQuery("#selectUser").hide();	
			}
			if(document.getElementById("sendUser")!=null){
				jQuery("#sendUser").hide();	
			}
			if(document.getElementById("yn_tr")!=null){
				jQuery("#yn_tr").hide();	
			}
		} else if (operateType == 5) {//否决
			nui.get("comments").setValue("否决");
			jQuery("#handlerActor").hide();
			jQuery("#backActivity_tr").hide();
			jQuery("#handlerActorTitle").hide();
			if(document.getElementById("selectUser")!=null){
				jQuery("#selectUser").hide();	
			}
			if(document.getElementById("sendUser")!=null){
				jQuery("#sendUser").hide();	
			}
			if(document.getElementById("yn_tr")!=null){
				jQuery("#yn_tr").hide();	
			}
		}
	}

	//选择人员
	function selectActor(e){ 
		var btnEdit = this;
		nui.open({
			url:  contextPath + "/process/util/multselet_main.jsp",
			title: "员工列表",
			width: 650,
			height: 480,
			ondestroy: function (action) {
				if(action == "ok") {
					var iframe = this.getIFrameEl();
					var emps = iframe.contentWindow.getData();
					emps = nui.clone(emps);    //必须
					if (emps) {
						btnEdit.setValue(emps.value+','+emps.name);
						btnEdit.setText(emps.name);
						var comments = nui.get("comments").getValue();
						nui.get("comments").setValue(comments.split(":")[0] + " : " + "'"+ emps.name +"'");
					}
				}
			}
		});   			
	}
      
	//选择抄送人员
	function selectSendUser(e){ 
		var btnEdit = this;
		nui.open({
			url: contextPath + "/process/util/multselet_main.jsp",
			title: "员工列表",
			width: 650,
			height: 480,
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
  		return nui.getDictText("PM_FLOW_OPERATE_TWO", e.row.operateType);
  	}  
         //返回我的代办页面
    function backSubmit(){
       	window.location.href="<%=request.getContextPath()%>/bps/wfclient/common/fpmMyTasks.jsp";
    }
    
	//获取子页面的fileid字符串
    function getProcessFileIds(){
    	var iframe = document.getElementById("processIframe").contentWindow;
    	var fileIds = iframe.getFileIds();
    	return fileIds;
    }
    
    //批量下载附件
    function fileDownload(){
    	var  datas = nui.get("employee_grid").getSelecteds();
    	var sysId = "";
    	for(var i = 0;i < datas.length;i++){
    		if(sysId == ""){
    			sysId = datas[i].sysid;
    		}else{
    			sysId = sysId + "," +datas[i].sysid;
    		}
    	nui.get("sysid").setValue(sysId);	
      }
    	if(sysId == ""){
    		nui.alert("请选择要下载的附件","系统提示");
    		return;
    	}
    	nui.confirm("确认要下载吗？","系统提示",function(action){
			if(action=="ok"){
				//nui.get("fileDownload").disable();//禁用“导出”按钮
				var form = document.getElementById("file_download");
				form.action = "com.cjhxfund.jy.process.fileDownload.flow";
		        form.submit();
		        //setTimeout("enableExportFun1()",15000);//启用“导出”按钮
			}
		});
    }
    
	//附件列表批量下载附件
	function fileDownload1(){
		var  datas = nui.get("file_grid").getSelecteds();   //获取选中的附件信息
    	
    	//组装附件编号
    	var sysId = "";
    	for(var i = 0;i < datas.length;i++){
    		if(sysId == ""){
    			sysId = datas[i].sysid;
    		}else{
    			sysId = sysId + "," +datas[i].sysid;
    		}
    	  nui.get("sysid").setValue(sysId);	
    	}
    	
    	if(sysId == ""){
    		nui.alert("请选择要下载的附件","系统提示");
    		return;
    	}
    	//下载附件
    	nui.confirm("确认要下载吗？","系统提示",function(action){
			if(action=="ok"){
				//nui.get("fileDownload").disable();//禁用“导出”按钮
				var form = document.getElementById("file_download");
				form.action = "com.cjhxfund.jy.process.fileDownload.flow";
		        form.submit();
		        //setTimeout("enableExportFun1()",15000);//启用“导出”按钮
			}
		});
    }
    
    //word文档下载
    function wordDownload(){
    	var bizId = nui.get("cfjybusinessbonetable.bizId").getValue();
    	nui.get("bizId1").setValue(bizId);

    	nui.get("modeRepayment1").setValue(nui.get("modeRepayment").getValue());
    	nui.get("deadlineInterest1").setValue(nui.get("deadlineInterest").getValue());
    	nui.get("couponRate1").setValue(nui.get("couponRate").getValue());
    	nui.get("issuePrice1").setValue(nui.get("issuePrice").getValue());
    	nui.get("startingDateInterest1").setValue(nui.get("startingDateInterest").getValue());
    	
    	//下载附件
    	nui.confirm("确认要下载吗？","系统提示",function(action){
			if(action=="ok"){
				var form = document.getElementById("word_download");
				form.action = "com.cjhxfund.jy.process.wordDownload.flow";
		        form.submit();
			}
		});
    }
    
    //附件删除后重新加载附件列表
    function loademployeeGrid(gridName,fileName){
        //附件列表
	     var file_grid = nui.get(gridName);
	     var file_Form = new nui.Form("#file_Form").getData(false,false);
	     file_grid.load(file_Form);
     }
     
    
    
    /** 
    * 将数值四舍五入后自动增加千分位. ----所有业务通用
    * @param cmpId 控件ID
    * @param cent 要保留的小数位(Number) 
    * @param isThousand 是否需要千分位 0:不需要,1:需要(数值类型); 
    * @return 格式的字符串,如'1,234,567.45' 
    * @type String 
    */
    function formatNumberCommon(cmpId, cent, isThousand){
    	cent = cent != null ?cent:4;//默认保留4位小数
    	isThousand = isThousand == null || cent == ""?1:isThousand;//默认需要千分位
    	var oldVal = nui.get(cmpId).getValue();
    	if(oldVal!=null && oldVal!=""){
    		var newVal = formatNumber(oldVal,cent,isThousand);
    		nui.get(cmpId).setValue(newVal);
    	}
    }
    
  //关闭窗口
    function CloseWindow(action) {
       if (window.CloseOwnerWindow)
          return window.CloseOwnerWindow(action);
       else window.close();
    }
    
    /**
     * 计算金额加入千分位
     */
   //发行规模(万元)
	function issueSizeFun(){
	   formatNumberCommon("issueSize",0);
	}
	
	//已投资该发行主体证券存量(万元)
	function categoryMoneyFun(){
	   formatNumberCommon("categorymoney",0);
	}
	
	//产品净值规模
	function netWorthScaleFun(){
	  formatNumberCommon("netWorthScale",0);
	}
	
	// 产品净值规模(万元)
    function netWorthScaleFun(){
        formatNumberCommon("netWorthScale",0);
    }
    
    //在线打开用印文档
    file_grid.on("rowdblclick", function (e) {
    	var type = 0;
    	if(activityDefID == "manualActivity8" || activityDefID == "manualActivity12" || activityDefID == "FirstGradeBond_KZJ_YY"){
    		type = 1;
    	}
    	var record = e.record;
    	var actionURL = contextPath + "/commonUtil/JQMHistory/iWebOffice/Judgment_document_type.jsp?sysid="+record.sysid+"&fileName="+record.name+"&type="+type; //目标页面
    	
		var tabs = nui.get("tab"); 
		
		//add tab
        var tab = {title: record.name,url:actionURL,showCloseButton:true};
        tab = tabs.addTab(tab);            

        //active tab  
        tabs.activeTab(tab);
	});	
   
    //打印功能
    function Print(){
    	/*var winFrm=document.PrintForm;
		winFrm.action=contextPath + "/com.cjhxfund.jy.process.FirstGradeBond.FirstGradeBond_print.flow";
		var newwin = window.open('about:blank', 'newWindow');
		winFrm.target = 'newWindow';//这一句是关键
		winFrm.submit();*/
		var processinstid = nui.get("processinstid").getValue();
		window.open("com.cjhxfund.jy.process.FirstGradeBond.FirstGradeBond_print.flow?processinstid="+processinstid);
    }
    
    
    function commonLoading(msg,title){
    	return nui.loading(msg,title);
    }

    function commonHideMessageBox(messageid){
    	 nui.hideMessageBox(messageid);
    }
    
    //判断数据是否回撤
    function retracementJudgment(){
    	
    }
    
    function saveData(data,urlStr){
    	
    	var json = nui.encode(data);
    	var a = nui.loading("流程正在提交中,请稍等...","提示");
    	$.ajax({
    		url:urlStr,
    		type:'POST',
    		data:json,
    		cache:false,
    		contentType:'text/json',
    		success:function(text){
    			nui.hideMessageBox(a);
    			var returnJson = nui.decode(text);
    			if(returnJson.exception == null && returnJson.returnValue != "no"){
    				nui.alert("流程提交成功","系统提示",function(action){
    					debugger;
    					if(myActivityDefID=="manualActivity9"){
    						nui.ajax({
    							url:"com.cjhxfund.cjapi.WSPrimaryMarketService.checkApplyIs.biz.ext",
    							type:'POST',
    							data:{investNo:data.investproductnum},
    				 			cache:false,
    							contentType:'text/json',
    							success:function(text){
    								if(text.ret==false){
    									nui.alert("当前指令不是通过接口下单，不允许推送到招行~");
    									return ;
    								}
			    					nui.open({
			    						url: contextPath+"/process/FirstGradeBond/stockApiList.jsp",
			    						title: "选择推送给招行的新债", width: 750, height: 350,
			    						showCloseButton:false,
			    						onload: function () {
			    							//弹出页面加载完成
			    							var iframe = this.getIFrameEl();
			    							//var data = {pageType:"add",processInstID:processInstID,bizId:bizId};//传入页面的json数据
			    										iframe.contentWindow.setFormData(data);
			    						},
			    						ondestroy: function (action) {//弹出页面关闭前
			    							//刷新页面
			    							//返回我的代办任务页面
			    							CloseWindow("confirmSuccess");
			    							window.opener.parent.location.href=window.opener.parent.location.href;
			    						}
			    					});
    							}
    						});
    					}else{
    						//返回我的代办任务页面
        					CloseWindow("confirmSuccess");
        					window.opener.parent.location.href=window.opener.parent.location.href;
    					}
    					
    				});
	                 
    			}else{
    				if(returnJson.returnValue == "no" && (returnJson.result == 0 || returnJson.result == undefined)){
    					nui.alert("流程提交失败。", "系统提示", function(action){});
    					return;
    				}else if(returnJson.returnValue == "no" && returnJson.result == -1){
    					nui.alert("调用反馈指令状态接口失败，请联系管理员。", "系统提示", function(action){});
    					return;
    				}else if(returnJson.returnValue == "no" && returnJson.result == 1){
    					nui.alert("找不到投资编号:" + returnJson.vcInvestNo + "的有效记录信息。请联系管理员。", "系统提示", function(action){});
    					return;
    				}else if(returnJson.returnValue == "no" && returnJson.result == 2){
    					nui.alert("找到投资编号:" + returnJson.vcInvestNo + "多条有效记录信息。请联系管理员。", "系统提示", function(action){});
    					return;
    				}else if(returnJson.returnValue == "no" && returnJson.result == 3){
    					nui.alert("调用招行接口失败，请联系管理员。", "系统提示", function(action){});
    					return;
    				}else if(returnJson.returnValue == "no" && returnJson.result == 4){
    					nui.alert("中标确认招行接口必填项校验失败，请确认输入的信息是否完整！。", "系统提示", function(action){});
    					return;
    				}else if(returnJson.returnValue == "no" && returnJson.result == 1117){
    					nui.alert("调用招行接口失败，请联系管理员。", "系统提示", function(action){});
    					return;
    				}
    			}
    		}
    	});
	}
    
	//获取选中的附件信息
    function FileSelecteds(gridName){
    	var  datas = nui.get("file_grid").getSelecteds();   //获取选中的附件信息
    	//组装附件编号
    	var sysId = "";
    	for(var i = 0;i < datas.length;i++){
    		if(sysId == ""){
    			sysId = datas[i].sysid;
    		}else{
    			sysId = sysId + "," +datas[i].sysid;
    		}
    	}
    	return sysId;
    }
    
    //发送传真
    function sendFaxes(){
    	var form = new nui.Form("#dataform1");   //获取表单对象
    	form.validate();
        if(form.isValid()==false){
           nui.alert("业务信息必填项不能为空，请输入。","系统提示");
           return;
        }
        //获取流程ID与业务ID
        var bizId = nui.get("cfjybusinessbonetable.bizId").getValue();
        var processinstid = nui.get("processinstid").getValue();
        
        //获取选中的附件信息
        var sysId = FileSelecteds();
        if(sysId == ""){
        	nui.alert("请选择要传真的附件","系统提示");
        	return;
        }
        
        var data = {bpsParam:form.getData(false,true).bpsParam,bizId:bizId,processinstid:processinstid,sysId:sysId};
        
        var json = nui.encode(data);
    	$.ajax({
    		url:"com.cjhxfund.commonUtil.cfjyeastfaxbiz.sendFaxs.biz.ext",
    		type:'POST',
    		data:json,
    		cache:false,
    		contentType:'text/json',
    		success:function(text){
    			var returnJson = nui.decode(text);
    			if(returnJson.exception == null && returnJson.returnValue != "no"){
    				nui.alert("发送成功","系统提示",function(action){});
	                 
    			}else{
    				nui.alert("发送失败。", "系统提示", function(action){});
    			}
    		}
    	});
    }
    