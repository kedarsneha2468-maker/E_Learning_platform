package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import database.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

public class AdminDAO {

	 // ADMIN SIGNUP
    public boolean registerAdmin(String username, String password,String email){

        boolean status=false;

        try{

            Connection con = DBConnection.getConnection();

            // hash password
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            String query="INSERT INTO Admin(admin_username,admin_password,email) VALUES(?,?,?)";

            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1,username);
            ps.setString(2,hashedPassword);
            ps.setString(3, email);

            int i = ps.executeUpdate();

            if(i>0){
                status=true;
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return status;
    }

    public boolean loginAdmin(String username, String password) {

        boolean status = false;

        try {

            Connection con = DBConnection.getConnection();

            String query = "SELECT admin_password FROM Admin WHERE admin_username=?";

            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                String storedHash = rs.getString("admin_password");

                if (BCrypt.checkpw(password, storedHash)) {
                    status = true;
                }

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}