<%@ page import="java.util.*, model.Instructor" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    List<Instructor> instructors = (List<Instructor>) request.getAttribute("instructors");
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Course - EduStream</title>
    
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

        .form-container {
            max-width: 550px;
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

        .form-control, .form-select {
            padding: 0.7rem 0.9rem;
            border-radius: var(--radius-sm);
            border: 2px solid var(--border);
            font-size: 0.9rem;
            transition: all 0.3s ease;
            font-family: 'DM Sans', sans-serif;
            width: 100%;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(26,86,219,0.1);
            outline: none;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 80px;
        }

        /* Alert Messages */
        .alert {
            border-radius: var(--radius-sm);
            padding: 0.75rem 1rem;
            margin-bottom: 1.25rem;
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

        .instructor-info {
            font-size: 0.75rem;
            color: var(--text-muted);
            margin-top: 0.5rem;
            text-align: center;
        }
        .instructor-info a {
            color: var(--primary);
            text-decoration: none;
        }
        .instructor-info a:hover {
            text-decoration: underline;
        }

        /* Responsive */
        @media (max-width: 576px) {
            body {
                padding: 1rem;
            }
            .form-container {
                padding: 1.5rem;
            }
        }
    </style>

    <script>
        function validateForm() {
            let instructor = document.querySelector("select[name='instructor_id']").value;
            let courseName = document.querySelector("input[name='course_name']").value;
            
            if (courseName.trim() === "") {
                alert("Please enter course name!");
                return false;
            }
            
            if (instructor === "") {
                alert("Please select an instructor!");
                return false;
            }
            return true;
        }

        function showOtherCategory() {
            let category = document.querySelector("select[name='category']").value;
            let otherDiv = document.getElementById("otherCategoryDiv");
            
            if (category === "Other") {
                otherDiv.style.display = "block";
            } else {
                otherDiv.style.display = "none";
            }
        }

        window.onload = function() {
            document.querySelector("input[name='course_name']").focus();
            showOtherCategory();
        };
    </script>
</head>
<body>

<div class="form-container">
    <a href="AdminDashboardServlet" class="btn-back">
        <i class="bi bi-arrow-left"></i> Back to Dashboard
    </a>
    
    <div class="form-header">
        <div class="icon">
            <i class="bi bi-book-plus-fill"></i>
        </div>
        <h2>Add New Course</h2>
        <p>Create a new course and assign an instructor</p>
    </div>
    
    <% if (error != null) { %>
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-triangle-fill"></i>
            <%= error %>
        </div>
    <% } %>
    
    <% if (success != null) { %>
        <div class="alert alert-success">
            <i class="bi bi-check-circle-fill"></i>
            <%= success %>
        </div>
    <% } %>

    <form action="AddCourseServlet" method="post" onsubmit="return validateForm()">
        
        <div class="form-group">
            <label class="form-label">
                <i class="bi bi-book-fill"></i> Course Name *
            </label>
            <input type="text" class="form-control" name="course_name" placeholder="e.g., Java Programming" required>
        </div>

        <div class="form-group">
            <label class="form-label">
                <i class="bi bi-file-text-fill"></i> Description *
            </label>
            <textarea class="form-control" name="description" placeholder="Describe the course content..." required></textarea>
        </div>

        <div class="form-group">
            <label class="form-label">
                <i class="bi bi-clock-fill"></i> Duration *
            </label>
            <input type="text" class="form-control" name="duration" placeholder="e.g., 40 hours, 8 weeks" required>
        </div>

        <div class="form-group">
            <label class="form-label">
                <i class="bi bi-tag-fill"></i> Category *
            </label>
            <select class="form-select" name="category" onchange="showOtherCategory()">
                <option value="Programming">💻 Programming</option>
                <option value="Database">🗄️ Database</option>
                <option value="Web Development">🌐 Web Development</option>
                <option value="Data Science">📊 Data Science</option>
                <option value="Cloud Computing">☁️ Cloud Computing</option>
                <option value="DevOps">🚀 DevOps</option>
                <option value="Cybersecurity">🔒 Cybersecurity</option>
                <option value="Mobile Development">📱 Mobile Development</option>
                <option value="AI/ML">🤖 AI/ML</option>
                <option value="Other">📝 Other</option>
            </select>
        </div>

        <div class="form-group" id="otherCategoryDiv" style="display:none;">
            <label class="form-label">
                <i class="bi bi-pencil-fill"></i> Specify Other Category
            </label>
            <input type="text" class="form-control" name="other_category" placeholder="Enter custom category">
        </div>

        <div class="form-group">
            <label class="form-label">
                <i class="bi bi-person-badge-fill"></i> Select Instructor *
            </label>
            <select class="form-select" name="instructor_id" required>
                <option value="">-- Choose an Instructor --</option>
                
                <% if (instructors != null && !instructors.isEmpty()) { 
                    for (Instructor instructor : instructors) { %>
                        <option value="<%= instructor.getInstructorId() %>">
                            <%= instructor.getName() %> - <%= instructor.getExpertise() %> 
                            (<%= instructor.getExperience() %> years)
                        </option>
                <%  } 
                } else { %>
                    <option value="" disabled>No instructors available. Please add instructors first.</option>
                <% } %>
            </select>
            <% if (instructors == null || instructors.isEmpty()) { %>
                <div class="instructor-info">
                    <i class="bi bi-info-circle"></i> No instructors found! 
                    <a href="AddInstructorServlet">Click here to add an instructor</a>
                </div>
            <% } %>
        </div>

        <button type="submit" class="btn-submit">
            <i class="bi bi-plus-circle"></i> Add Course
        </button>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>