package servlet;

import dao.AdminDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

import javax.servlet.annotation.WebServlet;

@WebServlet("/AdminSignupServlet")
public class AdminSignupServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");

        AdminDAO dao = new AdminDAO();

        boolean status = dao.registerAdmin(username,password,email);

        if(status){

            response.sendRedirect("admin_login.jsp");

        }else{

            request.setAttribute("error","Signup Failed");

            RequestDispatcher rd=request.getRequestDispatcher("admin_signup.jsp");
            rd.forward(request,response);

        }
    }
}