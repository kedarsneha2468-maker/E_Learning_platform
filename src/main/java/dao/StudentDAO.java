package dao;

import database.DBConnection;
import model.Student;
import java.sql.*;
import org.mindrot.jbcrypt.BCrypt;

public class StudentDAO {

    // REGISTER STUDENT
    public boolean registerStudent(String name, String email, String password) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            String query = "INSERT INTO student(name, email, password) VALUES(?, ?, ?)";
            ps = con.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);

            int i = ps.executeUpdate();
            if (i > 0) status = true;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return status;
    }

    // LOGIN STUDENT - Returns Student object with details
    public Student loginStudent(String email, String password) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            
            String query = "SELECT student_id, name, email, password FROM student WHERE email = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                String storedHash = rs.getString("password");
                
                if (BCrypt.checkpw(password, storedHash)) {
                    Student student = new Student();
                    student.setStudentId(rs.getInt("student_id"));
                    student.setName(rs.getString("name"));
                    student.setEmail(rs.getString("email"));
                    return student;
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return null;
    }
    
    // GET STUDENT BY ID
    public Student getStudentById(int studentId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Student student = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT student_id, name, email FROM student WHERE student_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                student = new Student();
                student.setStudentId(rs.getInt("student_id"));
                student.setName(rs.getString("name"));
                student.setEmail(rs.getString("email"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return student;
    }
    
    // UPDATE STUDENT PROFILE
    public boolean updateStudentProfile(int studentId, String name, String email) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "UPDATE student SET name = ?, email = ? WHERE student_id = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setInt(3, studentId);
            
            int result = ps.executeUpdate();
            if (result > 0) status = true;
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return status;
    }
    
    // UPDATE STUDENT PASSWORD
    public boolean updateStudentPassword(int studentId, String newPassword) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            String query = "UPDATE student SET password = ? WHERE student_id = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, hashedPassword);
            ps.setInt(2, studentId);
            
            int result = ps.executeUpdate();
            if (result > 0) status = true;
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return status;
    }
    
    // CHECK IF EMAIL EXISTS
    public boolean isEmailExists(String email) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT student_id FROM student WHERE email = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();
            return rs.next();
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // GET TOTAL STUDENT COUNT (ADD THIS METHOD)
    public int getTotalStudentCount() {
        int count = 0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT COUNT(*) as total FROM student";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return count;
    }
}