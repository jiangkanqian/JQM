package com.cjhxfund.foundation.fix.model;
import java.math.BigDecimal;
import java.util.List;

import com.cjhxfund.foundation.fix.RiskCtrlCenterService;

public class RequestRecordDetail {
	/**
	 * 风控请求指令参数集(保持参数与接口文档一致)
	 */
	private String requestId;

	//@NotNull
	private String fundCode;

	//@NotNull
	private String fundId;

	//@NotNull
	private String combinNo;

	private String symbol;

	private String exDestination;

	private String stype;

	private String currencyCode;

	private String interCode;

	//@NotNull
	private String investType;

	//@NotNull
	private String businType;

	private String bondType;

	private BigDecimal maturityYield1;

	private BigDecimal maturityYield2;

	private BigDecimal insideAppraise1;

	private BigDecimal insideAppraise2;

	private BigDecimal outerAppraise1;

	private BigDecimal outerAppraise2;

	private BigDecimal issueAppraise1;

	private BigDecimal issueAppraise2;

	private BigDecimal leftDays1;

	private BigDecimal leftDays2;

	private BigDecimal hgDays1;

	private BigDecimal hgDays2;

	//@NotNull
	private String stockTargetType;

	//@NotNull
	private BigDecimal price;

	//@NotNull
	private BigDecimal orderQty;

	//@NotNull
	private BigDecimal cashOrderQty;

	private String riskInfluenceFlag;

	private String expirationDate;

	private String valueDate;

	private BigDecimal earnestAmount;

	private BigDecimal interest;

	private String execBroker;

	private String bondSettleType;

	private String bondSettleType2;

	private String advanceLimitFlag;

	private String withdrawType;

	private String recordDetailId;

	private BigDecimal repoRate;

	private BigDecimal earnestBalance;
	
	private BigDecimal bondYield;
	
	private BigDecimal bondYield2;
	
	private BigDecimal realBondInterest;
	
	private BigDecimal stopPrice;
	
	private List<RequestCollateraDetailModel> collateraDetails;
	
	private String isInquiry;
	
	public BigDecimal getBondYield() {
		return bondYield;
	}

	public void setBondYield(BigDecimal bondYield) {
		this.bondYield = bondYield;
	}

	public BigDecimal getBondYield2() {
		return bondYield2;
	}

	public void setBondYield2(BigDecimal bondYield2) {
		this.bondYield2 = bondYield2;
	}

	public BigDecimal getRealBondInterest() {
		return realBondInterest;
	}

	public void setRealBondInterest(BigDecimal realBondInterest) {
		this.realBondInterest = realBondInterest;
	}

	public BigDecimal getStopPrice() {
		return stopPrice;
	}

	public void setStopPrice(BigDecimal stopPrice) {
		this.stopPrice = stopPrice;
	}

	public String getIsInquiry() {
		return isInquiry;
	}

	public void setIsInquiry(String isInquiry) {
		this.isInquiry = isInquiry;
	}
	
	public String getRequestId() {
		return requestId;
	}

	public void setRequestId(String requestId) {
		this.requestId = requestId;
	}

	public String getFundCode() {
		return fundCode;
	}

	public void setFundCode(String fundCode) {
		this.fundCode = fundCode;
	}

	public String getFundId() {
		return fundId;
	}

	public void setFundId(String fundId) {
		this.fundId = fundId;
	}

	public String getCombinNo() {
		return combinNo;
	}

	public void setCombinNo(String combinNo) {
		this.combinNo = combinNo;
	}

