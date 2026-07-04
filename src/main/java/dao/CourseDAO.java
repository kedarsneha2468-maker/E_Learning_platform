package dao;

import database.DBConnection;
import model.Course;
import java.sql.*;
import java.util.*;

public class CourseDAO {
   
    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String query = "SELECT * FROM course ORDER BY course_id DESC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Course c = new Course();
                c.setCourseId(rs.getInt("course_id"));
                c.setCourseName(rs.getString("course_name"));
                c.setDescription(rs.getString("description"));
                c.setDuration(rs.getString("duration"));
                c.setCategory(rs.getString("category"));
                c.setInstructorId(rs.getInt("instructor_id"));
                list.add(c);
            }
            
            System.out.println("CourseDAO - Courses fetched: " + list.size());

        } catch (Exception e) {
            System.out.println("ERROR in getAllCourses: " + e.getMessage());
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
        return list;
    }
    
    // Get all courses with instructor names
    public List<Course> getAllCoursesWithInstructor() {
        List<Course> list = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String query = "SELECT c.*, i.name as instructor_name FROM course c " +
                          "LEFT JOIN instructor i ON c.instructor_id = i.instructor_id " +
                          "ORDER BY c.course_id DESC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Course c = new Course();
                c.setCourseId(rs.getInt("course_id"));
                c.setCourseName(rs.getString("course_name"));
                c.setDescription(rs.getString("description"));
                c.setDuration(rs.getString("duration"));
                c.setCategory(rs.getString("category"));
                c.setInstructorId(rs.getInt("instructor_id"));
                list.add(c);
            }
            
            System.out.println("CourseDAO - Courses with instructors fetched: " + list.size());

        } catch (Exception e) {
            System.out.println("ERROR in getAllCoursesWithInstructor: " + e.getMessage());
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
        return list;
    }
    
    public Course getCourseById(int courseId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT * FROM course WHERE course_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, courseId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                Course course = new Course();
                course.setCourseId(rs.getInt("course_id"));
                course.setCourseName(rs.getString("course_name"));
                course.setDescription(rs.getString("description"));
                course.setDuration(rs.getString("duration"));
                course.setCategory(rs.getString("category"));
                course.setInstructorId(rs.getInt("instructor_id"));
                return course;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return null;
    }
    
    public int getCourseCount() {
        int count = 0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT COUNT(*) as total FROM course";
            ps = con.prepareStatement(query);
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
    
    public int getTotalEnrollments() {
        int count = 0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT COUNT(*) as total FROM enrollment";
            ps = con.prepareStatement(query);
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
    
    public boolean addCourse(Course course) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "INSERT INTO course(course_name, description, duration, category, instructor_id) VALUES(?, ?, ?, ?, ?)";
            ps = con.prepareStatement(query);
            ps.setString(1, course.getCourseName());
            ps.setString(2, course.getDescription());
            ps.setString(3, course.getDuration());
            ps.setString(4, course.getCategory());
            ps.setInt(5, course.getInstructorId());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}