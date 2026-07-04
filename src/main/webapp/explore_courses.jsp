<%@ page import="java.util.*, model.Course" %>
<%@ page session="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Check if student is logged in
    if(session.getAttribute("student_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    
    // Debug
    System.out.println("Explore JSP - Courses: " + (courses != null ? courses.size() : 0));
%>

<!DOCTYPE html>
<html>
<head>
    <title>Explore Courses - EduStream</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        /* Navbar */
        .navbar {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 15px 0;
        }

        .navbar-brand {
            font-weight: 800;
            font-size: 1.5rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Main Container */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 30px 20px;
        }

        /* Header */
        .page-header {
            background: white;
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 30px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .page-header h1 {
            font-size: 2rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
        }

        .page-header p {
            color: #666;
        }

        /* Course Grid */
        .course-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
        }

        .course-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }

        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .course-image {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 120px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2.5rem;
        }

        .course-content {
            padding: 20px;
        }

        .course-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
        }

        .course-category {
            display: inline-block;
            background: #e0e7ff;
            color: #667eea;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-bottom: 12px;
        }

        .course-description {
            color: #666;
            font-size: 0.85rem;
            line-height: 1.5;
            margin-bottom: 15px;
        }

        .course-meta {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            font-size: 0.8rem;
            color: #888;
        }

        .btn-enroll {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 10px;
            border-radius: 10px;
            width: 100%;
            font-weight: 600;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-enroll:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
            color: white;
        }

        .empty-state {
            background: white;
            border-radius: 15px;
            padding: 50px;
            text-align: center;
            grid-column: 1/-1;
        }

        .empty-state i {
            font-size: 3rem;
            color: #ccc;
            margin-bottom: 15px;
        }

        .back-btn {
            display: inline-block;
            margin-bottom: 20px;
            padding: 10px 20px;
            background: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .course-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<!-- Navbar -->
<nav class="navbar">
    <div class="container">
        <a class="navbar-brand" href="StudentDashboardServlet">
            <i class="fas fa-graduation-cap"></i> EduStream
        </a>
        <div>
            <span class="text-muted">
                <i class="fas fa-user"></i> <%= session.getAttribute("name") != null ? session.getAttribute("name") : "Student" %>
            </span>
        </div>
    </div>
</nav>

<div class="container">
    
    <!-- Back Button -->
    <a href="StudentDashboardServlet" class="back-btn">
        <i class="fas fa-arrow-left"></i> Back to Dashboard
    </a>
    
    <!-- Page Header -->
    <div class="page-header">
        <h1><i class="fas fa-compass"></i> Explore Courses</h1>
        <p>Discover new courses and expand your skills</p>
    </div>
    
    <!-- Course Grid -->
    <div class="course-grid">
        <%
            if(courses != null && !courses.isEmpty()){
                for(Course course : courses){
        %>
        <div class="course-card">
            <div class="course-image">
                <i class="fas fa-chalkboard-teacher"></i>
            </div>
            <div class="course-content">
                <span class="course-category">
                    <i class="fas fa-tag"></i> <%= course.getCategory() != null ? course.getCategory() : "General" %>
                </span>
                <h3 class="course-title"><%= course.getCourseName() %></h3>
                <p class="course-description">
                    <%= course.getDescription() != null && course.getDescription().length() > 80 ? 
                        course.getDescription().substring(0, 80) + "..." : 
                        course.getDescription() != null ? course.getDescription() : "No description available" %>
                </p>
                <div class="course-meta">
                    <span><i class="fas fa-clock"></i> <%= course.getDuration() != null ? course.getDuration() : "Self-paced" %></span>
                    <span><i class="fas fa-signal"></i> Beginner</span>
                </div>
                <form action="EnrollCourseServlet" method="post">
                    <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
                    <button type="submit" class="btn-enroll">
                        <i class="fas fa-plus-circle"></i> Enroll Now
                    </button>
                </form>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <div class="empty-state">
            <i class="fas fa-book-open"></i>
            <h4>No Courses Available</h4>
            <p>Check back later for new courses!</p>
        </div>
        <%
            }
        %>
    </div>
    
</div>

</body>
</html>