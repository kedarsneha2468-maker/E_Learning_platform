package servlet;

import dao.AssignmentDAO;
import model.Assignment;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CreateAssignmentServlet")
public class CreateAssignmentServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    // Handle GET request - Show the create assignment form
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== CreateAssignmentServlet doGet START ===");
        
        HttpSession session = request.getSession();
        Integer instructorId = (Integer) session.getAttribute("instructor_id");
        
        if (instructorId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String courseIdParam = request.getParameter("courseId");
        if (courseIdParam == null || courseIdParam.isEmpty()) {
            response.sendRedirect("instructor_dashboard.jsp?error=Invalid course");
            return;
        }
        
        int courseId = Integer.parseInt(courseIdParam);
        request.setAttribute("courseId", courseId);
        request.getRequestDispatcher("create_assignment.jsp").forward(request, response);
    }
    
    // Handle POST request - Create the assignment
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== CreateAssignmentServlet doPost START ===");
        
        HttpSession session = request.getSession();
        Integer instructorId = (Integer) session.getAttribute("instructor_id");
        
        if (instructorId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        int totalMarks = Integer.parseInt(request.getParameter("totalMarks"));
        String dueDateStr = request.getParameter("dueDate");
        
        Assignment assignment = new Assignment();
        assignment.setCourseId(courseId);
        assignment.setInstructorId(instructorId);
        assignment.setTitle(title);
        assignment.setDescription(description);
        assignment.setTotalMarks(totalMarks);
        
        if (dueDateStr != null && !dueDateStr.isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date dueDate = sdf.parse(dueDateStr);
                assignment.setDueDate(dueDate);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        AssignmentDAO dao = new AssignmentDAO();
        boolean created = dao.createAssignment(assignment);
        
        if (created) {
            // ✅ Redirect back to instructor dashboard with success message
            response.sendRedirect("InstructorDashboardServlet?success=Assignment '" + title + "' created successfully for this course");
        } else {
            response.sendRedirect("CreateAssignmentServlet?courseId=" + courseId + "&error=Failed to create assignment");
        }
    }
}