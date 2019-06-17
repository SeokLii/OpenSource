<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" , initial-scale="1.0">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="css/style.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<title>경비In 웹 사이트</title>
</head>
<body>
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
		<div class="col-lg-4"></div>
		<div class="col-lg-4">
			<div class="jumbotron" style="padding-top: 20px; width : 300px;">
				<form method="post" action="joinAction.jsp"> <!-- 이쪽으로 데이터를 보낸다. -->
					<h3 style="text-align: center;">회원가입화면</h3>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="아이디" name="userID" maxlength="20">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="비밀번호" name="userPassword" maxlength="20">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="이름" name="userName" maxlength="20">
					</div>
					<div class="form-group" style="text-align: center;">
						<div class="btn-group" data-toggle="buttons">
							<label class="btn btn-primary active"> 
								<input type="radio" name="userGender" autocomplete="off" value="101동" checked>101동
							</label>
							<label class="btn btn-primary active">
							 	<input type="radio" name="userGender" autocomplete="off" value="102동" checked>102동
							</label>
						</div>
					</div>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="호수" name="userEmail" maxlength="20">
					</div>
					<input type="submit" class="btn btn-primary form-control" value="회원가입">
				</form>
			</div>
		</div>
	</div>

	<!--  시도#1
	<script src="https://code.jquery.com/jqurey-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	-->
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<!-- 시도#3
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>﻿
	 -->
</body>
</html>