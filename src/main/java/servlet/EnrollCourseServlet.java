package servlet;

import database.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EnrollCourseServlet")
public class EnrollCourseServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        Integer studentId = (Integer) session.getAttribute("student_id");
        
        if (studentId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String redirectTo = request.getParameter("redirectTo");
        
        if (redirectTo == null) {
            redirectTo = "CourseDetailsServlet";
        }
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            
            // Check if already enrolled
            String checkQuery = "SELECT * FROM enrollment WHERE student_id = ? AND course_id = ?";
            ps = con.prepareStatement(checkQuery);
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                // Already enrolled - just go to course details
                response.sendRedirect(redirectTo + "?courseId=" + courseId);
                return;
            }
            
            rs.close();
            ps.close();
            
            // Enroll student
            String insertQuery = "INSERT INTO enrollment (student_id, course_id) VALUES (?, ?)";
            ps = con.prepareStatement(insertQuery);
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                // Update session's enrolled course IDs
                @SuppressWarnings("unchecked")
                java.util.Set<Integer> enrolledIds = (java.util.Set<Integer>) session.getAttribute("enrolledCourseIds");
                if (enrolledIds == null) {
                    enrolledIds = new java.util.HashSet<>();
                } 
                enrolledIds.add(courseId);
                session.setAttribute("enrolledCourseIds", enrolledIds);
                
                // Redirect back to course details with success message
                response.sendRedirect(redirectTo + "?courseId=" + courseId + "&msg=enrolled");
            } else {
                response.sendRedirect(redirectTo + "?courseId=" + courseId + "&error=Failed to enroll");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(redirectTo + "?courseId=" + courseId + "&error=Database error");
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}