<%@page import="commonj.sdo.DataObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" %>

<%@ taglib uri="http://eos.primeton.com/tags/logic" prefix="l"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/common/js/commscripts.jsp" %>

<!-- 
  - Author(s): 石浩
  - Date: 2016-08-23 16:33:01
  - Description:
-->
<head>
<title>新债复核</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    
    <style type="text/css">
      .td1{
        border-right: 1px solid #D3D3D3;
        border-left: 1px solid #D3D3D3;
      }
      .td2{
        border-right: 1px solid #D3D3D3;
      }
      .asLabel .mini-textbox-input{
        color: red;
        background:none;cursor:default;
      }
      .asLabel_gray .mini-textbox-input{
         color: black;
         background:none;cursor:default;
      }
      
      .p{
           border-bottom: 1px solid #D3D3D3;     
        }
        P{
          margin: 0px;padding: 0px;
        }
        
    </style>
</head>

<%
    Object rootObj= com.eos.web.taglib.util.XpathUtil.getDataContextRoot("request", pageContext); 
    String pid = (String)com.eos.web.taglib.util.XpathUtil.getObjectByXpath(rootObj,"processInstID");
    String workItemID =(String)com.eos.web.taglib.util.XpathUtil.getObjectByXpath(rootObj,"workItemID");
    String bizId = (String)com.eos.web.taglib.util.XpathUtil.getObjectByXpath(rootObj,"bizId");
    String processType = (String)com.eos.web.taglib.util.XpathUtil.getObjectByXpath(rootObj,"processType");
    String stockInvestNo = (String)com.eos.web.taglib.util.XpathUtil.getObjectByXpath(rootObj,"stockInvestNo");
 %>
