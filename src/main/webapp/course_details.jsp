<%@ page import="java.util.*, model.Course, model.Module, model.Video" %>
<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("student_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Course course = (Course) request.getAttribute("course");
    List<Module> modules = (List<Module>) request.getAttribute("modules");
    Boolean isEnrolled = (Boolean) request.getAttribute("isEnrolled");
    Boolean isCourseCompleted = (Boolean) request.getAttribute("isCourseCompleted");
    Integer progressPercentage = (Integer) request.getAttribute("progressPercentage");
    Integer courseId = (Integer) request.getAttribute("courseId");
    String successMsg = request.getParameter("msg");
    String errorMsg = request.getParameter("error");
    
    // Get assignment data from servlet
    List<Map<String, Object>> assignmentsData = (List<Map<String, Object>>) request.getAttribute("assignmentsData");
    Integer totalAssignments = (Integer) request.getAttribute("totalAssignments");
    Integer gradedAssignments = (Integer) request.getAttribute("gradedAssignments");
    Boolean allAssignmentsGraded = (Boolean) request.getAttribute("allAssignmentsGraded");
    Boolean certificateIssued = (Boolean) request.getAttribute("certificateIssued");
    
    if (isEnrolled == null) isEnrolled = false;
    if (isCourseCompleted == null) isCourseCompleted = false;
    if (progressPercentage == null) progressPercentage = 0;
    if (assignmentsData == null) assignmentsData = new ArrayList<>();
    if (totalAssignments == null) totalAssignments = 0;
    if (gradedAssignments == null) gradedAssignments = 0;
    if (allAssignmentsGraded == null) allAssignmentsGraded = false;
    if (certificateIssued == null) certificateIssued = false;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= course != null ? course.getCourseName() : "Course Details" %> - EduStream</title>
    
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
            --danger: #ef4444;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: linear-gradient(135deg, var(--bg) 0%, #eef2ff 100%);
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

        .container-custom {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .course-header {
            background: var(--surface);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            border: 1px solid var(--border);
        }
        .course-header h1 {
            font-family: 'Sora', sans-serif;
            font-weight: 800;
            margin-bottom: 0.5rem;
        }

        .enroll-card {
            background: linear-gradient(135deg, var(--primary-light), #fff);
            border: 2px solid var(--primary);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }
        .btn-enroll {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 10px;
            border: none;
            font-weight: 600;
        }
        .btn-enrolled {
            background: var(--success);
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 10px;
            border: none;
            font-weight: 600;
        }

        .locked-content {
            background: #fef3c7;
            border: 1px solid var(--warning);
            border-radius: 16px;
            padding: 3rem;
            text-align: center;
            margin: 2rem 0;
        }

        .progress-container {
            background: var(--surface);
            border-radius: 16px;
            padding: 1rem;
            margin-bottom: 2rem;
            border: 1px solid var(--border);
        }
        .progress {
            height: 12px;
            border-radius: 10px;
        }
        .progress-bar {
            background: linear-gradient(135deg, var(--success), #059669);
            border-radius: 10px;
            transition: width 0.5s ease;
        }

        .nav-tabs {
            border-bottom: 2px solid var(--border);
            margin-bottom: 1.5rem;
        }
        .nav-tabs .nav-link {
            border: none;
            font-weight: 600;
            color: var(--text-muted);
            padding: 0.75rem 1.5rem;
        }
        .nav-tabs .nav-link.active {
            color: var(--primary);
            border-bottom: 2px solid var(--primary);
            background: none;
        }
        .nav-tabs .nav-link.disabled {
            color: #ccc;
            cursor: not-allowed;
        }

        .module-card {
            background: var(--surface);
            border-radius: 16px;
            margin-bottom: 1rem;
            overflow: hidden;
            border: 1px solid var(--border);
        }
        .module-header {
            background: var(--surface);
            padding: 1.25rem 1.5rem;
            cursor: pointer;
            border-bottom: 1px solid var(--border);
        }
        .module-header:hover {
            background: var(--primary-light);
        }
        .module-header h3 
            font-family: 'Sora', sans-serif;
            font-size: 1.1rem;
            font-weight: 700;
            margin: 0;
            display: flex;
            justify-content: space-between;
        }
        .module-body {
            padding: 1.5rem;
            display: none;
        }
        .module-body.show {
            display: block;
            animation: fadeIn 0.3s ease;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .video-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 1rem;
            border-bottom: 1px solid var(--border);
            border-radius: 8px;
            margin-bottom: 0.5rem;
        }
        .video-watched {
            background: #d1fae5;
            border-left: 4px solid var(--success);
        }
        .btn-watch {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            color: white;
            padding: 0.4rem 1rem;
            border-radius: 8px;
            text-decoration: none;
            font-size: 0.75rem;
        }
        .btn-mark-watched {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 0.4rem 1rem;
            border-radius: 8px;
            font-size: 0.7rem;
            border: none;
            cursor: pointer;
            margin-right: 0.5rem;
        }
        .completion-badge {
            background: var(--success);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.7rem;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            margin-right: 0.5rem;
        }

        .assignment-locked, .certificate-locked {
            background: #fef3c7;
            border: 1px solid var(--warning);
            border-radius: 12px;
            padding: 2rem;
            text-align: center;
        }
        .assignment-card {
            background: var(--surface);
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1rem;
            border: 1px solid var(--border);
        }
        .btn-submit {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 0.4rem 1rem;
            border-radius: 8px;
            text-decoration: none;
            font-size: 0.75rem;
        }
        .btn-certificate {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s;
        }
        .btn-certificate:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(245,158,11,0.3);
            color: white;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            padding: 0.5rem 1rem;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 8px;
            text-decoration: none;
            color: var(--text);
        }

        .alert-success {
            background: #d1fae5;
            color: #059669;
            border-left: 4px solid #059669;
            border-radius: 10px;
            padding: 0.75rem 1rem;
            margin-bottom: 1rem;
            animation: slideIn 0.5s ease;
        }
        
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .badge {
            padding: 0.5rem 1rem;
            font-weight: 500;
            font-size: 0.8rem;
            border-radius: 20px;
        }
        .bg-primary {
            background: linear-gradient(135deg, #1a56db, #2563eb) !important;
        }
        .bg-success {
            background: linear-gradient(135deg, #10b981, #059669) !important;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: 600;
        }
        .status-submitted { background: #fed7aa; color: #c2410c; }
        .status-graded { background: #d1fae5; color: #059669; }

        @media (max-width: 768px) {
            .container-custom { padding: 1rem; }
            .video-item { flex-direction: column; gap: 0.75rem; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="container">
        <a class="logo" href="StudentDashboardServlet">
            <i class="bi bi-mortarboard-fill"></i> Edu<span style="color:var(--accent)">Stream</span>
        </a>
        <div>
            <span><i class="bi bi-person-circle"></i> <%= session.getAttribute("name") %></span>
        </div>
    </div>
</nav>

<div class="container-custom">
    <a href="StudentDashboardServlet" class="back-btn">
        <i class="bi bi-arrow-left"></i> Back to Dashboard
    </a>
    
    <!-- Success Messages -->
    <% if (successMsg != null && successMsg.equals("watched")) { %>
        <div class="alert-success">
            <i class="bi bi-check-circle-fill"></i> <strong>Video marked as watched!</strong> Keep going to complete the course.
        </div>
    <% } %>
    <% if (successMsg != null && successMsg.equals("submitted")) { %>
        <div class="alert-success">
            <i class="bi bi-check-circle-fill"></i> <strong>Assignment Submitted Successfully!</strong> The instructor will grade it soon. After grading, you will receive your certificate.
        </div>
    <% } %>
    
    <% if (course != null) { %>
        <div class="course-header">
            <h1><%= course.getCourseName() %></h1>
            <p class="text-muted"><%= course.getDescription() %></p>
            <div class="d-flex gap-2 flex-wrap mt-3">
                <span class="badge bg-primary"><i class="bi bi-tag"></i> <%= course.getCategory() %></span>
                <span class="badge bg-success"><i class="bi bi-clock"></i> <%= course.getDuration() %></span>
            </div>
        </div>
        
        <!-- Enrollment Section -->
        <div class="enroll-card">
            <div>
                <h5><i class="bi bi-star-fill"></i> Course Access</h5>
                <p class="text-muted mb-0">
                    <% if(isEnrolled) { %>
                        🎉 You are enrolled in this course! Access all modules and videos.
                    <% } else { %>
                        🔒 Enroll now to unlock all course content, modules, videos, and assignments.
                    <% } %>
                </p>
            </div>
            <% if(isEnrolled) { %>
                <div class="btn-enrolled">
                    <i class="bi bi-check-circle-fill"></i> Enrolled
                </div>
            <% } else { %>
                <form action="EnrollCourseServlet" method="post">
                    <input type="hidden" name="courseId" value="<%= courseId %>">
                    <button type="submit" class="btn-enroll">
                        <i class="bi bi-plus-circle"></i> Enroll Now
                    </button>
                </form>
            <% } %>
        </div>
        
        <!-- Only show course content if enrolled -->
        <% if(isEnrolled) { %>
            
            <!-- Progress Section -->
            <div class="progress-container">
                <div class="d-flex justify-content-between mb-2">
                    <span><i class="bi bi-graph-up"></i> Course Progress</span>
                    <span><strong><%= progressPercentage %>% Complete</strong></span>
                </div>
                <div class="progress">
                    <div class="progress-bar" style="width: <%= progressPercentage %>%"></div>
                </div>
                <% if(isCourseCompleted) { %>
                    <div class="mt-2 text-success">
                        <i class="bi bi-trophy-fill"></i> Congratulations! You have completed this course.
                    </div>
                <% } else { %>
                    <div class="mt-2 text-muted small">
                        <i class="bi bi-info-circle"></i> Mark each video as watched after viewing to track progress.
                    </div>
                <% } %>
            </div>
            
            <!-- Tabs -->
            <ul class="nav nav-tabs" id="courseTabs" role="tablist">
                <li class="nav-item">
                    <button class="nav-link active" id="modules-tab" data-bs-toggle="tab" data-bs-target="#modules" type="button" role="tab">
                        <i class="bi bi-files"></i> Course Modules
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link <%= !isCourseCompleted ? "disabled" : "" %>" id="assignments-tab" data-bs-toggle="tab" data-bs-target="#assignments" type="button" role="tab" <%= !isCourseCompleted ? "disabled" : "" %>>
                        <i class="bi bi-file-text"></i> Assignments 
                        <% if(!isCourseCompleted) { %>
                            <span class="badge bg-warning ms-1">Locked</span>
                        <% } %>
                    </button>
                </li>
                <li class="nav-item">
                    <button class="nav-link <%= !allAssignmentsGraded ? "disabled" : "" %>" id="certificate-tab" data-bs-toggle="tab" data-bs-target="#certificate" type="button" role="tab" <%= !allAssignmentsGraded ? "disabled" : "" %>>
                        <i class="bi bi-award-fill"></i> Certificate 
                        <% if(!allAssignmentsGraded && isCourseCompleted) { %>
                            <span class="badge bg-warning ms-1">Locked</span>
                        <% } %>
                        <% if(allAssignmentsGraded) { %>
                            <span class="badge bg-success ms-1">Unlocked</span>
                        <% } %>
                    </button>
                </li>
            </ul>
            
            <div class="tab-content">
                <!-- Modules Tab -->
                <div class="tab-pane fade show active" id="modules" role="tabpanel">
                    <% if (modules != null && !modules.isEmpty()) { 
                        for (Module module : modules) { %>
                            <div class="module-card">
                                <div class="module-header" onclick="toggleModule(<%= module.getModuleId() %>)">
                                    <h3>
                                        <span><i class="bi bi-folder"></i> <%= module.getModuleName() %></span>
                                        <i class="bi bi-chevron-down" id="icon-<%= module.getModuleId() %>"></i>
                                    </h3>
                                </div>
                                <div class="module-body" id="module-<%= module.getModuleId() %>">
                                    <p class="text-muted mb-3"><%= module.getDescription() %></p>
                                    
                                    <h6 class="mb-2"><i class="bi bi-camera-reels"></i> Videos</h6>
                                    <% if (module.getVideos() != null && !module.getVideos().isEmpty()) { 
                                        for (Video video : module.getVideos()) { %>
                                            <div class="video-item <%= video.isWatched() ? "video-watched" : "" %>">
                                                <div>
                                                    <% if(video.isWatched()) { %>
                                                        <i class="bi bi-check-circle-fill text-success"></i>
                                                    <% } else { %>
                                                        <i class="bi bi-play-circle-fill text-primary"></i>
                                                    <% } %>
                                                    <strong><%= video.getTitle() %></strong>
                                                    <small class="text-muted ms-2">(<%= video.getDuration() %>)</small>
                                                </div>
                                                <div>
                                                    <% if(!video.isWatched()) { %>
                                                        <form action="MarkVideoWatchedServlet" method="post" style="display: inline;">
                                                            <input type="hidden" name="videoId" value="<%= video.getVideoId() %>">
                                                            <input type="hidden" name="courseId" value="<%= courseId %>">
                                                            <button type="submit" class="btn-mark-watched">
                                                                <i class="bi bi-check-lg"></i> Mark as Watched
                                                            </button>
                                                        </form>
                                                    <% } else { %>
                                                        <span class="completion-badge">
                                                            <i class="bi bi-check-lg"></i> Completed
                                                        </span>
                                                    <% } %>
                                                    <a href="<%= video.getVideoUrl() %>" target="_blank" class="btn-watch">
                                                        <i class="bi bi-play-fill"></i> Watch
                                                    </a>
                                                </div>
                                            </div>
                                        <% } 
                                    } else { %>
                                        <p class="text-muted">No videos available for this module.</p>
                                    <% } %>
                                </div>
                            </div>
                        <% } 
                    } else { %>
                        <div class="alert alert-info">No modules available for this course yet.</div>
                    <% } %>
                </div>
                <!--  -->
                <!-- Assignments Tab -->
                <div class="tab-pane fade" id="assignments" role="tabpanel">
                    <% if(!isCourseCompleted) { %>
                        <div class="assignment-locked">
                            <i class="bi bi-lock-fill" style="font-size: 2rem;"></i>
                            <h5 class="mt-2">Assignments Locked</h5>
                            <p>Complete all course modules and videos to unlock assignments.</p>
                            <div class="progress mt-2" style="height: 8px; max-width: 300px; margin: 0 auto;">
                                <div class="progress-bar bg-warning" style="width: <%= progressPercentage %>%"></div>
                            </div>
                            <p class="mt-2">Current Progress: <strong><%= progressPercentage %>%</strong> Complete</p>
                        </div>
                    <% } else if (assignmentsData != null && !assignmentsData.isEmpty()) { %>
                        <h5 class="mb-3"><i class="bi bi-file-text"></i> Course Assignments</h5>
                        <% for (Map<String, Object> assign : assignmentsData) { 
                            String status = (String) assign.get("status");
                            if (status == null) status = "pending";
                        %>
                            <div class="assignment-card">
                                <div class="d-flex justify-content-between align-items-start flex-wrap">
                                    <div>
                                        <h6><%= assign.get("title") %></h6>
                                        <p class="text-muted small mb-1"><%= assign.get("description") != null ? assign.get("description") : "No description" %></p>
                                        <small>
                                            <i class="bi bi-star"></i> Total Marks: <%= assign.get("total_marks") %> | 
                                            <i class="bi bi-calendar"></i> Due: <%= assign.get("due_date") != null ? assign.get("due_date") : "No deadline" %>
                                        </small>
                                        <% if(assign.get("marks_obtained") != null) { %>
                                            <br><small class="text-success">Score: <%= assign.get("marks_obtained") %>/<%= assign.get("total_marks") %></small>
                                        <% } %>
                                    </div>
                                    <div class="mt-2 mt-md-0">
                                        <span class="status-badge status-<%= status %>">
                                            <%= "submitted".equals(status) ? "Submitted" : ("graded".equals(status) ? "Graded ✓" : "Not Submitted") %>
                                        </span>
                                        <a href="SubmitAssignmentServlet?assignmentId=<%= assign.get("assignment_id") %>&courseId=<%= courseId %>" class="btn-submit">
                                            <i class="bi bi-upload"></i> <%= assign.get("submission_id") != null ? "Edit Submission" : "Submit Assignment" %>
                                        </a>
                                    </div>
                                </div>
                                <% if(assign.get("feedback") != null && !((String)assign.get("feedback")).isEmpty()) { %>
                                    <div class="mt-2 p-2 bg-light rounded">
                                        <small><i class="bi bi-chat"></i> Feedback: <%= assign.get("feedback") %></small>
                                    </div>
                                <% } %>
                            </div>
                        <% } %>
                    <% } else { %>
                        <div class="empty-state text-center p-4 bg-white rounded border">
                            <i class="bi bi-inbox" style="font-size: 2rem; color: #ccc;"></i>
                            <p class="mt-2">No assignments posted for this course yet.</p>
                        </div>
                    <% } %>
                </div>
               
                <!-- Certificate Tab -->
                <div class="tab-pane fade" id="certificate" role="tabpanel">
                    <% if(!allAssignmentsGraded && isCourseCompleted && totalAssignments > 0) { %>
                        <div class="certificate-locked">
                            <i class="bi bi-lock-fill" style="font-size: 2rem;"></i>
                            <h5 class="mt-2">Certificate Locked</h5>
                            <p>Your certificate will be available once all assignments are graded.</p>
                            <div class="mt-3">
                                <p><strong>Grading Progress:</strong> <%= gradedAssignments %> out of <%= totalAssignments %> assignments graded</p>
                                <div class="progress" style="height: 8px; max-width: 300px; margin: 0 auto;">
                                    <div class="progress-bar bg-success" style="width: <%= (gradedAssignments * 100 / totalAssignments) %>%"></div>
                                </div>
                            </div>
                            <p class="text-muted mt-3">Once the instructor grades all your assignments, you will receive your certificate.</p>
                        </div>
                    <% } else if (certificateIssued) { %>
                        <div class="text-center p-4" style="background: #d1fae5; border-radius: 16px;">
                            <i class="bi bi-trophy-fill" style="font-size: 2.5rem; color: #f59e0b;"></i>
                            <h4 class="mt-2">🎉 Congratulations! 🎉</h4>
                            <p>You have successfully completed all course requirements!</p>
                            <p class="text-muted">Your certificate is ready for download.</p>
                            <a href="CertificateServlet?courseId=<%= courseId %>" class="btn-certificate">
                                <i class="bi bi-award-fill"></i> Download Certificate
                            </a>
                        </div>
                    <% } else if (allAssignmentsGraded) { %>
                        <div class="text-center p-4" style="background: #d1fae5; border-radius: 16px;">
                            <i class="bi bi-trophy-fill" style="font-size: 2.5rem; color: #f59e0b;"></i>
                            <h4 class="mt-2">🎉 All Assignments Graded! 🎉</h4>
                            <p>Congratulations! All your assignments have been graded.</p>
                            <p>You are now eligible to receive your certificate of completion.</p>
                            <a href="CertificateServlet?courseId=<%= courseId %>" class="btn-certificate">
                                <i class="bi bi-award-fill"></i> Get Your Certificate
                            </a>
                        </div>
                    <% } else { %>
                        <div class="certificate-locked">
                            <i class="bi bi-award" style="font-size: 2rem; color: #ccc;"></i>
                            <h5 class="mt-2">Certificate</h5>
                            <p>Complete the course and all assignments to receive your certificate.</p>
                        </div>
                    <% } %>
                </div>
            </div>
            
        <% } else { %>
            <!-- Not Enrolled -->
            <div class="locked-content">
                <i class="bi bi-lock-fill"></i>
                <h3>Course Content Locked</h3>
                <p>You need to enroll in this course to access modules, videos, and assignments.</p>
                <p class="text-muted">Click the "Enroll Now" button above to get started!</p>
            </div>
        <% } %>
        
    <% } %>
</div>

<script>
    function toggleModule(moduleId) {
        var body = document.getElementById("module-" + moduleId);
        var icon = document.getElementById("icon-" + moduleId);
        body.classList.toggle("show");
        if (body.classList.contains("show")) {
            icon.classList.remove("bi-chevron-down");
            icon.classList.add("bi-chevron-up");
        } else {
            icon.classList.remove("bi-chevron-up");
            icon.classList.add("bi-chevron-down");
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>