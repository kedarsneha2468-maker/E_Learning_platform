<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String admin = (String) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Instructor - EduStream</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary: #1a56db;
            --primary-dark: #1240a8;
            --accent: #f97316;
            --bg: #f5f7ff;
            --surface: #ffffff;
            --text: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --radius-sm: 8px;
            --radius-md: 14px;
            --radius-lg: 20px;
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
            border-radius: var(--radius-lg);
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
        }

        .form-label {
            font-weight: 600;
            margin-bottom: 0.4rem;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }
        .form-label i {
            color: var(--primary);
        }
        .form-control {
            padding: 0.7rem 0.9rem;
            border-radius: var(--radius-sm);
            border: 2px solid var(--border);
            font-size: 0.9rem;
            width: 100%;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(26,86,219,0.1);
            outline: none;
        }
        textarea.form-control {
            resize: vertical;
            min-height: 80px;
        }

        .btn-submit {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            color: white;
            font-weight: 600;
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
        .alert {
            padding: 0.75rem 1rem;
            border-radius: var(--radius-sm);
            margin-bottom: 1rem;
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

        @media (max-width: 576px) {
            .form-container {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>

<div class="form-container">
    <a href="AdminDashboardServlet" class="btn-back">
        <i class="bi bi-arrow-left"></i> Back to Dashboard
    </a>
    
    <div class="form-header">
        <div class="icon">
            <i class="bi bi-person-plus-fill"></i>
        </div>
        <h2>Add New Instructor</h2>
        <p class="text-muted">Register a new instructor to the platform</p>
    </div>
    
    <% if (error != null) { %>
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-triangle-fill"></i> <%= error %>
        </div>
    <% } %>
    
    <form action="AddInstructorServlet" method="post">
        <div class="mb-3">
            <label class="form-label">
                <i class="bi bi-person-fill"></i> Full Name *
            </label>
            <input type="text" name="name" class="form-control" placeholder="e.g., John Doe" required>
        </div>
        
        <div class="mb-3">
            <label class="form-label">
                <i class="bi bi-envelope-fill"></i> Email *
            </label>
            <input type="email" name="email" class="form-control" placeholder="instructor@example.com" required>
        </div>
        
        <div class="mb-3">
            <label class="form-label">
                <i class="bi bi-key-fill"></i> Password *
            </label>
            <input type="password" name="password" class="form-control" placeholder="Create a strong password" required>
        </div>
        
        <div class="mb-3">
            <label class="form-label">
                <i class="bi bi-star-fill"></i> Expertise *
            </label>
            <input type="text" name="expertise" class="form-control" placeholder="e.g., Java Programming, Web Development, Data Science, Cloud Computing, Cybersecurity" required>
            <small class="text-muted">Enter the instructor's area of expertise</small>
        </div>
        
        <div class="mb-3">
            <label class="form-label">
                <i class="bi bi-briefcase-fill"></i> Experience (years) *
            </label>
            <input type="number" name="experience" class="form-control" placeholder="e.g., 5" min="0" step="1" required>
        </div>
        
        <button type="submit" class="btn-submit">
            <i class="bi bi-person-plus-fill"></i> Add Instructor
        </button>
    </form>
</div>

</body>
</html>