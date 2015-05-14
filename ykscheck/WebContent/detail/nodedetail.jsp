<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.youku.yks.bean.*" %>
<%@ page import="com.youku.yks.dao.*" %>
<%@ page import="com.youku.yks.dao.impl.*" %>
<%@ page import="com.youku.yks.paging.*"%>
<%@ page import="com.youku.yks.tools.*"%>
<%
  String id = request.getParameter("id");
  NodeDao nodeDao = new NodeImpl();
  CaseDao caseDao = new CaseImpl();
  UserBean userBean = (UserBean)session.getAttribute("user");
  NodeBean getNode = nodeDao.getUnitNode(Integer.parseInt(id));
  CaseBean getCase = caseDao.getUnitCase(getNode.getCaseNodeId());
  
%>
<jsp:include page="../checkin.jsp" flush="true"/>
<div class="pageContent">
	<form method="post" action="./do/donode.jsp?type=update" class="pageForm required-validate" onsubmit="return validateCallback(this, navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56">
			<div class="unit">
				<label>用例节点详细信息</label>
			</div>
			<div class="divider">divider</div>
			<p>
				<label>Id：</label>
				<input type="text" readonly="true" name="id" size=25 value=<%=getNode.getId() %>>
				<span class="inputInfo">库中的id</span>
			</p>
			<p>
				<label>所属用户：</label>
				<input type="hidden" name="userId" size=25 value=<%=userBean.getId() %>>
				<input type="text" readonly="true" name="userName" size=25 value=<%=userBean.getName() %>>
				<span class="inputInfo">用户名称</span>
			</p>
			<p>
				<label>所属用例：</label>
				<input id="inputOrg1" name="org1.id" value="<%=getCase.getId() %>" type="hidden"/>
				<input class="required" name="org1.orgName" type="text" postField="keyword" size="25" value=<%=getCase.getCaseNode() %>>
				<a class="btnLook" href="./lookback/backcase.jsp" lookupGroup="org1">查找带回</a>	
			</p>
			
			<p>
				<label>节点名称：</label>
				<input type="text" class="required" name="caseNodeName" size=25 value=<%=getNode.getParamNode() %>>
				<span class="inputInfo">用例名称</span>
			</p>
			
			<p>
				<label>是否可用：</label>
				<input type="hidden" name="orgLookup.orgName" value="${orgLookup.orgNum}"/>
				<input type="text" size=25 class="required" name="orgLookup.orgNum" value="<%=getNode.getIsDisabled() %>" suggestFields="orgNum,orgName" suggestUrl="files/isDisabled.html" lookupGroup="orgLookup" />
				<span class="inputInfo">设置节点状态</span>
			</p>
			
		    <p>
				<label>备注：</label>
				<input type="text" name="remark" size=25 value=<%=getNode.getRemark() %>>
				<span class="inputInfo">功能介绍</span>
			</p>

		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">保存修改</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">关闭窗口</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>