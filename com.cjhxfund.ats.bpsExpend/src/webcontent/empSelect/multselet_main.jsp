<%@page pageEncoding="UTF-8"%>
<%@page import="com.eos.data.datacontext.UserObject"%>
<% 
	UserObject user = (UserObject)session.getAttribute("userObject");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@include file="/coframe/tools/skins/common.jsp" %>

<html>

<head>
<title>参与者选择</title>

</head>
<body>
<div class="nui-fit">
<!-- 在线用户 -->
<div class="mini-splitter" style="width:100%;height:100%;">
    <div size="30%" showCollapseButton="true">
         <div id="deptsearch" class="mini-fit" style="height:100%;" borderStyle="border:0;">
            <ul id="depttree" class="nui-tree" url="com.cjhxfund.fpm.bpsExpend.empOrg.findAllorganization.biz.ext" style="width:100%;height:100%;"
                showTreeIcon="true" textField="orgname" idField="orgid" 
                parentField="parentorgid" dataField="organizations" resultAsTree="false" showExpandButtons="true" onload="onload" expandOnLoad="true">        
            </ul>
        </div>
      </div>
    <div showCollapseButton="true">
    	<div id="form1" class="nui-form" align="center" style="height:100%;height:15%;">
            <!-- 数据实体的名称 -->
            <!-- 排序字段 -->
            <table id="table1" class="table" style="height:100%; width: 100%;">
                <tr>
                    <td class="form_label" style="text-align: right">
                        员工姓名:
                    </td>
                    <td colspan="1">
                        <input class="nui-textbox" name="targetName" emptyText="请输入拼音或中文" id="targetName" onenter="search(1)" onvaluechanged="search(1)"/>
                    </td>
                    <td colspan="1">
						<a class="nui-button" iconCls="icon-search" onclick="search(1)"> 查询 </a>
					</td>
                </tr>
            </table>
        </div>
         <div class="nui-fit" style="width:100%;height:85%;">
            <div id="usergrid1"
                dataField="data"
                class="nui-datagrid"
                style="width:100%;height:100%;"
                url="com.cjhxfund.fpm.bpsExpend.empOrg.deptUserList.biz.ext"
                allowCellSelect="true"   
                showPageInfo="true"
                sizeList=[20,40,60,100]
                pageSize="20"
                multiSelect="false"
                onrowclick="onrowclick"
                onrowdblclick="onrowdblclick"
                allowSortColumn="true">
                <div property="columns">            
                    <div field="targetName" width="100" headerAlign="center" align="center" allowSort="true">员工姓名</div>
                   <div field="userid" width="80" headerAlign="center"  align="center" allowSort="true">员工帐号</div>
                   <div field="orgname" width="100" headerAlign="center"  align="center" allowSort="true">所属机构</div>
                   <div field="userselect" width="30" headerAlign="center"  align="center"  renderer="showcheckbox">选择</div>
                </div>
            </div>  
        </div>
    </div>        
</div>

</div>
<div style="display:none" property="footer" class="mini-toolbar" style="padding:2px;border-top:0;border-left:0;border-right:0;">
<div >选择用户和机构：</div>
<div>
<input id="selectUsers" class="mini-textboxlist" allowInput="false" name="selectUsers" textName="selectUsersName" required="true" style="width:100%;height:50px;"
        value="" text=""
        valueField="id" textField="text" 
/>
</div>
</div>
<div class="mini-toolbar" style="text-align:center;padding-top:8px;padding-bottom:8px;" borderStyle="border:0;">
        <a class="mini-button" style="" iconCls="icon-ok"  onclick="closeWindow('ok')">确定</a>
        <span style="display:inline-block;width:25px;"></span>
        <a class="mini-button" iconCls="icon-close"  style="" onclick="closeWindow('cancel')">取消</a>
    </div>
