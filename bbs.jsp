<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" , initial-scale="1.0">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="css/style.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<title>경비In</title>
<!-- 20190614 홈페이지 이름 수정 -->

<style>
a, a:hover {
	color: #000000;
	text-decoration: none;
}
</style>
</head>
<body id="myPage" data-spy="scroll" data-target=".navbar"
	data-offset="50">

	<!-- 로그인이 된 사람들의 세션을 만들어 준다. 

		 회원값이 있는 사람들은 userID에 정보가 담기게 되고

		 아닌 사람은 null값을 가지게 된다.

	-->
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		int pageNumber = 1;
		if (request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>
	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target="#myNavbar">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="main.jsp">경비In</a>
			</div>
			<div class="collapse navbar-collapse" id="myNavbar">
				<ul class="nav navbar-nav navbar-right">
					<li><a href="main.jsp">홈</a></li>
					<li class="dropdown"><a class="dropdown-toggle"
						data-toggle="dropdown" href="#">게시판 <span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="bbs.jsp">공지 게시판</a></li>
							<li><a href="bbs2.jsp">자유 게시판</a></li>
							<li><a href="bbs3.jsp">민원 게시판</a></li>
							<li><a href="bbs4.jsp">장터 게시판</a></li>
						</ul></li>
					<li><a href="#tour">블라블라</a></li>
					<%
						if (userID == null) {
					%>
					<li class="dropdown"><a class="dropdown-toggle"
						data-toggle="dropdown" href="#">회원관리 <span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="login.jsp">로그인</a></li>
							<li><a href="join.jsp">회원가입</a></li>
						</ul></li>
					<%
						} else {
					%>
					<li class="dropdown"><a class="dropdown-toggle"
						data-toggle="dropdown" href="#">회원관리 <span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="logoutAction.jsp">로그아웃</a></li>
						</ul></li>
					<%
						}
					%>
				</ul>
			</div>
		</div>
	</nav>
	<div class="container">
		<div class="row">
			<p>공지게시판</p>
			<table class="table table-striped"
				style="text-align: center; border: 1px;">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
						<th style="background-color: #eeeeee; text-align: center;">조회수</th>
					</tr>
				</thead>
				<tbody>
					<%
						BbsDAO bbsDAO = new BbsDAO();
						ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
						ArrayList<Bbs> listAll = bbsDAO.getAllList();
						int result; //2019-06-08 [BEST]인기글		
						int OrderNum = 1;
						int k = listAll.size() - ((pageNumber - 1) * 10) + 1;
						for (int i = 0; i < list.size(); i++) {
							// 2019-06-15 [투표] 생성_BEGIN_박초희
							//if(list.get(i).getBbsVOTE()==1){
							//	result = bbsDAO.best(list.get(i).getBbsID(), "[투표] "+list.get(i).getBbsTitle());
							//}
							//2019-06-15 [투표] 생성_END_박초희
					%>
					<tr>
						<%
							if (list.get(i).getBbsVOTE() == 1) {
						%>
						<td><%=k - OrderNum%></td>
						<%
							if (list.get(i).getBbsView() >= 15) {
						%>
						<td><a
							href="voteview.jsp?bbsID=<%=list.get(i).getBbsID()%>&modNum=<%=0%>#<%=0%>">[BEST]
								<%=list.get(i).getBbsTitle().replaceAll(" ", "&nbsp").replaceAll("<", "&lt")
								.replaceAll(">", "&gt").replaceAll("\n", "<br>")%></a></td>
						<%
							} else {
						%>
						<td><a
							href="voteview.jsp?bbsID=<%=list.get(i).getBbsID()%>&modNum=<%=0%>#<%=0%>"><%=list.get(i).getBbsTitle().replaceAll(" ", "&nbsp").replaceAll("<", "&lt")
								.replaceAll(">", "&gt").replaceAll("\n", "<br>")%></a></td>
						<%
							}
						%>
						<td><%=list.get(i).getUserID()%></td>
						<td><%=list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13)
							+ "시" + list.get(i).getBbsDate().substring(14, 16) + "분"%></td>
						<td><%=list.get(i).getBbsView()%></td>
					</tr>
					<%
						} else {
					%>
					<tr>
						<td><%=k - OrderNum%></td>
						<%
							if (list.get(i).getBbsView() >= 15) {
						%>
						<td><a
							href="view.jsp?bbsID=<%=list.get(i).getBbsID()%>&modNum=<%=0%>#<%=0%>">[BEST]
								<%=list.get(i).getBbsTitle().replaceAll(" ", "&nbsp").replaceAll("<", "&lt")
								.replaceAll(">", "&gt").replaceAll("\n", "<br>")%></a></td>
						<%
							} else {
						%>
						<td><a
							href="view.jsp?bbsID=<%=list.get(i).getBbsID()%>&modNum=<%=0%>#<%=0%>"><%=list.get(i).getBbsTitle().replaceAll(" ", "&nbsp").replaceAll("<", "&lt")
								.replaceAll(">", "&gt").replaceAll("\n", "<br>")%></a></td>
						<%
							}
						%>
						<td><%=list.get(i).getUserID()%></td>
						<td><%=list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13)
							+ "시" + list.get(i).getBbsDate().substring(14, 16) + "분"%></td>
						<td><%=list.get(i).getBbsView()%></td>
					</tr>
					<%
						}
							OrderNum++;
						}
					%>

				</tbody>
			</table>
			<%
				if (pageNumber != 1) {
			%>
			<a href="bbs.jsp?pageNumber=<%=pageNumber - 1%>"
				class="btn btn-success btn-arraw-left">이전</a>
			<%
				}
			System.out.print(k-OrderNum);

				if (bbsDAO.nextPage(pageNumber + 1) && k-OrderNum != 0) {
			%>
			<a href="bbs.jsp?pageNumber=<%=pageNumber + 1%>"
				class="btn btn-success btn-arraw-left">다음</a>
			<%
				}
			%>
			<a href="votewrite.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
</body>
</html>