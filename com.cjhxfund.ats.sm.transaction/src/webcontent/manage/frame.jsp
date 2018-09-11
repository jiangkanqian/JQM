<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" %>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/common.jsp" %>
<!-- 
  - Author(s): 吴艳飞
  - Date: 2016-09-08 16:40:15
  - Description: 二级交易市场
-->
<head>
<title>债券二级交易执行</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
</head>
<body style="width: 100%; height:100%;" onload="reloadWaitConfirmFun(json)">
	<div id="tabs_frame" class="nui-tabs" activeIndex="0" onactivechanged="" style="width:100%;height:100%;">
		<!--<div title="询价录入" url="<%=request.getContextPath() %>/transaction/manage/enquiry_entering/enquiryEntering.jsp"></div>-->
		<div title="交易录单" url="<%=request.getContextPath() %>/transaction/manage/deal_entering/dealEntering.jsp"></div>
		<div title="录单复核" url="<%=request.getContextPath() %>/transaction/manage/entering_reexamine/enteringReexamine.jsp"></div>
	</div>


	<script type="text/javascript">
    	nui.parse();
    	var json = null;
		    	
    	function reloadWaitConfirmFun(json){
    		if(json == null){
    			// 默认查询条件（查询录单和复核）(vcProcessStatus1=待录单，vcProcessStatus2=已录单待复核)
    			json= {vcProcessStatus1:5, cIsValid:1, vcProcessStatus2:6, vcEntrustDirection:"3,4"};
    		}
	    	// 去后台获取条数信息
	        nui.ajax({
	            url:"com.cjhxfund.ats.sm.comm.InstructionManager.queryTransactionRecordCount.biz.ext",
	            type:'POST',
	            data: {param:json},
	            contentType:'text/json',
	            success:function(text){
	                var returnJson = nui.decode(text);
	                if(returnJson.exception == null){
	                	// 给标题添加条数显示
	                	var tabCmp = nui.get("tabs_frame");
	                	tabCmp.updateTab(tabCmp.getTab(0), {title:"交易录单("+returnJson.data[0].COUNT+")"});
                		tabCmp.updateTab(tabCmp.getTab(1), {title:"录单复核("+returnJson.data[1].COUNT+")"});
	                }else{
	                    nui.alert("数据获取失败", "系统提示");
	                }
	            }
	        });
      	}  
    </script>
</body>
</html>