<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Learn More - VitaVest</title>
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

        /* Hero Section */
        .hero {
            min-height: 70vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background:
                radial-gradient(circle at top right, rgba(255,255,255,0.15), transparent 40%),
                linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            text-align: center;
            padding: 100px 20px;
        }

        .hero h1 {
            font-size: 3rem;
            font-weight: bold;
        }

        .hero p {
            font-size: 1.3rem;
            margin-top: 20px;
        }

        .hero .btn {
            margin-top: 30px;
        }

        /* Section Styles */
        .section {
            padding: 80px 20px;
        }

        .section h2 {
            text-align: center;
            color: var(--primary);
            margin-bottom: 20px;
        }

        .section p {
            text-align: center;
            max-width: 700px;
            margin: 0 auto;
            color: #475569;
        }

        .features {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            justify-content: center;
            margin-top: 50px;
        }

        .feature-box {
            background: #fff;
            border-radius: 20px;
            padding: 30px 20px;
            width: 280px;
            text-align: center;
            box-shadow: 0 14px 35px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
        }

        .feature-box i {
            font-size: 40px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
        }

        .feature-box:hover {
            transform: translateY(-10px);
            box-shadow: 0 28px 60px rgba(0,0,0,0.15);
        }

        .footer {
            background: white;
            padding: 22px;
            color: #64748b;
            font-size: 14px;
            text-align: center;
        }

        @media (max-width: 768px) {
            .features {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>

<!-- ================= HERO ================= -->
<section class="hero">
    <div class="container">
        <h1>Discover the Power of VitaVest Check-ins</h1>
        <p>VitaVest helps you build daily habits for mental clarity, emotional balance, and personal growth.</p>
        <a href="register.jsp" class="btn btn-light btn-lg rounded-pill px-5">Start Your Journey</a>
    </div>
</section>

<!-- ================= FEATURES ================= -->
<section class="section">
    <h2>How VitaVest Supports You</h2>
    <p>Our tools are designed to make mindfulness simple, actionable, and meaningful in your daily life.</p>

    <div class="features">
        <div class="feature-box">
            <i class="bi bi-journal"></i>
            <h4>Private Journaling</h4>
            <p>Record your reflections securely and gain insight into your mental patterns.</p>
        </div>

        <div class="feature-box">
            <i class="bi bi-bar-chart-line"></i>
            <h4>Track Your Progress</h4>
            <p>Visualize your mood trends and celebrate personal growth over time.</p>
        </div>

        <div class="feature-box">
            <i class="bi bi-lightning"></i>
            <h4>Quick Exercises</h4>
            <p>Use guided breathing and meditation exercises to quickly reduce stress.</p>
        </div>

        <div class="feature-box">
            <i class="bi bi-people"></i>
            <h4>Community Insights</h4>
            <p>Learn from anonymized data and discover patterns that improve wellbeing.</p>
        </div>

        <div class="feature-box">
            <i class="bi bi-award"></i>
            <h4>Personal Growth</h4>
            <p>Set small daily goals and see measurable improvement in your mental health.</p>
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
