<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - EduStream</title>
    
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
            margin: 0;
            padding: 1rem;
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

        .signup-container {
            max-width: 500px;
            width: 100%;
            background: rgba(255,255,255,0.96);
            backdrop-filter: blur(12px);
            border-radius: var(--radius-lg);
            padding: 2rem 2rem;
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(255,255,255,0.5);
            position: relative;
            z-index: 1;
            transition: transform 0.3s ease;
        }

        .signup-container:hover {
            transform: translateY(-5px);
        }

        /* Logo */
        .logo {
            text-align: center;
            margin-bottom: 1.5rem;
        }
        .logo-icon {
            width: 55px;
            height: 55px;
            background: linear-gradient(135deg, var(--primary), #2563eb);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 0.75rem;
            box-shadow: 0 8px 20px rgba(26,86,219,0.2);
        }
        .logo-icon i {
            font-size: 28px;
            color: white;
        }
        .logo h2 {
            font-family: 'Sora', sans-serif;
            font-size: 1.6rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 0;
        }
        .logo p {
            color: var(--text-muted);
            font-size: 0.85rem;
            margin-top: 0.25rem;
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

        /* Form Styles */
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

        .form-control {
            padding: 0.7rem 0.9rem;
            border-radius: var(--radius-sm);
            border: 2px solid var(--border);
            font-size: 0.9rem;
            transition: all 0.3s ease;
            font-family: 'DM Sans', sans-serif;
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(26,86,219,0.1);
            outline: none;
        }

        .password-wrapper {
            position: relative;
        }

        .password-wrapper input {
            padding-right: 2.5rem !important;
        }

        .toggle-password {
            position: absolute;
            top: 50%;
            right: 0.8rem;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--text-muted);
            font-size: 1rem;
            cursor: pointer;
            padding: 0;
            transition: color 0.3s ease;
        }

        .toggle-password:hover {
            color: var(--primary);
        }

        /* Signup Button */
        .btn-signup {
            background: linear-gradient(135deg, var(--primary), #2563eb);
            color: white;
            font-weight: 600;
            font-size: 0.95rem;
            padding: 0.75rem;
            border: none;
            border-radius: var(--radius-sm);
            width: 100%;
            margin-top: 1.25rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-signup:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(26,86,219,0.3);
        }

        /* Login Link */
        .login-link {
            text-align: center;
            margin-top: 1.25rem;
            padding-top: 1rem;
            border-top: 1px solid var(--border);
            font-size: 0.85rem;
            color: var(--text-muted);
        }

        .login-link a {
            color: var(--primary);
            font-weight: 600;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .login-link a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }

        .back-home {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            margin-top: 0.75rem;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.8rem;
            transition: color 0.3s ease;
        }
        .back-home:hover {
            color: var(--primary);
        }

        /* Password strength indicator */
        .password-strength {
            margin-top: 0.4rem;
            display: flex;
            gap: 0.4rem;
            align-items: center;
        }
        .strength-bar {
            flex: 1;
            height: 3px;
            background: var(--border);
            border-radius: 3px;
            overflow: hidden;
        }
        .strength-bar-fill {
            height: 100%;
            width: 0%;
            transition: width 0.3s ease;
            border-radius: 3px;
        }
        .strength-text {
            font-size: 0.7rem;
            color: var(--text-muted);
            min-width: 50px;
        }

        @media (max-width: 576px) {
            .signup-container {
                margin: 1rem;
                padding: 1.5rem;
            }
            .logo h2 {
                font-size: 1.4rem;
            }
            .row {
                margin: 0;
            }
            .col-md-6 {
                padding: 0 6px;
            }
        }
    </style>
</head>
<body>

<div class="signup-container">
    <div class="logo">
        <div class="logo-icon">
            <i class="bi bi-mortarboard-fill"></i>
        </div>
        <h2>EduStream</h2>
        <p>Create your account to start learning</p>
    </div>

    <!-- Display error message if any -->
    <%
        String error = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        if (error != null && !error.isEmpty()) {
    %>
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-triangle-fill"></i>
            <%= error %>
        </div>
    <%
        }
        if (success != null && success.equals("true")) {
    %>
        <div class="alert alert-success">
            <i class="bi bi-check-circle-fill"></i>
            Account created successfully! Please login.
        </div>
    <%
        }
    %>

    <form action="RegisterServlet" method="post" id="signupForm">
        <div class="row g-2">
            <div class="col-md-6">
                <label for="username" class="form-label">
                    <i class="bi bi-person-fill"></i> Username
                </label>
                <input type="text" class="form-control" id="username" name="username" 
                       placeholder="Choose username" required>
            </div>

            <div class="col-md-6">
                <label for="mobile" class="form-label">
                    <i class="bi bi-phone-fill"></i> Mobile
                </label>
                <input type="tel" class="form-control" id="mobile" name="mobile" 
                       placeholder="9876543210" required pattern="[0-9]{10}" 
                       title="10-digit mobile number">
            </div>

            <div class="col-12">
                <label for="email" class="form-label">
                    <i class="bi bi-envelope-fill"></i> Email Address
                </label>
                <input type="email" class="form-control" id="email" name="email" 
                       placeholder="name@example.com" required>
            </div>

            <div class="col-md-6">
                <label for="password" class="form-label">
                    <i class="bi bi-key-fill"></i> Password
                </label>
                <div class="password-wrapper">
                    <input type="password" class="form-control" id="password" name="password" 
                           placeholder="Create password" required>
                    <button type="button" class="toggle-password" id="togglePassword">
                        <i class="bi bi-eye"></i>
                    </button>
                </div>
                <div class="password-strength" id="passwordStrength" style="display: none;">
                    <div class="strength-bar">
                        <div class="strength-bar-fill" id="strengthFill"></div>
                    </div>
                    <span class="strength-text" id="strengthText">Weak</span>
                </div>
            </div>

            <div class="col-md-6">
                <label for="confirmPassword" class="form-label">
                    <i class="bi bi-check-circle-fill"></i> Confirm Password
                </label>
                <div class="password-wrapper">
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                           placeholder="Confirm password" required>
                    <button type="button" class="toggle-password" id="toggleConfirm">
                        <i class="bi bi-eye"></i>
                    </button>
                </div>
            </div>
        </div>

        <button type="submit" class="btn-signup">
            <i class="bi bi-person-plus-fill"></i> Create Account
        </button>
    </form>

    <div class="login-link">
        <p>Already have an account? <a href="login.jsp">Sign in</a></p>
        <a href="index.html" class="back-home">
            <i class="bi bi-arrow-left"></i> Back to Home
        </a>
    </div>
</div>

<script>
    // Password toggle for main password
    const togglePassword = document.querySelector('#togglePassword');
    const password = document.querySelector('#password');

    togglePassword.addEventListener('click', function () {
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        this.innerHTML = type === 'password' 
            ? '<i class="bi bi-eye"></i>' 
            : '<i class="bi bi-eye-slash"></i>';
    });

    // Password toggle for confirm password
    const toggleConfirm = document.querySelector('#toggleConfirm');
    const confirmPassword = document.querySelector('#confirmPassword');

    toggleConfirm.addEventListener('click', function () {
        const type = confirmPassword.getAttribute('type') === 'password' ? 'text' : 'password';
        confirmPassword.setAttribute('type', type);
        this.innerHTML = type === 'password' 
            ? '<i class="bi bi-eye"></i>' 
            : '<i class="bi bi-eye-slash"></i>';
    });

    // Password strength checker
    const passwordStrengthDiv = document.getElementById('passwordStrength');
    const strengthFill = document.getElementById('strengthFill');
    const strengthText = document.getElementById('strengthText');

    password.addEventListener('input', function() {
        const pwd = this.value;
        
        if (pwd.length === 0) {
            passwordStrengthDiv.style.display = 'none';
            return;
        }
        
        passwordStrengthDiv.style.display = 'flex';
        
        let strength = 0;
        if (pwd.length >= 6) strength++;
        if (pwd.length >= 10) strength++;
        if (/[a-z]/.test(pwd)) strength++;
        if (/[A-Z]/.test(pwd)) strength++;
        if (/[0-9]/.test(pwd)) strength++;
        if (/[^a-zA-Z0-9]/.test(pwd)) strength++;
        
        let percentage = 0;
        let text = '';
        let color = '';
        
        if (strength <= 2) {
            percentage = 33;
            text = 'Weak';
            color = '#ef4444';
        } else if (strength <= 4) {
            percentage = 66;
            text = 'Medium';
            color = '#f59e0b';
        } else {
            percentage = 100;
            text = 'Strong';
            color = '#10b981';
        }
        
        strengthFill.style.width = percentage + '%';
        strengthFill.style.background = color;
        strengthText.textContent = text;
        strengthText.style.color = color;
    });

    // Form validation before submit
    document.getElementById('signupForm').addEventListener('submit', function(e) {
        const username = document.getElementById('username').value.trim();
        const email = document.getElementById('email').value.trim();
        const mobile = document.getElementById('mobile').value.trim();
        const pass = password.value;
        const confirm = confirmPassword.value;
        
        if (username.length < 3) {
            e.preventDefault();
            alert('Username must be at least 3 characters long');
            return false;
        }
        
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailPattern.test(email)) {
            e.preventDefault();
            alert('Please enter a valid email address');
            return false;
        }
        
        if (mobile.length !== 10 || !/^\d+$/.test(mobile)) {
            e.preventDefault();
            alert('Please enter a valid 10-digit mobile number');
            return false;
        }
        
        if (pass.length < 6) {
            e.preventDefault();
            alert('Password must be at least 6 characters long');
            return false;
        }
        
        if (pass !== confirm) {
            e.preventDefault();
            alert('Passwords do not match. Please try again.');
            confirmPassword.focus();
            return false;
        }
        
        return true;
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>