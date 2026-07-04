package servlet;

import database.DBConnection;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/StudentReportServlet")
public class StudentReportServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Map<String, Object>> reportData = new ArrayList<>();
        int totalStudents = 0;
        int totalSubmissions = 0;
        double avgCompletion = 0;
        
        try (Connection conn = DBConnection.getConnection()) {
            
            // Call stored procedure with explicit cursor
            CallableStatement stmt = conn.prepareCall("{call get_submission_summary_report()}");
            ResultSet rs = stmt.executeQuery();
            
            // Process results
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("studentId", rs.getInt("student_id"));
                row.put("studentName", rs.getString("student_name"));
                row.put("email", rs.getString("email"));
                row.put("totalSubmitted", rs.getInt("total_submitted"));
                row.put("gradedCount", rs.getInt("graded_count"));
                row.put("lateCount", rs.getInt("late_count"));
                
                String completionRate = rs.getString("completion_rate");
                row.put("completionRate", completionRate);
                
                reportData.add(row);
                
                // Calculate statistics
                totalStudents++;
                totalSubmissions += rs.getInt("total_submitted");
                
                // Parse completion rate for average
                String rateStr = completionRate.replace("%", "");
                if (!rateStr.equals("0")) {
                    avgCompletion += Double.parseDouble(rateStr);
                }
            }
            
            // Calculate average
            if (totalStudents > 0) {
                avgCompletion = avgCompletion / totalStudents;
            }
            
            rs.close();
            stmt.close();
            
            // Set attributes for JSP
            request.setAttribute("reportData", reportData);
            request.setAttribute("totalStudents", totalStudents);
            request.setAttribute("totalSubmissions", totalSubmissions);
            request.setAttribute("avgCompletion", Math.round(avgCompletion));
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error generating report: " + e.getMessage());
        }
        
        request.getRequestDispatcher("student_report.jsp").forward(request, response);
    }
}