package dao;

import database.DBConnection;
import model.Instructor;
import model.Course;
import java.sql.*;
import java.util.*;
import org.mindrot.jbcrypt.BCrypt;

public class InstructorDAO {

    // REGISTER INSTRUCTOR
    public boolean registerInstructor(String name, String email, String password, String expertise, int experience) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            String query = "INSERT INTO instructor(name, email, password, expertise, experience) VALUES(?, ?, ?, ?, ?)";
            ps = con.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);
            ps.setString(4, expertise);
            ps.setInt(5, experience);

            int result = ps.executeUpdate();
            return result > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
    }

    // LOGIN INSTRUCTOR - Returns Instructor object
    public Instructor loginInstructor(String email, String password) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT instructor_id, name, email, password, expertise, experience FROM instructor WHERE email = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                String storedHash = rs.getString("password");
                if (BCrypt.checkpw(password, storedHash)) {
                    Instructor instructor = new Instructor();
                    instructor.setInstructorId(rs.getInt("instructor_id"));
                    instructor.setName(rs.getString("name"));
                    instructor.setEmail(rs.getString("email"));
                    instructor.setExpertise(rs.getString("expertise"));
                    instructor.setExperience(rs.getInt("experience"));
                    return instructor;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return null;
    }
    
    // GET INSTRUCTOR BY ID
    public Instructor getInstructorById(int instructorId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT instructor_id, name, email, expertise, experience FROM instructor WHERE instructor_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, instructorId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                Instructor instructor = new Instructor();
                instructor.setInstructorId(rs.getInt("instructor_id"));
                instructor.setName(rs.getString("name"));
                instructor.setEmail(rs.getString("email"));
                instructor.setExpertise(rs.getString("expertise"));
                instructor.setExperience(rs.getInt("experience"));
                return instructor;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return null;
    }
    
    // GET ALL INSTRUCTORS
    public List<Instructor> getAllInstructors() {
        List<Instructor> instructors = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT instructor_id, name, email, expertise, experience FROM instructor ORDER BY name";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Instructor instructor = new Instructor();
                instructor.setInstructorId(rs.getInt("instructor_id"));
                instructor.setName(rs.getString("name"));
                instructor.setEmail(rs.getString("email"));
                instructor.setExpertise(rs.getString("expertise"));
                instructor.setExperience(rs.getInt("experience"));
                instructors.add(instructor);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return instructors;
    }
    
    // GET COURSES BY INSTRUCTOR ID (The method you requested)
    public List<Course> getCoursesByInstructor(int instructorId) {
        List<Course> courses = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT * FROM course WHERE instructor_id = ? ORDER BY course_name";
            ps = con.prepareStatement(query);
            ps.setInt(1, instructorId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Course course = new Course();
                course.setCourseId(rs.getInt("course_id"));
                course.setCourseName(rs.getString("course_name"));
                course.setDescription(rs.getString("description"));
                course.setDuration(rs.getString("duration"));
                course.setCategory(rs.getString("category"));
                course.setInstructorId(rs.getInt("instructor_id"));
                courses.add(course);
            }
            
            System.out.println("Courses fetched for instructor " + instructorId + ": " + courses.size());
            
        } catch (Exception e) {
            System.out.println("Error in getCoursesByInstructor: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return courses;
    }
    
    // GET COURSE COUNT BY INSTRUCTOR
    public int getCourseCountByInstructor(int instructorId) {
        int count = 0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT COUNT(*) as total FROM course WHERE instructor_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, instructorId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return count;
    }
    
    // GET STUDENT COUNT BY INSTRUCTOR (students enrolled in instructor's courses)
    public int getStudentCountByInstructor(int instructorId) {
        int count = 0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT COUNT(DISTINCT e.student_id) as total " +
                          "FROM enrollment e " +
                          "INNER JOIN course c ON e.course_id = c.course_id " +
                          "WHERE c.instructor_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, instructorId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return count;
    }
    
    // UPDATE INSTRUCTOR PROFILE
    public boolean updateInstructorProfile(int instructorId, String name, String email, String expertise, int experience) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "UPDATE instructor SET name = ?, email = ?, expertise = ?, experience = ? WHERE instructor_id = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, expertise);
            ps.setInt(4, experience);
            ps.setInt(5, instructorId);
            
            int result = ps.executeUpdate();
            if (result > 0) status = true;
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return status;
    }
    
    // UPDATE INSTRUCTOR PASSWORD
    public boolean updateInstructorPassword(int instructorId, String newPassword) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            String query = "UPDATE instructor SET password = ? WHERE instructor_id = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, hashedPassword);
            ps.setInt(2, instructorId);
            
            int result = ps.executeUpdate();
            if (result > 0) status = true;
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return status;
    }
    
    // DELETE INSTRUCTOR (Admin only)
    public boolean deleteInstructor(int instructorId) {
        boolean status = false;
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            
            // First, update courses to set instructor_id = NULL or delete them
            String updateCourses = "UPDATE course SET instructor_id = NULL WHERE instructor_id = ?";
            ps = con.prepareStatement(updateCourses);
            ps.setInt(1, instructorId);
            ps.executeUpdate();
            ps.close();
            
            // Then delete the instructor
            String query = "DELETE FROM instructor WHERE instructor_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, instructorId);
            
            int result = ps.executeUpdate();
            if (result > 0) status = true;
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
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
            String query = "SELECT instructor_id FROM instructor WHERE email = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();
            return rs.next();
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}