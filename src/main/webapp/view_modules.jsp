<%@ page import="java.util.*, model.Module, model.Video" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Modules - EduStream</title>

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
            min-height: 100vh;
            padding: 2rem;
        }

        .navbar {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border);
            padding: 0.85rem 0;
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

        .main-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            padding: 0.5rem 1rem;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            text-decoration: none;
            color: var(--text);
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }
        .back-button:hover {
            background: var(--primary-light);
            color: var(--primary);
        }

        .header-section {
            background: var(--surface);
            border-radius: var(--radius-lg);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border);
            text-align: center;
        }
        .header-section h1 {
            font-family: 'Sora', sans-serif;
            font-size: 1.8rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.5rem;
        }

        .alert-success {
            background: #d1fae5;
            color: #059669;
            border-left: 4px solid #059669;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            animation: slideIn 0.5s ease;
        }
        .alert-danger {
            background: #fee2e2;
            color: #dc2626;
            border-left: 4px solid #dc2626;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            animation: slideIn 0.5s ease;
        }
        
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        .stat-card {
            background: var(--surface);
            border-radius: var(--radius-md);
            padding: 1.25rem;
            text-align: center;
            border: 1px solid var(--border);
        }
        .stat-card i {
            font-size: 2rem;
            color: var(--primary);
        }
        .stat-card .stat-number {
            font-family: 'Sora', sans-serif;
            font-size: 1.8rem;
            font-weight: 800;
        }

        .module-card {
            background: var(--surface);
            border-radius: var(--radius-md);
            margin-bottom: 1rem;
            overflow: hidden;
            border: 1px solid var(--border);
        }
        .module-header {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            padding: 1rem 1.5rem;
            color: white;
            cursor: pointer;
        }
        .module-header h3 {
            font-family: 'Sora', sans-serif;
            font-size: 1.1rem;
            font-weight: 700;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .module-body {
            padding: 1.5rem;
            display: none;
        }
        .module-body.show {
            display: block;
        }

        .btn-add-video {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: var(--radius-sm);
            text-decoration: none;
            font-size: 0.8rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }
        .btn-add-video:hover {
            transform: translateY(-2px);
            color: white;
        }

        .video-item {
            background: var(--bg);
            border-radius: var(--radius-sm);
            padding: 0.75rem 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
            border-left: 3px solid var(--primary);
        }
        .btn-watch {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            color: white;
            padding: 0.3rem 0.8rem;
            border-radius: var(--radius-sm);
            text-decoration: none;
            font-size: 0.7rem;
        }

        .empty-state {
            text-align: center;
            padding: 2rem;
            background: var(--bg);
            border-radius: var(--radius-md);
        }

        @media (max-width: 768px) {
            body { padding: 1rem; }
            .video-item { flex-direction: column; gap: 0.5rem; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="container">
        <a class="logo" href="InstructorDashboardServlet">
            <i class="bi bi-mortarboard-fill"></i>
            Edu<span style="color:var(--accent)">Stream</span> Instructor
        </a>
        <div>
            <span><i class="bi bi-person-circle"></i> <%= session.getAttribute("name") %></span>
        </div>
    </div>
</nav>

<div class="main-container">
    
    <a href="InstructorDashboardServlet" class="back-button">
        <i class="bi bi-arrow-left"></i> Back to Dashboard
    </a>

    <div class="header-section">
        <h1><i class="bi bi-book-open"></i> Course Modules</h1>
        <p>Manage your course content, add videos, and track progress</p>
    </div>

    <%
        List<Module> modules = (List<Module>) request.getAttribute("modules");
        String successMsg = (String) request.getAttribute("successMsg");
        String errorMsg = (String) request.getAttribute("errorMsg");
        Integer courseId = (Integer) request.getAttribute("courseId");
        
        int totalModules = (modules != null) ? modules.size() : 0;
        int totalVideos = 0;
        if (modules != null) {
            for (Module m : modules) {
                if (m.getVideos() != null) {
                    totalVideos += m.getVideos().size();
                }
            }
        }
    %>

    <!-- Success Message -->
    <% if (successMsg != null && !successMsg.isEmpty()) { %>
        <div class="alert-success" id="successAlert">
            <i class="bi bi-check-circle-fill"></i> 
            <strong>Success!</strong> <%= successMsg %>
        </div>
    <% } %>
    
    <!-- Error Message -->
    <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
        <div class="alert-danger" id="errorAlert">
            <i class="bi bi-exclamation-triangle-fill"></i> 
            <strong>Error!</strong> <%= errorMsg %>
        </div>
    <% } %>

    <!-- Stats Section -->
    <div class="stats-container">
        <div class="stat-card">
            <i class="bi bi-folder"></i>
            <div class="stat-number"><%= totalModules %></div>
            <div class="stat-label">Total Modules</div>
        </div>
        <div class="stat-card">
            <i class="bi bi-camera-reels"></i>
            <div class="stat-number"><%= totalVideos %></div>
            <div class="stat-label">Total Videos</div>
        </div>
    </div>

    <%
        if (modules != null && !modules.isEmpty()) {
            int moduleCounter = 0;
            for (Module module : modules) {
                moduleCounter++;
                List<Video> videos = module.getVideos();
                int videoCount = (videos != null) ? videos.size() : 0;
    %>

    <div class="module-card">
        <div class="module-header" onclick="toggleModule(<%= moduleCounter %>)">
            <h3>
                <span>
                    <i class="bi bi-folder-fill"></i> 
                    <%= module.getModuleName() %>
                </span>
                <i class="bi bi-chevron-down" id="icon-<%= moduleCounter %>"></i>
            </h3>
        </div>
        
        <div class="module-body" id="module-<%= moduleCounter %>">
            <p class="text-muted mb-3"><%= module.getDescription() %></p>
            
            <a href="add_video.jsp?moduleId=<%= module.getModuleId() %>&courseId=<%= courseId %>" class="btn-add-video">
                <i class="bi bi-plus-circle"></i> Add New Video
            </a>

            <div class="video-list">
                <%
                    if (videos != null && !videos.isEmpty()) {
                        for (Video video : videos) {
                %>
                <div class="video-item">
                    <div>
                        <i class="bi bi-file-earmark-play"></i>
                        <strong><%= video.getTitle() %></strong>
                        <small class="text-muted ms-2">(<%= video.getDuration() %>)</small>
                    </div>
                    <a href="<%= video.getVideoUrl() %>" target="_blank" class="btn-watch">
                        <i class="bi bi-play-fill"></i> Watch
                    </a>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="empty-state">
                    <i class="bi bi-film"></i>
                    <p>No videos added yet. Click "Add New Video" to get started!</p>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>

    <%
            }
        } else {
    %>

    <div class="module-card">
        <div class="empty-state" style="padding: 3rem;">
            <i class="bi bi-folder-x"></i>
            <h5>No Modules Found</h5>
            <p>This course doesn't have any modules yet.</p>
        </div>
    </div>

    <%
        }
    %>

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