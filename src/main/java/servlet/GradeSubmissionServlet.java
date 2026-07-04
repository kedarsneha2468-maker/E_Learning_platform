package servlet;

import dao.SubmissionDAO;
import database.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/GradeSubmissionServlet")
public class GradeSubmissionServlet extends HttpServlet {
    
    // Handle GET requests (from the prompt)
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer instructorId = (Integer) session.getAttribute("instructor_id");
        
        if (instructorId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int submissionId = Integer.parseInt(request.getParameter("submissionId"));
        int marksObtained = Integer.parseInt(request.getParameter("marksObtained"));
        String feedback = request.getParameter("feedback");
        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
        
        System.out.println("=== GradeSubmissionServlet (GET) ===");
        System.out.println("Submission ID: " + submissionId);
        System.out.println("Marks: " + marksObtained);
        
        // ========== THIS UPDATE TRIGGERS THE CERTIFICATE CREATION ==========
        // The 'auto_create_certificate' trigger fires automatically when 
        // status changes to 'graded'. No additional code needed!
        // ===================================================================
        
        SubmissionDAO dao = new SubmissionDAO();
        boolean graded = dao.gradeSubmission(submissionId, marksObtained, feedback, instructorId);
        
        // ========== CODE COMMENTED OUT - NOW HANDLED BY TRIGGER ==========
        // The trigger automatically creates the certificate when all 
        // assignments are graded. No need to manually check or create.
        // =================================================================
        
//        // OLD CODE - Now handled by trigger:
//        // Check if all assignments are graded and create certificate
//        if (graded) {
//            // Check if this was the last pending assignment
//            boolean allGraded = checkAllAssignmentsGraded(assignmentId, submissionId);
//            if (allGraded) {
//                // Create certificate automatically
//                createCertificateForStudent(submissionId);
//            }
//        }
        
        if (graded) {
            response.sendRedirect("ViewSubmissionsServlet?assignmentId=" + assignmentId + "&success=Graded successfully");
        } else {
            response.sendRedirect("ViewSubmissionsServlet?assignmentId=" + assignmentId + "&error=Failed to grade");
        }
    }
    
    // Handle POST requests
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer instructorId = (Integer) session.getAttribute("instructor_id");
        
        if (instructorId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int submissionId = Integer.parseInt(request.getParameter("submissionId"));
        int marksObtained = Integer.parseInt(request.getParameter("marksObtained"));
        String feedback = request.getParameter("feedback");
        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
        
        System.out.println("=== GradeSubmissionServlet (POST) ===");
        System.out.println("Submission ID: " + submissionId);
        System.out.println("Marks: " + marksObtained);
        
        // ========== THIS UPDATE TRIGGERS THE CERTIFICATE CREATION ==========
        // The 'auto_create_certificate' trigger fires automatically when 
        // status changes to 'graded'. No additional code needed!
        // ===================================================================
        
        SubmissionDAO dao = new SubmissionDAO();
        boolean graded = dao.gradeSubmission(submissionId, marksObtained, feedback, instructorId);
        
        // ========== CODE COMMENTED OUT - NOW HANDLED BY TRIGGER ==========
        // The trigger automatically creates the certificate when all 
        // assignments are graded. No need to manually check or create.
        // =================================================================
        
//        // OLD CODE - Now handled by trigger:
//        // Check if all assignments are graded and create certificate
//        if (graded) {
//            // Check if this was the last pending assignment
//            boolean allGraded = checkAllAssignmentsGraded(assignmentId, submissionId);
//            if (allGraded) {
//                // Create certificate automatically
//                createCertificateForStudent(submissionId);
//            }
//        }
        
        if (graded) {
            // ========== FIXED REDIRECT URL ==========
            // Changed from ViewSubmissionServlet to ViewSubmissionsServlet (with 's')
            response.sendRedirect("ViewSubmissionServlet?assignmentId=" + assignmentId + "&success=Graded successfully");
        } else {
            response.sendRedirect("ViewSubmissionServlet?assignmentId=" + assignmentId + "&error=Failed to grade");
        }
    }
    
