package servlet;

import dao.AdminDAO;


import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

import javax.servlet.annotation.WebServlet;
@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        AdminDAO dao = new AdminDAO();

        boolean status = dao.loginAdmin(username, password);

        if (status) {

            HttpSession session = request.getSession();
            session.setAttribute("admin", username);

            response.sendRedirect("AdminDashboardServlet");

        } else {

            request.setAttribute("error", "Invalid Admin Credentials");
            RequestDispatcher rd = request.getRequestDispatcher("admin_login.jsp");
            rd.forward(request, response);

        }
    }
}