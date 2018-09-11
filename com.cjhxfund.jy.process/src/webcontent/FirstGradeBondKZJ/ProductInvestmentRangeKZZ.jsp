<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/JQMHistory/common/commscripts.jsp" %>
<html>
<%--
- Author(s): CJ-WB-DT13
- Date: 2016-03-09 11:38:26
- Description:
    --%>
    <head>
        <title>
            产品投资范围
        </title>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
        <link id="css_icon" rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/coframe/org/css/org.css"/>
        
      <%--  <script src="<%= request.getContextPath() %>/common/kindeditor/kindeditor.js" type="text/javascript"></script> 
		<script src="<%= request.getContextPath() %>/common/kindeditor/kindeditor-min.js" type="text/javascript"></script>--%>
        <%
           String combProductCode = request.getParameter("combProductCode");
         %>
    </head>
    <body style="width: 100%;height: 100%;overflow-X: hidden;">
        <!-- 标识页面是查看(query)、修改(edit)、新增(add) -->
        <input name="pageType" class="nui-hidden"/>
        <div id="dataform1" style="padding-top:5px;">
            <!-- hidden域 -->
            <input class="nui-hidden" name="cfjyproductinvestmentrange.productid"/>
            <table style="width:100%;height:100%;table-layout:fixed;" class="nui-form-table">
                <tr>
                    <td class="form_label" width="15%" align="right">
                        产品代码:
                    </td>
                    <td colspan="1" width="35%">
                        <input class="nui-textbox" name="ProductInvestmentRange.combProductCode" readonly/>
                    </td>
                    <td class="form_label" width="15%" align="right">
                        产品名称:
                    </td>
                    <td colspan="1" width="35%">
                        <input class="nui-textbox" name="ProductInvestmentRange.combProductName" style="width: 80%;"readonly/>
                    </td>
                </tr>
                <tr>
                    <td class="form_label" align="right">
                        可投范围:
                    </td>
                    <td colspan="3">
                        <input class="nui-textarea" width="100%" height="110" name="ProductInvestmentRange.voteRange" readonly/>
                       <%-- <textarea id="ke1" name="cfjyproductinvestmentrange.noCastRange" style="width:100%;height:120px;visibility:hidden;">

        				</textarea>--%>
                    </td>
                </tr>
                <tr>    
                    <td class="form_label" align="right">
                        禁投范围:
                    </td>
                    <td colspan="3">
                        <input class="nui-textarea" width="100%" height="110" name="ProductInvestmentRange.noCastRange" readonly/>
                        <%--<textarea id="ke" name="cfjyproductinvestmentrange.noCastRange" style="width:100%;height:120px;visibility:hidden;">

        				</textarea>--%>
                    </td>
                </tr>
                <tr>     
                    <td class="form_label" align="right">
                        投资限制:
                    </td>
                    <td colspan="3">
                        <input class="nui-textarea" width="100%" height="115" name="ProductInvestmentRange.investmentLimit" readonly/>
                         <%--<textarea id="ke2" name="cfjyproductinvestmentrange.noCastRange" style="width:100%;height:200px;visibility:hidden;">

        				</textarea>--%>
                    </td>
                </tr>
                <tr>
                    <td class="form_label" align="right">
                        备注:
                    </td>
                    <td colspan="3">
                        <input class="nui-textarea" width="100%" height="115" name="ProductInvestmentRange.remarks" readonly/>
                    </td>
                </tr>
            </table>
        </div>
        <script type="text/javascript">
            nui.parse();

            function Init(){
                var json = nui.encode({combProductCode : '<%=combProductCode %>'});

                $.ajax({
                    url:"com.cjhxfund.jy.process.cfjyproductinvestmentrangebiz.expandProductInvestmentRange.biz.ext",
                    type:'POST',
                    data:json,
                    cache:false,
                    contentType:'text/json',
                    success:function(text){
                        var returnJson = nui.decode(text);
                        var form = new nui.Form("#dataform1");//将普通form转为nui的form
                            form.setData(returnJson);
                           	form.setChanged(false);
                        }
					  });
                 }
                 Init();
                </script>
            </body>
        </html>