    // ========== HELPER METHODS - COMMENTED OUT (Now handled by trigger) ==========
    // These methods are no longer needed because the trigger handles certificate creation
    // =============================================================================
    
//    /**
//     * Check if all assignments for this course are graded
//     * OLD METHOD - Now handled by trigger
//     */
//    private boolean checkAllAssignmentsGraded(int assignmentId, int submissionId) {
//        Connection con = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//        
//        try {
//            con = DBConnection.getConnection();
//            
//            // Get course ID for this assignment
//            String courseQuery = "SELECT course_id FROM assignment WHERE assignment_id = ?";
//            ps = con.prepareStatement(courseQuery);
//            ps.setInt(1, assignmentId);
//            rs = ps.executeQuery();
//            int courseId = 0;
//            if (rs.next()) {
//                courseId = rs.getInt("course_id");
//            }
//            rs.close();
//            ps.close();
//            
//            // Get student ID from submission
//            String studentQuery = "SELECT student_id FROM submission WHERE submission_id = ?";
//            ps = con.prepareStatement(studentQuery);
//            ps.setInt(1, submissionId);
//            rs = ps.executeQuery();
//            int studentId = 0;
//            if (rs.next()) {
//                studentId = rs.getInt("student_id");
//            }
//            rs.close();
//            ps.close();
//            
//            // Count total assignments and graded assignments
//            String checkQuery = "SELECT COUNT(*) as total, " +
//                               "SUM(CASE WHEN s.status = 'graded' THEN 1 ELSE 0 END) as graded " +
//                               "FROM assignment a " +
//                               "LEFT JOIN submission s ON a.assignment_id = s.assignment_id AND s.student_id = ? " +
//                               "WHERE a.course_id = ?";
//            ps = con.prepareStatement(checkQuery);
//            ps.setInt(1, studentId);
//            ps.setInt(2, courseId);
//            rs = ps.executeQuery();
//            
//            if (rs.next()) {
//                int total = rs.getInt("total");
//                int graded = rs.getInt("graded");
//                return total > 0 && total == graded;
//            }
//            
//        } catch (Exception e) {
//            e.printStackTrace();
//        } finally {
//            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
//        }
//        return false;
//    }
//    
//    /**
//     * Create certificate for student
//     * OLD METHOD - Now handled by trigger
//     */
//    private void createCertificateForStudent(int submissionId) {
//        Connection con = null;
//        PreparedStatement ps = null;
//        ResultSet rs = null;
//        
//        try {
//            con = DBConnection.getConnection();
//            
//            // Get student ID and course ID
//            String infoQuery = "SELECT s.student_id, a.course_id " +
//                              "FROM submission s " +
//                              "JOIN assignment a ON s.assignment_id = a.assignment_id " +
//                              "WHERE s.submission_id = ?";
//            ps = con.prepareStatement(infoQuery);
//            ps.setInt(1, submissionId);
//            rs = ps.executeQuery();
//            
//            int studentId = 0;
//            int courseId = 0;
//            if (rs.next()) {
//                studentId = rs.getInt("student_id");
//                courseId = rs.getInt("course_id");
//            }
//            rs.close();
//            ps.close();
//            
//            // Check if certificate already exists
//            String checkQuery = "SELECT certificate_id FROM certificate WHERE student_id = ? AND course_id = ?";
//            ps = con.prepareStatement(checkQuery);
//            ps.setInt(1, studentId);
//            ps.setInt(2, courseId);
//            rs = ps.executeQuery();
//            
//            if (!rs.next()) {
//                // Generate certificate code
//                String certificateCode = generateCertificateCode(studentId, courseId);
//                
//                // Insert certificate
//                String insertQuery = "INSERT INTO certificate(student_id, course_id, certificate_code) VALUES(?, ?, ?)";
//                ps = con.prepareStatement(insertQuery);
//                ps.setInt(1, studentId);
//                ps.setInt(2, courseId);
//                ps.setString(3, certificateCode);
//                ps.executeUpdate();
//                
//                System.out.println("Certificate created automatically for student: " + studentId);
//            }
//            
//        } catch (Exception e) {
//            e.printStackTrace();
//        } finally {
//            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
//        }
//    }
//    
//    /**
//     * Generate unique certificate code
//     */
//    private String generateCertificateCode(int studentId, int courseId) {
//        String uniqueId = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
//        return "EDU-" + studentId + "-" + courseId + "-" + uniqueId;
//    }
}