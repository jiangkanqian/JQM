var grid = nui.get("datagrid1");
			
//给业务日期查询条件赋值
//nui.get("processDate").setValue(new Date());
			
var formData = new nui.Form("#form1").getData(false,false);
grid.load(formData);
	    
//重新刷新页面
function refresh(){
	var form = new  nui.Form("#form1");
	var json = form.getData(false,false);
	grid.load(json);//grid查询
	nui.get("update").enable();
	//dynamicHidingColumn();
}

//查询
function search() {
	var form = new nui.Form("#form1");
	var json = form.getData(false,false);
	grid.load(json);//grid查询
}

//重置查询条件
function reset(){
	var form = new nui.Form("#form1");//将普通form转为nui的form
	form.reset();
}

//enter键触发查询
function onKeyEnter(e) {
	search();
}

//流程类型
function rendererVcProcessType(e){
	var processType = e.row.VC_PROCESS_TYPE;
	if(processType == undefined){
		return nui.getDictText("ATS_TASK_BIZ_TYPE",e.row.vcProcessType);
	}else{
		return nui.getDictText("ATS_TASK_BIZ_TYPE",e.row.VC_PROCESS_TYPE);
	}
}
	

		
function ButtonClickGetFundName_ZJTC(e){
	ButtonClickGetFundName(this,jurisdiction);
}
	
if(jurisdiction =="All"){
	nui.get("add").disable();
}
	
	//展示详细行数据
	function onShowRowDetailList(e) {
		var grid = e.sender;//获取表格
	    var row = e.record;//获取行数据
	    var remark = changeNull(row.vcRemarks);//备注信息 
	    var ProcessInstId = row.lProcessInstId;
	    var workItemID = row.workItemID;
	    //判断待办中传过来的流程ID是否为空
	    if(ProcessInstId == undefined){
	    	ProcessInstId = row.L_PROCESS_INST_ID;
	    }
	    if(workItemID == undefined){
	    	workItemID = row.WORKITEMID;
	    }
	    
	    var vcProcessType = row.vcProcessType;
	    if(vcProcessType == undefined){
	    	vcProcessType = row.VC_PROCESS_TYPE;
	    }

	    //获取债券信息
	    var processIdJson = nui.encode({processInstId : ProcessInstId,workItemID:workItemID});
	    $.ajax({
            url:"com.cjhxfund.foundation.task.pendingTreatment.queryTAtsApproveInfo.biz.ext",
            type:'POST',
            data:processIdJson,
            cache: false,
            contentType:'text/json',
            success:function(text){
                var returnJson = nui.decode(text);
                if(returnJson.exception == null){
                    var bonds = returnJson.TAsApproveInfos;
                    var heights = 0;  //动态div与table高度
                    //动态获取table高度
					var height = bonds.length * 25;
					if(height >= 250){   //判断是否大于250,设置DIV高度
						heights = 250;
					}else{
						heights = height + 75;
					}

                    var html = "<div style='width:99%;height:"+heights+"px;overflow:auto;'><table border='0'  style='width:100%;'>";
					 
					/*if(abandonedReasons!=null && abandonedReasons!=""){
						html +=" <tr>"
							 + "  <td style='width:95px;font-weight:bold;vertical-align:top;' align='right'>废弃原因：</td>"
							 + "  <td>" + abandonedReasons + "</td>"
							 + " </tr>";
					} */
					if(remark!=null && remark!=""){
						html +=" <tr>"
							 + "  <td style='width:150px;font-weight:bold;vertical-align:top;' align='right'>备注信息：</td>"
							 + "  <td>" + remark + "</td>"
							 + " </tr>";
					}
					if(returnJson.nextActor!=null && returnJson.nextActor!=""){
						html +=" <tr>"
							 + "  <td style='width:150px;font-weight:bold;vertical-align:top;' align='right'>当前节点参与者：</td>"
							 + "  <td>" + returnJson.nextActor + "</td>"
							 + " </tr>";
					}
					html += "</table>";
                    
					if(height >= 150){   //判断是否大于150,设置table高度
						heights = 150;
					}else{
						heights = height;
					}
					var bondStr = html + "</table>";
					    bondStr += "<table  style='width:99%;height:"+heights+"px;'>"
                    			+" <tr>"
                    			+"  <td style='width:150px;font-weight:bold;' align='center'>审批时间</td>"
                    			+"  <td style='width:220px;font-weight:bold;' align='center'>节点名称</td>"
                    			+"  <td style='width:120px;font-weight:bold;' align='center'>操作者</td>"
                    			+"  <td style='width:120px;font-weight:bold;' align='center'>操作</td>"
                    			+"  <td style='width:200px;font-weight:bold;' align='center'>操作意见</td>"
                    			+" </tr>";
                    var vcOperateType = "同意";			
                    for(var i=0; i<bonds.length; i++){
                    	var bondInfo = bonds[i];
                    	  if(bondInfo.vcOperateType == 1){
                    		 vcOperateType = "同意";
					      }
					      if(bondInfo.vcOperateType == 2){
					    	  if(vcProcessType != 101 && vcProcessType != 102 && vcProcessType != 103){
					    		  vcOperateType = "退办";
					    	  }else{
					    		  vcOperateType = "退回";
					    	  }	  
					      }
					      if(bondInfo.vcOperateType == 3){
					    	  vcOperateType = "转办";
					      }
					      if(bondInfo.vcOperateType == 4){
					    	  vcOperateType = "征求意见";
					      }
					      if(bondInfo.vcOperateType == 5){
					    	  vcOperateType = "否决";
					      }
					      
					      if(bondInfo.vcOperateType == 99 || bondInfo.vcOperateType == 0){
					    	  if(vcProcessType != 101 && vcProcessType != 102 && vcProcessType != 103){
					    		  vcOperateType = "不同意";
					    	  }else{
					    		  vcOperateType = "不通过";
					    	  }
					      }
					      
					      if(bondInfo.vcOperateType == 98){
					    	  vcOperateType = "修改";
					      }
					      if(bondInfo.vcOperateType == 97){
					    	  vcOperateType = "废弃";
					      }
					      if(bondInfo.vcOperateType == 96){
					    	  vcOperateType = "撤回";
					      }
                    	bondStr += "<tr style='height:25px;'><td align='center'>"+ nui.formatDate(bondInfo.dCreateTime, "yyyy-MM-dd HH:mm:ss")+"</td><td align='center'>"+changeNull(bondInfo.vcWorkItemName)+"</td><td align='center'>"+changeNull(bondInfo.vcUserName)
                    			+	"</td><td align='center'>"+changeNull(vcOperateType)+"</td><td align='center'>"+changeNull(bondInfo.vcComments)+"</td></tr>";
                    }
                    bondStr += "</table></div>";
                    
                    var td = grid.getRowDetailCellEl(row);

					td.innerHTML = bondStr;
                    
                }else{
					nui.alert("加载失败", "系统提示");
                }
            }
         });
	}
	
	//行单击时重新设置tabs页面参数
//	grid.on("rowclick", function (e) {
//		var iframeTab = document.getElementById("iframeTab");
//		var actionURL = contextPath + "/task/pedingTab.jsp?bizId="+ e.row.L_BIZ_ID +"&processInstId="+e.row.L_PROCESS_INST_ID;
//		iframeTab.src = actionURL;
//   });  