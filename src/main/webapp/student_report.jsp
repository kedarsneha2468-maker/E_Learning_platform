<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Submission Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 3px solid #4CAF50;
            padding-bottom: 10px;
        }
        .info-box {
            background: #e3f2fd;
            border-left: 4px solid #2196F3;
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th {
            background: #4CAF50;
            color: white;
            padding: 12px;
            text-align: left;
        }
        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .badge {
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
        }
        .badge-success {
            background: #d4edda;
            color: #155724;
        }
        .badge-warning {
            background: #fff3cd;
            color: #856404;
        }
        .badge-danger {
            background: #f8d7da;
            color: #721c24;
        }
        .badge-info {
            background: #d1ecf1;
            color: #0c5460;
        }
        button {
            background: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            margin-bottom: 20px;
        }
        button:hover {
            background: #45a049;
        }
        .stats {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            border-radius: 8px;
            flex: 1;
            text-align: center;
        }
        .stat-card h3 {
            margin: 0;
            font-size: 14px;
        }
        .stat-card p {
            margin: 10px 0 0;
            font-size: 24px;
            font-weight: bold;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .no-data {
            background: #fff3cd;
            color: #856404;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📊 Student Submission Report</h1>
        
        <!-- Display error if any -->
        <% if(request.getAttribute("error") != null) { %>
            <div class="error">
                <strong>Error:</strong> <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <div class="info-box">
            <strong>ℹ️ Report Information:</strong>
            <ul>
                <li>Shows all students and their assignment submission status</li>
                <li>Displays total submissions, graded count, and late submissions</li>
                <li>Completion rate shows percentage of graded assignments</li>
            </ul>
        </div>
        
        <form action="StudentReportServlet" method="get">
            <button type="submit">🔄 Refresh Report</button>
        </form>
        
        <% 
            List<Map<String, Object>> reportData = (List<Map<String, Object>>) request.getAttribute("reportData");
            Integer totalStudents = (Integer) request.getAttribute("totalStudents");
            Integer totalSubmissions = (Integer) request.getAttribute("totalSubmissions");
            Long avgCompletion = (Long) request.getAttribute("avgCompletion");
            
            if(reportData != null && !reportData.isEmpty()) { 
        %>
            <!-- Statistics Summary -->
            <div class="stats">
                <div class="stat-card">
                    <h3>Total Students</h3>
                    <p><%= totalStudents != null ? totalStudents : 0 %></p>
                </div>
                <div class="stat-card">
                    <h3>Total Submissions</h3>
                    <p><%= totalSubmissions != null ? totalSubmissions : 0 %></p>
                </div>
                <div class="stat-card">
                    <h3>Average Completion</h3>
                    <p><%= avgCompletion != null ? avgCompletion : 0 %>%</p>
                </div>
            </div>
            
            <!-- Data Table -->
            <table>
                <thead>
                    <tr>
                        <th>Student ID</th>
                        <th>Student Name</th>
                        <th>Email</th>
                        <th>Total Submissions</th>
                        <th>Graded</th>
                        <th>Late</th>
                        <th>Completion Rate</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(Map<String, Object> student : reportData) { %>
                        <tr>
                            <td><%= student.get("studentId") %></td>
                            <td><strong><%= student.get("studentName") %></strong></td>
                            <td><%= student.get("email") %></td>
                            <td><%= student.get("totalSubmitted") %></td>
                            <td>
                                <span class="badge badge-success">✓ <%= student.get("gradedCount") %></span>
                            </td>
                            <td>
                                <% Integer lateCount = (Integer) student.get("lateCount"); %>
                                <% if(lateCount > 0) { %>
                                    <span class="badge badge-danger">⚠ <%= lateCount %></span>
                                <% } else { %>
                                    <span class="badge badge-info">0</span>
                                <% } %>
                            </td>
                            <td>
                                <% String completionRate = (String) student.get("completionRate"); %>
                                <span class="badge <%= "100%".equals(completionRate) ? "badge-success" : ("0%".equals(completionRate) ? "badge-danger" : "badge-warning") %>">
                                    <%= completionRate %>
                                </span>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <div class="no-data">
                <p>📭 No data found. Please ensure:</p>
                <ul style="text-align: left;">
                    <li>The stored procedure exists in your database</li>
                    <li>You have students and submissions in your database</li>
                    <li>The servlet is properly configured</li>
                </ul>
            </div>
        <% } %>
    </div>
</body>
</html>