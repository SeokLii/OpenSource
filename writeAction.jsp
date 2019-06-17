<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%	request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />
<jsp:setProperty name="bbs" property="bbsVOTE" />
<jsp:setProperty name="bbs" property="bbsDeadline" />


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
			if(bbs.getBbsVOTE() == 1 && bbs.getBbsDeadline() == null){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()"); //이전 페이지로
				script.println("</script>");
			}
			else if (bbs.getBbsTitle() == null || bbs.getBbsContent() == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()"); //이전 페이지로
				script.println("</script>");
			} else {
				BbsDAO bbsDAO = new BbsDAO();
				int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent(), bbs.getBbsDeadline(), bbs.getBbsYES(), bbs.getBbsNO(), bbs.getBbsVOTE()); //DB에 등록
				System.out.print(bbs.getBbsVOTE());
				if (result == -1) { //DB오류
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글작성에 실패했습니다.')");
					script.println("history.back()"); //DB에 등록되지 않고, 전 페이지로 돌아감
					script.println("</script>");
				} else { //글 작성 성공
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'bbs.jsp'"); //게시판 메인화면으로 이동
					script.println("</script>");
				}
			}
		}
	%>
</body>
</html>