	public String getSymbol() {
		return symbol;
	}

	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}

	public String getExDestination() {
		return exDestination;
	}

	public void setExDestination(String exDestination) {
		this.exDestination = exDestination;
	}

	public String getStype() {
		return stype;
	}

	public void setStype(String stype) {
		this.stype = stype;
	}

	public String getCurrencyCode() {
		return currencyCode;
	}

	public void setCurrencyCode(String currencyCode) {
		this.currencyCode = currencyCode;
	}

	public String getInterCode() {
		return interCode;
	}

	public void setInterCode(String interCode) {
		this.interCode = interCode;
	}

	public String getInvestType() {
		return investType;
	}

	public void setInvestType(String investType) {
		this.investType = investType;
	}

	public String getBusinType() {
		return businType;
	}

	public void setBusinType(String businType) {
		this.businType = businType;
	}

	public String getBondType() {
		return bondType;
	}

	public void setBondType(String bondType) {
		this.bondType = bondType;
	}

	public BigDecimal getMaturityYield1() {
		return maturityYield1;
	}

	public void setMaturityYield1(BigDecimal maturityYield1) {
		this.maturityYield1 = maturityYield1;
	}

	public BigDecimal getMaturityYield2() {
		return maturityYield2;
	}

	public void setMaturityYield2(BigDecimal maturityYield2) {
		this.maturityYield2 = maturityYield2;
	}

	public BigDecimal getInsideAppraise1() {
		return insideAppraise1;
	}

	public void setInsideAppraise1(BigDecimal insideAppraise1) {
		this.insideAppraise1 = insideAppraise1;
	}

	public BigDecimal getInsideAppraise2() {
		return insideAppraise2;
	}

	public void setInsideAppraise2(BigDecimal insideAppraise2) {
		this.insideAppraise2 = insideAppraise2;
	}

	public BigDecimal getOuterAppraise1() {
		return outerAppraise1;
	}

	public void setOuterAppraise1(BigDecimal outerAppraise1) {
		this.outerAppraise1 = outerAppraise1;
	}

	public BigDecimal getOuterAppraise2() {
		return outerAppraise2;
	}

	public void setOuterAppraise2(BigDecimal outerAppraise2) {
		this.outerAppraise2 = outerAppraise2;
	}

	public BigDecimal getIssueAppraise1() {
		return issueAppraise1;
	}

	public void setIssueAppraise1(BigDecimal issueAppraise1) {
		this.issueAppraise1 = issueAppraise1;
	}

	public BigDecimal getIssueAppraise2() {
		return issueAppraise2;
	}

	public void setIssueAppraise2(BigDecimal issueAppraise2) {
		this.issueAppraise2 = issueAppraise2;
	}

	public BigDecimal getLeftDays1() {
		return leftDays1;
	}

	public void setLeftDays1(BigDecimal leftDays1) {
		this.leftDays1 = leftDays1;
	}

	public BigDecimal getLeftDays2() {
		return leftDays2;
	}

	public void setLeftDays2(BigDecimal leftDays2) {
		this.leftDays2 = leftDays2;
	}

	public BigDecimal getHgDays1() {
		return hgDays1;
	}

	public void setHgDays1(BigDecimal hgDays1) {
		this.hgDays1 = hgDays1;
	}

	public BigDecimal getHgDays2() {
		return hgDays2;
	}

	public void setHgDays2(BigDecimal hgDays2) {
		this.hgDays2 = hgDays2;
	}

	public String getStockTargetType() {
		return stockTargetType;
	}

	public void setStockTargetType(String stockTargetType) {
		this.stockTargetType = stockTargetType;
	}

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}

	public BigDecimal getOrderQty() {
		return orderQty;
	}

	public void setOrderQty(BigDecimal orderQty) {
		this.orderQty = orderQty;
	}

	public BigDecimal getCashOrderQty() {
		return cashOrderQty;
	}

	public void setCashOrderQty(BigDecimal cashOrderQty) {
		this.cashOrderQty = cashOrderQty;
	}

	public String getRiskInfluenceFlag() {
		return riskInfluenceFlag;
	}

	public void setRiskInfluenceFlag(String riskInfluenceFlag) {
		this.riskInfluenceFlag = riskInfluenceFlag;
	}

	public String getExpirationDate() {
		return expirationDate;
	}

	public void setExpirationDate(String expirationDate) {
		this.expirationDate = expirationDate;
	}

	public String getValueDate() {
		return valueDate;
	}

	public void setValueDate(String valueDate) {
		this.valueDate = valueDate;
	}

	public BigDecimal getEarnestAmount() {
		return earnestAmount;
	}

	public void setEarnestAmount(BigDecimal earnestAmount) {
		this.earnestAmount = earnestAmount;
	}

	public BigDecimal getInterest() {
		return interest;
	}

	public void setInterest(BigDecimal interest) {
		this.interest = interest;
	}

	public String getExecBroker() {
		return execBroker;
	}

	public void setExecBroker(String execBroker) {
		this.execBroker = execBroker;
	}

	public String getBondSettleType() {
		return bondSettleType;
	}

	public void setBondSettleType(String bondSettleType) {
		this.bondSettleType = bondSettleType;
	}

	public String getBondSettleType2() {
		return bondSettleType2;
	}

	public void setBondSettleType2(String bondSettleType2) {
		this.bondSettleType2 = bondSettleType2;
	}

	public String getAdvanceLimitFlag() {
		return advanceLimitFlag;
	}

	public void setAdvanceLimitFlag(String advanceLimitFlag) {
		this.advanceLimitFlag = advanceLimitFlag;
	}

	public String getWithdrawType() {
		return withdrawType;
	}

	public void setWithdrawType(String withdrawType) {
		this.withdrawType = withdrawType;
	}

	public String getRecordDetailId() {
		return recordDetailId;
	}

	public void setRecordDetailId(String recordDetailId) {
		this.recordDetailId = recordDetailId;
	}

	public BigDecimal getRepoRate() {
		return repoRate;
	}

	public void setRepoRate(BigDecimal repoRate) {
		this.repoRate = repoRate;
	}

	public BigDecimal getEarnestBalance() {
		return earnestBalance;
	}

	public void setEarnestBalance(BigDecimal earnestBalance) {
		this.earnestBalance = earnestBalance;
	}

	public List<RequestCollateraDetailModel> getCollateraDetails() {
		return collateraDetails;
	}

	public void setCollateraDetails(List<RequestCollateraDetailModel> collateraDetails) {
		this.collateraDetails = collateraDetails;
	}
	/**
	 * 提供json格式的属性字符串   杨敏
	 * @return
	 */
	public String getToJsonStr(){
		
		String jsonStr="";//定义json 字符串
		jsonStr = "\"requestId\":"+RiskCtrlCenterService.isNull(this.getRequestId())+","+
				"\"fundCode\":"+RiskCtrlCenterService.isNull(this.getFundCode())+","+
				"\"fundId\":"+RiskCtrlCenterService.isNull(this.getFundId())+","+
				"\"combinNo\":"+RiskCtrlCenterService.isNull(this.getCombinNo())+","+
				"\"symbol\":"+RiskCtrlCenterService.isNull(this.getSymbol())+","+
				"\"exDestination\":"+RiskCtrlCenterService.isNull(this.getExDestination())+","+
				"\"stype\":"+RiskCtrlCenterService.isNull(this.getStype())+","+
				"\"currencyCode\":"+RiskCtrlCenterService.isNull(this.getCurrencyCode())+","+
				"\"interCode\":"+RiskCtrlCenterService.isNull(this.getInterCode())+","+
				"\"investType\":"+RiskCtrlCenterService.isNull(this.getInvestType())+","+
				"\"businType\":"+RiskCtrlCenterService.isNull(this.getBusinType())+","+
				"\"bondType\":"+RiskCtrlCenterService.isNull(this.getBondType())+","+
				"\"maturityYield1\":"+RiskCtrlCenterService.isNull(this.getMaturityYield1())+","+
				"\"maturityYield2\":"+RiskCtrlCenterService.isNull(this.getMaturityYield2())+","+
				"\"insideAppraise1\":"+RiskCtrlCenterService.isNull(this.getInsideAppraise1())+","+
				"\"insideAppraise2\":"+RiskCtrlCenterService.isNull(this.getInsideAppraise2())+","+
				"\"outerAppraise1\":"+RiskCtrlCenterService.isNull(this.getOuterAppraise1())+","+
				"\"outerAppraise2\":"+RiskCtrlCenterService.isNull(this.getOuterAppraise2())+","+
				"\"issueAppraise1\":"+RiskCtrlCenterService.isNull(this.getIssueAppraise1())+","+
				"\"issueAppraise2\":"+RiskCtrlCenterService.isNull(this.getIssueAppraise2())+","+
				"\"leftDays1\":"+RiskCtrlCenterService.isNull(this.getLeftDays1())+","+
				"\"leftDays2\":"+RiskCtrlCenterService.isNull(this.getLeftDays2())+","+
				"\"hgDays1\":"+RiskCtrlCenterService.isNull(this.getHgDays1())+","+
				"\"hgDays2\":"+RiskCtrlCenterService.isNull(this.getHgDays2())+","+
				"\"stockTargetType\":"+RiskCtrlCenterService.isNull(this.getStockTargetType())+","+
				"\"price\":"+RiskCtrlCenterService.isNull(this.getPrice())+","+
				"\"orderQty\":"+RiskCtrlCenterService.isNull(this.getOrderQty())+","+
				"\"cashOrderQty\":"+RiskCtrlCenterService.isNull(this.getCashOrderQty())+","+
				"\"riskInfluenceFlag\":"+RiskCtrlCenterService.isNull(this.getRiskInfluenceFlag())+","+
				"\"expirationDate\":"+RiskCtrlCenterService.isNull(RiskCtrlCenterService.getIntData(this.getExpirationDate()+"","yyyyMMdd"))+","+
				"\"valueDate\":"+RiskCtrlCenterService.isNull(this.getValueDate())+","+
				"\"earnestAmount\":"+RiskCtrlCenterService.isNull(this.getEarnestAmount())+","+
				"\"interest\":"+RiskCtrlCenterService.isNull(this.getInterest())+","+
				"\"execBroker\":"+RiskCtrlCenterService.isNull(this.getExecBroker())+","+
				"\"bondSettleType\":"+RiskCtrlCenterService.isNull(this.getBondSettleType())+","+
				"\"bondSettleType2\":"+RiskCtrlCenterService.isNull(this.getBondSettleType2())+","+
				"\"advanceLimitFlag\":"+RiskCtrlCenterService.isNull(this.getAdvanceLimitFlag())+","+
				"\"withdrawType\":"+RiskCtrlCenterService.isNull(this.getWithdrawType())+","+
				"\"recordDetailId\":"+RiskCtrlCenterService.isNull(this.getRecordDetailId())+","+
				"\"repoRate\":"+RiskCtrlCenterService.isNull(this.getRepoRate())+","+
				"\"isInquiry\":"+RiskCtrlCenterService.isNull(this.getIsInquiry())+","+ 
				"\"earnestBalance\":"+RiskCtrlCenterService.isNull(this.getEarnestBalance())+","+
				"\"bondYield\":"+RiskCtrlCenterService.isNull(this.getBondYield())+","+
				"\"bondYield2\":"+RiskCtrlCenterService.isNull(this.getBondYield2())+","+
				"\"stopPrice\":"+RiskCtrlCenterService.isNull(this.getStopPrice())+","+
				"\"realBondInterest\":"+RiskCtrlCenterService.isNull(this.getRealBondInterest())+"";
				jsonStr+=",\"collateraDetails\":[";
				List<RequestCollateraDetailModel> list = this.getCollateraDetails();
				int k=1;
				if(list!=null){
					for (RequestCollateraDetailModel requestCollateraDetailModel : list) {
						jsonStr+="{"+requestCollateraDetailModel.getToJsonStr()+"}";
						//最后一个不没有分号
						if(k<list.size()){
							jsonStr+=",";
							k++;
						}
					}
				}
				jsonStr=jsonStr+"]";
				return jsonStr;
	}
}