<!-- 게시글의 내용을 볼 수 있는 페이지 -->
<%@ page import="comment3.Comment3DAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs3.Bbs3"%>
<%@ page import="bbs3.Bbs3DAO"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:useBean id="comment" class="comment.Comment" scope="page" />
<jsp:setProperty name="comment" property="commentContent" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">
<title>경비In 웹 사이트</title>
</head>
<body>
	<%
		String userID = null;
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
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) { //수정(!= -> ==)
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		} else {
			if (comment.getCommentContent() == null) { //댓글의 내용이 없다면
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()"); //이전 페이지로
				script.println("</script>");
			} else {
				Comment3DAO commentDAO = new Comment3DAO();
				// int bbsID, String userID, String commentContent
				//int result = commentDAO.writeComment(bbs.getBbsID(), userID, comment.getCommentContent());
				int result = commentDAO.writeComment(bbsID, userID, comment.getCommentContent());

				if (result == -1) { //DB오류
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('댓글 작성에 실패했습니다.')");
					script.println("history.back()"); //DB에 등록되지 않고, 전 페이지로 돌아감
					script.println("</script>");
				}else { //글 작성 성공
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'view3.jsp?bbsID="+bbsID+"'"); //게시판 메인화면으로 이동
					script.println("</script>");

				}
			}
		}
	%>
</body>
</html>