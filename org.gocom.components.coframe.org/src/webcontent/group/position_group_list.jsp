<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<!-- 
  - Author(s): gouyl
  - Date: 2013-10-09 14:43:27
  - Description:下级岗位
-->
<head>
<title>下级岗位</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@include file="/common.jsp" %>
</head>
<body>
<div style="padding:5px 5px 0px 5px;">
	 <div class="nui-toolbar" style="border-bottom:0;">
        <table style="width:100%;">
            <tr>
	            <td style="width:100%;">
	                <a class='nui-button' plain='false' iconCls="icon-add" onclick="add">增加</a>
	            	<a class='nui-button' plain='false' iconCls="icon-edit" onclick="edit" id="edit_btn">编辑</a>
	            	<a class='nui-button' plain='false' iconCls="icon-remove" onclick="remove">删除</a>
	            </td>
            </tr>
        </table>
    </div>
</div>
	<div class="nui-fit" style="padding:0px 5px 5px 5px;">
		<div id="datagrid1" class="nui-datagrid" style="width:100%;height:100%;" 
		url="org.gocom.components.coframe.org.groupposi.queryGroupposi.biz.ext" dataField="treeNodes" onselectionchanged="selectionChanged" ajaxData="getAjaxData" idField="id" allowResize="true" sizeList="[2,10,20,50,100]" pageSize="10" multiSelect="true">
		    <div property="columns">
		        <div type="checkcolumn"></div>
		        <div field="posiname" width="120" headerAlign="center" >岗位名称</div>    
		        <div field="posicode" width="120" headerAlign="center" >岗位代码</div>    
		        <div field="orgGroup"  width="120" headerAlign="center" >所属工作组</div>    
		    </div>
		</div>
	</div>

<div id="removePrompt" style="width:100%;display:none;">
   <table>
     <tr>
       <td>
          <div class="mini-messagebox-question"></div>
       </td>
       <td>&nbsp;&nbsp;&nbsp;确实想要删除选中岗位以及其下属所有记录吗?</td>
     </tr>
   </table>
</div>

<script type="text/javascript">
	nui.parse();
	
	(function(){
		if(window.parent.getCurrentNode){
			var node = window.parent.getCurrentNode();
			var parentNode = node;
			window['parentNode'] = parentNode;
		}
	})();
	
	var grid = nui.get("datagrid1");
	grid.load();
	
	
	var bootPath = "<%=request.getContextPath() %>/";
	
	function add(){
		var url = "";
		var node = window.parentNode||{};
		url = bootPath + "coframe/org/group/position_group_add.jsp";
		nui.open({
            url: url,
            title: "添加下级岗位", width: 600, height: 150,
            onload:function(){
                var iframe = this.getIFrameEl();
                var data = {parentNode:window.parentNode||{}};
                iframe.contentWindow.SetData(data);
            },
            ondestroy: function (action) {
               grid.reload();
               if(action=="ok" && window.parent){
	               window.parent.refreshCurrentNode();
               }
            }
        });
	}
	
	function edit(){
		var row = grid.getSelected();
        if (row) {
        	var url = "";
			var node = window.parentNode||{};
			url = bootPath + "coframe/org/group/position_group_update.jsp";
			nui.open({
	            url: url,
	            title: "修改下级岗位", width: 600, height: 180,
	            onload: function () {
	                var iframe = this.getIFrameEl();
	                var data = row;
	                data.action="update";
	                iframe.contentWindow.SetData(data);
	            },
	            ondestroy: function (action) {
	                grid.reload();
	                if(action=="ok" && window.parent){
		               	window.parent.refreshCurrentNode();
	               }
	            }
	        });
		}else{
			nui.alert("请选中一条记录");
		}
	}
	
	function remove(){
		var rows = grid.getSelecteds();
        if (rows && rows.length > 0) {
       		 nui.confirm("确定删除岗位以及其下面所有记录吗", "系统提示", function(action){
	        	if(action=="ok"){
	        		var json = nui.encode(getRemoveData(rows, "OrgPosition"));
	                grid.loading("操作中，请稍后......");
	                $.ajax({
	                    url: "org.gocom.components.coframe.org.group.deleteNodes.biz.ext",
		                type: 'POST',
		                data: json,
		                cache: false,
		                contentType:'text/json',
	                    success: function (text) {
	                        grid.reload();
	                        if(!text.exception){
				                if(window.parent){
				               		window.parent.refreshCurrentNode();
				               	}
	                        }
	                    },
	                    error: function () {
	                    }
	                });
	        	}
            });
        }else{
			nui.alert("请选中一条记录");
		}
	}
	
	function renderOrg(e){
		var row = e.row;
		if(row.orgOrganization){
			return row.orgOrganization.orgname;
		}
	}
	
	function selectionChanged(){
		var rows = grid.getSelecteds();
		if(rows.length>1){
			nui.get("edit_btn").disable();
		}else{
			nui.get("edit_btn").enable();
		}
	}
	
	//组合删除的数据；需要固定的格式
	function getRemoveData(rows, nodeType){
		var childs = [];
		for(var i=0,len=rows.length;i<len;i++){
			var child = rows[i];
			child.nodeId = child.positionid;
			child.nodeType = nodeType;
			child.orgGroup = null;
			child.orgPosition = null;
			childs.push(child);			
		}
		var parentId = "";
		var parentType = "";
		if(window.parentNode){
			parentId = window.parentNode.nodeId;
			parentType = window.parentNode.nodeType;
		}
		var data = {
			childs:childs,
			parentType:parentType,
			parentId:parentId
		}
		return data;
	}
	
	function getAjaxData(){
		var node = window.parentNode;
		if(!node){
			return "";
		}
		if(node.nodeType=="OrgGroup"){
			return {"criteria":{"_expr":[{"orgGroup.groupid":node.groupid||"","_op":"="},
			{"posilevel":1,"_op":"="}
			]}};
		}
		if(node.nodeType=="OrgPosition"){
			return {"criteria":{"_expr":[{"orgPosition.positionid":node.positionid||"","_op":"="}]}};
		}
	}
	
</script>

</body>
</html>