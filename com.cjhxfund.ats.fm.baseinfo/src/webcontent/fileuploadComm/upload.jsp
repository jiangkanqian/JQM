<%@page import="com.cjhxfund.ats.fm.comm.DateUtil"%>
<%@page import="com.cjhxfund.ats.fm.comm.ProductUtil"%>
<%@page import="com.cjhxfund.foundation.task.ProcessUtil"%>
<%@page import="java.util.Date"%>
<%@page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" session="false" %>
<%@page import="com.eos.foundation.database.DatabaseUtil"%>
<%@page import="com.eos.foundation.data.DataObjectUtil"%>
<%@page import="commonj.sdo.DataObject"%>
<%@page import="java.io.File"%>
<%@page import="java.io.IOException"%>
<%@page import="java.util.List"%>
<%@page import="java.util.UUID"%>
<%@page import="com.eos.data.datacontext.UserObject"%>
<%@page import="javax.servlet.http.HttpServletRequest"%>
<%@page import="javax.servlet.http.HttpServletResponse"%>

<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="com.eos.engine.component.ILogicComponent"%>
<%@page import="com.primeton.ext.engine.component.LogicComponentFactory"%>

<%
	String bizId = request.getParameter("bizId");
	String attachType = request.getParameter("attachType");
	String attachBusType = request.getParameter("attachBusType");
	String lStockInvestNo = request.getParameter("lStockInvestNo"); 
	String processinstid = request.getParameter("processinstid");
    String workItemID = request.getParameter("workItemID"); 

	String usreId = "";
	
	String fileId = "";
	
	String attachName;
	
	String extention;
	
	UUID uuid;
	
	DiskFileItemFactory factory = new DiskFileItemFactory();
		// 设置内存缓冲区，超过后写入临时文件
		factory.setSizeThreshold(10240000); 
		// 设置临时文件存储位置
		String ContextPath = request.getContextPath();
		//设置上传路径
		String base = "";
		if(attachType.equals("1")){
			 base = ProductUtil.UPLOAD_FILE_PATH_LIUCHENG;
		}else if(attachType.equals("2")){//新债录入
			if(attachBusType.equals("1")){//募集说明书
				 base =ProductUtil.UPLOAD_FILE_PATH_MJSMS;
			}else if(attachBusType.equals("2")){//信用评级报告
				base =ProductUtil.UPLOAD_FILE_PATH_CREDIT;
			}else if(attachBusType.equals("3")){//债券发行公告
				base =ProductUtil.UPLOAD_FILE_PATH_PUBLICATION;
			}
		}else if(attachType.equals("9")){
		   if(attachBusType.equals("9")){
			    base =ProductUtil.UPLOAD_FILE_PATH_UNDERWRITER;
			}
		}else if("99".equals(attachType) || "99".equals(attachBusType)){	//招行文件路径
			base = ProductUtil.UPLOAD_FILE_PATH_ZH;
		}else if(attachType.equals("77")){
		   if(attachBusType.equals("1")){
			    base = ProductUtil.UPLOAD_FILE_PATH_CHARGEAGAINST;
			}
			if(attachBusType.equals("2")){
			    base = ProductUtil.UPLOAD_FILE_PATH_INTERESTSWAP;
			}
			if(attachBusType.equals("3")){
			    base = ProductUtil.UPLOAD_FILE_PATH_GOLD;
			}
		}
		else{
			base = ProductUtil.UPLOAD_FILE_PATH_TEMP;
		}
		File file = new File(base);
		
		if(!file.exists())
			file.mkdirs();
		factory.setRepository(file);
		ServletFileUpload upload = new ServletFileUpload(factory);
		// 设置单个文件的最大上传值
		upload.setSizeMax(10002400000l);
		// 设置整个request的最大值
		upload.setSizeMax(10002400000l);
		upload.setHeaderEncoding("UTF-8");
		
		//逻辑构建名称
		String componentName = "com.cjhxfund.ats.fm.comm.attachUitlFunction";
		//逻辑流名称
		String operationName = "addAttachment";
			
		ILogicComponent comp = LogicComponentFactory.create(componentName);
			
		try {
			List<?> items = upload.parseRequest(request);
			FileItem item = null;
			String fileName = null;
			for (int i = 0 ;i < items.size(); i++){
				item = (FileItem) items.get(i);
				attachName=item.getName();
				// 保存文件
				if (!item.isFormField() && attachName.length() > 0) {
				    //获取扩展名
				    if(attachName.length()>0&&attachName!=null){
				    int k=attachName.lastIndexOf(".");        
				    extention=attachName.substring(k+1);
				    uuid=UUID.randomUUID();
			    	fileName = base + File.separator + DateUtil.currentDateString(DateUtil.YYYYMMDDHHMMSS_NUMBER) + "_" + attachName.substring(0,k) +'.'+extention;
			    	} 
                    //文件名与UUID生成的文件写进服务器
					item.write(new File(fileName));
					Object[] params = new Object[]{attachName,fileName,  item.getSize(),usreId,bizId,attachType,attachBusType,workItemID,processinstid};
					Object[] result = (Object[])comp.invoke(operationName, params);
					Long sysid = (Long)result[0];	
					fileId += sysid.toString();
				}			
			}
			out.write(fileId);
								
		} catch (FileUploadException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}catch(Throwable e){
			System.out.print("文件写入出错！");
			e.printStackTrace();
		}
		
		
 %>