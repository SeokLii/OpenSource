<!-- 게시글의 내용을 볼 수 있는 페이지 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BbsDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">
<script src="http://d3js.org/d3.v3.min.js"></script>
<script src="http://labratrevenge.com/d3-tip/javascripts/d3.tip.v0.6.3.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<title>JSP 게시판 웹 사이트</title>
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
		Bbs bbs = new BbsDAO().getBbs(bbsID);
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<div class="collapse navbar-collapse"
			id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
				<!-- active : 현재의 페이지를 알려줌 -->
			</ul>
			<%
				if (userID == null) { //로그인이 되어있지 않다면
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul></li>
			</ul>
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul></li>
			</ul>
			<%
				}
			%>

		</div>
	</nav>

	<div class="container">
		<div class="row">
			<table class="table table-striped"
				style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="3"
							style="background-color: #eeeeee; text-align: center">투표하기</th>
					</tr>
				</thead>
				<tbody>
					<tr width=90%>
						<td>내용</td>
						<!-- 특수문자 처리 -->
						<td>단지 내 주차공간 확보를 위한 지하주차장 설립</td>
					</tr>
					<tr width=90%>
						<td>마감 기한</td>
						<!-- 특수문자 처리 -->
						<td><%=bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시"
					+ bbs.getBbsDate().substring(14, 16) + "분"%></td>
					</tr>
					<tr>
						<td colspan="2" id="targetSVG"></td>
					</tr>
					<tr>
						<td colspan="2">
							<div class="btn-group" role="group" aria-label="Basic example">
								<button type="button" id="YES" class="btn btn-secondary" onclick="YES()" style="background: #ed5565; width:300px">찬성</button>
                       		    <button type="button" id="NO" class="btn btn-secondary" onclick="NO()" style="background: #add8e6; width:300px">반대</button>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<a href="bbs.jsp" class="btn btn-primary">목록</a>
			<%
				if (userID != null && userID.equals(bbs.getUserID())) { //작성자가 본인이라면 _19/5/25
			%>
			<a href="update.jsp?bbsID=<%=bbsID%>" class="btn btn-primary">수정</a>
			<!-- 매개변수로서 본인의 아이디를 가져감. _19/5/25-->
			<a onclick="return confirm('정말로 삭제하시겠습니까?')"
				href="deleteAction.jsp?bbsID=<%=bbsID%>" class="btn btn-primary">삭제</a>
			<%
				}
			%>
			<input type="submit" class="btn btn-primary pull-right" value="수정하기">
		</div>
	</div>

	<script>
	  var data = [];
	    data[0] = 0;
	    data[1] = 0;
	    function DRAW() {
	        var svg = d3.select("#targetSVG").append("svg").attr("width", 600)
	            .attr("height", 200);

	        var x = d3.scale.linear().domain([0, 172]).range([10, 1000]);

	        var rect = svg.selectAll("rect").data(data).enter().append("rect")
	            .attr("x", 10).attr("y", function (d, i) {
	                return i * (50 + 1)
	            }).attr("width", function (d) {
	                return x(d)
	            }).attr("height", 50).attr("fill", function (d, i) {

	                console.log(data);
	                if(data[0] == data[1])
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

	        var label = svg.selectAll(".label").data(data).enter().append("text")
	            .attr("x", function (d, i) {
	                return x(d)
	            }).attr("y", function (d, i) {
	                return i * (50 + 1) + 30
	            }).attr("text-anchor", "end").text(function (d) {
	                return d
	            }).style("fill", "white");

	    }
	    function YES(){
	        data[0] = data[0] + 1;
	        console.log(data[0]);
	    }
	    function NO(){
	        data[1] = data[1] + 1;
	    }
	    DRAW();
	    $("#YES").on( "click", function (d) {
	        d3.select("#targetSVG").select("svg").remove();
	        DRAW();
	    });
	    $("#NO").on( "click", function (d) {
	        d3.select("#targetSVG").select("svg").remove();
	        DRAW();
	    });
	</script>
</body>
</html>