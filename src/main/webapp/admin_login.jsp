<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | EduStream</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Poppins:wght@600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #4f46e5;
            --primary-dark: #3730a3;
            --bg: #f5f7fb;
            --text: #1f2937;
            --muted: #6b7280;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #eef2ff, #f5f7fb);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-box {
            width: 100%;
            max-width: 420px;
            background: white;
            padding: 2.5rem;
            border-radius: 16px;
            box-shadow: 0 10px 35px rgba(0,0,0,0.1);
        }

        .logo {
            font-family: 'Poppins', sans-serif;
            font-size: 1.8rem;
            font-weight: 700;
            text-align: center;
            color: var(--primary-dark);
        }

        .subtitle {
            text-align: center;
            color: var(--muted);
            margin-bottom: 2rem;
        }

        .form-control {
            border-radius: 8px;
            padding: 10px;
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(79,70,229,0.2);
        }

        .btn-login {
            width: 100%;
            background: var(--primary);
            color: white;
            padding: 10px;
            border-radius: 8px;
            font-weight: 600;
            border: none;
            transition: 0.3s;
        }

        .btn-login:hover {
            background: var(--primary-dark);
        }

        .password-wrapper {
            position: relative;
        }

        .toggle-password {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            border: none;
            background: none;
            cursor: pointer;
        }

        .error-box {
            background: #fee2e2;
            color: #b91c1c;
            padding: 10px;
            border-radius: 6px;
            margin-top: 15px;
            text-align: center;
        }

        .bottom-links {
            text-align: center;
            margin-top: 20px;
        }

        .bottom-links a {
            text-decoration: none;
            color: var(--primary);
            font-weight: 500;
        }

        .bottom-links a:hover {
            text-decoration: underline;
        }

        .home-btn {
            display: block;
            text-align: center;
            margin-top: 15px;
        }

        .home-btn a {
            font-size: 0.9rem;
            color: var(--muted);
            text-decoration: none;
        }

        .home-btn a:hover {
            color: var(--primary);
        }
    </style>
</head>

<body>

<div class="login-box">

    <div class="logo">EduStream</div>
    <p class="subtitle">Admin Panel Login</p>

    <form action="AdminLoginServlet" method="post">

        <div class="mb-3">
            <label class="form-label">Username</label>
            <input type="text" name="username" class="form-control" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Password</label>

            <div class="password-wrapper">
                <input type="password" id="password" name="password" class="form-control" required>
                <button type="button" class="toggle-password" id="togglePassword">
                    <i class="bi bi-eye"></i>
                </button>
            </div>
        </div>

        <button type="submit" class="btn btn-login">Login</button>

    </form>

    <!-- ERROR MESSAGE -->
    <%
        String error = (String) request.getAttribute("error");
        if(error != null){
    %>
        <div class="error-box">
            <%= error %>
        </div>
    <%
        }
    %>

    <div class="bottom-links">
        <p>New Admin? <a href="admin_signup.jsp">Create Account</a></p>
    </div>

    <div class="home-btn">
        <a href="index.html"><i class="bi bi-arrow-left"></i> Back to Home</a>
    </div>

</div>

<script>
    const togglePassword = document.getElementById("togglePassword");
    const password = document.getElementById("password");

    togglePassword.addEventListener("click", function () {
        const type = password.type === "password" ? "text" : "password";
        password.type = type;

        this.innerHTML = type === "password"
            ? '<i class="bi bi-eye"></i>'
            : '<i class="bi bi-eye-slash"></i>';
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>