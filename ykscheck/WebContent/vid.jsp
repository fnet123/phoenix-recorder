<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.youku.yks.bean.*" %>
<%@ page import="com.youku.yks.dao.*" %>
<%@ page import="com.youku.yks.dao.impl.*" %>
<%@ page import="com.youku.yks.paging.*"%>
<%@ page import="com.youku.yks.tools.*"%>

<%    
    PagingCommon pagingCommon = new PagingCommon();
    VidDao vidDao = new VidImpl();
    UserDao userDao = new UserDaoImpl();
    VidPaging vidPaging = new VidPaging(); 
    VidBean vidBean = new VidBean();
    List<VidBean> vidList = new ArrayList<VidBean>();
    UserBean userBean = (UserBean)session.getAttribute("user");
%>

<%
	request.setCharacterEncoding("UTF-8"); //设置编码集
	String strPageNum = request.getParameter("pageNum");
	String numPerPage = request.getParameter("numPerPage");	
	String checkKey = request.getParameter("keyword");

	vidPaging.setUserBean(userBean);
	pagingCommon.setNumPerPage(numPerPage);
	pagingCommon.setStrPageNum(strPageNum);
	pagingCommon.setTotalRow(vidPaging.getVidTotalRow());
	
	PagingBean pagingBean = pagingCommon.getPagingData();
	
	int totalRow = pagingBean.getTotalRow();
	int totalPage = pagingBean.getTotalPage();
	int currentPage = pagingBean.getCurrentPage();
	int initPerPageRows = pagingBean.getNumPerPage();
		
	if(checkKey!=null && !checkKey.equals("")){
		try{
		    VidBean vid = vidDao.getVidByName(checkKey,userBean.getId());
		    vidList.add(vid);	
		}catch(Exception e){}
	}else{
		checkKey = "";
		vidList = vidPaging.getVidQuery(currentPage,initPerPageRows); //分页查询
	}

%>
<jsp:include page="check.jsp" flush="true"/>
<form id="pagerForm" method="post" action="vid.jsp">
	<input type="hidden" name="keyword" value="<%=checkKey == null?"":checkKey %>" />
	<input type="hidden" name="pageNum" value="1" />
	<input type="hidden" name="numPerPage" value=<%=initPerPageRows %> />
	<input type="hidden" name="orderField" value="asc" />
</form>	
	
<div class="pageHeader">
	<form onsubmit="return navTabSearch(this);" action="vid.jsp" method="post">
	<div class="searchBar">
		<table class="searchContent">
			<tr>
				<td>
					输入vid值查询：<input type="text" name="keyword" size=40 value=<%=checkKey %>>
				</td>
				<td><div class="buttonActive"><div class="buttonContent"><button type="submit">提交数据</button></div></div></td>
				
			</tr>
		</table>
		<div class="subBar">
			<ul>
			    <li></li>
			</ul>
		</div>
	</div>
	</form>
</div>
<div class="pageContent">
	<div class="panelBar">
		<ul class="toolBar">
		    <li><a title="添加一个新vid" class="add" href="add/addvid.jsp" target="dialog" rel="addvid_page"><span>添加</span></a></li>
			<li class="line">line</li>
			<li><a class="icon" href="#" target="dwzExport" targetType="navTab" title="确实要导出这些记录吗?"><span>导出EXCEL</span></a></li>
		</ul>
	</div>
	<table class="table" width="100%" layoutH="138">
		<thead>
			<tr align="center">
			    <th width="10%">Id</th>
			    <th width="15%">所属用户</th>
			    <th width="15%">vid</th>
			    <th width="15%">vid名称</th>
			    <th width="30%">备注</th>
			    <th width="15%">操作</th>
			</tr>
		</thead>
		<tbody>
		<%
			for (VidBean vidData : vidList) {
		%>
		<tr target="sid_caseType" rel="1"  align="center">
			<td><%=vidData.getId()%></td>
			<td><%=userDao.getUser(vidData.getUserId()).getName() %></td>
			<td><%=vidData.getVid()%></td>
			<td><%=vidData.getVidName() %></td>
			<td><%=vidData.getRemark() %></td>
			<td>
				<a title="要删除vid “<%=vidData.getVid()%>” 吗？删除后与其关联的用例数据将不可使用，且删除后数据不可恢复！" target="ajaxTodo" href="do/dovid.jsp?type=delete&id=<%=vidData.getId()%>" class="btnDel">删除</a>
				<a target="dialog" mask="true" title="编辑" href="detail/viddetail.jsp?id=<%=vidData.getId()%>" class="btnEdit">编辑</a>
			</td>
		</tr>
		<%
			}
		%>


		</tbody>
	</table>
	<div class="panelBar">
		<div class="pages">
			<span>显示</span>
			<select class="combox" name="numPerPage" onchange="navTabPageBreak({numPerPage:this.value})">
				<option value=>当前每页:<%=initPerPageRows%></option>
				<option value="20">20</option>
				<option value="30">30</option>
				<option value="50">50</option>
				<option value="100">100</option>
			</select>
			<span>条，共<%=totalRow%>条</span>
		</div>
		
		<div class="pagination" targetType="navTab" totalCount=<%=totalRow%> numPerPage=<%=initPerPageRows%> pageNumShown=10 currentPage=<%=currentPage%>></div>
	</div>
</div>