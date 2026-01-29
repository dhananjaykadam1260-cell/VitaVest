<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.time.LocalDate, java.sql.Timestamp" %>

<%
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/vitevista_db?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC",
        "root", "root"
    );

    int userId = 1; 

    String userName = "User";
    String planName = "No Active Plan";
    String planStatus = "INACTIVE";
    Timestamp planEndDate = null;

    int checkins = 0, journals = 0, goals = 0;

    PreparedStatement ps;
    ResultSet rs;

    
    ps = con.prepareStatement("SELECT name FROM users WHERE id=?");
    ps.setInt(1, userId);
    rs = ps.executeQuery();
    if (rs.next()) userName = rs.getString("name");
    rs.close();
    ps.close();

    // ✅ ACTIVE PLAN: check session first (payment reflected immediately)
    if (session.getAttribute("planName") != null) {
        planName = (String) session.getAttribute("planName");
        planStatus = (String) session.getAttribute("planStatus");
        LocalDate end = (LocalDate) session.getAttribute("planEndDate");
        if (end != null) planEndDate = Timestamp.valueOf(end.atStartOfDay());
    } else {
        // fallback: DB query
        ps = con.prepareStatement(
            "SELECT p.plan_name, s.end_date FROM subscriptions s " +
            "JOIN plans p ON s.plan_id = p.id " +
            "WHERE s.user_id=? AND s.start_date<=NOW() AND s.end_date>=NOW()"
        );
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        if (rs.next()) {
            planName = rs.getString("plan_name");
            planEndDate = rs.getTimestamp("end_date");
            planStatus = "ACTIVE";
        }
        rs.close();
        ps.close();
    }

    // STATS
    ps = con.prepareStatement("SELECT COUNT(*) FROM checkins WHERE user_id=?");
    ps.setInt(1, userId);
    rs = ps.executeQuery();
    if (rs.next()) checkins = rs.getInt(1);
    rs.close();
    ps.close();

    ps = con.prepareStatement("SELECT COUNT(*) FROM journals WHERE user_id=?");
    ps.setInt(1, userId);
    rs = ps.executeQuery();
    if (rs.next()) journals = rs.getInt(1);
    rs.close();
    ps.close();

    ps = con.prepareStatement("SELECT COUNT(*) FROM goals WHERE user_id=? AND completed=1");
    ps.setInt(1, userId);
    rs = ps.executeQuery();
    if (rs.next()) goals = rs.getInt(1);
    rs.close();
    ps.close();
%>

<!DOCTYPE html>
<html>
<head>
<title>VitaVista | Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

<style>
body {
    background: #f7faf9;
    font-family: "Segoe UI", sans-serif;
}

/* NAVBAR IMPROVEMENT */
.vitavist-navbar {
    background: #ffffff;
    border-bottom: 1px solid #e5e7eb;
    padding: 12px 0;
}

.brand-text {
    font-size: 1.25rem;
    letter-spacing: 0.5px;
}

.nav-link {
    font-weight: 500;
    color: #374151 !important;
    display: flex;
    align-items: center;
    gap: 6px;
}

.nav-link:hover {
    color: #16a34a !important;
}

.dropdown-menu {
    border-radius: 14px;
    border: 1px solid #e5e7eb;
}

.dropdown-item {
    display: flex;
    align-items: center;
    gap: 8px;
}

.tile {
    background: #ffffff;
    border-radius: 20px;
    padding: 24px;
    border: 1px solid #e5e7eb;
    margin-bottom: 24px;
}

.badge-plan {
    background: #d1fae5;
    color: #065f46;
    font-weight: 600;
    border-radius: 20px;
    padding: 6px 14px;
}

.breath-circle {
    width: 160px;
    height: 160px;
    border-radius: 50%;
    background: #e0f2fe;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    margin: auto;
    transition: all 4s ease;
}

