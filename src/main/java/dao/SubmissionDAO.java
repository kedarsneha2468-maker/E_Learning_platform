package dao;

import database.DBConnection;
import model.Submission;
import java.sql.*;
import java.util.*;

public class SubmissionDAO {
    
    public boolean submitAssignment(Submission submission) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            
            // Check if already submitted
            String checkQuery = "SELECT submission_id FROM submission WHERE assignment_id = ? AND student_id = ?";
            PreparedStatement checkPs = con.prepareStatement(checkQuery);
            checkPs.setInt(1, submission.getAssignmentId());
            checkPs.setInt(2, submission.getStudentId());
            rs = checkPs.executeQuery();
            
            boolean exists = rs.next();
            rs.close();
            checkPs.close();
            
            if (exists) {
                String updateQuery = "UPDATE submission SET submission_text = ?, file_path = ?, submitted_at = CURRENT_TIMESTAMP, status = 'submitted', marks_obtained = NULL, feedback = NULL, graded_by = NULL, graded_at = NULL WHERE assignment_id = ? AND student_id = ?";
                ps = con.prepareStatement(updateQuery);
                ps.setString(1, submission.getSubmissionText());
                ps.setString(2, submission.getFilePath());
                ps.setString(3, submission.getStatus());  // ✅ Can be 'submitted' or 'late'
                ps.setInt(3, submission.getAssignmentId());
                ps.setInt(4, submission.getStudentId());
            } else {
                String insertQuery = "INSERT INTO submission(assignment_id, student_id, submission_text, file_path, status) VALUES(?, ?, ?, ?, 'submitted')";
                ps = con.prepareStatement(insertQuery);
                ps.setInt(1, submission.getAssignmentId());
                ps.setInt(2, submission.getStudentId());
                ps.setString(3, submission.getSubmissionText());
                ps.setString(4, submission.getFilePath());
            }
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
    
    public Submission getSubmission(int assignmentId, int studentId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT s.*, a.title as assignment_title, a.total_marks, i.name as grader_name FROM submission s " +
                          "JOIN assignment a ON s.assignment_id = a.assignment_id " +
                          "LEFT JOIN instructor i ON s.graded_by = i.instructor_id " +
                          "WHERE s.assignment_id = ? AND s.student_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, assignmentId);
            ps.setInt(2, studentId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                Submission submission = new Submission();
                submission.setSubmissionId(rs.getInt("submission_id"));
                submission.setAssignmentId(rs.getInt("assignment_id"));
                submission.setStudentId(rs.getInt("student_id"));
                submission.setSubmissionText(rs.getString("submission_text"));
                submission.setFilePath(rs.getString("file_path"));
                submission.setSubmittedAt(rs.getTimestamp("submitted_at"));
                submission.setMarksObtained(rs.getInt("marks_obtained"));
                if (rs.wasNull()) submission.setMarksObtained(null);
                submission.setFeedback(rs.getString("feedback"));
                submission.setGradedBy(rs.getInt("graded_by"));
                if (rs.wasNull()) submission.setGradedBy(null);
                submission.setGradedAt(rs.getTimestamp("graded_at"));
                submission.setStatus(rs.getString("status"));
                submission.setAssignmentTitle(rs.getString("assignment_title"));
                submission.setTotalMarks(rs.getInt("total_marks"));
                submission.setGraderName(rs.getString("grader_name"));
                return submission;
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return null;
    }
    
    public List<Submission> getSubmissionsByAssignment(int assignmentId) {
        List<Submission> submissions = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT s.*, st.name as student_name, st.email as student_email, a.title as assignment_title, a.total_marks, i.name as grader_name " +
                          "FROM submission s " +
                          "JOIN student st ON s.student_id = st.student_id " +
                          "JOIN assignment a ON s.assignment_id = a.assignment_id " +
                          "LEFT JOIN instructor i ON s.graded_by = i.instructor_id " +
                          "WHERE s.assignment_id = ? ORDER BY s.submitted_at DESC";
            ps = con.prepareStatement(query);
            ps.setInt(1, assignmentId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Submission submission = new Submission();
                submission.setSubmissionId(rs.getInt("submission_id"));
                submission.setAssignmentId(rs.getInt("assignment_id"));
                submission.setStudentId(rs.getInt("student_id"));
                submission.setSubmissionText(rs.getString("submission_text"));
                submission.setFilePath(rs.getString("file_path"));
                submission.setSubmittedAt(rs.getTimestamp("submitted_at"));
                submission.setMarksObtained(rs.getInt("marks_obtained"));
                if (rs.wasNull()) submission.setMarksObtained(null);
                submission.setFeedback(rs.getString("feedback"));
                submission.setGradedBy(rs.getInt("graded_by"));
                if (rs.wasNull()) submission.setGradedBy(null);
                submission.setGradedAt(rs.getTimestamp("graded_at"));
                submission.setStatus(rs.getString("status"));
                submission.setStudentName(rs.getString("student_name"));
                submission.setStudentEmail(rs.getString("student_email"));
                submission.setAssignmentTitle(rs.getString("assignment_title"));
                submission.setTotalMarks(rs.getInt("total_marks"));
                submission.setGraderName(rs.getString("grader_name"));
                submissions.add(submission);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return submissions;
    }
    
    public boolean gradeSubmission(int submissionId, int marksObtained, String feedback, int gradedBy) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "UPDATE submission SET marks_obtained = ?, feedback = ?, graded_by = ?, graded_at = CURRENT_TIMESTAMP, status = 'graded' WHERE submission_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, marksObtained);
            ps.setString(2, feedback);
            ps.setInt(3, gradedBy);
            ps.setInt(4, submissionId);
            
            int result = ps.executeUpdate();
            System.out.println("Grade update result: " + result);
            return result > 0;
            
        } catch (Exception e) {
            System.out.println("Error in gradeSubmission: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}