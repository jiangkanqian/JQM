<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.primeton.cap.AppUserManager"%>
<meta http-equiv="x-ua-compatible" content="IE=8;" />
<html>
<head>
<%@include file="/common.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>创金合信-综合服务平台</title>
<style type="text/css">
.dtHighLight{background:#F0F8FF !important;}
.submain{position:absolute; top:32px; bottom:8px; left:0px; right:0px; *height:100%; _width:80%;}
.sidebar .user .head{display:block; float:left; margin:4px 2px 0 2px; _margin:4px 2px 0 2px; width:51px; height:51px;}
.sidebar .user .tips{float:left; width:145px; margin-top:7px;}
.sidebar .user .font-1{
	overflow: hidden; /*自动隐藏文字*/
	text-overflow: ellipsis;/*文字隐藏后添加省略号*/
	white-space: nowrap;/*强制不换行*/
	/*width: 20em;/*不允许出现半汉字截断*/
	
}

#container{bottom:0px;}
#footer{height:0px;}
#footer p{line-height:0px;}
.mini-outlookbar-groupTitle .newstyle{
	color: red;margin-left: 5px;font-weight: 600;font-style: oblique;
}
.mini-tree-nodetext .newstyle, .mini-tab-text .newstyle{
	color: red;margin-left: 5px;font-style: oblique;
}
</style>
</head>
<body class="index">
<a id="a" class='nui-button' plain='false' style="position:absolute;right:120px;top:8px;z-index:999;" iconCls="icon-download" plain="false" onclick="download()">操作手册下载</a>
<%--<a id="a" class="time font-5"style="position:absolute;right:240px;top:8px;z-index:999;" href="javascript:open();">系统建议/意见</a>--%>
<div class="nui-fit">
	<div id="wrapper" class="wrap">
		<div id="header">
			<div class="head-in clearfix">
				<div class="fl clearfix">
					<h1 class="logo"></h1>
					<h2 class="name">综合服务平台</h2>
				</div>
				<div class="options fr">
					<div class="time font-5"><span id="currentData"></span></div>
				</div>
			</div>
		</div>
		<div class="nui-fit">
			<div id="container">
				<div id="wrapper" class="wrap">
				<div id="layout1" class="nui-layout"  width="100%" height="99.6%" >
					    <div  region="west" width="201px" showHeader="false"  showSplit="false"  showSplitIcon="true">
							<!--侧边栏-->
							<div class="sidebar" style="overflow:-Scroll;overflow-x:hidden;width:200px;border: 0px;">
								<!--用户信息区-->
								<div class="user">
									<img class="head" src="<%=request.getContextPath()%>/coframe/tools/skins/skin1/images/user-head.gif" width="51" height="51" alt="" />
										<p class="tips">
											<span class="font-1" title="<%=AppUserManager.getCurrentUserId() %>"><strong>您好，<%=AppUserManager.getCurrentUserId() %></strong></span>
											<span>
												<a class="set" href="#" onclick="javascript:updatepwd()">修改信息</a>
												<a class="login-out"  href="#" onclick="javascript:loginOut()">注销</a>
											</span>
										</p>
								</div>
								<!--左侧菜单-->
								
								<div class="nui-fit">
									<ul id="leftTree" class="nui-outlooktree" url="org.gocom.components.coframe.auth.LoginManager.getMenuList.biz.ext" 
										style="width:100%;height:100%;"  onnodeclick="onNodeSelect" expandOnNodeClick="true"
			                    		textField="text" idField="id" parentField="pid" resultAsTree="false"
			                    		showTreeIcon="true" dataField="treeNodes" expandOnLoad="false" >        
					       		 	</ul>
								</div> 
							</div>
						</div>
						<!-- 右侧菜单 -->
						<div region="center" width="100%" style="border: 0px;">
							<!--Tabs 修改后主页菜单-->
			                <div id="mainTabs" class="nui-tabs"  maskOnLoad="true" activeIndex="0" style="width:99.8%;height:100%;" tabPosition="bottom" plain="false" showContextMenu="true" onactivechanged="onTabsActiveChanged">
			                     <div title="首页" url="<%=request.getContextPath()%>/commonUtil/messageService/remindManage.jsp" ></div>
			                </div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<%--
		<div id="footer">
			<p>(c) Copyright 创金合信基金管理有限公司 2015. All Rights Reserved. </p>
		</div>
		--%>
	</div>
</div>
<script type="text/javascript">
	nui.parse();
	
	var date = new Date();
	var currentDate = date.getFullYear() + "年" + (date.getMonth()+ 1) + "月" + date.getDate() + "日";
	$("#currentData").text(currentDate);
	var tree = mini.get("leftTree");
	var callFlag = false;
	var callJason = null;
	//折叠被打开的节点
	tree.groups[0].expanded=false;
	//console.log(tree);
	var node = "";
	function showTab(node) {
		var tabs = mini.get("mainTabs");
		var id = "tab$" + node.id;
		var tab = tabs.getTab(id);
		if (!tab) {
			tab = {};
			tab._nodeid = node.id;
			tab.name = id;
			tab.title = node.text;
			tab.showCloseButton = true;
			
			//这里拼接了url，实际项目，应该从后台直接获得完整的url地址
			tab.url = "<%=request.getContextPath() %>/" + node.url;
			var tabArrly = tabs.getTabs();
			if(tabArrly.length > 15){
				nui.alert("最多只能打开15个标签页，请先关闭其他标签页","系统提示");
				return;
			}
			tabs.addTab(tab);
		}
		tabs.activeTab(tab);
	}
	
	function loginOut(){
		location.href="<%=request.getContextPath()%>/coframe/auth/login/logout.jsp";
	}
	function onNodeSelect(e) {
		
		node = e.node;
		var isLeaf = e.isLeaf;
		if (isLeaf) {
			showTab(node);
		}
		
		var text=node.text;//菜单名称
		var url=node.url;//功能调用入口（url）
		var menuid=node.id;//菜单id
		var date=new Date().format("yyyy-MM-dd HH:mm:ss");
		var json = nui.encode({text:text,url:url,menuid:menuid,date:date});
		$.ajax({
			url:"org.gocom.components.coframe.auth.operationLog.addOperationLog.biz.ext",
			type:'POST',
			data:json,
			cache: false,
			contentType:'text/json'
		}); 
	}
	function onClick(e) {
		var text = this.getText();
		nui.alert(text);
	}
	function onQuickClick(e) {
		tree.expandPath("datagrid");
		tree.selectNode("datagrid");
	}
	function onTabsActiveChanged(e) {
		var tabs = e.sender;
		var tab = tabs.getActiveTab();
		var iframe = tabs.getTabIFrameEl(tab);
		if (tab && tab._nodeid) {
			var node = tree.getNode(tab._nodeid);
			if (node && !tree.isSelectedNode(node)) {
				tree.selectNode(node);
			}
		}
		if(callFlag && typeof(iframe) == "undefined"){
			callFlag=false;
			tab.onload = function (e) {        
	            var tradeTabs = e.sender;
	            iframe = tradeTabs.getTabIFrameEl(e.tab);
	            iframe.contentWindow.planToInquiry(callJason);
        	};
		}else if(callFlag){
			callFlag=false;
    		iframe.contentWindow.planToInquiry(callJason);//调用当前显示的标签页的显示详情方法
		}
	}
	
	//修改密码
	function updatepwd(){
		
		nui.ajax({
			url : "org.gocom.components.coframe.auth.LoginManager.checkUserInfo.biz.ext",
			type : 'POST',
			data : {type:'query'},
			cache : false,
			contentType : 'text/json',
			success : function(text) {
				var returnJson = nui.decode(text);
				if(returnJson.exception == null){
					if(!returnJson.isComplete){
						nui.open({
							url: "<%=request.getContextPath()%>/coframe/auth/skin1/employee_basicinfo_update.jsp",
							title:"修改信息",
							width:"620px",
							height:"370px",
							onload: function () {
	                            var iframe = this.getIFrameEl();
	                            //直接从页面获取，不用去后台获取
	                            iframe.contentWindow.setFormData(returnJson.userInfo);
	                            }
						});
					}else{
		var jspUrl = "<%=request.getContextPath()%>/coframe/rights/user/update_password.jsp";
		nui.open({
			url: jspUrl,
			title:"修改密码",
			width: "370px",
			height: "200px"
		});
	}
				}
			}
		});
	}
	nui.ajax({
		url : "org.gocom.components.coframe.auth.LoginManager.checkUserInfo.biz.ext",
		type : 'POST',
		cache : false,
		contentType : 'text/json',
		success : function(text) {
			var returnJson = nui.decode(text);
			if(returnJson.exception == null){
				if(!returnJson.isComplete){
					nui.open({
						url: "<%=request.getContextPath()%>/coframe/auth/skin1/updateUserInfo.jsp",
						title:"欢迎使用本系统",
						/* iconCls:"icon-tip", */
						width:"520px",
						height:"320px",
						onload: function () {
                            var iframe = this.getIFrameEl();
                            //直接从页面获取，不用去后台获取
                            iframe.contentWindow.setFormData(returnJson.userInfo);
                            }
					});
				}
			}
		}
	});

	<%-- nui.ajax({
		url : "com.cjhxfund.ats.sm.comm.InstructionManager.getPendingPresetInstruction.biz.ext",
		type : 'POST',
		data : {pageIndex:0,pageSize:10},
		cache : false,
		contentType : 'text/json',
		success : function(text) {
			var returnJson = nui.decode(text);
			if(returnJson.exception == null){
				if(returnJson.total>0){
					nui.open({
						url: "<%=request.getContextPath()%>/sm/comm/instruct/presetInstructConfirm.jsp",
						title:"预置指令交易提示",
						width:"960px",
					});
				}
			}
		}
	}); --%>
		
	//操作手册下载
    function download(){
        window.location.href = "com.cjhxfund.commonUtil.manualDownload.wordUpload.flow";
    }
    function open(){
    	var leftTree = nui.get("leftTree");
    	var node = leftTree.getNode("1801");
    	showTab(node);
    }	
	
	function dynamicRedirect(data){
		var node = tree.getNode(data.nodeId);
		callJason = nui.clone(data);
		callFlag = true;
		//var selectNode = tree.findNodes(function(node){
		    //if(node.id == 1845) return true;
		//});
		showTab(node);
	}
	
	//更新交易管理菜单下页签栏
	function updateTab(){
		var tabCmp = nui.get("mainTabs");
		var date = new Date();
	    var todayDate = nui.formatDate(date, "yyyyMMdd");
		//到后台获取“今日待处理”模块数据
        var json = nui.encode({processDate: todayDate});
        var tabs = tabCmp.getTabs();
        $.ajax({
            url:"com.cjhxfund.jy.ProductProcess.CFJYProductProcessBiz.getAllBizWaitConfirmInstructCount.biz.ext",
            type:'POST',
            data:json,
            cache: false,
            contentType:'text/json',
            success:function(text){
            	// 机器猫业务条数
                var returnJson = nui.decode(text);
                if(returnJson.exception == null){
                	// 机器猫业务条数
                	var result = returnJson.result;
                	var resultArr = result.split(",");
                	//一级债业务条数
                	var ret = returnJson.ret;
                	// 二级债业务条数
                	var smRepurchaseData = returnJson.smRepurchaseCount;
                	var smTransactionData = returnJson.smTransactionCount;  
                	for(var i=0; i<tabs.length; i++){
                		// 交易管理菜单下面不要默认title
						if(node.id =="1744"){		//一级新债
							if(ret!="" && ret!=""){
								if(tabCmp.getTab(i).title == "一级新债"){
		                			tabCmp.updateTab(tabCmp.getTab(i), {title:"一级新债("+ret+"/"+ret+")"});
								}
		                	}
						} else if(node.id =="1817"){		//债券买卖（机器猫加二级债）
							if(result!=null && result!="" && smRepurchaseData!=null && smRepurchaseData!="" && smTransactionData!=null && smTransactionData!=""){
	                			// 机器猫债券买卖条数
								var jqmCounts = new Array();
	                			jqmCounts = resultArr[0].split("/");
								var zqmmAllCount = parseInt(smTransactionData[0].COUNT+smTransactionData[1].COUNT) +"/"+parseInt(smTransactionData[2].COUNT)+")";
		                		if(tabCmp.getTab(i).title.substring(0,4) == "债券买卖" && tabs[i]._nodeid == "1817"){		// 交易管理菜单id 1267
		                			tabCmp.updateTab(tabCmp.getTab(i), {title:"债券买卖("+zqmmAllCount});
		                		}
	                		}
						} else if(node.id =="1820"){		//正逆回购
							if(tabCmp.getTab(i).title.substring(0,4) == "正逆回购"){
	                			tabCmp.updateTab(tabCmp.getTab(i), {title:"正逆回购("+resultArr[1]+")"});
	                		}
						} else if(node.id =="1821"){		//场外基金
							if(tabCmp.getTab(i).title.substring(0,4) == "场外基金"){
	                			tabCmp.updateTab(tabCmp.getTab(i), {title:"场外基金("+resultArr[3]+")"});
	                		}
						} else if(node.id =="1832"){		//大宗交易
							if(tabCmp.getTab(i).title.substring(0,4) == "股票大宗"){
	                			tabCmp.updateTab(tabCmp.getTab(i), {title:"股票大宗("+resultArr[6]+")"});
	                		}
						} else if(node.id =="1822"){		//参会投票
							if(tabCmp.getTab(i).title.substring(0,4) == "行权管理"){
	                			tabCmp.updateTab(tabCmp.getTab(i), {title:"行权管理("+resultArr[7]+")"});
	                		}
						} else if(node.id =="1823"){		//其他交易
							if(tabCmp.getTab(i).title.substring(0,4) == "其他交易"){
	                			tabCmp.updateTab(tabCmp.getTab(i), {title:"其他交易("+resultArr[8]+")"});
	                		}
						} else if(node.id =="1834"){		//正逆回购
							if(result!=null && result!="" && smRepurchaseData!=null && smRepurchaseData!="" ){
								var znhgAllCount = parseInt(smRepurchaseData[0].COUNT+smRepurchaseData[1].COUNT) +"/"+parseInt(smRepurchaseData[2].COUNT)+")";
		                		if(tabCmp.getTab(i).title.substring(0,4) == "正逆回购" && tabs[i]._nodeid == "1834"){
		                			tabCmp.updateTab(tabCmp.getTab(i), {title:"正逆回购("+znhgAllCount});
		                		}
	                		}
						}
                	}
                }
            }
        });
	}
</script>
</body>
</html>