<body style="width:100%;height:100%;margin:0px;">

   <div id="tabs" class="nui-tabs" height="100%">
   		<div title="基本信息">
		  	<div id="dataform1" style="padding-top:5px;">
              	<input class="nui-hidden" name="debtIssue.lOperatorNo"  />
              
	            <!-- hidden域 -->
	            <!-- 业务子表参数 -->
	            <input class="nui-hidden" id="lStockIssueId"  name="debtIssue.lStockIssueId" />
	            <input class="nui-hidden" id="lBizId" name="debtIssue.lBizId"/>
	            <input class="nui-hidden" id="cStatus" name="debtIssue.cStatus"/>
	            <input class="nui-hidden" id="cSource" name="debtIssue.cSource"/>
	            <input class="nui-hidden" id="lStockInvestNo" name="debtIssue.lStockInvestNo"/>
	            <input class="nui-hidden" id="lValidStatus" name="debtIssue.lValidStatus"/>
	            <input class="nui-hidden" id="vcInterCode" name="debtIssue.vcInterCode"/>
	            <input class="nui-hidden" id="lDate" name="debtIssue.lDate"/>
	            <input class="nui-hidden" id="cMarketNo" name="debtIssue.cMarketNo"/>
	            <input class="nui-hidden" id="lRaiseInstFile" name="debtIssue.lRaiseInstFile"/>
 				<input class="nui-hidden" id="lRateReportFile" name="debtIssue.lRateReportFile"/>
				<input class="nui-hidden" id="lBondIssueFile" name="debtIssue.lBondIssueFile"/>
	            <table style="width:100%;height:100%;table-layout:fixed;" class="nui-form-table">
	                <tr>
	                    <td class="form_label" width="20%" align="right">
	                        	<span style="color:red">*</span>&nbsp;登记托管机构:
	                    </td>
	                    <td colspan="1" width="30%">
								<input class="nui-dictcombobox"  required="true" 
	                        dictTypeId="CF_JY_DJTGCS" valueField="dictID" textField="dictName"
	                          name="debtIssue.vcPaymentPlace" 
	                         id="vcPaymentPlace" width="80%"  onvaluechanged="onMarketNoChanged"/>
	                    </td>
	                    <td class="form_label" align="right" width="15%">
	                        	利率类型:
	                    </td>
	                    <td colspan="1" width="30%">
	                    	 <input class="nui-dictcombobox" dictTypeId="rateType" width="80%" id="cInterestType" name="debtIssue.cInterestType"  />
	                    </td>
	                </tr>
	                <tr>
	                  <td class="form_label" align="right">
	                       	 <span style="color:red">*</span>&nbsp;债券类别:
	                  </td>
	                  <td colspan="1">
	                     <input style="width: 80%;" id="vcStockType" name="debtIssue.vcStockType" class="mini-treeselect"  multiSelect="false" 
										        textField="text" valueField="id" parentField="pid" checkRecursive="false" required="true" 
										        url="com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.loadStockType.biz.ext"  onbeforenodeselect="beforenodeselect"
										        showFolderCheckBox="true"   expandOnLoad="true" showTreeIcon="false" showClose="true"
										        popupWidth="300" oncloseclick="onCloseClickValueEmpty"  onvaluechanged="cheangedVcStockType"/>
	                  </td>
	                  <td class="form_label" width="25%" align="right">
	                        	息票品种:
	                  </td>
	                  <td colspan="1" width="25%">
	                   	<input class="nui-dictcombobox" dictTypeId="payInterestType" width="80%" id="cPayInterestType" name="debtIssue.cPayInterestType" onvaluechanged="changeEnPayInteval" />
	                  </td>
	                </tr>
	                <tr>
	                     <td class="form_label" align="right">
	                       	 <span style="color:red">*</span>&nbsp;债券代码:
	                    </td>
	                    <td colspan="1">
	                    		<input class="nui-textbox" required="true" id="vcStockCode" onblur="checkCode(this)" width="80%" name="debtIssue.vcStockCode" maxlength="20"/>
	                    </td>
	                    <td class="form_label" align="right">
	                        	付息频率(次/年):
	                    </td>
	                    <td colspan="1">
	                        <!-- <input class="nui-textbox"  id="enPayInteval"  width="80%" name="debtIssue.enPayInteval"/> -->
	                        <input class="nui-dictcombobox" dictTypeId="ATS_CF_JY_FREQUENCY" onblur="checkFXPL(this)" allowInput="true" width="80%" id="enPayInteval" name="debtIssue.enPayInteval" onvaluechanged="checkCPayInterestType"/>
	                    </td>
	                </tr>
	                <tr>
	                    <td class="form_label" align="right">
	                       	 债券简称:
	                    </td>
	                    <td colspan="1">
	                    		<input class="nui-textbox" id="vcStockName"  width="80%" name="debtIssue.vcStockName"/>
	                    </td>
	                    <td class="form_label requiredLable" align="right">
	                        	<label style="color:red">*</label>&nbsp;债券评级:
	                    </td>
	                    <td colspan="1">
	                        <input class="nui-dictcombobox" dictTypeId="creditRating" required="true"  id="cBondAppraise"  width="80%" name="debtIssue.cBondAppraise"/>
	                    </td>
	                </tr>
	                <tr>
	                  	<td class="form_label" align="right">
	                        	<span style="color:red">*</span>&nbsp;债券全称:
	                    </td>
	                    <td colspan="1">
	                    	<input class="nui-textbox" id="vcStockNameFull" required="true" width="80%" name="debtIssue.vcStockNameFull"  />
	                    </td>
	                    <td class="form_label requiredLable" align="right">
	                       	<label style="color:red">*</label>&nbsp;债券评级机构:
	                    </td>
	                    <td colspan="1">
	                        <input class="nui-dictcombobox" dictTypeId="outRatingOrgan" required="true"  width="80%" id="vcBondAppraiseOrgan" name="debtIssue.vcBondAppraiseOrgan"/>
	                    </td>
	                </tr>
	                <tr id="tr1">
	                     <td class="form_label" align="right">
	                        	<span style="color:red">*</span>&nbsp;发行规模(亿):
	                    </td>
	                    <td colspan="1">
	                        <input class="nui-textbox" name="debtIssue.enIssueBalance" required="true" onblur="check(this)" id="enIssueBalance" width="80%"  />
	                    </td>
	                     <td class="form_label" align="right">
	                        	<span style="color:red">*</span>&nbsp;发行期限(年):
	                    </td>
	                    <td colspan="1">
	                        <input class="nui-textbox"  required="true" name="debtIssue.enExistLimite" onblur="check(this)" id="enExistLimite"  width="80%" />
	                    </td>
	                </tr>
	                <tr id="morStockNameAndCode">
	                    <td class="form_label  lableReq" align="right">
	                          <label style="color:red">*</label>&nbsp;股票名称:
	                    </td>
	                    <td colspan="1">
	                        <input class="nui-textbox" name="debtIssue.vcMortStockName" id="vcMortStockName" width="80%" />
	                    </td>	                    
	                    <td class="form_label  lableReq" align="right">
	                          <label style="color:red">*</label>&nbsp;股票抵押数量(万股):
	                    </td>
	                    <td colspan="1">
	                        <input class="nui-textbox" onblur="check(this)" vtype="float" name="debtIssue.vcMortStockAmount" id="vcMortStockAmount" width="80%" />
	                    </td>
	                </tr>
	                <tr id="morStockAmount">
	                    <td class="form_label   lableReq" align="right">
	                         <label style="color:red">*</label>&nbsp; 股票代码:
	                    </td>
	                    <td colspan="1">
	                        <input class="nui-textbox" name="debtIssue.vcMortStockCode" id="vcMortStockCode" width="80%" />
	                    </td>	                    
	                </tr>
	                 <tr id="tr1">
	                   <td class="form_label" align="right">
	                        	发行规模描述:
	                    </td>
	                    <td colspan="3">
	                    	<input class="nui-textarea" id="vcExistLimiteDesc" name="debtIssue.vcExistLimiteDesc" width="92%"/>
	                    </td>
	                </tr>
	                 
	                
	                <tr>
	                    <td class="form_label" align="right">
	                       	 公告日期:
	                    </td>
	                    <td colspan="1"> 
	                        <input class="nui-datepicker"  name="lIssuePostDate" id="lIssuePostDate" style="width: 80%;"  />
	                    </td>
	                    <td class="form_label" align="right">
	                         <span style="color:red">*</span>&nbsp;主体简称:
	                    </td>
	                    <td colspan="1">
	                    	  <input class="nui-hidden"  id="lIssuerId"  width="80%" name="debtIssue.lIssuerId"/>
	                    	  <input id="lookup2" style="width: 80%;" name="debtIssue.lIssuerId" class="mini-lookup"  
						        textField="vcIssueName" valueField="lIssuerId" popupWidth="auto"  
						        popup="#gridPanel" data="data"  onvalidation="onIssuerId" grid="#datagrid1" multiSelect="false" onclick="onClearClick();onSearchClick()" />
						     
						     <div id="gridPanel" class="mini-panel" title="header" iconCls="icon-add" style="width:450px;height:250px;" 
						        showToolbar="true" showCloseButton="true" showHeader="false" bodyStyle="padding:0" borderStyle="border:0" >
						        <div property="toolbar" style="padding:5px;padding-left:8px;text-align:center;">   
						            <div style="float:left;padding-bottom:2px;">
						                <span>发行主体：</span>                
						                <input id="keyText" class="mini-textbox" style="width:160px;" onenter="onSearchClick"/>
						                <a class="mini-button" onclick="onSearchClick">查询</a>
						                <a class="mini-button" id="add" iconCls='icon-add' onclick="onAddClick">添加</a>
						            </div>
						            <div style="float:right;padding-bottom:2px;margin-right:14px;">
						            </div>
						            <div style="clear:both;"></div>
						        </div>
						        <div id="datagrid1"   class="mini-datagrid" style="width:100%;height:100%;" 
						            borderStyle="border:0" showPageSize="false" showPageIndex="false"
						            url="com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.loadIssueInfo.biz.ext" onRowdblclick="dbClick2">
						            <div property="columns" >
						                <div field="vcIssueName" width="50"  headerAlign="center" allowSort="true">简称</div>
						                <div field="vcIssueNameFull" width="70" headerAlign="center" allowSort="true">全称</div>
						            </div>
						        </div>  
						      </div>
					     </td>
	                </tr>
	                
	                 <tr>
	                    <td class="form_label" align="right">
	                       	 发行日期:
	                    </td>
	                    <td colspan="1"> 
	                        <input class="nui-datepicker" name="lIssueBeginDate" id="lIssueBeginDate" style="width: 80%;"  />
	                    </td>
	                    <td class="form_label" align="right">
	                         <span style="color:red">*</span>&nbsp;主体全称:
	                    </td>
	                    <td colspan="1">
	                    	 <input class="nui-hidden"  id="vcIssuerName" readonly="true"  inputStyle="background-color:#f0f0f0;" width="80%" name="debtIssue.vcIssuerName"/>
	                    	 <input class="nui-textbox" required="true" readonly="true"  inputStyle="background-color:#f0f0f0;"  id="vcIssuerNameFull"  width="80%" name="debtIssue.vcIssuerNameFull"/>
	                    </td>
	                </tr>
	                
	                <tr>
	                 	<td class="form_label" align="right">
	                       	 上市日期:
	                    </td>
	                    <td colspan="1"> 
	                        <input class="nui-datepicker" name="lPublishDate" id="lPublishDate" style="width: 80%;"  />
	                    </td>
	                     <td class="form_label requiredLable" align="right">
	                        <label style="color:red">*</label>&nbsp;主体评级:
	                    </td>
	                    <td colspan="1">
	                    	<input required="true" class="nui-dictcombobox"  dictTypeId="issuerRating" width="80%" id="cIssueAppraise" name="debtIssue.cIssueAppraise" showNullItem="false"/>
	                    </td>
	                 </tr>
	                 
	                 <tr>
	                    <td class="form_label" align="right">
	                       	 起息日期:
	                    </td>
	                    <td colspan="1"> 
	                        <input class="nui-datepicker" name="lBegincalDate" id="lBegincalDate" style="width: 80%;"  />
	                    </td>
	                    <td class="form_label" align="right">
	                                                                                    主体类型:
	                    </td>
	                    <td colspan="1">
	                    	<input  class="nui-dictcombobox"  dictTypeId="ATS_FM_ISSUE_PROPERTY" width="80%" id="vcIssueProperty" value="" name="debtIssue.vcIssueProperty" showNullItem="false"/>
	                    </td>
	                </tr>
	                
	                <tr>
	                	 <td class="form_label" align="right">
	                       	 到期日期:
	                    </td>
	                    <td colspan="1"> 
	                        <input class="nui-datepicker" name="lEndincalDate" id="lEndincalDate" style="width: 80%;"  />
	                    </td>
	                    <td class="form_label" align="right">
	                                                                                    主体评级机构:
	                    </td>
	                    <td colspan="1">
	                        <input class="nui-dictcombobox" dictTypeId="outRatingOrgan" width="80%" id="vcIssueAppraiseOrgan" name="debtIssue.vcIssueAppraiseOrgan" showNullItem="false"/>
	                    </td>
	                </tr>
	                
	                <tr>
	                     <td class="form_label" align="right">
	                       	 缴款日期:
	                    </td>
	                    <td colspan="1"> 
	                        <input class="nui-datepicker" name="lPayDate" id="lPayDate" style="width: 80%;"  />
	                    </td>
	                      <td class="form_label" align="right">
	                                                                                    所属行业:
	                    </td>
	                    <td colspan="1">
	                     	<input style="width: 80%;" id="vcIndustry" name="debtIssue.vcIndustry" class="mini-treeselect"  multiSelect="false" 
										        textField="text" valueField="id" parentField="pid" checkRecursive="false" virtualScroll="true"
										        expandOnLoad="false" showTreeIcon="false" showFolderCheckBox="true" allowInput="true" />
										        
	                    </td>
	                </tr>
	                 <tr>
	                    <td class="form_label" align="right">
	                       	 发行方式:
	                    </td>
	                    <td colspan="1"> 
	                        <input class="nui-dictcombobox" dictTypeId="issueType" name="debtIssue.vcIssueType" id="vcIssueType" style="width: 80%;"  />
	                    </td>
	                    <td class="form_label" align="right">
	                       	 所属省份:
	                    </td>
	                    <td colspan="1"> 
	                        <input class="nui-textbox"  id="vcProvince" width="80%"  name="debtIssue.vcProvince"/>
	                    </td>
	                </tr>
	                
	                <tr>
	                    <td class="form_label" align="right">
	                       	 所属行业(证监会二级):
	                    </td>
	                    <td colspan="1"> 
	                        <input style="width: 80%;" id="vcIssueAppraiseCsrc" name="debtIssue.vcIssueAppraiseCsrc" class="mini-treeselect"  multiSelect="false" 
										        textField="text" valueField="id" parentField="pid"  allowInput="true" virtualScroll="true"
										        showTreeIcon="false" textField="name" expandOnLoad="true" allowDrag="true" allowDrop="true" allowLeafDropIn="true"/>
										        
	                    </td>
	                    <td class="form_label" align="right">
	                       	 城投行政级别:
	                    </td>
	                    <td colspan="1"> 
	                        <input class="nui-dictcombobox" dictTypeId="cityLevel" id="vcCityLevel" width="80%"  name="debtIssue.vcCityLevel"/>
	                    </td>
	                </tr>
	                <tr>
	                    <td class="form_label" align="right">
	                                                                                    票面利率(%):
	                    </td>
	                    <td colspan="1">
	                        <input class="nui-textbox" name="debtIssue.enFaceRate" id="enFaceRate" width="80%" />
	                    </td>
	                    <td class="form_label" align="right">
	                       	 公司净资产(元):
	                    </td>
	                    <td colspan="1"> 
	                        <input class="nui-textbox"  vtype="float" onblur="check(this)" id="enIssuerNetValue" width="80%"  name="debtIssue.enIssuerNetValue"/>
	                    </td>
	                </tr>
	                <tr>
	                     <td class="form_label" align="right">
	                                                                                    主承销商:
	                    </td>
	                    <td colspan="3">
	                    	 <input style="width: 90%;" class="nui-textbox"  id="vcMainUnderwriter" name="debtIssue.vcMainUnderwriter"/>
	                    	 <input style="width: 92%;" class="nui-hidden"  id="vcMainUnderwriterId" name="debtIssue.vcMainUnderwriterId"/>
	                    	 <input id="lookup3" style="width: 25px;" class="mini-lookup" onvalidation="onIssuerId3"   
						        textField="vcIssueNameFull" valueField="lIssuerId" popupWidth="auto" onvalidation="onIssuerId3" 
						        popup="#gridPanel3" data="data"  grid="#datagrid3" multiSelect="true"  onclick="onClearClick3();onSearchClick3()"/>
						     
						     <div id="gridPanel3" class="mini-panel" title="header" iconCls="icon-add" style="width:450px;height:250px;" 
						        showToolbar="true" showCloseButton="true" showHeader="false" bodyStyle="padding:0" borderStyle="border:0" >
						        <div property="toolbar" style="padding:5px;padding-left:8px;text-align:center;">   
						            <div style="float:left;padding-bottom:2px;">
						                <span>主承销商：</span>                
						                <input id="keyText3" class="mini-textbox" style="width:170px;" onenter="onSearchClick3"/>
						                <a class="mini-button" onclick="onSearchClick3">查询</a>
						                <a class="mini-button" id="add" iconCls='icon-add' onclick="onAddClick">添加</a>
						            </div>
						            <div style="float:right;padding-bottom:2px;margin-right:14px;">
						            </div>
						            <div style="clear:both;"></div>
						        </div>
						        <div id="datagrid3"   class="mini-datagrid" style="width:100%;height:100%;" 
						            borderStyle="border:0" showPageSize="false" showPageIndex="false"
						            url="com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.loadIssueInfo.biz.ext" onRowdblclick="dbClick3">
						            <div property="columns" >
						            	<div type="checkcolumn"></div>
						                <div field="vcIssueName" width="50"  headerAlign="center" allowSort="true">简称</div>
						                <div field="vcIssueNameFull" width="70" headerAlign="center" allowSort="true">全称</div>
						            </div>
						        </div>  
						      </div>
	                    </td>
	                </tr>
	                
	                 <tr>
	                     <td class="form_label" align="right">
	                                                                                    副主承销商:
	                    </td>
	                    <td colspan="3">
	                    	  <input style="width: 90%;" class="nui-textbox"  id="vcDeputyUnderwriter" name="debtIssue.vcDeputyUnderwriter"/>
	                    	  <input style="width: 92%;" class="nui-hidden"  id="vcDeputyUnderwriterId" name="debtIssue.vcDeputyUnderwriterId"/>
	                    	  <input id="lookup4" style="width: 25px;" class="mini-lookup"  onvalidation="onIssuerId4" 
						        textField="vcIssueNameFull" valueField="lIssuerId" popupWidth="auto"  
						        popup="#gridPanel4" data="data"  grid="#datagrid4" multiSelect="true" onclick="onClearClick4();onSearchClick4()" />
						     
						     <div id="gridPanel4" class="mini-panel" title="header" iconCls="icon-add" style="width:450px;height:250px;" 
						        showToolbar="true" showCloseButton="true" showHeader="false" bodyStyle="padding:0" borderStyle="border:0" >
						        <div property="toolbar" style="padding:5px;padding-left:8px;text-align:center;">   
						            <div style="float:left;padding-bottom:2px;">
						                <span>副主承销商：</span>                
						                <input id="keyText4" class="mini-textbox" style="width:145px;" onenter="onSearchClick4"/>
						                <a class="mini-button" onclick="onSearchClick4">查询</a>
						                <a class="mini-button" id="add" iconCls='icon-add' onclick="onAddClick">添加</a>
						            </div>
						            <div style="float:right;padding-bottom:2px;margin-right:14px;">
						            </div>
						            <div style="clear:both;"></div>
						        </div>
						        <div id="datagrid4"   class="mini-datagrid" style="width:100%;height:100%;" 
						            borderStyle="border:0" showPageSize="false" showPageIndex="false"
						            url="com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.loadIssueInfo.biz.ext" onRowdblclick="dbClick4">
						            <div property="columns" >
						            	<div type="checkcolumn"></div>
						                <div field="vcIssueName" width="50"  headerAlign="center" allowSort="true">简称</div>
						                <div field="vcIssueNameFull" width="70" headerAlign="center" allowSort="true">全称</div>
						            </div>
						        </div>  
						      </div>
	                    </td>
	                </tr>
	                <tr>
	                    <td class="form_label" align="right">
	                       	缴款方式:
	                    </td>
	                    <td colspan="1"> 
	                        <input class="nui-dictcombobox"  dictTypeId="ATS_FM_PAYMENT" width="80%" id="cPayType" name="debtIssue.cPayType" showNullItem="false"/>
	                    </td>
	                     <td class="form_label" align="right">
	                         	承销方式:
	                    </td>
	                    <td colspan="1">
	                        <input class="nui-dictcombobox"  dictTypeId="underwriteType" width="80%" id="cUnderwriteType" name="debtIssue.cUnderwriteType" showNullItem="false"/>
	                    </td>
	                </tr>
	                <tr>
	                	<td class="form_label" align="right">
	                       	投标截止时间:
	                    </td>
	                    <td colspan="1"> 
	                    	<input class="nui-datepicker" name="debtIssue.dBidLimitTime"  id="dBidLimitTime" style="width: 100px;"  />
	                    	<input style="width: 40px;" url="<%=request.getContextPath() %>/fm/instr/processUtil/timeHH.txt" class="nui-dictcombobox" id="dApplicationTimeHH" />时
			    			<input style="width: 40px;" url="<%=request.getContextPath() %>/fm/instr/processUtil/timeMM.txt" class="nui-dictcombobox" id="dApplicationTimeMM" />分
	                    </td>
	                	<td class="form_label" align="right">
	                                                                                    投标区间:
	                    </td>
	                    <td colspan="1">
	                        <input class="nui-textbox" name="debtIssue.vcTenderInterval" id="vcTenderInterval" width="80%" />
	                    </td>
	                </tr>
	                <tr id="tr1">
	                   <td class="form_label" align="right">
	                        	发行日期描述:
	                    </td>
	                    <td colspan="3">
	                    	<input class="nui-textarea" id="vcIssueBeginDateDesc" name="debtIssue.vcIssueBeginDateDesc" width="92%"/>
	                    </td>
	                </tr>
	                <tr id="tr1">
	                   <td class="form_label" align="right">
	                        	承销商联系人信息:
	                    </td>
	                    <td colspan="3">
	                    	<input class="nui-textarea" id="vcUnderwriterInfo" name="debtIssue.vcUnderwriterInfo" width="92%"/>
	                    </td>
	                </tr>
	                <tr>
	                <td class="form_label" align="right">
	                                                                                    承销团:
	                    </td>
	                    <td colspan="3">
	                    	  <input style="width: 90%;" class="nui-textbox"  id="vcGroupUnderwriter" name="debtIssue.vcGroupUnderwriter"/>
	                    	  <input style="width: 92%;" class="nui-hidden"  id="vcGroupUnderwriterId" name="debtIssue.vcGroupUnderwriterId"/>
	                    	  <input id="lookup6" style="width: 25px;" class="mini-lookup"  
						        textField="vcIssueNameFull" valueField="lIssuerId" popupWidth="auto"  onvalidation="onIssuerId6"  
						        popup="#gridPanel6" data="data"  grid="#datagrid6" multiSelect="true" onclick="onClearClick6();onSearchClick6()" />
						     
						     <div id="gridPanel6" class="mini-panel" title="header" iconCls="icon-add" style="width:450px;height:250px;" 
						        showToolbar="true" showCloseButton="true" showHeader="false" bodyStyle="padding:0" borderStyle="border:0" >
						        <div property="toolbar" style="padding:5px;padding-left:8px;text-align:center;">   
						            <div style="float:left;padding-bottom:2px;">
						                <span>承销团：</span>                
						                <input id="keyText6" class="mini-textbox" style="width:145px;" onenter="onSearchClick6"/>
						                <a class="mini-button" onclick="onSearchClick6">查询</a>
						                <a class="mini-button" id="add" iconCls='icon-add' onclick="onAddClick">添加</a>
						            </div>
						            <div style="float:right;padding-bottom:2px;margin-right:14px;">
						            </div>
						            <div style="clear:both;"></div>
						        </div>
						        <div id="datagrid6"   class="mini-datagrid" style="width:100%;height:100%;" 
						            borderStyle="border:0" showPageSize="false" showPageIndex="false"
						            url="com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.loadIssueInfo.biz.ext" onRowdblclick="dbClick6">
						            <div property="columns" >
						                <div type="checkcolumn"></div>
						                <div field="vcIssueName" width="50"  headerAlign="center" allowSort="true">简称</div>
						                <div field="vcIssueNameFull" width="70" headerAlign="center" allowSort="true">全称</div>
						            </div>
						        </div>  
						      </div>
	                    </td>
	                </tr>
	                <tr>
	                <td class="form_label" align="right">
	                        	特殊条款:
	                    </td>
	                    <td colspan="1">
	                    	<input class="nui-dictcombobox" dictTypeId="specialText" multiSelect="true" width="80%" id="vcSpecialText" name="debtIssue.vcSpecialText" />
	                    </td>
	               </tr>
	                 <tr id="tr1">
	                   <td class="form_label" align="right">
	                        	特殊条款说明:
	                    </td>
	                    <td colspan="3">
	                    	<input class="nui-textarea" id="vcSpecialTextDesc" name="debtIssue.vcSpecialTextDesc" width="92%"/>
	                    </td>
	                </tr>
	                 <tr>
	                  	 <td class="form_label" align="right">
	                       	 下一利率跳升点数(BP):
	                    </td>
	                    <td colspan="1"> 
	                        <input class="nui-textbox" onblur="checkInt(this,lNInterestRateJumpPoints)" id="lNInterestRateJumpPoints" width="80%"  name="debtIssue.lNInterestRateJumpPoints"/>
	                    </td>
	                  	 <td class="form_label" align="right">
	                                                                                    招标方式:
	                    </td>
	                    <td colspan="1">
	                        <input class="nui-dictcombobox" dictTypeId="tenderType" width="80%" id="cBidType" name="debtIssue.cBidType"  showNullItem="false"/>
	                    </td>
	                </tr>
	                
	                 <tr>
	                  	<td class="form_label" align="right">
	                       	 担保人:
	                    </td>
	                    <td colspan="1"> 
	                    	<input style="width: 78%;" class="nui-textbox"  id="vcGuarantorName" name="debtIssue.vcGuarantorName"/>
	                    	<input id="lookup5" style="width: 25px;" name="debtIssue.lGuarantorId" class="mini-lookup"  
						        textField="vcIssueNameFull" valueField="lIssuerId" popupWidth="auto"  
						        popup="#gridPanel5" data="data" onvalidation="onGuarantor" grid="#datagrid5" multiSelect="false" onclick="onClearClick5();onSearchClick5()" />
						     
						     <div id="gridPanel5" class="mini-panel" title="header" iconCls="icon-add" style="width:450px;height:250px;" 
						        showToolbar="true" showCloseButton="true" showHeader="false" bodyStyle="padding:0" borderStyle="border:0" >
						        <div property="toolbar" style="padding:5px;padding-left:8px;text-align:center;">   
						            <div style="float:left;padding-bottom:2px;">
						                <span>担保人：</span>                
						                <input id="keyText5" class="mini-textbox" style="width:160px;" onenter="onSearchClick5"/>
						                <a class="mini-button" onclick="onSearchClick5">查询</a>
						                <a class="mini-button" id="add" iconCls='icon-add' onclick="onAddClick">添加</a>
						            </div>
						            <div style="float:right;padding-bottom:2px;margin-right:14px;">
						            </div>
						            <div style="clear:both;"></div>
						        </div>
						        <div id="datagrid5"   class="mini-datagrid" style="width:100%;height:100%;" 
						            borderStyle="border:0" showPageSize="false" showPageIndex="false"
						            url="com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.loadIssueInfo.biz.ext" onRowdblclick="dbClick5">
						            <div property="columns" >
						                <div field="vcIssueName" width="50"  headerAlign="center" allowSort="true">简称</div>
						                <div field="vcIssueNameFull" width="70" headerAlign="center" allowSort="true">全称</div>
						            </div>
						        </div>  
						      </div>
	                    	
	                    </td>
	                  	 <td class="form_label" align="right">
	                                                                                    担保方式:
	                    </td>
	                    <td colspan="1">
	                        <input class="nui-dictcombobox" dictTypeId="ATS_FM_ASSUER_TYPE" width="80%" id="cAssuerType" name="debtIssue.cAssureType"  showNullItem="false"/>
	                    </td>
	                </tr>
	                <tr>
	                 <td class="form_label" align="right">
	                                                                                    担保人简介:
	                    </td>
	                    <td colspan="3">
	                    	<input class="nui-textarea"  name="debtIssue.vcGuarantorSummary"  id="vcGuarantorSummary" width="92%"/>
	                    </td>
	                </tr>
	                
	                <tr>
	                    <td class="form_label" align="right">
	                       	 下一行权日:
	                    </td>
	                    <td colspan="1"> 
	                        <input class="nui-datepicker"  id="lNextExerciseDate" name="lNextExerciseDate" style="width: 80%"  />
	                    </td>
	                    <td class="form_label" align="right">
	                                                                                    特殊期限:
	                    </td>
	                    <td colspan="1">
	                        <input class="nui-textbox" name="debtIssue.vcSpecialLimite" id="vcSpecialLimite" width="80%" />
	                    </td>
	                </tr>	             
	                <tr>
	                    <td class="form_label" align="right">
	                         是否具有赎回权:
	                    </td>
	                    <td colspan="1"  class="radio-border-top-none">
							<input id="cIsHaveBuyback" name="debtIssue.cIsHaveBuyback" value="0" class="nui-radiobuttonlist" data="[{id: 1, text: '是'}, {id: 0, text: '否'}]"/>
	                    </td>
	                    <td class="form_label" align="right">
	                       	 是否具有回售权:
	                    </td>
	                    <td colspan="1"  class="radio-border-top-none"> 
	                    	<input id="cIsHaveSaleback" name="debtIssue.cIsHaveSaleback" value="0" class="nui-radiobuttonlist" data="[{id: 1, text: '是'}, {id: 0, text: '否'}]"/>
	                    </td>
	                </tr>
	                <tr> 
		                 <td class="form_label" align="right">
		                                                                                    募集说明书:
		                 </td>
		                 <td colspan="3" class="td">
							<iframe id="prodIfm1" width="590"  height="110px" frameborder="no" border="0" marginwidth="0" marginheight="0" scolling="no" 
							 	src="<%=request.getContextPath() %>/fm/baseinfo/fileupload/any_upload.jsp?attachType=2&attachBusType=1" >
							 </iframe>
						 </td>
	               </tr>
	               
	               <tr> 
		                 <td class="form_label" align="right">
		                                                                                    信用评级报告:
		                 </td>
		                 <td colspan="3" class="td">
							<iframe id="prodIfm2" width="590"  height="110px" frameborder="no" border="0" marginwidth="0" marginheight="0" scolling="no" 
							 	src="<%=request.getContextPath() %>/fm/baseinfo/fileupload/any_upload.jsp?attachType=2&attachBusType=2" >
							 </iframe>
						 </td>
	               </tr>
	               <tr> 
		                 <td class="form_label" align="right">
		                                                                                      债券发行公告:
		                 </td>
		                 <td colspan="3" class="td">
							<iframe id="prodIfm3" width="590"  height="110px" frameborder="no" border="0" marginwidth="0" marginheight="0" scolling="no" 
							 	src="<%=request.getContextPath() %>/fm/baseinfo/fileupload/any_upload.jsp?attachType=2&attachBusType=3" >
							 </iframe>
						 </td>
	               </tr>
	            </table>
	        </div>
		</div>
   		<div title="审批内容">
   		  <div id="dataform2" style="padding-top:5px;">
   		  	 <input class="nui-hidden" id="activityDefID"  value=<b:write property="workitem/ACTIVITYDEFID" /> />
   			<table style="width:100%;table-layout:fixed;" border="0" class="nui-form-table">
		     <tr>
		         <td colspan="1" class="td1" align="right">主题: </td>
		         <td colspan="3" class="td2"><div id="themeOfWork"></div></td>
		     </tr>
		       <tr>
		         <td class="td1" width="20%" align="right">
		         	  当前节点:    
		         </td>
		         <td colspan="3" class="td2"><b:write property="workitem/WORKITEMNAME" /></td>
		         
		       </tr>
		       <tr>
		         <td class="td1" width="20%" align="right">上一节点参与者:</td>
		         <td colspan="1" class="td2" width="30%"><b:write property="lastActor" /></td>
		         <td class="td2" width="20%" align="right">当前节点参与者:</td>
		         <td class="td2" colspan="1">  <b:write property="nextActor" /></td>
		       </tr>
		       <tr>
		         <td class="td1" align="right">操作:</td>
		         <td colspan="2" class="radio-border-top-none ">
			          <l:in property="workitem/ACTIVITYDEFID" targetValue="ATS_FM_JYY1FH">
			             
			           <input name="bpsParam.operateType" id="operateType" class="nui-radiobuttonlist" onitemclick="operateCheck(this)" 
							data="[{id: 1, text: '同意'}, {id: 2, text: '退办'},{id: 98, text: '修改'},{id: 5, text: '否决'}]" style="float: left;" value="1"/>
					  </l:in>
					  
					  <l:in property="workitem/ACTIVITYDEFID" targetValue="JYY2FH">
			           <input name="bpsParam.operateType" id="operateType" class="nui-radiobuttonlist" onitemclick="operateCheck(this)" 
							data="[{id: 1, text: '同意'}, {id: 2, text: '退办'},{id: 5, text: '否决'}]" style="float: left;" value="1"/>
					  </l:in>
					  
					  <l:in property="workitem/ACTIVITYDEFID" targetValue="ATS_FM_XZLR">
			            <input name="bpsParam.operateType" id="operateType" class="nui-radiobuttonlist" onitemclick="operateCheck(this)" 
							data="[{id: 98, text: '修改'}]" style="float: left;" value="98"/>
						 <input class="nui-hidden" id="isSign"  value="0" >
					  </l:in>
					  
					   <l:in property="workitem/ACTIVITYDEFID" targetValue="ATS_FM_XZQCFH">
			           <input name="bpsParam.operateType" id="operateType" class="nui-radiobuttonlist" onitemclick="operateCheck(this)" 
							data="[{id: 1, text: '同意'},{id: 98, text: '修改'}, {id: 5, text: '否决'}]" style="float: left;" value="1"/>
					   </l:in>
					  <l:in property="workitem/ACTIVITYDEFID" targetValue="ATS_FM_XZQCFH2">
			           <input name="bpsParam.operateType" id="operateType" class="nui-radiobuttonlist" onitemclick="operateCheck(this)" 
							data="[{id: 1, text: '同意'}, {id: 5, text: '否决'}]" style="float: left;" value="1"/>
					   </l:in>
					   
					  <font style="color: red; margin-left: 40px;"></font><span id="handlerActorTitle"></span>
							 <input class="nui-buttonedit" id="sendUser"  name="bpsParam.sendUser" onclick="selectSendUser" style="display: none;"/>
							<input class="nui-buttonedit" id="selectUser"  name="bpsParam.selectUser" onclick="selectActor" style="display: none;"/>
							<input class="nui-buttonedit" id="handlerActor"  name="bpsParam.handlerActor" onclick="selectActor" style="display: none;"/>
		         </td>
		         
		         <td class="td1">
			           <a class='nui-button' plain='false' iconCls="icon-save" onclick="processSubmit()">
	                                                                        提交
	                   </a>
	                   <span style="display:inline-block;width:15px;"></span>
	                   <a class='nui-button' plain='false' iconCls="icon-cancel" onclick="CloseWindow('close')">
	                                                                         返回
	                   </a>
		         </td>
		       </tr>
		        <tr id="backActivity_tr" style="display: none;">
					<th class="nui-form-label td1">退办:</th>
					<td colspan="3" class="td2">
						<input id="backActivity" name="bpsParam.backActivity" class="nui-combobox" onvaluechanged="backActivityChanged" textField="activityInstName" valueField="activityDefID"  style="width: 300px">
					</td>
				</tr>

	            <l:iterate property="approveInfos" id="approveInfo">
					<tr>
					   <td class="td1" align="right">审批意见:</td>
					   <td colspan="3" class="td2"><b:write iterateId="approveInfo" property="vcUserName"/>:<b:write iterateId="approveInfo" property="vcWorkItemName"/>,<b:write iterateId="approveInfo" property="vcComments"/></td>
					</tr>
				</l:iterate>
               <tr>
		         <td class="td1" align="right">处理意见:</td>
		         <td colspan="3" class="td2"><input id="vcComments" class="nui-textarea" name="approve.vcComments" width="600" height="60" value="同意"/></td>
		        
		       </tr>
		     </table>
		    </div>
   		</div>
		<div title="流程信息" url="com.cjhxfund.ats.fm.comm.processGraph.flow?processInstID=<%=pid %>&workItemID=<%=workItemID %>&bizId=<%=bizId %>" ></div>
		
		<div id="mergeDet" title="去重明细信息" url="<%=request.getContextPath() %>/fm/baseinfo/firstGradeDebt/mergeDetail.jsp?processInstID=<%=pid %>"></div>
   </div>
	<script type="text/javascript">
    	nui.parse();
    	var context = '<%=request.getContextPath() %>';
    	var pid= '<%=pid %>';
    	var stockInvestNo = '<%=stockInvestNo %>';
    	var form = new nui.Form("dataform1");
    	var form2 = new nui.Form("dataform2");
    	var processType ='<%=processType %>';
    	//查重配置
    	var stockIssueInfoStr;
            
        getCheckCondition();
    		
    	initForm();
    	
    	loadActivities();
    	
    	 //获取查重条件
        function getCheckCondition(){
        	 $.ajax({
				url:"com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.loadCheckStockIssueInfo.biz.ext",
	            type:'POST',
	            data:null,
	            cache:false,
	            contentType:'text/json',
	            success:function(text){
					var data = nui.decode(text);
					stockIssueInfoStr = data.stockIssueInfoStr;
				}    
			});
        }
        
         //将时间格式字符串转换为int类型
		function getIntDate(dateStr){
			if(dateStr=="" || dateStr==null){
				return "";
			}
			dateStr=dateStr.substr(0,10);//0开始，取后面10位
			dateStr=dateStr.replace(/-/g, "");
			return dateStr;
		}
        
    	
    	//---------------------发行人-------------start--------------------------//
    	var grid1 = nui.get("datagrid1");
        var keyText = nui.get("keyText");
        grid1.load();
        
        function onCloseClick(e) {
            var lookup2 = nui.get("lookup2");
            lookup2.hidePopup();
        }
        function onClearClick(e) {
            nui.get("keyText").setValue("");
        }
        
        function onCloseClick(e) {
            var lookup2 = nui.get("lookup2");
            lookup2.hidePopup();
        }
        
        
         function onSearchClick(e) {
	            grid1.load({
	                key: keyText.value
	            });
	    }
	    
	      //发行人，行选择，双击响应事件
        function dbClick2(e) {
           var lookup2 = nui.get("lookup2");
            lookup2.hidePopup();
        }
        
        var IssueronCkData=new Array();//发行人选中的历史数据
		function onIssuerId(e){
				var dataIssuer=grid1.data;
	        	//设置发行人信息,累加查询结果，防止用户查询新数据后不选择
	        	if(IssueronCkData!=null){
	        		dataIssuer=dataIssuer.concat(IssueronCkData);
	        	}
	        	//获取发行人的其他数据
	        	for(var i=0;i<dataIssuer.length;i++){
	        		//查找选中的数据
	        		if(dataIssuer[i].lIssuerId==e.value){
	        			if(IssueronCkData!=null){
	        				IssueronCkData=IssueronCkData.concat(dataIssuer[i]);
	        			}else{
	        				IssueronCkData[0]=dataIssuer[i];
	        			}
					    //投资产品信息（债券代码,债券名称,债券类别代码,债券评级代码,主体评级代码,评级机构代码）
					    var vcIssueName = dataIssuer[i].vcIssueName;
					    var vcIssueNameFull = dataIssuer[i].vcIssueNameFull;
					    var vcIssueProperty = dataIssuer[i].vcIssueProperty;
					    var cIssueAppraise = dataIssuer[i].cIssueAppraise;
					    var vcIssueAppraiseOrgan = dataIssuer[i].vcIssueAppraiseOrgan;
					    var vcIndustry = dataIssuer[i].vcIndustry;   //所属行业
					    var vcProvince = dataIssuer[i].vcProvince;  //所属省份
					    var vcIssueAppraiseCsrc = dataIssuer[i].vcIssueAppraiseCsrc;//所属行业（证监会二级）
					    var enIssuerNetValue = dataIssuer[i].enIssuerNetValue;//公司净资产
					    var vcCityLevel = dataIssuer[i].vcCityLevel;//城投行政级别
					    
						nui.get("vcIssuerName").setValue(vcIssueName);               //发行人全称
						nui.get("vcIssuerNameFull").setValue(vcIssueNameFull);               //发行人全称
						if(cIssueAppraise!=null){
							nui.get("cIssueAppraise").setValue(cIssueAppraise);			  //主体评级
						}
						if(vcIssueProperty!=null){
							nui.get("vcIssueProperty").setValue(vcIssueProperty);	      //主体类型
						}
						if(vcIssueAppraiseOrgan!=null){
							nui.get("vcIssueAppraiseOrgan").setValue(vcIssueAppraiseOrgan);//主体评级机构
						}
						if(vcIndustry!=null){
							nui.get("vcIndustry").setValue(vcIndustry);			  //所属行业
						}
						if(vcProvince!=null){
							nui.get("vcProvince").setValue(vcProvince);			  //所属省份
						}
						if(vcIssueAppraiseCsrc!=null){
							nui.get("vcIssueAppraiseCsrc").setValue(vcIssueAppraiseCsrc);			  //所属行业（证监会二级）
						}
						if(enIssuerNetValue!=null){
							nui.get("enIssuerNetValue").setValue(enIssuerNetValue);			  //公司净资产
						}
						if(vcCityLevel!=null){
							nui.get("vcCityLevel").setValue(vcCityLevel);			  //城投行政级别
						}
	        		}
	        	}
	          
		}
		//---------------------发行人-------------end--------------------------//
		
		
		var grid3 = nui.get("datagrid3");
        var keyText3 = nui.get("keyText3");
        grid3.load();
        function onCloseClick3(e) {
            var lookup3 = nui.get("lookup3");
            lookup3.hidePopup();
        }
        function onClearClick3(e) {
            /* var lookup3 = nui.get("lookup3");
            lookup3.deselectAll(); */
            nui.get("keyText3").setValue("");
        }
        
        function onSearchClick3(e) {
            grid3.load({
                key: keyText3.value
            });
        }
        
        //主承销商选择 ，双击行，事件响应
        function dbClick3(e){
        	 var lookup3 = nui.get("lookup3");
            lookup3.hidePopup();
        }
        
        
        var grid4 = nui.get("datagrid4");
    	var keyText4 = nui.get("keyText4");
    	grid4.load();
    	 
    	function onCloseClick4(e) {
            var lookup4 = nui.get("lookup4");
            lookup4.hidePopup();
        }
        function onClearClick4(e) {
            /* var lookup4 = nui.get("lookup4");
            lookup4.deselectAll(); */
            nui.get("keyText4").setValue("");
        }
        
        function onSearchClick4(e) {
            grid4.load({
                key: keyText4.value
            });
        }
        
        //副主承销商，行选择，双击事件
        function dbClick4(e) {
            var lookup4 = nui.get("lookup4");
            lookup4.hidePopup();
        }
        
        var grid5 = nui.get("datagrid5");
    	var keyText5 = nui.get("keyText5");
    	grid5.load();
    	 
    	function onCloseClick5(e) {
            var lookup5 = nui.get("lookup5");
            lookup5.hidePopup();
        }
        function onClearClick5(e) {
            /* var lookup5 = nui.get("lookup5");
            lookup5.deselectAll(); */
            nui.get("keyText5").setValue("");
        }
        
        function onSearchClick5(e) {
            grid5.load({
                key: keyText5.value
            });
        }
        
     	//担保人，行选择，双击响应事件
        function dbClick5(e) {
            var lookup5 = nui.get("lookup5");
            lookup5.hidePopup();
        }
        //承销团
        var grid6 = nui.get("datagrid6");
    	var keyText6 = nui.get("keyText6");
    	grid6.load();
    	 
    	function onCloseClick6(e) {
            var lookup6 = nui.get("lookup6");
            lookup6.hidePopup();
        }
        function onClearClick6(e) {
            nui.get("keyText6").setValue("");
        }
        
        function onSearchClick6(e) {
            grid6.load({
                key: keyText6.value
            });
        }
        function dbClick6(e) {
            var lookup6 = nui.get("lookup6");
            lookup6.hidePopup();
        }
		function onIssuerId3(e){
    		nui.get("vcMainUnderwriter").setValue(e.source.text);
    		nui.get("vcMainUnderwriterId").setValue(e.source.value);
    	}
    	function onIssuerId4(e){
    		nui.get("vcDeputyUnderwriter").setValue(e.source.text);
    		nui.get("vcDeputyUnderwriterId").setValue(e.source.value);
    	}
		function onIssuerId6(e){
    		nui.get("vcGroupUnderwriter").setValue(e.source.text);
    		nui.get("vcGroupUnderwriterId").setValue(e.source.value);
    	}
    	var GuarantorCkData=new Array();//发行人选中的历史数据
		function onGuarantor(e){
				var dataIssuer=grid5.data;
	        	//设置发行人信息,累加查询结果，防止用户查询新数据后不选择
	        	if(IssueronCkData!=null){
	        		dataIssuer=dataIssuer.concat(IssueronCkData);
	        	}
	        	//获取发行人的其他数据
	        	for(var i=0;i<dataIssuer.length;i++){
	        		//查找选中的数据
	        		if(dataIssuer[i].lIssuerId==e.value){
	        			if(IssueronCkData!=null){
	        				GuarantorCkData=GuarantorCkData.concat(dataIssuer[i]);
	        			}else{
	        				GuarantorCkData[0]=dataIssuer[i];
	        			}
					    //投资产品信息（债券代码,债券名称,债券类别代码,债券评级代码,主体评级代码,评级机构代码）
					    var vcIssueNameFull = dataIssuer[i].vcIssueNameFull;
						nui.get("vcGuarantorName").setValue(vcIssueNameFull);               //发行人全称
	        		}
	        	}
	          
			}
    	
    	function onCancel(){
			CloseWindow("close");
		}
		var vcIssueAppraiseCsrc = "";
		var vcIndustry = "";
    	//初始化表单数据
    	function initForm(){
    	    var json = nui.encode({pid:pid,stockInvestNo:stockInvestNo});
	    	$.ajax({
					url:"com.cjhxfund.ats.fm.baseinfo.DebtIssueManager.getDebtIssueByProcessInstId.biz.ext",
					type:'POST',
					data:json,
					cache:false,
					contentType:'text/json',
					success:function(text){
						var returnJson = nui.decode(text);
						var data = returnJson.debtIssue;
		            	 if(data.cIsHaveSaleback!='1') data.cIsHaveSaleback=0;
		            	 if(data.cIsHaveBuyback!='1') data.cIsHaveBuyback=0;
						
						form.setData({debtIssue:data});
						loadStockTypeAll(data.vcStockType);  //初始化债券类型   
						vcIssueAppraiseCsrc = returnJson.vcIssueAppraiseCsrc;
						nui.get("vcIssueAppraiseCsrc").loadList(vcIssueAppraiseCsrc);
			    		nui.get("vcIssueAppraiseCsrc").setValue(data.vcIssueAppraiseCsrc);
			    		vcIndustry = returnJson.vcIndustry;
			    		nui.get("vcIndustry").loadList(vcIndustry);
			    		nui.get("vcIndustry").setValue(data.vcIndustry);
						
						  
						//处理付息频率，值满足数据字典则直接显示数据字典中对应值，否则直接显示值
						if(nui.get("enPayInteval").getText()=="" || nui.get("enPayInteval").getText()==null){
							nui.get("enPayInteval").setText(data.enPayInteval);
						}
						
            			changeDate(data); //转换日期类型
            			nui.get("lIssuerId").setValue(data.lIssuerId);
            	 		issueInfoOnItemClick();
            	 		showIssuerName(data);
            	 		var activityDefID = nui.get("activityDefID").value;
				       if(activityDefID=='JYY2FH' || activityDefID=='ATS_FM_XZQCFH2'){//如果是交易员2把所有控件都置灰
				       	 $("#dataform1").find("input").attr("disabled","true");				       	 
				       	 $("#enPayInteval").attr("readonly","readonly");
				       	 
				       	 nui.get("vcSpecialText").readOnly="readonly";
				       	 $("#vcSpecialText textarea").attr("disabled","disabled");
						$("#vcSpecialText textarea").attr("readonly","readonly");//解决IE兼容
						 nui.get("vcSpecialTextDesc").readOnly="readonly";
						 $("#vcSpecialTextDesc textarea").attr("disabled","disabled");
						$("#vcSpecialTextDesc textarea").attr("readonly","readonly");//解决IE兼容
						nui.get("vcGuarantorSummary").readOnly="readonly";
						$("#vcGuarantorSummary textarea").attr("disabled","disabled");
						$("#vcGuarantorSummary textarea").attr("readonly","readonly");//解决IE兼容
						nui.get("vcUnderwriterInfo").readOnly="readonly";
						$("#vcUnderwriterInfo textarea").attr("disabled","disabled");
						$("#vcUnderwriterInfo textarea").attr("readonly","readonly");//解决IE兼容
						nui.get("vcIssueBeginDateDesc").readOnly="readonly";
						$("#vcIssueBeginDateDesc textarea").attr("disabled","disabled");
						$("#vcIssueBeginDateDesc textarea").attr("readonly","readonly");//解决IE兼容
						nui.get("vcExistLimiteDesc").readOnly="readonly";
						$("#vcExistLimiteDesc textarea").attr("disabled","disabled");
						$("#vcExistLimiteDesc textarea").attr("readonly","readonly");//解决IE兼容				       	
						showFile(data,"1");
				       }else{
				       	showFile(data,"2");
				       }
				       if(activityDefID=='ATS_FM_JYY1FH' || activityDefID=='JYY2FH' || activityDefID=='ATS_FM_XZLR'){//不是去重的时候，把去重明细信息tab页移除
				       		nui.get("tabs").removeTab(3);
				       }
				       if((nui.get("cPayInterestType").getValue()=="1" || nui.get("cPayInterestType").getValue()=="3")&&(activityDefID=='ATS_FM_JYY1FH' || activityDefID=='ATS_FM_XZQCFH')){
							nui.get("enPayInteval").setValue("0");
			  				nui.get("enPayInteval").setReadOnly(true);//设置为不可选
						}
            	 		cheangedVcStockType({id:data.vcStockType,value:data.vcStockType});
            	 		initApproveContext(data);
            	 		
						form.setChanged(false);
					}
				});	
		}
		 
         //加载所有的债券信息
         function loadStockTypeAll(e){
         	
         	nui.ajax({
			    url: "com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.loadStockType.biz.ext",
			    type: "post",
			    dataType:"json",
			    success: function (text) {
			    	nui.get("vcStockType").loadList(text.data);
			    	nui.get("vcStockType").setValue(e);
			    }
			});
         	
         }
        	
        	function changeDate(data){
        	    //转换公告日期
        	    
        	    var n_lIssuePostDate = data.lIssuePostDate;		  						//父页面lIssuePostDate值 为Number类型
        	    if(n_lIssuePostDate!=0){
	        	    var o_lIssuePostDate = nui.get("lIssuePostDate"); 						//当前页面lIssuePostDate对象
	            	var v_lIssuePostDate = nui.parseDate(n_lIssuePostDate+"");				//转换为Date类型
	            	var d_lIssuePostDate = nui.formatDate(v_lIssuePostDate, "yyyy-MM-dd");  //date格式化
	            	o_lIssuePostDate.setValue(d_lIssuePostDate);							//赋值
        	    }
        	    //发行日
        	    var n_lIssueBeginDate = data.lIssueBeginDate;		  						//父页面lIssueBeginDate值 为Number类型
				if(n_lIssueBeginDate!=0){
					var o_lIssueBeginDate = nui.get("lIssueBeginDate"); 						//当前页面lIssueBeginDate对象
					var v_lIssueBeginDate = nui.parseDate(n_lIssueBeginDate+"");				//转换为Date类型
					var d_lIssueBeginDate = nui.formatDate(v_lIssueBeginDate, "yyyy-MM-dd");  //date格式化
					o_lIssueBeginDate.setValue(d_lIssueBeginDate);							//赋值
				}
				//上市日期
				var n_lPublishDate = data.lPublishDate;		  						//父页面lPublishDate值 为Number类型
				if(n_lPublishDate!=0){
					var o_lPublishDate = nui.get("lPublishDate"); 						//当前页面lPublishDate对象
					var v_lPublishDate = nui.parseDate(n_lPublishDate+"");				//转换为Date类型
					var d_lPublishDate = nui.formatDate(v_lPublishDate, "yyyy-MM-dd");  //date格式化
					o_lPublishDate.setValue(d_lPublishDate);							//赋值
				}
				
				//到期日期
				var n_lEndincalDate = data.lEndincalDate;		  						//父页面lEndincalDate值 为Number类型
				if(n_lEndincalDate!=0){
					var o_lEndincalDate = nui.get("lEndincalDate"); 						//当前页面lEndincalDate对象
					var v_lEndincalDate = nui.parseDate(n_lEndincalDate+"");				//转换为Date类型
					var d_lEndincalDate = nui.formatDate(v_lEndincalDate, "yyyy-MM-dd");  //date格式化
					o_lEndincalDate.setValue(d_lEndincalDate);							//赋值
				}
				// 起息日期
				var n_lBegincalDate = data.lBegincalDate;		  						//父页面lBegincalDate值 为Number类型
				if(n_lBegincalDate!=0){
					var o_lBegincalDate = nui.get("lBegincalDate"); 						//当前页面lBegincalDate对象
					var v_lBegincalDate = nui.parseDate(n_lBegincalDate+"");				//转换为Date类型
					var d_lBegincalDate = nui.formatDate(v_lBegincalDate, "yyyy-MM-dd");  //date格式化
					o_lBegincalDate.setValue(d_lBegincalDate);							//赋值
				}
				//下一行权日
				var n_lNextExerciseDate = data.lNextExerciseDate;		  						//父页面lNextExerciseDate值 为Number类型
				if(n_lNextExerciseDate!=0){
					var o_lNextExerciseDate = nui.get("lNextExerciseDate"); 						//当前页面lNextExerciseDate对象
					var v_lNextExerciseDate = nui.parseDate(n_lNextExerciseDate+"");				//转换为Date类型
					var d_lNextExerciseDate = nui.formatDate(v_lNextExerciseDate, "yyyy-MM-dd");  //date格式化
					o_lNextExerciseDate.setValue(d_lNextExerciseDate);							//赋值
				}
				
				 //缴款日期
				var n_lPayDate = data.lPayDate;		  						//父页面lPayDate值 为Number类型
				if(n_lPayDate!=0){
					var o_lPayDate = nui.get("lPayDate"); 						//当前页面lPayDate对象
					var v_lPayDate = nui.parseDate(n_lPayDate+"");				//转换为Date类型
					var d_lPayDate = nui.formatDate(v_lPayDate, "yyyy-MM-dd");  //date格式化
					o_lPayDate.setValue(d_lPayDate);							//赋值
				}	
				
				var n_dBidLimitTime = data.dBidLimitTime;		  						//父页面lPayDate值 为Number类型
				if(n_dBidLimitTime!=0){
					var v_dBidLimitTime = nui.parseDate(n_dBidLimitTime+"");				//转换为Date类型
					if(v_dBidLimitTime!=null){
					 	nui.get("dApplicationTimeHH").setValue(v_dBidLimitTime.getHours());
					 	nui.get("dApplicationTimeMM").setValue(v_dBidLimitTime.getMinutes());
					}
				}		
            	
        	}
        	
        	function showIssuerName(data){
        		//发行人简称显示
        	    var lIssuerIdObj = nui.get("lookup2");
        	    lIssuerIdObj.setValue(data.lIssuerId);
        	    lIssuerIdObj.setText(data.vcIssuerName);
        	    
        	    //发行人简称显示 vcDeputyUnderwriter
        	    /* var vcDeputyUnderwriterObj = nui.get("lookup4");
        	    vcDeputyUnderwriterObj.setValue(data.vcDeputyUnderwriter);
        	    vcDeputyUnderwriterObj.setText(data.vcDeputyUnderwriter); */
        	    
        	    //发行人简称显示vcMainUnderwriter
        	    /* var vcMainUnderwriterObj = nui.get("lookup3");
        	    vcMainUnderwriterObj.setValue(data.vcMainUnderwriter);
        	    vcMainUnderwriterObj.setText(data.vcMainUnderwriter); */
        	    
        	    //担保人简称显示vcMainUnderwriter
        	    /* var vcGuarantorNameObj = nui.get("lookup5");
        	    vcGuarantorNameObj.setValue(data.lGuarantorId);
        	    vcGuarantorNameObj.setText(data.vcGuarantorName); */
        	    
        	    //承销团显示vcMainUnderwriter
        	    /* var vcGroupUnderwriterObj = nui.get("lookup6");
        	    vcGroupUnderwriterObj.setValue(data.vcGroupUnderwriter);
        	    vcGroupUnderwriterObj.setText(data.vcGroupUnderwriter); */
        	    
        	}
        	
        	
        	
        	
           function showFile(data,type){
                var bizId=data.lBizId;     

           	 	document.getElementById("prodIfm1").src = context+"/fm/baseinfo/fileupload/any_upload.jsp?attachType=2&attachBusType=1&id="+bizId+"&type="+type;
           	 	
           	 	document.getElementById("prodIfm2").src = context+"/fm/baseinfo/fileupload/any_upload.jsp?attachType=2&attachBusType=2&id="+bizId+"&type="+type;
           	 	
           	 	document.getElementById("prodIfm3").src = context+"/fm/baseinfo/fileupload/any_upload.jsp?attachType=2&attachBusType=3&id="+bizId+"&type="+type;
           }
		
		   function onOk(){
		   		if(form != null && form.isChanged()){
		   		    //投标截止时间
		   			var dBidLimitTime = nui.get("dBidLimitTime");
					if(dBidLimitTime!=null && dBidLimitTime.value!=""){
						var dApplicationDate=dBidLimitTime.text;
						var dApplicationHH=nui.get("dApplicationTimeHH").text;
						var dApplicationMM=nui.get("dApplicationTimeMM").text;
						var dApplicationTime1=dApplicationHH+":"+dApplicationMM+":00";
						var dDate=dApplicationDate+" "+dApplicationTime1;
						
						dBidLimitTime.setValue(dDate);
					}  
		   			var data = form.getData(false,true);
	            	var json = nui.encode(data);
					$.ajax({
						url:"com.cjhxfund.ats.fm.baseinfo.DebtIssueManager.updateDebtIssue.biz.ext",
			            type:'POST',
			            data:json,
			            cache:false,
			            contentType:'text/json',
			            success:function(text){
							var returnJson = nui.decode(text);
		        			if(returnJson.exception == null){
		        				nui.alert("保存成功", "系统提示", function(action){
		                        		if(action == "ok" || action == "close"){
		                            		//CloseWindow("saveSuccess");
		                        		}
		                    		});
		        			}
						}    
					});
		   		}else{
		   		
		   		}
		   	   
		   }
		   
		   //删除数据库中附件表的的文件
		function deleteFile(ids){
			var json = nui.encode({fileIds: ids});
			$.ajax({
	            url:'com.cjhxfund.ats.fm.baseinfo.attachInfoManager.deleteAttachInfos.biz.ext',
	            type:'POST',
	            data:json,
	            cache:false,
	            contentType:'text/json',
	            success:function(data){
	            
	             	 var returnJson = nui.decode(data);
		             if(returnJson.returnValue == "ok"){
		              	CloseWindow("close");
		             }else{
		               nui.alert("附件删除失败！","系统提示",function(action){
		               
		               });
		             }
	        	 }
	         });
		}
		
		function deleteFilePreparation(){
			var ids = "";
			var lRaiseInstFile = nui.get("lRaiseInstFile").value;
			var lRateReportFile = nui.get("lRateReportFile").value;
			var lBondIssueFile = nui.get("lBondIssueFile").value;
			if(lRaiseInstFile!=null  && lRaiseInstFile !=""){
				ids = lRaiseInstFile;
			}
			if(lRateReportFile!=null && lRateReportFile!=""){
				if(ids!=""){
					ids  = lRateReportFile+","+ids;
				}else{
					ids  = lRateReportFile;
				}
			}
		
			if(lBondIssueFile!=null && lBondIssueFile !=""){
				if(ids!=""){
					ids  = lBondIssueFile+","+ids;
				}else{
					ids  = lBondIssueFile;
				}
			}
			//如果没有上载文件，直接关闭
			if (ids == ""){
		     	//return window.CloseOwnerWindow(action);
	    	}else{
	    		deleteFile(ids);
	    	}
		}
		
		 //子页面删除文件之后，也删除父界面上的隐藏表单的值
		   function deleteFileByUpload(attachBusType){
		   	  if(attachBusType==1){     
		   	  	nui.get("lRaiseInstFile").setValue("");
		   	  }else if(attachBusType==2){//lRateReportFile
		   	  	nui.get("lRateReportFile").setValue("");
		   	  }else if(attachBusType==3){//lBondIssueFile
		   	  	nui.get("lBondIssueFile").setValue("");
		   	  }
		   	  form.setChanged(true);
		   }
		   //上载时，将附件表中的id传过来，放到隐藏表单中，直接保存到数据库
		   function initAttachId(attachBusType,serverData){
		       var fileID = serverData.trim();
		   	  if(attachBusType==1){     //lRaiseInstFile
		   	  	nui.get("lRaiseInstFile").setValue(fileID);
		   	  }else if(attachBusType==2){//lRateReportFile
		   	  	nui.get("lRateReportFile").setValue(fileID);
		   	  }else if(attachBusType==3){//lBondIssueFile
		   	  	nui.get("lBondIssueFile").setValue(fileID);
		   	  }
		   	  form.setChanged(true);
		   } 

		   function initApproveContext(data){
		   		var themeContext =  data.vcStockNameFull +"-"+ data.vcStockCode ;
		   		document.getElementById("themeOfWork").innerHTML=themeContext;
		   }
		
    	  //关闭窗口
		    function CloseWindow(action) {
		       if(action=="close" && form.isChanged()){
		      	if(confirm("数据已改变,确认退出?")){
		           deleteFilePreparation();
		           /* window.opener.location.reloadData();
		           return window.CloseOwnerWindow(action); */
		           return CloseWindow("cance");/* window.close();// */
		        }else{
		           return false;
		        }
		      }else if(window.CloseOwnerWindow) {
		      	window.opener.location.reloadData();
		      	return window.CloseOwnerWindow(action);
		      } else{
		      	//window.opener.reloadData();
		      	return window.close();
		      }
		    }
		    
		   /*
			*流程处理公共方法
			*/
			function operateCheck(ck) {
			    //id: 1, text: '通过'},{id: 2, text: '退办'},{id: 3, text: '修改'}
				var operateType = ck.value;
				if(operateType == 1){//同意
					nui.get("vcComments").setValue(ck.getSelected().text);
					jQuery("#handlerActor").hide();
					jQuery("#backActivity_tr").hide();
					jQuery("#handlerActorTitle").hide();
				} else if (operateType == 2){//退办
					if(nui.get("backActivity").getText() == ""){
						nui.get("vcComments").setValue("退办");
					} else {
						nui.get("vcComments").setValue( "退办 : " + "'"+ nui.get("backActivity").getText() +"'环节");
					}
					jQuery("#backActivity_tr").show();
					jQuery("#handlerActor").hide();	
					jQuery("#handlerActorTitle").hide();
					if(document.getElementById("selectUser")!=null){
						jQuery("#selectUser").hide();	
					}
					if(document.getElementById("sendUser")!=null){
						jQuery("#sendUser").hide();	
					}
					if(document.getElementById("yn_tr")!=null){
						jQuery("#yn_tr").hide();	
					}
				} else if (operateType == 98) {//修改
					if(nui.get("handlerActor").getText() == ""){
						nui.get("vcComments").setValue("修改");
					}
					//jQuery("#handlerActor").hide();
					jQuery("#backActivity_tr").hide();
					//jQuery("#handlerActorTitle").show();
					//document.getElementById("handlerActorTitle").innerHTML="请选择转办人员:";	
					if(document.getElementById("selectUser")!=null){
						jQuery("#selectUser").hide();	
					}	
					if(document.getElementById("sendUser")!=null){
						jQuery("#sendUser").hide();	
					}
					if(document.getElementById("yn_tr")!=null){
						jQuery("#yn_tr").hide();	
					}
				} else if (operateType == 5) {//否决
					if(nui.get("handlerActor").getText() == ""){
						nui.get("vcComments").setValue("不同意");
					}
					jQuery("#backActivity_tr").hide();
					if(document.getElementById("selectUser")!=null){
						jQuery("#selectUser").hide();	
					}	
					if(document.getElementById("sendUser")!=null){
						jQuery("#sendUser").hide();	
					}
					if(document.getElementById("yn_tr")!=null){
						jQuery("#yn_tr").hide();	
					}
				} 
			}
			
			 //流程提交
			 function processSubmit(){
			    //如果回退到新债录入活动节点，不需要进行签收操作
			    var isSignObj = nui.get("isSign");
			    var isSign = "1";
			    if(isSignObj!=null){
			    	isSign = "0";
			    }
			    var operateType = nui.get("operateType").value;
			    if(operateType == null){
				     nui.alert("请选择操作类型。");
				     return false;
			    }
			    //如果表单有更改	
				if(form.isChanged()){
				    if(operateType == 1){
				       //交易员2复核，数据校验
				       var activityDefID = nui.get("activityDefID").value;
				       if(activityDefID=='JYY2FH' && operateType == 1){
				       	 nui.alert("当前环节，不允许修改数据");
				       }else{
				       	 nui.alert("表单数据有修改,请选择'修改'操作");
				       }
				       return false;
				    }
				}
				onSubmit();
			 }
			 
			 function  onSubmit(){
			 	var operateType = nui.get("operateType").value;
			 	var reg = new RegExp("^^[0-9]+\.?[0-9]*$"); // /^[1-9]+[0-9]*]*$/
			 	var code = new RegExp("^^[A-Za-z0-9]+$");
			 	var numformat = /^\d{1,5}(\.\d{1,4})?$/; 
			 	var vcStockCode = nui.get("vcStockCode").value;
				var vcPaymentPlace = nui.get("vcPaymentPlace").value;
				var lStockInvestNo = nui.get("lStockInvestNo").value;
				var cMarketNo = nui.get("cMarketNo").value;
				var enPayInteval = nui.get("enPayInteval").value;
				var enIssueBalance = nui.get("enIssueBalance").value;
				var enExistLimite = nui.get("enExistLimite").value;
				var enFaceRate = nui.get("enFaceRate").value;
				var vcDeputyUnderwriterObj = nui.get("vcDeputyUnderwriter").getValue();
        	    var vcMainUnderwriterObj = nui.get("vcMainUnderwriter").getValue();
        	    var vcGuarantorNameObj = nui.get("vcGuarantorName").getValue();
        	    var vcGroupUnderwriterObj = nui.get("vcGroupUnderwriter").getValue();
        	    var enIssuerNetValue = nui.get("enIssuerNetValue").getValue();
        	    var vcMainUnderwriterIdObj=nui.get("vcMainUnderwriterId").getValue();
        	    var vcDeputyUnderwriterIdObj=nui.get("vcDeputyUnderwriterId").getValue();
        	    var vcGroupUnderwriterIdObj=nui.get("vcGroupUnderwriterId").getValue();
        	    nui.get("vcStockName").setValue(nui.get("vcStockName").getValue().replace(/\s+/g, ""));
        	    nui.get("vcStockNameFull").setValue(nui.get("vcStockNameFull").getValue().replace(/\s+/g, ""));
				if(enIssuerNetValue!=""){
					if(!reg.test(enIssuerNetValue)){
						nui.alert("公司净资产请输入数字!");
						return;
					}
				}
			 	if(operateType== 1 || operateType == 98){
			 		form.validate();	
					if (form.isValid() == false) {
						nui.alert("请检查必填项!");
						return;
					}
					if(vcStockCode!=""){
						if(!code.test(vcStockCode)){
							nui.alert("债券代码请输入字母数字！");
							return;
						}
						if(cMarketNo!="5"){//银行间
							if(vcStockCode.length>6){
								nui.alert("登记托管所为上交所深交所的时候债券代码不能超过6位！");
								return;
							}
						}else{
							if(vcStockCode.length>20){
								nui.alert("债券代码不能超过20位！");
								return;
							}
						}
					} 
					if(enPayInteval<-1){
						nui.alert("付息频率必须大于0且小于7位!");
						return;
					}
					if(enPayInteval==-1 || enPayInteval==null || enPayInteval==""){
					
					}else{
						if(!reg.test(enPayInteval)){
							nui.alert("付息频率请输入数字或者下拉框选择!");
							return;
						}
					}
					var length = enIssueBalance.split(".")[0].length;
					if(enIssueBalance<=0 || length>6){
						nui.alert("发行规模必须大于0且小于6位!");
						return;
					} 
					if(!reg.test(enIssueBalance)){
						nui.alert("发行规模请输入数字!");
						return;
					}
					length = enExistLimite.split(".")[0].length;
					if(enExistLimite<=0 || length>5){
						nui.alert("发行期限必须大于0且小于5位!");
						return;
					}
					if(!reg.test(enExistLimite)){
						nui.alert("发行期限请输入数字!");
						return;
					}
					length = enFaceRate.split(".")[0].length;
					if(enFaceRate!=""){
						if(!reg.test(enFaceRate) || length>6){
							nui.alert("票面利率请输入数字且小于6位!");
							return;
						}
					}
			 	}
			 	//执行完validate方法后，导致承销商的值没有了，先保存下来，等执行完validate后再赋值
			 	nui.get("vcDeputyUnderwriter").setValue(vcDeputyUnderwriterObj);
				nui.get("vcMainUnderwriter").setValue(vcMainUnderwriterObj);
				nui.get("vcGuarantorName").setValue(vcGuarantorNameObj);
				nui.get("vcGroupUnderwriter").setValue(vcGroupUnderwriterObj);
				nui.get("vcMainUnderwriterId").setValue(vcMainUnderwriterIdObj);
				nui.get("vcDeputyUnderwriterId").setValue(vcDeputyUnderwriterIdObj);
				nui.get("vcGroupUnderwriterId").setValue(vcGroupUnderwriterIdObj);
			 	var stockIssueInfo= getCheckStockIssueInfo();
				//校验数据不能为空
				if(stockIssueInfo==""){
					return;
				}
				
				//退办的时候，必须选择退办节点
				if(operateType==2){
					if(nui.get("backActivity").getText()==""){
						nui.alert("请选择退办节点!");
						return false;
					}
				}
				if(operateType==98){//交易员1进行修改的时候
					nui.ajax({
					    url: "com.cjhxfund.ats.fm.baseinfo.DebtIssueManager.checkDebtIssues.biz.ext",
					    type: "post",
					    data: {stockIssueInfo:stockIssueInfo,type:2,vcStockCode:vcStockCode,vcPaymentPlace:vcPaymentPlace,lStockInvestNo:lStockInvestNo},
					    dataType:"json",
					    success: function (text) {
						       form.unmask();//取消遮罩
						       flag = text.out;
						       if(text.out==false){
									nui.alert("当前债券已经存在.");
									return false;
						       }else{
						       		submitData();
						       }
					      	}
					});
				}else{
					submitData();
				}
			}
			function submitData(){
				if(nui.get("enFaceRate").getValue()==""){
		   			nui.get("enFaceRate").setValue("0");
		   		}
				var isSignObj = nui.get("isSign");
			    var isSign = "1";
			    if(isSignObj!=null){
			    	isSign = "0";
			    }
			    var operateType = nui.get("operateType").value;
				var dBidLimitTime = nui.get("dBidLimitTime");
					if(dBidLimitTime!=null){
					    var dApplicationDate = dBidLimitTime.text;
						var dApplicationHH=nui.get("dApplicationTimeHH").text;
						var dApplicationMM=nui.get("dApplicationTimeMM").text;
						var dApplicationTime1=dApplicationHH+":"+dApplicationMM+":00";
						var dDate=dApplicationDate+" "+dApplicationTime1;
						dBidLimitTime.setValue(dDate);
					}  
				var comments = nui.get("vcComments").value;
				    var activityDefID = nui.get("activityDefID").value;
				    var backActivity = nui.get("backActivity").value;
				    var lIssuePostDate = nui.get("lIssuePostDate").value;
				    var lIssueBeginDate = nui.get("lIssueBeginDate").value;
				    var lPublishDate = nui.get("lPublishDate").value;
				    var lEndincalDate = nui.get("lEndincalDate").value;
				    var lBegincalDate = nui.get("lBegincalDate").value;
				    var lNextExerciseDate = nui.get("lNextExerciseDate").value;
				    
				    var lPayDate = nui.get("lPayDate").value;
				    var approve = {vcComments:comments,vcActivityDefId:activityDefID};
					var data = {
						workItemID:'<%=workItemID %>',
						stockIssueInfo:form.getData(false,true).debtIssue,
						backActivity:backActivity,
						aprvinfo:approve,
						operateType:operateType,
						processInstID:pid,
						isSign:isSign,
						processType:processType,
						lIssuePostDate:lIssuePostDate,
						lIssueBeginDate:lIssueBeginDate,
						lPublishDate:lPublishDate,
						lEndincalDate:lEndincalDate,
						lBegincalDate:lBegincalDate,
						lNextExerciseDate:lNextExerciseDate,
						lPayDate:lPayDate
					};
				var json = nui.encode(data);
				var url = "com.cjhxfund.ats.fm.baseinfo.DebtIssueManager.approveDebtIssue.biz.ext";
				if(<%=processType %>=="4"){
					url = "com.cjhxfund.ats.fm.baseinfo.DebtIssueManager.approveDebtIssueMerge.biz.ext";
				}
				form.loading();//加载遮罩
				$.ajax({
					  url:url,
					  type:'POST',
					  data:json,
					  cache:false,
					  contentType:'text/json',
					  success:function(text){
					      var returnJson = nui.decode(text);
			              if(returnJson.exception == null && returnJson.status =="10"){
			                 nui.alert("流程提交成功","系统提示",function(action){
			                 	 //返回我的代办任务页面
					              //CloseWindow("confirmSuccess");
					              if (!!window.ActiveXObject || "ActiveXObject" in window){//如果是IE浏览器
					              	 window.opener.history.go(0);
					              }else{
					              	 window.opener.reloadData();
					              }
					              CloseWindow("confirmSuccess");//放在后面reloadData起刷新作用
			                 });
			                 
			              }else if(returnJson.status=="1"){
			              	nui.alert("流程已被别人操作领取。", "系统提示", function(action){
			                    if(action == "ok" || action == "close"){
			                       //CloseWindow("saveFailed");
			                    }
			                  });
			              }else{
			                 nui.alert("流程提交失败。", "系统提示", function(action){
			                    if(action == "ok" || action == "close"){
			                       //CloseWindow("saveFailed");
			                    }
			                  });
			               }
					     
					      }
					});
			}
				//获取校验债券的数据
		function getCheckStockIssueInfo(){
			//定义存储变量
			var stockIssueInfoEnt={};
			if(stockIssueInfoStr=="" || stockIssueInfoStr==null){
				nui.alert("没有获取到债券校验信息，请刷新！");
				return "";
			}else{
				var strs=stockIssueInfoStr.split(",");
				for(var i=0;i<strs.length;i++){
				//vc_issuer_name,vc_stock_name_full,vc_stock_type,en_exist_limite,en_issue_balance
				//,l_issue_begin_date,c_issue_appraise,vc_issue_property
					if(strs[i]=="vc_issuer_name_full"){
						//发行人
						var vcIssuerNameFull=nui.get("vcIssuerNameFull").getValue();
						stockIssueInfoEnt.vcIssuerNameFull=vcIssuerNameFull;
					}
					if(strs[i]=="vc_stock_name_full"){
						//债券全称
						var vcStockNameFull=nui.get("vcStockNameFull").getValue().replace(/\s+/g, "");
						stockIssueInfoEnt.vcStockNameFull=vcStockNameFull;
					}
					if(strs[i]=="vc_stock_name"){
						//债券全称
						var vcStockName=nui.get("vcStockName").getValue().replace(/\s+/g, "");
						stockIssueInfoEnt.vcStockName=vcStockName;
					}
					if(strs[i]=="vc_stock_type"){
						//债券类型
						var vcStockType=nui.get("vcStockType").getValue();
						stockIssueInfoEnt.vcStockType=vcStockType;
					}
					if(strs[i]=="en_exist_limite"){
						//发行期限
						var enExistLimite=nui.get("enExistLimite").getValue();
						stockIssueInfoEnt.enExistLimite=enExistLimite;
					}
					if(strs[i]=="en_issue_balance"){
						//发行额度
						var enIssueBalance=nui.get("enIssueBalance").getValue();
						stockIssueInfoEnt.enIssueBalance=enIssueBalance;
					}
					if(strs[i]=="l_issue_begin_date"){
						//发行日期
						var lIssueBeginDate=nui.get("lIssueBeginDate").getValue();
						lIssueBeginDate=getIntDate(lIssueBeginDate);
						stockIssueInfoEnt.lIssueBeginDate=lIssueBeginDate;
					}
					if(strs[i]=="c_issue_appraise"){
						//主体评级
						var cIssueAppraise=nui.get("cIssueAppraise").getValue();
						stockIssueInfoEnt.cIssueAppraise=cIssueAppraise;
					}
					if(strs[i]=="vc_issue_property"){
						//主体类型
						var vcIssueProperty=nui.get("vcIssueProperty").getValue();
						stockIssueInfoEnt.vcIssueProperty=vcIssueProperty;
					}
					var cMarketNo=nui.get("cMarketNo").getValue();
					stockIssueInfoEnt.cMarketNo=cMarketNo;
				}
				return stockIssueInfoEnt;
			}
		}
				function enterSumbit(e){  
				   issueInfoOnItemClick();
		 		}
 		
 			   function issueInfoOnItemClick(){
				 var lIssuerId = nui.get("lIssuerId").getValue();//发行人代码
				 if(lIssuerId!=null && lIssuerId!=""){
				      //
					  $.ajax({
						url:"com.cjhxfund.ats.fm.baseinfo.IssueInfoManager.getIssueInfoByID.biz.ext",
						type:'POST',
						data:nui.encode({id:lIssuerId}),
						cache:false,
						contentType:'text/json',
						success:function(text){
							var returnJson = nui.decode(text);
							if(returnJson.exception == null){
							    var issueInfo = returnJson.issueInfo;//投资产品信息（债券代码,债券名称,债券类别代码,债券评级代码,主体评级代码,评级机构代码）
							    //投资产品信息（债券代码,债券名称,债券类别代码,债券评级代码,主体评级代码,评级机构代码）
							    var vcIssueName = issueInfo.vcIssueName;
							    var vcIssueNameFull = issueInfo.vcIssueNameFull;
							    
							    var vcIssueProperty = issueInfo.vcIssueProperty;
							    var cIssueAppraise = issueInfo.cIssueAppraise;
							    var vcIssueAppraiseOrgan = issueInfo.vcIssueAppraiseOrgan;
							    var vcIndustry = issueInfo.vcIndustry;   //所属行业
							    var vcProvince = issueInfo.vcProvince;  //所属省份
								nui.get("vcIssuerName").setValue(vcIssueName);               //发行主体
								nui.get("vcIssuerNameFull").setValue(vcIssueNameFull);               //发行主体
								//nui.get("cIssueAppraise").setValue(cIssueAppraise);			  //主体评级
								//nui.get("vcIssueProperty").setValue(vcIssueProperty);	      //主体类型
								//nui.get("vcIssueAppraiseOrgan").setValue(vcIssueAppraiseOrgan);//主体评级机构
								//nui.get("vcIndustry").setValue(vcIndustry);			  //所属行业
								//nui.get("vcProvince").setValue(vcProvince);			  //所属省份
								//nui.get("vcBondAppraiseOrgan").setValue(vcBondAppraiseOrgan);
								
								
							}
						 }
					});
				  }
			
			
			}
		
		function backActivityChanged(){
			
			nui.get("vcComments").setValue( "退办 : " + "'"+ nui.get("backActivity").getText() +"'环节");
		}
		
			//取回退的活动实例
		function loadActivities(){
			var workItemID = '<%=workItemID %>';
			//var urlStr = context + "/com.cjhxfund.jy.process.wf.getRollBackActivitys.biz.ext";
	    	var json = nui.encode({processInstID:pid,workItemID:workItemID});
	    	$.ajax({
	            url:'com.cjhxfund.jy.process.wf.getRollBackActivitys.biz.ext',
	            data:json,
	            type:'POST',
	            contentType:'text/json',
	            cache:false,
	            success:function(d){
	            	if(d && d.activitys) {
	            		var data = d.activitys;
	            		var backActivityCombo = nui.get("backActivity");
	                	backActivityCombo.load(data);
	            	}
	            }
	       });
		}
		function check(obj){  
	       var reg = new RegExp("^^[0-9]+\.?[0-9]*$");  
		    if(!reg.test(obj.value)){  
		        nui.alert("请检查数据,该项只能输入数字!");  
		        return;
		    }  
	  }   
	  function checkCode(obj){
	  	var code = new RegExp("^^[A-Za-z0-9]+$"); ///^[0-9a-zA-Z]*$/g,/^[A-Za-z0-9]+$/
	  	if(obj.value!=""){
	  		if(!code.test(obj.value)){
				nui.alert("债券代码请输入字母数字！");
				return;
			}
	  	}
	  } 
	  function checkInt(obj,name){  
	       var reg = new RegExp("^[0-9]*[1-9][0-9]*$");  
		    if(!reg.test(obj.value)){ 
		        nui.alert("请检查数据,该项只能输入整数!");  
		        nui.get(name).setValue("");
		        return;
		    }  
	  }
	  function checkFXPL(obj){
	  	if(obj.value=="-1" || obj.value==""){
	  		
	  	}else{
	  		var reg = new RegExp("^^[0-9]+\.?[0-9]*$");  
		    if(!reg.test(obj.value) || obj.value.indexOf(" ") != -1){ 
		        nui.alert("请输入数字或者下拉框按钮选择，且不能包含空格，请检查!");  
		        return;
		    }
	  	}
	  }	
	  		//根据登记托管机构，获取交易市场和缴款方式
		 function onMarketNoChanged(e) {
		    var vcPaymentPlace = nui.get("vcPaymentPlace");
            var id = vcPaymentPlace.getValue();
            var cPayType = nui.get("cPayType").getValue();
            var cMarketNo = nui.get("cMarketNo").getValue();
            if(id=='03'){
	        	cMarketNo=1;//交易市场
	        	cPayType = "3";
	        }else if(id=='04'){
	        	cMarketNo=2;
	        	cPayType = "3";
	        }else if(id=='02'){//上海清算所
	        	cMarketNo=5;
	        	if(nui.get("vcStockType").getValue()=="D"){//同业存单
	        		cPayType = "3";
	        	}else{
	        		cPayType = "1";
	        	}
			}else if(id=='01'){
				cMarketNo=5;
				cPayType = "2";
			}else{
				cMarketNo=5;
	        	cPayType = "3";
			}
			nui.get("cMarketNo").setValue(cMarketNo);
			if(nui.get("cPayType").getValue() == ""){
        		nui.get("cPayType").setValue(cPayType);
        	}
        }
	  function onAddClick(){
	  	var url = "<%= request.getContextPath() %>/fm/baseinfo/issuerInfo/addIssuerInfo.jsp";
			var title = "新增发行主体";
			var width = "400";
			var height = "390";
			nui.open({
				url: url,
				title: title, width: width, height: height,
				onload: function () {//弹出页面加载完成
					
				},
				ondestroy: function (action) {//弹出页面关闭前,把新增的主体简称返回赋值给查询框
					keyText.setValue(action);
					keyText3.setValue(action);
					keyText4.setValue(action);
					keyText5.setValue(action);
					onSearchClick();
					onSearchClick3();
					onSearchClick4();
					onSearchClick5();
				}
			});
	  }
	  function beforenodeselect(e) {
            //禁止选中父节点
            if (e.isLeaf == false) e.cancel = true;
        	}
	   //国债A、政策银行债E1、央票C、地方债B，这些利率债的主体评级、债券评级、评级机构为非必填
        function cheangedVcStockType(e){
        	if(e.value=="A" || e.value=="B" || e.value=="C" || e.value=="E1"){
        		nui.get("cIssueAppraise").setRequired(false);
        		nui.get("cBondAppraise").setRequired(false);
        		nui.get("vcBondAppraiseOrgan").setRequired(false);
        		//删除红* ，必填样式
        		$(".requiredLable").find("label").hide();
        	}else{
        		//否则添加必填校验
        		nui.get("cIssueAppraise").setRequired(true);
        		nui.get("cBondAppraise").setRequired(true);
        		nui.get("vcBondAppraiseOrgan").setRequired(true);
        		$(".requiredLable").find("label").show();
        	}
        	//手工新增债券时如果是可交换债还需要录入  抵押股票代码、抵押股票数量
        	if(e.value=="Q" || e.value=="O"){
        		$("#morStockNameAndCode").show();
		        $("#morStockAmount").show();
        		nui.get("vcMortStockName").setRequired(true);
        		nui.get("vcMortStockAmount").setRequired(true);
        		nui.get("vcMortStockCode").setRequired(true);
        		$(".lableReq").find("label").show();
        	}else{
        		$("#morStockNameAndCode").hide();
		        $("#morStockAmount").hide();
        		nui.get("vcMortStockName").setRequired(false);
        		nui.get("vcMortStockAmount").setRequired(false);
        		nui.get("vcMortStockCode").setRequired(false);
        		$(".lableReq").find("label").hide();
        	}
        	onMarketNoChanged();
        }
        //付息方式可增加“利随本清”，并在“票息品种”为“一次还本付息券”或者“贴现券”时自动连动选择
	  function changeEnPayInteval(e){
	  	if(e.value=="1" || e.value=="3"){
	  		nui.get("enPayInteval").setValue("0");
	  		nui.get("enPayInteval").setReadOnly(true);//设置为不可选
	  	}else{
	  		nui.get("enPayInteval").setValue(null);
	  		nui.get("enPayInteval").setReadOnly(false);
	  	}
	  }
	  function checkCPayInterestType(e){
	  	if(e.value=="0"){
	  		if(nui.get("cPayInterestType").value != "1" || nui.get("cPayInterestType").value != "3"){
	  			nui.alert("付息频率为“利随本清”的时候，息票品种为“一次还本付息券”或者“贴现券”！");
	  			nui.get("cPayInterestType").setValue(null);
	  		}
	  	}
	  }
	   
		/* setTimeout("setTimeoutFunction()",1000);//页面加载防止并发问题
		function setTimeoutFunction(){
			//加载所属行业的证监会二级
			loadVcIssueAppraiseCsrcAll(vcIssueAppraiseCsrc);
			//加载所属行业
			loadVcIndustryAll(vcIndustry);
		} */
	     /* function loadVcIssueAppraiseCsrcAll(e){
	     	nui.ajax({//com.cjhxfund.ats.fm.baseinfo.IssueInfoManager.loadVcIssueAppraiseCsrc
			    url: "com.cjhxfund.ats.fm.baseinfo.IssueInfoManager.loadVcIssueAppraiseCsrc.biz.ext",
			    type: "post",
			    data:nui.encode({type:"1"}),
			    contentType:'text/json',
			    success: function (text) {
			    	nui.get("vcIssueAppraiseCsrc").loadList(text.data);
			    	nui.get("vcIssueAppraiseCsrc").setValue(e);
			    }
			});
	     }
	     function loadVcIndustryAll(e){
	     	nui.ajax({//com.cjhxfund.ats.fm.baseinfo.IssueInfoManager.loadVcIssueAppraiseCsrc
			    url: "com.cjhxfund.ats.fm.baseinfo.IssueInfoManager.loadVcIssueAppraiseCsrc.biz.ext",
			    type: "post",
			    data:nui.encode({type:"2"}),
			    contentType:'text/json',
			    success: function (text) {
			    	nui.get("vcIndustry").loadList(text.data);
			    	nui.get("vcIndustry").setValue(e);
			    }
			});
	     } */
	     function onSearchClickVcIssueA(){
	     	
	     	var items = this.findItems(nui.get("vcIssueAppraiseCsrc").getText());
	     	//alert(items);
		    if (!items || items.length == 0) {
		        e.errorText = "输入值不在下拉数据中";
		    }
	     }
	     function onSearchClickVcIndustry(){
	     	
	     	var items = this.findItems(nui.get("vcIndustry").getText());
	     	alert(items);
		    if (!items || items.length == 0) {
		        e.errorText = "输入值不在下拉数据中";
		    }
	     }
    </script>
   
</body>
</html>