<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" %>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/common/js/commscripts.jsp" %>

<head>
<title>综合信息查询</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    
</head>

<body style="width:99.6%;height:99.6%;">
<div  class="nui-tabs"  style="width:100%;height:100%;" activeIndex="0" id="tab1">
	   		</div>
	<script type="text/javascript">
    	nui.parse();
    	//tab页权限处理
		 nui.ajax({
			url:"com.cjhxfund.ats.fm.comm.common.queryMenuList.biz.ext",
            type:'POST',
            data:{funcCode:"ATS_TCGL_SSTCB,ATS_ZHXXCX_JYSZYQ,ATS_ZHXXCX_YHJZYQ,ATS_ZHXXCX_BZQ,ATS_ZHXXCX_JYSHG,ATS_ZHXXCX_YHJHG,ATS_ZHXXCX_CPCCMX,ATS_ZHXXCX_JYSCJHB,ATS_ZHXXCX_YHJCJHB,ATS_ZHXXCX_JZB"},
            cache:false,
            contentType:'text/json',
            success:function(text){
            	var result = nui.decode(text.treeNodes);
            	console.log(result);
	        	if(result){
			        var tempArray = new Array();
 	        		for(var k=0;k<result.length;k++){
	        			if(result[k].RES_ID=="ATS_TCGL_SSTCB"){
							tempArray[0]=result[k];
						}
						if(result[k].RES_ID=="ATS_ZHXXCX_JYSZYQ"){
							tempArray[1]=result[k];
						}
						if(result[k].RES_ID=="ATS_ZHXXCX_YHJZYQ"){
							tempArray[2]=result[k];
						}
						if(result[k].RES_ID=="ATS_ZHXXCX_BZQ"){
							tempArray[3]=result[k];
						}
						if(result[k].RES_ID=="ATS_ZHXXCX_JYSHG"){
							tempArray[4]=result[k];
						}		
						if(result[k].RES_ID=="ATS_ZHXXCX_YHJHG"){
							tempArray[5]=result[k];
						}	
						if(result[k].RES_ID=="ATS_ZHXXCX_CPCCMX"){
							tempArray[6]=result[k];
						}	
						if(result[k].RES_ID=="ATS_ZHXXCX_JYSCJHB"){
							tempArray[7]=result[k];
						}	
						if(result[k].RES_ID=="ATS_ZHXXCX_YHJCJHB"){
							tempArray[8]=result[k];
						}	
						if(result[k].RES_ID=="ATS_ZHXXCX_JZB"){
							tempArray[9]=result[k];
						}				
	        		}
	        		
		        	for(var i=0;i<tempArray.length;i++){
		        		if(tempArray[i]!=null){
					    	var actionURL = '<%=request.getContextPath()%>'+tempArray[i].FUNCACTION;
					    	
							var tabs = nui.get("tab1"); 
							
					        var tab = {title: tempArray[i].FUNCNAME,url:actionURL,showCloseButton:false,refreshOnClick:"true"};
					        var tab1 = tabs.addTab(tab);    
				        }        			        
			        }
			        var tabs = nui.get("tab1");
			        var tab1 = tabs.getTab(0);
                    tabs.activeTab(tab1);	  
	            }
            }
		 });
		 
    </script>
</body>
</html>