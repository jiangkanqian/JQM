<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/common/common.jsp" %>


<%@page import="com.primeton.das.entity.impl.hibernate.mapping.Array"%>
<%@page import="commonj.sdo.DataObject"%>
<%@page import="java.util.ArrayList"%>

<html>
<!-- 
  - Author(s): wujiaxin
  - Date: 2017-01-13 16:04:56
  - Description:
-->
	
<head>
<title>定时器维护</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <script src="<%= request.getContextPath() %>/common/nui/nui.js" type="text/javascript"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/common/nui/locale/zh_CN.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/taskTimer/taskjs/schedule.js"></script>
</head>
<body>
	<!-- 隐藏域   开始-->
	<!-- 任务主键 -->
	<input id="pageType" class="nui-hidden" name="pageType">
	<div id="dataform1" style="padding-top:5px;">
		
		<input id="taskId" class="nui-hidden" name="task.lId">
		<input id="timerId" class="nui-hidden" name="timer.lTimerId">
		<input id="vcBegin" class="nui-hidden" name="timer.vcBegin">
		<input id="vcEnd" class="nui-hidden" name="timer.vcEnd">
		<input id="cronExpression" class="nui-hidden" name="timer.vcCronExpression">
		
		<!-- 隐藏域	  结束 -->
		
		<!-- 表格开始 -->
		<table style="width:100%;table-layout:fixed;" class="nui-form-table" border="0">
			<tr>
				<td width="76px" style="font-size:12px;"><label for="data.CFMS$text">触发模式：</label></td>
				<td style="font-size:12px;" colspan="3">
					<input id="triggerType" name="timer.vcTriggerType" class="nui-radiobuttonlist" valueField="id" textField="text" onvaluechanged="cfmsValueChanged">
				</td>
			</tr>
			<tr>
				<td width="70px" style="font-size:12px;"><label for="data.CFMS$text">状态：</label></td>
				<td style="font-size:12px;" colspan="3">
					<input id="timeStatus" name="timer.vcState" class="nui-radiobuttonlist" valueField="id" textField="text" >
				</td>
			</tr>
			<tr id="rlzqcf_cfsj_tr">
				<td><label for="data.cfsj">触发时间：</label></td>
				<td colspan="3">
					<input id="triggerTime" class="nui-timespinner" format="HH:mm" value="00:00:00" style="width: 90px;" >
					<span id="sjjgcfSpan" style="display: none;">-
						<input id="triggerTime1" class="nui-timespinner" format="HH:mm" value="01:00:00" style="width: 90px;" onblur="timeValueChanged">
						<span style="margin-left: 10px;">
							每隔
							<input id="zengliang"  name="timer.vcFrequency" class="nui-dictcombobox"  value="5"   dictTypeId="OMS_TIME">
							分钟执行一次<%--<span style="color: red;">值范围：5-50</span>--%>
						</span>
					</span>
				</td>
			</tr>
			<tr id="rlzqcf_xhms_tr">
				<td><label for="data.xhms">循环模式：</label></td>
				<td colspan="3">
					<input id="xhms" class="nui-radiobuttonlist" valueField="id" textField="text" onvaluechanged="xhmsValueChanged">
				</td>
			</tr>
			<tr id="xhms1tr" style="display:none;">
				<td><label for="data.xhms1"><span id="xhms1"></span></label></td>
				<td id='meizhou' colspan="2" style="display: none;">
					<input id="week_type" class="nui-checkboxlist" valueField="id" textField="text">
				</td>
				<td id='meiyue' colspan="2" style="display: none;">
					<input id="month_type" class="nui-combobox" valueField="id" textField="text" emptyText="请选择...">
				</td>
				<td id='meinian' colspan="2" style="display: none;">
					<input id="year_type_month" class="nui-combobox" valueField="id" textField="text" emptyText="请选择..." onvaluechanged="yearTypeMonthChanged">
					<input id="year_type_day" class="nui-combobox" valueField="id" textField="text" emptyText="请选择..." style="display: none;">
				</td>
			</tr>
			<tr id="gdskcf_jgsj_tr" style="display: none;">
				<td><label for="data.jgsj">间隔时间：</label></td>
				<td colspan="3">
					<input id="jgsj" class="nui-textbox" value="1"><span style="color: red;margin-left: 10px;">单位：分钟         最小为1，最大为60；</span>
				</td>
			</tr>
			<tr id="gdskcf_zxcs_tr" style="display: none;">
				<td><label for="data.zxcount">执行次数：</label></td>
				<td colspan="3">
					<input id="zxcount" class="nui-textbox" value="-1"><span style="color: red;margin-left: 10px;">“-1”表示不限次数，一直执行到结束时间，若结束时间为空，则永远不会结束</span>
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center">
				   <a class="nui-button" iconCls="icon-save" onclick="saveSchedule()">保存</a>
							<span style="display:inline-block;width:25px;"></span>
					<a class="nui-button" iconCls="icon-cancel" onclick="onCancel()">取消</a>
				</td>
			</tr>
		</table>
		
		<!-- 表格结束 -->
	</div>
	
