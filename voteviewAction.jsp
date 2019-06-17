<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter"%>
<%	request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:useBean id="user" class="user.User" scope="page"/>
<jsp:setProperty name="bbs" property="bbsYES" />
<jsp:setProperty name="bbs" property="bbsNO" />

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>경비In 웹 사이트</title>
</head>
<body>
	<%
		BbsDAO bbsDAO = new BbsDAO();
		UserDAO userdao = new UserDAO();
		int bbsID = 0; //글의 번호가 들어오지 않았다면
		int YES_check = 0; 
		int NO_check = 0;
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		
		if (request.getParameter("bbsID") != null) { //특정한 번호가 존재해야 글을 볼 수 있음.
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if (request.getParameter("bbsYES") != null) {
			YES_check = Integer.parseInt(request.getParameter("bbsYES"));
		}
		if (request.getParameter("bbsNO") != null) {
			NO_check = Integer.parseInt(request.getParameter("bbsNO"));
		}
		
		int YES = bbsDAO.getBbsYES(bbsID);
		int NO = bbsDAO.getBbsNO(bbsID);
		
		if(YES_check == 1)
		{
			YES = YES + 1;
		}
		else if(NO_check == 1)
		{
			NO = NO +1;
		}
		String VoteBbsID = null;
		VoteBbsID = userdao.VoteBbsID(userID); //user DB의 지금까지 투표한 게시글 현황 알려주는 변수
		
		System.out.println(bbsDAO.getUSERID(bbsID));
		
		if(VoteBbsID == null)
		{
			VoteBbsID = Integer.toString(bbsID);
		}
		else{
			VoteBbsID = VoteBbsID + "," +Integer.toString(bbsID);
		}
		
		System.out.println(VoteBbsID);
		userdao.VoteUpdate(VoteBbsID, userID); //user의 voteBbsID를 저장해준다
		
		
		if (userID == null) { //수정(!= -> ==)
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		else {
				int result = bbsDAO.YesNoUpdate(YES,NO,bbsID); //DB에 등록

				if (result == -1) { //DB오류
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글작성에 실패했습니다.')");
					script.println("history.back()"); //DB에 등록되지 않고, 전 페이지로 돌아감
					script.println("</script>");
				} else { //글 작성 성공
					PrintWriter script = response.getWriter();
		%>
					<script>
						var BBSID = <%=bbsID%>;
						location.href = "voteview.jsp?bbsID=" + BBSID
					</script>
		<%
				}
		}
	
		%>
			
</body>
</html>