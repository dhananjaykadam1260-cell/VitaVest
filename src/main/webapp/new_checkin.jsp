<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    int userId = 1;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        int mood = Integer.parseInt(request.getParameter("mood"));
        int stress = Integer.parseInt(request.getParameter("stress"));
        String note = request.getParameter("note");

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/vitevista_db", "root", "root"
        );

        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO checkins (user_id, mood_score, stress_level, note) VALUES (?, ?, ?, ?)"
        );
        ps.setInt(1, userId);
        ps.setInt(2, mood);
        ps.setInt(3, stress);
        ps.setString(4, note);
        ps.executeUpdate();
        con.close();

        // Redirect to user dashboard after successful check-in
        response.sendRedirect("userdashboard.jsp");
        return; // Stop further processing of the JSP
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Daily Check-in</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
    background: linear-gradient(135deg,#eef2ff,#f8fafc);
    font-family: Inter, Segoe UI, sans-serif;
}
.card-box {
    background:white;
    border-radius:24px;
    padding:40px;
    box-shadow:0 30px 60px rgba(0,0,0,0.12);
    max-width:480px;
    width:100%;
}
.range-label {
    font-weight:600;
    display:flex;
    justify-content:space-between;
    align-items:center;
}
.range-value {
    background:#eef2ff;
    color:#4338ca;
    padding:4px 12px;
    border-radius:20px;
    font-size:14px;
}
.btn-round {
    border-radius:30px;
    padding:10px 28px;
}
</style>
</head>

<body>
<div class="container min-vh-100 d-flex align-items-center justify-content-center">
    <div class="card-box">
        <h4 class="fw-bold mb-1">❤️ Daily Check-in</h4>
        <p class="text-muted mb-4">How are you feeling today?</p>

        <form method="post">
            <!-- Mood -->
            <div class="mb-4">
                <div class="range-label">
                    <span>😊 Mood Level</span>
                    <span class="range-value" id="moodVal">5</span>
                </div>
                <input type="range" class="form-range mt-2"
                       min="1" max="10" value="5"
                       name="mood"
                       oninput="moodVal.innerText=this.value">
            </div>

            <!-- Stress -->
            <div class="mb-4">
                <div class="range-label">
                    <span>😖 Stress Level</span>
                    <span class="range-value" id="stressVal">5</span>
                </div>
                <input type="range" class="form-range mt-2"
                       min="1" max="10" value="5"
                       name="stress"
                       oninput="stressVal.innerText=this.value">
            </div>

            <!-- Notes -->
            <div class="mb-4">
                <label class="fw-semibold mb-2">📝 Notes</label>
                <textarea name="note" class="form-control" rows="3"
                          placeholder="Write something about today..."></textarea>
            </div>

            <div class="d-flex justify-content-between">
                <a href="userdashboard.jsp" class="btn btn-outline-secondary btn-round">
                    Back
                </a>
                <button class="btn btn-success btn-round">
                    Save Check-in
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
