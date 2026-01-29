<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    // Database connection
    Class.forName("com.mysql.cj.jdbc.Driver");
    try (Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/vitevista_db?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC",
            "root", "root");
         PreparedStatement ps = con.prepareStatement("SELECT * FROM plans ORDER BY price ASC");
         ResultSet rs = ps.executeQuery()) {

        DecimalFormat df = new DecimalFormat("#0.00"); // format price
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
    --primary: #4ade80;  
    --secondary: #22d3ee; 
    --background: #f9fafb;
    --card-bg: #ffffff;
    --accent: #facc15; 
}
body { font-family: 'Segoe UI', sans-serif; background: var(--background); color: #334155; margin:0; padding:0; }
/* Header */
.header-section { background: linear-gradient(120deg, var(--primary), var(--secondary)); padding:100px 0 60px; color:white; text-align:center; }
.header-section h1 { font-size:3rem; font-weight:700; }
.header-section p { font-size:1.2rem; margin-top:10px; }

/* Pricing Cards */
.pricing-card { background: var(--card-bg); border-radius:20px; padding:35px 25px; text-align:center; box-shadow:0 12px 36px rgba(0,0,0,0.08); transition: transform 0.3s, box-shadow 0.3s; display:flex; flex-direction:column; justify-content:space-between; height:100%; position:relative; }
.pricing-card:hover { transform: translateY(-8px); box-shadow:0 24px 60px rgba(0,0,0,0.15); }
.pricing-card h4 { font-size:1.5rem; font-weight:600; }
.price { font-size:2.5rem; font-weight:700; margin:20px 0; background: linear-gradient(120deg, var(--primary), var(--secondary)); -webkit-background-clip:text; -webkit-text-fill-color:transparent; }
.btn-subscribe { background: linear-gradient(120deg, var(--primary), var(--secondary)); color:white; border:none; border-radius:50px; padding:12px 28px; font-weight:600; margin-top:20px; transition: transform 0.2s, box-shadow 0.2s; }
.btn-subscribe:hover { transform:translateY(-3px); box-shadow:0 6px 20px rgba(0,0,0,0.2); }

/* Popular Badge */
.popular-badge { position:absolute; top:-10px; right:-10px; background: var(--accent); color:white; font-weight:600; padding:6px 16px; border-radius:25px; font-size:0.85rem; }

/* Footer */
.footer { padding:30px; text-align:center; font-size:14px; color:#64748b; margin-top:60px; }
</style>
</head>

<body>

<!-- HEADER -->
<section class="header-section">
    <div class="container">
        <h1>VitaVest Pricing Plans</h1>
        <p>Find the perfect plan to support your mental wellness journey</p>
    </div>
</section>

<!-- PRICING CARDS -->
<section class="py-5">
    <div class="container">
        <div class="row g-4 justify-content-center">
<%
    int counter = 1;
    while(rs.next()) {
        int planId = rs.getInt("id");
        String planName = rs.getString("plan_name");
        double price = rs.getDouble("price");
        int duration = rs.getInt("duration_days");
        String desc = rs.getString("description");

        boolean isPopular = (counter == 2); 
%>
            <div class="col-md-4">
                <div class="pricing-card <%= isPopular ? "popular" : "" %>">
                    <% if(isPopular){ %>
                        <div class="popular-badge">Most Popular</div>
                    <% } %>

                    <div>
                        <h4><%= planName %></h4>
                        <div class="price">₹ <%= df.format(price) %></div>
                        <p class="text-muted">Valid for <%= duration %> days</p>
                        <p class="small text-muted mt-2"><%= desc %></p>
                    </div>

                    <form action="SelectPlanServlet" method="post">
                        <input type="hidden" name="planId" value="<%= planId %>">
                        <input type="hidden" name="planName" value="<%= planName %>">
                        <input type="hidden" name="duration" value="<%= duration %>">
                        <input type="hidden" name="price" value="<%= df.format(price) %>">
                        <button type="submit" class="btn btn-subscribe w-100">Subscribe</button>
                    </form>

                </div>
            </div>
<%
        counter++;
    } // end while
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
} // end try
%>
