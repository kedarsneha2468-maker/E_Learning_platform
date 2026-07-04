package servlet;

import database.DBConnection;
import model.Certificate;
import dao.CertificateDAO;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CertificateServlet")
public class CertificateServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer studentId = (Integer) session.getAttribute("student_id");
        
        if (studentId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        
        // Check if course is completed and all assignments are graded
        if (!isEligibleForCertificate(studentId, courseId)) {
            response.sendRedirect("CourseDetailsServlet?courseId=" + courseId + "&error=Complete all videos and assignments first");
            return;
        }
        
        CertificateDAO certDAO = new CertificateDAO();
        Certificate certificate = certDAO.getCertificateByStudentAndCourse(studentId, courseId);
        
        if (certificate == null) {
            // Generate new certificate
            String certificateCode = generateCertificateCode(studentId, courseId);
            certDAO.createCertificate(studentId, courseId, certificateCode);
            certificate = certDAO.getCertificateByStudentAndCourse(studentId, courseId);
        }
        
        String studentName = certDAO.getStudentName(studentId);
        String courseName = certDAO.getCourseName(courseId);
        String issueDate = certificate.getIssueDateFormatted();
        String certificateCode = certificate.getCertificateCode();
        
        request.setAttribute("certificate", certificate);
        request.setAttribute("studentName", studentName);
        request.setAttribute("courseName", courseName);
        request.setAttribute("issueDate", issueDate);
        request.setAttribute("certificateCode", certificateCode);
        request.setAttribute("courseId", courseId);
        
        request.getRequestDispatcher("certificate.jsp").forward(request, response);
    }
    
    private boolean isEligibleForCertificate(int studentId, int courseId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            
            // Check if course is completed
            String checkQuery = "SELECT is_completed FROM enrollment WHERE student_id = ? AND course_id = ?";
            ps = con.prepareStatement(checkQuery);
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            rs = ps.executeQuery();
            
            if (!rs.next() || !rs.getBoolean("is_completed")) {
                return false;
            }
            rs.close();
            ps.close();
            
            // Check if all assignments are graded
            String assignQuery = "SELECT COUNT(*) as total, " +
                                "SUM(CASE WHEN s.status = 'graded' THEN 1 ELSE 0 END) as graded " +
                                "FROM assignment a " +
                                "LEFT JOIN submission s ON a.assignment_id = s.assignment_id AND s.student_id = ? " +
                                "WHERE a.course_id = ?";
            ps = con.prepareStatement(assignQuery);
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                int total = rs.getInt("total");
                int graded = rs.getInt("graded");
                return total == 0 || (total > 0 && total == graded);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return false;
    }
    
    private String generateCertificateCode(int studentId, int courseId) {
        String uniqueId = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        return "EDU-" + studentId + "-" + courseId + "-" + uniqueId;
    }
}