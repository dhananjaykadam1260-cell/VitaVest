<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Login | VitaVest</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Inter', sans-serif;
    height: 100vh;
    background: #f1f5f9;
    display: flex;
    justify-content: center;
    align-items: center;
}

/* Card */
.login-box {
    width: 380px;
    padding: 36px 32px;
    background: #ffffff;
    border-radius: 14px;
    box-shadow: 0 20px 40px rgba(0,0,0,0.08);
    border: 1px solid #e5e7eb;
}

/* Header */
.login-box h2 {
    text-align: center;
    font-weight: 700;
    color: #020617;
}

.login-box p {
    text-align: center;
    font-size: 13px;
    color: #64748b;
    margin: 8px 0 28px;
}

/* Inputs */
.field {
    margin-bottom: 18px;
}

.field label {
    display: block;
    font-size: 13px;
    margin-bottom: 6px;
    color: #475569;
}

.field input {
    width: 100%;
    padding: 12px 14px;
    border-radius: 10px;
    border: 1px solid #cbd5f5;
    font-size: 14px;
    outline: none;
}

.field input:focus {
    border-color: #6366f1;
}

/* Button */
button {
    width: 100%;
    padding: 13px;
    border-radius: 12px;
    border: none;
    background: #6366f1;
    color: #fff;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
}

button:hover {
    background: #4f46e5;
}

/* Error */
.error-msg {
    margin-top: 12px;
    font-size: 13px;
    color: #dc2626;
    text-align: center;
}
</style>
</head>

<body>

<div class="login-box">
    <h2>VitaVest</h2>
    <p>Admin Login</p>

    <form id="adminLoginForm" action="AdminLoginServlet" method="post">

        <div class="field">
            <label>Admin Email</label>
            <input type="email" name="email" required>
        </div>

        <div class="field">
            <label>Password</label>
            <input type="password" name="password" required>
        </div>

        <button type="submit">Login</button>

        <div class="error-msg" id="error-msg"></div>
    </form>
</div>

<script>
const form = document.getElementById('adminLoginForm');
const errorMsg = document.getElementById('error-msg');

form.addEventListener('submit', function (e) {
    if (!form.email.value.trim() || !form.password.value.trim()) {
        e.preventDefault();
        errorMsg.textContent = "Email and password required";
    }
});
</script>

</body>
</html>
