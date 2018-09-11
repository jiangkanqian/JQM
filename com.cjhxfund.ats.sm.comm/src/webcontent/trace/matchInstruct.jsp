<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/common.jsp"%>
<!-- 
  - Author(s): 陈迪
  - Date: 2017-04-13 19:00:24
  - Description:指令/建议要素匹配
-->

<head>
<title>手工指令/建议匹配</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
</head>
<body>
	<div>
		<div id="form_matchIntrust" class="nui-form-table" align="center">
			<table border="0" cellpadding="1" align="center" cellspacing="1" style="width:100%;padding-top:10px">
				<tr>
					<td style="text-align:right">
						<label style="color:red;">*</label>
						<label>指令/建议序号：</label>
					</td>
					<td>
						<input id="resultNo" name="resultNo" class="nui-textbox" style="width:180px;align:left" required="true" />
					</td>
				</tr>
				<tr>
					<td style="text-align:right">
						<label style="color:red">*</label>
						<label>成交编号：</label>
					</td>
					<td>
						<input id="dealNo" name="dealNo" class="nui-textbox" vtype="int" style="width:180px;align:left" required="true" readonly/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div style="text-align: center;padding-top:5px">
		<a class="mini-button" iconCls="icon-ok" onclick="validInstructStatus">确定</a>
		<a class="mini-button" iconCls="icon-cancel" onclick="onCancel">取消</a>
	</div>
	<script type="text/javascript">
		var infos;
		//接收页面传过来的值
		function setMatchData(data){
			infos = nui.clone(data);
			nui.get("dealNo").setValue(infos.vcDealNo);
		}
		
	    // 去后台手工匹配
	    function validInstructStatus(){
	    	var form = new nui.Form("#form_matchIntrust");
			form.validate();
    		if(form.isValid()==false) return;
    		var setmtParamData = form.getData(false,false);;
	    	delete setmtParamData.dealNo;
	    	var json = nui.encode({fundSetmtTrace:setmtParamData});
			nui.ajax({
			  	url:"com.cjhxfund.ats.sm.comm.FundSetmtTraceManager.fundSetmtManualMatchInstruct.biz.ext",
	 		  	type:'POST',
	    	  	data: json,
	    	 	cache:false,
	    	 	contentType:'text/json',
		    	success:function(text){
		    		var rtnJson = nui.decode(text);
					if(rtnJson.exception == null){
			    		if(rtnJson.rtnCode == "0"){
			    			nui.alert(rtnJson.rtnMsg, "系统提示", function(){
			    				window.CloseOwnerWindow();
			    			});
			    		}else if(rtnJson.rtnCode == "1"){
			    			nui.alert(rtnJson.rtnMsg, "系统提示");
							return;
			    		}else{
			    			nui.alert("系统异常","系统提示");
							return;
			    		}
					}else{
						nui.alert("系统异常","系统提示");
						return;
					}
		    	}
			});
	    }
	    
	    //关闭窗口
		function onCancel(e) {
			window.CloseOwnerWindow();
		}
	</script>
</body>
</html>