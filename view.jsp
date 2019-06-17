<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "bbs.Bbs" %>
<%@ page import = "bbs.BbsDAO" %>
<%@ page import="comment.Comment"%>
<%@ page import="comment.CommentDAO"%>
<%@ page import="java.util.ArrayList"%>
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

<title>경비In 웹 사이트</title> <!-- 20190614 이름 수정 -->
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID")!= null){
			userID = (String) session.getAttribute("userID");
		}
		int bbsID = 0;
		if (request.getParameter("bbsID")!=null){
			bbsID =Integer.parseInt(request.getParameter("bbsID"));
		}
		
		int modNum = 0;
	      if (request.getParameter("modNum") != null) { //특정한 번호가 존재해야 글을 볼 수 있음.
	         modNum = Integer.parseInt(request.getParameter("modNum"));
	      }
	      
	      
		if (bbsID == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href='bbs.jsp'");
			script.println("</script>");
		}
		BbsDAO bbsDAO = new BbsDAO();
		Bbs bbs = new BbsDAO().getBbs(bbsID);
		int bbsView = bbs.getBbsView();
		int result=0;
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
        <%
				if(userID == null){
			%>
		<li class="dropdown">
          <a class="dropdown-toggle" data-toggle="dropdown" href="#">회원관리
          <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="login.jsp">로그인</a></li>
            <li><a href="join.jsp">회원가입</a></li>
          </ul>
        </li>
			<%
				}else{
					bbsView++; //조회수 증가
			%>
		<li class="dropdown">
          <a class="dropdown-toggle" data-toggle="dropdown" href="#">회원관리
          <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="logoutAction.jsp">로그아웃</a></li> 
          </ul>
        </li>
			<%
			result = bbsDAO.view(bbsView, bbsID);
				}
			%>
		</ul>
    </div>
  </div>
</nav>
	
	<div class ="container">
		<div class="row">
			<table class="table table-striped" style = "text-align : center; border : 1px solid #dddddd">
			<thead>
				<tr>
					<th colspan="3" style="background-color : #eeeeee; text-align : center;">게시판 글 보기</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style = "width : 20%;">글 제목</td>
					<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>")  %></td>
				</tr>
				<tr>
					<td>작성자</td>
					<td colspan="2"><%= bbs.getUserID()  %></td>
				</tr>
				<tr>
					<td>작성일자</td>
					<td colspan="2"><%= bbs.getBbsDate().substring(0,11) + bbs.getBbsDate().substring(11, 13) + "시" + bbs.getBbsDate().substring(14, 16) +  "분"  %></td>
				</tr>
				<tr>
					<td>조회수</td>
					<td colspan="2"><%=bbsView%></td>
				</tr>
				<tr>
					<td>내용</td>
					<td colspan="2" style = "min-height : 200px; text-align : left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>") %></td>
				</tr>
			</tbody>
			</table>
			<a href="bbs.jsp" class="btn btn-primary">목록</a>
			<%
				if(userID != null && userID.equals(bbs.getUserID())) {
			%>
					<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a>
					<a onclick ="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a>
			<%
				}
			%>	
			
	                 <!-- -------------------------------------- 댓글이 보이는 부분 ----------------------------------------- -->
         <br> <br> <br> <br>  <br>  
         <table class="table table-default">
            <%
                  CommentDAO commentDAO = new CommentDAO();
                  ArrayList<Comment> list = commentDAO.getList(bbsID);
                  for (int i = 0; i < list.size(); i++) {
               %>
            <tr>
               <!-- --첫번째 td-- -->
               <td style="width: 10%;"><%=list.get(i).getUserID()%></td>
               
               
               <!-- -----------------------------------수정 모드였을때-------------------------------- -->
               <% if((modNum==list.get(i).getCommentID())&&(userID.equals(list.get(i).getUserID())))   //수정모드+작성자가 본인일때
               {
               %>
            <!-- --두번째 td-- -->
               <td>
                  <div> <!-- 작성일 -->
                     <%=list.get(i).getCommentDate().substring(0, 11) + list.get(i).getCommentDate().substring(11, 13) + "시"
                  + list.get(i).getCommentDate().substring(14, 16) + "분"%>
                  </div>
                  <form method="post" action="updateComment.jsp?bbsID=<%=bbsID%>&modNum=<%=list.get(i).getCommentID()%>">
                  <div>
                     <!-- 내용부분 -->
                     <textarea id="<%=list.get(i).getCommentID()%>" class="form-control" style="width:90%;hright:100px;" name="commentContent" maxlength="2048"><%=list.get(i).getCommentContent()%></textarea>
                  </div>

            </td>
               <!-- --세번째 td-- -->
               <td style="width: 10%">
                  <div>
                     <input type="submit" class="btn btn-default pull-right" style="width: 50%; height: 50%; text-align: center;" value="등록"></input>
                  </div>
               </td>
               </form>
               <!-- ------------------------------------수정모드일때 끝 ------------------------------ -->
               
               
               <!----------------------------------- 수정 모드가 아닐때----------------------------------- -->
               <%
                     }
                     else
                     {
                     %>
                     <!-- --두번째 td-- -->
               <td>
                  <div>
                     <%=list.get(i).getCommentDate().substring(0, 11) + list.get(i).getCommentDate().substring(11, 13) + "시"
                  + list.get(i).getCommentDate().substring(14, 16) + "분"%>
                  </div>

                  <div id="<%=list.get(i).getCommentID()%>">
                     <%=list.get(i).getCommentContent().replaceAll(" ", "&nbsp").replaceAll("<", "&lt").replaceAll(">", "&gt")
               .replaceAll("\n", "<br>")%>
                  </div>
               </td>
               
               <!-- --세번째 td-- -->
               <%
                  if (userID != null && userID.equals(list.get(i).getUserID())) { //작성자가 본인이라면 _19/5/25
               %>
               <td style="width: 10%">

                  <div>
                     <a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteCommentAction.jsp?commentID=<%=list.get(i).getCommentID() %>&bbsID=<%=bbsID %>" class="btn btn-default">삭제</a>
                  </div>

                  <div>
                     <a href="view.jsp?bbsID=<%=bbsID %>&modNum=<%=list.get(i).getCommentID()%>#<%=list.get(i).getCommentID()%>" class="btn btn-default">수정</a>
                  </div>
               </td>
               <%
                     }
               %>
                  <%
                  }   
                  %>
               
                  <!------------------------------ 수정모드가 아닐때 끝 ------------------------------>
               <%
                  }   //for문의 끝
               %>

            </tr>
         </table>
         <!-- -------------------------------------- 댓글이 보이는 부분 끝 ----------------------------------------- -->

         <!-- -------------------------------------- 댓글을 쓰는부분 ----------------------------------------- -->
         <form method="post" action="writeCommentAction.jsp?bbsID=<%=bbsID%>">
            <table class="table table-default">
               <tr>
                  <td style="width: 90%"><textarea class="form-control"
                        placeholder="댓글 내용" name="commentContent" maxlength="2048"
                        style="height: 100px;"></textarea></td>
                  <td><input type="submit" class="btn btn-default pull-right"
                     style="width: 100%; height: 100px; text-align: center;"
                     value="등록"></input></td>
               </tr>
            </table>
         </form>
         <!-- -------------------------------------- 댓글을 쓰는부분 끝 ---------------------------------------- -->
		</div>
	</div>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="js/bootstrap.min.js"></script> 
</body>
</html>