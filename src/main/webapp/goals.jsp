<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    int userId = 1; // Replace with session user ID if available

    // Handle new goal submission
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("action") != null) {
        String action = request.getParameter("action");
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/vitevista_db", "root", "root"
        );

        if ("add".equals(action)) {
            String goalName = request.getParameter("goal_name");
            int targetValue = Integer.parseInt(request.getParameter("target_value"));

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO goals (user_id, goal_name, target_value, current_value, completed) VALUES (?, ?, ?, 0, 0)"
            );
            ps.setInt(1, userId);
            ps.setString(2, goalName);
            ps.setInt(3, targetValue);
            ps.executeUpdate();
            ps.close();
        } else if ("complete".equals(action)) {
            int goalId = Integer.parseInt(request.getParameter("goalId"));
            PreparedStatement ps = con.prepareStatement(
                "UPDATE goals SET completed=1 WHERE id=? AND user_id=?"
            );
            ps.setInt(1, goalId);
            ps.setInt(2, userId);
            ps.executeUpdate();
            ps.close();
        }

        con.close();
        response.sendRedirect("goals.jsp"); 
        return;
    }

    // Load user goals
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/vitevista_db", "root", "root"
    );
    PreparedStatement psGoals = con.prepareStatement(
        "SELECT id, goal_name, target_value, current_value, start_date, end_date, completed FROM goals WHERE user_id=? ORDER BY id DESC"
    );
    psGoals.setInt(1, userId);
    ResultSet rsGoals = psGoals.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Goals</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
    background: linear-gradient(135deg,#eef2ff,#f8fafc);
    font-family: 'Inter', sans-serif;
}
.container {
    padding-top: 40px;
    padding-bottom: 40px;
}
.card-box {
    background: #fff;
    border-radius: 20px;
    padding: 30px;
    box-shadow: 0 15px 35px rgba(0,0,0,0.1);
}
.btn-round {
    border-radius: 25px;
    padding: 10px 25px;
}
.goal-card {
    border-radius: 15px;
    padding: 20px;
    margin-bottom: 20px;
    transition: transform 0.2s;
}
.goal-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.12);
}
.completed {
    background: #f0f0f0;
    text-decoration: line-through;
    color: gray;
}
.progress {
    height: 12px;
    border-radius: 10px;
}
</style>
</head>
<body>

<div class="container d-flex justify-content-center">
    <div class="card-box col-md-8">

        <h3 class="fw-bold mb-4 text-center">🎯 My Goals</h3>

        <!-- Add Goal Form -->
        <form method="post" class="mb-5">
            <input type="hidden" name="action" value="add">
            <div class="row g-2">
                <div class="col-md-8">
                    <input type="text" name="goal_name" class="form-control form-control-lg" placeholder="Goal Name" required>
                </div>
                <div class="col-md-4">
                    <input type="number" name="target_value" class="form-control form-control-lg" placeholder="Target Value" value="0" min="0">
                </div>
            </div>
            <div class="text-end mt-3">
                <button class="btn btn-success btn-round">Add Goal</button>
            </div>
        </form>

        <!-- Goals List -->
        <% while (rsGoals.next()) { 
            int goalId = rsGoals.getInt("id");
            String goalName = rsGoals.getString("goal_name");
            int targetValue = rsGoals.getInt("target_value");
            int currentValue = rsGoals.getInt("current_value");
            Date startDate = rsGoals.getDate("start_date");
            Date endDate = rsGoals.getDate("end_date");
            boolean completed = rsGoals.getInt("completed") == 1;
            int progressPercent = targetValue > 0 ? (int)((currentValue*100)/targetValue) : 0;
        %>
            <div class="goal-card border <% if(completed){ %>completed<% } %>">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h5 class="mb-0"><%= goalName %></h5>
                    <% if (!completed) { %>
                        <form method="post" style="display:inline;">
                            <input type="hidden" name="action" value="complete">
                            <input type="hidden" name="goalId" value="<%= goalId %>">
                            <button class="btn btn-outline-primary btn-sm btn-round">Mark Completed</button>
                        </form>
                    <% } else { %>
                        <span class="badge bg-success">Completed</span>
                    <% } %>
                </div>
                <small>From <%= startDate %> to <%= endDate != null ? endDate : "-" %></small>
                <div class="progress mt-2">
                    <div class="progress-bar <% if(completed){ %>bg-success<% } else { %>bg-primary<% } %>" role="progressbar" style="width: <%= progressPercent %>%;" aria-valuenow="<%= progressPercent %>" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
                <small class="d-block mt-1">Progress: <%= currentValue %> / <%= targetValue %></small>
            </div>
        <% } %>

        <div class="text-center mt-4">
            <a href="userdashboard.jsp" class="btn btn-outline-secondary btn-round">Back to Dashboard</a>
        </div>

    </div>
</div>

<%
    rsGoals.close();
    psGoals.close();
    con.close();
%>
</body>
</html>
