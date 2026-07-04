package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddAssignmentServlet")
public class AddAssignmentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int moduleId = Integer.parseInt(request.getParameter("moduleId"));
        String title = request.getParameter("title");
        String desc = request.getParameter("description");
        String date = request.getParameter("dueDate");

        try {
            Connection con = DBConnection.getConnection();

            String q = "INSERT INTO assignment(module_id, title, description, due_date) VALUES(?,?,?,?)";
            PreparedStatement ps = con.prepareStatement(q);

            ps.setInt(1, moduleId);
            ps.setString(2, title);
            ps.setString(3, desc);
            ps.setString(4, date);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("InstructorDashboardServlet");
    }
}