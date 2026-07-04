package servlet;

import database.DBConnection;
import model.Course;
import model.Module;
import model.Video;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CourseDetailsServlet")
public class CourseDetailsServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer studentId = (Integer) session.getAttribute("student_id");
        
        if (studentId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            
            // Check if student is enrolled and get completion status
            String checkQuery = "SELECT e.*, " +
                               "(SELECT COUNT(*) FROM video v JOIN module m ON v.module_id = m.module_id WHERE m.course_id = e.course_id) as total_videos, " +
                               "(SELECT COUNT(*) FROM video_progress vp JOIN video v ON vp.video_id = v.video_id JOIN module m ON v.module_id = m.module_id WHERE vp.student_id = e.student_id AND m.course_id = e.course_id AND vp.is_watched = TRUE) as watched_videos " +
                               "FROM enrollment e WHERE e.student_id = ? AND e.course_id = ?";
            ps = con.prepareStatement(checkQuery);
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            rs = ps.executeQuery();
            
            boolean isEnrolled = rs.next();
            boolean isCourseCompleted = false;
            
            // ========== CODE COMMENTED OUT - NOW HANDLED BY TRIGGER ==========
            // This code is now automatically handled by the 'update_course_progress' trigger
            // The trigger fires automatically when a video is marked as watched
            // =================================================================
            
//            int totalVideos = 0;
//            int watchedVideos = 0;
//            int progressPercentage = 0;
//            
//            if (isEnrolled) {
//                isCourseCompleted = rs.getBoolean("is_completed");
//                totalVideos = rs.getInt("total_videos");
//                watchedVideos = rs.getInt("watched_videos");
//                
//                if (totalVideos > 0) {
//                    progressPercentage = (watchedVideos * 100) / totalVideos;
//                }
//                
//                if (progressPercentage != rs.getInt("progress_percentage")) {
//                    String updateProgress = "UPDATE enrollment SET progress_percentage = ? WHERE student_id = ? AND course_id = ?";
//                    PreparedStatement psUpdate = con.prepareStatement(updateProgress);
//                    psUpdate.setInt(1, progressPercentage);
//                    psUpdate.setInt(2, studentId);
//                    psUpdate.setInt(3, courseId);
//                    psUpdate.executeUpdate();
//                    psUpdate.close();
//                }
//                
//                if (progressPercentage == 100 && !isCourseCompleted) {
//                    String completeQuery = "UPDATE enrollment SET is_completed = TRUE, completed_at = CURRENT_TIMESTAMP WHERE student_id = ? AND course_id = ?";
//                    PreparedStatement psComplete = con.prepareStatement(completeQuery);
//                    psComplete.setInt(1, studentId);
//                    psComplete.setInt(2, courseId);
//                    psComplete.executeUpdate();
//                    psComplete.close();
//                    isCourseCompleted = true;
//                }
//            }
            
            // ========== KEEP THIS - Still needed to get isCourseCompleted from database ==========
            // We still need to read the completion status that the trigger updated
            if (isEnrolled) {
                isCourseCompleted = rs.getBoolean("is_completed");
            }
            // ===================================================================================
            
            rs.close();
            ps.close();
            
            // Get course details
            Course course = null;
            String courseQuery = "SELECT * FROM course WHERE course_id = ?";
            ps = con.prepareStatement(courseQuery);
            ps.setInt(1, courseId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                course = new Course();
                course.setCourseId(rs.getInt("course_id"));
                course.setCourseName(rs.getString("course_name"));
                course.setDescription(rs.getString("description"));
                course.setDuration(rs.getString("duration"));
                course.setCategory(rs.getString("category"));
            }
            rs.close();
            ps.close();
            
            // Get modules and videos
            List<Module> modules = new ArrayList<>();
            String moduleQuery = "SELECT * FROM module WHERE course_id = ? ORDER BY module_id";
            ps = con.prepareStatement(moduleQuery);
            ps.setInt(1, courseId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Module module = new Module();
                module.setModuleId(rs.getInt("module_id"));
                module.setModuleName(rs.getString("module_name"));
                module.setDescription(rs.getString("description"));
                module.setCourseId(courseId);
                
                List<Video> videos = new ArrayList<>();
                String videoQuery = "SELECT v.*, COALESCE(vp.is_watched, FALSE) as is_watched " +
                                   "FROM video v " +
                                   "LEFT JOIN video_progress vp ON v.video_id = vp.video_id AND vp.student_id = ? " +
                                   "WHERE v.module_id = ? ORDER BY v.video_id";
                PreparedStatement ps2 = con.prepareStatement(videoQuery);
                ps2.setInt(1, studentId);
                ps2.setInt(2, module.getModuleId());
                ResultSet rs2 = ps2.executeQuery();
                
                while (rs2.next()) {
                    Video video = new Video();
                    video.setVideoId(rs2.getInt("video_id"));
                    video.setTitle(rs2.getString("video_title"));
                    video.setVideoUrl(rs2.getString("video_url"));
                    video.setDuration(rs2.getString("duration"));
                    video.setModuleId(module.getModuleId());
                    video.setWatched(rs2.getBoolean("is_watched"));
                    videos.add(video);
                }
                rs2.close();
                ps2.close();
                
                module.setVideos(videos);
                modules.add(module);
            }
            
            // Get assignments with submission status
            List<Map<String, Object>> assignmentsData = new ArrayList<>();
            int totalAssignments = 0;
            int gradedAssignments = 0;
            boolean allAssignmentsGraded = false;
            
            if (isEnrolled && isCourseCompleted) {
                String assignQuery = "SELECT a.*, s.submission_id, s.status, s.marks_obtained, s.feedback, s.submitted_at " +
                                    "FROM assignment a " +
                                    "LEFT JOIN submission s ON a.assignment_id = s.assignment_id AND s.student_id = ? " +
                                    "WHERE a.course_id = ? ORDER BY a.assignment_id";
                ps = con.prepareStatement(assignQuery);
                ps.setInt(1, studentId);
                ps.setInt(2, courseId);
                rs = ps.executeQuery();
                
                while (rs.next()) {
                    Map<String, Object> assignMap = new HashMap<>();
                    assignMap.put("assignment_id", rs.getInt("assignment_id"));
                    assignMap.put("title", rs.getString("title"));
                    assignMap.put("description", rs.getString("description"));
                    assignMap.put("total_marks", rs.getInt("total_marks"));
                    assignMap.put("due_date", rs.getDate("due_date"));
                    assignMap.put("submission_id", rs.getObject("submission_id"));
                    assignMap.put("status", rs.getString("status"));
                    assignMap.put("marks_obtained", rs.getObject("marks_obtained"));
                    assignMap.put("feedback", rs.getString("feedback"));
                    assignMap.put("submitted_at", rs.getTimestamp("submitted_at"));
                    assignmentsData.add(assignMap);
                    totalAssignments++;
                    
                    if ("graded".equals(rs.getString("status"))) {
                        gradedAssignments++;
                    }
                }
                allAssignmentsGraded = (totalAssignments > 0 && totalAssignments == gradedAssignments);
            }
            
            // ========== CERTIFICATE CHECK - Now handled by trigger, but we still need to check existence ==========
            // The 'auto_create_certificate' trigger automatically creates the certificate
            // when the last assignment is graded. We just need to check if it exists.
            // ================================================================================================
            
            // Check if certificate exists (trigger would have created it already)
            boolean certificateIssued = false;
            if (isEnrolled && isCourseCompleted && allAssignmentsGraded) {
                String certQuery = "SELECT certificate_id FROM certificate WHERE student_id = ? AND course_id = ?";
                ps = con.prepareStatement(certQuery);
                ps.setInt(1, studentId);
                ps.setInt(2, courseId);
                rs = ps.executeQuery();
                certificateIssued = rs.next();
                rs.close();
                ps.close();
            }
            
            // ========== GET PROGRESS PERCENTAGE FROM DATABASE (Updated by Trigger) ==========
            // Get the progress percentage that the trigger has updated
            int progressPercentage = 0;
            if (isEnrolled) {
                String progressQuery = "SELECT progress_percentage FROM enrollment WHERE student_id = ? AND course_id = ?";
                ps = con.prepareStatement(progressQuery);
                ps.setInt(1, studentId);
                ps.setInt(2, courseId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    progressPercentage = rs.getInt("progress_percentage");
                }
                rs.close();
                ps.close();
            }
            // =================================================================================
            
            request.setAttribute("course", course);
            request.setAttribute("modules", modules);
            request.setAttribute("isEnrolled", isEnrolled);
            request.setAttribute("isCourseCompleted", isCourseCompleted);
            request.setAttribute("progressPercentage", progressPercentage);
            request.setAttribute("courseId", courseId);
            request.setAttribute("assignmentsData", assignmentsData);
            request.setAttribute("totalAssignments", totalAssignments);
            request.setAttribute("gradedAssignments", gradedAssignments);
            request.setAttribute("allAssignmentsGraded", allAssignmentsGraded);
            request.setAttribute("certificateIssued", certificateIssued);
            
            request.getRequestDispatcher("course_details.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("Error in CourseDetailsServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("StudentDashboardServlet?error=Database error");
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}