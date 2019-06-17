package bbs4;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import bbs.Bbs;

public class Bbs4DAO {

	private Connection conn;
	private ResultSet rs;

	public Bbs4DAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS?serverTimezone=UTC";
			String dbID = "root";
			String dbPassword = "9866";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}

	public int getNext() {
		String SQL = "SELECT bbsID FROM BBS4 ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // 泥� 踰덉㎏ 寃뚯떆湲��씤 寃쎌슦
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}

	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "INSERT INTO BBS4 VALUES (?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 0);
			pstmt.setInt(7, 1);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}

	
/* Paging */
	public ArrayList<Bbs4> getList(int pageNumber){
		String SQL = "SELECT * FROM BBS4 WHERE bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10 OFFSET ?";
		ArrayList<Bbs4> list = new ArrayList<Bbs4>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, (pageNumber -1)*10);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Bbs4 bbs = new Bbs4();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsView(rs.getInt(6));
				bbs.setBbsAvailable(rs.getInt(7));
				list.add(bbs);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list; //�뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}
	
	public ArrayList<Bbs4> getAllList() { // �럹�씠吏� : �븳 �럹�씠吏� �떦 10媛쒖쓽 湲��쓣 蹂댁뿬以��떎.
		String SQL = "SELECT * FROM BBS4 WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC";
		ArrayList<Bbs4> listAll = new ArrayList<Bbs4>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Bbs4 bbs = new Bbs4();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsView(rs.getInt(6));
				bbs.setBbsAvailable(rs.getInt(7));
				listAll.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return listAll;
	}
	
	
	public boolean nextPage(int pageNumber) { //�럹�씠吏� : �삁)寃뚯떆湲��씠 15媛쒕㈃ �럹�씠吏��뒗 2媛쒓� �걹.
		String SQL = "SELECT * FROM BBS4 WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public Bbs4 getBbs(int bbsID) {
		String SQL = "SELECT * FROM BBS4 WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Bbs4 bbs = new Bbs4();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsView(rs.getInt(6));
				bbs.setBbsAvailable(rs.getInt(7));
				return bbs;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public int update4(int bbsID, String bbsTitle, String bbsContent) { //湲� �닔�젙
		String SQL = "UPDATE BBS4 SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}
	
	public int delete(int bbsID) {
		String SQL = "UPDATE BBS4 SET bbsAvailable = 0 WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}
	// 2019-05-30 議고쉶�닔 �깮�꽦_BEGIN_諛뺤큹�씗
	   public int view(int bbsView, int bbsID) { //湲� �닔�젙
	      String SQL = "UPDATE BBS4 SET bbsView = ? WHERE bbsID = ?";
	      try {
	         PreparedStatement pstmt = conn.prepareStatement(SQL);
	         pstmt.setInt(1, bbsView);
	         pstmt.setInt(2, bbsID);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	   }
	// 2019-05-30 議고쉶�닔 �깮�꽦_END_諛뺤큹�씗 
	   
	// 2019-06-08 [BEST] �씤湲곌�_BEGIN_諛뺤큹�씗
	      public int best(int bbsID, String bbsTitle) { //bbsTitle�뿉 [BEST] 異붽�
	         String SQL = "UPDATE BBS4 SET bbsTitle = ? WHERE bbsID = ?";
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
	// 2019-06-08 [BEST] �씤湲곌�_END_諛뺤큹�씗
}