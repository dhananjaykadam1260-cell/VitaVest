<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Payments | VitaVest</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

<style>
body {
    background: linear-gradient(135deg, #f8fafc, #e2e8f0);
    font-family: "Inter", system-ui, sans-serif;
}

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
}

.sidebar a:hover,
.sidebar a.active {
    background: rgba(255,255,255,0.08);
    color: #fff;
}
</style>
</head>

<body>

<div class="container-fluid">
<div class="row">

<!-- SIDEBAR -->
<div class="col-md-2 sidebar">
    <h4 class="text-center">VitaVest Admin</h4>

    <a href="admin-dashboard.jsp"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
    <a href="admin-users.jsp"><i class="bi bi-people me-2"></i> Users</a>
    <a href="admin-plans.jsp"><i class="bi bi-box me-2"></i> Plans</a>
    <a href="admin-feedback.jsp"><i class="bi bi-chat-dots me-2"></i> Feedback</a>

    <a href="admin-payments.jsp" class="active">
        <i class="bi bi-credit-card-2-front me-2"></i> Payments
    </a>

    <a href="adminLogout.jsp"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
</div>

<!-- MAIN -->
<div class="col-md-10 p-5">
    <h2 class="fw-bold mb-4">Payments / Subscriptions</h2>

    <div class="card shadow-sm rounded-4">
        <div class="card-body">

            <table class="table align-middle">
                <thead class="table-light">
                    <tr>
                        <th>User</th>
                        <th>Plan</th>
                        <th>Status</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                    </tr>
                </thead>
                <tbody>

                <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/vitevista_db", "root", "root"
                    );

                    String sql =
                        "SELECT u.name, p.plan_name, s.status, s.start_date, s.end_date " +
                        "FROM subscriptions s " +
                        "JOIN users u ON s.user_id = u.id " +
                        "JOIN plans p ON s.plan_id = p.id " +
                        "ORDER BY s.created_at DESC";

                    PreparedStatement ps = con.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();

                    if (!rs.isBeforeFirst()) {
                %>
                    <tr>
                        <td colspan="5" class="text-center text-muted">
                            No subscriptions found
                        </td>
                    </tr>
                <%
                    } else {
                        while (rs.next()) {
                            String status = rs.getString("status");
                %>
                    <tr>
                        <td><%= rs.getString("name") %></td>
                        <td><%= rs.getString("plan_name") %></td>
                        <td>
                            <span class="badge
                                <%= "active".equalsIgnoreCase(status) ? "bg-success" :
                                    "expired".equalsIgnoreCase(status) ? "bg-secondary" :
                                    "bg-danger" %>">
                                <%= status.toUpperCase() %>
                            </span>
                        </td>
                        <td><%= rs.getDate("start_date") %></td>
                        <td><%= rs.getDate("end_date") %></td>
                    </tr>
                <%
                        }
                    }
                    con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
                %>

                </tbody>
            </table>

        </div>
    </div>

</div>

</div>
</div>

</body>
</html>
