<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" %>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/common.jsp" %>
<!-- 
  - Author(s): 童伟
  - Date: 2017-10-16 14:29:38
  - Description:
-->
<title>退回原因</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <script type="text/javascript" src="<%= request.getContextPath() %>/riskMgr/js/riskMgrComm.js"></script>
    
</head>
<body>
	<form id="reasonForm">
		<table border="0" cellpadding="1" cellspacing="2" style="border-collapse:separate;border-spacing:10px;">
		    <tr>
		        <td >退回原因：</td>
		        <td >
		        	<input class="nui-textarea" id="checkComments" vtype="maxLength:85" width="400" height="100" name="checkComments" required="true"/>
		        </td>
		    </tr>
		    <tr>
		        <td ></td>
		        <td style="text-align: center">
        			<a class='nui-button' plain='true' iconCls="icon-ok" onclick="backTasks()">确定</a>
        			<span style="display:inline-block;width:25px;"></span>
        			<a class='nui-button' plain='true' iconCls="icon-cancel" onclick="closeWindow()">关闭</a>
		        </td>
		    </tr>
		</table>
	</form>
	

	<script type="text/javascript">
    	nui.parse();
    	// 指令信息
    	var row = "";
    	var reasonForm = new nui.Form("#reasonForm");
    	var returnJson=null;
    	
    	function setData(data){
    		row = data;
    	}
    	
    	function getData(){
    		return returnJson;
    	}
    	
    	// 退回操作
		function backTasks(){
			reasonForm.validate();
            if (reasonForm.isValid() == false) return;
			row["vcRejectReason"] = nui.get("checkComments").getValue();
			var checkComments = nui.get("checkComments").getValue();
	 		var a = nui.loading("正在处理中,请稍等...","提示");
	 		// 普通退回
	 		var json = {inquriyData:row};
	 		var url = "com.cjhxfund.ats.sm.inquiry.inquiryResultManage.investManagerReturnInquiry.biz.ext";
	 		// 修改后退回
	 		if(row.workitemid != null && row.workitemid != ""){
	 			json = {checkResult:0,checkComments:checkComments,workItemID:row.workitemid};
	 			url = "com.cjhxfund.ats.sm.comm.TaskManager.approveAvailValidate.biz.ext";
	 		}
			nui.ajax({
				url : url,
				type : 'POST',
				data : json,
				cache : false,
				contentType : 'text/json',
				success : function(text) {
					nui.hideMessageBox(a);
					returnJson = nui.decode(text);
					if(row.vcBizType=='1' || row.vcBizType=='5' || row.vcBizType=='6' || row.vcBizType=='2' || row.vcBizType=='3' || row.vcBizType=='4'){
        				updateRiskStatus("", "", row.lResultId, "4");
					}
					window.closeWindow();
				}
			});
			
	    }
		  
		function closeWindow(e) {
	       if (window.CloseOwnerWindow)
	          return window.CloseOwnerWindow(e);
	       else window.close();
		} 	 	
    </script>
</body>
</html>