package servlet;

import dao.SubmissionDAO;
import dao.AssignmentDAO;
import database.DBConnection;
import model.Submission;
import model.Assignment;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/ViewSubmissionServlet")
public class ViewSubmissionServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== ViewSubmissionServlet START ===");
        
        HttpSession session = request.getSession();
        Integer instructorId = (Integer) session.getAttribute("instructor_id");
        
        if (instructorId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get assignmentId from request parameter (not from attribute)
        String assignmentIdParam = request.getParameter("assignmentId");
        System.out.println("Assignment ID Parameter: " + assignmentIdParam);
        
        if (assignmentIdParam == null || assignmentIdParam.isEmpty()) {
            System.out.println("Error: No assignmentId parameter");
            response.sendRedirect("instructor_dashboard.jsp?error=Invalid assignment");
            return;
        }
        
        int assignmentId = Integer.parseInt(assignmentIdParam);
        System.out.println("Assignment ID: " + assignmentId);
        
        SubmissionDAO submissionDAO = new SubmissionDAO();
        AssignmentDAO assignmentDAO = new AssignmentDAO();
        
        List<Submission> submissions = submissionDAO.getSubmissionsByAssignment(assignmentId);
        Assignment assignment = assignmentDAO.getAssignmentById(assignmentId);
        
        System.out.println("Submissions found: " + (submissions != null ? submissions.size() : 0));
        
        // Set attributes for JSP
        request.setAttribute("submissions", submissions);
        request.setAttribute("assignment", assignment);
        request.setAttribute("assignmentId", assignmentId);  // ← IMPORTANT: Set this!
        
        request.getRequestDispatcher("view_submissions.jsp").forward(request, response);
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
            return result > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}