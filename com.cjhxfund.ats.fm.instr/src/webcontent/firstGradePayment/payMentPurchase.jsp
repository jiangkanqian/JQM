
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<%@include file="/common/js/commscripts.jsp"%>

<!-- 
  - Author(s): 谢海光
  - Date: 2017-02-24 16:33:01
  - Description: 新债超市录入界面
-->
<head>
<title>分销缴款</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<script src="<%= request.getContextPath() %>/fm/instr/processUtil/instr.js" type="text/javascript"></script>
<script src="<%=request.getContextPath() %>/fm/instr/processUtil/process.js" type="text/javascript"></script>
<script type="text/javascript" src="<%= request.getContextPath() %>/riskMgr/js/riskMgrComm.js"></script>
<style type="text/css">
.td {
	border-bottom: 1px solid #D3D3D3;
}

.form_label label {
	color: red;
}

.form_label {
	text-align: right;
}

#footer {
	z-index: 999;
	position: fixed;
	bottom: 0;
	left: 0;
	width: 100%;
	_position: absolute;
	_top: expression_r(documentElement.scrollTop + 
		documentElement.clientHeight-this.offsetHeight);
	overflow: visible;
}

#dataform2 tr {
	border-top: 0px;
}
</style>
</head>
<body style="width: 100%; height: 100%; overflow: hidden;">
	<div id="layout1" class="nui-layout" style="width: 100%; height: 100%;">
		<div title="center">
			<div id="dataform1" style="padding-top: 5px;">
				<table style="width: 100%; table-layout: fixed;" border="0"
					class="nui-form-table">
					<tr>
						<td colspan="1" width="18%" class="form_label"><label>*</label>业务日期:
						</td>
						<td colspan="1" width="32%"><input style="width: 100%"
							class="nui-datepicker" id="bizprocess.dApplicationTime"
							name="bizprocess.dApplicationTime" format="yyyy-MM-dd"
							required="true" /></td>
						<td width="18%" class="form_label"><label>*</label>缴款日期:</td>
						<td width="32%"><input style="width: 100%"
							class="nui-datepicker" required="true"
							id="stockissueinfo.lPayDate" name="stockissueinfo.lPayDate"
							format="yyyy-MM-dd" /></td>
					</tr>
					<tr>
						<td colspan="1" class="form_label"><label>*</label>产品名称:</td>
						<td colspan="1"><input style="width: 100%;"
							id="productCombo" class="mini-combobox"
							name="applyInst.vcProductName" textField="TEXT" valueField="ID"
							showNullItem="false" required="true" allowInput="true"
							emptyText="请选择" onvalidation="onComboValidation"
							onvaluechanged="onProductChanged" /> <input class="nui-hidden"
							type="hidden" id="vcProductName" name="applyInst.vcProductName" />
							<input class="nui-hidden" type="hidden" id="vcProductCode"
							name="applyInst.vcProductCode" /> <!-- 指令类型--> <input
							class="nui-hidden" type="hidden" id="cApplyInstType"
							name="applyInst.cApplyInstType" /> <input class="nui-hidden"
							type="hidden" id="cApplyAuthStatus"
							name="applyInst.cApplyAuthStatus" /> <input class="nui-hidden"
							type="hidden" id="cPaymentAuthStatus"
							name="applyInst.cPaymentAuthStatus" /> <!-- 证券投资编号 --> <input
							class="nui-hidden" type="hidden" id="applyInst.lInvestNo"
							name="applyInst.lInvestNo" /> <input class="nui-hidden"
							type="hidden" id="applyInst.lStockInvestNo"
							name="applyInst.lStockInvestNo" /> <input class="nui-hidden"
							type="hidden" type="hidden" id="lStockInvestNo1"
							name="lStockInvestNo1" /> <input class="nui-hidden"
							type="hidden" id="stockissueinfo.lStockIssueId"
							name="stockissueinfo.lStockIssueId" readonly="readonly" /> <input
							class="nui-hidden" type="hidden"
							id="stockissueinfo.lStockInvestNo"
							name="stockissueinfo.lStockInvestNo" readonly="readonly" /> <!-- 存储报量临时数据 -->
							<input class="nui-hidden" type="hidden" id="report.vcReport"
							name="report.vcReport" value="0" readonly="readonly" /> <!-- 流程业务表 -->
							<input class="nui-hidden" type="hidden"
							id="bizprocess.lProcessInstId" name="bizprocess.lProcessInstId"
							readonly="readonly" /> <input class="nui-hidden" type="hidden"
							id="bizprocess.lBizId" name="bizprocess.lBizId"
							readonly="readonly" /></td>
						<td colspan="1" class="form_label"><label>*</label>组合名称:</td>
						<td colspan="1"><input style="width: 100%;" id="combiCombo"
							class="mini-combobox" name="applyInst.vcCombiNo" textField="TEXT"
							valueField="ID" value="cn" showNullItem="false" required="true"
							allowInput="true" emptyText="请选择"
							onvalidation="onComboValidation1" /> <!-- 组合信息 --> <input
							class="nui-hidden" type="hidden" id="lCombiId"
							name="applyInst.lCombiId" /> <input class="nui-hidden"
							type="hidden" id="vcCombiName" name="applyInst.vcCombiName" /> <!-- 资产单元 -->
							<input class="nui-hidden" type="hidden" id="lAssetId"
							name="applyInst.lAssetId" /> <input class="nui-hidden"
							type="hidden" id="vcAssetNo" name="applyInst.vcAssetNo" /> <input
							class="nui-hidden" type="hidden" id="vcAssetName"
							name="applyInst.vcAssetName" /> <input class="nui-hidden"
							type="hidden" id="enInterestRate" name="applyInst.enInterestRate" />
							<input class="nui-hidden" type="hidden" id="enInvestBalance"
							name="applyInst.enInvestBalance" /></td>
					</tr>
					<tr>
						<td colspan="1" class="form_label">债券代码:</td>
						<td colspan="1"><input style="width: 100%;"
							class="nui-textbox" id="stockissueinfo.vcStockCode"
							name="stockissueinfo.vcStockCode" /></td>
						<td width="18%" class="form_label"><label>*</label>债券简称:</td>
						<td width="32%"><input style="width: 70%;"
							class="nui-textbox" onvaluechanged="onStockNameFull"
							required="true" id="vcStockName"
							name="stockissueinfo.vcStockName" /> <a class='nui-button'
							plain='false' style="margin-left: 3px; margin-right: 3px;"
							id="queryStock" iconCls="icon-search" onclick="queryOpen()"></a>
							<a class='nui-button' plain='false' iconCls="icon-remove"
							id="cleanStock" onclick="stockIssueInfoClean()"></a></td>
					</tr>
					<tr>
						<td colspan="1" class="form_label"><label>*</label> 登记托管所机构:
						</td>
						<td colspan="1">
							<!-- 交易市场 根据托管机构查询债券，然后带出 --> <input class="nui-hidden"
							type="hidden" id="applyInst.cMarketNo" name="applyInst.cMarketNo" />
							<input style="width: 100%;" id="stockissueinfo.vcPaymentPlace"
							required="true" class="nui-dictcombobox"
							onvaluechanged="onVcPaymentPlace()"
							name="stockissueinfo.vcPaymentPlace" showNullItem="true"
							emptyText="---请选择---" nullItemText="---请选择---"
							dictTypeId="CF_JY_DJTGCS" />
						</td>
						<td colspan="1" class="form_label"><label>*</label>债券类别:</td>
						<td colspan="1"><input style="width: 100%;" id="vcStockType"
							name="stockissueinfo.vcStockType" class="mini-treeselect"
							multiSelect="false" textField="text" valueField="id"
							parentField="pid" checkRecursive="false"
							showFolderCheckBox="true" expandOnLoad="true"
							showTreeIcon="false" onbeforenodeselect="beforenodeselect"
							onvaluechanged="onAccountTypeChanged" popupWidth="200"
							required="true" /></td>
					</tr>
					<tr>
						<td colspan="1" class="form_label"><label id="lIssuerId_lab"
							style="display: none">*</label>发行主体:</td>
						<td colspan="1">
							<!--控件内容  开始--> <input id="lookup3" style="width: 100%"
							name="stockissueinfo.lIssuerId" class="mini-lookup"
							textField="vcIssueNameFull" valueField="lIssuerId"
							popupWidth="auto" popup="#gridPanel3" onvalidation="onIssuerId3"
							grid="#datagrid3" multiSelect="false"
							onclick="onClearClick3();onSearchClick3()" />

							<div id="gridPanel3" class="mini-panel" title="header"
								iconCls="icon-add" style="width: 450px; height: 250px;"
								showToolbar="true" showCloseButton="true" showHeader="false"
								bodyStyle="padding:0" borderStyle="border:0">
								<div property="toolbar"
									style="padding: 5px; padding-left: 8px; text-align: center;">
									<div style="float: left; padding-bottom: 2px;">
										<span>发行主体：</span> <input id="keyText3" class="mini-textbox"
											style="width: 160px;" onenter="onSearchClick3" /> <a
											class="mini-button" onclick="onSearchClick3">查询</a> <a
											class="mini-button" id="add" iconCls='icon-add'
											onclick="onAddClick3">添加</a> <a class="mini-button"
											id="cleanLookup3" onclick="cleanLookup3()">清空</a>
									</div>
									<div style="float: right; padding-bottom: 2px;"></div>
									<div style="clear: both;"></div>
								</div>
								<div id="datagrid3" class="mini-datagrid"
									style="width: 100%; height: 100%;" borderStyle="border:0"
									showPageSize="false" showPageIndex="false"
									url="com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.loadIssueInfo.biz.ext"
									onRowdblclick="onCloseClickLookup">
									<div property="columns">
										<div field="vcIssueName" width="80" headerAlign="center"
											allowSort="true">简称</div>
										<div field="vcIssueNameFull" width="120" headerAlign="center"
											allowSort="true">全称</div>
									</div>
								</div>
							</div> <!-- 控件内容  结束--> <input class="nui-hidden" type="hidden"
							id="vcIssuerName" name="stockissueinfo.vcIssuerName" /> <input
							class="nui-hidden" type="hidden" id="vcIndustry"
							name="stockissueinfo.vcIndustry" /> <input class="nui-hidden"
							type="hidden" id="vcProvince" name="stockissueinfo.vcProvince" />
							<input class="nui-hidden" type="hidden" id="vcIssuerNameFull"
							name="stockissueinfo.vcIssuerNameFull" />
						</td>
						<td colspan="1" class="form_label"><label
							id="vcStockNameFull_lab" style="display: none">*</label>债券全称:</td>
						<td colspan="1"><input style="width: 100%;"
							class="nui-textbox" id="vcStockNameFull"
							name="stockissueinfo.vcStockNameFull" /></td>

					</tr>
					<tr>
						<td colspan="1" class="form_label">发行日期:</td>
						<td colspan="1"><input style="width: 100%"
							class="nui-datepicker" id="stockissueinfo.lIssueBeginDate"
							name="stockissueinfo.lIssueBeginDate" format="yyyy-MM-dd" /></td>
						<td colspan="1" class="form_label"><label
							id="enIssueBalance_lab" style="display: none">*</label>发行规模(亿):</td>
						<td colspan="1"><input style="width: 100%;"
							class="nui-textbox" vtype="float" id="enIssueBalance"
							name="stockissueinfo.enIssueBalance" value="0" /></td>
					</tr>
				</table>
				<div id="panel2" class="mini-panel" title="缴款信息" iconCls="icon-edit"
					style="width: 100%;" showToolbar="true" showCollapseButton="true"
					showFooter="true" allowResize="false" collapseOnTitleClick="true">
					<table style="width: 100%; table-layout: fixed;" border="0"
						class="nui-form-table">
						<tr>
							<td colspan="1" width="18%" class="form_label"><label>*</label>缴款面值(万元):
							</td>
							<td colspan="1" width="32%"><input style="width: 100%;"
								class="nui-textbox" onvaluechanged="payVcBallotNumber()"
								required="true" id="enPayFaceValue"
								name="applyInst.enPayFaceValue" /></td>
							<td colspan="1" width="18%" class="form_label"><label>*</label>发行价格(元):
							</td>
							<td colspan="1" width="32%"><input style="width: 100%;"
								class="nui-textbox" vtype="float"
								onvaluechanged="payVcBallotPrice()" required="true"
								id="enBallotPrice" name="applyInst.enBallotPrice" /></td>
						</tr>
						<tr>
							<td colspan="1" width="15%" class="form_label"><label>*</label>缴款金额(万元):
							</td>
							<td colspan="1"><input style="width: 100%;"
								class="nui-textbox" required="true" id="enPaymentMoney"
								name="applyInst.enPaymentMoney" /></td>
							<td colspan="1" class="form_label"><label>*</label>票面利率(%):
							</td>
							<td colspan="1"><input style="width: 100%;"
								class="nui-textbox" vtype="float" required="true" id=enFaceRate
								name="stockissueinfo.enFaceRate" /></td>
						</tr>
						<tr>
							<td colspan="1" class="form_label"><label
								id="enPayInteval_lab" style="display: none">*</label>付息频率(次/年):
							</td>
							<td colspan="1"><input style="width: 100%;"
								id="enPayInteval" allowInput="true"
								name="stockissueinfo.enPayInteval" class="nui-dictcombobox"
								dictTypeId="ATS_CF_JY_FREQUENCY" showNullItem="true"
								emptyText="请选择" nullItemText="---请选择---" /></td>
								
							<td colspan="1" class="form_label"><label
								id="lBegincalDate_lab" style="display: none">*</label>计息起始日期:</td>
							<td colspan="1"><input style="width: 100%"
								class="nui-datepicker" id="stockissueinfo.lBegincalDate"
								onvaluechanged="countEnExistLimite()"
								name="stockissueinfo.lBegincalDate" format="yyyy-MM-dd" /></td>
						</tr>
						<tr>
							<td colspan="1" class="form_label"><label
								id="vcModeRepayment_lab" style="display: none">*</label>还本方式:</td>
							<td colspan="1"><input style="width: 100%;"
								id="vcModeRepayment" class="nui-dictcombobox"
								name="applyInst.vcModeRepayment"
								dictTypeId="CF_JY_MODE_REPAYMENT" showNullItem="true"
								emptyText="请选择" nullItemText="---请选择---" /></td>
							<td colspan="1" class="form_label"><label
								id="lEndincalDate_lab" style="display: none">*</label>到期日:</td>
							<td colspan="1"><input style="width: 100%"
								class="nui-datepicker" id="stockissueinfo.lEndincalDate"
								onvaluechanged="countEnExistLimite()"
								name="stockissueinfo.lEndincalDate" format="yyyy-MM-dd" /></td>
						</tr>
						<tr>
							<td colspan="1" width="15%" class="form_label"><label
								id="cPayType_lab" style="display: none">*</label>缴款方式：</td>
							<td colspan="1" width="35%"><input id="cPayType"
								style="width: 100%" class="nui-dictcombobox"
								name="stockissueinfo.cPayType" dictTypeId="ATS_FM_PAYMENT"
								showNullItem="true" emptyText="请选择" nullItemText="---请选择---"
								onvaluechanged="cheangedCpayType" /></td>
							<td colspan="1" width="15%" class="form_label"><label
								id="vcBene" style="display: none">*</label>收款人户名：</td>
							<td colspan="1" width="35%"><input class="nui-textbox"
								style="width: 100%" id="vcBeneficiary"
								name="applyInst.vcBeneficiary" /></td>
						</tr>
						<tr>
							<td colspan="1" class="form_label"><label id="vcBene1"
								style="display: none">*</label> 收款账号：</td>
							<td colspan="1"><input class="nui-textbox"
								style="width: 100%" id="vcCollectionAccount" vtype="int"
								name="applyInst.vcCollectionAccount" /></td>
							<td colspan="1" class="form_label">大额支付号：</td>
							<td colspan="1"><input class="nui-textbox"
								style="width: 100%" id="vcPayLine" name="applyInst.vcPayLine" />
							</td>
						</tr>
						<tr>
							<td colspan="1" width="15%" class="form_label">收款备注:</td>
							<td colspan="3"><input class="nui-textarea" width="60%"
								name="applyInst.vcReceivableRemark" /></td>

						</tr>
					</table>
				</div>
				<div id="panel3" class="mini-panel" title="债券详细" iconCls="icon-edit"
					style="width: 100%;" showToolbar="true" showCollapseButton="true"
					showFooter="true" allowResize="false" collapseOnTitleClick="true">
					<table style="width: 100%; table-layout: fixed;" border="0"
						class="nui-form-table">
						<tr>
							<td colspan="1" width="18%" class="form_label"><label
								id="vcMainUnderwriter_lab" style="display: none">*</label>主承销商:
							</td>
							<td colspan="3" width="82%">
								<!-- 控件开始 --> <input style="width: 95%;" class="nui-textbox"
								id="stockissueinfo.vcMainUnderwriter"
								name="stockissueinfo.vcMainUnderwriter" /> <input id="lookup2"
								style="width: 25px;" class="mini-lookup"
								textField="vcIssueNameFull" valueField="lIssuerId"
								popupWidth="auto" popup="#gridPanel2" onvalidation="onIssuerId2"
								allowInput="true" showNullItem="true" grid="#datagrid2"
								multiSelect="true" />

								<div id="gridPanel2" class="mini-panel" title="header"
									iconCls="icon-add" style="width: 450px; height: 250px;"
									showToolbar="true" showCloseButton="true" showHeader="false"
									bodyStyle="padding:0" borderStyle="border:0">
									<div property="toolbar"
										style="padding: 5px; padding-left: 8px; text-align: center;">
										<div style="float: left; padding-bottom: 2px;">
											<span>主承销商：</span> <input id="keyText2" class="mini-textbox"
												style="width: 160px;" onenter="onSearchClick2" /> <a
												class="mini-button" onclick="onSearchClick2">查询</a> <a
												class="mini-button" id="add" iconCls='icon-add'
												onclick="onAddClick2">添加</a>
										</div>
										<div style="float: right; padding-bottom: 2px;"></div>
										<div style="clear: both;"></div>
									</div>
									<div id="datagrid2" class="mini-datagrid"
										style="width: 100%; height: 100%;" borderStyle="border:0"
										showPageSize="false" showPageIndex="false"
										url="com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.loadIssueInfo.biz.ext"
										onRowdblclick="onCloseClickLookup">
										<div property="columns">
											<div type="checkcolumn"></div>
											<div field="vcIssueName" width="80" headerAlign="center"
												allowSort="true">简称</div>
											<div field="vcIssueNameFull" width="120" headerAlign="center"
												allowSort="true">全称</div>
										</div>
									</div>
								</div> <!-- 控件结束 --> <input class="nui-hidden" type="hidden"
								id="vcMainUnderwriterId"
								name="stockissueinfo.vcMainUnderwriterId" />
							</td>

						</tr>
						<tr>
						<tr>
							<td colspan="1" width="18%" class="form_label">副主承销商:</td>
							<td colspan="3" width="82%">
								<!-- 控件开始 --> <input style="width: 95%;" class="nui-textbox"
								id="stockissueinfo.vcDeputyUnderwriter"
								name="stockissueinfo.vcDeputyUnderwriter" /> <input id="lookup4"
								style="width: 25px;" class="mini-lookup"
								textField="vcIssueNameFull" valueField="lIssuerId"
								popupWidth="auto" popup="#gridPanel4" onvalidation="onIssuerId4"
								allowInput="true" showNullItem="true" grid="#datagrid4"
								multiSelect="true" />

								<div id="gridPanel4" class="mini-panel" title="header"
									iconCls="icon-add" style="width: 450px; height: 250px;"
									showToolbar="true" showCloseButton="true" showHeader="false"
									bodyStyle="padding:0" borderStyle="border:0">
									<div property="toolbar"
										style="padding: 5px; padding-left: 8px; text-align: center;">
										<div style="float: left; padding-bottom: 2px;">
											<span>副主承销商：</span> <input id="keyText4" class="mini-textbox"
												style="width: 160px;" onenter="onSearchClick4" /> <a
												class="mini-button" onclick="onSearchClick4">查询</a> <a
												class="mini-button" id="add" iconCls='icon-add'
												onclick="onAddClick4">添加</a>
										</div>
										<div style="float: right; padding-bottom: 2px;"></div>
										<div style="clear: both;"></div>
									</div>
									<div id="datagrid4" class="mini-datagrid"
										style="width: 100%; height: 100%;" borderStyle="border:0"
										showPageSize="false" showPageIndex="false"
										url="com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.loadIssueInfo.biz.ext"
										onRowdblclick="onCloseClickLookup">
										<div property="columns">
											<div type="checkcolumn"></div>
											<div field="vcIssueName" width="80" headerAlign="center"
												allowSort="true">简称</div>
											<div field="vcIssueNameFull" width="120" headerAlign="center"
												allowSort="true">全称</div>
										</div>
									</div>
								</div> <!-- 控件结束 --> <input class="nui-hidden" type="hidden"
								id="vcDeputyUnderwriterId"
								name="stockissueinfo.vcDeputyUnderwriterId" />
							</td>
						</tr>
						<tr>
						<tr>
							<td colspan="1" width="18%" class="form_label">承销团:</td>
							<td colspan="3" width="82%">
								<!-- 控件开始 --> <input style="width: 95%;" class="nui-textbox"
								id="stockissueinfo.vcGroupUnderwriter"
								name="stockissueinfo.vcGroupUnderwriter" /> <input id="lookup5"
								style="width: 25px;" class="mini-lookup"
								textField="vcIssueNameFull" valueField="lIssuerId"
								popupWidth="auto" popup="#gridPanel5" onvalidation="onIssuerId5"
								allowInput="true" showNullItem="true" grid="#datagrid5"
								multiSelect="true" />

								<div id="gridPanel5" class="mini-panel" title="header"
									iconCls="icon-add" style="width: 450px; height: 250px;"
									showToolbar="true" showCloseButton="true" showHeader="false"
									bodyStyle="padding:0" borderStyle="border:0">
									<div property="toolbar"
										style="padding: 5px; padding-left: 8px; text-align: center;">
										<div style="float: left; padding-bottom: 2px;">
											<span>承销团：</span> <input id="keyText5" class="mini-textbox"
												style="width: 160px;" onenter="onSearchClick5" /> <a
												class="mini-button" onclick="onSearchClick5">查询</a> <a
												class="mini-button" id="add" iconCls='icon-add'
												onclick="onAddClick5">添加</a>
										</div>
										<div style="float: right; padding-bottom: 2px;"></div>
										<div style="clear: both;"></div>
									</div>
									<div id="datagrid5" class="mini-datagrid"
										style="width: 100%; height: 100%;" borderStyle="border:0"
										showPageSize="false" showPageIndex="false"
										url="com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.loadIssueInfo.biz.ext"
										onRowdblclick="onCloseClickLookup">
										<div property="columns">
											<div type="checkcolumn"></div>
											<div field="vcIssueName" width="80" headerAlign="center"
												allowSort="true">简称</div>
											<div field="vcIssueNameFull" width="120" headerAlign="center"
												allowSort="true">全称</div>
										</div>
									</div>
								</div> <!-- 控件结束 -->
							</td>
						</tr>
						<tr>
							<td colspan="1" class="form_label">主体类型:</td>
							<td colspan="1"><input style="width: 100%;"
								id="vcIssueProperty" class="nui-dictcombobox"
								name="stockissueinfo.vcIssueProperty" showNullItem="true"
								emptyText="---请选择---" nullItemText="---请选择---"
								dictTypeId="ATS_FM_ISSUE_PROPERTY" /></td>
							<td colspan="1" class="form_label"><label id="hlRivalId_lab"
								style="display: none">*</label>交易对手:</td>
							<td colspan="1">
								<!--控件内容  开始--> <input class="nui-hidden" type="hidden"
								id="hlRivalId" name="applyInst.lRivalId" /> <input id="lookup1"
								style="width: 100%" name="applyInst.vcBusinessObject"
								class="mini-lookup" textField="vcAllName" valueField="lRivalId"
								popupWidth="auto" popup="#gridPanel1" onvalidation="onIssuerId1"
								grid="#datagrid1" multiSelect="false"
								onclick="onClearClick1();onSearchClick1()" />

								<div id="gridPanel1" class="mini-panel" title="header"
									iconCls="icon-add" style="width: 450px; height: 250px;"
									showToolbar="true" showCloseButton="true" showHeader="false"
									bodyStyle="padding:0" borderStyle="border:0">
									<div property="toolbar"
										style="padding: 5px; padding-left: 8px; text-align: center;">
										<div style="float: left; padding-bottom: 2px;">
											<span>交易对手：</span> <input id="keyText1" class="mini-textbox"
												style="width: 160px;" onenter="onSearchClick1" /> <a
												class="mini-button" onclick="onSearchClick1">查询</a> <a
												class="mini-button" id="add" iconCls='icon-add'
												onclick="onAddClick1">添加</a> <a class="mini-button"
												id="cleanLookup1" onclick="cleanLookup1()">清空</a>
										</div>
										<div style="float: right; padding-bottom: 2px;"></div>
										<div style="clear: both;"></div>
									</div>
									<div id="datagrid1" class="mini-datagrid"
										style="width: 100%; height: 100%;" borderStyle="border:0"
										showPageSize="false" showPageIndex="false"
										url="com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.LoadCounterpartyInfo.biz.ext"
										onRowdblclick="onCloseClickLookup">
										<div property="columns">
											<div field="vcName" width="80" headerAlign="center"
												allowSort="true">简称</div>
											<div field="vcAllName" width="120" headerAlign="center"
												allowSort="true">全称</div>
										</div>
									</div>
								</div> <!-- 控件内容  结束-->
							</td>
						</tr>
						<tr>
							<td colspan="1" class="form_label"><label
								id="cIssueAppraise_lab" style="display: none">*</label>主体评级:</td>
							<td colspan="1"><input style="width: 100%;"
								id="cIssueAppraise" class="nui-dictcombobox"
								name="stockissueinfo.cIssueAppraise" showNullItem="true"
								emptyText="---请选择---" nullItemText="---请选择---"
								dictTypeId="issuerRating" /></td>
							<td colspan="1" class="form_label"><label
								id="cBondAppraise_lab" style="display: none">*</label>债券评级:</td>
							<td colspan="1"><input style="width: 100%;"
								id="cBondAppraise" class="nui-dictcombobox"
								name="stockissueinfo.cBondAppraise" showNullItem="true"
								emptyText="---请选择---" nullItemText="---请选择---"
								dictTypeId="creditRating" /></td>
						</tr>
						<tr>
							<td colspan="1" class="form_label"><label
								id="vcIssueAppraiseOrgan_lab" style="display: none">*</label>主体评级机构:
							</td>
							<td colspan="1"><input style="width: 100%;"
								id="vcIssueAppraiseOrgan" class="nui-dictcombobox"
								name="stockissueinfo.vcIssueAppraiseOrgan" showNullItem="true"
								emptyText="---请选择---" nullItemText="---请选择---"
								dictTypeId="outRatingOrgan" /></td>
							<td colspan="1" class="form_label"><label
								id="vcBondAppraiseOrgan_lab" style="display: none">*</label>债券评级机构:
							</td>
							<td colspan="1"><input style="width: 100%;"
								id="vcBondAppraiseOrgan" class="nui-dictcombobox"
								name="stockissueinfo.vcBondAppraiseOrgan" showNullItem="true"
								emptyText="---请选择---" nullItemText="---请选择---"
								dictTypeId="outRatingOrgan" /></td>
						</tr>
						<tr>
							<td colspan="1" class="form_label">特殊条款:</td>
							<td colspan="1"><input style="width: 100%;"
								id="vcSpecialText" class="nui-dictcombobox"
								name="stockissueinfo.vcSpecialText"
								onvaluechanged="checkvcSpecialText" showNullItem="true"
								emptyText="---请选择---" nullItemText="---请选择---"
								dictTypeId="specialText" multiSelect="true" showClose="true"
								valueFromSelect="true" /></td>
							<td colspan="1" class="form_label"><label
								id="enExistLimite_lab" style="display: none">*</label>发行期限(年):</td>
							<td colspan="1"><input style="width: 100%;"
								class="nui-textbox" vtype="float" onvaluechanged="checkInt"
								id="enExistLimite" name="stockissueinfo.enExistLimite" value="0" />
							</td>
						</tr>
						<tr>
							<td colspan="1" class="form_label">特殊期限:</td>
							<td colspan="1"><input style="width: 100%;"
								class="nui-textbox" id="vcSpecialLimite"
								name="stockissueinfo.vcSpecialLimite" /></td>
							<td colspan="1" class="form_label">发行方式:</td>
							<td colspan="1"><input style="width: 100%;"
								id="vcIssueType" class="nui-dictcombobox"
								name="stockissueinfo.vcIssueType" showNullItem="true"
								emptyText="---请选择---" nullItemText="---请选择---"
								dictTypeId="issueType" /></td>
						</tr>
						<tr>
							<td colspan="1" class="form_label">下一利率跳升点数:</td>
							<td colspan="1"><input style="width: 100%;"
								onvaluechanged="checkInt" class="nui-textbox"
								id="lNInterestRateJumpPoints"
								name="stockissueinfo.lNInterestRateJumpPoints" vtype="float" />
							</td>
							<td width="18%" class="form_label">首次付息日:</td>
							<td width="32%"><input style="width: 100%"
								class="nui-datepicker" id="dInitInterestPaymentDate"
								name="applyInst.dInitInterestPaymentDate" format="yyyy-MM-dd" />
							</td>
						</tr>
						<tr>
							<td colspan="1" class="form_label">公司净资产（元）:</td>
							<td colspan="1"><input style="width: 100%;"
								class="nui-textbox" vtype="float" onvaluechanged="checkInt"
								id="enIssuerNetValue" name="stockissueinfo.enIssuerNetValue" />
							</td>
							<td colspan="1" class="form_label">城投行政级别:</td>
							<td colspan="1"><input style="width: 100%;"
								id="vcCityLevel" class="nui-dictcombobox"
								name="stockissueinfo.vcCityLevel" showNullItem="true"
								emptyText="---请选择---" nullItemText="---请选择---"
								dictTypeId="cityLevel" /></td>
						</tr>

						<tr id="mortInfo" style="display: none">
							<td colspan="1" class="form_label"><label>*</label>股票名称:</td>
							<td colspan="1"><input style="width: 100%;"
								class="nui-textbox" required="true" id="vcMortStockName"
								name="stockissueinfo.vcMortStockName" /></td>
							<td colspan="1" class="form_label"><label>*</label>股票代码:</td>
							<td colspan="1"><input style="width: 100%;"
								class="nui-textbox" required="true" id="vcMortStockCode"
								name="stockissueinfo.vcMortStockCode" /></td>
						</tr>
						
						
						
						<tr id="mortAmount" style="display: none">
							<td colspan="1" class="form_label"><label>*</label>股票抵押数量(万股):
							</td>
							<td colspan="1"><input style="width: 100%;"
								class="nui-textbox" required="true" id="vcMortStockAmount"
								vtype="float" onvaluechanged="checkInt"
								name="stockissueinfo.vcMortStockAmount" /></td>
							<td colspan="1" class="form_label">所属行业(证监会二级):</td>
							<td colspan="1">
								<!-- <input style="width: 100%;" class="nui-textbox" id="vcIssueAppraiseCsrc" name="stockissueinfo.vcIssueAppraiseCsrc" /> -->
								<input style="width: 100%;" id="vcIssueAppraiseCsrc"
								name="stockissueinfo.vcIssueAppraiseCsrc"
								class="mini-treeselect" multiSelect="false" textField="text"
								valueField="id" parentField="pid" checkRecursive="false"
								virtualScroll="true" expandOnLoad="true" showTreeIcon="false"
								showFolderCheckBox="true" allowInput="true" />
							</td>
						</tr>
						
						
						
						
						
						<tr>
							
							
							
							
							<td colspan="1" class="form_label">
							ABS类型:
						  </td>
						  <td colspan="1"  >
						  	<input style="width: 100%;" id="vcAbsType" class="mini-combobox" name="stockissueinfo.vcAbsType"   
						     showNullItem="true"  emptyText="---请选择---" nullItemText="---请选择---"   textField="text" valueField="id"/>
			                </td>
			                
			                  <td colspan="1" class="form_label">
				主体评级展望:
			  </td>
			  <td colspan="1"  >
			  	<input style="width: 100%;" id="vcIssueAppraiseProspect" class="nui-dictcombobox" name="stockissueinfo.vcIssueAppraiseProspect" 
			     showNullItem="true"  emptyText="---请选择---" nullItemText="---请选择---" dictTypeId="vcIssueAppraiseProspect" />
			  </td>
						
						</tr>
						
						
		
						
						
						
						<tr>
						
							<td colspan="1" class="form_label">是否具有回售权:</td>
							<td colspan="1">
								<div id="cIsHaveSaleback" name="stockissueinfo.cIsHaveSaleback"
									class="nui-dictradiogroup" value="0" dictTypeId="COF_YESORNO"></div>
							</td>
							
							<td colspan="1" class="form_label">是否具有赎回权:</td>
							<td colspan="1">
								<div id="cIsHaveBuyback" name="stockissueinfo.cIsHaveBuyback"
									class="nui-dictradiogroup" value="0" dictTypeId="COF_YESORNO"></div>
							</td>
							
						</tr>
						
						
						
							
			<tr>
			  <td colspan="1"  class="form_label">
				是否城投债:	 
			  </td>
			  <td colspan="1" class="radio-border-top-none">
			  	<div   value="0" onValueChanged="cIsHaveCityInvestmentBond" id="cIsHaveCityInvestmentBond" name="stockissueinfo.cIsHaveCityInvestmentBond" class="nui-dictradiogroup"  dictTypeId="COF_YESORNO" >
			   </td>
			  <td colspan="1"  class="form_label">
				是否担保债:	 
			  </td>
			  <td colspan="1" class="radio-border-top-none">
			    <div value="0" onValueChanged="cIsGuarantyBond" id="cIsGuarantyBond" name="stockissueinfo.cIsGuarantyBond" class="nui-dictradiogroup"  dictTypeId="COF_YESORNO" >
			  </td>
			</tr>
			
			
			<tr>
			  <td colspan="1"  class="form_label">
				是否次级债:	 
			  </td>
			  <td colspan="1" class="radio-border-top-none">
			  	<div   value="0" onValueChanged="cIsSubordinatedBond" id="cIsSubordinatedBond" name="stockissueinfo.cIsSubordinatedBond" class="nui-dictradiogroup"  dictTypeId="COF_YESORNO" >
			   </td>
			  <td colspan="1"  class="form_label">
				是否永续债:	 
			  </td>
			  <td colspan="1" class="radio-border-top-none">
			    <div value="0" onValueChanged="cIsPerpetualBond" id="cIsPerpetualBond" name="stockissueinfo.cIsPerpetualBond" class="nui-dictradiogroup"  dictTypeId="COF_YESORNO" >
			  </td>
			</tr>
			
			
						
						
						
						
						
						
						
						
						
						<tr>
							<td colspan="1" width="15%" class="form_label">备注:</td>
							<td colspan="3"><input class="nui-textarea" width="60%"
								name="applyInst.vcRemarks" /></td>

						</tr>

					</table>
					<table style="width: 100%; table-layout: fixed;" border="0"
						class="nui-form-table">
						<tr>
							<td width="215px" class="form_label" style="padding: 5px 5px;">
								已投资该发行主体债券存量(万元):</td>
							<td colspan="1" style="padding: 5px 0px;"><input
								class="nui-textbox" id="fsumamount"
								onvaluechanged="BondAccountedCalculation1()" /> <a
								class='nui-button' plain='false' style="margin-left: 0;"
								onclick="Calculation()" iconCls="icon-reload">刷新</a></td>

							<td width="230px" class="form_label" style="padding: 5px 5px;">
								产品净值规模(万元):</td>
							<td colspan="1" style="padding: 5px 0px;"><input
								class="nui-textbox" id="enNetScale" width="170px"
								onvaluechanged="BondAccountedCalculation1()" /></td>

						</tr>
						<tr>
							<td class="form_label" style="padding: 5px 5px;">
								该笔债券投资占发行规模比例(%):</td>
							<td colspan="1" style="padding: 5px 0px;"><input
								class="nui-textbox" id="enInvestScaleRatio"
								inputStyle="background-color:#f0f0f0;" readonly="readonly" /></td>
							<td class="form_label" style="padding: 5px 5px;">
								同一发行主体占产品净值规模比例(%):</td>
							<td colspan="1" style="padding: 5px 0px;"><input
								class="nui-textbox" id="enIssuerNetRatio" width="170px"
								inputStyle="background-color:#f0f0f0;" readonly="readonly" /></td>

						</tr>
						<tr>
							<td class="form_label" style="padding: 5px 5px;">
								该笔债券投资占产品净值规模比例(%):</td>
							<td colspan="1" style="padding: 5px 0px;"><input
								class="nui-textbox" id="enInvestNetRatio"
								inputStyle="background-color:#f0f0f0;" readonly="readonly" /></td>
							<td class="form_label" style="padding: 5px 5px;">
								弱流动性资产规模占产品净值规模比例(%):</td>
							<td colspan="1" style="padding: 5px 0px;"><input
								class="nui-textbox" id="enWeakNetRatio" width="170px"
								inputStyle="background-color:#f0f0f0;" readonly="readonly" /></td>
						</tr>
					</table>
				</div>

				<div title="报量信息">
					<div class="nui-toolbar"
						style="border-bottom: 0; padding: 0px; margin-top: 2px; height: 25px;">
						<table style="width: 100%;">
							<tr>
								<td style="width: 100%;">&nbsp;&nbsp;报量录入</td>
								<td><a class="nui-button " plain="false" iconCls="icon-add"
									onclick="gridAddRow('datagrid')" plain="false" tooltip="增加">
										&nbsp; </a></td>
								<td><a class="nui-button " plain="false"
									iconCls="icon-remove" onclick="gridRemoveRow('datagrid')"
									plain="false" tooltip="删除"> &nbsp; </a></td>
								<td><a class="nui-button " plain="false"
									iconCls="icon-reload" onclick="gridReload('datagrid')"
									plain="false" tooltip="刷新"> &nbsp; </a></td>
								<td><a class="nui-button " plain="false"
									iconCls="icon-help" onclick="showTips()" plain="false"
									tooltip="帮助"> &nbsp; </a></td>
							</tr>
						</table>
					</div>
					<div style="font-size: 10px; color: red;">
						<div
							style="width: 65%; float: left; padding-left: 10px; line-height: 30px;">
							<b>说明：</b>①报量为100万整数倍。②特殊说明请在报量说明中填写。③报价待定时为空即可。
						</div>
						<div
							style="width: 30%; float: right; padding-right: 10px; text-align: right; line-height: 30px;">
							报量方式：<input style="width: 140px;" id="reportType"
								name="applyInst.cReportType"
								url="<%= request.getContextPath() %>/fm/instr/processUtil/reportData.txt"
								class="nui-dictcombobox" />
						</div>
					</div>
					<div class="nui-datagrid" id="datagrid" url="" height="120px"
						showPager="false" allowSortColumn="false" allowCellSelect="true"
						allowCellEdit="true" multiSelect="true" allowCellValid="true"
						oncellvalidation="reportEdit">
						<div property="columns">
							<div field="enReport" headerAlign="center" allowSort="true">
								报量(万元) <input id="enReport" class="nui-textbox" name="enReport"
									property="editor" />
							</div>
							<div field="enOffer" headerAlign="center" allowSort="true">
								报价(%) <input id="enOffer" class="nui-textbox" name="enOffer"
									property="editor" />
							</div>
							<div field="vcReportRemark" headerAlign="center" allowSort="true">
								报量说明 <input id="vcReportRemark" class="nui-textbox"
									name="vcReportRemark" property="editor" />
							</div>
						</div>
					</div>
				</div>
				<table style="width: 100%; table-layout: fixed; margin-top: 2px;"
					border="0" class="nui-form-table">
					<tr>
						<td class="form_label td" align="right" width="15%">附件上传:</td>
						<td colspan="3" class="td"><iframe id="prodIfm" width="590"
								height="130px" frameborder="no" border="0" marginwidth="0"
								marginheight="0" scolling="no"></iframe></td>
					</tr>
				</table>
				<div id="attachmentListShow">
					<div style="margin-top: 10px">
						<privilege:operation sourceId="ATS_JYGL_ZXBJ" sid="editorFile"
							clazz="nui-button" onClick="myEditorFile()" lableName="编辑文档"
							iconCls="icon-edit"></privilege:operation>
						<privilege:operation sourceId="ATS_JYGL_ZXBJ" sid="generateFile"
							clazz="nui-button" onClick="generatePurchaseOrder()"
							lableName="生成申购函" iconCls="icon-add"></privilege:operation>
						<label style="color: red; margin-left: 50px;">发送传真时请"勾选"需要传真的附件</label>
					</div>

					<div id="file_Form">
						<input class="nui-hidden" id="mapBizId" name="map/bizId" value="" />
						<input class="nui-hidden" id="mapAttachBusType"
							name="map/attachBusType" value="1" />
					</div>
					<!-- 附件用印 -->
					<div id="file_grid" class="mini-datagrid"
						style="width: 100%; height: 150px;"
						url="com.cjhxfund.ats.fm.comm.attachUitlFunction.queryProcrssAttachment.biz.ext"
						showPager="false" dataField="attachments" pageSize="50"
						showPageInfo="fase" multiSelect="true" allowSortColumn="false"
						allowCellEdit="true">
						<div property="columns">
							<div type="checkcolumn" width="20"></div>
							<div field="lAttachId" headerAlign="center" visible="false">编号</div>
							<div field="vcAttachName" headerAlign="center"
								style="width: 70%;" allowSort="true">文件名</div>
							<div field="vcAnnexSeal" type="checkboxcolumn" trueValue="1"
								falseValue="0" width="30" headerAlign="center">是否用印</div>
							<div field="vcWhetherIndia" type="checkboxcolumn" trueValue="1"
								falseValue="0" width="40" headerAlign="center" readOnly="true">是否用过印</div>
							<div field="cWhetherArchiving" type="checkboxcolumn"
								trueValue="1" falseValue="0" width="40" headerAlign="center">是否需要归档</div>
						</div>
					</div>
				</div>
				<div style="height: 30px;">&nbsp;</div>
			</div>
		</div>
		<!-- 投资范围 -->
		<!-- 居右east，据左west -->
		<div title="投资范围" region="east" width="220" showCloseButton="false"
			showSplitIcon="true">
			<div id="dataform2">
				<!-- hidden域 -->
				<input type="hidden" class="nui-hidden"
					name="cfjyProductInvestRange.productid" />
				<table style="width: 100%; height: 100%; table-layout: fixed;"
					class="nui-form-table">
					<tr>
						<td colspan="3">产品名称： <input class="nui-textbox" width="100%"
							inputStyle="background-color:#f0f0f0;"
							name="ProductInvestRange.combProductName" readonly />
						</td>
					</tr>
					<tr>
						<td colspan="3">可投范围： <input class="nui-textarea"
							width="100%" height="120" name="ProductInvestRange.voteRange"
							inputStyle="background-color:#f0f0f0;" readonly />
						</td>
					</tr>
					<tr>
						<td colspan="3">禁投范围： <input class="nui-textarea"
							width="100%" height="120" name="ProductInvestRange.noCastRange"
							inputStyle="background-color:#f0f0f0;" readonly />
						</td>
					</tr>
					<tr>
						<td colspan="3">投资限制： <input class="nui-textarea"
							width="100%" height="120"
							name="ProductInvestRange.investmentLimit"
							inputStyle="background-color:#f0f0f0;" readonly />
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>

	<div style="height: 50px;">&nbsp;</div>
	<div id="footer" class="nui-toolbar" style="padding: 0px;"
		borderStyle="border:0;">
		<table width="100%">
			<tr>
				<td style="text-align: center;" colspan="4"><a
					class='nui-button' plain='false' iconCls="icon-save"
					onclick="onOk()"> 保存 </a> <span
					style="display: inline-block; width: 25px;"></span> <a
					id="windControlTrial" style="display: none" class='nui-button'
					plain='false' iconCls="icon-save" onclick="windControlTrial()">
						风控试算 </a> <span style="display: inline-block; width: 25px;"></span> <a
					class='nui-button' plain='false' iconCls="icon-cancel"
					onclick="onCancel()"> 取消 </a></td>
			</tr>
		</table>
	</div>
	<!--隐藏表单-->
	<form action="" name="openForm" method="post" target="_blank">
		<input type="hidden" name="workItemID" id="workItemID"> 
		<input type="hidden" name="processInstID" id="processinstid"> 
		<input  type="hidden" name="bizId" id="bizId1"> 
		<input type="hidden"  name="processType" id="processType" value="8"> 
		<input type="hidden" name="stockInvestNo" id="stockInvestNo"> 
		<input type="hidden" name="pageType" id="pageType" value="1" />
		
		<input type="hidden" name="pageType" id="pageType" value="1" />
		
	</form>

	<script type="text/javascript">
    	nui.parse();
    	var grid = nui.get("datagrid");
    	var processInstID="<%=request.getParameter("processInstID")%>";
    	
    	console.log(processInstID);
		var blgrid = nui.get(datagrid);
		blgrid.addRows([ {}, {}, {} ]);//默认添加3行
		var generateFileSwitch = false;
		var grid1 = mini.get("datagrid1");
		var grid2 = mini.get("datagrid2");
		var grid3 = mini.get("datagrid3");
		var grid4 = mini.get("datagrid4");
		var grid5 = mini.get("datagrid5");
        var keyText1 = mini.get("keyText1");
        var keyText2 = mini.get("keyText2");
        var keyText3 = mini.get("keyText3");
        var keyText4 = mini.get("keyText4");
        var keyText5 = mini.get("keyText5");
        //grid1.load();
		grid2.load();
		//grid3.load();
		grid4.load();
		grid5.load();
		
		var biztype=2; //默认有债券缴款
		//查询发行人
        function onSearchClick1(e) {
            grid1.load({
                key: keyText1.value
            });
        }
        function onSearchClick2(e) {
            grid2.load({
                key: keyText2.value
            });
        }
        function onSearchClick3(e) {
            grid3.load({
                key: keyText3.value
            });
        }
        function onSearchClick4(e) {
            grid4.load({
                key: keyText4.value
            });
        }
        function onSearchClick5(e) {
            grid5.load({
                key: keyText5.value
            });
        }
        function cleanLookup3() {
            nui.get("keyText3").setValue("");
            nui.get("lookup3").setValue("");
           	nui.get("lookup3").setText("");
        }
        function cleanLookup1() {
            nui.get("keyText1").setValue("");
            nui.get("lookup1").setValue("");
           	nui.get("lookup1").setText("");
        }
        function onCloseClickLookup(e) {
            var lookup1 = mini.get("lookup1");
            lookup1.hidePopup();
            var lookup2 = mini.get("lookup2");
            lookup2.hidePopup();
            var lookup3 = mini.get("lookup3");
            lookup3.hidePopup();
            var lookup4 = mini.get("lookup4");
            lookup4.hidePopup();
            var lookup5 = mini.get("lookup5");
            lookup5.hidePopup();
        }
        function onIssuerId2(e){	
        	nui.get("stockissueinfo.vcMainUnderwriter").setValue(e.source.text);
        	var vcMainUnderwriterId2= nui.get("lookup2").getValue();
        	nui.get("vcMainUnderwriterId").setValue(vcMainUnderwriterId2);
        }
        function onIssuerId4(e){
        	nui.get("stockissueinfo.vcDeputyUnderwriter").setValue(e.source.text);
        	var vcMainUnderwriterId4= nui.get("lookup4").getValue();
        	nui.get("vcDeputyUnderwriterId").setValue(vcMainUnderwriterId4);
        }
        function onIssuerId5(e){
        	nui.get("stockissueinfo.vcGroupUnderwriter").setValue(e.source.text);
        }
        function onClearClick3(e) {
             //修改为情况查询条件
            nui.get("keyText3").setValue("");
        }
        function onClearClick2(e) {
             //修改为情况查询条件
            nui.get("keyText2").setValue("");
        }
        function onClearClick1(e) {
             //修改为情况查询条件
            nui.get("keyText1").setValue("");
        }
        var IssueronCkData=new Array();//发行人选中的历史数据
		//控制 发行人限制输入
		function onIssuerId3(e){
			var dataIssuer=grid3.data;
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
        			//回填发行人信息
        			nui.get("vcIssuerName").setValue(dataIssuer[i].vcIssueName);
        			nui.get("vcIssueProperty").setValue(dataIssuer[i].vcIssueProperty);
        			nui.get("vcIndustry").setValue(dataIssuer[i].vcIndustry);
        			nui.get("vcProvince").setValue(dataIssuer[i].vcProvince);
        			nui.get("vcIssuerNameFull").setValue(dataIssuer[i].vcIssueNameFull);

        		}
        	}
          
		}

		//交易对手赋值
		function onIssuerId1(e){
			nui.get("hlRivalId").setValue(e.value);
			nui.get("lookup1").setValue(e.source.text);
		}
		
		var productCombo = mini.get("productCombo");
		var combiCombo = mini.get("combiCombo");
		//产品下拉改变事件		
		function onProductChanged(e) {
			var vcProductCode = productCombo.getValue();
			var url = "com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.queryCombiInfo.biz.ext?vcProductCode="+ vcProductCode;

			var cManageType = e.selected.C_MANAGE_TYPE;
			if(checkrole!= "2"){
				if(cManageType != null && cManageType != "" && cManageType == "0"){
					url = "com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.queryCombiInfoByManageType.biz.ext?vcProductCode="
					+ vcProductCode;
					nui.get("cApplyInstType").setValue("4");
				}else{
					nui.get("cApplyAuthStatus").setValue("1");
					nui.get("cPaymentAuthStatus").setValue("3");
					nui.get("cApplyInstType").setValue("3");
				}
			}
			combiCombo.setValue("");

			combiCombo.setUrl(url);

			combiCombo.select(0);
			//设置投资范围界面参数
			//nui.get("tabs").tabs[1].url = "<%=request.getContextPath() %>/fm/comm/ProductInvestmentRange.jsp?vcProductCode="+vcProductCode;
            //因参数改变重新tabs
            //nui.get("tabs").reloadTab(nui.get("tabs").tabs[1]);
            //装载组合相关信息
            var com=nui.get("combiCombo").getSelected();
            var data=nui.get("combiCombo").data;
        	//获取选中产品的其他数据
        	for(var i=0;i<data.length;i++){
        		//查找选中的数据
        		if(data[i].ID==com.ID){
        			//产品组合
        			nui.get("lCombiId").setValue(data[i].L_COMBI_ID);
        			nui.get("vcCombiName").setValue(data[i].VC_COMBI_NAME);
        			
        			//资产单元
        			nui.get("lAssetId").setValue(data[i].L_ASSET_ID);
        			nui.get("vcAssetNo").setValue(data[i].VC_ASSET_NO);
	        		nui.get("vcAssetName").setValue(data[i].VC_ASSET_NAME);
        		}
        	}
        	//查询、填充投资范围
        	Init(vcProductCode);
        }
        
        //报量值改变计算分控比例 
        function Calculation(){
        	//查询净值规模和发行存量 
        	queryScaleDaet();
        }
        //查询净值规模和发行存量 
        function queryScaleDaet(){
        	var vcProductCode = productCombo.getValue();
        	if(vcProductCode=="" || vcProductCode==null){
        	    nui.alert("产品名称为空，请选择产品！");
				return;
        	}
        	var lIssuerId =  nui.get("lookup3").getValue();
        	if(lIssuerId=="" || lIssuerId==null){
        	    nui.alert("发行主体为空，请选择发行主体！");
				return;
        	}
        	var json = nui.encode({vcProductCode : vcProductCode,lIssuerId : lIssuerId});

	        $.ajax({
	            url:"com.cjhxfund.ats.fm.instr.atsFmBiz.getVfundasset.biz.ext",
	            type:'POST',
	            data:json,
	            cache:false,
	            async:false,
	            contentType:'text/json',
	            success:function(text){
	                var returnJson = nui.decode(text);
	                if(returnJson.returnCode != 1){
		                if(null == returnJson.enFundValue[0].ENFUNDVALUE){
		                	nui.get("enNetScale").setValue(0);
		                }else{
		                	nui.get("enNetScale").setValue(returnJson.enFundValue[0].ENFUNDVALUE/10000);
		                	formatNumberCommon("enNetScale",4);
		                }
		                if(null == returnJson.fsumamount[0].FSUMAMOUNT){
		                	nui.get("fsumamount").setValue(0);
		                }else{
		                	nui.get("fsumamount").setValue(returnJson.fsumamount[0].FSUMAMOUNT);
		                }
	               }else{
	                   nui.get("enNetScale").setValue(0);
	                   nui.get("fsumamount").setValue(0);
	               }
	               BondAccountedCalculation1();
	           }
			});
        }
        
        //人工风控控制计算比例值
		function BondAccountedCalculation1(){
			var enIssueBalance = nui.get("enIssueBalance").getValue().replace(/,/gi,'');        //发行规模
			
			var form = new mini.Form("#dataform1");
			
			var vcMainUnderwriter=nui.get("stockissueinfo.vcMainUnderwriter").getValue();
			var vcDeputyUnderwriter=nui.get("stockissueinfo.vcDeputyUnderwriter").getValue();
			var vcGroupUnderwriter=nui.get("stockissueinfo.vcGroupUnderwriter").getValue();
			var vcMainUnderwriterId=nui.get("vcMainUnderwriterId").getValue();
			var vcDeputyUnderwriterId=nui.get("vcDeputyUnderwriterId").getValue();
			var hlRivalId=nui.get("hlRivalId").getValue();
			form.validate();
			    nui.get("stockissueinfo.vcMainUnderwriter").setValue(vcMainUnderwriter);
			    nui.get("stockissueinfo.vcDeputyUnderwriter").setValue(vcDeputyUnderwriter);
			    nui.get("stockissueinfo.vcGroupUnderwriter").setValue(vcGroupUnderwriter);
		    nui.get("vcMainUnderwriterId").setValue(vcMainUnderwriterId);
			nui.get("vcDeputyUnderwriterId").setValue(vcDeputyUnderwriterId);
			nui.get("hlRivalId").setValue(hlRivalId);
			if(form.isValid() == false){
				nui.alert("有数据为空或填写不正确，请确认！");
				return;
			}
			
		    var enInvestBalance = nui.get("enPayFaceValue").getValue().replace(/,/gi,'');  	    //缴款面值		   
		    var enNetScale = nui.get("enNetScale").getValue().replace(/,/gi,'');  				//净值规模
		    var enCategoryMoney = nui.get("fsumamount").getValue().replace(/,/gi,'');      		//债券存量		
		    formatNumberCommon("enNetScale",4);  //加入千分位
		    formatNumberCommon("fsumamount",4);  //加入千分位
		    //当发行规模与缴款面值不为空并且不为0时计算该笔债券投资占发行规模比例
			//公式为缴款面值/发行规模
			if(enIssueBalance != "" && enInvestBalance != "" && enIssueBalance != 0 && enInvestBalance != 0){
			   nui.get("enInvestScaleRatio").setValue(((enInvestBalance/(enIssueBalance * 10000)) * 100).toFixed(6));
			}else{
			   nui.get("enInvestScaleRatio").setValue(0);
			}
			       
			//当缴款面值、债券存量与净值规模都不为空并且都不为0时计算同一发行人占产品净值规模比例
			//公式为(本次缴款面值+主体发行债券存量)/净值规模
			if(enNetScale != "" && (enInvestBalance != "" || enCategoryMoney != "")){
			    if(enNetScale != 0){
			       nui.get("enIssuerNetRatio").setValue((((Number(enInvestBalance) + Number(enCategoryMoney))/enNetScale) * 100).toFixed(6));
			    }
			}else{
			   nui.get("enIssuerNetRatio").setValue(0);
			}
			       
			//当净值规模与缴款面值不为空并且不为0时计算该笔债券投资占产品净值规模比例
			//公式为缴款面值/净值规模
			if(enNetScale != "" && enInvestBalance != "" && enNetScale !=0 && enInvestBalance != 0){
			   nui.get("enInvestNetRatio").setValue(((enInvestBalance/enNetScale) * 100).toFixed(6));
			}else{
			   nui.get("enInvestNetRatio").setValue(0);
			}	
		}
        
        //查询投资范围
        function Init(vcProductCode){
            var json = nui.encode({vcProductCode : vcProductCode});

	        $.ajax({
	            url:"com.cjhxfund.ats.fm.comm.common.expandProductInvestRange.biz.ext",
	            type:'POST',
	            data:json,
	            cache:false,
	            contentType:'text/json',
	            success:function(text){
	                var returnJson = nui.decode(text);
	                var form = new nui.Form("#dataform2");//将普通form转为nui的form
	                    form.setData(returnJson);
	                   	form.setChanged(false);
	           }
			});
        }
        //控制 产品限制输入
		function onComboValidation(e){
			var items = this.findItems(e.value);
            if (!items || items.length == 0) {
                e.isValid = false;
                e.errorText = "输入值不在下拉数据中";
            }else{
            	//设置申购相关产品信息
            	var data=e.source.data;
            	//获取选中产品的其他数据
            	for(var i=0;i<data.length;i++){
            		//查找选中的数据
            		if(data[i].ID==e.value){
            			nui.get("vcProductCode").setValue(data[i].VC_PRODUCT_CODE);
            			nui.get("vcProductName").setValue(data[i].VC_PRODUCT_NAME);
            		}
            	}
            }
		}
		//限制组合输入
		function onComboValidation1(e){
			var items = this.findItems(e.value);
            if (!items || items.length == 0) {
                e.isValid = false;
                e.errorText = "输入值不在下拉数据中";
            }else{
            	//设置申购相关产品信息
            	
            	
            	var data=e.source.data;
            	//获取选中产品的其他数据
            	for(var i=0;i<data.length;i++){
            		//查找选中的数据
            		if(data[i].ID==e.value){
            			//产品组合
            			nui.get("lCombiId").setValue(data[i].L_COMBI_ID);
            			nui.get("vcCombiName").setValue(data[i].VC_COMBI_NAME);
            			//资产单元
	        			nui.get("lAssetId").setValue(data[i].L_ASSET_ID);
	        			nui.get("vcAssetNo").setValue(data[i].VC_ASSET_NO);
	        			nui.get("vcAssetName").setValue(data[i].VC_ASSET_NAME);
            		}
            	}
            }
		}
		
		//登记机构改变事件
		function onVcPaymentPlace(){
			var place=nui.get("stockissueinfo.vcPaymentPlace").getValue();
			var code=nui.get("stockissueinfo.vcStockCode").getValue();
			var vcStockType = nui.get("vcStockType").getValue();
			var cMarketNo="";//交易场所
			//将等级机构转为交易场所
	        if(place=="03"){
	        	cMarketNo=1;
	        }else if(place=="04"){
	        	cMarketNo=2;
	        }else{
	        	cMarketNo=5;
	        }
	        //将登记场所转换为交易场所 赋值 到交易场所
	        nui.get("applyInst.cMarketNo").setValue(cMarketNo);
	        
			if(place!="" && cMarketNo!=5 && code!=""){
				var skReadOnly = nui.get("stockissueinfo.vcStockCode").readOnly;
				//禁用状态不提示
				if(skReadOnly != "true"){
					return true;
				}
				if(code.length>6){
					nui.alert("当前债券代码大于超6位，不能再该登记托管机构下！");
					return false;
				}
			}
			if("D"==vcStockType && "02" ==place){
				nui.get("cPayType").setValue(3);
			}else if(place=="01"){
			  //中央结算公司cPayType
			  nui.get("cPayType").setValue(2);
			}else if(place=="02"){
			  //上海清算所
			  nui.get("cPayType").setValue(1);
			}else{
			  nui.get("cPayType").setValue(3);
			}
			cheangedCpayType();
		}
		//缴款方式为银行汇款时,收款人为必填
         function cheangedCpayType(){
        	var cPayType=nui.get("cPayType").getValue();
        	//纸质指令收款人和收款账号必填
        	if(cPayType=="3"){
        	    //否则添加必填校验
        		nui.get("vcBeneficiary").setRequired(true);
        		document.getElementById( "vcBene").style.display= "";  
        		nui.get("vcCollectionAccount").setRequired(true);
        		document.getElementById( "vcBene1").style.display= "";  
        	}else{
        		nui.get("vcBeneficiary").setRequired(false);
        		document.getElementById( "vcBene").style.display= "none"; 
        		nui.get("vcCollectionAccount").setRequired(false);
        		document.getElementById( "vcBene1").style.display= "none";   
        	}
        } 
		//债券类型改变事件
		function onStockType(sibk){
			var lStockIssueId=nui.get("stockissueinfo.lStockIssueId").getValue();
			//交易债券是否存在
			nui.ajax({
			    url: "com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.checkStockIssueInfo.biz.ext",
			    type: "post",
			    data: {
			    	vcStockCode:nui.get("stockissueinfo.vcStockCode").getValue(),
    				cMarketNo:nui.get("applyInst.cMarketNo").getValue(),
			    	lStockIssueId:lStockIssueId,lStockInvestNo:nui.get("stockissueinfo.lStockInvestNo").getValue()},
			    dataType:"json",
			    success: function (text) {
			       if(text.out==false){
			       		nui.confirm("当前债券已经存在多条，是否继续提交！","缴款提醒",function(action){
			       			if(action == "ok"){
			       				//回调提交方法
			       				applySubmit();
			       			}
			       		});
			       		return false;
			       }else{
			       		//判定是否需要回调
			       		if(sibk!=0){
			       			//回调提交方法
			       			applySubmit();
			       		}
			       		return true;
			       }
			       
			    }
			});
			return false;
		}
		
		
		var bizId;
		//有债券缴款跨页面参数传递参数
		function setFormDataPayMent(data){
    	    //跨页面传递的数据对象，克隆后才可以安全使用
	   		var infos = nui.clone(data);
	   		var data = {StockIssueId:infos.lStockIssueId};
	   		
			var json = nui.encode(data);
			$.ajax({
				url:"com.cjhxfund.ats.fm.instr.firstGradePayment.loadApplyInstBizPay.biz.ext",
				type:'POST',
				data:json,
				cache:false,
				contentType:'text/json',
				success:function(text){ 
					var returnJson = nui.decode(text);
					var form = new nui.Form("#dataform1");//将普通form转为nui的form
					
					form.setData(returnJson);
					form.setChanged(false);
					//发行日期，缴款日期
					var lIssueBeginDate=returnJson.stockissueinfo.lIssueBeginDate;
				    nui.get("stockissueinfo.lIssueBeginDate").setValue(dateTemp(lIssueBeginDate));
				    var lPayDate=returnJson.stockissueinfo.lPayDate;
				    nui.get("stockissueinfo.lPayDate").setValue(dateTemp(lPayDate));
				    var lBegincalDate=returnJson.stockissueinfo.lBegincalDate;
				    nui.get("stockissueinfo.lBegincalDate").setValue(dateTemp(lBegincalDate));
				    var lEndincalDate=returnJson.stockissueinfo.lEndincalDate;
				    nui.get("stockissueinfo.lEndincalDate").setValue(dateTemp(lEndincalDate));
				    
				    //债券类型
				    var vcStockType=returnJson.stockissueinfo.vcStockType;
				    loadvcStockType(vcStockType);
				    nui.get("vcIssueAppraiseCsrc").loadList(text.issueAppCrscData);//设置所属行业证监会二级
				    if(returnJson.stockissueinfo.vcIssueAppraiseCsrc!=null && returnJson.stockissueinfo.vcIssueAppraiseCsrc!=""){
				      nui.get("vcIssueAppraiseCsrc").setValue(returnJson.stockissueinfo.vcIssueAppraiseCsrc);
				    }
				    //通过债券类别控制股票信息展示stockissueinfo.vcStockType
					if(vcStockType!="" && vcStockType!=null){
						onAccountTypeChanged1(vcStockType);
					}
				    //发行主体
				    var vcIssuerNameFull=returnJson.stockissueinfo.vcIssuerNameFull;
				    var lIssuerId=returnJson.stockissueinfo.lIssuerId;
				    nui.get("lookup3").setText(vcIssuerNameFull);
				    nui.get("lookup3").setValue(lIssuerId);
				    
				    var fsumamount=returnJson.stockissueinfo.enCategoryMoney;
				    nui.get("fsumamount").setValue(fsumamount);
					var bdApplicationTime =returnJson.bdApplicationTime;
					//有债券申购时显示风控试算按钮
					document.getElementById("windControlTrial").style.display= "";
					//设置业务时间
					nui.get("bizprocess.dApplicationTime").setValue(bdApplicationTime);
					bizId=returnJson.bizProcess.lBizId;
					if(returnJson.stockissueinfo.cIsHaveBuyback=="" || returnJson.stockissueinfo.cIsHaveBuyback==null){
                   		//赎回权
		           		nui.get("cIsHaveBuyback").setValue("0");
                   	}
                   	if(returnJson.stockissueinfo.cIsHaveSaleback=="" || returnJson.stockissueinfo.cIsHaveBuyback==null){
			           	//回售权
			           	nui.get("cIsHaveSaleback").setValue("0");
                   	}
                   	//缴款方式为银行汇款时收款人账号必填
                   	cheangedCpayType();
                   	//改变缴款方式
					onVcPaymentPlace();
					//禁用修改
					if(isReadonly){
						readonly();
					}
					//禁用债券简称清空按钮
					document.getElementById( "cleanStock").style.display= "none";
					//加载附件
					$("#prodIfm").attr("src","<%=request.getContextPath() %>/fm/comm/fileupload/any_upload.jsp?bizId="+bizId+"&attachType=3&attachBusType=1");
				}
			});	
			
    	}
    	//定义存储债券字段变量
		var stockIssueInfoStr;
    	//无债券缴款跨页面参数传递参数
		function setFormDataPayMentNo(){
		   //不考虑回退
			$.ajax({
				url:"com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.loadApplyInstKeys.biz.ext",
				type:'POST',
				/*data:json,*/
				cache:false,
				contentType:'text/json',
				success:function(text){
					nui.get("vcStockType").loadList(text.stockTypeData);//设置债券信息
					nui.get("applyInst.lStockInvestNo").setValue(text.lStockInvestNo);
					nui.get("lStockInvestNo1").setValue(text.lStockInvestNo);
					nui.get("applyInst.lInvestNo").setValue(text.lInvestNo);
					bizId=text.bizProcess.lBizId;
					stockIssueInfoStr=text.stockIssueInfoStr;//获取债券变量数据
					nui.get("bizprocess.lBizId").setValue(bizId);
					nui.get("vcIssueAppraiseCsrc").loadList(text.issueAppCrscData);//设置所属行业证监会二级
					//设置无债券缴款
					biztype=1;
					//无债券申购时隐藏风控试算按钮
					document.getElementById("windControlTrial").style.display= "none";
					//设置申请时间
					nui.get("bizprocess.dApplicationTime").setValue((new Date()));
				   //加载附件
				   $("#prodIfm").attr("src","<%=request.getContextPath() %>/fm/comm/fileupload/any_upload.jsp?bizId="+bizId+"&attachType=3&attachBusType=1");
				
				}
			});	
			
		}
		//加载债券类别
		function loadvcStockType(vcStockType){
		   $.ajax({
				url:"com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.loadApplyInstKeys.biz.ext",
				type:'POST',
				/*data:json,*/
				cache:false,
				contentType:'text/json',
				success:function(text){
					nui.get("vcStockType").loadList(text.stockTypeData);//设置债券信息
					nui.get("vcStockType").setValue(vcStockType);
					stockIssueInfoStr=text.stockIssueInfoStr;//获取债券变量数据
				}
			});	
		}
    	
    	//时间转换
		function dateTemp(oldData){
			oldData=oldData+"";
			if(oldData==0 || oldData=="" || oldData=="null"){
				return "";
			}
			
			var datas=oldData.indexOf("-");
			if(datas>=0){
				return oldData;
			}
			var yy=oldData.substr(0,4);//0开始，截取后面4位
			var mm=oldData.substr(4,2);//4开始，截取后面2位
			var dd=oldData.substr(6,2);
			
			return yy+"-"+mm+"-"+dd;
		}
		//获取校验债券的数据
		function getCheckStockIssueInfo(){
			//定义存储变量
			var stockIssueInfoEnt={};
			if(stockIssueInfoStr=="" || stockIssueInfoStr==null){
				nui.alert("没有获取到债券信息，请关闭页面重现打开！");
				return "";
			}else{
				var strs=stockIssueInfoStr.split(",");
				for(var i=0;i<strs.length;i++){
					if(strs[i]=="vc_issuer_name_full"){
						//发行人
						var vcIssuerNameFull=nui.get("vcIssuerNameFull").getValue();
						stockIssueInfoEnt.vcIssuerNameFull=vcIssuerNameFull;
					}
					if(strs[i]=="vc_stock_name_full"){
						//债券全称
						var vcStockNameFull=nui.get("vcStockNameFull").getValue();
						stockIssueInfoEnt.vcStockNameFull=vcStockNameFull;
					}
					if(strs[i]=="vc_stock_type"){
						//债券类型
						var vcStockType=nui.get("stockissueinfo.vcStockType").getValue();
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
						var lIssueBeginDate=nui.get("stockissueinfo.lIssueBeginDate").getValue();
						lIssueBeginDate=getIntDate(lIssueBeginDate);
						stockIssueInfoEnt.lIssueBeginDate=lIssueBeginDate;
					}
					if(strs[i]=="c_issue_appraise"){
						//主体评级
						var cIssueAppraise=nui.get("stockissueinfo.cIssueAppraise").getValue();
						stockIssueInfoEnt.cIssueAppraise=cIssueAppraise;
					}
					if(strs[i]=="vc_issue_property"){
						//主体类型
						var vcIssueProperty=nui.get("vcIssueProperty").getValue();
						stockIssueInfoEnt.vcIssueProperty=vcIssueProperty;
					}
				}
				
				return stockIssueInfoEnt;
			}
		}
		function onStockNameFull(e){
			if(nui.get("vcStockNameFull").getValue()==""){
				nui.get("vcStockNameFull").setValue(e.value);
			}
		}
		 
		/*验证债劵代码长度*/
        function onvalidationkCode(){
			var place=nui.get("stockissueinfo.vcPaymentPlace").getValue();
			var code=nui.get("stockissueinfo.vcStockCode").getValue();
			var cMarketNo="";//交易场所
			//将等级机构转为交易场所
	        if(place==3){
	        	cMarketNo=1;
	        }else if(place==4){
	        	cMarketNo=2;
	        }else{
	        	cMarketNo=5;
	        }
			if(place!="" && cMarketNo!=5 && code!=""){
				var skReadOnly = nui.get("stockissueinfo.vcStockCode").readOnly;
				//禁用状态不提示
				if(skReadOnly != "true"){
					return true;
				}
				if(code.length>6){
					nui.alert("当前登记托管机构下，债券代码不能超6位！");
					return false;
				}
			}
			return true;
		}
		
		//提交数据
		function onOk(){	
		    //获取表单提交数据
			var form = new mini.Form("#dataform1"); 
			var vcMainUnderwriter=nui.get("stockissueinfo.vcMainUnderwriter").getValue();
			var vcDeputyUnderwriter=nui.get("stockissueinfo.vcDeputyUnderwriter").getValue();
			var vcGroupUnderwriter=nui.get("stockissueinfo.vcGroupUnderwriter").getValue();
			var vcMainUnderwriterId=nui.get("vcMainUnderwriterId").getValue();
			var vcDeputyUnderwriterId=nui.get("vcDeputyUnderwriterId").getValue();
			var hlRivalId=nui.get("hlRivalId").getValue();
			form.validate();
			nui.get("stockissueinfo.vcMainUnderwriter").setValue(vcMainUnderwriter);
		    nui.get("stockissueinfo.vcDeputyUnderwriter").setValue(vcDeputyUnderwriter);
		    nui.get("stockissueinfo.vcGroupUnderwriter").setValue(vcGroupUnderwriter);
		    nui.get("vcMainUnderwriterId").setValue(vcMainUnderwriterId);
			nui.get("vcDeputyUnderwriterId").setValue(vcDeputyUnderwriterId);
			nui.get("hlRivalId").setValue(hlRivalId);
			if(form.isValid() == false){
				nui.alert("业务信息必填项不能为空或者有数据输入格式不正确！");
				return;
			}
		    if(onvalidationkCode()==false){return;}//校验债券code
		    //无债券时验证
		    if(biztype==1){
				var stockIssueInfo=getCheckStockIssueInfo();
				//校验数据不能为空
				if(stockIssueInfo==""){
					return;
				}
			}
			//业务日期不能大于缴款日期
			var lPayDate2= dateTemp(nui.get("stockissueinfo.lPayDate").getValue()).substr(0,10);//缴款日期
			if(lPayDate2=="" || lPayDate2=="null"){
			        nui.alert("缴款日期不能为空，请确认!","提示");
	    			return;
	    		}
    		 lPayDate2=Date.parse(new Date(lPayDate2.replace(/-/g,"/")));
    		var dApplicationTime1= dateTemp(nui.get("bizprocess.dApplicationTime").getValue()).substr(0,10);//业务日期
			if(dApplicationTime1=="" || dApplicationTime1=="null"){
			        nui.alert("业务日期不能为空，请确认!","提示");
	    			return;
	    		}
    		 dApplicationTime1=Date.parse(new Date(dApplicationTime1.replace(/-/g,"/")));
        	if(dApplicationTime1>lPayDate2){
        			nui.alert("业务日期不能大于缴款日期!","提示");
        			return;
        		}
        	var lData = (new Date()).getTime()-86400000;
        		if(lPayDate2!="" && lPayDate2!=null && lData>lPayDate2){
        		    nui.alert("缴款日期不能小于当前日期!","提示");
        			return;
        		}
    		var lIssueBeginDate= dateTemp(nui.get("stockissueinfo.lIssueBeginDate").getValue()).substr(0,10);//发行日期
	    		lIssueBeginDate=Date.parse(new Date(lIssueBeginDate.replace(/-/g,"/")));
	    	if(lIssueBeginDate !=null && lIssueBeginDate !="" && lIssueBeginDate>lPayDate2){
	        			nui.alert("发行日期不能大于缴款日期!","提示");
	        			return;
		       }
		    var lBegincalDate= dateTemp(nui.get("stockissueinfo.lBegincalDate").getValue()).substr(0,10);//计息起始日期
	    		 lBegincalDate=Date.parse(new Date(lBegincalDate.replace(/-/g,"/")));
	        var lEndincalDate= dateTemp(nui.get("stockissueinfo.lEndincalDate").getValue()).substr(0,10);//到期日
	    		 lEndincalDate=Date.parse(new Date(lEndincalDate.replace(/-/g,"/")));
	    	if(lBegincalDate !=null && lEndincalDate !=null && lEndincalDate<=lBegincalDate){
	        			nui.alert("到期日不能小于等于计息起始日期!","提示");
	        			return;
		       }
		    var reNum=/^\d*$/;
		    var vcCollectionAccount1=nui.get("vcCollectionAccount").getValue()
		    if(!reNum.test(vcCollectionAccount1)){
		       nui.alert("收款账号只能输入数字！","系统提示");
				return;
		    }
		    var enIssueBalance1=nui.get("enIssueBalance").getValue();
		    var enPaymentMoney=nui.get("enPaymentMoney").getValue().replace(/,/gi,'');
			//验证输入是否为正数
	     	var reg = /^[0-9]+([.]{1}[0-9]+){0,1}$/;
			if (!reg.test(nui.get("enPayFaceValue").getValue().replace(/,/gi,'')))
			{
				nui.alert("缴款面值输入不能包含负数、字母、特殊字符，请输入正数！","系统提示");
				return;
			}
		    if (!reg.test(enPaymentMoney))
			{
				nui.alert("缴款金额输入不能包含负数、字母、特殊字符，请输入正数！","系统提示");
				return;
			}
			if(Number(enIssueBalance1)!=0 && Number(enIssueBalance1)*10000<Number(enPaymentMoney)){
			    nui.alert("发行规模需大于等于缴款金额！","系统提示");
				return;
			}
			//无债券时验证
		    if(biztype==1){
		       if(enIssueBalance1!=null && Number(enIssueBalance1)*10000<Number(enPaymentMoney)){
			    nui.alert("发行规模需大于等于缴款金额！","系统提示");
				return;
			   }
		    }
			var reg1=/^(-?\d+)(\.\d+)?$/;
			if (!reg1.test(nui.get("enPayInteval").getValue()) && nui.get("enPayInteval").getValue()!="")
			{
				nui.alert("付息频率输入不能包含字母、特殊字符，请输入正数或者下拉选择！","系统提示");
				return;
			}
			var vcStockCode=nui.get("stockissueinfo.vcStockCode").getValue();
			//债券为空 则不校验债券是否存在
			if(vcStockCode=="" || vcStockCode==null){
				applySubmit();
				return;
			}
			if(biztype==1){
				form.loading();//加载遮罩
				//交易债券是否存在
				nui.ajax({
				    url: "com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.checkStockIssueInfo.biz.ext",
				    type: "post",
				    data: {stockIssueInfo:stockIssueInfo,
				    	vcStockCode:vcStockCode,
				    	cMarketNo:nui.get("applyInst.cMarketNo").getValue(),
				    	lStockInvestNo:nui.get("applyInst.lStockInvestNo").getValue()},
				    dataType:"json",
				    success: function (text) {
				       form.unmask();//取消遮罩
				       if(text.out==false){
				       		nui.alert("当前债券已经存在，请点击<债券简称>输入框旁边的查询按钮，选择您待申购的债券！","申购提醒");
				       		return;
				       }else{
				       		applySubmit();
				       }
				       
				    }
				});
			}else{
				applySubmit();
			}
		}
		
		function applySubmit(){
		   nui.confirm("确认提交缴款？","系统提示",function(action){
		   if(action == "ok"){
			//获取表单提交数据
			var form = new mini.Form("#dataform1"); 
			//定义存储报量
			var applyInstReport=new Array();
			var reportData=getReportData(grid,form);
			if(reportData==false){
			   return;
			}
			//赋值获取报量相关信息
			applyInstReport=reportData.applyInstReport;
			
			/**---------------表单数据处理--------------------**/
			var data = form.getData(false,true);      //获取表单多个控件的数据
			var stockissueinfo,bizprocess;
			stockissueinfo=data.stockissueinfo;
			//获取投标金额和投标利率
			var applyInst=getReportBidInfo(applyInstReport,data.applyInst);
			applyInst.enCouponRate=stockissueinfo.enFaceRate;//票面利率--票面利率
			applyInst.enPayFaceValue = nui.get("enPayFaceValue").getValue().replace(/,/gi,'');
			/**
			 * 校验缴款流程报量的合法信息
			 * applyInst 必须包含四个参数 投标金额、投标利率；票面面值，票面利率。
			 * */
	        if(applyInst.enInvestBalance !="" && applyInst.enInvestBalance!=null && checkPaymentReport(applyInst)==false){
				//数据不通过校验
				return;
			} 
			
			//applyInst=data.applyInst;
			bizprocess=data.bizprocess;
		  	
			//净值规模和发行主体存量 
			applyInst.enBallotPrice = nui.get("enBallotPrice").getValue().replace(/,/gi,'');
			applyInst.enPaymentMoney = nui.get("enPaymentMoney").getValue().replace(/,/gi,'');
			applyInst.enNetScale = nui.get("enNetScale").getValue().replace(/,/gi,'');
			stockissueinfo.enCategoryMoney = nui.get("fsumamount").getValue().replace(/,/gi,'');
			applyInst.enInvestScaleRatio = nui.get("enInvestScaleRatio").getValue();
			applyInst.enIssuerNetRatio = nui.get("enIssuerNetRatio").getValue();
			applyInst.enInvestNetRatio = nui.get("enInvestNetRatio").getValue();
			applyInst.enWeakNetRatio = nui.get("enWeakNetRatio").getValue();
			applyInst.vcBusinessObject = nui.get("lookup1").text;

            applyInst.dPaymentDate=stockissueinfo.lPayDate;//缴款日期
			applyInst.vcTransactionType=stockissueinfo.cPayType;//缴款方式
			applyInst.vcFrequency=stockissueinfo.enPayInteval;//付息频率
			
			applyInst.vcBusinessType=1;//非可转;
			bizprocess.vcProcessType=8;//流程类型:1-一级债券申购,2-新债录入,3-新债修改,4-新债查重,5-一级债无债券申购,8--指令/建议繳款
			applyInst.lValidStatus=0;//指令/建议单状态:0-有效;1-无效-修改;2-无效-废弃;3-有效-退回;4-无效-退回;
			applyInst.cStatus=1;//复核状态 0草稿,1待复核,2正常,3合并中,4失效
			applyInst.cApplyInstType="F2";//业务类别（全）
			//组装业务日期 加入时分秒，默认当前时间的时分秒
			var date=new Date();
			var dApplicationTime1=nui.get("bizprocess.dApplicationTime").text+" "+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds();
			bizprocess.dApplicationTime=dApplicationTime1;
			applyInst.dApplicationTime=dApplicationTime1;
			if(biztype==1){
			    //设置无债券信息
		  	    stockissueinfo.lStockInvestNo=applyInst.lStockInvestNo;//证券投资编号
		  	    bizprocess.lStockInvestNo=applyInst.lStockInvestNo;//证券投资编号
			}else{
			    //债券信息 赋值到指令/建议表
			    applyInst.lStockInvestNo=stockissueinfo.lStockInvestNo;
			}
			//投顾录入和投顾复核为同一人时，页面跳转传StockInvestNo
			document.getElementById("stockInvestNo").value=applyInst.lStockInvestNo;
			bizprocess.vcAbstract="一级债分销缴款";
			applyInst.vcStockName=stockissueinfo.vcStockName;
			applyInst.vcStockNameFull=stockissueinfo.vcStockNameFull;
			applyInst.vcStockCode=stockissueinfo.vcStockCode;
			applyInst.vcStockType=stockissueinfo.vcStockType;//证券类别
			applyInst.cIssueAppraise=stockissueinfo.cIssueAppraise;//主体评级
			applyInst.vcPaymentPlace=stockissueinfo.vcPaymentPlace;//登记机构
			//获取附件数量
			var attachCount = getAttachCount(bizId);
			applyInst.lAttchCount=attachCount;//通过查询获取该zhi
			//流程实例ID
			bizprocess.lBizId=bizId;
			var cMarketNo=stockissueinfo.vcPaymentPlace;
			//债券表登记托管机构转换
 			if(cMarketNo=="03"){
	        	cMarketNo=1;
	        }else if(cMarketNo=="04"){
	        	cMarketNo=2;
	        }else{
	        	cMarketNo=5;
	        }
	        applyInst.cMarketNo=cMarketNo;//交易场所
	        stockissueinfo.cMarketNo=cMarketNo;//交易市场
	        stockissueinfo.lIssuerId=nui.get("lookup3").getValue();
	        
	        
	        debugger;
	        
	        var lBegincalDate1=stockissueinfo.lBegincalDate.replace(/-/gi,'').substr(0,8);//计息起始日期
	        var lEndincalDate1=stockissueinfo.lEndincalDate.replace(/-/gi,'').substr(0,8);//计息截止日期
	        var lPayDate1=stockissueinfo.lPayDate.replace(/-/gi,'').substr(0,8);//缴款日期
	        var lIssueBeginDate1=stockissueinfo.lIssueBeginDate.replace(/-/gi,'').substr(0,8);//发行日期
	        
	        console.log(lBegincalDate1);
	         console.log(lIssueBeginDate1);
	        
	        var stockIssueInfoTemp;
	        if(biztype==1){
	            stockissueinfo.lBegincalDate=lBegincalDate1;
	            stockissueinfo.lEndincalDate=lEndincalDate1;
	            stockissueinfo.lPayDate=lPayDate1;
	            stockissueinfo.lIssueBeginDate=lIssueBeginDate1;
	            stockissueinfo.cStatus=0;//复核状态 0草稿,1待复核,2正常,3合并中,4失效
	            stockIssueInfoTemp=stockissueinfo;
			}else{
			    var cStatus=2;//复核状态 0草稿,1待复核,2正常,3合并中,4失效
			    //有债券缴款定义需要提交的新债数据，注意是需要提交的（债券ID，债券类型,主承商,），不是所有 
				stockIssueInfoTemp=
				{
				cStatus:cStatus,
				lStockIssueId:stockissueinfo.lStockIssueId,
				vcStockType:stockissueinfo.vcStockType,
				lPayDate:lPayDate1,
				enFaceRate:stockissueinfo.enFaceRate,
				lIssueBeginDate:lIssueBeginDate1,
				lBegincalDate:lBegincalDate1,
				lEndincalDate:lEndincalDate1,
				enPayInteval:stockissueinfo.enPayInteval,
				cPayType:stockissueinfo.cPayType,
				enCategoryMoney:stockissueinfo.enCategoryMoney,vcMainUnderwriter:stockissueinfo.vcMainUnderwriter,
				vcDeputyUnderwriter:stockissueinfo.vcDeputyUnderwriter,vcGroupUnderwriter:stockissueinfo.vcGroupUnderwriter,vcMainUnderwriterId:stockissueinfo.vcMainUnderwriterId,
				vcDeputyUnderwriterId:stockissueinfo.vcDeputyUnderwriterId,enExistLimite:stockissueinfo.enExistLimite,cIssueAppraise:stockissueinfo.cIssueAppraise,
				cBondAppraise:stockissueinfo.cBondAppraise,vcIssueAppraiseOrgan:stockissueinfo.vcIssueAppraiseOrgan,vcBondAppraiseOrgan:stockissueinfo.vcBondAppraiseOrgan,enExistLimite:stockissueinfo.enExistLimite};
			}
			
			
			/**风控管理开始**/
			
			if(biztype!=1){	//	一级债无债券缴款只在交易员2校验风控
				applyInst.vcCombiCode = applyInst.vcCombiNo;
				if(judgeRiskTest(null, applyInst)){	//判断是否接入风控管理
					//风控参数
					applyInst.lBizId = bizId;  //业务主表
					applyInst.vcIssuePrice=stockissueinfo.vcIssuePrice;//发行价格
					applyInst.enInterestRate=stockissueinfo.enFaceRate;//投标利率--票面利率
				    applyInst.enCouponRate=stockissueinfo.enFaceRate;//票面利率--票面利率
					applyInst.enPayInteval=stockissueinfo.vcFrequency;//付息频率
					applyInst.vcBusinessObject=nui.get("hlRivalId").getValue();//交易对手需要传ID
					//后面风控回调方法中使用
					applyInstRiskParam = applyInst;
					
					
					
					stockissueinfoRiskParam = stockIssueInfoTemp;
					
					bizprocessRiskParam = bizprocess;
					applyInstReportRiskParam = applyInstReport;
					//序列化成JSON
					var riskJson = mini.encode({applyInst:applyInst}); 
					//console.log(riskJson);
					//校验风控
					checkRiskInfoApplyStock(riskJson);
					return;
				}
			}
			
			/**风控管理结束**/
			
			
			//获取用印信息
		    var attachments = nui.get("file_grid").getData();
			
			 //序列化成JSON
			var json = mini.encode({attachments:attachments,applyInst:applyInst,applyInstReport:applyInstReport,bizprocess:bizprocess,stockIssueInfo:stockIssueInfoTemp}); 
			
			console.log(json);
			
			form.loading();//加载遮罩
			//提交
			nui.ajax({
			    url: "com.cjhxfund.ats.fm.instr.firstGradePayment.savePayMentFirstGradeDabt.biz.ext",
			    type: "post",
			    data: json,
			    dataType:"json",
			    success: function (text) {
			    debugger;
			    	if(text.out==1){
			    		var processId = text.processId;
			    		//console.log(processId);
						if(generateFileSwitch){
							generateFile(processId,bizId,stockissueinfo.lStockInvestNo);
						}
			    		if(text.ret==1){
			    				var workItem = text.workItem;
			    				nui.confirm("缴款录入成功，是否前往复核？","缴款提示",function(act){
			    					if(act=="ok"){
			    						var actionUrl = "/com.cjhxfund.ats.fm.instr.FirstGradePayment.flow";
			    						wfOpenWin(actionUrl,workItem.processInstID,workItem.workItemID,bizId);
			    					}
			    					//关闭界面
			    					CloseWindow("cancel");
			    				});
		    			}else{
			    			nui.alert("提交成功","缴款提醒",function (a){
			    			
			    				//关闭界面
			    				CloseWindow("cancel");
			    			});
		    			}
			    		
			    	}else if(text.out==2){
			    		nui.alert("提交失败,该债券被修改或者不可用!");
			    	}else{
			    		nui.alert("提交失败!");
			    	}
			    	form.unmask();//取消遮罩
			        //alert("提交成功，返回结果:" + text.out);    
			    }
			});
			}
				
		});	
		    
		}
		
		
		/**风控管理开始**/
		var applyInstRiskParam;
		var stockissueinfoRiskParam;
		var bizprocessRiskParam;
		var applyInstReportRiskParam;
		var riskFlagRiskParam;
		var lResultIdRiskParam;
		var lRiskmgrIdRiskParam;
		function subData(riskReturn){
        	var riskFlag = showRiskInfoApplyStock(riskReturn, applyInstRiskParam);
        	riskControl(riskFlag);
        }
        function riskControl(riskFlag, lResultId, lRiskmgrId){
        	riskFlagRiskParam = riskFlag;
        	lResultIdRiskParam = lResultId;
        	lRiskmgrIdRiskParam = lRiskmgrId;
        	if(riskFlag=='-1'){
        		return;
        	}else if(riskFlag=='1' || riskFlag=='2'){
        		applySubmitRisk();
        	}
        }
        function applySubmitRiskFinish(){
      
            if(riskFlagRiskParam=='2'){
        		startRiskProcessInstruct(lResultIdRiskParam, lRiskmgrIdRiskParam, "1","F2");
        	}
        }
        
        function applySubmitRisk(){
        	//获取用印信息
		    var attachments = nui.get("file_grid").getData();
		    applyInstRiskParam.lResultIdRiskParam = lResultIdRiskParam;
			 //序列化成JSON
			var json = mini.encode({attachments:attachments,applyInst:applyInstRiskParam,applyInstReport:applyInstReportRiskParam,bizprocess:bizprocessRiskParam,stockIssueInfo:stockissueinfoRiskParam}); 
			console.log(nui.decode(json));
			var loadingForm = new nui.Form("#layout1");//获取全屏
			//
			loadingForm.loading();//加载遮罩
			//提交
			nui.ajax({
			    url: "com.cjhxfund.ats.fm.instr.firstGradePayment.savePayMentFirstGradeDabt.biz.ext",
			    type: "post",
			    data: json,
			    dataType:"json",
			    success: function (text) {
			    	loadingForm.unmask();//取消遮罩
			    	if(text.out==1){
			    		var processId = text.processId;
			    		//console.log(processId);
						if(generateFileSwitch){
							generateFile(processId,bizId,stockissueinfo.lStockInvestNo);
						}
			    		if(text.ret==1){
			    			applySubmitRiskFinish();
			    			var workItem = text.workItem;
		    				nui.confirm("缴款录入成功，是否前往复核？","缴款提示",function(act){
		    					if(act=="ok"){
		    						var actionUrl = "/com.cjhxfund.ats.fm.instr.FirstGradePayment.flow";
		    						wfOpenWin(actionUrl,workItem.processInstID,workItem.workItemID,bizId);
		    					}
		    					//关闭界面
		    					CloseWindow("cancel");
		    				});
		    			}else{
			    			nui.alert("提交成功","申购提醒",function (a){
			    				//关闭界面
			    				applySubmitRiskFinish();
			    				CloseWindow("cancel");
			    			});
		    			}
			    	}else if(text.out==2){
			    		nui.alert("提交失败,该债券被修改或者不可用!");
			    	}else{
			    		if(text.fixStart==false){
			    			nui.alert("fix验证失败，原因为："+msg);
			    		}else{
			    			nui.alert("网络错误，请确认！");
			    		}
			    	}
			    	
			        //alert("提交成功，返回结果:" + text.out);    
			    }
			});
        }
        
        /**风控管理结束**/
        
        
		var contextPath = "<%=request.getContextPath() %>";
		function wfOpenWin(url,processInstID,workItemID,bizId) {
		
		debugger;
			var winFrm=document.openForm;
			document.getElementById("processinstid").value=processInstID;
			document.getElementById("workItemID").value=workItemID;
			document.getElementById("bizId1").value=bizId;
			var actionURL=contextPath+"/"+url; //目标页面
			winFrm.action=actionURL;
					
			var newwin = window.open('about:blank', 'newWindow' + bizId, '');
			winFrm.target = 'newWindow' + bizId;//这一句是关键
			winFrm.submit();
		}
		//缴款面值值改变
		function payVcBallotNumber(){
	     	var payFaceValue = nui.get("enPayFaceValue").getValue().replace(/,/gi,'');
	     	//验证缴款面值是否为正数
	     	var reg = /^([0-9]+)(\.\d{1,4})?$/;
			if (!reg.test(payFaceValue))
			{
				nui.alert("缴款面值不能包含负数、字母、特殊字符，请输入正数！","系统提示");
				return;
			}
			
	     	formatNumberCommon("enPayFaceValue",4);  //缴款面值加入千分位
	     	
	     	var ballotPrice  = nui.get("enBallotPrice").getValue().replace(/,/gi,'');   //获取中标价格
	     	if(ballotPrice != null && ballotPrice != ""){
	     		payVcBallotPrice(); //计算缴款金额
	     	}
        }
         //缴款面值值改变
	     function payEnIssueBalance(){
	         var enIssueBalance = nui.get("enIssueBalance").getValue().replace(/,/gi,'');
	            //验证输入是否为正数
		     	var reg = /^([0-9]+)(\.\d{1,4})?$/;
				if (!reg.test(enIssueBalance))
				{
					nui.alert("输入不能包含负数、字母、特殊字符，请输入正数！","系统提示");
					return;
				}
				formatNumberCommon("enIssueBalance",4);  //加入千分位
	     }
	     //校验输入是否为正整数
	     function checkInt(number){
	            //验证输入是否为正数
		     	var reg = /^([0-9]+)(\.\d{1,4})?$/;
				if (!reg.test(number.value))
				{
					nui.alert("输入不能包含负数、字母、特殊字符，请输入正数！","系统提示");
					return;
				}
	     }
        //发行价格值改变
		function payVcBallotPrice(){
	     	var payFaceValue = nui.get("enPayFaceValue").getValue().replace(/,/gi,'');  //获取缴款面额
	     	var ballotPrice  = nui.get("enBallotPrice").getValue().replace(/,/gi,'');   //获取发行价格
	     	//验证中标价格是否为正数
	     	var reg = /^(([0-9]+)|([0-9]+\.[0-9]{1,4}))$/;
			if (!reg.test(ballotPrice))
			{
				nui.alert("中标价格不能包含负数、字母、特殊字符，请输入正数","系统提示");
				return;
			}
	     	//计算缴款金额并赋值
	     	nui.get("enPaymentMoney").setValue(payFaceValue*ballotPrice/100);
	     	formatNumberCommon("enPaymentMoney",4);
	     	//formatNumberCommon("enBallotPrice",4);
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
		
		//风控试算
		function windControlTrial(){
			//获取表单提交数据
			var form = new mini.Form("#dataform1"); 
			
			var vcMainUnderwriter=nui.get("stockissueinfo.vcMainUnderwriter").getValue();
			var vcDeputyUnderwriter=nui.get("stockissueinfo.vcDeputyUnderwriter").getValue();
			var vcGroupUnderwriter=nui.get("stockissueinfo.vcGroupUnderwriter").getValue();
			var vcMainUnderwriterId=nui.get("vcMainUnderwriterId").getValue();
			var vcDeputyUnderwriterId=nui.get("vcDeputyUnderwriterId").getValue();
			var hlRivalId=nui.get("hlRivalId").getValue();
			form.validate();
			    nui.get("stockissueinfo.vcMainUnderwriter").setValue(vcMainUnderwriter);
			    nui.get("stockissueinfo.vcDeputyUnderwriter").setValue(vcDeputyUnderwriter);
			    nui.get("stockissueinfo.vcGroupUnderwriter").setValue(vcGroupUnderwriter);
		    nui.get("vcMainUnderwriterId").setValue(vcMainUnderwriterId);
			nui.get("vcDeputyUnderwriterId").setValue(vcDeputyUnderwriterId);
			nui.get("hlRivalId").setValue(hlRivalId);
			if(form.isValid() == false){
				nui.alert("有数据为空或填写不正确，请确认！");
				return;
			}
			
			//存储报量信息
			var applyInstReport=new Array();
			var reportData=getReportData(grid,form);
			
			applyInstReport=reportData.applyInstReport;
			
			var data = form.getData(false,true);      //获取表单多个控件的数据
			var stockissueinfo,applyInst;
			stockissueinfo=data.stockissueinfo;
			applyInst=data.applyInst;
		  	//债券信息 赋值到指令/建议表
			applyInst.vcStockName=stockissueinfo.vcStockName;
			applyInst.vcStockCode=stockissueinfo.vcStockCode;
			
			applyInstReport=getReportBidInfo(reportData.applyInstReport,applyInst);
			applyInst.lBizId = bizId;  //业务主表
			applyInst.enInterestRate=stockissueinfo.enFaceRate;//投标利率--票面利率
			applyInst.enCouponRate=stockissueinfo.enFaceRate;//票面利率--票面利率
			applyInst.enPayInteval=stockissueinfo.vcFrequency;//付息频率
			
			applyInst.enInvestBalance=applyInstReport.enInvestBalance;//投标金额
			
			applyInst.enBallotPrice = nui.get("enBallotPrice").getValue().replace(/,/gi,'');
			applyInst.enPaymentMoney = nui.get("enPaymentMoney").getValue().replace(/,/gi,'');
			applyInst.enPayFaceValue = nui.get("enPayFaceValue").getValue().replace(/,/gi,'');
			
			applyInst.vcPaymentPlace=stockissueinfo.vcPaymentPlace;//登记机构
			applyInst.vcStockNameFull=stockissueinfo.vcStockNameFull;
			//获取附件数量
			var attachCount = getAttachCount(bizId);
			applyInst.lAttchCount=attachCount;//通过查询获取该zhi
			var PcMarketNo=applyInst.vcPaymentPlace;
			//债券表登记托管机构转换
	 		if(PcMarketNo==3){
		        PcMarketNo=1;
		    }else if(PcMarketNo==4){
		        PcMarketNo=2;
		     }else{
		        PcMarketNo=5;
		     }
	 		applyInst.cMarketNo=PcMarketNo;//交易市场
			applyInst.vcBusinessObject=nui.get("hlRivalId").getValue();//交易对手需要传ID
			 //序列化成JSON
			var json = mini.encode({applyInst:applyInst}); 
			
			form.loading();//加载遮罩
			//提交
			nui.ajax({
			    url: "com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.windControlTrial.biz.ext",
			    type: "post",
			    data: json,
			    dataType:"json",
			    success: function (text) {
			    	var returnJson = nui.decode(text);
			    	form.unmask();//取消遮罩
			    	if(returnJson.returnCode == 4){
			    		 nui.alert(returnJson.rtnMsg,"系统提示");
					     return;
			    	}else if(returnJson.returnCode == 0){
			    	 	if(returnJson.ishave==false){
			    			nui.alert("O32没有该债券，只能调用本地风控！","系统提示",function (){
			    				nui.alert("风控试算成功,未触发风控。","系统提示");
			    			});
		    			}else{
		    				nui.alert("风控试算成功,未触发风控。","系统提示");
		    			}
			    	 	return;
			    	}else if (returnJson.returnCode == -1){
			    			nui.alert(returnJson.rtnMsg,"系统提示");
			    			return;
			    	}else if(returnJson.returnCode != 0){
			    		if(checkRiskRet(returnJson.riskMsg)==false){
			    			return;
			    		}
		    			//判断债券是否存在o32
			    		if(returnJson.ishave==false){
			    			nui.alert("O32没有该债券，只能调用本地风控！","系统提示",function (){
			    			
			    				nui.open({
				    	  			url: "<%=request.getContextPath() %>/fix/riskApiControlDetailList.jsp",
				                    title: "风控试算反馈消息展示", width: 800, height: 390,
				                    onload: function () {
				                        //弹出页面加载完成
					                    var iframe = this.getIFrameEl();
					                    iframe.contentWindow.SetData(returnJson.riskMsg,3);
				                    },
				                    ondestroy: function (action) {//弹出页面关闭前
					                 
				                	}
				    	  		});
			    			});
		    	  			
			    		}else{
			    			nui.open({
			    	  			url: "<%=request.getContextPath() %>/fix/riskApiControlDetailList.jsp",
			                    title: "风控试算反馈消息展示", width: 800, height: 390,
			                    onload: function () {
			                        //弹出页面加载完成
				                    var iframe = this.getIFrameEl();
				                    iframe.contentWindow.SetData(returnJson.riskMsg,3);
			                    },
			                    ondestroy: function (action) {//弹出页面关闭前
				                 
			                	}
			    	  		});
			    		}
			    		
			    	}
			        //alert("提交成功，返回结果:" + text.out);    
			    }
			});
			
		}
		function onAddClick1(){
	  	var url = "<%= request.getContextPath() %>/fm/baseinfo/issuerInfo/addTraderivalInfo.jsp";
			var title = "新增交易对手";
			var width = "450";
			var height = "330";
			nui.open({
				url: url,
				title: title, width: width, height: height,
				onload: function () {//弹出页面加载完成
					
				},
				ondestroy: function (action) {//弹出页面关闭前
					keyText1.setValue(action);
					onSearchClick1();
				}
			});
	  }
	  function onAddClick2(){
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
					keyText2.setValue(action);
					onSearchClick2();
				}
			});
	  }
	  function onAddClick3(){
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
					keyText3.setValue(action);
					onSearchClick3();
				}
			});
	  }
	  function onAddClick4(){
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
					keyText4.setValue(action);
					onSearchClick4();
				}
			});
	  }
	  function onAddClick5(){
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
					keyText5.setValue(action);
					onSearchClick5();
				}
			});
	  }
		//取消
		function onCancel() {
			CloseWindow("cancel");
		}
		//提供给附件上传调用
		function refreshFile(){}
		
		//查询附件个数
		function getAttachCount(bizid){
			var json = nui.encode({lbizid : bizid});
			var attachCount = null;
			$.ajax({
				url:"com.cjhxfund.ats.fm.baseinfo.attachInfoManager.queryAttachCount.biz.ext",
				type:'POST',
				data:json,
				cache:false,
				async: false,
				contentType:'text/json',
				success:function(data){
					attachCount = data.attachCount;
				}
			});
			return attachCount;
		}
		//弹出报量帮助
		function showTips() {
			var reportTypeMark = "";
			var json = '{"paramKey":"REPORT_TYPE_MARK"}';
			var url = "<%= request.getContextPath() %>/fm/instr/firstGradeDebt/reportMark.jsp";
			var title = "报量方式说明";
			var width = "610";
			var height = "618";
			//从系统参数获得报量方式
			$.ajax({
				url:"com.cjhxfund.ats.fm.comm.zhfwptparamconfbiz.getParamValue.biz.ext",
				type:'POST',
				data:json,
				cache:false,
				async:false,
				contentType:'text/json',
				success:function(data){
					reportTypeMark = data.paramValue;
				}
			});
			nui.open({
				url: url,
				title: title, width: width, height: height,
				onload: function () {//弹出页面加载完成
					 var iframe = this.getIFrameEl(); 
        			//调用弹出页面方法进行初始化
        			iframe.contentWindow.SetData(reportTypeMark); 
				},
				ondestroy: function (action) {//弹出页面关闭前,把新增的主体简称返回赋值给查询框
				}
			});
	     }
	      
	     //打开查询债券界面
		function queryOpen(){
			var name=nui.get("vcStockName").getValue();
			nui.open({
                    url: "<%=request.getContextPath() %>/fm/instr/firstGradeDebt/queryStockName.jsp",
						title : "查询债券",
						width : 620,
						height : 350,
						onload : function() {
							//弹出页面加载完成
							var iframe = this.getIFrameEl();
							var data = {
								vcStockName : name
							};//传入页面的json数据
							iframe.contentWindow.setFormData(data);
						},
						ondestroy : function(data) {//弹出页面关闭前
							//判定回填数据
							if (data != null && data != "" && data != "close") {
								var form = new nui.Form("#dataform1");//将普通form转为nui的form
								var formData = form.getData(false, true); //获取表单多个控件的数据
								var lStockInvestNo1 = nui
										.get("lStockInvestNo1").getValue();
								stockIssueInfoTemp = data;//存储 ，提交时使用
								form.setData({
									stockissueinfo : data,
									bizprocess : formData.bizprocess,
									applyInst : formData.applyInst
								});
								form.setChanged(false);
								nui.get("lStockInvestNo1").setValue(lStockInvestNo1);
								//nui.get("stockissueinfo.vcMainUnderwriter").setValue(data.vcMainUnderwriter);
								//nui.get("stockissueinfo.vcPaymentPlace").setValue(data.vcPaymentPlace);
								//nui.get("stockissueinfo.vcStockCode").setValue(data.vcStockCode);
								
								
								debugger;
								
								if(nui.get("enPayInteval").getText()==null||nui.get("enPayInteval").getText()==""){
								
								   nui.get("enPayInteval").setText(data.enPayInteval);//付息频率(次/年)
								     
								}
								
								
								nui.get("vcStockName").setValue(data.vcStockName);
								nui.get("lookup3").setText(data.vcIssuerNameFull);
								nui.get("applyInst.lStockInvestNo").setValue(stockIssueInfoTemp.lStockInvestNo);
								nui.get("applyInst.lInvestNo").setValue(stockIssueInfoTemp.lInvestNo);
								nui.get("fsumamount").setValue(data.enCategoryMoney);
								nui.get("vcStockType").setValue(data.vcStockType);
								var vcStockType1 = data.vcStockType;
								//通过债券类别控制股票信息展示stockissueinfo.vcStockType
								if (vcStockType1 != "" && vcStockType1 != null) {
									onAccountTypeChanged1(vcStockType1);
								}
								//发行日期，缴款日期
								var lIssueBeginDate = data.lIssueBeginDate;
								nui.get("stockissueinfo.lIssueBeginDate")
										.setValue(dateTemp(lIssueBeginDate));
								var lPayDate = data.lPayDate;
								nui.get("stockissueinfo.lPayDate").setValue(
										dateTemp(lPayDate));
								var lBegincalDate = data.lBegincalDate;
								nui.get("stockissueinfo.lBegincalDate")
										.setValue(dateTemp(lBegincalDate));
								var lEndincalDate = data.lEndincalDate;
								nui.get("stockissueinfo.lEndincalDate")
										.setValue(dateTemp(lEndincalDate));

								biztype = 2;//设置为有债券申购
								//有债券申购时显示风控试算按钮
								document.getElementById("windControlTrial").style.display = "";
								//改变表单相关债券数据为不可以操作
								if (isReadonly) {
									readonly();
								}
								if (stockIssueInfoTemp.cIsHaveBuyback == ""
										|| stockIssueInfoTemp.cIsHaveBuyback == null) {
									//赎回权
									nui.get("cIsHaveBuyback").setValue("0");
								}
								if (stockIssueInfoTemp.cIsHaveSaleback == ""
										|| stockIssueInfoTemp.cIsHaveBuyback == null) {
									//回售权
									nui.get("cIsHaveSaleback").setValue("0");
								}
								cheangedCpayType();
							}
						}
					});
		}
		//有债券禁用数据
		function readonly() {
			//债券类型stockissueinfo.vcStockType
			readonlyInput("vcStockType", "vcStockType");
			$("#vcStockType").removeClass("mini-required");//删除必填样式
			nui.get("vcStockType").setRequired(false);//取消必填
			//债券代码
			readonlyInput("stockissueinfo.vcStockCode",
					"stockissueinfo\\.vcStockCode");
			$("#stockissueinfo\\.vcStockCode").removeClass("mini-required");//删除必填样式
			nui.get("stockissueinfo.vcStockCode").setRequired(false);//取消必填
			//债券简称
			readonlyInput("vcStockName", "vcStockName");
			$("#vcStockName").removeClass("mini-required");//删除必填样式
			nui.get("vcStockName").setRequired(false);//取消必填
			//债券全称
			readonlyInput("vcStockNameFull", "vcStockNameFull");

			//登记托管所
			readonlyInput("stockissueinfo.vcPaymentPlace",
					"stockissueinfo\\.vcPaymentPlace");
			//发行主体
			readonlyInput("lookup3", "lookup3");
			//主体类型
			readonlyInput("vcIssueProperty", "vcIssueProperty");
			//主体评级
			readonlyInput("cIssueAppraise", "cIssueAppraise");
			//债券评级
			readonlyInput("cBondAppraise", "cBondAppraise");
			//评级机构
			readonlyInput("vcIssueAppraiseOrgan", "vcIssueAppraiseOrgan");
			//评级机构
			readonlyInput("vcBondAppraiseOrgan", "vcBondAppraiseOrgan");
			//发行规模
			readonlyInput("enIssueBalance", "enIssueBalance");
			//发行方式
			readonlyInput("vcIssueType", "vcIssueType");
			//特殊期限
			readonlyInput("vcSpecialLimite", "vcSpecialLimite");
			//发行期限
			readonlyInput("enExistLimite", "enExistLimite");
			//赎回权
			readonlyInput("cIsHaveBuyback", "cIsHaveBuyback");
			//回售权
			readonlyInput("cIsHaveSaleback", "cIsHaveSaleback");
			//所属行业（证监会二级）
			readonlyInput("vcIssueAppraiseCsrc", "vcIssueAppraiseCsrc");
			//公司净资产
			readonlyInput("enIssuerNetValue", "enIssuerNetValue");
			//城投行政级别
			readonlyInput("vcCityLevel", "vcCityLevel");
			//下一利率跳升点数
			readonlyInput("lNInterestRateJumpPoints",
					"lNInterestRateJumpPoints");
			//特殊条款
			readonlyInput("vcSpecialText", "vcSpecialText");

		}
		/*禁用nui的input文本框，达到效果为：不可修改，可复制，置灰
		 *inputNuiId nui使用的id 即 控件的id属性值
		 *inputJQId jquery使用的id,jquery id不支持特殊符号 如“。”需要转义，即传入控件的id属性值转义的值
		 */
		function readonlyInput(inputNuiId, inputJQId) {
			nui.get(inputNuiId).readOnly = "readonly";//nui禁用
			$("#" + inputJQId + " input").attr("readonly", "readonly");//解决nui禁用IE兼容
			$("#" + inputJQId + " input").css("background-color", "#f0f0f0");//置灰
		}
		/*清理有债券信息，将有债券切换为无债券*/
		function stockIssueInfoClean() {
			var form = new nui.Form("#dataform1");//将普通form转为nui的form
			var formData = form.getData(false, true); //获取表单多个控件的数据
			var lStockInvestNo1 = nui.get("lStockInvestNo1").getValue();
			form.reset();
			form.setData({
				stockissueinfo : {},
				bizProcess : formData.bizProcess,
				applyInst : formData.applyInst
			});
			form.setChanged(false);
			//vcProductName  vcProductCode
			nui.get("productCombo").setValue(formData.applyInst.vcProductCode);
			//无债券申购时隐藏风控试算按钮
			document.getElementById("windControlTrial").style.display = "none";
			biztype = 1;//设置为无债券申购
			readonlyClean();
			//清理有债券的数据 lookup
			nui.get("lookup1").setValue("");
			nui.get("lookup1").setText("");
			nui.get("lookup2").setValue("");
			nui.get("lookup2").setText("");

			nui.get("lookup3").setValue("");
			nui.get("lookup3").setText("");
			nui.get("lookup4").setValue("");
			nui.get("lookup4").setText("");
			nui.get("lookup5").setValue("");
			nui.get("lookup5").setText("");
			nui.get("vcStockType").setValue("");
			nui.get("stockissueinfo.vcStockCode").setValue("");
			nui.get("vcStockName").setValue("");
			nui.get("stockissueinfo.vcPaymentPlace").setValue("");
			nui.get("stockissueinfo.vcMainUnderwriter").setValue("");
			nui.get("stockissueinfo.vcDeputyUnderwriter").setValue("");
			nui.get("stockissueinfo.vcGroupUnderwriter").setValue("");
			nui.get("lStockInvestNo1").setValue(lStockInvestNo1);
			nui.get("applyInst.lStockInvestNo").setValue(lStockInvestNo1);
			nui.get("enExistLimite").setValue("0");
			nui.get("enIssueBalance").setValue("0");
			//赎回权
			nui.get("cIsHaveBuyback").setValue("0");
			//回售权
			nui.get("cIsHaveSaleback").setValue("0");
			//隐藏股票信息
			onAccountTypeChanged1("0");
		}
		//清理有债券的禁用信息
		function readonlyClean() {
			//债券类型stockissueinfo.vcStockType
			addInput("vcStockType", "vcStockType");
			$("#vcStockType").addClass("mini-required");//添加必填样式
			nui.get("vcStockType").setRequired(true);//添加必填
			//债券代码
			addInput("stockissueinfo.vcStockCode",
					"stockissueinfo\\.vcStockCode");

			//债券简称
			addInput("vcStockName", "vcStockName");
			$("#vcStockName").addClass("mini-required");//添加必填样式
			nui.get("vcStockName").setRequired(true);//必填

			//债券全称
			addInput("vcStockNameFull", "vcStockNameFull");

			//登记托管所
			addInput("stockissueinfo.vcPaymentPlace",
					"stockissueinfo\\.vcPaymentPlace");
			//发行主体
			addInput("lookup3", "lookup3");
			//主体类型
			addInput("vcIssueProperty", "vcIssueProperty");
			//主体评级
			addInput("cIssueAppraise", "cIssueAppraise");
			//债券评级
			addInput("cBondAppraise", "cBondAppraise");
			//评级机构
			addInput("vcIssueAppraiseOrgan", "vcIssueAppraiseOrgan");
			//评级机构
			addInput("vcBondAppraiseOrgan", "vcBondAppraiseOrgan");
			//发行规模
			addInput("enIssueBalance", "enIssueBalance");
			//发行方式
			addInput("vcIssueType", "vcIssueType");
			//特殊期限
			addInput("vcSpecialLimite", "vcSpecialLimite");
			//发行期限
			addInput("enExistLimite", "enExistLimite");
			//赎回权
			addInput("cIsHaveBuyback", "cIsHaveBuyback");
			//回售权
			addInput("cIsHaveSaleback", "cIsHaveSaleback");
			//所属行业（证监会二级）
			addInput("vcIssueAppraiseCsrc", "vcIssueAppraiseCsrc");
			//公司净资产
			addInput("enIssuerNetValue", "enIssuerNetValue");
			//城投行政级别
			addInput("vcCityLevel", "vcCityLevel");
			//下一利率跳升点数
			addInput("lNInterestRateJumpPoints", "lNInterestRateJumpPoints");
			//特殊条款
			addInput("vcSpecialText", "vcSpecialText");

		}
		//还原必填
		function addInput(inputNuiId, inputJQId) {
			nui.get(inputNuiId).readOnly = "";//nui 取消禁用
			$("#" + inputJQId + " input").attr("readonly", "");// 取消 解决nui禁用IE兼容
			$("#" + inputJQId + " input").css("background-color", "");//取消 置灰
		}
		//发行主体禁用父节点
		function beforenodeselect(e) {
			//禁止选中父节点
			if (e.isLeaf == false)
				e.cancel = true;
		}

		//计算债券占比比例值
		function BondAccountedCalculation() {
			var enIssueBalance = nui.get("enIssueBalance").getValue().replace(
					/,/gi, ''); //发行规模
			var form = new mini.Form("#dataform1");
			var vcMainUnderwriter = nui.get("stockissueinfo.vcMainUnderwriter")
					.getValue();
			var vcDeputyUnderwriter = nui.get(
					"stockissueinfo.vcDeputyUnderwriter").getValue();
			var vcGroupUnderwriter = nui.get(
					"stockissueinfo.vcGroupUnderwriter").getValue();
			var vcMainUnderwriterId = nui.get("vcMainUnderwriterId").getValue();
			var vcDeputyUnderwriterId = nui.get("vcDeputyUnderwriterId")
					.getValue();
			var hlRivalId = nui.get("hlRivalId").getValue();
			form.validate();
			nui.get("stockissueinfo.vcMainUnderwriter").setValue(
					vcMainUnderwriter);
			nui.get("stockissueinfo.vcDeputyUnderwriter").setValue(
					vcDeputyUnderwriter);
			nui.get("stockissueinfo.vcGroupUnderwriter").setValue(
					vcGroupUnderwriter);
			nui.get("vcMainUnderwriterId").setValue(vcMainUnderwriterId);
			nui.get("vcDeputyUnderwriterId").setValue(vcDeputyUnderwriterId);
			nui.get("hlRivalId").setValue(hlRivalId);
			if (form.isValid() == false) {
				nui.alert("有数据为空或填写不正确，请确认！");
				return;
			}
			var reportData = getReportData(grid, form);

			var data = form.getData(false, true); //获取表单多个控件的数据
			var enInvestBalance = getReportBidInfo(reportData.applyInstReport,
					data.applyInst).enInvestBalance; //缴款面额		   
			var enNetScale = nui.get("enNetScale").getValue()
					.replace(/,/gi, ''); //净值规模
			var enCategoryMoney = nui.get("fsumamount").getValue().replace(
					/,/gi, ''); //债券存量		
			//当发行规模与缴款面额不为空并且不为0时计算该笔债券投资占发行规模比例
			//公式为缴款面额/发行规模
			if (enIssueBalance != "" && enInvestBalance != ""
					&& enIssueBalance != 0 && enInvestBalance != 0) {
				nui.get("enInvestScaleRatio").setValue(
						((enInvestBalance / (enIssueBalance * 10000)) * 100)
								.toFixed(6));
			} else {
				nui.get("enInvestScaleRatio").setValue(0);
			}

			//当缴款面额、债券存量与净值规模都不为空并且都不为0时计算同一发行人占产品净值规模比例
			//公式为(本次缴款面额+主体发行债券存量)/净值规模
			if (enNetScale != ""
					&& (enInvestBalance != "" || enCategoryMoney != "")) {
				if (enNetScale != 0) {
					nui
							.get("enIssuerNetRatio")
							.setValue(
									(((Number(enInvestBalance) + Number(enCategoryMoney)) / enNetScale) * 100)
											.toFixed(6));
				}
			} else {
				nui.get("enIssuerNetRatio").setValue(0);
			}

			//当净值规模与缴款面额不为空并且不为0时计算该笔债券投资占产品净值规模比例
			//公式为缴款面额/净值规模
			if (enNetScale != "" && enInvestBalance != "" && enNetScale != 0
					&& enInvestBalance != 0) {
				nui.get("enInvestNetRatio").setValue(
						((enInvestBalance / enNetScale) * 100).toFixed(6));
			} else {
				nui.get("enInvestNetRatio").setValue(0);
			}
		}

		//获取报量Datagrid的数据
		function getReportData(grid, form) {
			var rtdata = grid.data;//获取报量信息
			//存储整理后的报量数据
			var applyInstReport = new Array();
			var k = 0; //计数器

			//判定报量报价是否有未校验通过的值
			//校验报量报价信息
			if (checkReports1(rtdata) == false) {
				return false;
			}

			//提取报量数据
			for (var i = 0; i < rtdata.length; i++) {
				//新增vcReportRemark
				if ((rtdata[i].enReport != "" && rtdata[i].enReport != null)
						|| (rtdata[i].enOffer != "" && rtdata[i].enOffer != null)) {
					var report_t = form.getData(false, true).report;//获取临时变量
					report_t.enReport = rtdata[i].enReport;//用户输入的报量
					report_t.enOffer = rtdata[i].enOffer;
					//report_t.enEnsureGold=rtdata[i].enEnsureGold;
					report_t.vcReportRemark = rtdata[i].vcReportRemark;
					report_t.lValidStatus = 0;//状态	0-有效;1-无效-修改;2-无效-废弃
					applyInstReport[k] = report_t;
					k++;

				}
			}
			var rdata;//存储返回值
			rdata = {
				applyInstReport : applyInstReport
			};

			return rdata;
		}
		
		
		var vcAbsTypes = [{ id: 1, text: '优先' }, { id: 2, text: '次级'}];
		function onAccountTypeChanged(e) {
			     var vcAbsType= nui.get("vcAbsType");
		         vcAbsType.setData();
		         vcAbsType.setRequired(false);
			if (e.value == 'Q' || e.value == 'O') {
				document.getElementById("mortInfo").style.display = "";
				document.getElementById("mortAmount").style.display = "";
             }else if(e.value == 'M1' || e.value == 'M2'|| e.value == 'M3'){
	          vcAbsType.setData(vcAbsTypes);
	          vcAbsType.setRequired(true);
	        
	        } else {
				document.getElementById("mortInfo").style.display = "none";
				document.getElementById("mortAmount").style.display = "none";

				nui.get("vcMortStockName").setValue("");
				nui.get("vcMortStockCode").setValue("");
				nui.get("vcMortStockAmount").setValue("");
			}
			var place = nui.get("stockissueinfo.vcPaymentPlace").getValue();
			var vcStockType = nui.get("vcStockType").getValue();
			if ("D" == vcStockType && "02" == place) {
				nui.get("cPayType").setValue(3);
			} else if (place == "01") {
				//中央结算公司cPayType
				nui.get("cPayType").setValue(2);
			} else if (place == "02") {
				//上海清算所
				nui.get("cPayType").setValue(1);
			} else {
				nui.get("cPayType").setValue(3);
			}
			cheangedCpayType();
		}
		
		
		
		
		function onAccountTypeChanged1(eid) {
			if (eid == 'Q' || eid == 'O') {
				document.getElementById("mortInfo").style.display = "";
				document.getElementById("mortAmount").style.display = "";

			} else {
				document.getElementById("mortInfo").style.display = "none";
				document.getElementById("mortAmount").style.display = "none";

				nui.get("vcMortStockName").setValue("");
				nui.get("vcMortStockCode").setValue("");
				nui.get("vcMortStockAmount").setValue("");
			}
		}
		function countEnExistLimite() {
			var lBegincalDate = dateTemp(
					nui.get("stockissueinfo.lBegincalDate").getValue()).substr(
					0, 10);//计息起始日期
			lBegincalDate = Date.parse(new Date(lBegincalDate
					.replace(/-/g, "/")));
			var lEndincalDate = dateTemp(
					nui.get("stockissueinfo.lEndincalDate").getValue()).substr(
					0, 10);//到期日
			lEndincalDate = Date.parse(new Date(lEndincalDate
					.replace(/-/g, "/")));
			if (lBegincalDate != null && lEndincalDate != null
					&& lEndincalDate <= lBegincalDate) {
				nui.alert("到期日不能小于等于计息起始日期!", "提示");
				return;
			}
			if (lBegincalDate != null && lEndincalDate != null
					&& lEndincalDate > lBegincalDate) {
				var nTime = lEndincalDate - lBegincalDate;
				var day = Math.floor(nTime / 86400000);
				day = day / 365;
				nui.get("enExistLimite").setValue(day.toFixed(4));
			}
		}
		function checkvcSpecialText(e) {
			var cIsHave = e.value;
			if (cIsHave.indexOf("2") >= 0) {
				//赎回权
				nui.get("cIsHaveBuyback").setValue("1");
				readonlyInput("cIsHaveBuyback", "cIsHaveBuyback");
			} else {
				//赎回权
				nui.get("cIsHaveBuyback").setValue("0");
				addInput("cIsHaveBuyback", "cIsHaveBuyback");
			}
			if (cIsHave.indexOf("1") >= 0) {
				//回售权
				nui.get("cIsHaveSaleback").setValue("1");
				readonlyInput("cIsHaveSaleback", "cIsHaveSaleback");
			} else {
				//回售权
				nui.get("cIsHaveSaleback").setValue("0");
				addInput("cIsHaveSaleback", "cIsHaveSaleback");
			}
		}

		var isReadonly = true;
		var checkrole = "";
		//判断角色，交易员可以修改新债信息0:投资经理,1:交易员,2:投顾
		$(function() {
			$
					.ajax({
						url : "com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.queryTAtsProductInfo.biz.ext",
						type : 'POST',
						data : null,
						cache : false,
						async : false,
						contentType : 'text/json',
						success : function(result) {
							var returnJson = nui.decode(result);
							var data = returnJson.data;
							checkrole = returnJson.checkrole;
							if (data != null) {
								productCombo.setData(data);
							}
							if (checkrole == "1") {
								readonlyCleanAndRequired();
								isReadonly = false;
							}
							if (isReadonly == true) {
								//非纸质指令隐藏
								$("#attachmentListShow").hide();
							}
						}
					});
		});

		//清理有债券的禁用信息
		function readonlyCleanAndRequired() {

			//债券类型stockissueinfo.vcStockType
			addInput("vcStockType", "vcStockType");
			$("#vcStockType").addClass("mini-required");//添加必填样式
			nui.get("vcStockType").setRequired(true);//添加必填
			//债券代码
			addInput("stockissueinfo.vcStockCode",
					"stockissueinfo\\.vcStockCode");

			//债券简称
			addInput("vcStockName", "vcStockName");
			$("#vcStockName").addClass("mini-required");//添加必填样式
			nui.get("vcStockName").setRequired(true);//必填

			//债券全称
			addInput("vcStockNameFull", "vcStockNameFull");
			$("#vcStockNameFull").addClass("mini-required");//添加必填样式
			nui.get("vcStockNameFull").setRequired(true);//必填
			$("#vcStockNameFull_lab").show();
			//登记托管所
			addInput("stockissueinfo.vcPaymentPlace",
					"stockissueinfo\\.vcPaymentPlace");
			//发行主体
			addInput("lookup3", "lookup3");
			$("#lookup3").addClass("mini-required");//添加必填样式
			nui.get("lookup3").setRequired(true);//必填
			$("#lIssuerId_lab").show();
			//主体类型
			addInput("vcIssueProperty", "vcIssueProperty");
			//主体评级
			addInput("cIssueAppraise", "cIssueAppraise");
			$("#cIssueAppraise").addClass("mini-required");//添加必填样式
			nui.get("cIssueAppraise").setRequired(true);//必填
			$("#cIssueAppraise_lab").show();
			//债券评级
			addInput("cBondAppraise", "cBondAppraise");
			$("#cBondAppraise").addClass("mini-required");//添加必填样式
			nui.get("cBondAppraise").setRequired(true);//必填
			$("#cBondAppraise_lab").show();
			//评级机构
			addInput("vcIssueAppraiseOrgan", "vcIssueAppraiseOrgan");
			$("#vcIssueAppraiseOrgan").addClass("mini-required");//添加必填样式
			nui.get("vcIssueAppraiseOrgan").setRequired(true);//必填
			$("#vcIssueAppraiseOrgan_lab").show();
			//评级机构
			addInput("vcBondAppraiseOrgan", "vcBondAppraiseOrgan");
			$("#vcBondAppraiseOrgan").addClass("mini-required");//添加必填样式
			nui.get("vcBondAppraiseOrgan").setRequired(true);//必填
			$("#vcBondAppraiseOrgan_lab").show();
			//发行规模
			addInput("enIssueBalance", "enIssueBalance");
			$("#enIssueBalance").addClass("mini-required");//添加必填样式
			nui.get("enIssueBalance").setRequired(true);//必填
			$("#enIssueBalance_lab").show();
			//发行方式
			addInput("vcIssueType", "vcIssueType");
			//特殊期限
			addInput("vcSpecialLimite", "vcSpecialLimite");
			//发行期限
			addInput("enExistLimite", "enExistLimite");
			$("#enExistLimite").addClass("mini-required");//添加必填样式
			nui.get("enExistLimite").setRequired(true);//必填
			$("#enExistLimite_lab").show();
			//赎回权
			addInput("cIsHaveBuyback", "cIsHaveBuyback");
			//回售权
			addInput("cIsHaveSaleback", "cIsHaveSaleback");
			//所属行业（证监会二级）
			addInput("vcIssueAppraiseCsrc", "vcIssueAppraiseCsrc");
			//公司净资产
			addInput("enIssuerNetValue", "enIssuerNetValue");
			//城投行政级别
			addInput("vcCityLevel", "vcCityLevel");
			//下一利率跳升点数
			addInput("lNInterestRateJumpPoints", "lNInterestRateJumpPoints");
			//特殊条款
			addInput("vcSpecialText", "vcSpecialText");
			//主承销商
			addInput("stockissueinfo.vcMainUnderwriter",
					"stockissueinfo\\.vcMainUnderwriter");
			$("#stockissueinfo.vcMainUnderwriter").addClass("mini-required");//添加必填样式
			nui.get("stockissueinfo.vcMainUnderwriter").setRequired(true);//必填
			$("#vcMainUnderwriter_lab").show();
			//交易对手
			addInput("lookup1", "lookup1");
			$("#lookup1").addClass("mini-required");//添加必填样式
			nui.get("lookup1").setRequired(true);//必填
			$("#hlRivalId_lab").show();

			addInput("enPayInteval", "enPayInteval");
			$("#enPayInteval").addClass("mini-required");//添加必填样式
			nui.get("enPayInteval").setRequired(true);//必填
			$("#enPayInteval_lab").show();
			addInput("stockissueinfo.lBegincalDate",
					"stockissueinfo\\.lBegincalDate");
			$("#stockissueinfo.lBegincalDate").addClass("mini-required");//添加必填样式
			nui.get("stockissueinfo.lBegincalDate").setRequired(true);//必填
			$("#lBegincalDate_lab").show();
			addInput("vcModeRepayment", "vcModeRepayment");
			$("#vcModeRepayment").addClass("mini-required");//添加必填样式
			nui.get("vcModeRepayment").setRequired(true);//必填
			$("#vcModeRepayment_lab").show();
			addInput("stockissueinfo.lEndincalDate",
					"stockissueinfo\\.lEndincalDate");
			$("#stockissueinfo.lEndincalDate").addClass("mini-required");//添加必填样式
			nui.get("stockissueinfo.lEndincalDate").setRequired(true);//必填
			$("#lEndincalDate_lab").show();
			addInput("cPayType", "cPayType");
			$("#cPayType").addClass("mini-required");//添加必填样式
			nui.get("cPayType").setRequired(true);//必填
			$("#cPayType_lab").show();

		}

		function myEditorFile() {
			//var rows = document.getElementById("prodIfm").contentWindow.FileSelectedDatas();

			var rows = nui.get("file_grid").getSelecteds(); //获取选中的附件信息
			if (rows.length == 0) {
				nui.alert("请选择一条附件！", "系统提示");
				return;
			}
			if (rows.length > 1) {
				nui.alert("只能选择一条附件！", "系统提示");
				return;
			}

			var type = 4; //文档编辑类型
			var vcProductCode = nui.get("vcProductCode").getValue(); //产品编号
			var lBizId = bizId; //业务ID

			if (vcProductCode == null || vcProductCode == "") {
				nui.alert("请先选择产品信息，才能打开附件查阅。", "系统提示");
				return;
			}

			var vcStockCode = nui.get("stockissueinfo.vcStockCode").getValue();
			var vcStockName = nui.get("vcStockName").getValue();
			var cApplyInstType = nui.get("cApplyInstType").getValue();
			for (var i = 0; i < rows.length; i++) {
				//encodeURI 可解决IE的url中文乱码问题
				var actionURL = encodeURI(contextPath
						+ "/commonUtil/iWebOffice/Judgment_document_type.jsp?sysid="
						+ rows[i].lAttachId + "&fileName="
						+ rows[i].vcAttachName + "&type=" + type
						+ "&vcProductCode=" + vcProductCode + "&vcStockName="
						+ vcStockName + "&vcStockCode=" + vcStockCode
						+ "&bizId=" + lBizId + "&cApplyInstType="
						+ cApplyInstType); //目标页面

				var winFrm = document.openForm;
				winFrm.action = actionURL;
				var newwin = window.open('about:blank', 'newWindow' + lBizId);
				winFrm.target = 'newWindow' + lBizId;//这一句是关键
				winFrm.submit();
			}
		}
		function loademployeeGrid() {
			//用印附件列表 设置参数
			nui.get("mapBizId").setValue(bizId);
			//附件列表查询
			var file_grid = nui.get("file_grid");
			var file_Form = new nui.Form("#file_Form").getData(false, false);
			file_grid.load(file_Form);
		}
		//刷新附件列表
		function refreshFile() {

			//用印附件列表 设置参数
			nui.get("mapBizId").setValue(bizId);
			//附件列表
			var file_grid = nui.get("file_grid");
			var file_Form = new nui.Form("#file_Form").getData(false, false);
			file_grid.load(file_Form);
		}
	//生成申购函
     function generateFile(processInstID,bizId,stockInvestNo){
     	//console.log("生成申购函");
     	var productCode = nui.get("vcProductCode").getValue();
     	var params = new Array();
 		var map = {};
 		map['bizId']=bizId;
 		map['processInstId']=processInstID;
 		map['stockInvestNo']=stockInvestNo;
 		params[0] = map;
 		var json1 = nui.encode({templateFilePath:templeatePath,productCode:productCode,params:params});
 		//console.log("json1 = "+json1);
		$.ajax({
			  url:'com.cjhxfund.ats.fm.instr.FirstGradeBond.generatePurchaseOrder.biz.ext',
			  type:'POST',
			  data:json1,
			  cache:false,
			  contentType:'text/json',
			  success:function(data){
				  var returnJson = nui.decode(data);
				  if(returnJson.exception == null){
	              	//nui.alert("申购函生成成功");
	              	//console.log(returnJson.attachmentIds);
	              	window.parent.frames[0].location.reload(); 
		          }else{
		            nui.alert("申购函生成失败");
		          }
			  }
		  });
     	
     }
     var templeatePath=null; 
     function generatePurchaseOrder(){
		//获取表单提交数据
		var form = new mini.Form("#dataform1"); 
		var vcMainUnderwriter=nui.get("stockissueinfo.vcMainUnderwriter").getValue();
		var vcDeputyUnderwriter=nui.get("stockissueinfo.vcDeputyUnderwriter").getValue();
		var vcGroupUnderwriter=nui.get("stockissueinfo.vcGroupUnderwriter").getValue();
		var vcMainUnderwriterId=nui.get("vcMainUnderwriterId").getValue();
		var vcDeputyUnderwriterId=nui.get("vcDeputyUnderwriterId").getValue();
		var hlRivalId=nui.get("hlRivalId").getValue();
		form.validate();
		nui.get("stockissueinfo.vcMainUnderwriter").setValue(vcMainUnderwriter);
	    nui.get("stockissueinfo.vcDeputyUnderwriter").setValue(vcDeputyUnderwriter);
	    nui.get("stockissueinfo.vcGroupUnderwriter").setValue(vcGroupUnderwriter);
	    nui.get("vcMainUnderwriterId").setValue(vcMainUnderwriterId);
		nui.get("vcDeputyUnderwriterId").setValue(vcDeputyUnderwriterId);
		nui.get("hlRivalId").setValue(hlRivalId);
		if(form.isValid() == false){
			nui.alert("业务信息必填项不能为空或者有数据输入格式不正确！");
			return;
		}
		
		//无债券时验证
	    if(biztype==1){
	    	nui.alert("无债券缴款录入，提交流程后转至新债缴款页面生成申购函!","提示");
    			return;
			//暂不支无债券生成申购函，以下代码暂时废弃
			var data = form.getData(false,true);      //获取表单多个控件的数据
			var stockissueinfo,bizprocess,applyInst;
			stockissueinfo=data.stockissueinfo;
			applyInst=data.applyInst;
			bizprocess=data.bizprocess;
			stockissueinfo.enCategoryMoney = nui.get("fsumamount").getValue().replace(/,/gi,'');
			bizprocess.vcProcessType=8;
			stockissueinfo.lStockInvestNo=applyInst.lStockInvestNo;//证券投资编号
			bizprocess.lStockInvestNo=applyInst.lStockInvestNo;//证券投资编号
			bizprocess.vcAbstract="一级债分销缴款";
			bizprocess.lBizId=bizId;
			var cMarketNo=stockissueinfo.vcPaymentPlace;
			//债券表登记托管机构转换
			if(cMarketNo=="03"){
				cMarketNo=1;
			}else if(cMarketNo=="04"){
				cMarketNo=2;
			}else{
				cMarketNo=5;
			}
			stockissueinfo.cMarketNo=cMarketNo;//交易市场
			stockissueinfo.lIssuerId=nui.get("lookup3").getValue();
			var lBegincalDate1=stockissueinfo.lBegincalDate.replace(/-/gi,'').substr(0,8);//计息起始日期
			var lEndincalDate1=stockissueinfo.lEndincalDate.replace(/-/gi,'').substr(0,8);//计息截止日期
			var lPayDate1=stockissueinfo.lPayDate.replace(/-/gi,'').substr(0,8);//缴款日期
			var lIssueBeginDate1=stockissueinfo.lIssueBeginDate.replace(/-/gi,'').substr(0,8);//发行日期
			
			
			stockissueinfo.lBegincalDate=lBegincalDate1;
			stockissueinfo.lEndincalDate=lEndincalDate1;
			stockissueinfo.lPayDate=lPayDate1;
			stockissueinfo.lIssueBeginDate=lIssueBeginDate1;
			stockissueinfo.cStatus=0;//复核状态 0草稿,1待复核,2正常,3合并中,4失效
			
			
			console.log(stockissueinfo);
			
			var json1 = nui.encode({stockIssueInfo:stockissueinfo,saveType:'1',bizprocess:bizprocess});
			nui.confirm("当前为无债券录入，是否保存债券信息？","缴款提示",function(act){
				if(act=="ok"){
					$.ajax({
			            url:'com.cjhxfund.ats.fm.instr.StockIssueInfoBiz.saveDraftStockIssueInfo.biz.ext',
			            type:'POST',
			            data:json1,
			            cache:false,
			            contentType:'text/json',
			            success:function(data){
         					var templateQueryParams = new Array();
					 		var queryMap={};
					 		queryMap['stockInvestNo'] = nui.get("applyInst.lStockInvestNo").getValue();
					 		templateQueryParams[0] = queryMap;
					     	var json = nui.encode({templateQueryParams:templateQueryParams});
					     	//console.log("json = " + json);
					     	$.ajax({
						            url:'com.cjhxfund.ats.fm.baseinfo.tatsstocktemplatebiz.queryTemplateFilePath.biz.ext',
						            type:'POST',
						            data:json,
						            cache:false,
						            contentType:'text/json',
						            success:function(data){
						             	var returnJson = nui.decode(data);
					             		if(returnJson.templateFilePath=="erro"){
						         			nui.alert("选中的债券对应多个申购函模板。");
						         			generateFileSwitch=false;
						         			return;
						         		}
						         		if(returnJson.templateFilePath==null||returnJson.templateFilePath=="null"){
						         			nui.alert("选中的债券还没有配置对应的申购函模板。");
						         			generateFileSwitch=false;
						         			return;
								     	}
								     	templeatePath=returnJson.templateFilePath;
								     	nui.confirm("保存该页面后会自动生成申购函","申购提示",function(act){
											if(act=="ok"){
												generateFileSwitch=true;
												//console.log("生成申购函");
											}else{
												generateFileSwitch=false;
											}
										});
						     		}
					 			});
     					}
 					});
				}
				//关闭界面
				return;
			});
		}else{
			var templateQueryParams = new Array();
	 		var queryMap={};
	 		queryMap['stockInvestNo'] = nui.get("applyInst.lStockInvestNo").getValue();
	 		templateQueryParams[0] = queryMap;
	     	var json = nui.encode({templateQueryParams:templateQueryParams});
	     	//console.log("json = " + json);
	     	$.ajax({
		            url:'com.cjhxfund.ats.fm.baseinfo.tatsstocktemplatebiz.queryTemplateFilePath.biz.ext',
		            type:'POST',
		            data:json,
		            cache:false,
		            contentType:'text/json',
		            success:function(data){
		             	var returnJson = nui.decode(data);
	             		if(returnJson.templateFilePath=="erro"){
		         			nui.alert("选中的债券对应多个申购函模板。");
		         			generateFileSwitch=false;
		         			return;
		         		}
		         		if(returnJson.templateFilePath==null||returnJson.templateFilePath=="null"){
		         			nui.alert("选中的债券还没有配置对应的申购函模板。");
		         			generateFileSwitch=false;
		         			return;
				     	}
				     	templeatePath=returnJson.templateFilePath;
				     	nui.confirm("保存该页面后会自动生成申购函","申购提示",function(act){
							if(act=="ok"){
								generateFileSwitch=true;
								//console.log("生成申购函");
							}else{
								generateFileSwitch=false;
							}
						});
		     		}
	 			});
		
		}
     }
	</script>
</body>
</html>