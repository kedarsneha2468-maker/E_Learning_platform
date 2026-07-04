<%@ page import="java.util.*, model.Course" %>
<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String name = (String) session.getAttribute("name");
    List<Course> enrolledCourses = (List<Course>) request.getAttribute("enrolledCourses");
    
    if (session.getAttribute("student_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Calculate stats
    int totalCourses = enrolledCourses != null ? enrolledCourses.size() : 0;
    int completedCourses = 0;
    if (enrolledCourses != null) {
        for (Course c : enrolledCourses) {
            if (c.isCompleted()) {
                completedCourses++;
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Courses - EduStream</title>
    
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
        }

        .navbar {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border);
            padding: 0.85rem 0;
            position: sticky;
            top: 0;
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

        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .page-header {
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .page-header h1 {
            font-family: 'Sora', sans-serif;
            font-size: 1.8rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 0;
        }

        .stats-card {
            background: var(--surface);
            border-radius: var(--radius-md);
            padding: 1.5rem;
            margin-bottom: 2rem;
            border: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .stats-info {
            display: flex;
            gap: 2rem;
            flex-wrap: wrap;
        }
        .stat-item {
            text-align: center;
        }
        .stat-number {
            font-family: 'Sora', sans-serif;
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--primary);
        }
        .stat-label {
            font-size: 0.8rem;
            color: var(--text-muted);
        }

        .course-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
        }

        .course-card {
            background: var(--surface);
            border-radius: var(--radius-md);
            overflow: hidden;
            border: 1px solid var(--border);
            transition: all 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }

        .course-cover {
            height: 140px;
            background: linear-gradient(135deg, var(--primary), #2563eb);
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        .course-cover i {
            font-size: 3rem;
            opacity: 0.8;
        }
        .progress-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: rgba(255,255,255,0.3);
        }
        .progress-bar-custom {
            height: 100%;
            background: var(--success);
            width: 0%;
            transition: width 0.5s ease;
            border-radius: 2px;
        }

        .course-content {
            padding: 1.25rem;
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .course-title {
            font-family: 'Sora', sans-serif;
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text);
            margin-bottom: 0.5rem;
        }

        .course-description {
            color: var(--text-muted);
            font-size: 0.85rem;
            line-height: 1.5;
            margin-bottom: 1rem;
            flex: 1;
        }

        .course-meta {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
            font-size: 0.75rem;
            color: var(--text-muted);
        }
        .course-meta i {
            margin-right: 0.25rem;
            color: var(--primary);
        }

        .course-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid var(--border);
        }

        .btn-continue {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: var(--radius-sm);
            text-decoration: none;
            font-size: 0.8rem;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .btn-continue:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(26,86,219,0.3);
            color: white;
        }
        .btn-completed {
            background: linear-gradient(135deg, var(--success), #059669);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: var(--radius-sm);
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: default;
        }

        .progress-text {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--success);
        }
        .completed-badge {
            background: var(--success);
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 600;
        }

        .empty-state {
            text-align: center;
            padding: 4rem;
            background: var(--surface);
            border-radius: var(--radius-lg);
            border: 1px solid var(--border);
        }
        .empty-state i {
            font-size: 4rem;
            color: var(--border);
            margin-bottom: 1rem;
        }

        @media (max-width: 768px) {
            .main-container {
                padding: 1rem;
            }
            .course-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="container">
        <a class="logo" href="StudentDashboardServlet">
            <i class="bi bi-mortarboard-fill"></i>
            Edu<span style="color:var(--accent)">Stream</span>
        </a>
        <div class="d-flex align-items-center gap-3">
            <span><i class="bi bi-person-circle"></i> <%= name %></span>
            <a href="StudentDashboardServlet" class="btn btn-outline-primary btn-sm">
                <i class="bi bi-grid"></i> Dashboard
            </a>
            <a href="LogoutServlet" class="btn btn-outline-danger btn-sm">
                <i class="bi bi-box-arrow-right"></i> Logout
            </a>
        </div>
    </div>
</nav>

<div class="main-container">
    
    <div class="page-header">
        <div>
            <h1><i class="bi bi-book"></i> My Courses</h1>
            <p class="text-muted">Track your progress and continue learning</p>
        </div>
        <a href="StudentDashboardServlet" class="btn btn-outline-primary">
            <i class="bi bi-compass"></i> Explore More Courses
        </a>
    </div>
    
    <!-- Stats Card -->
    <div class="stats-card">
        <div class="stats-info">
            <div class="stat-item">
                <div class="stat-number"><%= totalCourses %></div>
                <div class="stat-label">Enrolled Courses</div>
            </div>
            <div class="stat-item">
                <div class="stat-number"><%= completedCourses %></div>
                <div class="stat-label">Completed</div>
            </div>
            <div class="stat-item">
                <div class="stat-number"><%= completedCourses %></div>
                <div class="stat-label">Certificates</div>
            </div>
        </div>
        <div>
            <span class="badge bg-success">
                <i class="bi bi-trophy"></i> Keep Learning!
            </span>
        </div>
    </div>
    
    <!-- Course Grid -->
    <% if (enrolledCourses != null && !enrolledCourses.isEmpty()) { %>
        <div class="course-grid">
            <% for (Course course : enrolledCourses) { 
                int progress = course.getProgressPercentage();
                boolean isCompleted = course.isCompleted();
            %>
                <div class="course-card">
                    <div class="course-cover">
                        <i class="bi bi-mortarboard-fill"></i>
                        <div class="progress-overlay">
                            <div class="progress-bar-custom" style="width: <%= progress %>%"></div>
                        </div>
                    </div>
                    <div class="course-content">
                        <div class="d-flex justify-content-between align-items-start">
                            <h3 class="course-title"><%= course.getCourseName() %></h3>
                            <% if (isCompleted) { %>
                                <span class="completed-badge">
                                    <i class="bi bi-check-circle-fill"></i> Completed
                                </span>
                            <% } %>
                        </div>
                        <p class="course-description">
                            <%= course.getDescription() != null && course.getDescription().length() > 100 ? 
                                course.getDescription().substring(0, 100) + "..." : 
                                course.getDescription() != null ? course.getDescription() : "No description available" %>
                        </p>
                        <div class="course-meta">
                            <span><i class="bi bi-tag"></i> <%= course.getCategory() != null ? course.getCategory() : "General" %></span>
                            <span><i class="bi bi-clock"></i> <%= course.getDuration() != null ? course.getDuration() : "Self-paced" %></span>
                        </div>
                        <div class="course-footer">
                            <div>
                                <span class="progress-text">
                                    <i class="bi bi-graph-up"></i> <%= progress %>% Complete
                                </span>
                            </div>
                            <% if (isCompleted) { %>
                                <a href="CourseDetailsServlet?courseId=<%= course.getCourseId() %>" class="btn-continue">
                                    <i class="bi bi-trophy-fill"></i> View Certificate
                                </a>
                            <% } else { %>
                                <a href="CourseDetailsServlet?courseId=<%= course.getCourseId() %>" class="btn-continue">
                                    <i class="bi bi-play-fill"></i> Continue
                                </a>
                            <% } %>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <div class="empty-state">
            <i class="bi bi-book"></i>
            <h4>No Enrolled Courses Yet</h4>
            <p class="text-muted">You haven't enrolled in any courses yet.</p>
            <a href="StudentDashboardServlet" class="btn btn-primary mt-3">
                <i class="bi bi-compass"></i> Browse Courses
            </a>
        </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>