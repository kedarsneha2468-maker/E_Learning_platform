<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.*" %>
<%
    Integer instructorId = (Integer) session.getAttribute("instructor_id");
    if (instructorId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int courseId = Integer.parseInt(request.getParameter("courseId"));
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Create Assignment - EduStream</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --primary: #1a56db;
            --accent: #f97316;
            --bg: #f5f7ff;
        }
        body {
            font-family: 'DM Sans', sans-serif;
            background: linear-gradient(135deg, var(--bg) 0%, #eef2ff 100%);
            min-height: 100vh;
            padding: 2rem;
        }
        .form-container {
            max-width: 700px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 12px 40px rgba(0,0,0,0.1);
        }
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            border: none;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="form-container">
        <h2><i class="bi bi-plus-circle"></i> Create New Assignment</h2>
        <hr>
        
        <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>
        
        <form action="CreateAssignmentServlet" method="post">
            <input type="hidden" name="courseId" value="<%= courseId %>">
            
            <div class="mb-3">
                <label class="form-label">Assignment Title *</label>
                <input type="text" name="title" class="form-control" required>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="5"></textarea>
            </div>
            
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Total Marks *</label>
                    <input type="number" name="totalMarks" class="form-control" value="100" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Due Date</label>
                    <input type="date" name="dueDate" class="form-control">
                </div>
            </div>
            
            <button type="submit" class="btn btn-primary w-100">
                <i class="bi bi-save"></i> Create Assignment
            </button>
            <a href="ViewAssignmentServlet?courseId=<%= courseId %>" class="btn btn-secondary w-100 mt-2">
                Cancel
            </a>
        </form>
    </div>
</div>
</body>
</html>