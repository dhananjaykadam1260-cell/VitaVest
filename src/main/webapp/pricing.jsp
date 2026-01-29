<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/vitevista_db", "root", "root"
    );

    String sql = "SELECT * FROM plans ORDER BY price ASC";
    PreparedStatement ps = con.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>VitaVest – Pricing</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

<style>
:root {
    --primary: #43cea2;
    --secondary: #185a9d;
    --light: #f5f7fb;
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


/* Header */
.page-header {
    padding: 140px 0 80px;
    background: linear-gradient(135deg, var(--secondary), var(--primary));
    color: white;
    text-align: center;
}

/* Pricing Cards */
.pricing-card {
    background: rgba(255,255,255,0.8);
    backdrop-filter: blur(14px);
    border-radius: 28px;
    padding: 45px 35px;
    text-align: center;
    box-shadow: 0 16px 40px rgba(0,0,0,0.1);
    transition: all 0.4s ease;
    height: 100%;
}

.pricing-card:hover {
    transform: translateY(-14px);
    box-shadow: 0 30px 70px rgba(0,0,0,0.18);
}

.price {
    font-size: 42px;
    font-weight: 700;
    margin: 20px 0;
    background: linear-gradient(135deg, var(--primary), var(--secondary));
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
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

<!-- HEADER -->
<section class="page-header">
    <div class="container">
        <h1 class="fw-bold display-5">Simple & Transparent Pricing</h1>
        <p class="lead mt-3">Choose a plan that fits your mental wellness journey.</p>
    </div>
</section>

<!-- PRICING -->
<section class="py-5">
    <div class="container">
        <div class="row g-4 justify-content-center">

        <%
            while(rs.next()) {
        %>
            <div class="col-md-4">
                <div class="pricing-card">

                    <h4 class="fw-semibold">
                        <%= rs.getString("plan_name") %>
                    </h4>

                    <div class="price">
                        ₹ <%= rs.getDouble("price") %>
                    </div>

                    <p class="text-muted">
                        Valid for <%= rs.getInt("duration_days") %> days
                    </p>

                    <p class="small text-muted mt-3">
                        <%= rs.getString("description") %>
                    </p>

                </div>
            </div>
        <%
            }
        %>

        </div>
    </div>
</section>

<!-- FOOTER -->
<footer class="footer">
    © 2026 VitaVest • Designed with calm 🌿
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%
    rs.close();
    ps.close();
    con.close();
%>
