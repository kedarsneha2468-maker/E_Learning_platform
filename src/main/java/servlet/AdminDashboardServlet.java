package servlet;

import database.DBConnection;
import model.AdminDashboard;
import model.Course;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        
        // Check if admin is logged in
        String admin = (String) session.getAttribute("admin");
        if (admin == null) {
            response.sendRedirect("admin_login.jsp");
            return;
        }
        
        System.out.println("=== AdminDashboardServlet START ===");
        
        // Get search parameter
        String searchQuery = request.getParameter("search");
        if (searchQuery == null) {
            searchQuery = "";
        }
        
        AdminDashboard dashboard = new AdminDashboard();
        List<Course> courses = new ArrayList<>();

        try {
            Connection con = DBConnection.getConnection();
            
            if (con == null) {
                System.out.println("Database connection failed!");
                request.setAttribute("error", "Database connection failed");
                request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
                return;
            }
            
            System.out.println("Database connected successfully");
            System.out.println("Search Query: " + searchQuery);

            // Total Students
            String studentQuery = "SELECT COUNT(*) as total FROM student";
            PreparedStatement ps1 = con.prepareStatement(studentQuery);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) {
                dashboard.setTotalStudents(rs1.getInt("total"));
            }
            rs1.close();
            ps1.close();

            // Total Instructors
            String instructorQuery = "SELECT COUNT(*) as total FROM instructor";
            PreparedStatement ps2 = con.prepareStatement(instructorQuery);
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) {
                dashboard.setTotalInstructors(rs2.getInt("total"));
            }
            rs2.close();
            ps2.close();

            // Total Courses
            String courseCountQuery = "SELECT COUNT(*) as total FROM course";
            PreparedStatement ps3 = con.prepareStatement(courseCountQuery);
            ResultSet rs3 = ps3.executeQuery();
            if (rs3.next()) {
                dashboard.setTotalCourses(rs3.getInt("total"));
            }
            rs3.close();
            ps3.close();

            // Total Enrollments
            String enrollQuery = "SELECT COUNT(*) as total FROM enrollment";
            PreparedStatement ps4 = con.prepareStatement(enrollQuery);
            ResultSet rs4 = ps4.executeQuery();
            if (rs4.next()) {
                dashboard.setTotalEnrollments(rs4.getInt("total"));
            }
            rs4.close();
            ps4.close();

            // Get courses with search filter
            String courseDetailsQuery;
            PreparedStatement ps5;
            
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                // Search by course name or instructor name
                courseDetailsQuery = "SELECT c.*, i.name as instructor_name FROM course c " +
                                    "LEFT JOIN instructor i ON c.instructor_id = i.instructor_id " +
                                    "WHERE c.course_name LIKE ? OR i.name LIKE ? " +
                                    "ORDER BY c.course_id DESC";
                ps5 = con.prepareStatement(courseDetailsQuery);
                String searchPattern = "%" + searchQuery + "%";
                ps5.setString(1, searchPattern);
                ps5.setString(2, searchPattern);
            } else {
                // Get all courses
                courseDetailsQuery = "SELECT c.*, i.name as instructor_name FROM course c " +
                                    "LEFT JOIN instructor i ON c.instructor_id = i.instructor_id " +
                                    "ORDER BY c.course_id DESC";
                ps5 = con.prepareStatement(courseDetailsQuery);
            }
            
            ResultSet rs5 = ps5.executeQuery();

            int courseCount = 0;
            while (rs5.next()) {
                Course course = new Course();
                course.setCourseId(rs5.getInt("course_id"));
                course.setCourseName(rs5.getString("course_name"));
                course.setDescription(rs5.getString("description"));
                course.setDuration(rs5.getString("duration"));
                course.setCategory(rs5.getString("category"));
                course.setInstructorId(rs5.getInt("instructor_id"));
                course.setInstructorName(rs5.getString("instructor_name"));
                courses.add(course);
                courseCount++;
            }
            rs5.close();
            ps5.close();

            con.close();
            
            System.out.println("Total courses fetched: " + courseCount);

        } catch (Exception e) {
            System.out.println("Error in AdminDashboardServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }

        request.setAttribute("dashboard", dashboard);
        request.setAttribute("courses", courses);
        request.setAttribute("searchQuery", searchQuery);
        request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
    }
}