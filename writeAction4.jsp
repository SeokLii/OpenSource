<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs4.Bbs4DAO"%>
<%@ page import="java.io.PrintWriter"%>
<%	request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs4" class="bbs4.Bbs4" scope="page" />
<jsp:setProperty name="bbs4" property="bbsTitle" />
<jsp:setProperty name="bbs4" property="bbsContent" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>경비In 웹 사이트</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) { //수정(!= -> ==)
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		else {
			if (bbs4.getBbsTitle() == null || bbs4.getBbsContent() == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()"); //이전 페이지로
				script.println("</script>");
			} else {
				Bbs4DAO bbsDAO = new Bbs4DAO();
				int result = bbsDAO.write(bbs4.getBbsTitle(), userID, bbs4.getBbsContent()); //DB에 등록

				if (result == -1) { //DB오류
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글작성에 실패했습니다.')");
					script.println("history.back()"); //DB에 등록되지 않고, 전 페이지로 돌아감
					script.println("</script>");
				} else { //글 작성 성공
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'bbs4.jsp'"); //게시판 메인화면으로 이동
					script.println("</script>");
				}
			}
		}
	%>
</body>
</html>