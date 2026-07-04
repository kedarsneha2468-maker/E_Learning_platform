package servlet;

import database.DBConnection;
import model.Instructor;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/AddCourseServlet")
public class AddCourseServlet extends HttpServlet {

    // Handle GET request - Show the add course form with instructors
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Instructor> instructors = new ArrayList<>();
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            
            // Fetch all instructors from database
            String query = "SELECT * FROM instructor ORDER BY name";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Instructor instructor = new Instructor();
                instructor.setInstructorId(rs.getInt("instructor_id"));
                instructor.setName(rs.getString("name"));
                instructor.setEmail(rs.getString("email"));
                instructor.setExpertise(rs.getString("expertise"));
                instructor.setExperience(rs.getInt("experience"));
                instructors.add(instructor);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
        
        request.setAttribute("instructors", instructors);
        RequestDispatcher dispatcher = request.getRequestDispatcher("add_course.jsp");
        dispatcher.forward(request, response);
    }

    // Handle POST request - Add the course
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String courseName = request.getParameter("course_name");
        String description = request.getParameter("description");
        String duration = request.getParameter("duration");
        String category = request.getParameter("category");
        String otherCategory = request.getParameter("other_category");

        // Handle "OTHER" category
        if (category != null && category.equals("Other") && otherCategory != null && !otherCategory.isEmpty()) {
            category = otherCategory;
        }

        // Get instructor from dropdown
        String instructorIdParam = request.getParameter("instructor_id");
        if (instructorIdParam == null || instructorIdParam.isEmpty()) {
            response.sendRedirect("add_course.jsp?error=Please select an instructor");
            return;
        }
        
        int instructorId = Integer.parseInt(instructorIdParam);

        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();

            String query = "INSERT INTO course(course_name, description, duration, category, instructor_id) VALUES(?,?,?,?,?)";
            ps = con.prepareStatement(query);

            ps.setString(1, courseName);
            ps.setString(2, description);
            ps.setString(3, duration);
            ps.setString(4, category);
            ps.setInt(5, instructorId);

            int result = ps.executeUpdate();

            if (result > 0) {
                // Success - redirect to dashboard with success message
                response.sendRedirect("AdminDashboardServlet?success=Course added successfully: " + courseName);
            } else {
                // Failed - redirect back to form with error
                response.sendRedirect("add_course.jsp?error=Failed to add course");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add_course.jsp?error=Database error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}