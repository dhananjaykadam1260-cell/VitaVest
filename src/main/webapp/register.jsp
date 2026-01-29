<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sign Up | VitaVest Check-in</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #6dd5c2, #5f9cff);
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: "Segoe UI", system-ui, sans-serif;
        }
        .auth-card {
            max-width: 450px;
            width: 100%;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            background: #fff;
        }
        .brand-gradient {
            background: linear-gradient(90deg, #5f9cff, #6dd5c2);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            -webkit-text-fill-color: transparent;
        }
        .form-control {
            border-radius: 12px;
        }
        .btn-primary {
            background: linear-gradient(90deg, #5f9cff, #6dd5c2);
            border: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>

<div class="auth-card text-center">
    <h3 class="fw-bold mb-2">
        Join <span class="brand-gradient">VitaVest</span>
    </h3>
    <p class="text-muted mb-4">Create your calm space 🌱</p>

    <form action="register" method="post">
        <div class="form-floating mb-3">
            <input type="text" name="name" class="form-control" placeholder="Your name" required>
            <label>Full Name</label>
        </div>

        <div class="form-floating mb-3">
            <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
            <label>Email</label>
        </div>

        <div class="form-floating mb-3">
            <input type="password" name="password" class="form-control" placeholder="Password" required>
            <label>Password</label>
        </div>

        <button type="submit" class="btn btn-primary w-100 rounded-pill py-2">
            Create Account
        </button>
    </form>

    <p class="mt-4 text-muted">
        Already have an account?
        <a href="login.jsp" class="fw-semibold text-decoration-none">Login</a>
    </p>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
