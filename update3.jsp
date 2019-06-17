<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs3.Bbs3"%>
<%@ page import="bbs3.Bbs3DAO"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" , initial-scale="1.0">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="css/style.css">
<title>경비In 웹 사이트</title>
</head>
<body>
	<%
		String userID = null;
			if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID"); //로그인시, userID에 해당 아이디가 입력됨.
			}
			if (userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.')");
		script.println("location.href = 'login.jsp'");
		script.println("</script>");
			}
			int bbsID = 0; //글의 번호가 들어오지 않았다면
			if (request.getParameter("bbsID") != null) { //특정한 번호가 존재해야 글을 볼 수 있음.
		bbsID = Integer.parseInt(request.getParameter("bbsID"));
			}
			if (bbsID == 0) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 글입니다.')");
		script.println("location.href = 'bbs3.jsp'");
		script.println("</script>");
			}
			Bbs3 bbs = new Bbs3DAO().getBbs(bbsID);
			if (!userID.equals(bbs.getUserID())) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('권한이 없습니다.')");
		script.println("location.href = 'bbs3.jsp'");
		script.println("</script>");
			}
	%>
<nav class="navbar navbar-default navbar-fixed-top">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>                        
      </button>
      <a class="navbar-brand" href="main.jsp">경비In</a>
    </div>
    <div class="collapse navbar-collapse" id="myNavbar">
      <ul class="nav navbar-nav navbar-right">
        <li><a href="main.jsp">홈</a></li>
        <li><a href="#band">경비In 소개</a></li>
        <li class="dropdown">
          <a class="dropdown-toggle" data-toggle="dropdown" href="#">게시판
          <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="bbs.jsp">공지 게시판</a></li>
            <li><a href="bbs2.jsp">자유 게시판</a></li>
            <li><a href="bbs3.jsp">민원 게시판</a></li>
            <li><a href="bbs4.jsp">장터 게시판</a></li> 
          </ul>
        </li>
        <li><a href="#tour">블라블라</a></li>
        <li class="dropdown">
          <a class="dropdown-toggle" data-toggle="dropdown" href="#">회원관리
          <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="login.jsp">로그인</a></li>
            <li><a href="join.jsp">회원가입</a></li>
          </ul>
        </li>
      </ul>
    </div>
  </div>
</nav>

	<div class="container">
		<div class="row">
			<form method="post" action="updateAction3.jsp?bbsID=<%=bbsID%>">
				<table class="table table-striped"
					style="text-align: center; border: 1px solid #dddddd;">
					<thead>
						<tr>
							<th colspan="2"
								style="background-color: #eeeeee; text-align: center">게시판 글 수정 양식</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><input type="text" class="form-control"
								placeholder="글 제목" name="bbsTitle" maxlength="50"
								value="<%=bbs.getBbsTitle()%>"></td>
						</tr>
						<tr>
							<td><textarea class="form-control" placeholder="글 내용"
									name="bbsContent" maxlength="2048" style="height: 350px;"><%=bbs.getBbsContent()%></textarea></td>
						</tr>
					</tbody>
				</table>
				<input type="submit" class="btn btn-primary pull-right" value="글수정">
			</form>

		</div>
	</div>

	<!--  시도#1
	<script src="https://code.jquery.com/jqurey-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	-->
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<!-- 
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>﻿
	 -->
</body>
</html>