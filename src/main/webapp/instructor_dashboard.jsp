<%@ page import="java.util.*,model.Course" %>
<%@ page session="true" %>

<%
    String role = (String) session.getAttribute("role");

    if(role == null || !role.equals("instructor")){
        response.sendRedirect("login.jsp");
        return;
    }
    
    String name = (String) session.getAttribute("name");
    String expertise = (String) session.getAttribute("expertise");
    Integer experience = (Integer) session.getAttribute("experience");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instructor Dashboard - EduStream</title>
    
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
            width: 300px;
            height: 300px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
        }
        .welcome-card h1 {
            font-family: 'Sora', sans-serif;
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .welcome-card p {
            opacity: 0.9;
            margin-bottom: 0;
        }
        .expertise-badge {
            display: inline-block;
            background: rgba(255,255,255,0.2);
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            margin-top: 0.5rem;
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
        }
        .stat-card p {
            color: var(--text-muted);
            font-size: 0.85rem;
            margin: 0;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        .section-header h2 {
            font-family: 'Sora', sans-serif;
            font-size: 1.3rem;
            font-weight: 700;
        }

        /* Course Table - Fixed Layout */
        .course-table {
            background: var(--surface);
            border-radius: var(--radius-md);
            overflow-x: auto;
            border: 1px solid var(--border);
        }
        .course-table table {
            width: 100%;
            border-collapse: collapse;
            min-width: 900px;
        }
        .course-table th {
            background: var(--primary-light);
            color: var(--primary-dark);
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            font-size: 0.85rem;
            white-space: nowrap;
        }
        .course-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
            font-size: 0.9rem;
            vertical-align: middle;
        }
        .course-table tr:last-child td {
            border-bottom: none;
        }
        .course-table tr:hover {
            background: var(--primary-light);
        }

        /* Button Styles */
        .btn-sm {
            padding: 0.35rem 0.7rem;
            border-radius: var(--radius-sm);
            font-size: 0.7rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            transition: all 0.3s ease;
            margin: 0.1rem;
            border: none;
            cursor: pointer;
        }
        .btn-success-sm {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
        }
        .btn-primary-sm {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            color: white;
        }
        .btn-warning-sm {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
        }
        .btn-info-sm {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
        }
        .btn-sm:hover {
            transform: translateY(-2px);
            color: white;
        }

        .action-group {
            display: flex;
            flex-wrap: wrap;
            gap: 0.3rem;
        }

        .badge-category {
            background: var(--primary-light);
            color: var(--primary);
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 600;
        }

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

        .btn-logout {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            border: none;
            padding: 0.5rem 1.25rem;
            border-radius: var(--radius-sm);
            font-weight: 600;
            font-size: 0.85rem;
        }

        .tips-section {
            margin-top: 2rem;
        }
        .tip-card {
            background: var(--surface);
            border-radius: var(--radius-md);
            padding: 1.25rem;
            border: 1px solid var(--border);
            height: 100%;
        }
        .tip-card i {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }
        .tip-card h6 {
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .tip-card p {
            font-size: 0.8rem;
            color: var(--text-muted);
            margin: 0;
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
            .action-group {
                flex-direction: column;
            }
            .btn-sm {
                justify-content: center;
            }
        }
        .alert-success {
    background: #d1fae5;
    color: #059669;
    border-left: 4px solid #059669;
    border-radius: 10px;
}
.alert-danger {
    background: #fee2e2;
    color: #dc2626;
    border-left: 4px solid #dc2626;
    border-radius: 10px;
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
        <form action="LogoutServlet" method="get" class="m-0">
            <button type="submit" class="btn-logout">
                <i class="bi bi-box-arrow-right"></i> Logout
            </button>
        </form>
    </div>
</nav>
<a href="student_report.jsp" class="btn btn-info">
     Student Submission Report
</a>
<!-- Success Message -->
<%
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    if (success != null && !success.isEmpty()) {
%>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill"></i> <%= success %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
<%
    }
    if (error != null && !error.isEmpty()) {
%>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill"></i> <%= error %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
<%
    }
%>
<div class="main-container">
    
    <!-- Welcome Section -->
    <div class="welcome-card">
        <h1>Welcome, <%= name != null ? name : "Instructor" %>!</h1>
        <p>Manage your courses, modules, assignments, and track student progress</p>
        <% if(expertise != null) { %>
            <span class="expertise-badge">
                <i class="bi bi-star-fill"></i> <%= expertise %> , <%= experience %> years experience
            </span>
        <% } %>
    </div>
    
   <!-- Stats -->
<%
    // Calculate dynamic stats from courses
    int totalCourses = courses != null ? courses.size() : 0;
    int totalAssignments = 0;
    int pendingGrading = 0;
    int totalSubmissions = 0;
    
    if (courses != null && !courses.isEmpty()) {
        dao.AssignmentDAO assignDAO = new dao.AssignmentDAO();
        dao.SubmissionDAO subDAO = new dao.SubmissionDAO();
        
        for (Course course : courses) {
            List<model.Assignment> assignments = assignDAO.getAssignmentsByCourse(course.getCourseId());
            totalAssignments += assignments.size();
            
            for (model.Assignment assign : assignments) {
                List<model.Submission> submissions = subDAO.getSubmissionsByAssignment(assign.getAssignmentId());
                totalSubmissions += submissions.size();
                
                // Count pending grading (submitted but not graded)
                for (model.Submission sub : submissions) {
                    if ("submitted".equals(sub.getStatus())) {
                        pendingGrading++;
                    }
                }
            }
        }
    }
%>

<div class="stats-grid">
    <div class="stat-card">
        <i class="bi bi-book-fill"></i>
        <h3><%= totalCourses %></h3>
        <p>My Courses</p>
        <small class="text-muted">Assigned to you</small>
    </div>
    
    <div class="stat-card">
        <i class="bi bi-file-text-fill"></i>
        <h3><%= totalAssignments %></h3>
        <p>Total Assignments</p>
        <small class="text-muted">Created across courses</small>
    </div>
    
    <div class="stat-card">
        <i class="bi bi-clock-history"></i>
        <h3 class="text-warning"><%= pendingGrading %></h3>
        <p>Pending Grading</p>
        <small class="text-muted">Awaiting your review</small>
    </div>
    
    <div class="stat-card">
        <i class="bi bi-trophy-fill"></i>
        <h3><%= totalSubmissions %></h3>
        <p>Total Submissions</p>
        <small class="text-muted">Received from students</small>
    </div>
</div>
    
    <!-- My Courses Section -->
    <div class="section-header">
        <h2><i class="bi bi-book"></i> My Courses</h2>
        <small class="text-muted">Manage course content and assignments</small>
    </div>
    
    <div class="course-table">
        <table class="table mb-0">
            <thead>
                <tr>
                    <th style="width: 15%">Course Name</th>
                    <th style="width: 25%">Description</th>
                    <th style="width: 8%">Duration</th>
                    <th style="width: 10%">Category</th>
                    <th style="width: 18%">Content</th>
                    <th style="width: 19%">Assignments</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if(courses != null && !courses.isEmpty()){
                        for(Course c : courses){
                %>
                <tr>
                    <td><strong><%= c.getCourseName() %></strong></td>
                    <td><%= c.getDescription() != null && c.getDescription().length() > 60 ? c.getDescription().substring(0, 60) + "..." : c.getDescription() %></td>
                    <td><%= c.getDuration() %></td>
                    <td><span class="badge-category"><%= c.getCategory() %></span></td>
                    
                    <!-- Content Actions (Modules & Videos) -->
                    <td>
                        <div class="action-group">
                            <a href="add_module.jsp?courseId=<%= c.getCourseId() %>" class="btn-sm btn-success-sm" title="Add Module">
                                <i class="bi bi-plus-circle"></i> Module
                            </a>
                            <a href="ViewModuleServlet?courseId=<%= c.getCourseId() %>" class="btn-sm btn-primary-sm" title="View Modules">
                                <i class="bi bi-eye"></i> View
                            </a>
                        </div>
                    </td>
                    
                    <!-- Assignment Actions -->
                    <td>
                        <div class="action-group">
                            <a href="CreateAssignmentServlet?courseId=<%= c.getCourseId() %>" class="btn-sm btn-info-sm" title="Create Assignment">
                                <i class="bi bi-plus-circle"></i> Create
                            </a>
                            <a href="ViewAssignmentServlet?courseId=<%= c.getCourseId() %>" class="btn-sm btn-warning-sm" title="View Assignments">
                                <i class="bi bi-file-text"></i> View
                            </a>
                        </div>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7">
                        <div class="empty-state" style="margin: 0;">
                            <i class="bi bi-book"></i>
                            <h5>No Courses Assigned</h5>
                            <p class="text-muted">You haven't been assigned any courses yet. Contact admin to assign courses to you.</p>
                        </div>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
    
    <!-- Quick Tips Section -->
    <div class="tips-section">
        <div class="row g-3">
            <div class="col-md-4">
                <div class="tip-card">
                    <i class="bi bi-info-circle-fill text-primary"></i>
                    <h6>Modules & Videos</h6>
                    <p>Add modules first, then add videos inside each module for structured learning.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="tip-card">
                    <i class="bi bi-file-text-fill text-warning"></i>
                    <h6>Assignments</h6>
                    <p>Create assignments for each course. Students can submit and you can grade them.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="tip-card">
                    <i class="bi bi-graph-up text-success"></i>
                    <h6>Track Progress</h6>
                    <p>View student submissions and provide feedback to help them improve.</p>
                </div>
            </div>
        </div>
    </div>
    
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>