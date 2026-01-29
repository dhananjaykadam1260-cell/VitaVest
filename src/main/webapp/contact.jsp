<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Us - VitaVest</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root {
            --primary: #43cea2;
            --secondary: #185a9d;
            --light: #f5f7fb;
            --dark: #1e293b;
        }

        body {
            font-family: "Segoe UI", system-ui, sans-serif;
            background: var(--light);
            color: #334155;
        }

        .premium-nav {
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(18px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.08);
            padding: 16px 0;
        }

        .brand-gradient {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 28px;
        }

        .navbar-nav .nav-link {
            font-weight: 500;
            margin: 0 14px;
            position: relative;
            color: #334155;
        }

        .navbar-nav .nav-link::after {
            content: "";
            position: absolute;
            width: 0%;
            height: 2px;
            left: 0;
            bottom: -6px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            transition: width 0.3s ease;
        }

        .navbar-nav .nav-link:hover::after,
        .navbar-nav .nav-link.active::after {
            width: 100%;
        }

        /* Contact Section */
        .contact-section {
            max-width: 800px;
            margin: 120px auto 60px;
            background: #fff;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 14px 35px rgba(0,0,0,0.08);
        }

        .contact-section h1 {
            text-align: center;
            margin-bottom: 30px;
            color: var(--primary);
        }

        .contact-info {
            display: flex;
            flex-direction: column;
            gap: 20px;
            font-size: 18px;
        }

        .contact-info div {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .contact-info div i {
            font-size: 24px;
            color: var(--secondary);
            min-width: 30px;
        }

        .contact-info div span {
            font-weight: 500;
            width: 100px;
            color: var(--primary);
        }

        .footer {
            background: white;
            padding: 22px;
            color: #64748b;
            font-size: 14px;
            text-align: center;
        }
    </style>
</head>
<body>

<!-- ================= NAVBAR ================= -->
<nav class="navbar navbar-expand-lg fixed-top premium-nav">
    <div class="container">
        <a class="navbar-brand fw-bold" href="index.jsp">
            <span class="brand-gradient">VitaVest </span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNav">
            <ul class="navbar-nav mx-auto">
                <li class="nav-item"><a class="nav-link" href="LandingPage.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="features.jsp">Features</a></li>
                <li class="nav-item"><a class="nav-link" href="pricing.jsp">Pricing</a></li>
                <li class="nav-item"><a class="nav-link active" href="contact.jsp">Contact</a></li>
                <li class="nav-item"><a class="nav-link" href="adminlogin.jsp">Admin</a></li>
            </ul>

            <div class="d-flex">
                <a href="login.jsp" class="btn btn-outline-primary rounded-pill px-4 me-2">Login</a>
                <a href="register.jsp" class="btn btn-primary rounded-pill px-4">Get Started</a>
            </div>
        </div>
    </div>
</nav>

<!-- ================= CONTACT SECTION ================= -->
<section class="contact-section">
    <h1>Contact Us</h1>
    <div class="contact-info">
        <div>
            <i class="bi bi-telephone"></i>
            <span>Phone:</span>
            <p>+91 12345 67890</p>
        </div>
        <div>
            <i class="bi bi-envelope"></i>
            <span>Email:</span>
            <p>info@vitavest.com</p>
        </div>
        <div>
            <i class="bi bi-geo-alt"></i>
            <span>Address:</span>
            <p>123, Main Street, Pune, Maharashtra, India</p>
        </div>
    </div>
</section>

<!-- ================= FOOTER ================= -->
<footer class="footer">
    <p class="mb-0">© 2026 VitaVest • Designed with calm 🌿</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
