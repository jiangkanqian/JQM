<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false" %>
<%@ page import="com.eos.foundation.eoscommon.CacheUtil" %>
<%@ page import="commonj.sdo.DataObject" %>
<%@ page import="com.eos.foundation.data.DataObjectUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/common.jsp" %>
<% 
//从缓存中获取对应的净价和中债t-1的估价净价偏差比
String deviationKey ="NET_RATE_ESTIMATE_DEVIATION";
DataObject deviation= (DataObject)CacheUtil.getValue("ReloadParamConf1",deviationKey);
String deviationValue = (String)deviation.get("paramValue");
%>
<!-- 
  - Author(s): 吴艳飞
  - Date: 2016-09-13 13:58:47
  - Description:
-->
<head>
<title>银行间下达投资指令/建议</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <style type="text/css">
    	.mini-buttonedit-border{
    		padding-right:1px;
    	}
    </style>
    <style type="text/css">
    	.nui-textbox {
		    width:100%;
		 } 
		#complete_instruction span{
		 	color:red;
		 }
		.instructTable tr{
		 	height:32px;
		 }
		
    </style>
    <script type="text/javascript" src="<%= request.getContextPath() %>/JQMHistory/common/common.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/riskMgr/js/riskMgrComm.js"></script>
    <script type="text/javascript">
    	$(function(){
    		 //初始化改变债券代码选择提示语句
    		$("#vcStockCode>span>input").attr("placeholder","请输入债券代码...");
    		$("#vcCounterpartyId>span>input").attr("placeholder","对手中文或首位拼音...");
    		$("#vcCounterpartyId>span").css({
    			"background":'#FFFFE6'
    		});
			nui.get("tradeDate").setValue(new Date());
			nui.get("vcSettleSpeed").setValue("0");
			nui.get("firstSettleDate").setValue(new Date());
			$("#vcEntrustDirection  label:first").css({
					"color":"red"
			});
			$("#vcEntrustDirection  label:last").css({
					"color":"green"
			});
			//当为IE8时，使用js调整宽度
			if(navigator.userAgent.indexOf("MSIE 8.0")>0){
					var width = parseFloat($("container").width());
							$("#bondDetailCont > div:first").css({
								width:(width - 505)+ "px"
							});
			}
			//限制交易日
			limitTradeDate("tradeDate");
		})
			
    </script>
