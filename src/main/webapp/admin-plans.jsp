<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/vitevista_db", "root", "root"
    );

    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM plans ORDER BY created_at DESC");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Plans | VitaVest Admin</title>

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

/* Buttons */
.btn-add {
    background: #16a34a;
    color: #fff;
}
.btn-add:hover { background: #15803d; }

.btn-delete {
    background: #dc2626;
    color: #fff;
}
.btn-delete:hover { background: #b91c1c; }

.desc {
    max-width: 280px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
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
    <a href="adminLogout.jsp"><i class="bi bi-box-arrow-right me-2"></i> Logout</a>
</div>

<!-- MAIN -->
<div class="col-md-10 main">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold">Subscription Plans</h2>
        <a href="add-plan.jsp" class="btn btn-add">
            <i class="bi bi-plus-lg"></i> Add Plan
        </a>
    </div>

    <!-- Alert Messages -->
    <%
        String msg = request.getParameter("msg");
        if ("deleted".equals(msg)) {
    %>
        <div class="alert alert-success">Plan deleted successfully!</div>
    <%
        } else if ("error".equals(msg)) {
    %>
        <div class="alert alert-danger">Error deleting plan!</div>
    <%
        }
    %>

    <div class="glass-card">
        <table class="table table-hover align-middle">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Plan Name</th>
                    <th>Description</th>
                    <th>Price</th>
                    <th>Duration</th>
                    <th>Created</th>
                    <th class="text-center">Actions</th>
                </tr>
            </thead>
            <tbody>

            <% while(rs.next()) { %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td class="fw-semibold"><%= rs.getString("plan_name") %></td>
                    <td class="desc" title="<%= rs.getString("description") %>">
                        <%= rs.getString("description") %>
                    </td>
                    <td>₹ <%= rs.getDouble("price") %></td>
                    <td><%= rs.getInt("duration_days") %> days</td>
                    <td><%= rs.getTimestamp("created_at") %></td>
                    <td class="text-center">
                        <a href="DeletePlanServlet?id=<%= rs.getInt("id") %>"
                           class="btn btn-sm btn-delete"
                           onclick="return confirm('Delete this plan?')">
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
