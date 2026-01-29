<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | VitaVest Check-in</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Inline CSS -->
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #5f9cff, #6dd5c2);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .auth-card {
            max-width: 420px;
            width: 100%;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            background: #fff;
        }
        .brand-gradient {
            background: linear-gradient(90deg, #5f9cff, #6dd5c2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
    </style>
</head>
<body>

<div class="auth-card text-center">
    <h3 class="fw-bold mb-2">
        <span class="brand-gradient">VitaVest</span> Check-in
    </h3>
    <p class="text-muted mb-4">Welcome back 🌿</p>

    <!-- Login Form -->
    <form action="login" method="post">

        <div class="form-floating mb-3">
            <input type="email" class="form-control" name="email" placeholder="name@example.com" required>
            <label>Email address</label>
        </div>

        <div class="form-floating mb-3">
            <input type="password" class="form-control" name="password" placeholder="Password" required>
            <label>Password</label>
        </div>

        <button type="submit" class="btn btn-primary w-100 rounded-pill py-2">
            Login
        </button>
    </form>

    <!-- Error message -->
    <%
        String error = request.getParameter("error");
        if (error != null) {
    %>
        <p class="text-danger mt-3">Invalid email or password</p>
    <%
        }
    %>

    <p class="mt-4 text-muted">
        Don’t have an account?
        <a href="register.jsp" class="fw-semibold text-decoration-none">Sign up</a>
    </p>
</div>

</body>
</html>
