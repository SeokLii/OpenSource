/*�떎�젣 �쉶�썝�젙蹂� �꽔�뒗嫄�*/
package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public UserDAO() {
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
	
	public int login(String userID,String userPassword) {
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).contentEquals(userPassword)) {
					return 1; // 濡쒓렇�씤�꽦怨�
				}
				else
					return 0; // 鍮꾨쾲�씠 ��由�
			}
			return -1; // �븘�씠�뵒媛� �뾾�쓬
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -2; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}
	public int join(User user) {
		String SQL = "INSERT INTO USER VALUES(?,?,?,?,?,?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			pstmt.setString(6, "0");
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //�뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}
	public int VoteUpdate(String VoteBbsID, String userID) { //湲� �닔�젙
		String SQL = "UPDATE USER SET VoteBbsID = ? WHERE userID =?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, VoteBbsID);
			pstmt.setString(2, userID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �뜲�씠�꽣踰좎씠�뒪 �삤瑜�
	}
	public String VoteBbsID (String userID) {
		String SQL =  "SELECT VoteBbsID FROM USER WHERE userID =?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				User user = new User();
				user.setVoteBbsID(rs.getString(1));
				
				return user.getVoteBbsID();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
