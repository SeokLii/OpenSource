package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	private Connection conn;
	private ResultSet rs;
	
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS?useUnicode=true&characterEncoding=UTF-8";
			String dbID = "root";
			String dbPassword = "9866";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL,dbID,dbPassword);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return ""; //�뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}
	public int getNext() {
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1)+1;
			}
			return 1; //泥ル쾲吏� 寃뚯떆臾쇱씤 寃쎌슦
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //�뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}
	public int write(String bbsTitle, String userID, String bbsContent, String bbsDeadline, int bbsYES, int bbsNO, int bbsVOTE) {
		String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			if(bbsVOTE==0) {
				pstmt.setString(2, bbsTitle);
			}
			else {
				pstmt.setString(2, "[투표] "+bbsTitle);
			}
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setString(6, bbsDeadline); 
			//----------------------------------------------------------------------------DB추가 + view 값
			pstmt.setInt(7, bbsYES);
			pstmt.setInt(8, bbsNO);
			pstmt.setInt(9, 1);
			pstmt.setInt(10, bbsVOTE);
			pstmt.setInt(11, 0);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB오류
	}
	
	public ArrayList<Bbs> getList(int pageNumber){
		String SQL = "SELECT * FROM BBS WHERE bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10 OFFSET ?";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, (pageNumber -1)*10);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsDeadline(rs.getString(6));
				bbs.setBbsYES(rs.getInt(7));
				bbs.setBbsNO(rs.getInt(8));
				bbs.setBbsAvailable(rs.getInt(9));
				bbs.setBbsVOTE(rs.getInt(10));
				bbs.setBbsView(rs.getInt(11));
				//------------------------------------------------- DB추가안해줘서 View를 넣으면 안나옴
				list.add(bbs);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list; //�뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}
	
	public ArrayList<Bbs> getAllList() { // �럹�씠吏� : �븳 �럹�씠吏� �떦 10媛쒖쓽 湲��쓣 蹂댁뿬以��떎.
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC";
		ArrayList<Bbs> listAll = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsDeadline(rs.getString(6));
				bbs.setBbsYES(rs.getInt(7));
				bbs.setBbsNO(rs.getInt(8));
				bbs.setBbsAvailable(rs.getInt(9));
				bbs.setBbsVOTE(rs.getInt(10));
				bbs.setBbsView(rs.getInt(11));
				listAll.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return listAll;
	}
	
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber -1)*10);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return false; //�뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}
	
	public Bbs getBbs(int bbsID) {
		String SQL = "SELECT * FROM BBS WHERE bbsID =?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsDeadline(rs.getString(6));
				bbs.setBbsYES(rs.getInt(7));
				bbs.setBbsNO(rs.getInt(8));
				bbs.setBbsAvailable(rs.getInt(9));
				bbs.setBbsVOTE(rs.getInt(10));
				bbs.setBbsView(rs.getInt(11));
				return bbs;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null; 
	}
	
	public int update(int bbsID, String bbsTitle, String bbsContent) {
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?"; //20190615 일반 글 update함수 수정
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	public int delete(int bbsID) {
		String SQL = "UPDATE BBS SET bbsAvailable = 0, bbsView=0 WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	// 2019-05-30 조회수 생성_BEGIN_박초희
	   public int view(int bbsView, int bbsID) { //글 수정
	      String SQL = "UPDATE BBS SET bbsView = ? WHERE bbsID = ?";
	      try {
	         PreparedStatement pstmt = conn.prepareStatement(SQL);
	         pstmt.setInt(1, bbsView);
	         pstmt.setInt(2, bbsID);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1; // 데이터베이스 오류
	   }
	// 2019-05-30 조회수 생성_END_박초희 
		
	// 2019-06-08 [BEST] 인기글_BEGIN_박초희
	      public int best(int bbsID, String bbsTitle) { //bbsTitle에 [BEST] 추가
	         String SQL = "UPDATE BBS SET bbsTitle = ? WHERE bbsID = ?";
	         try {
	            PreparedStatement pstmt = conn.prepareStatement(SQL);
	            pstmt.setString(1, bbsTitle);
	            pstmt.setInt(2, bbsID);
	            return pstmt.executeUpdate();
	         } catch (Exception e) {
	            e.printStackTrace();
	         }
	         return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	      }
	      // 2019-06-08 [BEST] 인기글_END_박초희
	  	public int YesNoUpdate(int bbsYES, int bbsNO, int bbsID) { //湲� �닔�젙
			String SQL = "UPDATE BBS SET bbsYES = ?, bbsNO= ? WHERE bbsID = ?";
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, bbsYES);
				pstmt.setInt(2, bbsNO);
				pstmt.setInt(3, bbsID);
				return pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			}
			return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
		}
		
		public int getBbsYES(int bbsID) {
			String SQL = "SELECT bbsYES FROM BBS WHERE bbsID = ?";
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, bbsID);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					Bbs bbs = new Bbs();
					bbs.setBbsYES(rs.getInt(1));
					return bbs.getBbsYES();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			return -1;
		}
		public int getBbsNO(int bbsID) {
			String SQL = "SELECT bbsNO FROM BBS WHERE bbsID = ?";
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, bbsID);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					Bbs bbs = new Bbs();
					bbs.setBbsNO(rs.getInt(1));
					return bbs.getBbsNO();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			return -1;
		}
		public String getUSERID(int bbsID) {
			String SQL = "SELECT userID FROM BBS WHERE bbsID = ?";
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, bbsID);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					Bbs bbs = new Bbs();
					bbs.setUserID(rs.getString(1));
					return bbs.getUserID();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			return null;
		}
}
