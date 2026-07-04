package servlet;

import database.DBConnection;
import model.Course;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/StudentDashboardServlet")
public class StudentDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        
        Integer studentId = (Integer) session.getAttribute("student_id");
        
        if (studentId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get filter parameter from request
        String categoryFilter = request.getParameter("category");
        if (categoryFilter == null || categoryFilter.isEmpty()) {
            categoryFilter = "all";
        }
        
        List<Course> courses = new ArrayList<>();
        Set<Integer> enrolledCourseIds = new HashSet<>();
        Set<String> allCategories = new HashSet<>();
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            
            // Get enrolled course IDs for this student
            String enrolledQuery = "SELECT course_id FROM enrollment WHERE student_id = ?";
            ps = con.prepareStatement(enrolledQuery);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                enrolledCourseIds.add(rs.getInt("course_id"));
            }
            rs.close();
            ps.close();
            
            // Get all courses with instructor names (for display)
            String courseQuery;
            if (!categoryFilter.equals("all")) {
                // Filter by category
                courseQuery = "SELECT c.*, i.name as instructor_name FROM course c " +
                              "LEFT JOIN instructor i ON c.instructor_id = i.instructor_id " +
                              "WHERE c.category = ? ORDER BY c.course_name";
                ps = con.prepareStatement(courseQuery);
                ps.setString(1, categoryFilter);
            } else {
                // Get all courses
                courseQuery = "SELECT c.*, i.name as instructor_name FROM course c " +
                              "LEFT JOIN instructor i ON c.instructor_id = i.instructor_id " +
                              "ORDER BY c.course_name";
                ps = con.prepareStatement(courseQuery);
            }
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Course course = new Course();
                course.setCourseId(rs.getInt("course_id"));
                course.setCourseName(rs.getString("course_name"));
                course.setDescription(rs.getString("description"));
                course.setDuration(rs.getString("duration"));
                course.setCategory(rs.getString("category"));
                course.setInstructorId(rs.getInt("instructor_id"));
                course.setInstructorName(rs.getString("instructor_name"));
                courses.add(course);
            }
            rs.close();
            ps.close();
            
            // Get all unique categories for filter dropdown
            String categoryQuery = "SELECT DISTINCT category FROM course WHERE category IS NOT NULL ORDER BY category";
            ps = con.prepareStatement(categoryQuery);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                allCategories.add(rs.getString("category"));
            }
            
            // Store enrolled IDs in session for JSP access
            session.setAttribute("enrolledCourseIds", enrolledCourseIds);
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
        
        // Sort categories for consistent display
        List<String> sortedCategories = new ArrayList<>(allCategories);
        Collections.sort(sortedCategories);
        
        request.setAttribute("courses", courses);
        request.setAttribute("categories", sortedCategories);
        request.setAttribute("selectedCategory", categoryFilter);
        
        request.getRequestDispatcher("student_dashboard.jsp").forward(request, response);
    }
}