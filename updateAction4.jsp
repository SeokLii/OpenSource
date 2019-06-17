<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs4.Bbs4"%>
<%@ page import="bbs4.Bbs4DAO"%>
<%@ page import="java.io.PrintWriter"%>
<%request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>경비In 웹 사이트</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID")!=null){
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		
		int bbsID = 0;
		if (request.getParameter("bbsID")!=null){
			bbsID =Integer.parseInt(request.getParameter("bbsID"));
		}
		if (bbsID == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href='bbs4.jsp'");
			script.println("</script>");
		}
		Bbs4 bbs = new Bbs4DAO().getBbs(bbsID);
		if(!userID.equals(bbs.getUserID())){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href='bbs4.jsp'");
			script.println("</script>");
		}
		
		else{
			if (request.getParameter("bbsTitle") == null || request.getParameter("bbsContent") == null ||
					request.getParameter("bbsTitle").equals(" ") || request.getParameter("bbsContent").equals(" ") ) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안 된 사항이 있습니다.')");
				script.println("history.back()"); //이전 페이지로
				script.println("</script>");
			} else {
				Bbs4DAO bbsDAO = new Bbs4DAO();
				int result = bbsDAO.update4(bbsID,request.getParameter("bbsTitle"),request.getParameter("bbsContent")); //DB에 등록
				if (result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글수정에 실패했습니다.')");
					script.println("history.back()"); //DB에 등록되지 않고, 전 페이지로 돌아감
					script.println("</script>");
				} else { 
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href = 'bbs4.jsp'");
					script.println("</script>");
				}
			}
		}
	%>
</body>
</html>