<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>VitaVest – Features</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

    <!-- SAME CSS (INLINE for NOW) -->
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


        .brand-gradient {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 28px;
        }

        .page-header {
            padding: 140px 0 80px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            text-align: center;
        }

        .feature-card {
            background: rgba(255,255,255,0.8);
            backdrop-filter: blur(14px);
            border-radius: 26px;
            padding: 40px 30px;
            text-align: center;
            box-shadow: 0 14px 35px rgba(0,0,0,0.08);
            transition: all 0.4s ease;
            height: 100%;
        }

        .feature-card:hover {
            transform: translateY(-12px);
            box-shadow: 0 28px 60px rgba(0,0,0,0.15);
        }

        .feature-card i {
            font-size: 46px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 20px;
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
            <span class="brand-gradient">VitaVest</span>
        </a>

        <div class="collapse navbar-collapse show">
            <ul class="navbar-nav mx-auto">
                <li class="nav-item"><a class="nav-link" href="LandingPage.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link active" href="features.jsp">Features</a></li>
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

<!-- ================= PAGE HEADER ================= -->
<section class="page-header">
    <div class="container">
        <h1 class="fw-bold display-5">Powerful Features for Your Mind</h1>
        <p class="lead mt-3">Designed to help you feel calmer, clearer, and more in control.</p>
    </div>
</section>

<!-- ================= FEATURES GRID ================= -->
<section class="py-5">
    <div class="container">
        <div class="row g-4">

            <div class="col-md-4">
                <div class="feature-card">
                    <i class="bi bi-heart-pulse"></i>
                    <h4>Daily Mood Check-ins</h4>
                    <p>Track how you feel each day and notice emotional patterns over time.</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <i class="bi bi-journal-text"></i>
                    <h4>Private Journaling</h4>
                    <p>Write your thoughts freely in a secure and distraction-free space.</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <i class="bi bi-bar-chart-line"></i>
                    <h4>Mood Analytics</h4>
                    <p>Visual insights help you understand what affects your mental health.</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <i class="bi bi-wind"></i>
                    <h4>Breathing Exercises</h4>
                    <p>Quick calming techniques to reduce anxiety and regain focus.</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <i class="bi bi-lock"></i>
                    <h4>Privacy First</h4>
                    <p>Your data is encrypted and completely private—always.</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <i class="bi bi-calendar-check"></i>
                    <h4>Healthy Habits</h4>
                    <p>Build consistency with gentle reminders and progress tracking.</p>
                </div>
            </div>

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
