<%@ page import="java.util.*, model.Assignment" %>
<%@ page session="true" %>
<%
    Integer instructorId = (Integer) session.getAttribute("instructor_id");
    if (instructorId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Assignment> assignments = (List<Assignment>) request.getAttribute("assignments");
    String courseIdParam = request.getParameter("courseId");
    int courseId = 0;
    if (courseIdParam != null && !courseIdParam.isEmpty()) {
        courseId = Integer.parseInt(courseIdParam);
    }
    
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Assignments - EduStream</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary: #1a56db;
            --primary-light: #e8effe;
            --accent: #f97316;
            --bg: #f5f7ff;
            --surface: #ffffff;
            --text: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --success: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
            --info: #3b82f6;
            --radius-sm: 8px;
            --radius-md: 14px;
            --radius-lg: 20px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: linear-gradient(135deg, var(--bg) 0%, #eef2ff 100%);
            color: var(--text);
            min-height: 100vh;
            padding: 2rem;
        }

        /* Navbar */
        .navbar {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border);
            padding: 0.85rem 0;
            position: sticky;
            top: 0;
            z-index: 100;
            margin-bottom: 2rem;
            border-radius: var(--radius-lg);
        }

        .logo {
            font-family: 'Sora', sans-serif;
            font-size: 1.55rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-decoration: none;
        }

        /* Main Container */
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Header Section */
        .header-section {
            background: var(--surface);
            border-radius: var(--radius-lg);
            padding: 1.5rem 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .header-section h1 {
            font-family: 'Sora', sans-serif;
            font-size: 1.5rem;
            font-weight: 700;
            margin: 0;
        }
        .header-section h1 i {
            color: var(--primary);
            margin-right: 0.5rem;
        }

        /* Alert Messages */
        .alert {
            border-radius: var(--radius-sm);
            padding: 1rem 1.25rem;
            margin-bottom: 1.5rem;
            border: none;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            animation: slideIn 0.5s ease;
        }
        .alert-success {
            background: #d1fae5;
            color: #059669;
            border-left: 4px solid #059669;
        }
        .alert-danger {
            background: #fee2e2;
            color: #dc2626;
            border-left: 4px solid #dc2626;
        }
        
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Buttons */
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            border: none;
            padding: 0.6rem 1.2rem;
            border-radius: var(--radius-sm);
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(26,86,219,0.3);
        }
        .btn-secondary {
            background: #6c757d;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: var(--radius-sm);
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        .btn-info {
            background: linear-gradient(135deg, var(--info), #2563eb);
            border: none;
            color: white;
            padding: 0.4rem 0.8rem;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-info:hover {
            transform: translateY(-2px);
            color: white;
        }

        /* Assignment Card */
        .assignment-card {
            background: var(--surface);
            border-radius: var(--radius-md);
            padding: 1.25rem;
            margin-bottom: 1rem;
            border: 1px solid var(--border);
            transition: all 0.3s ease;
        }
        .assignment-card:hover {
            transform: translateX(5px);
            box-shadow: var(--shadow-md);
            border-left: 3px solid var(--primary);
        }
        .assignment-title {
            font-family: 'Sora', sans-serif;
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text);
            margin-bottom: 0.5rem;
        }
        .assignment-description {
            color: var(--text-muted);
            font-size: 0.85rem;
            margin-bottom: 0.75rem;
            line-height: 1.5;
        }
        .assignment-meta {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            font-size: 0.75rem;
            color: var(--text-muted);
        }
        .assignment-meta i {
            margin-right: 0.25rem;
            color: var(--primary);
        }
        .assignment-actions {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem;
            background: var(--surface);
            border-radius: var(--radius-md);
            border: 1px solid var(--border);
        }
        .empty-state i {
            font-size: 3rem;
            color: var(--border);
            margin-bottom: 1rem;
        }
        .empty-state h4 {
            font-family: 'Sora', sans-serif;
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
        }
        .empty-state p {
            color: var(--text-muted);
            margin-bottom: 1rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }
            .header-section {
                flex-direction: column;
                text-align: center;
            }
            .assignment-card {
                padding: 1rem;
            }
            .assignment-actions {
                margin-top: 0.75rem;
            }
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <div class="container">
        <a class="logo" href="InstructorDashboardServlet">
            <i class="bi bi-mortarboard-fill"></i>
            Edu<span style="color:var(--accent)">Stream</span> Instructor
        </a>
        <div>
            <span class="text-muted">
                <i class="bi bi-person-circle"></i> <%= session.getAttribute("name") %>
            </span>
        </div>
    </div>
</nav>

<div class="main-container">
    
    <!-- Success Message -->
    <% if (success != null && !success.isEmpty()) { %>
        <div class="alert alert-success" id="successAlert">
            <i class="bi bi-check-circle-fill"></i> <%= success %>
        </div>
    <% } %>
    
    <!-- Error Message -->
    <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-danger" id="errorAlert">
            <i class="bi bi-exclamation-triangle-fill"></i> <%= error %>
        </div>
    <% } %>
    <!-- Back Button -->
    <a href="InstructorDashboardServlet" class="btn btn-secondary mb-3">
        <i class="bi bi-arrow-left"></i> Back to Dashboard
    </a>
    <!-- Header Section -->
    <div class="header-section">
        <div>
            <h1>
                <i class="bi bi-file-text"></i> Course Assignments
            </h1>
            <p class="text-muted mb-0">Manage assignments for this course</p>
        </div>
        <div>
            <a href="CreateAssignmentServlet?courseId=<%= courseId %>" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> Create New Assignment
            </a>
        </div>
    </div>
    
    
    
    <!-- Assignments List -->
    <% if (assignments != null && !assignments.isEmpty()) { %>
        <div class="assignments-list">
            <% for (Assignment a : assignments) { %>
                <div class="assignment-card">
                    <div class="row align-items-start">
                        <div class="col-md-8">
                            <div class="assignment-title">
                                <i class="bi bi-file-earmark-text"></i> <%= a.getTitle() %>
                            </div>
                            <div class="assignment-description">
                                <%= a.getDescription() != null && !a.getDescription().isEmpty() ? a.getDescription() : "No description provided" %>
                            </div>
                            <div class="assignment-meta">
                                <span><i class="bi bi-star"></i> Total Marks: <%= a.getTotalMarks() %></span>
                                <span><i class="bi bi-calendar"></i> Due Date: <%= a.getDueDate() != null ? a.getDueDate() : "No deadline" %></span>
                                <span><i class="bi bi-clock"></i> Created: <%= a.getCreatedAt() != null ? a.getCreatedAt() : "N/A" %></span>
                            </div>
                        </div>
                        <div class="col-md-4 text-md-end assignment-actions">
                            <a href="ViewSubmissionServlet?assignmentId=<%= a.getAssignmentId() %>" class="btn btn-info">
                                <i class="bi bi-people"></i> View Submissions
                            </a>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <div class="empty-state">
            <i class="bi bi-inbox"></i>
            <h4>No Assignments Yet</h4>
            <p>You haven't created any assignments for this course yet.</p>
            <a href="CreateAssignmentServlet?courseId=<%= courseId %>" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> Create Your First Assignment
            </a>
        </div>
    <% } %>
    
</div>

<script>
    // Auto hide success/error messages after 5 seconds
    setTimeout(function() {
        var successAlert = document.getElementById('successAlert');
        var errorAlert = document.getElementById('errorAlert');
        
        if (successAlert) {
            successAlert.style.transition = 'opacity 0.5s ease';
            successAlert.style.opacity = '0';
            setTimeout(function() {
                if (successAlert) successAlert.style.display = 'none';
            }, 500);
        }
        
        if (errorAlert) {
            errorAlert.style.transition = 'opacity 0.5s ease';
            errorAlert.style.opacity = '0';
            setTimeout(function() {
                if (errorAlert) errorAlert.style.display = 'none';
            }, 500);
        }
    }, 5000);
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>