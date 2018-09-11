/**
 * 
 */
package com.cjhxfund.commonUtil;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.eos.system.annotation.Bizlet;
import com.primeton.spring.support.DataObjectUtil;
import commonj.sdo.DataObject;

/**
 * 对象比较类
 * @author chendi
 *
 */
@Bizlet("")
public class CompareUtil {
	/**
	 * 取得上清中债(现券交易列表和结算指令下载列表)最新数据更新时间和当前时间的差异分钟数
	 * @param data
	 * @author 陈迪
	 * @date 2017-03-30 13:49:42
	 *
	 */
	@Bizlet("")
	public static DataObject[] getBetweenTime(DataObject data){
		//定义上清中债差异数据对象
		DataObject sqData = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
		DataObject zzData = DataObjectUtil.createDataObject("commonj.sdo.DataObject");
		Date sqUtime = data.getDate("sqUtime");
		Date zzUtime = data.getDate("zzUtime");
		Date cuttentTime = data.getDate("cuttentTime");
        //定义上清中债分别和当前时间的差异分钟数
        long sqMin = 0;  //上清差异分钟数
        long zzMin = 0; //中债差异分钟数
        //将时间转换为毫秒数
        long sqTime = sqUtime.getTime();
        long zzTime = zzUtime.getTime();
		long nowTime = cuttentTime.getTime();
		//获取上清中债分别和当前时间的差异分钟数
		sqMin = (nowTime - sqTime) / (60 * 1000);
		zzMin = (nowTime - zzTime) / (60 * 1000);
		//存储差异数据
		int length = 0;
		int lengthSq = 0;
		int lengthZz = 0;
		DataObject obj = (DataObject) com.eos.foundation.eoscommon.CacheUtil.getValue("ReloadParamConf1", "ATS_SQANDZZ_SM_TIME");//上清中债下载扫描间隔时间差
		int index = Integer.valueOf(obj.getString("paramValue").trim());
		if(sqMin>index){
			lengthSq = 1;
			sqData.set("diffMin", sqMin);
			sqData.set("type", "01");
		}else{
			sqData = null;
		}
		if(zzMin>index){
			lengthZz = 1;
			zzData.set("diffMin", zzMin);
			zzData.set("type", "02");
		}else{
			zzData = null;
		}
		length = lengthSq + lengthZz;
		//组装差异数组
		DataObject[] datas = new DataObject[length];
		if(lengthSq==1 && lengthZz==1){
			datas[0] = sqData;
			datas[1] = zzData;
		}else if(lengthSq==1 && lengthZz==0){
			datas[0] = sqData;
		}else if(lengthSq==0 && lengthZz==1){
			datas[0] = zzData;
		}else{
			datas = null;
		}
		return datas;
	}
	
	/**
	 * 判断当前时间是否大于当天早上8点30并且小于下午5点05分，是则返回true，否则返回false
	 * @param sysTime 系统时间
	 * @author 陈迪
	 * @date 2017-03-30 13:49:42
	 *
	 */
	@Bizlet("")
	@SuppressWarnings("deprecation")
	public static boolean isCorrectFlag(Date sysTime){
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date now = new Date();
        long startTime = 0;//开始时间初始化
        long endTime = 0;//结束时间初始化
        long nowTime = 0;//当前时间初始化
        boolean flag = false;
		try {
			nowTime = sysTime.getTime();//当前时间
//			nowTime = df.parse((now.getYear() + 1900)+"-"+(now.getMonth()+1)+"-"+now.getDate()+" "+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds()).getTime();//当前时间
			startTime = df.parse((now.getYear() + 1900)+"-"+(now.getMonth()+1)+"-"+now.getDate()+" 08:40:00").getTime();//开始时间
			endTime = df.parse((now.getYear() + 1900)+"-"+(now.getMonth()+1)+"-"+now.getDate()+" 17:05:00").getTime();//结束时间
		} catch (ParseException e1) {
			e1.printStackTrace();
		}
		if(nowTime>startTime && nowTime<endTime){
			flag = true;
		}
		return flag;
	}
	
	/**
	 * 判断当前登录者是否包含指定权限
	 * @param roleList 权限列表
	 * @param roleid   指定权限ID
	 * @return
	 */
	@Bizlet("")
	public static boolean isPermissiom(String roleList , String roleid){
		boolean flag = false;
		
		if(roleList.indexOf(roleid) > 0){
			flag = true;
		}
		
		return flag ;
	}
	
}
