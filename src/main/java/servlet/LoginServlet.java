package servlet;

import dao.StudentDAO;
import dao.InstructorDAO;
import model.Student;
import model.Instructor;
import java.io.*;
import javax.servlet.http.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("=== LOGIN ATTEMPT ===");
        System.out.println("Email: " + email);

        try {
            // 🔹 FIRST CHECK STUDENT
            StudentDAO sdao = new StudentDAO();
            Student student = sdao.loginStudent(email, password);

            if (student != null) {
                HttpSession session = request.getSession();
                session.setAttribute("student_id", student.getStudentId());
                session.setAttribute("name", student.getName());
                session.setAttribute("email", student.getEmail());
                session.setAttribute("role", "student");
                
                System.out.println("✅ Student login SUCCESS: " + student.getName());
                response.sendRedirect("StudentDashboardServlet");
                return;
            }

            // 🔹 THEN CHECK INSTRUCTOR
            InstructorDAO idao = new InstructorDAO();
            Instructor instructor = idao.loginInstructor(email, password);

            if (instructor != null) {
                HttpSession session = request.getSession();
                session.setAttribute("instructor_id", instructor.getInstructorId());
                session.setAttribute("name", instructor.getName());
                session.setAttribute("email", instructor.getEmail());
                session.setAttribute("expertise", instructor.getExpertise());
                session.setAttribute("experience", instructor.getExperience());
                session.setAttribute("role", "instructor");
                
                System.out.println("✅ Instructor login SUCCESS: " + instructor.getName());
                response.sendRedirect("InstructorDashboardServlet");
                return;
            }

            // 🔹 THEN CHECK ADMIN (if you have admin table)
            if ("admin@edustream.com".equals(email) && "admin123".equals(password)) {
                HttpSession session = request.getSession();
                session.setAttribute("admin", "Admin");
                session.setAttribute("role", "admin");
                System.out.println("✅ Admin login SUCCESS");
                response.sendRedirect("admin_dashboard.jsp");
                return;
            }

            // ❌ LOGIN FAILED
            System.out.println("❌ Login FAILED for email: " + email);
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } catch (Exception e) {
            System.out.println("Login ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}