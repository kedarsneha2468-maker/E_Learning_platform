package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AdminLogoutServlet")
public class AdminLogoutServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // get existing session
        HttpSession session = request.getSession(false);

        // invalidate session
        if (session != null) {
            session.invalidate();
        }

        // redirect to login page
        response.sendRedirect("admin_login.jsp");
    }
}