<script type="text/javascript">
	window.focus();
	 //禁止后退键 作用于Firefox、Opera
	document.onkeypress=banBackSpace;
	//禁止后退键  作用于IE、Chrome
	document.onkeydown=banBackSpace;
	
	nui.parse();
	var _deptconfig ="1" ;
    var _deptlist = "" ;
    var _deptconfigval = "" ;
    var _datatype = "" ;
    var _minSize = 0;//最小选择
    
    var _maxSize= 10;//最大选择
    
    var currentOrgid = '<%=user.getUserOrgId() %>';
	var grid=nui.get("usergrid1");
	var selectUserObj = nui.get("selectUsers");
	var _selectVal = [] ;
	selectUserObj.on("valuechanged", onValueChanged);
	//机构查询
	 var tree = nui.get("depttree");
     
     tree.on("nodeselect", function (e) {
     	currentOrgid=e.node.orgid;
     	search();
	});
	
	function onrowclick(e){
		//debugger;
		var record = e.record;
		var checked = $("#chk_" + record.targetId).attr("checked");
		if(checked){
			$("#chk_" + record.targetId).attr("checked","false");
		}else{
			$("#chk_" + record.targetId).attr("checked"  ,'true') ;
        }
        checkboxChange("#chk_" + record.targetId) ;
	}
	
	function onrowdblclick(e){
		var record = e.record;
		$("#chk_" + record.targetId).attr("checked"  ,'true') ;
        var checked = $("#chk_" + record.targetId).attr("checked");
		var jsonObj = createObj("#chk_" + record.targetId) ;
		
	 	if(checked){
			addSelectUser(jsonObj) ;
		}
		closeWindow('ok');
	}
	
	function showcheckbox(e){
		var record=e.record;
		//判断是否在结果集中
		// debugger;
		var checkstr = isSelectExist(record.targetId) ? " checked" : "" ;
		return '<input id="chk_'+record.targetId+'" type="radio" targetId="'+record.targetId+'" targetName="'+record.targetName
			+ '" userid="' + record.userid +'" mobileno="' + record.mobileno+  '" pemail="' + record.pemail + '" orgcode="' + record.orgcode 
			+  '" name="useselect" ' + checkstr + ' class="selcheckbox">';
	
	}
	function checkboxChange(obj) {
		
		var checked = $(obj).attr("checked");
		
		var jsonObj = createObj(obj) ;
		
	 	if(checked){
			addSelectUser(jsonObj) ;
		}else{
			removeSelectUser(jsonObj);
		}
	}
	 
	function deptSearch(){
		grid.load({ orgid:currentOrgid ,datatype:"1"}) ;
		/*var depttree = nui.get("depttree");
	 	depttree.setUrl("org.gocom.components.coframe.participantselect.deptselect.deptList.biz.ext") ;
   	 	var rootNode = depttree.getRootNode();
   	 	var nodes = depttree.getChildNodes(rootNode) ;
   	 	
		if(nodes != "undefined" || nodes.length>0){
			depttree.selectNode(nodes[0]);
		}*/
	} 
	function createObj(obj){
		return getEmpVal($(obj).attr("targetId"),$(obj).attr("mobileno")
			,$(obj).attr("pemail"),$(obj).attr("targetName"),$(obj).attr("userid"));
	}
	/**
	* 判断该用户是否已经被选中
	*/ 
	function isSelectExist( _val ){
		//alert(_val);
		_val= _val+"";
		var _selectuser_val = selectUserObj.getValue() ;
	 	var _selectArray = _selectuser_val.split(",") ;
	 	var _index = $.inArray(_val,_selectArray) ;
	 	return _index < 0 ? false : true ;
	}
    /**
    * 添加用户
    */
    function addSelectUser(obj) {
            var _selectuser_val = selectUserObj.getValue() ;
            var _selectuser_name = selectUserObj.getText() ;;
          	var val = getViewValue(obj);
          	var name = getViewName(obj);
            var _selectArray = _selectuser_val.split(",") ;
            var _index=$.inArray(val,_selectArray) ;
          
           	var seprator =  _selectuser_val=="" ?"" : ",";
            if(_index < 0){
            	_selectuser_val = _selectuser_val + seprator + val ;
	           
	            _selectuser_name = _selectuser_name + seprator + name ;
	           
	            selectUserObj.setValue(_selectuser_val) ;
	            
	            selectUserObj.setText(_selectuser_name) ;
	      		
	           _selectVal.pop();
	           _selectVal.push(obj) ;
	           
            }
            
    }
    function getViewName(obj){
    	return obj.username ;
    }
    function getViewValue(obj){
    	return obj.empid ;
    }
    
    /**
    * 创建机构json数据
    */
    function getOrgVal(v_orgid,v_orgcode,v_orgname) {
    	return {type:"org",data:{orgid:v_orgid , orgcode:v_orgcode,orgname:v_orgname}} ;
    }
    /**
    * 创建机构json数据
    */
    function getEmpVal(v_empid,v_mobileno,v_pemail,v_username,v_userid) {
    	return {userid:v_userid , mobileno:v_mobileno,pemail:v_pemail,username:v_username,empid:v_empid} ;
    }
    
    /**
    * 删除选择的用户
    */
	function removeSelectUser(obj) {
		 
		var _selectuser_val = selectUserObj.getValue();
		var _selectuser_name = selectUserObj.getText();
		
		var _selectArray = _selectuser_val.split(",") ;
		var _nameArray = _selectuser_name.split(",") ;
		var val = getViewValue(obj);
       	var _index = $.inArray(val,_selectArray) ;
		
		if(_index >= 0){
		    _selectArray.splice(_index , 1) ;
		    
		    _nameArray.splice(_index , 1) ;
			  
		    _selectVal.splice(_index ,1) ;
		}
		
		selectUserObj.setValue(_selectArray.join(",")) ;
		
		selectUserObj.setText(_nameArray.join(",")) ;
	}
	
	   
	function onValueChanged(e){
		
		var _data = grid.getData() ;
		var _isExist ;
		$.each(_data ,function(_index,record) {  
           _isExist = isSelectExist(record.targetId) ;
            
           if(_isExist){
           		$("#chk_" + record.targetId).attr("checked"  ,'true') ;
           }else{
           		$("#chk_" + record.targetId).removeAttr("checked");
           }
        });
        
        //结果集合内删除被用户点击的
        var valArray = selectUserObj.getValue().split(",") ;
        
        $.each(_selectVal ,function(_index,record) {
          	var val = getViewValue(record) ;
          	if (val!= valArray[_index]) {
            	_selectVal.splice(_index ,1) ;
            	return false ;
            }
             
         });
    }
	function selectAll(){
		var _data = grid.getData() ;
		$.each(_data ,function(_index,record) {  
          	 $("#chk_" + record.targetId).attr("checked"  ,'true') ;
          	 checkboxChange("#chk_" + record.targetId);
         });
   	}
	function removeAll(){
		var _data = grid.getData() ;
		$.each(_data ,function(_index,record) {  
          	$("#chk_" + record.targetId).removeAttr("checked") ;
          	 checkboxChange("#chk_" + record.targetId) ;
         });
	}
    
    //加载成功后
    function onload(e){
    	var tree = nui.get("depttree");
    	var userOrgId = '<%=user.getUserOrgId() %>';
        if(tree.getList()!=null&&tree.getList().length>0){
        	for(var i=0;i<tree.getList().length;i++){
	        	var selectNode = tree.getList()[i];
	        	if(selectNode.orgid==userOrgId){
		        	tree.selectNode(selectNode);
	        	}
        	}
        }
    }
 
 	function setData(data) {
		_deptconfig = data.deptConfig ;
		_deptlist = data.deptList ;
		_deptconfigval = data.deptConfigVal ;
		_minSize = data.minSize ;
		_maxSize = data.maxSize;
		_datatype = data.dataType ;
		_selectVal=data;
		init() ;
	}
	/**
	* 初始化页面的时候执行
	*/
	function init(){
		
		var wfVals=[];
		var wfNames=[];
		for(var i=0,len=_selectVal.length;i<len;i++){
			var obj = _selectVal[i];
			  wfVals.push(getViewValue(obj));
				wfNames.push(getViewName(obj));
		}
		selectUserObj.setValue(wfVals.join(','));
		selectUserObj.setText(wfNames.join(','));
		
		 
	}
	 
	/**
	* 初始化页面的时候执行
	*/
	var retData = {};
	 function closeWindow(action) {            
            if (action == "ok"){
            	var _val = selectUserObj.getValue();
            	var valArray = _val.split(",") ;
            	var aLen = (_val == "") ? 0 :valArray.length ;
            	if(aLen < _minSize){
            		//当记录少于最少值时候
            		nui.alert("选择用户低于最少用户数：" + _minSize);
            		return ;
            	}
            	if(_maxSize >=0 && aLen > _maxSize){
            		//
            		nui.alert("选择用户超过最多用户数：" + _maxSize);
            		return ;
            	}
				retData.data = _selectVal;
				//alert(_selectVal);
				//debugger;
				retData.value=selectUserObj.getValue();
				retData.name = selectUserObj.getText() ;
				//saveRecent();
			}else if (action == "cancel"){
            	//取消所有
            	 
            }else if (action =="clean"){
            	//清除
             
            }
            if (window.CloseOwnerWindow) 
            	return window.CloseOwnerWindow(action);
            else window.close() ;            
        }
        function getData(){
        	return retData ;
        }
    deptSearch();
    function search(index){
     	//alert("search") ;
     	var json = { orgid:currentOrgid ,datatype:"1"};
     	if(index&&index>0){
     		json={targetName:nui.get("targetName").getValue()};
     	}
    	grid.load(json) ;
    }
    function getType(){
    	return nui.get("searchtype").getValue();
    }
    function saveRecent(){
    	//
    	var selList=_selectVal;
    	var dataList=[];
    	/* for(var i=0,len=selList.length;i<len;i++){
    		var selItem=selList[i];
    		
    		var dataItem={};
    		switch(selItem.type){
    			case 'org':
    				dataItem.targetId=selItem.data.orgid;
    				break;
    			case 'emp':
    				dataItem.targetId=selItem.data.empid;
    				break;
    		}
    		dataItem.targetType=selItem.type;
    		dataList.push(dataItem);
    	} */
    	var i = selList.length-1;
    	var selItem=selList[i];
    		
		var dataItem={};
		switch(selItem.type){
			case 'org':
				dataItem.targetId=selItem.data.orgid;
				break;
			case 'emp':
				dataItem.targetId=selItem.data.empid;
				break;
		}
		dataItem.targetType=selItem.type;
		dataList.push(dataItem);
    	nui.ajax({
            url: "org.gocom.components.coframe.participantselect.recentvisit.add.biz.ext",
            type: 'POST' ,
            data: {
            	dataList:dataList
            } ,
            cache: false ,
            contentType:'text/json' ,
            
            success: function (text) {
            	var response = text.retCode ;
            	if(response!="1"){
	            	 nui.alert("处理失败，请联系管理员");
            	}
            },
            error: function (jqXHR, textStatus, errorThrown) {
                nui.alert("插入最新访问入库出错");
                //CloseWindow();
            }
        });
    }
    
    /*------------修改开始，杨志文，20161027----------*/
    	//处理键盘事件 禁止后退键（Backspace）密码或单行、多行文本框除外
		function banBackSpace(e){ 
		    var ev = e || window.event;//获取event对象   
		    var obj = ev.target || ev.srcElement;//获取事件源   
		    var t = obj.type || obj.getAttribute('type');//获取事件源类型  
		    //获取作为判断条件的事件类型
		    var vReadOnly = obj.getAttribute('readonly');
		    //处理null值情况
		    var isReadOnly = (vReadOnly == "") ? false : vReadOnly;
		    //当敲Backspace键时，事件源类型为密码或单行、多行文本的，
		    //并且readonly属性为true或enabled属性为false的，则退格键失效
		    var flag1=(ev.keyCode == 8 && (t=="password" || t=="text" || t=="textarea") 
		                && isReadOnly=="readonly")?true:false;
		    //当敲Backspace键时，事件源类型非密码或单行、多行文本的，则退格键失效
		    var flag2=(ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea")
		                ?true:false;        
		    
		    //判断
		    if(flag2){
		        return false;
		    }
		    if(flag1){   
		        return false;   
		    }   
		}
    	/*window.onload=function(){
		    
		    //禁止后退键 作用于Firefox、Opera
		    document.onkeypress=banBackSpace;
		    //禁止后退键  作用于IE、Chrome
		    document.onkeydown=banBackSpace;
		};*/
    
    /*------------修改结束，杨志文，20161027----------*/
 </script>
</body>
</html>