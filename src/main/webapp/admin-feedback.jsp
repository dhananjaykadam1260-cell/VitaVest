<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/vitevista_db", "root", "root"
    );

    String sql =
        "SELECT f.id, f.message, f.status, f.created_at, " +
        "u.name, u.email " +
        "FROM feedback f " +
        "JOIN users u ON f.user_id = u.id " +
        "ORDER BY f.created_at DESC";

    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery(sql);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Feedback | VitaVest Admin</title>

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
}
.sidebar a:hover {
    background: rgba(255,255,255,0.08);
    color: #fff;
}

/* Main */
.main {
    padding: 40px;
}

/* Card */
.glass-card {
    background: rgba(255,255,255,0.75);
    backdrop-filter: blur(14px);
    border-radius: 20px;
    padding: 30px;
    box-shadow: 0 20px 40px rgba(0,0,0,0.08);
}

/* Table */
.table th {
    color: #475569;
    font-weight: 600;
}
.table-hover tbody tr:hover {
    background: #f1f5f9;
}

/* Message truncate */
.msg {
    max-width: 320px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

/* Status Badges */
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

/* Action buttons */
.action-btns {
    display: flex;
    justify-content: center;
    gap: 6px;
}
.action-btns .btn {
    padding: 4px 8px;
}

/* Buttons */
.btn-view {
    background: #2563eb;
    color: #fff;
}
.btn-view:hover { background: #1d4ed8; }

.btn-delete {
    background: #dc2626;
    color: #fff;
}
.btn-delete:hover { background: #b91c1c; }
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
    <a href="adminLogout.jsp"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
</div>

<!-- MAIN -->
<div class="col-md-10 main">

    <h2 class="fw-bold mb-3">User Feedback</h2>

    <!-- Alerts -->
    <%
        String msg = request.getParameter("msg");
        if ("deleted".equals(msg)) {
    %>
        <div class="alert alert-success">Feedback deleted successfully!</div>
    <%
        } else if ("error".equals(msg)) {
    %>
        <div class="alert alert-danger">Something went wrong!</div>
    <%
        }
    %>

    <div class="glass-card">
        <table class="table table-hover align-middle">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>User</th>
                    <th>Email</th>
                    <th>Message</th>
                    <th>Status</th>
                    <th>Date</th>
                    <th class="text-center">Actions</th>
                </tr>
            </thead>
            <tbody>

            <% while(rs.next()) { %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td class="fw-semibold"><%= rs.getString("name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td class="msg" title="<%= rs.getString("message") %>">
                        <%= rs.getString("message") %>
                    </td>
                    <td>
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
                    </td>
                    <td><%= rs.getTimestamp("created_at") %></td>
                    <td class="action-btns">
                        <a href="view-feedback.jsp?id=<%= rs.getInt("id") %>"
                           class="btn btn-sm btn-view"
                           title="View">
                           <i class="bi bi-eye"></i>
                        </a>

                        <a href="DeleteFeedbackServlet?id=<%= rs.getInt("id") %>"
                           class="btn btn-sm btn-delete"
                           onclick="return confirm('Delete this feedback?')"
                           title="Delete">
                           <i class="bi bi-trash"></i>
                        </a>
                    </td>
                </tr>
            <% } %>

            </tbody>
        </table>
    </div>

</div>
</div>
</div>

</body>
</html>

<%
    rs.close();
    st.close();
    con.close();
%>
