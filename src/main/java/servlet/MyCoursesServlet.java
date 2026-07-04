package servlet;

import database.DBConnection;
import model.Course;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/MyCoursesServlet")
public class MyCoursesServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        if (session.getAttribute("student_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int studentId = (Integer) session.getAttribute("student_id");
        List<Course> enrolledCourses = new ArrayList<>();
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            
            // Get enrolled courses with progress and completion status
            // Removed ORDER BY e.enrollment_date since column doesn't exist
            String query = "SELECT c.*, e.progress_percentage, e.is_completed " +
                          "FROM course c " +
                          "INNER JOIN enrollment e ON c.course_id = e.course_id " +
                          "WHERE e.student_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Course course = new Course();
                course.setCourseId(rs.getInt("course_id"));
                course.setCourseName(rs.getString("course_name"));
                course.setDescription(rs.getString("description"));
                course.setDuration(rs.getString("duration"));
                course.setCategory(rs.getString("category"));
                course.setInstructorId(rs.getInt("instructor_id"));
                course.setProgressPercentage(rs.getInt("progress_percentage"));
                course.setCompleted(rs.getBoolean("is_completed"));
                enrolledCourses.add(course);
            }
            
            request.setAttribute("enrolledCourses", enrolledCourses);
            request.getRequestDispatcher("my_courses.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("StudentDashboardServlet?error=Database error");
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}