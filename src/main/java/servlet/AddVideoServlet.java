package servlet;

import database.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AddVideoServlet")
public class AddVideoServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer instructorId = (Integer) session.getAttribute("instructor_id");
        
        if (instructorId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
        String title = request.getParameter("title");
        String videoUrl = request.getParameter("videoUrl");
        String duration = request.getParameter("duration");
        String courseId = request.getParameter("courseId");
        
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            
            String query = "INSERT INTO video(video_title, video_url, duration, module_id) VALUES(?, ?, ?, ?)";
            ps = con.prepareStatement(query);
            ps.setString(1, title);
            ps.setString(2, videoUrl);
            ps.setString(3, duration);
            ps.setInt(4, moduleId);
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                // ✅ Success - redirect with success message
                response.sendRedirect("ViewModuleServlet?courseId=" + courseId + "&success=Video added successfully!");
            } else {
                response.sendRedirect("add_video.jsp?moduleId=" + moduleId + "&courseId=" + courseId + "&error=Failed to add video");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add_video.jsp?moduleId=" + moduleId + "&courseId=" + courseId + "&error=Database error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}