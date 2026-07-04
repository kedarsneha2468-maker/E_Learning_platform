package servlet;

import database.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/AddInstructorServlet")
public class AddInstructorServlet extends HttpServlet {

    // Handle GET request - Show the add instructor form
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Forward to the add instructor JSP page
        request.getRequestDispatcher("add_instructor.jsp").forward(request, response);
    }

    // Handle POST request - Process the form submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String expertise = request.getParameter("expertise");
        int experience = Integer.parseInt(request.getParameter("experience"));

        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();

            // 🔐 Hash password
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            // ✅ INSERT DIRECTLY INTO INSTRUCTOR TABLE
            String query = "INSERT INTO instructor(name, email, password, expertise, experience) VALUES(?, ?, ?, ?, ?)";

            ps = con.prepareStatement(query);

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);
            ps.setString(4, expertise);
            ps.setInt(5, experience);

            int result = ps.executeUpdate();

            if (result > 0) {
                // Success - redirect to dashboard with success message
                response.sendRedirect("admin_dashboard.jsp?success=Instructor added successfully: " + name);
            } else {
                // Failed - redirect back to form with error
                response.sendRedirect("add_instructor.jsp?error=Failed to add instructor");
            }
            
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add_instructor.jsp?error=Database error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (con != null) con.close(); } catch (SQLException e) {}
        }
    }
}