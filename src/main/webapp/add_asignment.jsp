<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    Integer instructorId = (Integer) session.getAttribute("instructor_id");
    if (instructorId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int courseId = Integer.parseInt(request.getParameter("courseId"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Assignment - EduStream</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary: #1a56db;
            --primary-dark: #1240a8;
            --primary-light: #e8effe;
            --accent: #f97316;
            --accent-light: #fff4ed;
            --bg: #f5f7ff;
            --surface: #ffffff;
            --text: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --success: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
            --radius-sm: 8px;
            --radius-md: 14px;
            --radius-lg: 20px;
            --shadow-sm: 0 1px 4px rgba(0,0,0,0.06);
            --shadow-md: 0 4px 20px rgba(0,0,0,0.08);
            --shadow-lg: 0 12px 40px rgba(26,86,219,0.12);
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            position: relative;
        }

        /* Background decoration */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200"><path fill="%231a56db" fill-opacity="0.03" d="M100 0L200 100L100 200L0 100L100 0Z"/></svg>');
            background-repeat: repeat;
            background-size: 40px;
            pointer-events: none;
        }

        /* Navbar */
        .navbar {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border);
            padding: 0.85rem 0;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 100;
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

        /* Form Container */
        .form-container {
            max-width: 600px;
            width: 100%;
            background: rgba(255,255,255,0.96);
            backdrop-filter: blur(12px);
            border-radius: var(--radius-lg);
            padding: 2rem;
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(255,255,255,0.5);
            position: relative;
            z-index: 1;
            transition: transform 0.3s ease;
            margin-top: 80px;
        }

        .form-container:hover {
            transform: translateY(-5px);
        }

        /* Header */
        .form-header {
            text-align: center;
            margin-bottom: 1.8rem;
        }
        .form-header .icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary), #2563eb);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            box-shadow: 0 8px 20px rgba(26,86,219,0.2);
        }
        .form-header .icon i {
            font-size: 28px;
            color: white;
        }
        .form-header h2 {
            font-family: 'Sora', sans-serif;
            font-size: 1.6rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.25rem;
        }
        .form-header p {
            color: var(--text-muted);
            font-size: 0.85rem;
        }

        /* Form Elements */
        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-label {
            font-weight: 600;
            color: var(--text);
            margin-bottom: 0.4rem;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }
        .form-label i {
            color: var(--primary);
            font-size: 0.85rem;
        }

        .form-control {
            padding: 0.7rem 0.9rem;
            border-radius: var(--radius-sm);
            border: 2px solid var(--border);
            font-size: 0.9rem;
            transition: all 0.3s ease;
            font-family: 'DM Sans', sans-serif;
            width: 100%;
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(26,86,219,0.1);
            outline: none;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }

        /* Buttons */
        .btn-submit {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            color: white;
            font-weight: 600;
            font-size: 0.95rem;
            padding: 0.75rem;
            border: none;
            border-radius: var(--radius-sm);
            width: 100%;
            margin-top: 0.5rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(26,86,219,0.3);
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            padding: 0.5rem 1rem;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            text-decoration: none;
            color: var(--text);
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }
        .btn-back:hover {
            background: var(--primary-light);
            color: var(--primary);
        }

        /* Alert Messages */
        .alert {
            border-radius: var(--radius-sm);
            padding: 0.75rem 1rem;
            margin-bottom: 1rem;
            border: none;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .alert-danger {
            background: #fee2e2;
            color: #dc2626;
            border-left: 4px solid #dc2626;
        }
        .alert-success {
            background: #d1fae5;
            color: #059669;
            border-left: 4px solid #059669;
        }

        /* Responsive */
        @media (max-width: 576px) {
            body {
                padding: 1rem;
            }
            .form-container {
                padding: 1.5rem;
                margin-top: 70px;
            }
        }
    </style>

    <script>
        function validateForm() {
            let title = document.querySelector("input[name='title']").value.trim();
            
            if (title === "") {
                alert("Please enter assignment title!");
                return false;
            }
            
            return true;
        }
    </script>
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

<div class="form-container">
    <a href="ViewAssignmentsServlet?courseId=<%= courseId %>" class="btn-back">
        <i class="bi bi-arrow-left"></i> Back to Assignments
    </a>
    
    <div class="form-header">
        <div class="icon">
            <i class="bi bi-file-text-fill"></i>
        </div>
        <h2>Create New Assignment</h2>
        <p>Add assignment for students to complete</p>
    </div>
    
    <form action="CreateAssignmentServlet" method="post" onsubmit="return validateForm()">
        <input type="hidden" name="courseId" value="<%= courseId %>">
        
        <div class="form-group">
            <label class="form-label">
                <i class="bi bi-pencil-fill"></i> Assignment Title *
            </label>
            <input type="text" name="title" class="form-control" placeholder="e.g., Java Programming Assignment 1" required>
        </div>
        
        <div class="form-group">
            <label class="form-label">
                <i class="bi bi-file-earmark-text"></i> Description
            </label>
            <textarea name="description" class="form-control" placeholder="Describe what students need to do..."></textarea>
        </div>
        
        <div class="form-group">
            <label class="form-label">
                <i class="bi bi-star-fill"></i> Total Marks *
            </label>
            <input type="number" name="totalMarks" class="form-control" placeholder="e.g., 100" value="100" required>
        </div>
        
        <div class="form-group">
            <label class="form-label">
                <i class="bi bi-calendar-fill"></i> Due Date
            </label>
            <input type="date" name="dueDate" class="form-control">
            <small class="text-muted">Leave empty if no deadline</small>
        </div>
        
        <button type="submit" class="btn-submit">
            <i class="bi bi-plus-circle"></i> Create Assignment
        </button>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>