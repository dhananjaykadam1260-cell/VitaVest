<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Plan | VitaVest Admin</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

<style>
body {
    background: linear-gradient(135deg, #eef2ff, #e0f2fe);
    font-family: "Inter", system-ui, sans-serif;
    padding: 40px 0;
}

.main {
    max-width: 600px;
    margin: 0 auto;
}

.glass-card {
    background: rgba(255,255,255,0.85);
    backdrop-filter: blur(14px);
    border-radius: 20px;
    padding: 30px;
    box-shadow: 0 20px 40px rgba(0,0,0,0.1);
}

h2 {
    text-align: center;
    margin-bottom: 25px;
    color: #2563eb;
}

.btn-submit {
    background: #16a34a;
    color: #fff;
}
.btn-submit:hover {
    background: #15803d;
    color: #fff;
}
</style>
</head>
<body>

<div class="main">

    <div class="glass-card">
        <h2>Add New Plan</h2>

        <% if(request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="AddPlanServlet" method="post">
            <div class="mb-3">
                <label class="form-label">Plan Name</label>
                <input type="text" class="form-control" name="plan_name" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea class="form-control" name="description" rows="3"></textarea>
            </div>

            <div class="mb-3">
                <label class="form-label">Price (₹)</label>
                <input type="number" class="form-control" name="price" step="0.01" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Duration (Days)</label>
                <input type="number" class="form-control" name="duration_days" required>
            </div>

            <div class="text-center">
                <button type="submit" class="btn btn-submit">
                    <i class="bi bi-plus-lg"></i> Add Plan
                </button>
            </div>
        </form>
    </div>

</div>

</body>
</html>
