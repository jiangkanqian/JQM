<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<script type="text/javascript">
	
	//查询--所有业务通用
	function search(grid_search, form_id) {
	    var form = new nui.Form(form_id);
	    form.validate();
		if(form.isValid()==false) return;
	    var json = form.getData(false,false);
	    grid_search.load(json,function(){},function (jqXHR, textStatus, errorThrown) {
                //nui.alert(jqXHR.responseText, "系统提示");
                nui.alert("数据加载失败，错误编码：" + jqXHR.errorCode,"系统提示");
            });//grid查询
             
	}
	
	
	//保存--所有业务通用
	function saveData(save_grid, url, form_id){
		var json = new nui.Form(form_id).getData(false,false);
        save_grid.loading("保存中，请稍后......");
        $.ajax({
            url: url,
            data: json,
            type: "post",
            success: function (text) {
                search(save_grid, form_id);
            },
            error: function (jqXHR, textStatus, errorThrown) {
                nui.alert(jqXHR.responseText, "系统提示");
            }
        });
	}
	
	
	//行双击时弹出页面展示该指令/建议详细信息--所有业务通用
    function rowdblclickFun(jspUrl, title, width, height, e, grid) {
        var row = e.record;//行对象值
        if (row) {
            nui.open({
                url: "<%=request.getContextPath()%>/ProductProcess/zhxxcx/"+jspUrl+"?queryUserType=<%=request.getParameter("queryUserType")%>",
                title: title,
                width: width,
                height: height,
                onload: function () {
                    var iframe = this.getIFrameEl();
                    var data = {record:{rowRecord:row,rowType:"real"}};//真实数据
                    if(row.XH=="8"){
                        data = {record:{rowRecord:row,rowType:"unreal"}};//并非数据中的真实数据,这里之前以为是假数据，现在是数据库查的。unreal当成标记
                    }
                    //直接从页面获取，不用去后台获取
                    iframe.contentWindow.setFormData(data);
                },
                ondestroy: function (action) {//弹出页面关闭前
		        }
            });
        }
    }
    
    
    <%-- 导出数据开始...(所有业务通用) --%>
	//启用“导出”按钮
	var enableExportId = "";//启用“导出”按钮ID
	function enableExportFun(){
		nui.get(enableExportId).enable();
		enableExportId = "";
	}
	//导出综合查询信息
	function exportSubmit(exportId, form_id, sheetName,exportType){
		var msg = "确定要导出吗？";
		nui.confirm(msg,"系统提示",function(action){
			if(action=="ok"){
				var form = new nui.Form("#"+form_id);
				var index=-1;//标志数据是否超过最大数目
			    form.validate();
				if(form.isValid()==false) return;
				nui.get(exportId).disable();//禁用“导出”按钮
				//在form表单中新增元素
				formAppendChild(form_id, "INPUT", "hidden", "paramObject/isExport", "yes");
				formAppendChild(form_id, "INPUT", "hidden", "paramObject/sheetName", sheetName);
				var formSubmit = document.getElementById(form_id);
				/**
				* 头寸查询信息-TCXXCX
				* 综合信息查询-ZHXXCX
				* 现金流水记录-SGTZXJL
				* 头寸管理信息-TCYCCX
				* 头寸管理明细-XJL_DETAIL
				**/
				if(exportType=="TCXXCX"){//头寸查询信息
					formSubmit.action = "com.cjhxfund.jy.ProductProcess.TcxxcxExport.flow";
				}else if(exportType=="SGTZXJL"||exportType=="TCYCCX"){// 现金流水记录， 头寸管理信息
					formSubmit.action = "com.cjhxfund.jy.ProductProcess.cashFlowExport.flow";
				}else if(exportType=="XJL_DETAIL"){//头寸管理明细
					formSubmit.action = "com.cjhxfund.jy.ProductProcess.cashFlowDetailExport.flow"; 
				}else{//综合信息查询-ZHXXCX
					formSubmit.action = "com.cjhxfund.jy.ProductProcess.ZhxxcxExport.flow";
		 			var data=form.getData();
		 			data["paramObject/isExport"]="yes";
		 			data["paramObject/sheetName"]=sheetName;
					nui.ajax({
		                url: "com.cjhxfund.jy.ProductProcess.ZhxxcxUtilBiz.ZhxxcxExport.biz.ext",
		                data: data,
		                type: "post",
		                async: false,
		                success: function (text) {
			                if(text){
			                	var errorCode=text.errorCode;
			                	if(0==errorCode){
			                		formAppendChild(form_id, "INPUT", "hidden", "pageUrl", text.pageUrl);
			                	}else{
			                		nui.alert("对不起，目前系统允许导出的最大数据为65000条，建议筛选后导出。");
			                		index++;
			                	}
			                }
		                },
		                error: function (jqXHR, textStatus, errorThrown) {
		                    nui.alert('导出失败，错误代码：' +jqXHR.status + ',' + errorThrown);
		                    return false;
		                }
		            });
				}
		        enableExportId = exportId;
		        setTimeout("enableExportFun()",60000);//启用“导出”按钮
				if(index==0)return ;
		        formSubmit.submit();
			}
		});
	}
    <%-- 导出数据结束!!!(批量) --%>
    //导出
	function exportSubmit_pl(exportId, form_id,fundCodeArr,fundNameArr,busDateArr){
				var form = new nui.Form("#"+form_id);
			    form.validate();
				if(form.isValid()==false) return;
				
				nui.get(exportId).disable();//禁用“导出”按钮
				//在form表单中新增元素
				formAppendChild(form_id, "INPUT", "hidden", "paramObject/isExport", "yes");
				formAppendChild(form_id, "INPUT", "hidden", "paramObject/fundCodeArr", fundCodeArr);
				formAppendChild(form_id, "INPUT", "hidden", "paramObject/fundNameArr", fundNameArr);
				formAppendChild(form_id, "INPUT", "hidden", "paramObject/busDateArr", busDateArr);
				var formSubmit = document.getElementById(form_id);
				formSubmit.action = "com.cjhxfund.jy.ProductProcess.momplExport.flow";
		        formSubmit.submit();
		        enableExportId = exportId;
		        setTimeout("enableExportFun()",60000);//启用“导出”按钮
	}
    <%-- 导出数据结束!!!(批量) --%>
    
    //自动隐藏显示无业务列
	function hideEmptyColumn(grid_id,checked){
		var grid = nui.get(grid_id);
		var cols = grid.columns;//获取列对象
		var rows = grid.data;//获取行对象
		var lengthCols = cols.length;//总列数(多列合并列之后记为一列)
		var lengthRows = rows.length;//总行数
		if(rows.length <= 0 ){
			return false;
		}
		//隐藏无业务列
		if(checked){
			//从1开始循环(忽略掉序号列)
			for(var i=1;i<lengthCols;i++){
				//记录每一个非合并单元格的无数据列总行数
				var count=0;
				//获取列名的key值
				col = cols[i].field;
				//判断是否为合并列
				var isMerge = grid.columns[i].columns;
				if(isMerge==undefined){
					//行遍历，并记录此列中有多少行数据为空
					for(var j=0;j<lengthRows;j++){
						if(rows[j][cols[i].field]==null||rows[j][cols[i].field]==""||rows[j][cols[i].field]=="0.00"){
							count++;
						}
					}
					//隐藏无数据列(非合并单元格)
					if(count==lengthRows){
						grid.hideColumn(cols[i]);
					}
				}else{
					//合并单元格，再次双重遍历合并单元格的列行
					var mergeLength = grid.columns[i].columns.length;
					for(var ii=0;ii<mergeLength;ii++){
						//记录每个合并单元格的无数据列总行数
						var mergeCount = 0;
						//获取列名的key值
						col = cols[i].columns[ii].field;
						//行遍历，并记录此列中有多少行数据为空
						for(var jj=0;jj<lengthRows;jj++){
							if(rows[jj][col]==null||rows[jj][col]==""||rows[jj][col]=="0.00"){
								mergeCount++;
							}
						}
						//隐藏无数据列(合并单元格)
						if(mergeCount==lengthRows){
							cols[i].columns[ii].visible=false;
						}
					}
				}
			}
		}else{
			//显示所有列
			for(var i=1;i<lengthCols;i++){
				//获取列是否为合并列
				var isMerge = grid.columns[i].columns;
				if(isMerge==undefined){
					//将隐藏列显示(针对非合并列)
					if(cols[i].visible==false){
						grid.showColumn(cols[i]);
					}
				}else{
					//合并单元格，遍历合并单元格的列行
					var mergeLength = grid.columns[i].columns.length;
					for(var ii=0;ii<mergeLength;ii++){
						//将隐藏列显示(针对合并列)
						if(cols[i].columns[ii].visible==false){
							grid.showColumn(cols[i].columns[ii]);
						}
					}
				}
			}
		}
	}
	/*
		描述：流水查询，时间判断
		逻辑：1、起始日期不能大于截止日期！；2、仅能查询当天或历史的交易流水！
	*
	*/
	
	//时间判断
	function lDateBeginFun(lDateBegin,lDateEnd){
		var lDateBegin_CPYHJ = DateUtil.toNumStr(nui.get(lDateBegin).getValue());
		var lDateEnd_CPYHJ = DateUtil.toNumStr(nui.get(lDateEnd).getValue());
		if(null !=lDateEnd_CPYHJ){
			if(null !=lDateBegin_CPYHJ){
				if(lDateBegin_CPYHJ > lDateEnd_CPYHJ){
					nui.alert("起始日期不能大于截止日期！","提示");
					//日期校验
					nui.get(lDateBegin).setValue(businDay);
					nui.get(lDateEnd).setValue(businDay);
					return;
				}
			/* if(lDateBegin_CPYHJ > businDay || lDateEnd_CPYHJ > businDay){
				nui.alert("仅能查询当天或历史的交易流水！","提示");
				nui.get(lDateEnd).setValue(preDate);
				return;
			}
			if(businDay == lDateEnd_CPYHJ && businDay != lDateBegin_CPYHJ){
				nui.alert("仅能查询当天或历史的交易流水！","提示");
				//查询历史数据时，如果日期包含了当天，则不允许查询，设置默认值为昨天
				nui.get(lDateEnd).setValue(preDate);
				return;
			} */
				if(lDateBegin_CPYHJ < lDateEnd_CPYHJ){
					if(lDateEnd_CPYHJ == businDay){
						if(lDateBegin_CPYHJ > preDate){
							nui.get(lDateBegin).setValue(preDate);
							nui.get(lDateEnd).setValue(preDate);
							return;
						}else{
							nui.alert("仅能查询当天或历史的交易流水！","提示");
							nui.get(lDateEnd).setValue(preDate);
							return;
						}
					}
				}
			}else{
				if(lDateEnd_CPYHJ == businDay){
						if(lDateBegin_CPYHJ > preDate){
							nui.get(lDateBegin).setValue(preDate);
							nui.get(lDateEnd).setValue(preDate);
							return;
						}else{
							nui.alert("仅能查询当天或历史的交易流水！","提示");
							nui.get(lDateEnd).setValue(preDate);
							return;
						}
				}
			}
		}
	}
	
	//时间判断
	function lDateEndFun(lDateBegin,lDateEnd){
		var lDateBegin_CPYHJ = DateUtil.toNumStr(nui.get(lDateBegin).getValue());
		var lDateEnd_CPYHJ = DateUtil.toNumStr(nui.get(lDateEnd).getValue());
		if(null !=lDateBegin_CPYHJ){
			if(lDateEnd_CPYHJ < lDateBegin_CPYHJ){
				//起始时间不能大于截止时间
				nui.get(lDateBegin).setValue(lDateEnd_CPYHJ);
			}
			if(lDateBegin_CPYHJ < lDateEnd_CPYHJ){
				if(lDateBegin_CPYHJ > preDate){
					nui.get(lDateBegin).setValue(preDate);
					nui.get(lDateEnd).setValue(preDate);
					nui.alert("仅能查询当天或历史的交易流水！","提示");
					return;
				}else{
					if((lDateEnd_CPYHJ >= businDay) || (preDate < lDateEnd_CPYHJ && lDateEnd_CPYHJ < businDay)){
						nui.get(lDateEnd).setValue(preDate);
						nui.alert("仅能查询当天或历史的交易流水！","提示");
						return;
					}
				}
			}
		}else{
			if(lDateEnd_CPYHJ = businDay){
				nui.alert("仅能查询当天或历史的交易流水！","提示");
				return;
			}
		}
	}
</script>