</head>
<body>
	<div class="container" style="height:100%;width:100%;">
		<div style="float:left; width:calc(100%-505px);height:auto;" id="bondDetailCont">
		<!--主体部分左边查询项begin  -->
			<div id="bond_details"  >
				<table border="0" cellpadding="1" cellspacing="2" style="width:100%;" >
					<tr>
						<td style="width:80px;" align="right">债券类型:</td>
		                <td style="width:100px;" align="left"><input  name="vcStocktypeName" class="nui-textbox" enabled="false"/></td>
	                    <td style="width:120px;" align="right">起息日:</td>
		                <td style="width:100px;" ><input name="lBegincalDate" class="nui-textbox"  enabled="false"/></td>
					</tr>
					<tr>
						<td align="right">债项评级:</td>
	                	<td><input name="vcBondAppraise" class="nui-dictcombobox" valueField="dictID" textField="dictName" dictTypeId="creditRating" enabled="false"/></td>
	                    <td align="right">下一付息日:</td>
		                <td><input name="lNextPayintDate" class="nui-textbox"  enabled="false"/></td>
					</tr>
					<tr>
						<td align="right">主体评级:</td>
						<td><input name="vcIssueAppraise" class="nui-dictcombobox" valueField="dictID" textField="dictName" dictTypeId="issuerRating" enabled="false"/></td>
		                <td align="right">距下一付息日天数:</td>
		                <td><input name="lNextPayintDays" class="nui-textbox"  enabled="false"/></td>
					</tr>
					<tr>
						<td align="right">发行机构:</td>
		                <td><input name="vcIssuerNameFull" class="nui-textbox"  enabled="false"/></td>
		                <td align="right">到期日:</td>
		                <td><input name="lEndincalDate" class="nui-textbox"  enabled="false"/></td>
					</tr>
					<tr>
						<td align="right">担保方式:</td>
		                <td><input name=vcAssureType class="nui-dictcombobox" valueField="dictID" textField="dictName" dictTypeId="ATS_FM_ASSUER_TYPE" enabled="false"/></td>
		                <td align="right">剩余期限:</td>
		                <td><input class="nui-textbox" name="lLimiteLeft" enabled="false"/></td>
					</tr>
					<tr>
						<td align="right">特殊条款:</td>
		                <td><input name="vcSpecialText" class="nui-textbox"  enabled="false"/></td>
		                <td align="right">距到期日天数:</td>
		                <td><input name="lEndincalDays" class="nui-textbox"  enabled="false"/></td>
					</tr>
					<tr>
						<td align="right">票面面值:</td>
		                <td><input name="enParvalue" class="nui-textbox"  enabled="false"/></td>
		                <td align="right">中债估价净价(元):</td>
		                <td><input id="enCbValueNetValue" name="enCbValueNetValue" class="nui-textbox"  enabled="false"/></td>
					</tr>
					<tr>
						<td align="right">基准类别:</td>
		                <td><input name="vcBchmkRate" class="nui-textbox"  enabled="false"/></td>
		                <td align="right">中债估价全价(元):</td>
		                <td><input name="enCbValueAllValue" class="nui-textbox"  enabled="false" /></td>
					</tr>
					<tr>
						<td align="right">票面利率:</td>
		                <td><input name="enFaceRate" class="nui-textbox"  enabled="false"/></td>
		                <td align="right">中债估价收益率(%):</td>
		                <td><input name="enCbValueIncmRate" class="nui-textbox"  enabled="false"/></td>
					</tr>
					<tr>
						<td align="right">利率类型:</td>
		                <td><input name="cInterestType" class="nui-dictcombobox" valueField="dictID" textField="dictName" dictTypeId="rateType" enabled="false"/></td>
		                <td align="right">中债估价修正久期:</td>
		                <td><input name="enCbValueMduration" class="nui-textbox"  enabled="false"/></td>
					</tr>
					<tr>
						<td align="right">付息频率:</td>
		                <td><input name="enPayInteval" class="nui-textbox"  enabled="false"/></td>
		                <td align="right">中债估值凸性:</td>
		                <td><input name="enCbValueConvexity" class="nui-textbox"  enabled="false"/></td>
					</tr>
		            	<tr>
		            		<td colspan="4">
		            			<div style="width:100%;height:1px;border-bottom:1px dashed #000;margin-top:10px;margin-botton:10px"></div>
		            		</td>
		            	</tr>
		            
		           </table>	
			  </div>
			  		  
		      <div id="available_details"  style="" >
				<table border="0" cellpadding="1" cellspacing="2" style="width:100%;" >
					<tr>
	                	<td style="width:80px;" align="right">T+0头寸:</td>
	                    <td style="width:100px;"><input id="vcAvailableamountT0"  name="vcAvailableamountT0" class="nui-textbox"  enabled="false"/></td>
	                    <td style="width:120px;" align="right">基金净资产:</td>
	                    <td style="width:100px;"><input id="enFundValue" name="enFundValue" class="nui-textbox"  enabled="false" /></td>
	                </tr>
	                <tr>
	                	<td align="right">T+1头寸:</td>
	                    <td><input id="vcAvailableamountT1"  name="vcAvailableamountT1" class="nui-textbox"  enabled="false"/></td>
	                    <td align="right">持仓(占%):</td>
	                    <td><input id="positionRatio" name="positionRatio" class="nui-textbox"  enabled="false"/></td>
	                </tr>
	                <tr>
	                	<td align="right">T+0可用数量:</td>
	                    <td><input id="vcAvailablequantityT0"  name="vcAvailablequantityT0" class="nui-textbox"  enabled="false"/></td>
	                    <td align="right">未成(占%):</td>
	                    <td><input id="unachievedRatio"  name="unachievedRatio"class="nui-textbox"  enabled="false" /></td>
	                </tr>
	                <tr>
	                	<td align="right">T+1可用数量:</td>
	                    <td><input id="vcAvailablequantityT1"  name="vcAvailablequantityT1" class="nui-textbox"  enabled="false"/></td>
	                    <td align="right">指令/建议(占%):</td>
	                    <td><input id="instructRatio"  name="instructRatio" class="nui-textbox"  enabled="false"/></td>
	                </tr>
	                <tr >
	                	<td align="right"></td>
	                    <td></td>
	                	<td align="right">合计(占%):</td>
	                    <td><input id="totalRatio"  name="totalRatio" class="nui-textbox"  enabled="false"/></td>
	                </tr>
		   		</table>	
			</div>
			<!--主体部分左边查询项end  -->
		</div>
		
		<div id="tabs" class="nui-tabs" style="height:100%; width:570px;float:right;" activeIndex="0">
			<div title="银行间债券市场">
				<div id="complete_instruction">
					<input class="nui-hidden" name="operatorType" id="operatorType" value="1"/>
					<!-- 业务类别:2-银行间二级市场业务 D-债券一级市场 E-交易所大宗交易，I-上交所固定收益平台 -->
					<input class="nui-hidden" name="businClass" id="businClass" value="2"/>
					<!-- 交易市场：OTC-场外（银行间）SS-上交所，SZ-深交所； -->
					<input id="exdestination" name="exdestination" class="nui-hidden" value="OTC"/>
					<!-- 投资类型：交易所，1-可交易；2-持有到期；3-可供出售；回购业务投资类型为1-可交易，不传投资类型会根据系统数决定取组合的投资类型或缺省为1-可交易，具体取值和O3保持一致。 -->
					<input id="vcInvestType" name="vcInvestType" class="nui-hidden" value="1"/>
					<!-- 证券控制类型:1-金额控 、2-数量控、缺省按2-数量控 -->
					<input id="ordtype" name="ordtype" class="nui-hidden" value="2"/>
					<!-- 结算方式（首次结算方式）：1-见款付券\2- 见券付款\3-券款对付\4-纯券过户-->
					<input id="vcFirstSettleMode" name="vcFirstSettleMode" class="nui-hidden" value="3"/>
					<!-- 指令/建议有效模式，默认为0-Day：0 – Day，当日有效；1 – GTC，一直有效，直到完成或撤销；6 – GTD，到指定日前有效  -->
					<input id="timeinforce" name="timeinforce" class="nui-hidden" value="6"/>
					<!-- 判断可用：0-不判；1-判  -->
					<input id="judgeavailable" name="judgeavailable" class="nui-hidden" value="1"/>
					<!-- 判断风控：0-不判；1-判   -->
					<input id="judgerisk" name="judgerisk" class="nui-hidden" value="1"/>
					<!--业务类型 1:银行间二级交易  2:上海大宗交易  3:上海固收平台  4:深圳综合协议平台  -->
					<input class="nui-hidden" name="vcBizType" id="vcBizType" value="1"/>
					<!--币种 人民币:CNY  -->
					<input class="nui-hidden" name="vcCurrency" id="vcCurrency" value="CNY"/>
					<!--插表交易市场 1-上交所;2-深交所;5-银行间;6-场外;7-中金所 -->
					<input class="nui-hidden" name="vcMarket" id="vcMarket" value="5"/>
					<!--收益率类型：1-到期收益率，2-行权收益率  -->
					<input class="nui-hidden" name="vcYieldType" id="vcYieldType" value="1"/>
					<table border="0" class="instructTable" cellpadding="1" cellspacing="2" style="width: 100%;">
						<tr>
							<td style="width: 15.38%;" align="right" ><span>*</span>产品名称:</td>
							<td style="width: 28.79%;" align="left">
	                            <div name="vcProductCode" class="mini-autocomplete" pinyinField="ID" id="vcProductCode"
		                             textField="TEXT" valueField="ID"
		                             searchField="productCode"
		                             url="com.cjhxfund.commonUtil.applyInstUtil.QueryTAtsProductInfoMatchSort.biz.ext"
		                             showNullItem="false"
		                             allowInput="true"
		                             emptyText="请输入产品代码或产品名称..."
		                             nullItemText="请输入产品代码或产品名称..."
		                             valueFromSelect="true"
		                             showClose="true"
		                             onvaluechanged="selectFunds"
		                             oncloseclick="onCloseClick"
		                             popupWidth="300"
		                             style="width: 125px"
		                             required="true">
		                            <div property="columns">
		                                <div header="产品代码" field="ID" width="40px"></div>
		                                <div header="产品名称" field="TEXT"></div>
		                            </div>
		                        </div>
		                        <div class="nui-hidden" type="hidden" id="lProductId" name="lProductId" />
							</td>
							<td style="width: 19.30%;" align="right" ><span>*</span>净价/全价:</td>
							<td style="width: 36.53%;" align="left">
								<span><input class="nui-textbox" id="enNetPrice" name="enNetPrice" required="true" style="width: 63px" onvalidation="numberCheck" onblur="netPriceFun" /></span>
								<lable>/</lable> 
								<span><input class="nui-textbox" id="enFullPrice" name="enFullPrice" required="true" style="width: 63px" onvalidation="numberCheck" onblur="fullPriceFun"/></span>
								<input id="autoCalc" name="autoCalc"  class="nui-checkbox" checked="true" text="联动"/>
							</td>
						</tr>
						<tr>
							<td align="right" ><span>*</span>组合名称:</td>
							<td>
								<input name="vcCombiCode" class="nui-combobox" id="vcCombiCode"
	                               textField="TEXT" valueField="ID"
	                               dataField="data"
	                               showNullItem="false"
	                               allowInput="false"
	                               required="true"
	                               emptyText="请选择..."
	                               nullItemText="请选择..."
	                               onitemclick="onCombiLinkage"
	                               showClose="true"
	                               oncloseclick="onCloseClick"/>
							</td>
							<td align="right" id="MaturityLab"><span>*</span>到期/行权收益率:</td>
							<td align="left" id="MaturityField">
								<span><input class="nui-textbox" id="enMaturityYield" name="enMaturityYield" style="width: 63px" required="true"  onvalidation="numberCheck" onblur="interestRateFun"/></span> 
								<label id="MaturityLabSplit">/</label> 
								<span><input class="nui-textbox" id="enOptionYield"  name="enOptionYield" style="width: 63px" required="true"  onvalidation="numberCheck" onblur="enOptionInterestRateFun"/></span>
							</td>
						</tr>
		
						<tr>
							<td align="right" ><span>*</span>债券代码:</td>
							<td>
								<div name="vcStockCode" class="nui-autocomplete" id="vcStockCode"
	                                 textField="stockCode" valueField="stockCode"
	                                 searchField="stockCode"
	                                 url="com.cjhxfund.ats.sm.comm.TBondBaseInfoManager.queryBankBetweenBondCode.biz.ext"
	                                 allowInput="true"
	                                 emptyText="请选择..."
	                                 nullItemText="请选择..."
	                                 valueFromSelect="true"
	                                 dataField="bondList"
	                                 multiSelect="false"
	                                 style="width:125px; float:left"
	                                 required="true"
	                                 popupWidth="300"
	                                 onvalidation="onO32ExistValidation"
	                                 onvaluechanged="onActionRenderer">
	                           		<div property="columns">
	                                    <div header="债券代码" field="stockCode" width="40px"></div>
	                                    <div header="债券名称" field="stockName"></div>
                                	</div>
	                    		</div>
	                    		<a class="mini-button" plain="true" style="float:left;height:19px;" iconCls="icon-search" onclick="showHoldingPage('interBankHolding.jsp')" tooltip="添加新债券"></a>
							</td>
							<td align="right" ><span>*</span>债券名称:</td>
							<td>
								<input id="vcStockName" class="nui-textbox" name="vcStockName"  style="width: 140px" required="true"  enabled="false"/>
								<input id="vcInterCode" class="nui-hidden"name="vcInterCode"/>
							</td>
							
						</tr>
						<tr>
							<td align="right" red="red"><span>*</span>委托方向:</td>
							<td><input id="vcEntrustDirection" class="nui-radiobuttonlist" name="vcEntrustDirection" onitemclick="changeToRed"
								data="[{id: '3', text: '买入'}, {id: '4', text: '卖出'}]" required="true"/></td>
							<td align="right" ><span>*</span>交易日期:</td>
							<td>
								<input id="tradeDate" class="nui-datepicker" name="tradeDate" required="true" allowInput="false" onvaluechanged="whetherTradeDate"  
											style="width: 140px" data-options='{dateType:"00"}' showClearButton="false" onvalidation="isTradeDate"/>
							</td>
						</tr>
						<tr>
							<td align="right" ><span>*</span>清算速度:</td>
							<td><input  id="vcSettleSpeed" class="nui-radiobuttonlist" name="vcSettleSpeed" required="true" onitemclick="whetherTradeDate"
								data="[{id: 0, text: 'T+0'}, {id: 1, text: 'T+1'}]"  onvaluechanged="enNetPriceMet"/></td>
							<td align="right" ><span>*</span>结算日期:</td>
							<td>
								<input id="firstSettleDate" class="nui-datepicker"  name="firstSettleDate" required="true"  style="width: 140px"  onvalidation="lDelistingVali"  readonly="readonly"/>
							</td>
						</tr>
						<tr>
							<td align="right" ><span>*</span>券面金额:</td>
							<td><input id="enFaceAmount" 
									class="nui-textbox" 
									name="enFaceAmount" 
									required="true" 
									onvalidation="faceAmountCheck"
									onblur="faceAmountAdjustandtest"
									style="margin-right:3px"/><span>万元</span>
							</td>
							<td align="right" ><span>*</span>交易对手:</td>
							<td>
								<div name="vcCounterpartyId" class="mini-autocomplete" id="vcCounterpartyId"
		                                 onvalidation="vcCounterpartyCheck"
		                                 textField="vcName" valueField="vcRivalCode"
		                                 searchField="vcPinyin"
		                                 url="com.cjhxfund.ats.sm.comm.TraderivalManager.QueryTraderByPinyin.biz.ext"
		                                 popupEmptyText="全部"
		                                 nullItemText="全部"
		                                 loadingText="加载中"
		                                 dataField="traders"
		                                 multiSelect="false"
		                                 style="width:140px"
		                                 popupWidth="300"
		                                 onvaluechanged="setIssueOrgan">
		                                <div property="columns">
			                                <div header="对手代码" field="vcRivalCode" width="20"></div>
			                                <div header="对手名称" field="vcName"></div>
	                					</div>
	                				</div>
							</td>
						</tr>
						<tr>
							<td align="right"><span>*</span>对方交易员:</td>
							<td><input id="vcCounterpartyTrader" class="nui-textbox" name="vcCounterpartyTrader" vtype="maxLength:64" required="true" /></td>
							<td align="right" >对手主体机构:</td>
							<td><input class="nui-textbox" showClose="true" id="vcCounterpartyOrgan" name="vcCounterpartyOrgan" style="width: 140px"/></td>
						</tr>
						<!-- <tr>
							<td align="right" style="width: 70px">附件:</td>
							<td><input class="nui-htmlfile" style="width: 280px" /></td>
						</tr> -->
						<tr style="height:64px !important">
							<td align="right" style="vertical-align: text-top;">备注:</td>
							<td colspan="3"><input class="nui-textarea"  id="vcRemark" name="vcRemark" vtype="maxLength:1024" style="width: 408px"/></td>
						</tr>
					</table>
				</div>
				<div style="text-align:center;padding:10px;">               
		            <a class="nui-button" iconCls="icon-tip" plain="true" id="exactrisk" onclick="riskControlTrial(this)">风控试算</a> 
					<a class="nui-button" iconCls="icon-ok" plain="true" id="exactCommit" onclick="commit(this)">提交</a> 
					<a class="nui-button" iconCls="icon-cancel" plain="true" onclick="onCancel()">取消</a>      
		        </div> 
			</div>
		</div>
	</div>
	<script type="text/javascript">
    	nui.parse();
    	$("#bondDetailCont .mini-buttonedit-button").remove();
    	var linkageResultInfo = null;//联动返回信息
    	var instructionInfo = null;//修改指令/建议的所有传值
    	var sumFaceAmount = null;//当前债券代码所有没有成交的数量
    	var cOverdraft = null; //可用金额是否允许透支 1:允许 2:不允许
    	var lLeftDays = null;  //距到期日天数
    	var originalInstructionInfo = null;//修改指令/建议时校验是否修改
		var investProductInfoCommon = "";//投资产品信息全局变量（债券代码,债券名称,交易市场编号,证券内码）
		var bondDetails = new nui.Form("#bond_details");
		var completeInstruction = new nui.Form("#complete_instruction");
		var hasSellback = true; //是否有回售条款
		var lDelistingDate = null; //摘牌日期
		var riskFlagParam = null;
		var lResultIdParam = null;
		var lRiskmgrIdParam = null;
		
		function onActionRenderer(e) {
			var businClass = nui.get("businClass").getValue();//业务类别-2（银行间）
			var exdestination = nui.get("exdestination").getValue();//交易市场代码-OTC
			var vcInvestType = nui.get("vcInvestType").getValue();//投资类型-1（可交易）
			var vcCombiCode = nui.get("vcCombiCode").getValue(); //组合代码
			var vcStockCode = e.value;//债券代码
			var vcMarketNo = nui.get("vcMarket").getValue();//交易市场代码
			if(vcStockCode){
				appointBondInfo(bondDetails,vcStockCode,vcMarketNo);
				var parameter = {businClass:businClass,exdestination:exdestination,vcEntrustDirection:3,vcInvestType:vcInvestType};
				var bondInfo = [{vcCombiCode:vcCombiCode,vcCombiNo:vcCombiCode,vcStockCode:vcStockCode,exdestination:exdestination}];
				if(checkO32Exist({vcStockCode:e.value,vcMarketNo:nui.get("vcMarket").getValue()})){
	        		instructAvaileAmount(parameter, bondInfo);
					enNetPriceMet();//根据净价联动
	        	}
			}
		}
		function onO32ExistValidation(e) {
            if (e.isValid) {
            	if(!checkO32Exist({vcStockCode:e.value,vcMarketNo:nui.get("vcMarket").getValue()})){
            		e.errorText = "O32不存在此债券";
              		e.isValid = false;
            	}
            }
        }
        
		//根据组合的变动获取对应头寸、资金净资产、透支条件，并且当债券代码不为空时更新可用。
		function onCombiLinkage(){
			//获取可用金额与净资产 start
			var vcProductCode = nui.get("vcProductCode").getValue();//产品代码
			var vcCombiCode = nui.get("vcCombiCode").getValue(); //组合代码
			var vcStockCode = nui.get("vcStockCode").getValue();//债券代码
			var vcMarketNo = nui.get("vcMarket").getValue();//交易市场代码
			var exdestination = nui.get("exdestination").getValue();//交易市场代码-OTC
			var businClass = nui.get("businClass").getValue();//业务类别-2（银行间）
			var vcInvestType = nui.get("vcInvestType").getValue();//投资类型-1（可交易）
			var dealPosition = {};
			dealPosition["vcProductCode"]=vcProductCode;
			dealPosition["vcCombiCode"] = vcCombiCode;
			dealPosition["vcCombiNo"]=vcCombiCode;
			dealPosition["exdestination"]=exdestination;
			dealPosition["businClass"]=businClass;
			if(vcCombiCode){
				nui.ajax({
					url:"com.cjhxfund.ats.sm.transaction.TransactionBizManager.queryAvailableAmount.biz.ext",
					type : 'POST',
					data : {dealPosition:dealPosition},
					cache : false,
					contentType : 'text/json',
					success : function(text) {
						var returnJson = nui.decode(text);
						if(returnJson.exception == null){
							cOverdraft = returnJson.cOverdraft;//否允许透支:1-允许, 2-不允许
							if(returnJson.sumList.length>0){
								var sumList = returnJson.sumList[0];
								var enFundValue = sumList.enFundValue;
								var vcAvailableamountT0 = sumList.vcAvailableamountT0;
								var vcAvailableamountT1 = sumList.vcAvailableamountT1;
								if(sumList.cLocalAvailable != null && sumList.cLocalAvailable == "0"){
									vcAvailableamountT0 = sumList.vcO32AvailableamountT0;
									vcAvailableamountT1 = sumList.vcO32AvailableamountT1;
								}
								if(nui.get("operatorType").getValue() == "1" && instructionInfo.cIsValid=="1"){//修改指令/建议
									var tradeQty = parseInt(0);
									var fullPrice = parseFloat(0);
									if(instructionInfo.vcProcessStatus=="4" || instructionInfo.vcProcessStatus=="5"){
										if(sumList.VC_TASSET==instructionInfo.vcAssetCode && instructionInfo.vcEntrustDirection == "3"){
											fullPrice = parseFloat(instructionInfo.enFullPrice.replace(/,/g,''));
											tradeQty = parseInt(instructionInfo.enFaceAmount.replace(/,/g,''))*100;
										}
									}else{
										if(sumList.cLocalAvailable != null && sumList.cLocalAvailable == "0"){
											//获取同业务编号，指令/建议记录流程已到O32的修改审核中的记录
											nui.ajax({
								        		data:{param:{lResultNo:instructionInfo.lResultNo,vcEntrustDirection:"3"}},
								        		async: false,
								        		url:"com.cjhxfund.ats.sm.comm.AvaiableDataManager.getO32UnderReviewInstruct.biz.ext",
								        		success:function(resp){
								        			var returnJson = nui.decode(resp);
													if(returnJson.exception == null){
														if(returnJson.updateCheckInstruct.length==1){
															var updateCheckInstruct = returnJson.updateCheckInstruct[0];
															if(updateCheckInstruct.VC_ASSET_CODE == sumList.VC_TASSET){
																tradeQty = (updateCheckInstruct.EN_FACE_AMOUNT)*100;
																fullPrice = updateCheckInstruct.EN_FULL_PRICE;
															}
														}
													}
									            }
										    });
										}else{
											if(sumList.VC_TASSET==instructionInfo.vcAssetCode){
												if(instructionInfo.vcEntrustDirection=="3"){//买入
													var now =  nui.formatDate(new Date(),"yyyyMMdd");//当日
													var now1 = nui.formatDate(new Date(new Date().getTime()+24*60*60*1000),"yyyyMMdd"); //修改指令/建议的可以金额校验需要
										    		//原指令/建议的交易日为今天的指令/建议或者交易日为明天的t+0指令/建议在需改时需要将资金加回
													if(instructionInfo.lTradeDate == now || (instructionInfo.lTradeDate == now1 && instructionInfo.vcSettleSpeed == "0")){
							    						tradeQty = parseInt(instructionInfo.enFaceAmount.replace(/,/g,''))*100;
							    						fullPrice = parseFloat(instructionInfo.enFullPrice.replace(/,/g,''));
							    					}
												}
											}
										}
									}
									if(vcAvailableamountT0 && vcAvailableamountT1){
										vcAvailableamountT0 =parseFloat(vcAvailableamountT0.replace(/,/g,''))+tradeQty*fullPrice;
										vcAvailableamountT1 = parseFloat(vcAvailableamountT1.replace(/,/g,''))+tradeQty*fullPrice;
									}
								}
								if(enFundValue){
									nui.get("enFundValue").setValue(formatNumber(enFundValue,2,1));
								}
								if(vcAvailableamountT0){
									nui.get("vcAvailableamountT0").setValue(formatNumber(vcAvailableamountT0,2,1));
								}
								if(vcAvailableamountT1){
									nui.get("vcAvailableamountT1").setValue(formatNumber(vcAvailableamountT1,2,1));
								}
								calculatePercentage();//计算持仓占比和未成占比和指令占比
							}
						}
					}
				});
				if(vcStockCode){//如果债券存在，获取可用数量
					appointBondInfo(bondDetails,vcStockCode,vcMarketNo);
					var parameter = {businClass:businClass,exdestination:exdestination,vcEntrustDirection:3,vcInvestType:vcInvestType};
					var bondInfo = [{vcCombiCode:vcCombiCode,vcCombiNo:vcCombiCode,vcStockCode:vcStockCode,exdestination:exdestination}];
					instructAvaileAmount(parameter, bondInfo);
				}
			}
			
		}
		
		//提交
		function commit(e) {
		 	//验证表单
    		completeInstruction.validate();
			if(completeInstruction.isValid()==false){
				nui.alert("必填项为空或校验失败","提示");
				return;
			} 
			//判断修改指令/建议是否有做修改
			if(nui.get("operatorType").getValue() == "1"){
				var flag = false;
				var instructions = completeInstruction.getData(false,false);
				for(var key1 in originalInstructionInfo){
					for(var key in instructions){
						if(key1 == key){
							if(key1 && key){
								if(originalInstructionInfo[key1] != instructions[key]){
									flag = true;
								}
							}
						}
					}
				}
				if(!flag){
					nui.alert("未做任何修改","提示");
					return;
				}
			}
			saveInstruction();
        }
        
        //下达指令/建议
        function saveInstruction(){
			var json = null;
			var parameter = capsulationInstructParameter();
			//parameter["callRiskType"] = "2";//调风控类型：1-风控试算，2-指令/建议下达
			json = {instructParameter:parameter};
			var operatorType = nui.get("operatorType").getValue();
			if(operatorType == "1"){   //下达指令/建议，否则为修改指令/建议
				json["srcInstruct"] = instructionInfo;
			}
			nui.ajax({
        		data:json,
        		url:"com.cjhxfund.ats.sm.comm.InstructionManager.instructionDateConfirm.biz.ext",
        		success:function(resp){
        			var returnJson = nui.decode(resp);
					if(returnJson.exception == null){//客户下达指令/建议时间>产品参数配置时间
						 if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ORDER_OVER_DEAL_TIME%>"){ 
							nui.confirm("该投资指令/建议下达时间过晚，无法完全保证交易达成，是否继续？", "提示",
					            function (action) {
					                if (action == "ok") {
					                	if(judgeRiskTest(null, json.instructParameter)){	//判断是否接入风控管理
					                		checkRiskInfo(json);//riskMgrComm.js的方法
					                	}else{
					                		instructionAvailIssue(json);
					                	}
					                }
					            }
					        );
						}else if(returnJson.rtnCode =="<%=com.cjhxfund.commonUtil.Constants.ATS_ERROR%>" ){
							nui.alert("系统异常,请稍后再试","提示");
						}else{
							if(judgeRiskTest(null, json.instructParameter)){	//判断是否接入风控管理
		                		checkRiskInfo(json);//riskMgrComm.js的方法
		                	}else{
		                		instructionAvailIssue(json);
		                	}
						}
					}else{
						nui.alert("系统异常","系统提示");
					}
		          
	            }
		    });
		  }
		  
		
		function subData(riskReturn, instructJson){
        	var riskFlag = showRiskInfo(riskReturn, instructJson);
        	riskControl(riskFlag, instructJson);
        }
        function riskControl(riskFlag, instructJson){
        	riskFlagParam = riskFlag;
        	lResultIdParam = instructJson.instructParameter.lResultId;
        	lRiskmgrIdParam = instructJson.instructParameter.lRiskmgrId;
        	if(riskFlag=='-1'){
        		return;
        	}else if(riskFlag=='1'){
        		formalInstructionEntry(instructJson);
        	}else if(riskFlag=='2'){
        		formalInstructionEntry(instructJson);
        	}
        }
        function formalInstructionEntryFinish(){
        	if(riskFlagParam=='2'){
        		startRiskProcessInstruct(lResultIdParam, lRiskmgrIdParam);
        	}
        	CloseOwnerWindow("ok");
        }
		
		//指令/建议下达或修改start
 		function instructionAvailIssue(instructJson){
 			 var tooltip = nui.loading("正在处理中,请稍等...","提示");
 			 nui.ajax({
 				url: "com.cjhxfund.ats.sm.comm.InstructionManager.checkInstructAvail.biz.ext",
	            type: 'POST',
	            data: instructJson,
	            cache: false,
	            contentType: 'text/json',
	            success: function (text) {
	            	nui.hideMessageBox(tooltip);
	            	var returnJson = nui.decode(text);
	            	if(returnJson.exception == null){
	            		if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_SUCCESS%>"){
	            			var riskMsg = returnJson.riskMsg;
	            			if(riskMsg!=null && riskMsg.isAgainstRisk){
	            				riskMsg["alertMsg"]="投资指令/建议修改成功！";
	            				nui.open({
			                        url: "<%=request.getContextPath()%>/fix/riskControlDetailList.jsp",
			                        title: "投资指令/建议风控信息",
			                        width: 800,
			                        height: 422,
			                        onload: function () {
			                            var iframe = this.getIFrameEl();
			                            iframe.contentWindow.SetData(riskMsg,3);
			                        },
			                        ondestroy: function (action) {
			                           CloseOwnerWindow("ok");
			                        }
			                    });
	            			}else{
		            			nui.alert("投资指令/建议修改成功！","提示",function(){
	                            	CloseOwnerWindow("ok");
	                            });
	            			}
	            		}else if(returnJson.rtnCode == "203" || returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ORDER_USABLE_AMOUNT_INSUFFICIENT%>"){//可用不足,继续下单先校验风控
	            			nui.confirm(returnJson.rtnMsg+"</br>是否继续下单？","提示", function(action){
		                		if(action == "ok") {
                                	formalInstructionEntry(instructJson);
                                }
		                	});
	            		}else if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ERROR%>"){
	            			var riskMsg = returnJson.riskMsg;
	            			if(riskMsg!=null && riskMsg.isAgainstRisk){//触发了风控
	            				riskMsg["alertMsg"]="投资指令/建议修改失败！";
	            				nui.open({
			                        url: "<%=request.getContextPath()%>/fix/riskControlDetailList.jsp",
			                        title: "投资指令/建议风控信息",
			                        width: 800,
			                        height: 422,
			                        onload: function () {
			                            var iframe = this.getIFrameEl();
			                            iframe.contentWindow.SetData(riskMsg,3);
			                        }
			                    });
	            			}else{
	            				nui.alert(returnJson.rtnMsg,"系统提示");
	            			}
	            		}else if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ORDER_NO_RCV_FR_O32%>"){
	            			nui.alert("投资指令/建议修改成功！</br>"+returnJson.rtnMsg,"提示",function(){
                            	CloseOwnerWindow("ok");
                            });
	            		}else if(returnJson.rtnCode == "301"){//既触发风控又触发可用
	            			var riskMsg = returnJson.riskMsg;
	            			riskMsg["alertMsg"]=returnJson.rtnMsg;
	            			nui.open({
		                        url: "<%=request.getContextPath()%>/fix/riskControlDetailList.jsp",
		                        title: "投资指令/建议风险提示",
		                        width: 800,
		                        height: 422,
		                        onload: function(){
		                            var iframe = this.getIFrameEl();
		                            iframe.contentWindow.SetData(riskMsg,1);
		                        },
		                        ondestroy: function (action) {
		                            if (action == "ok") {
	                                    formalInstructionEntry(instructJson);
	                                }
		                        }
		                    });
	            		}else{//触发风控，弹出风险提示框，展示风险信息
	            			var riskInfo = returnJson.riskMsg;
		                    nui.open({
		                        url: "<%=request.getContextPath()%>/fix/riskControlDetailList.jsp",
		                        title: "投资指令/建议风险提示",
		                        width: 800,
		                        height: 380,
		                        onload: function () {
		                            var iframe = this.getIFrameEl();
		                            iframe.contentWindow.SetData(riskInfo,1);
		                        },
		                        ondestroy: function (action) {
		                            if (action == "ok") {
	                                    formalInstructionEntry(instructJson);
	                                }
		                        }
		                    });
	            		}
	            	}else{
	            		nui.alert("系统异常","系统提示");
	            	}
	            }
 			 });
   		 }
   	 	
   	 	//正式修改指令/建议信息
   	 	function formalInstructionEntry(instructJson){
   	 		var tooltip = nui.loading("正在处理中,请稍等...","提示");
   	 		nui.ajax({
                url: "com.cjhxfund.ats.sm.comm.InstructionManager.insertAndUpdateInstruct.biz.ext",
                type: 'POST',
                data: instructJson,
                cache: false,
                contentType: 'text/json',
                success: function (e) {
                	nui.hideMessageBox(tooltip);
                   	var returnJson = nui.decode(e);
					if(returnJson.exception == null){
						if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_SUCCESS%>"){
	            			var riskMsg = returnJson.riskMsg;
	            			if(riskMsg!=null && riskMsg.isAgainstRisk){
	            				riskMsg["alertMsg"]="投资指令/建议修改成功！";
	            				nui.open({
			                        url: "<%=request.getContextPath()%>/fix/riskControlDetailList.jsp",
			                        title: "投资指令/建议风控信息",
			                        width: 800,
			                        height: 422,
			                        onload: function () {
			                            var iframe = this.getIFrameEl();
			                            iframe.contentWindow.SetData(riskMsg,3);
			                        },
			                        ondestroy: function (action) {
			                           formalInstructionEntryFinish();
			                        }
			                    });
	            			}else{
		            			nui.alert("投资指令/建议修改成功！","提示",function(){
	                            	formalInstructionEntryFinish();
	                            });
	            			}
	            		}else if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ERROR%>") {
	            			var riskMsg = returnJson.riskMsg;
	            			if(riskMsg!=null && riskMsg.isAgainstRisk){
	            				riskMsg["alertMsg"]="投资指令/建议修改失败！";
	            				nui.open({
			                        url: "<%=request.getContextPath()%>/fix/riskControlDetailList.jsp",
			                        title: "投资指令/建议风控信息",
			                        width: 800,
			                        height: 422,
			                        onload: function () {
			                            var iframe = this.getIFrameEl();
			                            iframe.contentWindow.SetData(riskMsg,3);
			                        }
			                    });
	            			}else{
	            				nui.alert("投资指令/建议修改失败！</br>"+returnJson.rtnMsg,"提示");
	            			}
                        } else{
                        	nui.alert("投资指令/建议修改成功！"+returnJson.rtnMsg,"提示",function(){
                            	formalInstructionEntryFinish();
                            });
                        }
					}else{
						nui.alert("系统异常","系统提示");
					}
                }
            });
   	 	}
   	    //封装指令/建议参数
	   	 function capsulationInstructParameter(){
			var tradeDate = nui.formatDate(nui.get("tradeDate").value, "yyyyMMdd");
			var firstSettleDate = nui.formatDate(nui.get("firstSettleDate").value, "yyyyMMdd");
			var parameter = null;
			var bondInfo = null;
			bondInfo = bondDetails.getData(false, false);//仅用作给后台传参用
			parameter = completeInstruction.getData(false, false);
			//仅插入数据库用，start
			var funds = nui.get("vcProductCode").getData();
			for(var i = 0,len = funds.length; i < len;i++){
				if(funds[i].ID==nui.get("vcProductCode").getValue()){
		    		parameter["lProductId"] = funds[i].L_PRODUCT_ID;
		    	}
			}
			parameter["vcProductName"] = nui.get("vcProductCode").getText();//产品名称
			parameter["vcCombiName"] = nui.get("vcCombiCode").getText();		//组合名称
			parameter["lLeftDays"] = lLeftDays;		//距到期日天数
			parameter["lTradeDate"] = tradeDate;		//交易日期
			parameter["lFirstSettleDate"] = firstSettleDate;//结算日期
			
			var combis = nui.get("vcCombiCode").getData();
			for(var i = 0,len = combis.length; i < len;i++){
				var asset = combis[i];
				if(asset.ID==nui.get("vcCombiCode").getValue()){
		    		parameter["lAssetId"] = asset.L_ASSET_ID;
		    		parameter["vcAssetCode"] = asset.VC_ASSET_NO;
		    		parameter["vcAssetName"] = asset.VC_ASSET_NAME;
		    		parameter["lCombiId"] = asset.L_COMBI_ID;
		    	}
			}
			if(nui.get("operatorType").getValue() == "1" && instructionInfo.cIsValid=="1"){//修改指令/建议
				var tradeQty = parseInt(instructionInfo.enFaceAmount.replace(/,/g,''))*100;
				if(instructionInfo.vcEntrustDirection=="01" || instructionInfo.vcEntrustDirection=="3"){//买入
					if(parameter["vcAssetCode"] == instructionInfo.vcAssetCode){
						var now =  nui.formatDate(new Date(),"yyyyMMdd");//当日
						var now1 = nui.formatDate(new Date(new Date().getTime()+24*60*60*1000),"yyyyMMdd"); //修改指令/建议的可以金额校验需要
			    		//原指令/建议的交易日为今天的指令/建议或者交易日为明天的t+0指令/建议在需改时需要将资金加回
						if(instructionInfo.lTradeDate == now || (instructionInfo.lTradeDate == now1 && instructionInfo.vcSettleSpeed == "0")){
    						var fullPrice = parseFloat(instructionInfo.enFullPrice.replace(/,/g,''));
							tradeQty = tradeQty*fullPrice;
							parameter["tradeQty"] = tradeQty;
    					}
					}
				}else{//卖出
					if(nui.get("vcStockCode").getValue() == instructionInfo.vcStockCode && nui.get("vcCombiCode").getValue()==instructionInfo.vcCombiCode){
						parameter["tradeQty"] = tradeQty;
					}
				}
			}
			
			parameter["cOverdraft"] = cOverdraft; //可用金额是否允许透支 1:允许 2:不允许
			parameter["vcOrgRating"] = bondInfo["vcIssueAppraise"];					//主体评级
			parameter["vcBondRating"] =bondInfo["vcBondAppraise"];					//债项评级
			parameter["enDuration"] =bondInfo["enCbValueMduration"];				//中债估价修正久期(推荐)
			parameter["vcCounterpartyName"] = nui.get("vcCounterpartyId").getText(); //交易对手编号
			//仅插入数据库用，end
// 			parameter["fixStatus"]="ZHFWPT_ENABLE_FIX";//用于给后台取缓存的fix是否启用
			var enNetPrice = parameter.enNetPrice.replace(/,/g,'');					//净价
			var enFaceAmount = parameter.enFaceAmount.replace(/,/g,'');	//券面金额
			var enFullPrice = parameter.enFullPrice.replace(/,/g,'');					//全价
			//净价金额的计算,净价价格*券面金额（万元）*100,全价金额计算方式一致
			var enNetPriceAmount = enNetPrice*enFaceAmount*100; 
			var enFullPriceAmount = enFullPrice*enFaceAmount*100; 
			parameter["enNetPriceAmount"] = enNetPriceAmount	;		//净价金额
			parameter["enFullPriceAmount"] = enFullPriceAmount;		//全价金额
			
			//判断交易对手是否是自己手动输入
			if(parameter["vcCounterpartyId"] == parameter["vcCounterpartyName"]){
				parameter["vcCounterpartyId"] = "";
			}
			parameter["vcPrice"] = enNetPrice;									//作为O32传入价格
			parameter["enPrice"] = enNetPrice;									//作为O32传入价格
			parameter["enNetPrice"] = enNetPrice;									//净价
			parameter["enFullPrice"] = enFullPrice;									//全价
			parameter["enFaceAmount"] = enFaceAmount;						//券面金额
			parameter["vcInstructType"] = "1"; 			 //用来传给流程判断1、完整指令/建议  2、询价指令/建议
			parameter["vcProcessStatus"] = "1";			//流程状态
			parameter["lFixValidStatus"] = "0";//用于判断指令/建议是否发送O32以及发送结果：0-未发送,1-修改后未发送,2-发送中,3-发送成功,4-发送失败
			return parameter;
	   	 }
			
	   	 //风控试算
        function riskControlTrial(e){
        	//验证表单
    		completeInstruction.validate();
			if(completeInstruction.isValid()==false){
				nui.alert("必填项为空或校验失败","提示");
				return;
			} 
        	var parameter = capsulationInstructParameter();
        	var operatorType = nui.get("operatorType").getValue();
        	parameter["callRiskType"] = "1";//风控校验类型：1-风控试算，2-指令下达
        	var json = null;
        	json = {instructParameter:parameter};
        	if(operatorType == "1"){   //下达指令/建议，否则为修改指令/建议
        		json["srcInstruct"] = instructionInfo;
			}
        	 //风控试算start
        	var a = nui.loading("正在处理中,请稍等...","提示");
	        nui.ajax({
        	 	url: "com.cjhxfund.ats.sm.comm.InstructionManager.checkInstructAvail.biz.ext",
	            type: 'POST',
	            data: json,
	            cache: false,
	            contentType: 'text/json',
	            success: function (text) {
	            	nui.hideMessageBox(a);
	            	var returnJson = nui.decode(text);
					if(returnJson.exception == null){
		                var riskInfo = returnJson.riskMsg;
		                //可用不足或风控校验失败
		                if(returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_ORDER_USABLE_AMOUNT_INSUFFICIENT%>"){
		                	nui.alert(returnJson.rtnMsg,"投资指令/建议风险提示");//可用不足
		                }else if(returnJson.rtnCode == "203"){
		                	nui.alert(returnJson.rtnMsg,"系统提示");//风控校验失败
		                }else if (returnJson.rtnCode == "<%=com.cjhxfund.commonUtil.Constants.ATS_SUCCESS%>") {
		                    if(returnJson.rtnMsg!=null){
		                    	nui.alert(returnJson.rtnMsg,"系统提示");
		                    }else{
		                    	nui.alert("风控试算通过!","系统提示");
		                    }
		                }else if(returnJson.rtnCode == "301"){
		                	riskInfo["alertMsg"]=returnJson.rtnMsg;
		                    nui.open({
		                        url: "<%=request.getContextPath()%>/fix/riskControlDetailList.jsp",
		                        title: "投资指令/建议风险提示",
		                        width: 800,
		                        height: 422,
		                        onload: function () {
		                            var iframe = this.getIFrameEl();
		                            iframe.contentWindow.SetData(riskInfo,3);
		                        }
		                    });
		                }else{
		                    nui.open({
		                        url: "<%=request.getContextPath()%>/fix/riskControlDetailList.jsp",
		                        title: "投资指令/建议风险提示",
		                        width: 800,
		                        height: 380,
		                        onload: function () {
		                            var iframe = this.getIFrameEl();
		                            iframe.contentWindow.SetData(riskInfo,3);
		                        }
		                    });
		                }
					}else{
						nui.alert("系统异常","系统提示");
					}
	            }
        	 });
	        //风控试算end
        }
		
		//获取主页面传参，赋到对应字段
		function SetData(data) {
			//跨页面传递的数据对象，克隆后才可以安全使用
            data = nui.clone(data);
            bondDetails.clear();
            var vcEntrustDirection = data["vcEntrustDirection"];//委托方向
//             var productInList = false;
//             var funds = nui.get("vcProductCode").getData();
            nui.get("vcProductCode").setValue(data["vcProductCode"]);//产品代码
            nui.get("lProductId").setValue(data.lProductId);//产品Id
		    		nui.get("vcProductCode").setText(data["vcProductName"]);//产品名称
            		selectFunds(data["vcCombiCode"]);
            		var vcAvailablequantityT0 = data["vcAvailablequantityT0"];//T+0可用数量
					if(vcAvailablequantityT0 && vcEntrustDirection == "4"){
						//券面金额：可用数量（先取T+0可用数量）*100
					 	var enFaceAmount = formatNumber(vcAvailablequantityT0/100,0,1);
						nui.get("enFaceAmount").setValue(enFaceAmount);
					}
					
// 			for(var i = 0,len = funds.length; i < len;i++){
// 				if(funds[i].ID==data["vcProductCode"]){
// 					productInList = true;
// 		    	}
// 			}
// 			if(!productInList){
// 				nui.get("vcProductCode").setText(null);//产品名称
//             	nui.get("vcProductCode").setValue(null);//产品代码
// 			}
        	nui.get("vcEntrustDirection").setValue(vcEntrustDirection);//委托方向
        	nui.get("vcStockCode").setValue(data["vcStockCode"]);
        	nui.get("vcStockCode").setText(data["vcStockCode"]);//债券代码
 			changeRed(data.vcEntrustDirection);//根据委托方向改变输入框对应字段的颜色
 			nui.get("vcStockName").setValue(data["vcStockName"]);//债券名称
 			nui.get("vcInterCode").setValue(data["vcInterCode"]);//O32债券内码
 			lDelistingDate = data["lDelistingDate"];
        	if(data["operatorType"] == "1"){//修改指令/建议
        		nui.get("operatorType").setValue(data["operatorType"]);
        		nui.get("vcSettleSpeed").setValue(data["vcSettleSpeed"]);//清算速度
        		var lTradeDate = data["lTradeDate"].toString();
        		var lFirstSettleDate = data["lFirstSettleDate"].toString();
        		nui.get("tradeDate").setValue(lTradeDate);//交易日期
        		nui.get("firstSettleDate").setValue(lFirstSettleDate);//结算日期
        		nui.get("vcCombiCode").setValue(data["vcCombiCode"]);//组合代码
        		nui.get("enFaceAmount").setValue(formatNumber(data["enFaceAmount"],0,1));//券面金额
        		nui.get("vcCounterpartyTrader").setValue(data["vcCounterpartyTrader"]);//交易员名称
        		nui.get("enFullPrice").setValue(data["enFullPrice"]);//全价
				nui.get("enNetPrice").setValue(data["enNetPrice"]);//净价
				nui.get("enMaturityYield").setValue(data["enMaturityYield"]);//到期收益率
				nui.get("enOptionYield").setValue(data["enOptionYield"]);//行权收益率
				nui.get("vcCounterpartyId").setText(data["vcCounterpartyName"]);//交易对手
				nui.get("vcCounterpartyId").setValue(data["vcCounterpartyId"]);//交易对手编号
				nui.get("vcCounterpartyOrgan").setValue(data["vcCounterpartyOrgan"]);//对手主体机构
				nui.get("vcRemark").setValue(data["vcRemark"]);//备注
				//禁用不可修改元素
				nui.get("vcProductCode").disable();
				nui.get("vcCombiCode").disable();
				nui.get("vcStockCode").disable();
				nui.get("vcEntrustDirection").disable();
        		instructionInfo = data;
        	}else{
        		whetherTradeDate();
        	}
 			originalInstructionInfo = completeInstruction.getData(false,false);
		}

		//关闭页面
		function onCancel() {
			CloseOwnerWindow();
		}
		
		//点击事件，根据委托方向改变所有输入框对应字段的颜色
		function changeToRed(e){
			changeRed(e.source.value);
		}
		//委托方向有值时就改变输入框对应字段的颜色
		function changeRed(e){
			if(e == "01" || e == "3"){
				$("td[red='red']").css({"color":"red"});
			}else {
				$("td[red='red']").css({"color":"green"});
			}
		}
		//根据清算速度和交易日期得出结算日期
		function whetherTradeDate(){
			var tradeDatePicker = nui.get("tradeDate").value;
			var tradeDate = nui.formatDate(tradeDatePicker, "yyyyMMdd");
			var settleSpeed = nui.get("vcSettleSpeed").getValue();
			//var dateType = "00";  //交易日类型：00-系统交易日(沪深交易日)；01-银行间交易日；02-港股通交易日；O32数据字典tdictionary.l_dictionary_no=10084；
			if(tradeDate && settleSpeed){
				if(settleSpeed=="0"){
					nui.get("firstSettleDate").setValue(tradeDate.toString());
				}else{
					if(isNotTradeDate(tradeDatePicker,"00")){
						settleSpeed="0";
					}
					nui.ajax({
			            url:"com.cjhxfund.ats.sm.repurchase.RepurchaseBizManager.calMaturitySettleDate.biz.ext",
			            type:'POST',
			            data:{firstSettleDate:tradeDate,repoDays:settleSpeed},
			            cache:false,
			            contentType:'text/json',
			            success:function(text){
			                var returnJson = nui.decode(text);
			                if(returnJson.exception == null){
			                	nui.get("firstSettleDate").setValue(returnJson.maturitySettleDate.toString());
			                }else{
			                    nui.alert("获取交易日失败", "系统提示");
			                }
			            }
			        });
				}
		        enNetPriceMet();
			}
		}
			//联动方法
    	function selectFunds(e){
     		var fundCodeCombo = nui.get("vcProductCode");
    		var vcCombiCombo = nui.get("vcCombiCode");
       		var id = fundCodeCombo.getValue();
       		if(!id){
       			vcCombiCombo.setValue(null);
       			vcCombiCombo.setText(null);
       		}
    		nui.ajax({
        		data:{vcProductCode:id},
        		url:"com.cjhxfund.commonUtil.applyInstUtil.queryCombiInfo.biz.ext",
        		success:function(resp){
        			var returnJson = nui.decode(resp);
					if(returnJson.exception == null){
			             var combis = resp.data;
			             if(combis){
		                    vcCombiCombo.load(combis);
		                    if(typeof e === "object"){
		                    	vcCombiCombo.select(0);
		                    }else{
		                    	var combiInList = false;
		                    	for(var i = 0,len = combis.length; i < len;i++){
									if(combis[i].VC_COMBI_NO==e){
										combiInList = true;
							    		vcCombiCombo.setValue(e);
							    	}
								}
								if(!combiInList){
									vcCombiCombo.setValue(null);
       								vcCombiCombo.setText(null);
								}
		                    }
		             	 }
		             	onCombiLinkage();//获取可用金额与净资产
					}else{
						nui.alert("系统异常","系统提示");
					}
	              },
	            //有错误码之后，把后面的错误提醒补齐。
	            fail:function(resp){
	                alert(resp);
	            }
		    });
    	};
        
        //计算净价、全价、收益率，可以必填其一，选填其他，输入一个另外两个数据可以系统自动算出来
            function setBondPriceCommon(netPrice, fullPrice, interestRate, interestRateType){
            	var autoCalc = nui.get("autoCalc");//获取“联动”值（是否勾选）
            	if(autoCalc.checked==false){//若“联动”未勾选，则不自动计算而直接返回
            		return;
            	}
            	var vcReportCode = nui.get("vcStockCode").getValue();//债券代码
                //以下情况重新获取债券信息
                if(investProductInfoCommon==null || investProductInfoCommon=="" || investProductInfoCommon.split(",").length!=4 || vcReportCode != investProductInfoCommon.split(",")[0]){
                	var cMarketNo = nui.get("vcMarket").getValue(); //交易市场编号
                	if(!vcReportCode){
                		return;
                	}
                	nui.ajax({
			            url:"com.cjhxfund.ats.sm.comm.InstructionManager.getInvestProductsByReportCodeAndMarketNo.biz.ext",
			            type:'POST',
			            data:nui.encode({vcReportCode:vcReportCode, cMarketNo:cMarketNo}),
			            cache:false,
			            contentType:'text/json',
			            success:function(text){
			                var returnJson = nui.decode(text);
			                if(returnJson.exception == null){
			                	investProductInfoCommon = returnJson.investProductInfo; //投资产品信息（债券代码,债券名称,交易市场编号,证券内码）
			                	getBondPriceFun(netPrice, fullPrice, interestRate, interestRateType);
			                }else{
			                    nui.alert("债券详细信息获取失败", "系统提示");
			                }
			            }
			        });
                }else{
                	getBondPriceFun(netPrice, fullPrice, interestRate, interestRateType);
                }
            }
            
            //获取净价、全价、收益率数据
            function getBondPriceFun(netPrice, fullPrice, interestRate, interestRateType){
            	var investProductCode = nui.get("vcStockCode").getValue();//债券代码
                //若投资产品信息全局变量的债券代码值不等于债券代码属性的值则直接返回
                if(investProductCode!=investProductInfoCommon.split(",")[0]){
                	return;
                }
                var interCode = investProductInfoCommon.split(",")[3];//获取证券内码[投资产品信息（债券代码,债券名称,交易市场编号,证券内码）]
                var processDate = nui.formatDate(nui.get("tradeDate").value, "yyyyMMdd");//业务日期
                var tradingPlace = "01";//交易场所：[01-银行间;02-上交所固收平台;03-深交所综合协议平台|上交所大宗;]
                var clearingSpeed = nui.get("vcSettleSpeed").value;//清算速度：T+0、T+1
                if(clearingSpeed == "1"){
                	clearingSpeed = "T+1";
                }else{
                	clearingSpeed = "T+0";
                }
            	var interestRateTypeP = 1;//收益率类型：[1-到期;2-行权日]
            	if(interestRateType=="02"){
            		interestRateTypeP = 2;
            	}
            	
            	var jsonParam = nui.encode({processDate:processDate, interCode:interCode, netPrice:netPrice, fullPrice:fullPrice, interestRate:interestRate, interestRateType:interestRateTypeP, tradingPlace:tradingPlace, clearingSpeed:clearingSpeed});
            	nui.ajax({
		            url:"com.cjhxfund.ats.sm.comm.InstructionManager.getLinkageValue.biz.ext",
		            type:'POST',
		            data:jsonParam,
		            cache:false,
		            contentType:'text/json',
		            success:function(text){
		                var returnJson = nui.decode(text);
		                if(returnJson.exception == null){
		                	var result = returnJson.result; //返回结果：净价，全价，到期收益率，收益率类型，交易场所，清算速度，行权收益率
		                	var resultArr = result.split("@");
		                	nui.get("enNetPrice").setValue(resultArr[0]);//净价（元/百元面值）
    						nui.get("enFullPrice").setValue(resultArr[1]);//全价（元/百元面值）
    						nui.get("enMaturityYield").setValue(resultArr[2]);//到期收益率（%）
    						nui.get("enOptionYield").setValue(resultArr[6]);//行权收益率
    						setPriceFunCommon("enNetPrice");//自动增加千分位-净价（元/百元面值）
    						setPriceFunCommon("enFullPrice");//自动增加千分位-全价（元/百元面值）
    						setPriceFunCommon("enMaturityYield");//自动增加千分位-收益率（%）
    						setPriceFunCommon("enOptionYield");//自动增加千分位-收益率（%）
    						if(eval(nui.get("enMaturityYield").getValue())<=0){
    							nui.get("enMaturityYield").setValue("0.0000");
    						}
    						if(eval(nui.get("enOptionYield").getValue())<=0){
    							nui.get("enOptionYield").setValue("0.0000");
    						}
    						linkageResultInfo = [nui.get("enNetPrice").value,nui.get("enFullPrice").value,nui.get("enMaturityYield").value,nui.get("enOptionYield").value];
    						calculatePercentage(); //计算未成占比和指令/建议占比
		                }else{
		                    nui.alert("净价、全价、收益率数据获取失败", "系统提示");
		                }
		            }
		        });
            }
            
            //收益率（%）
            function interestRateFun(e){
            	if(numberCheck(e)){//判断参数是否为数字
		           	return;
		         }
				setPriceFunCommon("enMaturityYield");
				setPriceFunCommon("enOptionYield");
            	var interestRateType = null;
            	var interestRate = null;
            	//净价、全价、收益率，可以必填其一，选填其他，输入一个另外两个数据可以系统自动算出来
            	var enMaturityYield = nui.get("enMaturityYield").getValue();//到期收益率
				var enOptionYield = nui.get("enOptionYield").getValue();//行权收益率
				var enNetPrice = nui.get("enNetPrice").getValue();//净价
    			var enFullPrice = nui.get("enFullPrice").getValue();//全价
				if(enMaturityYield){
					if(linkageResultInfo != null && linkageResultInfo[2] == enMaturityYield && enNetPrice && enFullPrice && enOptionYield){
	            		return;
	            	}
					interestRate = enMaturityYield;
					interestRateType = "01";//收益率类型：01-到期;02-行权;
				}else if(enOptionYield){
					if(linkageResultInfo != null && linkageResultInfo[3] == enOptionYield && enNetPrice && enFullPrice && enMaturityYield){
	            		return;
	            	}
					interestRate = enOptionYield;
					interestRateType = "02";
				}
            	setBondPriceCommon(null, null, interestRate, interestRateType);
            }	
            
            //自动增加千分位
            function setPriceFunCommon(cmpId){
            	var oldVal = nui.get(cmpId).getValue();
            	if(oldVal){
            		//特殊验证，交易场所：[01-银行间;02-上交所固收平台;03-深交所综合协议平台|上交所大宗;]
                	var tradingPlaceVal = "01";//交易场所
                	var newVal = formatNumber(oldVal,4,1);
                	if(tradingPlaceVal=="02" || tradingPlaceVal=="03"){
                		newVal = formatNumber(oldVal,3,1);
                	}
            		nui.get(cmpId).setValue(newVal);
            	}
            }
            
             //净价（元/百元面值）
            function netPriceFun(e){
            	 if(numberCheck(e)){//判断参数是否为数字
	            	return;
	            }
            	setPriceFunCommon("enNetPrice");//自动增加千分位-净价（元/百元面值）
            	var enNetPrice = nui.get("enNetPrice").getValue();  //净价
            	var enMaturityYield = nui.get("enMaturityYield").getValue();//到期收益率
				var enOptionYield = nui.get("enOptionYield").getValue();//行权收益率
    			var enFullPrice = nui.get("enFullPrice").getValue();//全价
            	if(linkageResultInfo != null && linkageResultInfo[0] == enNetPrice && enOptionYield && enFullPrice && enMaturityYield){
            		return;
            	}
            	enNetPriceMet();
            }
            //根据净价联动
            function enNetPriceMet(){
            	var enNetPrice = nui.get("enNetPrice").getValue();  //净价
            	if(enNetPrice){
            		if(enNetPrice <= 0){
	            		nui.get("enFullPrice").setValue("0.0000");
	 					nui.get("enMaturityYield").setValue("0.0000");
						nui.get("enOptionYield").setValue("0.0000");
						return;
	            	}
	            	setBondPriceCommon(enNetPrice, null, null, null);//净价、全价、收益率，可以必填其一，选填其他，输入一个另外两个数据可以系统自动算出来
            	}
            }
            //全价（元/百元面值）
            function fullPriceFun(e){
	            if(numberCheck(e)){//判断参数是否为数字
	            	return;
	            }
            	setPriceFunCommon("enFullPrice");//自动增加千分位-全价（元/百元面值）
            	var enFullPrice = nui.get("enFullPrice").getValue();  //全价
            	var enMaturityYield = nui.get("enMaturityYield").getValue();//到期收益率
				var enOptionYield = nui.get("enOptionYield").getValue();//行权收益率
				var enNetPrice = nui.get("enNetPrice").getValue();//净价
            	if(linkageResultInfo != null && linkageResultInfo[1] == enFullPrice  && enOptionYield && enNetPrice && enMaturityYield){
            		return;
            	}
            	if(enFullPrice <= 0){
            		nui.get("enNetPrice").setValue("0.0000");
 					nui.get("enMaturityYield").setValue("0.0000");
					nui.get("enOptionYield").setValue("0.0000");
					return;
            	}
            	setBondPriceCommon(null, enFullPrice, null, null);//净价、全价、收益率，可以必填其一，选填其他，输入一个另外两个数据可以系统自动算出来
            }
           
           
            //计算持仓占比和未成占比和指令/建议占比
        function calculatePercentage(){
    		var enFundValue = nui.get("enFundValue").value;//净资产
    		enFundValue = enFundValue.replace(/,/g,'');
    		var enNetPrice = nui.get("enNetPrice").value;//净价
    		var enFaceAmount = nui.get("enFaceAmount").value.replace(/,/g,'');
    		if(enFundValue && enNetPrice){
    			var unachievedRatio = null;
    			var instructRatio = null;
    			var positionRatio = null;
    			if(enFundValue <= 0){
    				unachievedRatio = "0.0000";
    				instructRatio = "0.0000";
    				positionRatio = "0.0000";
    			}else{
    				//持仓占比:市值/净资产*100
    				positionRatio = enBondAsset/enFundValue*100;
    				positionRatio = formatNumber(positionRatio,4,1);
    				//未成占比:当前债券代码所有没有成交的数量（券面金额元/100或万元*100）*指令/建议净价/净资产*100
		    		unachievedRatio = ((sumFaceAmount*100*enNetPrice)/enFundValue)*100;
		    		unachievedRatio = formatNumber(unachievedRatio,4,1);
					//指令/建议占比:当前指令/建议金额( 数量 * 净价 或 （券面金额(万元) * 100）* 净价)/净资产*100
					instructRatio = enFaceAmount*100*enNetPrice/(enFundValue)*100;
					instructRatio = formatNumber(instructRatio,4,1);
    			}
				//合计(占%) =持仓占%+未成占%+指令/建议占%
				var totalRatio = add(positionRatio,unachievedRatio);
				totalRatio = add(totalRatio,instructRatio);
				
				nui.get("unachievedRatio").setValue(unachievedRatio);
				nui.get("instructRatio").setValue(instructRatio);
				nui.get("positionRatio").setValue(positionRatio);
				nui.get("totalRatio").setValue(formatNumber(totalRatio,4,0));
    		}
    		if(enFaceAmount){
    			enFaceAmount = formatNumber(enFaceAmount,0,1);
				nui.get("enFaceAmount").setValue(enFaceAmount);
    		}
        }
           
       //控制交易日期不能小于当天
        function limitTradeDate(id){
				var time = (new Date()).getTime() - 24*60*60*1000;
				nui.get(id).minDate = new Date(time);
					}
	     
       //精确加
       function add(a, b) {
		    var c, d, e,f;
		    try {
		        c = a.toString().split(".")[1].length;
		    } catch (f) {
		        c = 0;
		    }
		    try {
		        d = b.toString().split(".")[1].length;
		    } catch (f) {
		        d = 0;
		    }
		    e = Math.pow(10, Math.max(c, d));
		    f = (a * e + b * e) / e;
		    return f
		}
		
  		 //数字校验(允许英文逗号)
       function numberCheck(e){
			var reg= /^([0-9]([0-9,])*(\.[0-9]+)?)$/;
        	var value = e.sender.value;
        	if(!reg.test(value)){
        		e.sender.setValue("");
        		e.errorText = "请输入数字";
        	 	e.isValid = false;
        	 	return true;
        	}
		}
		
		//校验券面金额
		function faceAmountCheck(e){
			var reg= /^([1-9][0-9]{0,11}(\.[0-9]{2})?)$/;
        	var value = e.sender.value;
        	if(!reg.test(value.replace(/,/g,''))){
        		e.sender.setValue("");
        		e.errorText = "请输入1~12位正数";
        	 	e.isValid = false;
        	 	return true;
        	}
        	
		}
		
		//券面金额校验
		function faceAmountAdjustandtest(e){
			var reg= /^([0-9]([0-9,])*(\.[0-9]+)?)$/;
			var value = e.sender.value;
			if(reg.test(value)){
				calculatePercentage();
			}
		}
		//页面X的删除功能
		function onCloseClick(e) {
		    var obj = e.sender;
		    obj.setText(null);
		    obj.setValue(null);
		    obj.doValueChanged();
		}
		//校验交易日期是否为交易日
		function isTradeDate(e){
			if(!remindTradeDate(e,"交易日期不是交易日，还需要继续吗？")){
		    	e.errorText = "交易日期不是交易日！";
		        e.isValid = false;
		    }
		}
		//选择交易对手的时候，将对手主体机构带出
		function setIssueOrgan(e){
			var vcIssuerName = e.selected ? e.selected.vcIssuerName : "";
			nui.get("vcCounterpartyOrgan").setValue(vcIssuerName);
		}
	</script>
	<script type="text/javascript" src="<%= request.getContextPath() %>/scripts/com.cjhxfund.js.base/utils/DateUtil.js"></script>
	<script type="text/javascript" src="<%= request.getContextPath() %>/transaction/invest/transaction_JS/transactionInstructComJs.js"></script>
</body>
</html>