</body>
	<script type="text/javascript">
    	nui.parse();
    	
    	//-----------------------------------------------------------------页面初始化---------------------------------------------------------------------------//
    	
    	//触发模式
    	var cfmsData = [{'id':'0','text':'日历周期触发'},{'id':'1','text':'间隔时间触发'}];
    	//状态
    	var timeStatusData = [{'id':'true','text':'有状态'},{'id':'false','text':'无状态'}];
    	//循环模式
    	var xhmsData = [{'id':'0','text':'每日'},{'id':'1','text':'每周'},{'id':'2','text':'每月'},{'id':'3','text':'每年'}];
    	//每周选项
    	var weekTypeData = [{'id':'1','text':'周日'},{'id':'2','text':'周一'},{'id':'3','text':'周二'},{'id':'4','text':'周三'},{'id':'5','text':'周四'},{'id':'6','text':'周五'},{'id':'7','text':'周六'}];
    	//每月选项
    	var monthTypeData = "";
		for(var i=0;i<31;i++){
			var id = i+1;
			var text = i+1+"日";
			if(monthTypeData==""){
				monthTypeData = "{'id':'"+id+"','text':'"+text+"'}";
			}else{
				monthTypeData = monthTypeData+",{'id':'"+id+"','text':'"+text+"'}";
			}
		}
		monthTypeData = "["+monthTypeData+"]";
    	//每年选项
    	var yearTypeData = "";
    	for(var i=0;i<12;i++){
    		var id = i+1;
    		var text = i+1+"月";
    		if(yearTypeData==""){
    			yearTypeData = "{'id':'"+id+"','text':'"+text+"'}";
    		}else{
    			yearTypeData = yearTypeData+",{'id':'"+id+"','text':'"+text+"'}";
    		}
    	}
    	yearTypeData = "["+yearTypeData+"]";
    	
    	$(function(){
    		initPage();
    		cfmsValueChanged();
    		xhmsValueChanged();
    	});
    	//初始化页面是执行
    	function initPage(){
    		var pageType = window.Owner.getPageType();
    		var taskId = window.Owner.getTaskId();
    		nui.get("pageType").setValue(pageType);
    		nui.get("taskId").setValue(taskId);
    		//设置触发模式
    		nui.get("triggerType").setData(cfmsData);
    		nui.get("triggerType").setValue("0");
    		//设置状态
    		nui.get("timeStatus").setData(timeStatusData);
    		nui.get("timeStatus").setValue("false");
    		//设置循环模式
    		nui.get("xhms").setData(xhmsData);
    		nui.get("xhms").setValue("0");
    		//设置每周选项
    		nui.get("week_type").setData(weekTypeData);
    		//设置每月选项
    		nui.get("month_type").setData(monthTypeData);
    		//设置每年选项
    		nui.get("year_type_month").setData(yearTypeData);
    		//nui.get("year_type_day").setData(monthTypeData);
    		if(pageType=="edit"){
    			var grid = window.Owner.getDataGrid();
    			var row = grid.getSelected();
    			nui.get("cronExpression").setValue(row.vcCronExpression);
    			nui.get("taskId").setValue(row.lTaskId);
    			nui.get("timerId").setValue(row.lTimerId);
    			nui.get("triggerType").setValue(row.vcTriggerType);
    			nui.get("timeStatus").setValue(row.isStateful);
    			
    			if(row.vcTriggerType=="0"){
    				initRlzqcf(row.vcCronExpression);
    			}else if(row.vcTriggerType=="1"){
    				nui.get("triggerTime").setValue(row.vcBegin);
    				nui.get("triggerTime1").setValue(row.vcEnd);
    				nui.get("zengliang").setValue(row.vcFrequency);
    			}
    			initTaskSchedule();
    		}
    	}
    	
    	
    	//-----------------------------------------------------------------触发模式---------------------------------------------------------------------------//
    	//日历周期触发模式
    	function rlzqcf(){
    		//隐藏固定时刻触发的间隔时间
    		$("#gdskcf_jgsj_tr").hide();
    		//隐藏固定时刻触发的执行次数
    		$("#gdskcf_zxcs_tr").hide();
    		//隐藏时间间隔触发
    		$("#sjjgcfSpan").hide();
    		//显示日历周期触发的触发时间
    		$("#rlzqcf_cfsj_tr").show();
    		//显示日历手气触发的循环模式
    		$("#rlzqcf_xhms_tr").show();
    		//初始化间隔时间
    		
    		//初始化循环模式
    		//nui.get("xhms").setValue(0);
    		//调用循环模式
    		//xhmsValueChanged();
    	}
    	//时间间隔触发模式
    	function sjjgcf(){
    		//隐藏固定时刻触发的间隔时间
    		$("#gdskcf_jgsj_tr").hide();
    		//隐藏固定时刻触发的执行次数
    		$("#gdskcf_zxcs_tr").hide();
    		//显示时间间隔触发
    		$("#sjjgcfSpan").show();
    		//显示日历周期触发的触发时间
    		$("#rlzqcf_cfsj_tr").show();
    		//显示日历手气触发的循环模式
    		$("#rlzqcf_xhms_tr").show();
    		
    		//初始化循环模式
    		//nui.get("xhms").setValue(0);
    		//调用循环模式
    		//xhmsValueChanged();
    	}
    	//固定时刻触发模式
    	function gdskcf(){
    		//隐藏时间间隔触发
    		$("#sjjgcfSpan").hide();
    		//隐藏日历周期触发的触发时间
    		$("#rlzqcf_cfsj_tr").hide();
    		//隐藏日历手气触发的循环模式
    		$("#rlzqcf_xhms_tr").hide();
    		//显示固定时刻触发的间隔时间
    		$("#gdskcf_jgsj_tr").show();
    		//显示固定时刻触发的执行次数
    		$("#gdskcf_zxcs_tr").show();
    		//初始化循环模式
    		nui.get("xhms").setValue(0);
    		//调用循环模式
    		xhmsValueChanged();
    	}
    	
    	//触发模式值改变时执行
    	function cfmsValueChanged(){
    		//获取触发模式
    		var triggerType = nui.get("triggerType").getValue();
    		if(triggerType=="0"){
    			//日历周期触发
    			rlzqcf();
    		}else if(triggerType=="1"){
    			//时间间隔触发
    			sjjgcf();
    		}else if(triggerType=="2"){
    			//固定时刻触发
    			gdskcf();
    		}
    	}
    	
    	//-----------------------------------------------------------------循环模式---------------------------------------------------------------------------//
    	//循环模式值改变时执行
    	function xhmsValueChanged(){
    		var xhmsValue = nui.get("xhms").getValue();
    		if(xhmsValue=="0"){//每天
    			$("#meizhou").hide();
    			$("#meiyue").hide();
    			$("#meinian").hide();
    			nui.get("week_type").setValue("");
    			nui.get("month_type").setValue("");
    			nui.get("year_type_month").setValue("");
    			nui.get("year_type_day").setValue("");
    			$("#xhms1tr").hide();
    			$("#xhms1").html("");
    		}else if(xhmsValue=="1"){//每周
    			$("#meizhou").show();
    			$("#meiyue").hide();
    			$("#meinian").hide();
    			nui.get("month_type").setValue("");
    			nui.get("year_type_month").setValue("");
    			nui.get("year_type_day").setValue("");
    			$("#xhms1tr").show();
    			$("#xhms1").html(xhmsData[xhmsValue].text+"：");
    		}else if(xhmsValue=="2"){//每月
    			$("#meizhou").hide();
    			$("#meiyue").show();
    			$("#meinian").hide();
    			nui.get("week_type").setValue("");
    			nui.get("year_type_month").setValue("");
    			nui.get("year_type_day").setValue("");
    			$("#xhms1tr").show();
    			$("#xhms1").html(xhmsData[xhmsValue].text+"：");
    		}else if(xhmsValue=="3"){//每年
    			$("#meizhou").hide();
    			$("#meiyue").hide();
    			$("#meinian").show();
    			nui.get("week_type").setValue("");
    			nui.get("month_type").setValue("");
    			$("#xhms1tr").show();
    			$("#xhms1").html(xhmsData[xhmsValue].text+"：");
    		}
    	}
    	//循环模式下按年执行选择月份时执行
    	function yearTypeMonthChanged(){
    		var yearTypeMonthValue = nui.get("year_type_month").getValue();
    		if(yearTypeMonthValue==""){
    			nui.get("year_type_day").hide();
    		}else{
    			nui.get("year_type_day").setData(monthTypeData);
    			nui.get("year_type_day").show();
    		}
    	}
    	
    	//-----------------------------------------------------------------按钮事件方法---------------------------------------------------------------------------//
    	//保存
    	function saveSchedule(){
    	debugger;
    		var re = /^[0-9]+.?[0-9]*$/;
    		var zengliang = nui.get("zengliang").getValue();
    		 if(!re.test(zengliang)){
    		 	nui.alert("请输入数字1~59");
				nui.get("zengliang").setValue("");
				nui.get("zengliang").select();
				return ;
    		 }
    		if(parseInt(zengliang)>=60||parseInt(zengliang)<=0){
    			nui.alert("输入错误,请输入1~59");
				nui.get("zengliang").setValue("");
				nui.get("zengliang").select();
				return ;
    		}
    		
    		var taskId = nui.get("taskId").getValue();
    		if(taskId==""){
    			nui.alert("任务主键丢失，无法保存，请关闭页面后重新操作","系统提示");
    			return ;
    		}
    		
    		if(!timeValueChanged()){
    			return;
    		}
    		buildCron();
    		var pageType = nui.get("pageType").value;
    		var url = "com.cjhxfund.ats.taskTimer.CommTimer.addTimer.biz.ext";
    		var json = "";
    		var form = new nui.Form("#dataform1");
    		var data = form.getData(false,true);
    		
    		if(pageType=="add"){
    			//var data = {taskId:taskId,checkStyle:checkStyle};
    			json = nui.encode(data);
    		}else if(pageType=="edit"){
    			url = "com.cjhxfund.ats.taskTimer.CommTimer.updateTimer.biz.ext";
    			//var data = {taskId:taskId,timerId:timerId,checkStyle:checkStyle};
    			json = nui.encode(data);
    		}else{
    			nui.alert("获取页面操作类型失败，请联系系统管理员处理","系统提示");
    			return ;
    		}
    		$.ajax({
				url:url,type:'POST',data:json,cache:false,async:false,contentType:'text/json',
	          	success:function(text){
	            	var returnJson = nui.decode(text);
	            	if(returnJson.exception == null){
	              		CloseWindow("saveSuccess");
	            	}else{
	              		nui.alert("保存失败", "系统提示", function(action){});
              		}
				}
			});
    	}
    	
    	//取消
    	function onCancel(){
    		nui.confirm("取消将不会保存数据，确定要取消吗？","系统提示",function(action){
    			if(action=="ok"){
    				CloseWindow("cancel");
    			}
    		});
    	}
    	//关闭窗口
		var isSaved = true;
		function CloseWindow(action){
			if(action=="close"){
				nui.confirm("关闭页面将不会保存数据，确定要关闭吗？", "提示", function(action){
					if(action == "ok" ){
						window.CloseOwnerWindow("close");
					}
				});
				return false;
			}else{
				if(isSaved) action="success";// 如果已保存过，强制设置
				if(window.CloseOwnerWindow) 
		        return window.CloseOwnerWindow(action);
				else return window.close();
			}
		}
    	
    	
    	
    	//-----------------------------------------------------------------表达式封装---------------------------------------------------------------------------//
    	//封装表达式（条件）
    	function buildCron(){
    		
    		var xhmsValue = nui.get("xhms").getValue();
    		if(xhmsValue==0){
    			nui.get("cronExpression").setValue(getTaskTime().toText());
    		}else if(xhmsValue==1){
    			var weekTypeValue = nui.get("week_type").getValue();
    			if(weekTypeValue==""){
    				nui.alert("请选择每周的执行时间","系统提示");
    				return;
    			}
    			var schedule = getTaskTime();
    			schedule.week.parse(weekTypeValue);
    			nui.get("cronExpression").setValue(schedule.toText());
    		}else if(xhmsValue==2){
    			var monthTypeValue = nui.get("month_type").getValue();
    			if(monthTypeValue==""){
    				nui.alert("请选择每月的执行时间","系统提示");
    				return;
    			}
    			var schedule = getTaskTime();
    			schedule.day.parse(monthTypeValue);
    			nui.get("cronExpression").setValue(schedule.toText());
    		}else if(xhmsValue==3){
    			var yearTypeMonthValue = nui.get("year_type_month").getValue();
    			var yearTypeDayValue = nui.get("year_type_day").getValue();
    			if(yearTypeMonthValue==""){
    				nui.alert("请选择月份","系统提示");
    				return;
    			}else if(yearTypeDayValue==""){
    				nui.alert("请选择日期","系统提示");
    				return;
    			}
    			var schedule = getTaskTime();
    			schedule.month.parse(yearTypeMonthValue);
    			schedule.day.parse(yearTypeDayValue);
    			nui.get("cronExpression").setValue(schedule.toText());
    		}else{
    			nui.alert("获取循环模式时出错，请联系系统管理员处理","系统提示");
    		}
    	}
    	//封装表达式（时间）
    	function getTaskTime(){
    		
    		var cfms = nui.get("triggerType").getValue();
    		if(cfms==0){
    			var time = nui.get("triggerTime").getFormValue()+":00";
    			nui.get("vcBegin").setValue(time);
	    		var arr = time.split(":");
	    		for(var i=0;i<arr.length;i++){
					arr[i] = parseInt(arr[i], 10);
				}
				arr.reverse();
				var cron = arr.join(" ") + " * * ? *";
				return new Schedule(cron);
    		}else if(cfms==1){
    			return new Schedule(getTasjkTimeSJJG());
    		}
    		
    	}
    	
    	//封装时间间隔表达式
    	function getTasjkTimeSJJG(){
    		//获取时间间隔
    		var time = nui.get("triggerTime").getFormValue();
			var time1 = nui.get("triggerTime1").getFormValue();
			nui.get("vcBegin").setValue(time);
			nui.get("vcEnd").setValue(time1);
			//获取增量（每隔多少分钟执行一次）
			var zengliang = nui.get("zengliang").getValue();
			if(zengliang==""){
				zengliang = "1";
			}else if(zengliang>=60){
				zengling = 59;
			}
			//拆分
			var arr = time.split(":");
			var arr1 = time1.split(":");
			if(arr[0].length>1 && arr[0]<10){
				arr[0] = arr[0].substring(1,2);
			}
			if(arr[1].length>1 && arr[1]<10){
				arr[1] = arr[1].substring(1,2);
			}
			if(arr1[0].length>1 && arr1[0]<10){
				arr1[0] = arr1[0].substring(1,2);
			}
			if(arr1[1].length>1 && arr1[1]<10){
				arr1[1] = arr1[1].substring(1,2);
			}
			//赋值
			var h = arr[0];
			var h1 = arr1[0];
			var m = arr[1];
			var m1 = arr1[1];
			//定义表达式变量
			var cron = "";
			//cron = "0 0-59/"+zengliang;
			if(m<m1){
				cron = "0 "+m+"-"+m1+"/"+zengliang;
			}else if(m==m1){
				cron = "0 "+m+"/"+zengliang;
			}else{
				cron = "0 "+m1+"-"+m+"/"+zengliang;
			}
			
			if(h<h1){
				var hStr =  (parseInt(h1)-1).toString();
				cron = cron +" "+h+"-"+hStr+" * * ? *";
			}else if(h==h1){
				cron = cron +" "+h+" * * ? *";
			}else{
				var hStr =  (parseInt(h1)-1).toString();
				cron = cron +" "+h+"-"+hStr+" * * ? *";
			}
			return cron;
    	}
    	
    	
    	//-----------------------------------------------------------------表达式解析---------------------------------------------------------------------------//
    	//解析表达式
    	function initTaskSchedule(){
    		var cron = nui.get("cronExpression").getValue();
    		if(cron!=null){
    			var schedule = new Schedule(cron);
    			var day = schedule.day.toText();
				var month = schedule.month.toText();
				var week = schedule.week.toText();
				//开始解析月份
				if(day=="*" && month=="*"&&week=="?"){
					nui.get("xhms").setValue(0);
				}
    			if(day=="?" && week!="*" && month=="*"){
					if(week.indexOf("#")>0||week.indexOf("L")>0){
						nui.get("xhms").setValue("2");
					}else{
						//initWeek(schedule);
						nui.get("xhms").setValue("1");
						nui.get("week_type").setValue(week);
					}
				}
				if(day!="*" && week=="?" && month=="*"){
					//initMonth(schedule);
					nui.get("xhms").setValue("2");
					nui.get("month_type").setValue(day);
				}
				if(month!="*"){
					//initYear(schedule);
					nui.get("xhms").setValue("3");
					nui.get("year_type_month").setValue(month);
					nui.get("year_type_day").setValue(day);
					yearTypeMonthChanged();
				}
    		}
    	}
    	//日历周期模式下的表达式解析
    	function initRlzqcf(cron){
    		var schedule = new Schedule(cron);
    		var temphour = schedule.hour.toText();
    		var tempminute = schedule.minute.toText();
    		var shijian = temphour+":"+tempminute+":00";
    		var triggerTime = nui.get("triggerTime");
    		triggerTime.setValue(shijian);
    	}
    	<%--
    	//时间间隔模式下的表达式解析
    	function initSjjg(cron){
    		var schedule = new Schedule(cron);
    		var temphour = schedule.hour.toText();
    		var tempminute = schedule.minute.toText();
    		var triggerTime = nui.get("triggerTime");
			var triggerTime1 = nui.get("triggerTime1");
			var zengliang = nui.get("zengliang");
			var time1="";
			var time2="";
			var tempzl="";
    		if(temphour.indexOf("_")>-1){
    			if(tempminute.indexOf("_")>-1){
    				if(tempminute.indexOf("/")>-1){
    					time1 = temphour.split("_")[0]+":"+tempminute.split("_")[0]+":00";
    					time2 = temphour.split("_")[1]+":"+tempminute.split("_")[1].split("/")[0]+":00";
    					tempzl = tempminute.split("_")[1].split("/")[1];
    				}
    			}else{
    				time1 = temphour.split("_")[0]+":"+tempminute.split("_")[0]+":00";
    				time2 = temphour.split("_")[1]+":"+tempminute.split("/")[0]+":00";
    				tempzl = tempminute.split("/")[1];
    			}
    		}else{
    			if(tempminute.indexOf("_")>-1){
    				if(tempminute.indexOf("/")>-1){
    					time1 = temphour+":"+tempminute.split("_")[0]+":00";
    					time2 = temphour+":"+tempminute.split("_")[1].split("/")[0]+":00";
    					tempzl = tempminute.split("_")[1].split("/")[1];
    				}
    			}else{
					time1 = temphour+":"+tempminute+":00";
    				time2 = temphour+":"+tempminute+":00";
				}
    		}
    		triggerTime.setValue(time1);
			triggerTime1.setValue(time2);
			zengliang.setValue(tempzl);
    	}
    	--%>
    	//-----------------------------------------------------------------表单校验---------------------------------------------------------------------------//
    	function timeValueChanged(){
    		var falg = false;
    		var cfms = nui.get("triggerType").getValue();
    		if(cfms==0){
    			falg = true;
    		}else if(cfms==1){
    			var time = nui.get("triggerTime").getValue();
	    		var time1 = nui.get("triggerTime1").getValue();
	    		if(time>=time1){
	    			falg = false;
	    			nui.alert("开始时间必须小于结束时间","系统提示");
	    		}else{
	    			falg = true;
	    		}
    		}
    		return falg ;
    	}
    	
    	
    	
    </script>
</html>