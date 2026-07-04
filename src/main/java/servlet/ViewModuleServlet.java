package servlet;

import database.DBConnection;
import model.Module;
import model.Video;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ViewModuleServlet")
public class ViewModuleServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer instructorId = (Integer) session.getAttribute("instructor_id");
        
        if (instructorId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        
        List<Module> modules = new ArrayList<>();
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            
            // Get modules with videos
            String query = "SELECT m.*, v.video_id, v.video_title, v.video_url, v.duration as video_duration " +
                          "FROM module m " +
                          "LEFT JOIN video v ON m.module_id = v.module_id " +
                          "WHERE m.course_id = ? " +
                          "ORDER BY m.module_id, v.video_id";
            
            ps = con.prepareStatement(query);
            ps.setInt(1, courseId);
            rs = ps.executeQuery();
            
            Map<Integer, Module> moduleMap = new HashMap<>();
            
            while (rs.next()) {
                int moduleId = rs.getInt("module_id");
                
                Module module = moduleMap.get(moduleId);
                if (module == null) {
                    module = new Module();
                    module.setModuleId(moduleId);
                    module.setModuleName(rs.getString("module_name"));
                    module.setDescription(rs.getString("description"));
                    module.setCourseId(courseId);
                    module.setVideos(new ArrayList<>());
                    moduleMap.put(moduleId, module);
                    modules.add(module);
                }
                
                int videoId = rs.getInt("video_id");
                if (videoId > 0) {
                    Video video = new Video();
                    video.setVideoId(videoId);
                    video.setTitle(rs.getString("video_title"));
                    video.setVideoUrl(rs.getString("video_url"));
                    video.setDuration(rs.getString("video_duration"));
                    video.setModuleId(moduleId);
                    module.getVideos().add(video);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        
        // Get success/error messages from URL parameters
        String successMsg = request.getParameter("success");
        String errorMsg = request.getParameter("error");
        
        request.setAttribute("modules", modules);
        request.setAttribute("successMsg", successMsg);
        request.setAttribute("errorMsg", errorMsg);
        request.setAttribute("courseId", courseId);
        
        request.getRequestDispatcher("view_modules.jsp").forward(request, response);
    }
}