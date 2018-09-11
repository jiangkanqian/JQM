<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/bpsExpend/common/processCommon.jsp"%>
<!-- 
  - Author(s): zengjing
  - Date: 2015-12-15 14:34:56
  - Description:
-->
<head>
<title>页面跳转</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <script src="<%= request.getContextPath() %>/common/nui/nui.js" type="text/javascript"></script>
</head>

<body style="height: 98%;overflow: hidden;" >
	<div id="mainProcessTabs"  class="mini-tabs tab-lazy" style="width: 100%;height: 100%;" activeIndex="0">
				<div name="busTab" title="业务信息" style="width: auto;height:100%; position: relative;" onload="asynProcessTab"
					url="<%=request.getContextPath() %>/${bizsrc}?workItemID=${workitem.workItemID}&processInstID=${processInstID}&bizId=${bizId}&timestmp=${timestmp}&pageType=${pageType}&helpWorkItemID=${helpWorkItemID}&biztypename=${biztypename}&lResultId=${lResultId}">
				</div>
				<!--审批意见  -->
				<!--<div id="processControlTab" name="processControlTab" title="流程信息" style="width: auto;position: relative;"
				 url="<%=request.getContextPath() %>/com.cjhxfund.fpm.bpsExpend.processControl.flow?workitemID=${workitem.workItemID}" >
				</div>	-->	
				<!--流程图  -->
				<div id="processGraphTab" name="processGraphTab" title="流程图"  style="width: auto;position: relative;"
				 url= "<%=request.getContextPath() %>/bpsExpend/processComm/processGraph.jsp?processInstID=${processInstID}">
				</div>
	</div>
</body>
</html>
<script type="text/javascript">	
	nui.parse();
	var mainProcessTabs = nui.get("mainProcessTabs");
	var busTab = mainProcessTabs.getTab("busTab");
	//var processTab = mainProcessTabs.getTab("processControlTab");
	var contextpath = "<%=request.getContextPath()%>";
	var workItemID = '<b:write property="workitem/workItemID"/>';
	var processInstID = '<b:write property="workitem/processInstID"/>';
	var parTabId = '<b:write property="parTabId"/>';
	
	
	//异步加载流程页面
	/*function asynProcessTab(){
		if(!mainProcessTabs.getTabIFrameEl(processTab)&&processTab.url!=null){
				mainProcessTabs.loadTab(processTab.url,processTab);
		}
	}*/
	
	//获取业务表单的iframe
	function getBusTabIframe(){
		return mainProcessTabs.getTabIFrameEl(mainProcessTabs.getTab("busTab"));
	}
	
	//获取流程表单的iframe
	function getProcessTabIframe(){
		return mainProcessTabs.getTabIFrameEl(mainProcessTabs.getTab("processControlTab"));
	}
</script>	