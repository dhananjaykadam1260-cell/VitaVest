<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>VitaVest Check-in</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

  <style type="text/css">
  :root {
    --primary: #43cea2;
    --secondary: #185a9d;
    --light: #f5f7fb;
    --dark: #1e293b;
}

/* Global */
body {
    font-family: "Segoe UI", system-ui, sans-serif;
    background: var(--light);
    color: #334155;
    line-height: 1.6;
}

html {
    scroll-behavior: smooth;
}

/* Navbar */
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

/* Hero */
.hero {
    min-height: 100vh;
    background:
        radial-gradient(circle at top right, rgba(255,255,255,0.15), transparent 40%),
        linear-gradient(135deg, var(--primary), var(--secondary));
    padding-top: 120px;
}

.hero .badge {
    background: rgba(255,255,255,0.25);
    padding: 8px 18px;
}

.hero .btn-light {
    font-weight: 600;
}

/* Features */
.features {
    padding: 100px 0;
}

.feature-box {
    background: rgba(255,255,255,0.75);
    backdrop-filter: blur(14px);
    padding: 40px 30px;
    border-radius: 26px;
    text-align: center;
    transition: all 0.4s ease;
    box-shadow: 0 14px 35px rgba(0,0,0,0.08);
    height: 100%;
}

.feature-box i {
    font-size: 44px;
    background: linear-gradient(135deg, var(--primary), var(--secondary));
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin-bottom: 18px;
}

.feature-box:hover {
    transform: translateY(-12px);
    box-shadow: 0 28px 60px rgba(0,0,0,0.15);
}

/* CTA */
.cta {
    background:
        radial-gradient(circle at top left, rgba(255,255,255,0.15), transparent 40%),
        linear-gradient(135deg, var(--secondary), var(--primary));
    padding: 90px 20px;
}

/* Footer */
.footer {
    background: white;
    padding: 22px;
    color: #64748b;
    font-size: 14px;
}

/* Animations */
.animate-fade {
    animation: fadeUp 1.2s ease forwards;
}

@keyframes fadeUp {
    from {
        opacity: 0;
        transform: translateY(25px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
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
                <li class="nav-item"><a class="nav-link active" href="index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="features.jsp">Features</a></li>
                <li class="nav-item"><a class="nav-link" href="pricing.jsp">Pricing</a></li>
                <li class="nav-item"><a class="nav-link" href="contact.jsp">Contact</a></li>
                <li class="nav-item"><a class="nav-link" href="adminlogin.jsp">Admin</a></li>
            </ul>

            <div class="d-flex">
                <a href="login.jsp" class="btn btn-outline-primary rounded-pill px-4 me-2">Login</a>
                <a href="register.jsp" class="btn btn-primary rounded-pill px-4">Get Started</a>
            </div>
        </div>
    </div>
</nav>

<!-- ================= HERO ================= -->
<section class="hero d-flex align-items-center">
    <div class="container text-center text-white animate-fade">
        <span class="badge rounded-pill">Mental Wellness</span>
        <h1 class="display-4 fw-bold mt-4">Check In With Yourself</h1>
        <p class="lead mt-3">
            A calm, private space to reflect, track emotions, and grow every day.
        </p>

        <div class="mt-4">
            <a href="register.jsp" class="btn btn-light btn-lg rounded-pill px-5 me-2">
                Start Free
            </a>
            <a href="learnmore.jsp" class="btn btn-outline-light btn-lg rounded-pill px-5">
                Learn More
            </a>
        </div>
    </div>
</section>

<!-- ================= FEATURES ================= -->
<section class="features py-5" id="features">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="fw-bold">How VitaVest Helps You</h2>
            <p class="text-muted">Simple habits. Powerful clarity.</p>
        </div>

        <div class="row g-4">
            <div class="col-md-4">
                <div class="feature-box">
                    <i class="bi bi-heart-pulse"></i>
                    <h4>Relax</h4>
                    <p>Reduce stress with guided breathing and calming check-ins.</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-box">
                    <i class="bi bi-journal-text"></i>
                    <h4>Reflect</h4>
                    <p>Privately journal your thoughts and emotions anytime.</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-box">
                    <i class="bi bi-graph-up-arrow"></i>
                    <h4>Grow</h4>
                    <p>Track mood patterns and build healthy mental habits.</p>
                </div>
            </div>
        </div>
    </div>
</section>


<section class="cta text-center text-white">
    <div class="container">
        <h2 class="fw-bold">Begin Your VitaVest Journey Today</h2>
        <p class="mt-3">Just 2 minutes a day can change how you feel.</p>
        <a href="register.jsp" class="btn btn-light btn-lg rounded-pill px-5 mt-4">
            Begin Check-in
        </a>
    </div>
</section>

<!-- ================= FOOTER ================= -->
<footer class="footer text-center">
    <p class="mb-0">© 2026 VitaVest Check-in • Designed with calm 🌿</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