.breath-in { transform: scale(1.2); }
.breath-out { transform: scale(0.9); }
</style>
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-light vitavist-navbar shadow-sm">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="dashboard.jsp">
            <i class="bi bi-heart-pulse-fill text-success fs-4"></i>
            <span class="fw-bold brand-text">VitaVista</span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#vvNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="vvNavbar">
            <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-3">

                <li class="nav-item">
                    <a class="nav-link" href="dashboard.jsp">
                        <i class="bi bi-speedometer2"></i> Dashboard
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="new_checkin.jsp">
                        <i class="bi bi-heart"></i> Check-in
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="new_journal.jsp">
                        <i class="bi bi-journal-text"></i> Journal
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="goals.jsp">
                        <i class="bi bi-flag"></i> Goals
                    </a>
                </li>
                <li class="nav-item">
    <a class="btn btn-outline-danger rounded-pill px-3" href="logout.jsp">
        <i class="bi bi-box-arrow-right"></i> Logout
    </a>
</li>
                
            </ul>
        </div>
    </div>
</nav>  

<div class="container my-4">

<!-- WELCOME -->
<div class="tile">
    <h4>Welcome, <%= userName %> 🌿</h4>
    <p class="text-muted">Your wellness overview</p>
    <span class="badge-plan"><%= planName %></span>
</div>

<!-- SUBSCRIPTION -->
<div class="tile">
    <h5><i class="bi bi-award-fill text-success"></i> My Subscription</h5>

    <% if ("ACTIVE".equals(planStatus)) { %>
        <span class="badge bg-success">Active</span>
        <p class="mt-2"><strong>Plan:</strong> <%= planName %></p>
        <p class="text-muted">Valid till: <%= planEndDate %></p>
    <% } else { %>
        <span class="badge bg-secondary">Inactive</span>
        <p class="text-muted mt-2">Upgrade to unlock premium features.</p>
        <a href="plans.jsp" class="btn btn-success rounded-pill">Upgrade Plan</a>
    <% } %>
</div>

<!-- STATS -->
<div class="row g-4">
    <div class="col-md-4">
        <div class="tile text-center">
            <i class="bi bi-heart-pulse fs-2 text-success"></i>
            <h6>Check-ins</h6>
            <h3><%= checkins %></h3>
        </div>
    </div>

    <div class="col-md-4">
        <div class="tile text-center">
            <i class="bi bi-journal-text fs-2 text-primary"></i>
            <h6>Journals</h6>
            <h3><%= journals %></h3>
        </div>
    </div>

    <div class="col-md-4">
        <div class="tile text-center">
            <i class="bi bi-flag-fill fs-2 text-warning"></i>
            <h6>Goals</h6>
            <h3><%= goals %></h3>
        </div>
    </div>
</div>

<!-- RECENT CHECKINS -->
<div class="tile">
<h5>Recent Check-ins</h5>
<%
ps = con.prepareStatement(
    "SELECT mood_score, stress_level, created_at FROM checkins WHERE user_id=? ORDER BY created_at DESC LIMIT 5"
);
ps.setInt(1, userId);
rs = ps.executeQuery();

if (!rs.isBeforeFirst()) {
%>
<p class="text-muted">No check-ins yet.</p>
<%
} else {
while (rs.next()) {
%>
<div class="border rounded p-2 mb-2">
Mood: <strong><%= rs.getInt("mood_score") %>/10</strong>,
Stress: <strong><%= rs.getInt("stress_level") %>/10</strong><br>
<small class="text-muted"><%= rs.getTimestamp("created_at") %></small>
</div>
<%
}}
rs.close();
ps.close();
%>
</div>

<!-- RECENT JOURNALS -->
<div class="tile">
<h5>
Recent Journals
<% if (!"ACTIVE".equals(planStatus)) { %>
<span class="badge bg-warning text-dark">Premium</span>
<% } %>
</h5>

<% if (!"ACTIVE".equals(planStatus)) { %>
<p class="text-muted">Upgrade plan to view journals.</p>
<% } else {

ps = con.prepareStatement(
    "SELECT title, created_at FROM journals WHERE user_id=? ORDER BY created_at DESC LIMIT 5"
);
ps.setInt(1, userId);
rs = ps.executeQuery();

if (!rs.isBeforeFirst()) {
%>
<p class="text-muted">No journals yet.</p>
<%
} else {
while (rs.next()) {
%>
<div class="border rounded p-2 mb-2">
<strong><%= rs.getString("title") %></strong><br>
<small class="text-muted"><%= rs.getTimestamp("created_at") %></small>
</div>
<%
}} 
rs.close();
ps.close();
} %>
</div>

