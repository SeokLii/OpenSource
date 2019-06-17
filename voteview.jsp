<!-- 게시글의 내용을 볼 수 있는 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="user.User"%>
<%@ page import="user.UserDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" , initial-scale="1.0">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<script src="http://d3js.org/d3.v3.min.js"></script>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="css/style.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

<script src="js/bootstrap.min.js"></script>


<title>경비In</title>
<!-- 20190614 이름 수정 -->
<style>
rect:hover {
	fill: #5897ED;
}

svg {
	font-family: Malgun Gothic;
}

#targetSVG {text-align = center;
	
}
</style>
</head>
<body>

	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID"); //로그인시, userID에 해당 아이디가 입력됨.
		}

		int bbsID = 0;
		if (request.getParameter("bbsID") != null) { //특정한 번호가 존재해야 글을 볼 수 있음.
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if (bbsID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		BbsDAO bbsDAO = new BbsDAO();
		Bbs bbs = new BbsDAO().getBbs(bbsID);
		int bbsView = bbs.getBbsView();
		int result = 0;
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
					<li><a href="#band">경비In 소개</a></li>
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
							bbsView++; //조회수 증가
					%>
					<li class="dropdown"><a class="dropdown-toggle"
						data-toggle="dropdown" href="#">회원관리 <span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="logoutAction.jsp">로그아웃</a></li>
						</ul></li>
					<%
						result = bbsDAO.view(bbsView, bbsID); //조회수 증가
						}
					%>
				</ul>
			</div>
		</div>
	</nav>

	<div class="container">
		<div class="row">
			<table class="table table-striped"
				style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="3"
							style="background-color: #eeeeee; text-align: center">투표</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%;">글 제목</td>
						<td colspan="2"><%=bbs.getBbsTitle().replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt")
					.replaceAll("\n", "<br>")%></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%=bbs.getUserID()%></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="2"><%=bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시"
					+ bbs.getBbsDate().substring(14, 16) + "분"%></td>
					</tr>
					<tr width=90%>
						<td>마감 기한</td>
						<td><%=bbs.getBbsDeadline()%></td>
					</tr>
					<tr>
						<td>조회수</td>
						<td colspan="2"><%=bbsView%></td>
					</tr>
					<tr>
						<td>내용</td>
						<!-- 특수문자 처리 -->
						<td colspan="2" style="min-height: 200px; text-align: left;"><%=bbs.getBbsContent().replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt")
					.replaceAll("\n", "<br>")%></td>
					</tr>
					<tr>
						<td colspan="2" id="targetSVG"></td>
					</tr>
					<%
						String VoteBbsID = null;

						//BbsDAO bbsDAO = new BbsDAO();
						UserDAO usedrdao = new UserDAO();
						VoteBbsID = usedrdao.VoteBbsID(userID);
						System.out.print("투표한 게시판 번호 : "+VoteBbsID);

						if(userID == null)
						{
							PrintWriter script = response.getWriter();
							script.println("<script>");
							script.println("alert('로그인이후 열람 가능합니다.')");
							script.println("location.href = 'bbs.jsp'");
							script.println("</script>");
						}
						else if (VoteBbsID.indexOf(Integer.toString(bbsID)) != -1) {
					%>
					<tr>
						<td colspan="2">
							<div class="custom-control custom-radio">
								<input type="radio" name="bbsYES" class="custom-control-input"
									value="1"> <label class="custom-control-label"
									for="jb-radio-1">찬성</label> <input type="radio" name="bbsNO"
									class="custom-control-input" value="1"> <label
									class="custom-control-label" for="jb-radio-1">반대</label>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="2"><input type="submit" class="btn btn-primary"
							value="선택"></td>
					</tr>
					<%
						} else {
					%>
					<form method="post" action="voteviewAction.jsp?bbsID=<%=bbsID%>">
						<tr>
							<td colspan="2">
								<div class="custom-control custom-radio">
									<input type="radio" name="bbsYES" class="custom-control-input"
										value="1"> <label class="custom-control-label"
										for="jb-radio-1">찬성</label> <input type="radio" name="bbsNO"
										class="custom-control-input" value="1"> <label
										class="custom-control-label" for="jb-radio-1">반대</label>
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="2"><input type="submit"
								class="btn btn-primary" value="선택"></td>
						</tr>
					</form>
					<%
						}
					%>
				</tbody>
			</table>
			<a href="bbs.jsp" class="btn btn-primary">목록</a>
			<%
				if (userID != null && userID.equals(bbs.getUserID())) { //작성자가 본인이라면 _19/5/25
			%>
			<!-- <a href="voteupdate.jsp?bbsID=<%=bbsID%>" class="btn btn-primary">수정</a> -->
			<!-- 매개변수로서 본인의 아이디를 가져감. _19/5/25-->
			<a onclick="return confirm('정말로 삭제하시겠습니까?')"
				href="deleteAction.jsp?bbsID=<%=bbsID%>" class="btn btn-primary">삭제</a>
			<%
				}
			%>
		</div>
	</div>

	<script>
		var data = [];
		data[0] =
	<%=bbs.getBbsYES()%>
		;
		data[1] =
	<%=bbs.getBbsNO()%>
		;
		function DRAW() {
			var svg = d3.select("#targetSVG").append("svg").attr("width", 600)
					.attr("height", 200);

			var x = d3.scale.linear().domain([ 0, 172 ]).range([ 10, 1000 ]);

			var rect = svg.selectAll("rect").data(data).enter().append("rect")
					.attr("x", 10).attr("y", function(d, i) {
						return i * (50 + 1)
					}).attr("width", function(d) {
						return x(d)
					}).attr("height", 50).attr("fill", function(d, i) {

						console.log(data);
						if (data[0] == data[1])
							return "#2E93E6";
						else if (data[i] == data[0])
							return "#ed5565";
						else
							return "#add8e6";
					});
			var xAxis = d3.svg.axis().scale(x).orient("bottom").ticks(5)
					.outerTickSize(0).tickPadding(-5);

			svg.append("g").attr("class", "x axis").attr("transform",
					"translate(0,130)").call(xAxis);

			var label = svg.selectAll(".label").data(data).enter().append(
					"text").attr("x", function(d, i) {
				return x(d)
			}).attr("y", function(d, i) {
				return i * (50 + 1) + 30
			}).attr("text-anchor", "end").text(function(d) {
				return d
			}).style("fill", "white");

		}
		function YES() {
			data[0] = data[0] + 1;
			console.log(data[0]);

		}
		function NO() {
			data[1] = data[1] + 1;
		}
		DRAW();
	</script>
</body>


</html>
