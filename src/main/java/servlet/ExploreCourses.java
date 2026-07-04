package servlet;

import database.DBConnection;
import model.Course;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/ExploreCoursesServlet")
public class ExploreCourses extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get session
        HttpSession session = request.getSession();
        
        // Check if student is logged in
        if(session.getAttribute("student_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int studentId = (Integer) session.getAttribute("student_id");
        
        List<Course> allCourses = new ArrayList<>();
        List<Course> enrolledCourses = new ArrayList<>();
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            
            // First, get enrolled courses
            String enrolledQuery = "SELECT course_id FROM enrollment WHERE student_id = ?";
            ps = con.prepareStatement(enrolledQuery);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            
            Set<Integer> enrolledIds = new HashSet<>();
            while(rs.next()) {
                enrolledIds.add(rs.getInt("course_id"));
            }
            rs.close();
            ps.close();
            
            // Get all courses
            String query = "SELECT * FROM course ORDER BY course_name";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            while(rs.next()) {
                Course course = new Course();
                course.setCourseId(rs.getInt("course_id"));
                course.setCourseName(rs.getString("course_name"));
                course.setDescription(rs.getString("description"));
                course.setDuration(rs.getString("duration"));
                course.setCategory(rs.getString("category"));
                course.setInstructorId(rs.getInt("instructor_id"));
                
                if(enrolledIds.contains(course.getCourseId())) {
                    enrolledCourses.add(course);
                } else {
                    allCourses.add(course);
                }
            }
            
        } catch(Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        } finally {
            try {
                if(rs != null) rs.close();
                if(ps != null) ps.close();
                if(con != null) con.close();
            } catch(SQLException e) {
                e.printStackTrace();
            }
        }
        
        // Set attributes
        request.setAttribute("allCourses", allCourses);
        request.setAttribute("enrolledCourses", enrolledCourses);
        
        // Forward to JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("explore_courses.jsp");
        dispatcher.forward(request, response);
    }
}