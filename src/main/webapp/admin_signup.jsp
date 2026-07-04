<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    String alertType = "";
    String alertMessage = "";
    
    if ("true".equals(success)) {
        alertType = "success";
        alertMessage = "Admin account created successfully! Please login.";
    } else if ("exists".equals(error)) {
        alertType = "danger";
        alertMessage = "Admin account already exists!";
    } else if ("db".equals(error)) {
        alertType = "danger";
        alertMessage = "Database error occurred!";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Setup - EduStream</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        /* Same styles as above */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            /*background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);*/
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .admin-container {
            max-width: 450px;
            width: 100%;
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .header h2 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .header p {
            color: #666;
            font-size: 14px;
        }
        
        .security-box {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 12px;
            margin-bottom: 25px;
            border-radius: 8px;
            font-size: 13px;
            color: #856404;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .password-wrapper {
            position: relative;
        }
        
        .toggle-pwd {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            background: none;
            border: none;
            font-size: 18px;
        }
        
        .btn-submit {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
        }
        
        .login-link {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .login-link a {
            color: #667eea;
            text-decoration: none;
        }
        
        .alert {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        @media (max-width: 576px) {
            .admin-container {
                padding: 25px;
                margin: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <div class="header">
            <h2>EduStream Admin</h2>
            <p>Create platform administrator account</p>
        </div>
        
        <div class="security-box">
            <strong>⚠️ Important:</strong> This page should only be accessible during initial setup.
        </div>
        
        <% if (!alertMessage.isEmpty()) { %>
            <div class="alert alert-<%= alertType %>">
                <%= alertMessage %>
            </div>
        <% } %>
        
        <form action="AdminSignupServlet" method="post">
            <div class="form-group">
                <label>Username</label>
                <input type="text" class="form-control" name="username" required>
            </div>
            
            <div class="form-group">
                <label>Email</label>
                <input type="email" class="form-control" name="email" required>
            </div>
            
            <div class="form-group">
                <label>Password</label>
                <div class="password-wrapper">
                    <input type="password" class="form-control" name="password" id="password" required>
                    <button type="button" class="toggle-pwd" onclick="togglePassword()">👁️</button>
                </div>
            </div>
            
            <button type="submit" class="btn-submit">Create Admin Account</button>
        </form>
        
        <div class="login-link">
            <p>Already have admin access? <a href="admin_login.jsp">Admin Login</a></p>
        </div>
    </div>
    
    <script>
        function togglePassword() {
            var pwd = document.getElementById("password");
            if (pwd.type === "password") {
                pwd.type = "text";
            } else {
                pwd.type = "password";
            }
        }
    </script>
</body>
</html>