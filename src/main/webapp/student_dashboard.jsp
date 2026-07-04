<%@ page import="java.util.*, model.Course" %>
<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String name = (String) session.getAttribute("name");
    String email = (String) session.getAttribute("email");
    Integer studentId = (Integer) session.getAttribute("student_id");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<String> categories = (List<String>) request.getAttribute("categories");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    Set<Integer> enrolledCourseIds = (Set<Integer>) session.getAttribute("enrolledCourseIds");
    
    if (studentId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    if (enrolledCourseIds == null) {
        enrolledCourseIds = new HashSet<>();
    }
    if (categories == null) {
        categories = new ArrayList<>();
    }
    if (selectedCategory == null || selectedCategory.equals("null")) {
        selectedCategory = "all";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - EduStream</title>
    
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
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--text);
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
            color: var(--primary);
            text-decoration: none;
        }
        .logo-dot { color: var(--accent); }

        .main-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
        }

        .welcome-banner {
            background: linear-gradient(135deg, var(--primary) 0%, #2563eb 100%);
            border-radius: 20px;
            padding: 2.5rem;
            margin-bottom: 2rem;
            color: white;
            position: relative;
            overflow: hidden;
        }
        .welcome-banner h1 {
            font-family: 'Sora', sans-serif;
            font-size: 1.8rem;
            font-weight: 700;
        }

        /* Filter Section Styles */
        .filter-section {
            background: var(--surface);
            border-radius: 14px;
            padding: 1rem 1.5rem;
            margin-bottom: 2rem;
            border: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .filter-label {
            font-weight: 600;
            color: var(--text);
        }
        .filter-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
        }
        .filter-btn {
            padding: 0.4rem 1rem;
            border-radius: 20px;
            text-decoration: none;
            font-size: 0.8rem;
            font-weight: 500;
            transition: all 0.3s;
            background: var(--bg);
            color: var(--text);
            border: 1px solid var(--border);
        }
        .filter-btn:hover, .filter-btn.active {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }
        .stat-card {
            background: var(--surface);
            border-radius: 14px;
            padding: 1.5rem;
            text-align: center;
            border: 1px solid var(--border);
            transition: transform 0.3s;
        }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-card i { font-size: 2rem; color: var(--primary); }
        .stat-card h3 { font-family: 'Sora', sans-serif; font-size: 2rem; font-weight: 800; }

        .course-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 1.5rem;
        }
        .course-card {
            background: var(--surface);
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid var(--border);
            transition: all 0.3s;
        }
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(26,86,219,0.12);
        }
        .course-header {
            background: linear-gradient(135deg, var(--primary-light), #fff);
            padding: 1.5rem;
            border-bottom: 1px solid var(--border);
        }
        .course-header h4 {
            font-family: 'Sora', sans-serif;
            font-weight: 700;
        }
        .course-body { padding: 1.5rem; }
        .course-description {
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }
        .course-meta {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1.25rem;
            font-size: 0.85rem;
            color: var(--text-muted);
        }
        .enrolled-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            background: #d1fae5;
            color: var(--success);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 600;
        }
        .btn-details {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            color: white;
            border: none;
            padding: 0.75rem;
            border-radius: 8px;
            width: 100%;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        .btn-details:hover { transform: translateY(-2px); color: white; }
        .empty-state {
            text-align: center;
            padding: 3rem;
            background: var(--surface);
            border-radius: 20px;
            grid-column: 1/-1;
        }

        @media (max-width: 768px) {
            .main-container { padding: 1rem; }
            .welcome-banner h1 { font-size: 1.3rem; }
            .filter-section { flex-direction: column; align-items: flex-start; }
            .filter-buttons { overflow-x: auto; padding-bottom: 0.5rem; width: 100%; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="container">
        <a class="logo" href="StudentDashboardServlet">
            <i class="bi bi-mortarboard-fill"></i> Edu<span class="logo-dot">Stream</span>
        </a>
        <div class="d-flex align-items-center gap-3">
            <span><i class="bi bi-person-circle"></i> <%= name != null ? name : "Student" %></span>
            <a href="MyCoursesServlet" class="btn btn-outline-primary btn-sm">My Courses</a>
            <a href="LogoutServlet" class="btn btn-outline-danger btn-sm">Logout</a>
        </div>
    </div>
</nav>

<div class="main-container">
    
    <div class="welcome-banner">
        <h1>Welcome back, <%= name != null ? name : "Student" %>! </h1>
        <p>Browse courses by category and view details before enrolling</p>
    </div>
    
    <!-- Category Filter Section -->
    <div class="filter-section">
        <span class="filter-label"><i class="bi bi-funnel"></i> Filter by Category:</span>
        <div class="filter-buttons">
            <a href="StudentDashboardServlet?category=all" class="filter-btn <%= selectedCategory.equals("all") ? "active" : "" %>">
                All Courses
            </a>
            <% if (categories != null && !categories.isEmpty()) {
                for (String cat : categories) { %>
                    <a href="StudentDashboardServlet?category=<%= cat %>" class="filter-btn <%= selectedCategory.equals(cat) ? "active" : "" %>">
                        <%= cat %>
                    </a>
            <%  }
            } %>
        </div>
    </div>
    
    <div class="stats-grid">
        <div class="stat-card">
            <i class="bi bi-book-open"></i>
            <h3><%= courses != null ? courses.size() : 0 %></h3>
            <p>Available Courses</p>
        </div>
        <div class="stat-card">
            <i class="bi bi-play-circle"></i>
            <h3><%= enrolledCourseIds.size() %></h3>
            <p>Enrolled Courses</p>
        </div>
        <div class="stat-card">
            <i class="bi bi-award"></i>
            <h3>0</h3>
            <p>Certificates</p>
        </div>
    </div>
    
    <h3 class="mb-3">
        <i class="bi bi-search"></i> 
        <% if (selectedCategory.equals("all")) { %>
            All Courses
        <% } else { %>
            <%= selectedCategory %> Courses
        <% } %>
    </h3>
    
    <div class="course-grid">
        <%
            if(courses != null && !courses.isEmpty()){
                for(Course course : courses){
                    boolean isEnrolled = enrolledCourseIds.contains(course.getCourseId());
        %>
        <div class="course-card">
            <div class="course-header">
                <h4><%= course.getCourseName() %></h4>
                <div class="d-flex justify-content-between align-items-center mt-2">
                    <span class="badge bg-primary-light text-primary"><%= course.getCategory() != null ? course.getCategory() : "General" %></span>
                    <% if(isEnrolled) { %>
                        <span class="enrolled-badge"><i class="bi bi-check-circle-fill"></i> Enrolled</span>
                    <% } %>
                </div>
            </div>
            <div class="course-body">
                <p class="course-description">
                    <%= course.getDescription() != null && course.getDescription().length() > 100 ? 
                        course.getDescription().substring(0, 100) + "..." : 
                        course.getDescription() != null ? course.getDescription() : "No description" %>
                </p>
                <div class="course-meta">
                    <span><i class="bi bi-clock"></i> <%= course.getDuration() != null ? course.getDuration() : "Self-paced" %></span>
                    <span><i class="bi bi-person"></i> Instructor</span>
                </div>
                <a href="CourseDetailsServlet?courseId=<%= course.getCourseId() %>" class="btn-details">
                    <i class="bi bi-eye"></i> View Details
                </a>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <div class="empty-state">
            <i class="bi bi-book" style="font-size: 3rem; color: #ccc;"></i>
            <h4 class="mt-3">No Courses Available</h4>
            <p class="text-muted">No courses found in this category. Try another filter!</p>
        </div>
        <%
            }
        %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>