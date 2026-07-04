package servlet;

import database.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/MarkVideoWatchedServlet")
public class MarkVideoWatchedServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer studentId = (Integer) session.getAttribute("student_id");
        
        if (studentId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int videoId = Integer.parseInt(request.getParameter("videoId"));
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            
            // Check if already marked as watched
            String checkQuery = "SELECT watch_id FROM video_progress WHERE student_id = ? AND video_id = ?";
            ps = con.prepareStatement(checkQuery);
            ps.setInt(1, studentId);
            ps.setInt(2, videoId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                // Update existing record
                String updateQuery = "UPDATE video_progress SET is_watched = TRUE, watched_at = CURRENT_TIMESTAMP WHERE student_id = ? AND video_id = ?";
                ps = con.prepareStatement(updateQuery);
                ps.setInt(1, studentId);
                ps.setInt(2, videoId);
                ps.executeUpdate();
            } else {
                // Insert new record
                String insertQuery = "INSERT INTO video_progress(student_id, video_id, is_watched, watched_at) VALUES(?, ?, TRUE, CURRENT_TIMESTAMP)";
                ps = con.prepareStatement(insertQuery);
                ps.setInt(1, studentId);
                ps.setInt(2, videoId);
                ps.executeUpdate();
            }
            
            // Redirect back to course details
            response.sendRedirect("CourseDetailsServlet?courseId=" + courseId + "&msg=watched");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("CourseDetailsServlet?courseId=" + courseId + "&error=Failed to mark as watched");
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}