<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    int totalUsers = 0;
    int totalCheckins = 0;
    int totalJournals = 0;
    int activeSubs = 0;
    int newFeedback = 0;
    double avgMood = 0.0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/vitevista_db", "root", "root"
        );
        Statement st = con.createStatement();
        ResultSet rs;

        rs = st.executeQuery("SELECT COUNT(*) FROM users");
        if (rs.next()) totalUsers = rs.getInt(1);

        rs = st.executeQuery("SELECT COUNT(*) FROM checkins");
        if (rs.next()) totalCheckins = rs.getInt(1);

        rs = st.executeQuery("SELECT COUNT(*) FROM journals");
        if (rs.next()) totalJournals = rs.getInt(1);

        rs = st.executeQuery("SELECT COUNT(*) FROM subscriptions WHERE status='active'");
        if (rs.next()) activeSubs = rs.getInt(1);

        rs = st.executeQuery("SELECT COUNT(*) FROM feedback WHERE status='new'");
        if (rs.next()) newFeedback = rs.getInt(1);

        rs = st.executeQuery("SELECT ROUND(AVG(mood_score),1) FROM checkins");
        if (rs.next()) avgMood = rs.getDouble(1);

        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard | VitaVest</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

<style>
body {
    background: linear-gradient(135deg, #f8fafc, #e2e8f0);
    font-family: "Inter", system-ui, sans-serif;
}

/* Sidebar */
.sidebar {
    height: 100vh;
    background: linear-gradient(180deg, #0f172a, #020617);
    color: #fff;
    padding-top: 30px;
}

.sidebar h4 {
    font-weight: 700;
    margin-bottom: 30px;
}

.sidebar a {
    color: #c7d2fe;
    padding: 14px 24px;
    display: block;
    text-decoration: none;
    font-weight: 500;
    transition: 0.3s;
}

.sidebar a:hover {
    background: rgba(255,255,255,0.08);
    color: #fff;
}

/* Dashboard Cards */
.stat-card {
    background: rgba(255,255,255,0.75);
    backdrop-filter: blur(12px);
    border-radius: 20px;
    padding: 28px;
    text-align: center;
    box-shadow: 0 20px 40px rgba(0,0,0,0.08);
    transition: transform 0.3s ease;
}

.stat-card:hover {
    transform: translateY(-8px);
}

.stat-card i {
    font-size: 36px;
    padding: 16px;
    border-radius: 14px;
    margin-bottom: 10px;
    display: inline-block;
}

.stat-card h6 {
    color: #64748b;
    font-size: 14px;
}

.stat-card h3 {
    font-weight: 800;
    color: #0f172a;
}

/* Icon colors */
.icon-blue { background:#e0f2fe; color:#0284c7; }
.icon-red { background:#fee2e2; color:#dc2626; }
.icon-green { background:#dcfce7; color:#16a34a; }
.icon-yellow { background:#fef9c3; color:#ca8a04; }
.icon-purple { background:#ede9fe; color:#7c3aed; }
.icon-gray { background:#e5e7eb; color:#374151; }
</style>
</head>

<body>

<div class="container-fluid">
<div class="row">

<!-- Sidebar -->
<div class="col-md-2 sidebar">
    <h4 class="text-center">VitaVest Admin</h4>
    <a href="admin-dashboard.jsp"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
    <a href="admin-users.jsp"><i class="bi bi-people me-2"></i> Users</a>
    <a href="admin-plans.jsp"><i class="bi bi-box me-2"></i> Plans</a>
    <a href="admin-feedback.jsp"><i class="bi bi-chat-dots me-2"></i> Feedback</a>
    <a href="admin-payments.jsp"><i class="bi bi-credit-card-2-front me-2"></i> Payments</a>
    <a href="adminLogout.jsp"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
</div>

<!-- Main -->
<div class="col-md-10 p-5">
    <h2 class="fw-bold mb-4">Dashboard Overview</h2>

    <div class="row g-4">

        <div class="col-md-4">
            <div class="stat-card">
                <i class="bi bi-people icon-blue"></i>
                <h6>Total Users</h6>
                <h3><%= totalUsers %></h3>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card">
                <i class="bi bi-heart-pulse icon-red"></i>
                <h6>Check-ins</h6>
                <h3><%= totalCheckins %></h3>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card">
                <i class="bi bi-journal-text icon-green"></i>
                <h6>Journals</h6>
                <h3><%= totalJournals %></h3>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card">
                <i class="bi bi-credit-card icon-yellow"></i>
                <h6>Payments</h6>
                <h3><%= activeSubs %></h3>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card">
                <i class="bi bi-chat-left-text icon-purple"></i>
                <h6>New Feedback</h6>
                <h3><%= newFeedback %></h3>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card">
                <i class="bi bi-emoji-smile icon-gray"></i>
                <h6>Avg Mood</h6>
                <h3><%= avgMood %></h3>
            </div>
        </div>

    </div>
</div>

</div>
</div>

</body>
</html>
