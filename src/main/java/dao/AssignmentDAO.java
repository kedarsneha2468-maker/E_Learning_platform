package dao;

import database.DBConnection;
import model.Assignment;
import model.Submission;
import java.sql.*;
import java.util.*;

public class AssignmentDAO {
    
    // CREATE ASSIGNMENT (Instructor)
    public boolean createAssignment(Assignment assignment) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "INSERT INTO assignment(course_id, instructor_id, title, description, total_marks, due_date) VALUES(?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(query);
            ps.setInt(1, assignment.getCourseId());
            ps.setInt(2, assignment.getInstructorId());
            ps.setString(3, assignment.getTitle());
            ps.setString(4, assignment.getDescription());
            ps.setInt(5, assignment.getTotalMarks());
            ps.setDate(6, assignment.getDueDate() != null ? new java.sql.Date(assignment.getDueDate().getTime()) : null);
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
    
    // GET ASSIGNMENTS BY COURSE ID (Instructor view)
    public List<Assignment> getAssignmentsByCourse(int courseId) {
        List<Assignment> assignments = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT a.*, c.course_name FROM assignment a " +
                          "JOIN course c ON a.course_id = c.course_id " +
                          "WHERE a.course_id = ? ORDER BY a.created_at DESC";
            ps = con.prepareStatement(query);
            ps.setInt(1, courseId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Assignment assignment = new Assignment();
                assignment.setAssignmentId(rs.getInt("assignment_id"));
                assignment.setCourseId(rs.getInt("course_id"));
                assignment.setInstructorId(rs.getInt("instructor_id"));
                assignment.setTitle(rs.getString("title"));
                assignment.setDescription(rs.getString("description"));
                assignment.setTotalMarks(rs.getInt("total_marks"));
                assignment.setDueDate(rs.getDate("due_date"));
                assignment.setCreatedAt(rs.getTimestamp("created_at"));
                assignment.setCourseName(rs.getString("course_name"));
                assignments.add(assignment);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return assignments;
    }
    
    // GET ASSIGNMENTS BY INSTRUCTOR ID
    public List<Assignment> getAssignmentsByInstructor(int instructorId) {
        List<Assignment> assignments = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT a.*, c.course_name FROM assignment a " +
                          "JOIN course c ON a.course_id = c.course_id " +
                          "WHERE a.instructor_id = ? ORDER BY a.created_at DESC";
            ps = con.prepareStatement(query);
            ps.setInt(1, instructorId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Assignment assignment = new Assignment();
                assignment.setAssignmentId(rs.getInt("assignment_id"));
                assignment.setCourseId(rs.getInt("course_id"));
                assignment.setInstructorId(rs.getInt("instructor_id"));
                assignment.setTitle(rs.getString("title"));
                assignment.setDescription(rs.getString("description"));
                assignment.setTotalMarks(rs.getInt("total_marks"));
                assignment.setDueDate(rs.getDate("due_date"));
                assignment.setCreatedAt(rs.getTimestamp("created_at"));
                assignment.setCourseName(rs.getString("course_name"));
                assignments.add(assignment);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return assignments;
    }
    
    // GET ASSIGNMENTS FOR STUDENT (by course - only enrolled courses)
    public List<Assignment> getAssignmentsForStudent(int studentId, int courseId) {
        List<Assignment> assignments = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT a.*, c.course_name, " +
                          "(SELECT s.submission_id FROM submission s WHERE s.assignment_id = a.assignment_id AND s.student_id = ?) as has_submitted " +
                          "FROM assignment a " +
                          "JOIN course c ON a.course_id = c.course_id " +
                          "WHERE a.course_id = ? ORDER BY a.due_date ASC";
            ps = con.prepareStatement(query);
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Assignment assignment = new Assignment();
                assignment.setAssignmentId(rs.getInt("assignment_id"));
                assignment.setCourseId(rs.getInt("course_id"));
                assignment.setInstructorId(rs.getInt("instructor_id"));
                assignment.setTitle(rs.getString("title"));
                assignment.setDescription(rs.getString("description"));
                assignment.setTotalMarks(rs.getInt("total_marks"));
                assignment.setDueDate(rs.getDate("due_date"));
                assignment.setCreatedAt(rs.getTimestamp("created_at"));
                assignment.setCourseName(rs.getString("course_name"));
                assignments.add(assignment);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return assignments;
    }
    
    // GET ASSIGNMENT BY ID
    public Assignment getAssignmentById(int assignmentId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT a.*, c.course_name, i.name as instructor_name FROM assignment a " +
                          "JOIN course c ON a.course_id = c.course_id " +
                          "JOIN instructor i ON a.instructor_id = i.instructor_id " +
                          "WHERE a.assignment_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, assignmentId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                Assignment assignment = new Assignment();
                assignment.setAssignmentId(rs.getInt("assignment_id"));
                assignment.setCourseId(rs.getInt("course_id"));
                assignment.setInstructorId(rs.getInt("instructor_id"));
                assignment.setTitle(rs.getString("title"));
                assignment.setDescription(rs.getString("description"));
                assignment.setTotalMarks(rs.getInt("total_marks"));
                assignment.setDueDate(rs.getDate("due_date"));
                assignment.setCreatedAt(rs.getTimestamp("created_at"));
                assignment.setCourseName(rs.getString("course_name"));
                assignment.setInstructorName(rs.getString("instructor_name"));
                return assignment;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return null;
    }
    
    // UPDATE ASSIGNMENT
    public boolean updateAssignment(Assignment assignment) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "UPDATE assignment SET title = ?, description = ?, total_marks = ?, due_date = ? WHERE assignment_id = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, assignment.getTitle());
            ps.setString(2, assignment.getDescription());
            ps.setInt(3, assignment.getTotalMarks());
            ps.setDate(4, assignment.getDueDate() != null ? new java.sql.Date(assignment.getDueDate().getTime()) : null);
            ps.setInt(5, assignment.getAssignmentId());
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
    
    // DELETE ASSIGNMENT
    public boolean deleteAssignment(int assignmentId) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "DELETE FROM assignment WHERE assignment_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, assignmentId);
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}