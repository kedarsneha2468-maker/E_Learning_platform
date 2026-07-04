<%@ page import="java.util.*, model.Assignment, model.Submission" %>
<%@ page session="true" %>
<%
    Integer studentId = (Integer) session.getAttribute("student_id");
    if (studentId == null) {
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
        .status-badge { padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }
        .status-submitted { background: #d1fae5; color: #059669; }
        .status-pending { background: #fed7aa; color: #c2410c; }
        .status-graded { background: #dbeafe; color: #1d4ed8; }
    </style>
</head>
<body>
<div class="container">
    <h2 class="mb-4"><i class="bi bi-file-text"></i> Course Assignments</h2>
    <a href="CourseDetailsServlet?courseId=<%= courseId %>" class="btn btn-secondary mb-3">
        <i class="bi bi-arrow-left"></i> Back to Course
    </a>
    
    <% if (assignments != null && !assignments.isEmpty()) { %>
        <% for (Assignment a : assignments) { 
            Submission submission = (Submission) request.getAttribute("submission_" + a.getAssignmentId());
            String status = submission != null ? submission.getStatus() : "pending";
        %>
            <div class="card p-3">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <h5><%= a.getTitle() %></h5>
                        <p class="text-muted mb-1"><%= a.getDescription() %></p>
                        <small>
                            <i class="bi bi-star"></i> Marks: <%= a.getTotalMarks() %> |
                            <i class="bi bi-calendar"></i> Due: <%= a.getDueDate() != null ? a.getDueDate() : "No deadline" %>
                        </small>
                        <br>
                        <% if (submission != null && "graded".equals(status)) { %>
                            <small class="text-success">
                                <i class="bi bi-check-circle"></i> Your Score: <%= submission.getMarksObtained() %>/<%= a.getTotalMarks() %>
                            </small>
                        <% } %>
                    </div>
                    <div>
                        <span class="status-badge status-<%= status %>">
                            <%= "submitted".equals(status) ? "Submitted" : ("graded".equals(status) ? "Graded" : "Pending") %>
                        </span>
                        <a href="SubmitAssignmentServlet?assignmentId=<%= a.getAssignmentId() %>" class="btn btn-sm btn-primary mt-2 d-block">
                            <%= submission != null ? "Edit Submission" : "Submit Assignment" %>
                        </a>
                    </div>
                </div>
                <% if (submission != null && submission.getFeedback() != null && !submission.getFeedback().isEmpty()) { %>
                    <div class="alert alert-info mt-2 mb-0">
                        <i class="bi bi-chat"></i> Feedback: <%= submission.getFeedback() %>
                    </div>
                <% } %>
            </div>
        <% } %>
    <% } else { %>
        <div class="text-center p-5 bg-white rounded">
            <i class="bi bi-inbox" style="font-size: 3rem; color: #ccc;"></i>
            <h4>No Assignments Yet</h4>
            <p>No assignments have been posted for this course.</p>
        </div>
    <% } %>
</div>
</body>
</html>