<!-- BREATHING -->
<div class="tile text-center">
<h5>Breathing Exercise</h5>
<div id="breathCircle" class="breath-circle mb-3">Ready</div>
<button class="btn btn-info rounded-pill" onclick="startBreathing()">Start</button>
</div>

<!-- FEEDBACK -->
<div class="tile">
    <h5><i class="bi bi-chat-left-heart-fill text-success"></i> Feedback</h5>

    <!-- SUBMIT FEEDBACK -->
    <form method="post">
        <div class="mb-3">
            <label class="form-label">Your Feedback</label>
            <textarea name="feedback" class="form-control" rows="3"
                      placeholder="Tell us how VitaVista helped you..." required></textarea>
        </div>

        <button class="btn btn-success rounded-pill px-4">
            Submit Feedback
        </button>
    </form>

    <hr>

    <%
    /* ================= SAVE FEEDBACK ================= */
    if ("POST".equalsIgnoreCase(request.getMethod())
        && request.getParameter("feedback") != null
        && request.getParameter("deleteId") == null) {

        String feedbackMsg = request.getParameter("feedback");

        ps = con.prepareStatement(
            "INSERT INTO feedback (user_id, message, status) VALUES (?, ?, 'new')"
        );
        ps.setInt(1, userId);
        ps.setString(2, feedbackMsg);
        ps.executeUpdate();
        ps.close();
    }

    /* ================= DELETE FEEDBACK ================= */
    if (request.getParameter("deleteId") != null) {
        int deleteId = Integer.parseInt(request.getParameter("deleteId"));

        ps = con.prepareStatement(
            "DELETE FROM feedback WHERE id=? AND user_id=?"
        );
        ps.setInt(1, deleteId);
        ps.setInt(2, userId);
        ps.executeUpdate();
        ps.close();
    }
    %>

    <!-- RECENT FEEDBACK -->
    <h6 class="mt-3">Your Recent Feedback</h6>

    <%
    ps = con.prepareStatement(
        "SELECT id, message, status, created_at FROM feedback " +
        "WHERE user_id=? ORDER BY created_at DESC LIMIT 3"
    );
    ps.setInt(1, userId);
    rs = ps.executeQuery();

    if (!rs.isBeforeFirst()) {
    %>
        <p class="text-muted">No feedback submitted yet.</p>
    <%
    } else {
        while (rs.next()) {
            String status = rs.getString("status");
    %>
        <div class="border rounded p-2 mb-2 d-flex justify-content-between align-items-start">
            <div>
                <p class="mb-1"><%= rs.getString("message") %></p>

                <span class="badge 
                    <%= "resolved".equals(status) ? "bg-success" :
                        "read".equals(status) ? "bg-primary" : "bg-warning text-dark" %>">
                    <%= status.toUpperCase() %>
                </span><br>

                <small class="text-muted">
                    <%= rs.getTimestamp("created_at") %>
                </small>
            </div>

            <!-- DELETE BUTTON -->
            <form method="post">
                <input type="hidden" name="deleteId" value="<%= rs.getInt("id") %>">
                <button class="btn btn-sm btn-outline-danger"
                        onclick="return confirm('Delete this feedback?');">
                    <i class="bi bi-trash"></i>
                </button>
            </form>
        </div>
    <%
        }
    }
    rs.close();
    ps.close();
    %>
</div>


</div>

<script>
function startBreathing() {
    const c = document.getElementById("breathCircle");
    c.textContent = "Breathe In";
    c.className = "breath-circle breath-in";

    setTimeout(() => c.textContent = "Hold", 4000);
    setTimeout(() => {
        c.textContent = "Breathe Out";
        c.className = "breath-circle breath-out";
    }, 8000);
    setTimeout(() => {
        c.textContent = "Done 🌿";
        c.className = "breath-circle";
    }, 12000);
}
</script>

</body>
</html>

<%
con.close();
%>
