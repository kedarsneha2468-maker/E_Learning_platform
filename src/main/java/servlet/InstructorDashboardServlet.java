package servlet;

import dao.InstructorDAO;
import database.DBConnection;
import dao.CourseDAO;
import model.Instructor;
import model.Course;
import java.io.IOException;
import java.sql.*;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/InstructorDashboardServlet")
public class InstructorDashboardServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer instructorId = (Integer) session.getAttribute("instructor_id");
        
        if (instructorId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        InstructorDAO instructorDAO = new InstructorDAO();
        CourseDAO courseDAO = new CourseDAO();
        
        // Get instructor details
        Instructor instructor = instructorDAO.getInstructorById(instructorId);
        
        if (instructor != null) {
            session.setAttribute("name", instructor.getName());
            session.setAttribute("email", instructor.getEmail());
            session.setAttribute("expertise", instructor.getExpertise());
            session.setAttribute("experience", instructor.getExperience());
        }
        
        // Get courses taught by this instructor
        List<Course> courses = instructorDAO.getCoursesByInstructor(instructorId);
        
        // Get enrollment stats for each course
        for (Course course : courses) {
            int enrolledCount = getEnrollmentCount(course.getCourseId());
            int completedCount = getCompletedCount(course.getCourseId());
            course.setEnrolledCount(enrolledCount);
            course.setCompletedCount(completedCount);
        }
        
        request.setAttribute("courses", courses);
        request.getRequestDispatcher("instructor_dashboard.jsp").forward(request, response);
    }
    
    private int getEnrollmentCount(int courseId) {
        int count = 0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT COUNT(*) as total FROM enrollment WHERE course_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, courseId);
            rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return count;
    }
    
    private int getCompletedCount(int courseId) {
        int count = 0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT COUNT(*) as total FROM enrollment WHERE course_id = ? AND is_completed = TRUE";
            ps = con.prepareStatement(query);
            ps.setInt(1, courseId);
            rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (SQLException e) {}
        }
        return count;
    }
}