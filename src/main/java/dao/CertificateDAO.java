package dao;

import database.DBConnection;
import model.Certificate;
import java.sql.*;
import java.text.SimpleDateFormat;

public class CertificateDAO {
    
    public Certificate getCertificateByStudentAndCourse(int studentId, int courseId) {
        Certificate certificate = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT * FROM certificate WHERE student_id = ? AND course_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                certificate = new Certificate();
                certificate.setCertificateId(rs.getInt("certificate_id"));
                certificate.setStudentId(rs.getInt("student_id"));
                certificate.setCourseId(rs.getInt("course_id"));
                certificate.setCertificateCode(rs.getString("certificate_code"));
                certificate.setIssueDate(rs.getTimestamp("issue_date"));
                certificate.setDownloadCount(rs.getInt("download_count"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return certificate;
    }
    
    public String getStudentName(int studentId) {
        String name = "Student";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT name FROM student WHERE student_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return name;
    }
    
    public String getCourseName(int courseId) {
        String name = "Course";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT course_name FROM course WHERE course_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, courseId);
            rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("course_name");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return name;
    }
    
    public boolean createCertificate(int studentId, int courseId, String certificateCode) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "INSERT INTO certificate(student_id, course_id, certificate_code, issue_date, download_count) VALUES(?, ?, ?, CURRENT_TIMESTAMP, 0)";
            ps = con.prepareStatement(query);
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ps.setString(3, certificateCode);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}