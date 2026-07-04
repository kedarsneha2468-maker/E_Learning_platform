package servlet;

import dao.SubmissionDAO;
import database.DBConnection;
import dao.AssignmentDAO;
import model.Assignment;
import model.Submission;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;
import java.util.Date;

@WebServlet("/SubmitAssignmentServlet")
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024,
    fileSizeThreshold = 1024 * 1024
)
public class SubmitAssignmentServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer studentId = (Integer) session.getAttribute("student_id");
        
        if (studentId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        
        AssignmentDAO assignDAO = new AssignmentDAO();
        Assignment assignment = assignDAO.getAssignmentById(assignmentId);
        
        SubmissionDAO subDAO = new SubmissionDAO();
        Submission existingSubmission = subDAO.getSubmission(assignmentId, studentId);
        
        request.setAttribute("assignment", assignment);
        request.setAttribute("submission", existingSubmission);
        request.setAttribute("courseId", courseId);
        request.getRequestDispatcher("submit_assignment.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer studentId = (Integer) session.getAttribute("student_id");
        
        if (studentId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String submissionText = request.getParameter("submissionText");
        boolean isLate = checkIfLate(assignmentId);
        
        Submission submission = new Submission();
        submission.setAssignmentId(assignmentId);
        submission.setStudentId(studentId);
        submission.setSubmissionText(submissionText);
        if (isLate) {
            submission.setStatus("late");  // Mark as late
        } else {
            submission.setStatus("submitted");  // On time
        }
        
        
        // Handle file upload
        try {
            Part filePart = request.getPart("file");
            if (filePart != null && filePart.getSize() > 0) 
            {
                String fileName = extractFileName(filePart);
                String fileType = getFileExtension(fileName);
                
                if (!"pdf".equalsIgnoreCase(fileType)) {
                    response.sendRedirect("SubmitAssignmentServlet?assignmentId=" + assignmentId + 
                        "&courseId=" + courseId + "&error=Only PDF files are allowed");
                    return;
                }
                
                if (filePart.getSize() > 5 * 1024 * 1024) {
                    response.sendRedirect("SubmitAssignmentServlet?assignmentId=" + assignmentId + 
                        "&courseId=" + courseId + "&error=File size exceeds 5MB");
                    return;
                }
                
                String uploadPath = getServletContext().getRealPath("") + "uploads" + java.io.File.separator;
                java.io.File uploadDir = new java.io.File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                
                String uniqueFileName = System.currentTimeMillis() + "_" + studentId + "_" + fileName;
                filePart.write(uploadPath + uniqueFileName);
                submission.setFilePath("uploads/" + uniqueFileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        SubmissionDAO dao = new SubmissionDAO();
        boolean submitted = dao.submitAssignment(submission);
        
        if (submitted) {
            // ✅ Success message with redirect
            response.sendRedirect("CourseDetailsServlet?courseId=" + courseId + "&msg=submitted");
        } else {
            response.sendRedirect("SubmitAssignmentServlet?assignmentId=" + assignmentId + 
                "&courseId=" + courseId + "&error=Failed to submit assignment");
        }
    }
    
    
    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
    
    private String getFileExtension(String fileName) {
        if (fileName == null || fileName.lastIndexOf(".") == -1) {
            return "";
        }
        return fileName.substring(fileName.lastIndexOf(".") + 1);
    }
    
    private boolean checkIfLate(int assignmentId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT due_date FROM assignment WHERE assignment_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, assignmentId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                Date dueDate = rs.getDate("due_date");
                if (dueDate != null) {
                    Date currentDate = new Date();
                    return currentDate.after(dueDate);  // True if current date > due date
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}