package servlet;

import database.DBConnection;
import java.io.*;
import javax.servlet.http.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import java.io.IOException;

@WebServlet("/AddModuleServlet")
public class AddModuleServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int courseId = Integer.parseInt(request.getParameter("courseId"));
        System.out.println("Course ID:"+courseId);
        String moduleName = request.getParameter("moduleName");
        String description = request.getParameter("description");

        try {
            Connection con = DBConnection.getConnection();

            String q = "INSERT INTO module(course_id, module_name, description) VALUES(?,?,?)";
            PreparedStatement ps = con.prepareStatement(q);

            ps.setInt(1, courseId);
            ps.setString(2, moduleName);
            ps.setString(3, description);

            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                System.out.println("✅ Module added successfully for course ID: " + courseId);
            } else {
                System.out.println("❌ Failed to add module");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // ✅ Correct Redirect
        response.sendRedirect(request.getContextPath() + "/InstructorDashboardServlet");
    }
}