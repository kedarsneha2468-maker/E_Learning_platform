<%@ page import="java.util.*, model.Assignment" %>
<%@ page session="true" %>
<%
    Integer instructorId = (Integer) session.getAttribute("instructor_id");
    if (instructorId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Assignment> assignments = (List<Assignment>) request.getAttribute("assignments");
    int courseId = Integer.parseInt(request.getParameter("courseId"));
%>
<!DOCTYPE html>
<html>
<head>
    <title>Assignments - EduStream</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { background: #f5f7ff; font-family: 'DM Sans', sans-serif; padding: 2rem; }
        .card { border-radius: 15px; border: none; box-shadow: 0 2px 10px rgba(0,0,0,0.08); margin-bottom: 1rem; }
        .btn-primary { background: linear-gradient(135deg, #1a56db, #2563eb); border: none; }
    </style>
</head>
<body>
<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-file-text"></i> Course Assignments</h2>
        <a href="CreateAssignmentServlet?courseId=<%= courseId %>" class="btn btn-primary">
            <i class="bi bi-plus-circle"></i> Create Assignment
        </a>
    </div>
    
    <a href="InstructorDashboardServlet" class="btn btn-secondary mb-3">
        <i class="bi bi-arrow-left"></i> Back to Dashboard
    </a>
    
    <% if (assignments != null && !assignments.isEmpty()) { %>
        <% for (Assignment a : assignments) { %>
            <div class="card p-3">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <h5><%= a.getTitle() %></h5>
                        <p class="text-muted mb-1"><%= a.getDescription() %></p>
                        <small>
                            <i class="bi bi-star"></i> Total Marks: <%= a.getTotalMarks() %> |
                            <i class="bi bi-calendar"></i> Due: <%= a.getDueDate() != null ? a.getDueDate() : "No deadline" %>
                        </small>
                    </div>
                    <div>
                        <a href="ViewSubmissionsServlet?assignmentId=<%= a.getAssignmentId() %>" class="btn btn-sm btn-info">
                            <i class="bi bi-people"></i> View Submissions
                        </a>
                    </div>
                </div>
            </div>
        <% } %>
    <% } else { %>
        <div class="text-center p-5 bg-white rounded">
            <i class="bi bi-inbox" style="font-size: 3rem; color: #ccc;"></i>
            <h4>No Assignments Yet</h4>
            <p>Click "Create Assignment" to add one.</p>
        </div>
    <% } %>
</div>
</body>
</html>