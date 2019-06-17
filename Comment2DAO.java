package comment2;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import bbs.Bbs;

public class Comment2DAO {
   private Connection conn;
   private ResultSet rs;

   public Comment2DAO() {
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
   
   public String getDate() {   //SQL �긽�쓽 �쁽�옱�떆媛꾩쓣 媛��졇�삤�뒗 硫붿냼�뱶
      String SQL ="SELECT NOW()";
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL); //conn 媛앹껜瑜� �씠�슜�빐 SQL �떎�뻾�븯湲곗쐞�븳 以�鍮꾪솚寃쎌쓣 留뚮뱾�뼱以��떎.
         rs = pstmt.executeQuery();   //洹� 寃곌낵媛믪� rs�뿉 ���옣.
         
         if(rs.next()) {   
            return rs.getString(1);   //�쁽�옱 �궇吏쒕�� 媛��졇�삩�떎
         }
      }catch(Exception e) {
         e.printStackTrace();
      }
      return "";
   }
   
   public int getNext() {   //寃뚯떆湲� 踰덊샇�뒗 primary key �씠硫� �븯�굹�뵫 利앷��빐�빞�븿.
      String SQL = "SELECT commentID FROM comment2 ORDER BY commentID DESC";   //comment �뀒�씠釉� �븞�쓽 commentID瑜�  �궡由쇱감�닚 �젙�젹�썑 留덉�留� 踰덊샇瑜� 媛��졇�삤怨� ==媛��옣 理쒖떊嫄� 媛��졇�삤怨�
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL);
         rs = pstmt.executeQuery();
         if (rs.next()) {
            return rs.getInt(1) + 1;      //媛��졇�삩 踰덊샇�쓽 +1 �븳 媛믪쓣 諛섑솚.
         }
         return 1; // �벐�뿬吏� �뙎湲��씠 �뾾�떎硫� == 吏�湲� �벐�뒗寃� 泥� �뙎湲��씠硫� 1�쓣 諛섑솚.
      } catch (Exception e) {
         e.printStackTrace();
      }
      return -1; //-1�� 寃뚯떆湲� �옉�꽦�떆�쓽 �삤瑜�
   }
   
   public int writeComment(int bbsID, String userID, String commentContent ) {
      String SQL = "INSERT INTO comment2 VALUES (?, ?, ?, ?, ?, ?)";
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL);   //�뿬湲곌퉴吏� 洹몃�濡�
         pstmt.setInt(1, bbsID);   //bbsID
         pstmt.setInt(2, getNext());   //commentID
         pstmt.setString(3, userID); 
         pstmt.setString(4, getDate());
         pstmt.setString(5, commentContent);
         pstmt.setInt(6, 1);
         return pstmt.executeUpdate();
      } catch (Exception e) {
         e.printStackTrace();
      }
      return -1;//
   }
   
   /*�뙎湲��쓣 遺덈윭�삤湲�*/
   
public ArrayList<Comment2> getList(int bbsID) {   //pageNumber ���떊 Bbsid瑜� 以��떎.
      String SQL = "SELECT * FROM COMMENT2 WHERE bbsID = ? AND commentAvailable";
      ArrayList<Comment2> list = new ArrayList<Comment2>();
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL);
         pstmt.setInt(1, bbsID);
         rs = pstmt.executeQuery();
         while (rs.next()) {
            Comment2 comment = new Comment2();
            comment.setBbsID(rs.getInt(1));
            comment.setCommentID(rs.getInt(2));
            comment.setUserID(rs.getString(3)); 
            comment.setCommentDate(rs.getString(4));
            comment.setCommentContent(rs.getString(5));
            comment.setCommentAvailable(rs.getInt(6));
            list.add(comment);
         }
      } catch (Exception e) {
         e.printStackTrace();
      }
      return list;
   }
   /*
   public boolean nextPage(int pageNumber) { //占쎈읂占쎌뵠筌욑옙 : 占쎌굙)野껊슣�뻻疫뀐옙占쎌뵠 15揶쏆뮆�늺 占쎈읂占쎌뵠筌욑옙占쎈뮉 2揶쏆뮄占� 占쎄국.
      String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
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
   
   */
   public Comment2 getComment(int bbsID) {
      String SQL = "SELECT * FROM comment2 WHERE bbsID = ?";
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL);
         pstmt.setInt(1, bbsID);
         rs = pstmt.executeQuery();
         if (rs.next()) {
            Comment2 comment = new Comment2();
            comment.setBbsID(rs.getInt(1));
            comment.setCommentID(rs.getInt(2));
            comment.setUserID(rs.getString(3));
            comment.setCommentDate(rs.getString(4));
            comment.setCommentContent(rs.getString(5));
            comment.setCommentAvailable(rs.getInt(6));
            return comment;
         }
      } catch (Exception e) {
         e.printStackTrace();
      }
      return null;
   }
   
   public int update(int commentID, String commentContent) { //疫뀐옙 占쎈땾占쎌젟
      String SQL = "UPDATE COMMENT2 SET commentContent = ? where commentID = ?";
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL);   //�뿬湲곌퉴吏� 洹몃�濡�
         pstmt.setString(1, commentContent );
         pstmt.setInt(2, commentID);   //commentID
         return pstmt.executeUpdate();
      } catch (Exception e) {
         e.printStackTrace();
      }
      return -1;//
   }
   
   
   public int delete(int commentID) {
      String SQL = "UPDATE COMMENT2 SET commentAvailable = 0 WHERE commentID = ?";
      try {
         PreparedStatement pstmt = conn.prepareStatement(SQL);
         pstmt.setInt(1, commentID);
         return pstmt.executeUpdate();
      } catch (Exception e) {
         e.printStackTrace();
      }
      return -1; // 占쎈쑓占쎌뵠占쎄숲甕곗쥙�뵠占쎈뮞 占쎌궎�몴占�
   }
}