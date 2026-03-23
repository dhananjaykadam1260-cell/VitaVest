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

        response.sendRedirect("userdashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Daily Check-in | VitaVista</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
    background: linear-gradient(135deg, #eef2ff, #f8fafc);
    font-family: Inter, Segoe UI, sans-serif;
}

.card-box {
    background: white;
    border-radius: 24px;
    padding: 40px;
    box-shadow: 0 30px 60px rgba(0,0,0,0.12);
    max-width: 500px;
    width: 100%;
}

/* MOOD EMOJI CARDS */
.mood-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 12px;
    margin-top: 12px;
}

.mood-card {
    border: 2px solid #e5e7eb;
    border-radius: 16px;
    padding: 14px 8px;
    text-align: center;
    cursor: pointer;
    transition: all 0.2s ease;
    background: #f9fafb;
    user-select: none;
}

.mood-card:hover {
    border-color: #a5b4fc;
    background: #eef2ff;
    transform: translateY(-2px);
}

.mood-card.selected {
    border-color: #4338ca;
    background: #eef2ff;
    box-shadow: 0 0 0 3px rgba(99,102,241,0.2);
    transform: translateY(-2px);
}

.mood-emoji {
    font-size: 2rem;
    display: block;
    margin-bottom: 6px;
}

.mood-label {
    font-size: 12px;
    font-weight: 600;
    color: #374151;
}

.mood-card.selected .mood-label {
    color: #4338ca;
}

/* STRESS SLIDER */
.range-label {
    font-weight: 600;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.range-value {
    background: #eef2ff;
    color: #4338ca;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 14px;
    min-width: 36px;
    text-align: center;
}

.stress-track {
    accent-color: #4338ca;
}

.btn-round {
    border-radius: 30px;
    padding: 10px 28px;
}

.section-title {
    font-weight: 700;
    font-size: 15px;
    color: #111827;
    margin-bottom: 4px;
}

.section-sub {
    font-size: 13px;
    color: #6b7280;
    margin-bottom: 0;
}
</style>
</head>

<body>
<div class="container min-vh-100 d-flex align-items-center justify-content-center py-4">
    <div class="card-box">

        <h4 class="fw-bold mb-1">❤️ Daily Check-in</h4>
        <p class="text-muted mb-4">How are you feeling today?</p>

        <form method="post" onsubmit="return validateMood()">

            <!-- HIDDEN MOOD VALUE -->
            <input type="hidden" name="mood" id="moodValue" value="">

            <!-- MOOD SELECTOR -->
            <div class="mb-4">
                <p class="section-title">😊 How's your mood?</p>
                <p class="section-sub mb-2">Pick what describes you best right now</p>

                <div class="mood-grid">
                    <div class="mood-card" onclick="selectMood(this, 9)" data-value="9">
                        <span class="mood-emoji">😊</span>
                        <span class="mood-label">Happy</span>
                    </div>
                    <div class="mood-card" onclick="selectMood(this, 5)" data-value="5">
                        <span class="mood-emoji">😐</span>
                        <span class="mood-label">Neutral</span>
                    </div>
                    <div class="mood-card" onclick="selectMood(this, 3)" data-value="3">
                        <span class="mood-emoji">😢</span>
                        <span class="mood-label">Sad</span>
                    </div>
                    <div class="mood-card" onclick="selectMood(this, 1)" data-value="1">
                        <span class="mood-emoji">😡</span>
                        <span class="mood-label">Stressed</span>
                    </div>
                </div>

                <div id="moodError" class="text-danger mt-2" style="font-size:13px; display:none;">
                    Please select a mood to continue.
                </div>
            </div>

            <!-- STRESS SLIDER -->
            <div class="mb-4">
                <div class="range-label">
                    <span class="section-title mb-0">😖 Stress Level</span>
                    <span class="range-value" id="stressVal">5</span>
                </div>
                <p class="section-sub mb-2">1 = very calm &nbsp;·&nbsp; 10 = very stressed</p>
                <input type="range" class="form-range stress-track mt-1"
                       min="1" max="10" value="5"
                       name="stress"
                       oninput="stressVal.innerText=this.value">
            </div>

            <!-- NOTES -->
            <div class="mb-4">
                <p class="section-title">📝 Notes <span class="text-muted fw-normal">(optional)</span></p>
                <textarea name="note" class="form-control" rows="3"
                          placeholder="Write something about today..."></textarea>
            </div>

            <!-- BUTTONS -->
            <div class="d-flex justify-content-between">
                <a href="userdashboard.jsp" class="btn btn-outline-secondary btn-round">
                    ← Back
                </a>
                <button type="submit" class="btn btn-success btn-round px-4">
                    Save Check-in ✓
                </button>
            </div>

        </form>
    </div>
</div>

<script>
function selectMood(card, value) {
    document.querySelectorAll('.mood-card').forEach(c => c.classList.remove('selected'));
    card.classList.add('selected');
    document.getElementById('moodValue').value = value;
    document.getElementById('moodError').style.display = 'none';
}

function validateMood() {
    const val = document.getElementById('moodValue').value;
    if (!val) {
        document.getElementById('moodError').style.display = 'block';
        return false;
    }
    return true;
}
</script>

</body>
</html>
