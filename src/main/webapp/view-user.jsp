<%@ page import="java.sql.*" %>
<%
    int userId = Integer.parseInt(request.getParameter("id"));

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/vitevista_db", "root", "root"
    );

    PreparedStatement ps = con.prepareStatement(
        "SELECT id, name, email FROM users WHERE id=?"
    );
    ps.setInt(1, userId);
    ResultSet userRs = ps.executeQuery();

    // Activity stats
    int totalCheckins = 0, totalJournals = 0, totalFeedback = 0;

    PreparedStatement ps1 = con.prepareStatement(
        "SELECT COUNT(*) FROM checkins WHERE user_id=?"
    ); ps1.setInt(1,userId); ResultSet rs1=ps1.executeQuery();
    if(rs1.next()) totalCheckins = rs1.getInt(1);

    PreparedStatement ps2 = con.prepareStatement(
        "SELECT COUNT(*) FROM journals WHERE user_id=?"
    ); ps2.setInt(1,userId); ResultSet rs2=ps2.executeQuery();
    if(rs2.next()) totalJournals = rs2.getInt(1);

    PreparedStatement ps3 = con.prepareStatement(
        "SELECT COUNT(*) FROM feedback WHERE user_id=?"
    ); ps3.setInt(1,userId); ResultSet rs3=ps3.executeQuery();
    if(rs3.next()) totalFeedback = rs3.getInt(1);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View User | VitaVest Admin</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

<style>
body {
    background: linear-gradient(135deg, #eef2ff, #e0f2fe);
    font-family: "Inter", system-ui, sans-serif;
    padding: 40px 0;
}

/* Main container */
.main {
    max-width: 900px;
    margin: 0 auto;
}

/* Glass card */
.glass-card {
    background: rgba(255,255,255,0.85);
    backdrop-filter: blur(14px);
    border-radius: 20px;
    padding: 30px;
    box-shadow: 0 20px 40px rgba(0,0,0,0.1);
    margin-bottom: 30px;
}

/* Header */
.user-header {
    background: linear-gradient(90deg, #3b82f6, #06b6d4);
    color: #fff;
    border-radius: 16px 16px 0 0;
    padding: 25px 30px;
    margin: -30px -30px 30px -30px;
    text-align: center;
    box-shadow: 0 6px 15px rgba(0,0,0,0.08);
}

/* Stats cards */
.stat-card {
    background: #ffffff;
    border-radius: 16px;
    padding: 20px;
    text-align: center;
    box-shadow: 0 6px 20px rgba(0,0,0,0.05);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.stat-card:hover {
    transform: translateY(-6px);
    box-shadow: 0 12px 30px rgba(0,0,0,0.1);
}
.stat-card i {
    font-size: 2.2rem;
}
.stat-card h4 {
    margin-top: 10px;
    font-weight: 700;
    font-size: 1.4rem;
}
.stat-card p {
    margin: 0;
    color: #64748b;
    font-size: 0.95rem;
}

/* Back button */
.btn-back {
    background: #2563eb;
    color: #fff;
}
.btn-back:hover {
    background: #1d4ed8;
    color: #fff;
}
</style>
</head>

<body>

<div class="main">

<% if(userRs.next()) { %>

    <div class="glass-card">

        <!-- Header -->
        <div class="user-header">
            <h2 class="fw-bold"><%= userRs.getString("name") %></h2>
            <p class="mb-0"><i class="bi bi-envelope me-2"></i> <%= userRs.getString("email") %></p>
            <small class="text-white-50">User ID: <%= userRs.getInt("id") %></small>
        </div>

        <!-- Activity stats -->
        <h4 class="mb-3 text-center">Activity Stats</h4>
        <div class="row g-4">

            <div class="col-md-4">
                <div class="stat-card">
                    <i class="bi bi-heart-pulse text-danger"></i>
                    <h4><%= totalCheckins %></h4>
                    <p>Check-ins</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card">
                    <i class="bi bi-journal-text text-success"></i>
                    <h4><%= totalJournals %></h4>
                    <p>Journals</p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card">
                    <i class="bi bi-chat-dots text-primary"></i>
                    <h4><%= totalFeedback %></h4>
                    <p>Feedback</p>
                </div>
            </div>

        </div>

        <!-- Back button -->
        <div class="text-center mt-4">
            <a href="admin-users.jsp" class="btn btn-back">
                <i class="bi bi-arrow-left"></i> Back to Users
            </a>
        </div>

    </div>

<% } else { %>
    <div class="alert alert-danger text-center">User not found</div>
<% } %>

</div>

</body>
</html>

<%
    con.close();
%>
