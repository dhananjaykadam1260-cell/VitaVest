<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    int userId = 1; // You can dynamically get this from session if needed

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/vitevista_db", "root", "root"
        );

        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO journals (user_id, title, content, created_at) VALUES (?, ?, ?, NOW())"
        );
        ps.setInt(1, userId);
        ps.setString(2, title);
        ps.setString(3, content);
        ps.executeUpdate();
        con.close();

        // Redirect to dashboard after saving
        response.sendRedirect("userdashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>New Journal Entry</title>
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
    max-width:600px;
    width:100%;
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
        <h4 class="fw-bold mb-3">📝 New Journal Entry</h4>
        <p class="text-muted mb-4">Write your thoughts for today.</p>

        <form method="post">

            <!-- Title -->
            <div class="mb-4">
                <label class="fw-semibold mb-2">Title</label>
                <input type="text" name="title" class="form-control" placeholder="Title of your journal" required>
            </div>

            <!-- Content -->
            <div class="mb-4">
                <label class="fw-semibold mb-2">Content</label>
                <textarea name="content" class="form-control" rows="6" placeholder="Write your thoughts here..." required></textarea>
            </div>

            <div class="d-flex justify-content-between">
                <a href="userdashboard.jsp" class="btn btn-outline-secondary btn-round">Back</a>
                <button class="btn btn-success btn-round">Save Journal</button>
            </div>

        </form>
    </div>

</div>

</body>
</html>
