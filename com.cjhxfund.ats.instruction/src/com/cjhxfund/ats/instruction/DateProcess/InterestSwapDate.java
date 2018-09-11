package com.cjhxfund.ats.instruction.DateProcess;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import com.cjhxfund.commonUtil.DateUtil;
import com.eos.foundation.data.DataObjectUtil;
import com.eos.system.annotation.Bizlet;

import commonj.sdo.DataObject;

/**
 * 利率互换日期类
 * @author jiangkanqian
 */
@Bizlet("")
public class InterestSwapDate {
	
	
	/**
	 * 根据交易日和业务名称获取联动数据
	 * @param d1
	 * @param d2
	 * @dateFormat 时间格式   yyyy-MM-dd hh:mm:ss
	 * @return
	 * @throws ParseException 
	 */
	@Bizlet("获取利率互换联动日期")
	public static DataObject getDates(String tradeDate,String valDate,String bsHead,String bsTail,String payCycle,String dateFormat) throws ParseException{
		DataObject dateData = DataObjectUtil.createDataObject("com.cjhxfund.ats.instruction.DateProcess.date.DateData");
		DateFormat dFormat= new SimpleDateFormat(dateFormat);
		Date date = dFormat.parse(tradeDate);
		Calendar calendar = new GregorianCalendar();
		//起息日	
		String valueDate = "";
		if(valDate!=null){
			valueDate = valDate;
		}
		else{
			valueDate = tradeDate;
			if("FR007".equals(bsHead) || "SHIBOR_3M".equals(bsHead)){			
				calendar.setTime(date);
				calendar.add(Calendar.DATE, 1);
				date = calendar.getTime();
				valueDate = dFormat.format(date);
			}
		}
		
		//首期利率确定日
		String firateDay = "";
		date = dFormat.parse(valueDate);
		calendar.setTime(date);
		if("FR007".equals(bsHead) || "SHIBOR_3M".equals(bsHead)){
			calendar.add(Calendar.DATE, -1);
			date = calendar.getTime();
			firateDay = dFormat.format(date);
		}
		if("SHIBOR_O/N".equals(bsHead)){
			date = calendar.getTime();
			firateDay = dFormat.format(date);
		}
		date = dFormat.parse(firateDay);
		DateFormat dFormat1 = new SimpleDateFormat("yyyyMMdd");
		firateDay = dFormat1.format(date);
		boolean isTrade = DateUtil.isTradeDay(null, firateDay, null);
		if(!isTrade){
			firateDay = DateUtil.getCalculateTradeDay(null, firateDay, null, -1);
		}
		
		//到期日
		date = dFormat.parse(valueDate);
		calendar.setTime(date);
		int bsTailLen = bsTail.length();
		String time = bsTail.substring(bsTailLen-1, bsTailLen);
		int count = Integer.parseInt(bsTail.substring(0, bsTailLen-1));
		if("D".equals(time)){
			calendar.add(Calendar.DATE, count);
		}
		if("M".equals(time)){
			calendar.add(Calendar.MONTH, count);
		}
		if("Y".equals(time)){
			calendar.add(Calendar.YEAR, count);
		}
		date = calendar.getTime();
		String dueDate = dFormat.format(date);
		
		//首期定期支付日
		String firegulPayday = "";
		date = dFormat.parse(valueDate);
		calendar.setTime(date);
		if("到期".equals(payCycle)){
			firegulPayday = dueDate;
		}
		else{
			if("季".equals(payCycle)){
				calendar.add(Calendar.MONTH, 3);
			}
			if("年".equals(payCycle)){
				calendar.add(Calendar.YEAR, 1);
			}
			date = calendar.getTime();
			firegulPayday = dFormat.format(date);
		}
		//跳过节假日（周末），如果跨月份则提前
		date = dFormat.parse(firegulPayday);
		DateFormat format = new SimpleDateFormat("yyyyMMdd");
		firegulPayday = format.format(date);
		boolean isTradeDay = DateUtil.isTradeDay(null, firegulPayday, null);
		if(!isTradeDay){
			firegulPayday = DateUtil.getCalculateTradeDay(null, firegulPayday, null, 1);
		}
		/*
		Date date1 = date;
		calendar.setTime(date);
		Calendar calendar1 = new GregorianCalendar();
		calendar1.setTime(date1);
		int month = calendar.get(Calendar.MONTH);
		if(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY){
			calendar1.add(Calendar.DATE, 1);
			int month1 = calendar1.get(Calendar.MONTH);
			if(month == month1){
				calendar.add(Calendar.DATE, 1);
			}
			else{
				calendar.add(Calendar.DATE, -2);
			}
		}
		if(calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY){
			calendar1.add(Calendar.DATE, 2);
			int month1 = calendar1.get(Calendar.MONTH);
			if(month == month1){
				calendar.add(Calendar.DATE, 2);
			}
			else{
				calendar.add(Calendar.DATE, -1);
			}			
		}
		date = calendar.getTime();
		firegulPayday = dFormat.format(date);
		*/					
		
		dateData.set("valueDate",valueDate);
		dateData.set("firateDay",firateDay);
		dateData.set("dueDate",dueDate);
		dateData.set("firegulPayday",firegulPayday);
		return dateData;
	}
	
}
