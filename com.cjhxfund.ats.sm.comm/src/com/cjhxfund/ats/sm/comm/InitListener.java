/**
 * 
 */
package com.cjhxfund.ats.sm.comm;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.cjhxfund.ats.qrtz.QrtzMoniteHandler;
import com.eos.engine.component.ILogicComponent;
import com.eos.system.annotation.Bizlet;
import com.primeton.ext.engine.component.LogicComponentFactory;

/**
 * ServletContextListener 接口能够监听 ServletContext 对象的生命周期
 * @author 金文轩
 * @date 2016-09-14 14:11:26
 *
 */
@Bizlet("监听器")
public class InitListener implements ServletContextListener{
	//@Override
	/**
	 * Servlet容器启动时调用此方法
	 */
	public void contextInitialized(ServletContextEvent paramServletContextEvent) {
		
		try{
			//调用O32ServiceEntry的方法
			O32ServiceEntry.loadData();
			
			//以下定时器监控功能已停用，by huangmizhi 2018.04.19
//			//启动定时器监控线程
//			System.out.println("InitListener=====startQrtzMonite启动");
//			Object[] param = new Object[]{"ATS_QRTZ_MONITE"};
//			String componentCount = "com.cjhxfund.commonUtil.zhfwptparamconfbiz";
//	    	ILogicComponent logicComponent = LogicComponentFactory.create(componentCount);
//	    	Object[] result = logicComponent.invoke("getParamValue",param);
//	    	if("1".equals(result[0])){//开启监控
//	    		QrtzMoniteHandler.startQrtzMonite();
//	    	}else{
//	    		QrtzMoniteHandler.stopQrtzMonite();
//	    	}
		}catch(Throwable e){
			e.printStackTrace();
		}
	}
	//@Override
	public void contextDestroyed(ServletContextEvent paramServletContextEvent) {
	}
}