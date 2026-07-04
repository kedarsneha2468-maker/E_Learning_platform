<%@ page session="true" %>
<%@ page import="java.util.*, model.AdminDashboard, model.Course" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String admin = (String) session.getAttribute("admin");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    String searchQuery = (String) request.getAttribute("searchQuery");
    
    if (admin == null) {
        response.sendRedirect("admin_login.jsp");
        return;
    }
    
    // Get data from servlet
    AdminDashboard dashboard = (AdminDashboard) request.getAttribute("dashboard");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    
    if (dashboard == null) dashboard = new AdminDashboard();
    if (courses == null) courses = new ArrayList<>();
    if (searchQuery == null) searchQuery = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - EduStream</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary: #1a56db;
            --accent: #f97316;
            --bg: #f5f7ff;
            --surface: #ffffff;
            --text: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --success: #10b981;
            --danger: #ef4444;
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
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
        }

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

        .welcome-card {
            background: linear-gradient(135deg, var(--primary) 0%, #2563eb 100%);
            border-radius: var(--radius-lg);
            padding: 2rem;
            margin-bottom: 2rem;
            color: white;
            position: relative;
            overflow: hidden;
        }
        .welcome-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 250px;
            height: 250px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }
        .welcome-card h1 {
            font-family: 'Sora', sans-serif;
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 0.25rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }
        .stat-card {
            background: var(--surface);
            border-radius: var(--radius-md);
            padding: 1.25rem;
            text-align: center;
            border: 1px solid var(--border);
            transition: all 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .stat-card i {
            font-size: 2rem;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }
        .stat-card h3 {
            font-family: 'Sora', sans-serif;
            font-size: 1.8rem;
            font-weight: 800;
            margin-bottom: 0.25rem;
            color: var(--primary);
        }
        .stat-card p {
            color: var(--text-muted);
            font-size: 0.85rem;
        }

        /* Search Bar */
        .search-section {
            background: var(--surface);
            border-radius: var(--radius-md);
            padding: 1.25rem;
            margin-bottom: 1.5rem;
            border: 1px solid var(--border);
        }
        .search-input-group {
            display: flex;
            gap: 0.5rem;
        }
        .search-input {
            flex: 1;
            padding: 0.75rem 1rem;
            border: 2px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 0.9rem;
            transition: all 0.3s;
        }
        .search-input:focus {
            border-color: var(--primary);
            outline: none;
            box-shadow: 0 0 0 3px rgba(26,86,219,0.1);
        }
        .search-btn {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: var(--radius-sm);
            font-weight: 600;
            transition: all 0.3s;
        }
        .search-btn:hover {
            transform: translateY(-2px);
        }
        .clear-btn {
            background: #6c757d;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: var(--radius-sm);
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .search-result-info {
            margin-top: 0.75rem;
            font-size: 0.85rem;
            color: var(--text-muted);
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 1rem;
            flex-wrap: wrap;
            margin-bottom: 2rem;
        }
        .btn-action {
            padding: 0.75rem 1.5rem;
            border-radius: var(--radius-sm);
            font-weight: 600;
            font-size: 0.9rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s ease;
        }
        .btn-success {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
        }
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            color: white;
        }
        .btn-logout {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            border: none;
            padding: 0.5rem 1.25rem;
            border-radius: var(--radius-sm);
            font-weight: 600;
            font-size: 0.85rem;
        }
        .btn-action:hover {
            transform: translateY(-2px);
            filter: brightness(105%);
            color: white;
        }

        .section-title {
            font-family: 'Sora', sans-serif;
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .course-table {
            background: var(--surface);
            border-radius: var(--radius-md);
            overflow: hidden;
            border: 1px solid var(--border);
        }
        .course-table table {
            width: 100%;
            border-collapse: collapse;
        }
        .course-table th {
            background: var(--primary-light);
            color: var(--primary-dark);
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            font-size: 0.85rem;
        }
        .course-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
            font-size: 0.9rem;
        }
        .course-table tr:last-child td {
            border-bottom: none;
        }
        .course-table tr:hover {
            background: var(--primary-light);
        }
        .badge-category {
            background: #d1fae5;
            color: #059669;
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 600;
        }
        .badge-not-assigned {
            background: #fee2e2;
            color: #dc2626;
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .main-container {
                padding: 1rem;
            }
            .welcome-card h1 {
                font-size: 1.3rem;
            }
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 1rem;
            }
            .course-table {
                overflow-x: auto;
            }
            .course-table table {
                min-width: 600px;
            }
            .action-buttons {
                flex-direction: column;
                align-items: stretch;
            }
            .btn-action {
                justify-content: center;
            }
            .search-input-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="container">
        <a class="logo" href="AdminDashboardServlet">
            <i class="bi bi-shield-lock-fill"></i>
            Edu<span style="color:var(--accent)">Stream</span> Admin
        </a>
        <form action="index.html" method="post" class="m-0">
            <button type="submit" class="btn-logout">
                <i class="bi bi-box-arrow-right"></i> Logout
            </button>
        </form>
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
    
    <!-- Welcome Card -->
    <div class="welcome-card">
        <h1>Welcome, <%= admin %>! 👋</h1>
        <p>Manage your platform, courses, instructors, and students</p>
    </div>
    
    <!-- Statistics Cards with Dynamic Data -->
    <div class="stats-grid">
        <div class="stat-card">
            <i class="bi bi-people-fill"></i>
            <h3><%= dashboard.getTotalStudents() %></h3>
            <p>Total Students</p>
        </div>
        <div class="stat-card">
            <i class="bi bi-person-video3"></i>
            <h3><%= dashboard.getTotalInstructors() %></h3>
            <p>Total Instructors</p>
        </div>
        <div class="stat-card">
            <i class="bi bi-book-fill"></i>
            <h3><%= dashboard.getTotalCourses() %></h3>
            <p>Total Courses</p>
        </div>
        <div class="stat-card">
            <i class="bi bi-trophy-fill"></i>
            <h3><%= dashboard.getTotalEnrollments() %></h3>
            <p>Total Enrollments</p>
        </div>
    </div>
    <!-- Action Buttons -->
    <div class="action-buttons">
        <a href="AddInstructorServlet" class="btn-action btn-success">
            <i class="bi bi-person-plus-fill"></i> Add Instructor
        </a>
        <a href="AddCourseServlet" class="btn-action btn-primary">
            <i class="bi bi-book-plus-fill"></i> Add Course
        </a>
    </div>
    <!-- Search Bar Section -->
    <div class="search-section">
        <form action="AdminDashboardServlet" method="get">
            <div class="search-input-group">
                <input type="text" name="search" class="search-input" 
                       placeholder="Search by course name or instructor name..." 
                       value="<%= searchQuery %>">
                <button type="submit" class="search-btn">
                    <i class="bi bi-search"></i> Search
                </button>
                <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
                    <a href="AdminDashboardServlet" class="clear-btn">
                        <i class="bi bi-x-circle"></i> Clear
                    </a>
                <% } %>
            </div>
            <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
                <div class="search-result-info">
                    <i class="bi bi-info-circle"></i> 
                    Showing results for: <strong>"<%= searchQuery %>"</strong>
                    (Found <%= courses.size() %> courses)
                </div>
            <% } %>
        </form>
    </div>
    
    
    
    <!-- All Courses Section -->
    <div class="section-title">
        <i class="bi bi-book"></i> All Courses with Instructors
        <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
            <span class="badge bg-primary">Search Results</span>
        <% } %>
    </div>
    
    <div class="course-table">
        <table class="table mb-0">
            <thead>
                <tr>
                    <th>Course Name</th>
                    <th>Description</th>
                    <th>Duration</th>
                    <th>Category</th>
                    <th>Instructor</th>
                </tr>
            </thead>
            <tbody>
                <% if (courses != null && !courses.isEmpty()) { 
                    for (Course course : courses) { %>
                        <tr>
                            <td><strong><%= course.getCourseName() %></strong></td>
                            <td><%= course.getDescription() != null && course.getDescription().length() > 60 ? course.getDescription().substring(0, 60) + "..." : (course.getDescription() != null ? course.getDescription() : "No description") %></td>
                            <td><%= course.getDuration() != null ? course.getDuration() : "N/A" %></td>
                            <td><span class="badge-category"><%= course.getCategory() != null ? course.getCategory() : "General" %></span></td>
                            <td>
                                <% if (course.getInstructorName() != null && !course.getInstructorName().isEmpty()) { %>
                                    <i class="bi bi-person-badge"></i> <%= course.getInstructorName() %>
                                <% } else { %>
                                    <span class="badge-not-assigned">
                                        <i class="bi bi-exclamation-circle"></i> Not Assigned
                                    </span>
                                <% } %>
                            </td>
                        </tr>
                    <% } 
                } else { %>
                    <tr>
                        <td colspan="6" class="text-center py-4">
                            <i class="bi bi-inbox" style="font-size: 2rem; color: #ccc;"></i>
                            <p class="mt-2">
                                <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
                                    No courses found matching "<strong><%= searchQuery %></strong>"
                                <% } else { %>
                                    No courses found. Click "Add Course" to create one.
                                <% } %>
                            </p>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    
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