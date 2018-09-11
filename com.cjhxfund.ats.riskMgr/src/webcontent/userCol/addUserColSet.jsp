<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<%@include file="/common/js/commscripts.jsp" %>
<!-- 
  - Author(s): caikaifa
  - Date: 2018-05-03 13:53:32
  - Description:
-->
<head>
    <title>自定义列设置</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
</head>

    <!-- 权限标签 -->
    <body style="width:99.6%;height:99.6%;overflow: hidden;">
    <div id="datagrid1" class="mini-datagrid" style="width:100%;height:430px;" 
        url="com.cjhxfund.ats.riskMgr.comm.queryUserColSet.biz.ext" idField="id" 
        allowResize="true" showPager="false" dataField="datas"
        allowCellEdit="true" allowCellSelect="true" multiSelect="true" 
        editNextOnEnterKey="true"  editNextRowCell="true" oncellbeginedit="cellbeginedit" oncellendedit="cellendedit" >
        <div property="columns">
            <div type="indexcolumn"></div>
            <div name="vcColComment" field="vcColComment" headerAlign="center" width="150" >[分组名] | 列名</div>
            <div property="editor" type="checkboxcolumn" field="cIsShow" trueValue="1" falseValue="0" width="60" headerAlign="center">是否可见</div>
            <div field="vcColSeq" width="120" headerAlign="center">显示顺序
                <input property="editor" class="mini-textbox" style="width:200px;" minWidth="200" minHeight="50"/>
            </div>
           </div>
     </div>
     <div class="nui-toolbar" id="submit_button" style="padding:0px;width: 100%;" borderStyle="border:0;">
		<table width="100%">
			<tr>
				<td style="text-align:center;" colspan="4">
					<a class='nui-button' plain='false' iconCls="icon-save" onclick="submitUpdate()">
                                                                        确认修改
					</a>
					<span style="display:inline-block;width:25px;"></span>
					<a class='nui-button' plain='false' iconCls="icon-cancel" onclick="onCancel()">
                                                                          取消
					</a>
				</td>
			</tr>
		</table>
	</div>
        <script type="text/javascript">
            nui.parse();
            var vcGridName = "${param.vcGridName}";
            var grid = mini.get("datagrid1");
            
            $(function(){
            	var param = {vcGridName:vcGridName};
       			grid.load(param);
            });
       		
			var editRow=null;
			var oldSeq=null;
			function cellbeginedit(e){
				editRow=e.row;
            	oldSeq=parseInt(editRow.vcColSeq);
			};
			
			//渲染行对象
			grid.on("drawcell", function (e) {
				var record = e.record,
		        column = e.column,
		        row=e.row;
		        //action列，超连接操作按钮
		        if (column.name == "vcColComment") {
		        	e.cellHtml=(row.vcColGroup=="-1"?"":"["+row.vcColGroup+"] | ")+row.vcColComment;
		        }
			});
			
       		function cellendedit(e){
       			if(editRow.vcColName == e.row.vcColName){
       				var olddata = grid.data;
       				for(var i=0;i<olddata.length;i++){
       					if(oldSeq<e.row.vcColSeq){ //原有的小于现在的
       						if(parseInt(e.row.vcColSeq) >= parseInt(olddata[i].vcColSeq) && parseInt(olddata[i].vcColSeq) > oldSeq && olddata[i]._id != editRow._id){
       							olddata[i].vcColSeq=parseInt(olddata[i].vcColSeq)-1;
       							grid.updateRow(grid.getRow(parseInt(olddata[i]._id)-1) ,olddata[i]);
       						}
       					}else{ //原有的大于现在的
       						if(parseInt(e.row.vcColSeq) <= parseInt(olddata[i].vcColSeq) && parseInt(olddata[i].vcColSeq) < parseInt(oldSeq) && olddata[i]._id!=editRow._id){
       							olddata[i].vcColSeq=parseInt(olddata[i].vcColSeq)+1;
       							grid.updateRow(grid.getRow(parseInt(olddata[i]._id)-1) ,olddata[i]);
       						}
       					}
       				}
       			}
        	};
        	
        	function submitUpdate(){
        		var datas = grid.data;
        		var json = nui.encode({datas:datas});
		        $.ajax({
		            url:"com.cjhxfund.ats.riskMgr.comm.saveUserColSet.biz.ext",
		            type:'POST',
		            data:json,
		            cache:false,
		            contentType:'text/json',
		            success:function(text){
		                nui.alert("保存成功,请刷新界面让设置生效.","系统提醒",function(){
		                	CloseWindow("cancel");
		                });
		           }
				});
        	}
        	
        	//关闭窗口
			function CloseWindow(action) {
				if (action == "close" && form.isChanged()) {
					if(confirm("数据被修改了，是否先保存？")) {
						saveData();
					}
				}
				if (window.CloseOwnerWindow)
					return window.CloseOwnerWindow(action);
				else window.close();
			}
			
			//取消
			function onCancel() {
				CloseWindow("cancel");
			}
          </script>
     </body>
</html>