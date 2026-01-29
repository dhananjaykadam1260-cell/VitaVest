<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    int feedbackId = Integer.parseInt(request.getParameter("id"));

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/vitevista_db", "root", "root"
    );

    // Mark feedback as READ
    PreparedStatement psUpdate =
        con.prepareStatement("UPDATE feedback SET status='read' WHERE id=?");
    psUpdate.setInt(1, feedbackId);
    psUpdate.executeUpdate();

    // Fetch feedback details
    String sql =
        "SELECT f.message, f.status, f.created_at, u.name, u.email " +
        "FROM feedback f " +
        "JOIN users u ON f.user_id = u.id " +
        "WHERE f.id=?";

    PreparedStatement ps = con.prepareStatement(sql);
    ps.setInt(1, feedbackId);
    ResultSet rs = ps.executeQuery();

    if (!rs.next()) {
        response.sendRedirect("admin-feedback.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Feedback | VitaVest Admin</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

<style>
body {
    background: linear-gradient(135deg, #f8fafc, #e2e8f0);
    font-family: "Inter", system-ui, sans-serif;
}

/* Card */
.feedback-card {
    background: rgba(255,255,255,0.8);
    backdrop-filter: blur(14px);
    border-radius: 20px;
    padding: 35px;
    box-shadow: 0 20px 40px rgba(0,0,0,0.08);
    max-width: 850px;
    margin: 60px auto;
}

.label {
    font-weight: 600;
    color: #475569;
    margin-bottom: 4px;
}

.value {
    font-size: 1rem;
    margin-bottom: 20px;
}

.message-box {
    background: #f8fafc;
    border-left: 5px solid #2563eb;
    padding: 20px;
    border-radius: 12px;
    white-space: pre-line;
}

/* Status badges */
.badge-new {
    background: #dbeafe;
    color: #1d4ed8;
}
.badge-read {
    background: #fef3c7;
    color: #92400e;
}
.badge-resolved {
    background: #dcfce7;
    color: #166534;
}
</style>
</head>

<body>

<div class="feedback-card">

    <h3 class="fw-bold mb-4">
        <i class="bi bi-chat-left-text me-2"></i> Feedback Details
    </h3>

    <div class="row mb-3">
        <div class="col-md-6">
            <div class="label">User Name</div>
            <div class="value"><%= rs.getString("name") %></div>
        </div>
        <div class="col-md-6">
            <div class="label">Email</div>
            <div class="value"><%= rs.getString("email") %></div>
        </div>
    </div>

    <div class="row mb-3">
        <div class="col-md-6">
            <div class="label">Date</div>
            <div class="value"><%= rs.getTimestamp("created_at") %></div>
        </div>
        <div class="col-md-6">
            <div class="label">Status</div>
            <div class="value">
                <%
                    String status = rs.getString("status");
                    if ("new".equals(status)) {
                %>
                    <span class="badge badge-new">New</span>
                <% } else if ("read".equals(status)) { %>
                    <span class="badge badge-read">Read</span>
                <% } else { %>
                    <span class="badge badge-resolved">Resolved</span>
                <% } %>
            </div>
        </div>
    </div>

    <div class="label">Message</div>
    <div class="message-box mb-4">
        <%= rs.getString("message") %>
    </div>

    <div class="text-end">
        <a href="admin-feedback.jsp" class="btn btn-secondary">
            <i class="bi bi-arrow-left"></i> Back
        </a>
    </div>

</div>

</body>
</html>

<%
    rs.close();
    ps.close();
    psUpdate.close();
    con.close();
%>
