<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    Integer instructorId = (Integer) session.getAttribute("instructor_id");
    if (instructorId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    int moduleId = Integer.parseInt(request.getParameter("moduleId"));
    int courseId = Integer.parseInt(request.getParameter("courseId"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Video - EduStream</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary: #1a56db;
            --accent: #f97316;
            --bg: #f5f7ff;
            --surface: #ffffff;
            --border: #e2e8f0;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: linear-gradient(135deg, var(--bg) 0%, #eef2ff 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }

        .form-container {
            max-width: 550px;
            width: 100%;
            background: rgba(255,255,255,0.96);
            backdrop-filter: blur(12px);
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 12px 40px rgba(26,86,219,0.12);
            border: 1px solid rgba(255,255,255,0.5);
        }

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
        }
        .form-header h2 {
            font-family: 'Sora', sans-serif;
            font-size: 1.6rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .form-control {
            padding: 0.7rem 0.9rem;
            border-radius: 8px;
            border: 2px solid var(--border);
            font-size: 0.9rem;
            width: 100%;
        }
        .form-control:focus {
            border-color: var(--primary);
            outline: none;
        }

        .btn-submit {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            color: white;
            font-weight: 600;
            padding: 0.75rem;
            border: none;
            border-radius: 8px;
            width: 100%;
            margin-top: 1rem;
        }
        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
            padding: 0.5rem 1rem;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 8px;
            text-decoration: none;
            color: var(--text);
        }
    </style>
</head>
<body>

<div class="form-container">
    <a href="ViewModuleServlet?courseId=<%= courseId %>" class="btn-back">
        <i class="bi bi-arrow-left"></i> Back to Modules
    </a>
    
    <div class="form-header">
        <div class="icon">
            <i class="bi bi-camera-reels-fill"></i>
        </div>
        <h2>Add New Video</h2>
        <p class="text-muted">Add video content to this module</p>
    </div>
    
    <form action="AddVideoServlet" method="post">
        <input type="hidden" name="moduleId" value="<%= moduleId %>">
        <input type="hidden" name="courseId" value="<%= courseId %>">
        
        <div class="mb-3">
            <label class="form-label">Video Title</label>
            <input type="text" name="title" class="form-control" placeholder="e.g., Introduction to Java" required>
        </div>
        
        <div class="mb-3">
            <label class="form-label">Video URL</label>
            <input type="text" name="videoUrl" class="form-control" placeholder="https://www.youtube.com/embed/..." required>
        </div>
        
        <div class="mb-3">
            <label class="form-label">Duration</label>
            <input type="text" name="duration" class="form-control" placeholder="e.g., 15 minutes" required>
        </div>
        
        <button type="submit" class="btn-submit">
            <i class="bi bi-plus-circle"></i> Add Video
        </button>
    </form>
</div>

</body>
</html>