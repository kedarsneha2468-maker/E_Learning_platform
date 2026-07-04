package servlet;

import dao.AssignmentDAO;
import model.Assignment;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ViewAssignmentServlet") 
public class ViewAssignmentServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== ViewAssignmentsServlet START ===");
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        
        if (role == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String courseIdParam = request.getParameter("courseId");
        if (courseIdParam == null || courseIdParam.isEmpty()) {
            response.sendRedirect("instructor_dashboard.jsp?error=Invalid course");
            return;
        }
        
        int courseId = Integer.parseInt(courseIdParam);
        System.out.println("Viewing assignments for course ID: " + courseId);
        
        AssignmentDAO dao = new AssignmentDAO();
        List<Assignment> assignments = dao.getAssignmentsByCourse(courseId);
        
        System.out.println("Assignments found: " + (assignments != null ? assignments.size() : 0));
        
        request.setAttribute("assignments", assignments);
        request.setAttribute("courseId", courseId);
        
        // Forward to JSP to display assignments
        request.getRequestDispatcher("view_assignment.jsp").forward(request, response);
    }
}