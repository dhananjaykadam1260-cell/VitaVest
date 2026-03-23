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

<!-- WELLNESS TOOLS -->
<%
/* ===== SAVE STEPS ===== */
if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("save_steps") != null) {
    int steps = Integer.parseInt(request.getParameter("steps_count"));
    ps = con.prepareStatement(
        "INSERT INTO wellness_logs (user_id, log_type, value, logged_at) VALUES (?, 'steps', ?, NOW()) " +
        "ON DUPLICATE KEY UPDATE value = value + ?, logged_at = NOW()"
    );
    ps.setInt(1, userId); ps.setInt(2, steps); ps.setInt(3, steps);
    ps.executeUpdate(); ps.close();
}

/* ===== SAVE STUDY SESSION ===== */
if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("save_study") != null) {
    int studyMins = Integer.parseInt(request.getParameter("study_minutes"));
    ps = con.prepareStatement(
        "INSERT INTO wellness_logs (user_id, log_type, value, logged_at) VALUES (?, 'study', ?, NOW())"
    );
    ps.setInt(1, userId); ps.setInt(2, studyMins);
    ps.executeUpdate(); ps.close();
}

/* ===== SAVE EXERCISE SESSION ===== */
if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("save_exercise") != null) {
    int exMins = Integer.parseInt(request.getParameter("exercise_minutes"));
    ps = con.prepareStatement(
        "INSERT INTO wellness_logs (user_id, log_type, value, logged_at) VALUES (?, 'exercise', ?, NOW())"
    );
    ps.setInt(1, userId); ps.setInt(2, exMins);
    ps.executeUpdate(); ps.close();
}

/* ===== SAVE CALORIES ===== */
if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("save_calories") != null) {
    int cal = Integer.parseInt(request.getParameter("calories_count"));
    ps = con.prepareStatement(
        "INSERT INTO wellness_logs (user_id, log_type, value, logged_at) VALUES (?, 'calories', ?, NOW())"
    );
    ps.setInt(1, userId); ps.setInt(2, cal);
    ps.executeUpdate(); ps.close();
}

/* ===== FETCH TODAY TOTALS ===== */
int todaySteps = 0, todayStudy = 0, todayExercise = 0, todayCalories = 0;

ps = con.prepareStatement(
    "SELECT log_type, SUM(value) as total FROM wellness_logs " +
    "WHERE user_id=? AND DATE(logged_at)=CURDATE() GROUP BY log_type"
);
ps.setInt(1, userId);
rs = ps.executeQuery();
while (rs.next()) {
    String lt = rs.getString("log_type");
    int val = rs.getInt("total");
    if ("steps".equals(lt))    todaySteps    = val;
    if ("study".equals(lt))    todayStudy    = val;
    if ("exercise".equals(lt)) todayExercise = val;
    if ("calories".equals(lt)) todayCalories = val;
}
rs.close(); ps.close();
%>

<div class="tile">
    <h5><i class="bi bi-activity text-success"></i> Wellness Tools</h5>

    <div class="row g-3">

        <!-- STEP COUNTER -->
        <div class="col-md-6">
            <div class="border rounded p-3 h-100">
                <h6><i class="bi bi-person-walking text-success"></i> Step Counter</h6>
                <div class="text-center my-2">
                    <span class="fs-2 fw-bold text-success" id="stepDisplay">0</span>
                    <span class="text-muted"> steps</span><br>
                    <small class="text-muted">Today's total: <strong><%= todaySteps %></strong> steps
                    (~<strong><%= Math.round(todaySteps * 0.04) %></strong> cal burned)</small>
                </div>
                <div class="d-flex gap-2 justify-content-center flex-wrap">
                    <button class="btn btn-sm btn-outline-success rounded-pill" onclick="addSteps(100)">+100</button>
                    <button class="btn btn-sm btn-outline-success rounded-pill" onclick="addSteps(500)">+500</button>
                    <button class="btn btn-sm btn-outline-success rounded-pill" onclick="addSteps(1000)">+1000</button>
                    <button class="btn btn-sm btn-success rounded-pill" onclick="saveSteps()">
                        <i class="bi bi-save"></i> Save
                    </button>
                    <button class="btn btn-sm btn-outline-secondary rounded-pill" onclick="resetSteps()">Reset</button>
                </div>
                <form method="post" id="stepsForm">
                    <input type="hidden" name="save_steps" value="1">
                    <input type="hidden" name="steps_count" id="stepsInput" value="0">
                </form>
            </div>
        </div>

        <!-- CALORIES BURNED -->
        <div class="col-md-6">
            <div class="border rounded p-3 h-100">
                <h6><i class="bi bi-fire text-danger"></i> Calories Burned</h6>
                <div class="text-center my-2">
                    <span class="fs-2 fw-bold text-danger" id="calDisplay">0</span>
                    <span class="text-muted"> kcal</span><br>
                    <small class="text-muted">Today's total: <strong><%= todayCalories %></strong> kcal</small>
                </div>
                <div class="d-flex gap-2 justify-content-center flex-wrap">
                    <button class="btn btn-sm btn-outline-danger rounded-pill" onclick="addCal(50)">+50</button>
                    <button class="btn btn-sm btn-outline-danger rounded-pill" onclick="addCal(100)">+100</button>
                    <button class="btn btn-sm btn-outline-danger rounded-pill" onclick="addCal(200)">+200</button>
                    <button class="btn btn-sm btn-danger rounded-pill" onclick="saveCal()">
                        <i class="bi bi-save"></i> Save
                    </button>
                    <button class="btn btn-sm btn-outline-secondary rounded-pill" onclick="resetCal()">Reset</button>
                </div>
                <form method="post" id="calForm">
                    <input type="hidden" name="save_calories" value="1">
                    <input type="hidden" name="calories_count" id="calInput" value="0">
                </form>
            </div>
        </div>

        <!-- STUDY TIMER -->
        <div class="col-md-6">
            <div class="border rounded p-3 h-100">
                <h6><i class="bi bi-book text-primary"></i> Study Timer</h6>
                <div class="text-center my-2">
                    <span class="fs-2 fw-bold text-primary" id="studyDisplay">25:00</span><br>
                    <small class="text-muted">Today: <strong><%= todayStudy %></strong> min studied</small>
                </div>
                <div class="mb-2 text-center">
                    <select class="form-select form-select-sm w-auto d-inline" id="studyPreset" onchange="setStudyTimer()">
                        <option value="25">Pomodoro 25 min</option>
                        <option value="45">Focus 45 min</option>
                        <option value="60">Deep work 60 min</option>
                        <option value="custom">Custom</option>
                    </select>
                    <input type="number" id="studyCustom" class="form-control form-control-sm d-inline w-auto mt-1"
                           placeholder="Min" min="1" max="180" style="display:none!important;">
                </div>
                <div class="d-flex gap-2 justify-content-center">
                    <button class="btn btn-sm btn-primary rounded-pill" id="studyStartBtn" onclick="toggleStudy()">
                        <i class="bi bi-play-fill"></i> Start
                    </button>
                    <button class="btn btn-sm btn-outline-secondary rounded-pill" onclick="resetStudy()">Reset</button>
                </div>
                <form method="post" id="studyForm">
                    <input type="hidden" name="save_study" value="1">
                    <input type="hidden" name="study_minutes" id="studyInput" value="0">
                </form>
            </div>
        </div>

        <!-- EXERCISE TIMER -->
        <div class="col-md-6">
            <div class="border rounded p-3 h-100">
                <h6><i class="bi bi-bicycle text-warning"></i> Exercise Timer</h6>
                <div class="text-center my-2">
                    <span class="fs-2 fw-bold text-warning" id="exDisplay">00:00</span><br>
                    <small class="text-muted">Today: <strong><%= todayExercise %></strong> min exercised</small>
                </div>
                <div class="mb-2 text-center">
                    <select class="form-select form-select-sm w-auto d-inline" id="exType">
                        <option value="30">Warm-up 30 min</option>
                        <option value="45">Workout 45 min</option>
                        <option value="60">Cardio 60 min</option>
                        <option value="custom">Custom</option>
                    </select>
                    <input type="number" id="exCustom" class="form-control form-control-sm d-inline w-auto mt-1"
                           placeholder="Min" min="1" max="300" style="display:none!important;">
                </div>
                <div class="d-flex gap-2 justify-content-center">
                    <button class="btn btn-sm btn-warning rounded-pill" id="exStartBtn" onclick="toggleExercise()">
                        <i class="bi bi-play-fill"></i> Start
                    </button>
                    <button class="btn btn-sm btn-outline-secondary rounded-pill" onclick="resetExercise()">Reset</button>
                </div>
                <form method="post" id="exForm">
                    <input type="hidden" name="save_exercise" value="1">
                    <input type="hidden" name="exercise_minutes" id="exInput" value="0">
                </form>
            </div>
        </div>

    </div>
</div>

<script>
/* ---- STEP COUNTER ---- */
let stepCount = 0;
function addSteps(n) { stepCount += n; document.getElementById('stepDisplay').textContent = stepCount; }
function resetSteps() { stepCount = 0; document.getElementById('stepDisplay').textContent = 0; }
function saveSteps() {
    if (stepCount === 0) { alert('Add some steps first!'); return; }
    document.getElementById('stepsInput').value = stepCount;
    document.getElementById('stepsForm').submit();
}

/* ---- CALORIES ---- */
let calCount = 0;
function addCal(n) { calCount += n; document.getElementById('calDisplay').textContent = calCount; }
function resetCal() { calCount = 0; document.getElementById('calDisplay').textContent = 0; }
function saveCal() {
    if (calCount === 0) { alert('Add some calories first!'); return; }
    document.getElementById('calInput').value = calCount;
    document.getElementById('calForm').submit();
}

/* ---- STUDY TIMER ---- */
let studyInterval = null, studyRunning = false;
let studyTotalSecs = 25 * 60, studyRemaining = 25 * 60, studyElapsedMins = 0;

function setStudyTimer() {
    const val = document.getElementById('studyPreset').value;
    const customBox = document.getElementById('studyCustom');
    if (val === 'custom') {
        customBox.style.setProperty('display', 'inline-block', 'important');
    } else {
        customBox.style.setProperty('display', 'none', 'important');
        studyTotalSecs = parseInt(val) * 60;
        studyRemaining = studyTotalSecs;
        updateStudyDisplay();
    }
}

function updateStudyDisplay() {
    const m = Math.floor(studyRemaining / 60);
    const s = studyRemaining % 60;
    document.getElementById('studyDisplay').textContent =
        String(m).padStart(2,'0') + ':' + String(s).padStart(2,'0');
}

function toggleStudy() {
    const btn = document.getElementById('studyStartBtn');
    const preset = document.getElementById('studyPreset').value;
    if (preset === 'custom') {
        const cv = parseInt(document.getElementById('studyCustom').value);
        if (!cv || cv < 1) { alert('Enter custom minutes!'); return; }
        studyTotalSecs = cv * 60; studyRemaining = studyTotalSecs;
    }
    if (!studyRunning) {
        studyRunning = true;
        btn.innerHTML = '<i class="bi bi-pause-fill"></i> Pause';
        studyInterval = setInterval(() => {
            if (studyRemaining > 0) {
                studyRemaining--;
                updateStudyDisplay();
            } else {
                clearInterval(studyInterval); studyRunning = false;
                studyElapsedMins = Math.round(studyTotalSecs / 60);
                btn.innerHTML = '<i class="bi bi-play-fill"></i> Start';
                alert('Study session complete! Saving ' + studyElapsedMins + ' minutes.');
                document.getElementById('studyInput').value = studyElapsedMins;
                document.getElementById('studyForm').submit();
            }
        }, 1000);
    } else {
        clearInterval(studyInterval); studyRunning = false;
        studyElapsedMins = Math.round((studyTotalSecs - studyRemaining) / 60);
        btn.innerHTML = '<i class="bi bi-play-fill"></i> Start';
        if (studyElapsedMins > 0) {
            if (confirm('Paused. Save ' + studyElapsedMins + ' min studied so far?')) {
                document.getElementById('studyInput').value = studyElapsedMins;
                document.getElementById('studyForm').submit();
            }
        }
    }
}

function resetStudy() {
    clearInterval(studyInterval); studyRunning = false;
    const preset = document.getElementById('studyPreset').value;
    studyTotalSecs = (preset === 'custom' ? 25 : parseInt(preset)) * 60;
    studyRemaining = studyTotalSecs;
    updateStudyDisplay();
    document.getElementById('studyStartBtn').innerHTML = '<i class="bi bi-play-fill"></i> Start';
}

/* ---- EXERCISE TIMER ---- */
let exInterval = null, exRunning = false, exElapsedSecs = 0, exTargetSecs = 30 * 60;

function updateExDisplay() {
    const m = Math.floor(exElapsedSecs / 60);
    const s = exElapsedSecs % 60;
    document.getElementById('exDisplay').textContent =
        String(m).padStart(2,'0') + ':' + String(s).padStart(2,'0');
}

function toggleExercise() {
    const btn = document.getElementById('exStartBtn');
    const exType = document.getElementById('exType').value;
    if (exType === 'custom' && !exRunning) {
        const cv = parseInt(document.getElementById('exCustom').value);
        if (!cv || cv < 1) { alert('Enter custom minutes!'); return; }
        exTargetSecs = cv * 60;
    } else if (!exRunning) {
        exTargetSecs = parseInt(exType) * 60;
    }
    if (!exRunning) {
        exRunning = true;
        btn.innerHTML = '<i class="bi bi-pause-fill"></i> Pause';
        exInterval = setInterval(() => {
            exElapsedSecs++;
            updateExDisplay();
            if (exElapsedSecs >= exTargetSecs) {
                clearInterval(exInterval); exRunning = false;
                const mins = Math.round(exElapsedSecs / 60);
                btn.innerHTML = '<i class="bi bi-play-fill"></i> Start';
                alert('Exercise done! Saving ' + mins + ' minutes.');
                document.getElementById('exInput').value = mins;
                document.getElementById('exForm').submit();
            }
        }, 1000);
    } else {
        clearInterval(exInterval); exRunning = false;
        const mins = Math.round(exElapsedSecs / 60);
        btn.innerHTML = '<i class="bi bi-play-fill"></i> Start';
        if (mins > 0) {
            if (confirm('Paused. Save ' + mins + ' min exercised so far?')) {
                document.getElementById('exInput').value = mins;
                document.getElementById('exForm').submit();
            }
        }
    }
}

function resetExercise() {
    clearInterval(exInterval); exRunning = false;
    exElapsedSecs = 0; updateExDisplay();
    document.getElementById('exStartBtn').innerHTML = '<i class="bi bi-play-fill"></i> Start';
}

document.getElementById('exType').addEventListener('change', function() {
    document.getElementById('exCustom').style.setProperty(
        'display', this.value === 'custom' ? 'inline-block' : 'none', 'important'
    );
});
</script>

<!-- EMERGENCY CONTACTS -->
<div class="tile">
    <h5><i class="bi bi-telephone-fill text-danger"></i> Emergency Contacts</h5>

    <%
    /* ================= SAVE CONTACT ================= */
    if ("POST".equalsIgnoreCase(request.getMethod())
        && request.getParameter("ec_name") != null) {

        ps = con.prepareStatement("SELECT COUNT(*) FROM emergency_contacts WHERE user_id=?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        int ecCount = 0;
        if (rs.next()) ecCount = rs.getInt(1);
        rs.close(); ps.close();

        if (ecCount < 5) {
            ps = con.prepareStatement(
                "INSERT INTO emergency_contacts (user_id, name, phone, relationship, email) VALUES (?,?,?,?,?)"
            );
            ps.setInt(1, userId);
            ps.setString(2, request.getParameter("ec_name"));
            ps.setString(3, request.getParameter("ec_phone"));
            ps.setString(4, request.getParameter("ec_relationship"));
            ps.setString(5, request.getParameter("ec_email"));
            ps.executeUpdate();
            ps.close();
        }
    }

    /* ================= DELETE CONTACT ================= */
    if (request.getParameter("deleteEcId") != null) {
        int deleteEcId = Integer.parseInt(request.getParameter("deleteEcId"));
        ps = con.prepareStatement("DELETE FROM emergency_contacts WHERE id=? AND user_id=?");
        ps.setInt(1, deleteEcId);
        ps.setInt(2, userId);
        ps.executeUpdate();
        ps.close();
    }

    /* ================= COUNT ================= */
    ps = con.prepareStatement("SELECT COUNT(*) FROM emergency_contacts WHERE user_id=?");
    ps.setInt(1, userId);
    rs = ps.executeQuery();
    int totalEc = 0;
    if (rs.next()) totalEc = rs.getInt(1);
    rs.close(); ps.close();
    %>

    <% if (totalEc < 5) { %>
    <form method="post" class="mb-3">
        <div class="row g-2">
            <div class="col-md-3">
                <input type="text" name="ec_name" class="form-control" placeholder="Name" required>
            </div>
            <div class="col-md-3">
                <input type="text" name="ec_phone" class="form-control" placeholder="Phone number" required>
            </div>
            <div class="col-md-2">
                <input type="text" name="ec_relationship" class="form-control" placeholder="Relation (e.g. Mom)">
            </div>
            <div class="col-md-3">
                <input type="email" name="ec_email" class="form-control" placeholder="Email">
            </div>
            <div class="col-md-1">
                <button class="btn btn-danger rounded-pill w-100" title="Add Contact">
                    <i class="bi bi-plus-lg"></i>
                </button>
            </div>
        </div>
    </form>
    <% } else { %>
    <p class="text-muted small">Maximum 5 contacts reached.</p>
    <% } %>

    <%
    ps = con.prepareStatement(
        "SELECT id, name, phone, relationship, email FROM emergency_contacts WHERE user_id=? ORDER BY id ASC"
    );
    ps.setInt(1, userId);
    rs = ps.executeQuery();

    if (!rs.isBeforeFirst()) {
    %>
        <p class="text-muted">No emergency contacts added yet.</p>
    <%
    } else {
        while (rs.next()) {
            String ecRel = rs.getString("relationship");
            String ecEmail = rs.getString("email");
    %>
        <div class="border rounded p-2 mb-2 d-flex justify-content-between align-items-center">
            <div>
                <strong><%= rs.getString("name") %></strong>
                <% if (ecRel != null && !ecRel.isEmpty()) { %>
                    <span class="badge bg-light text-dark ms-1"><%= ecRel %></span>
                <% } %><br>
                <i class="bi bi-telephone text-danger"></i>
                <a href="tel:<%= rs.getString("phone") %>" class="text-decoration-none text-dark">
                    <%= rs.getString("phone") %>
                </a>
                <% if (ecEmail != null && !ecEmail.isEmpty()) { %>
                    &nbsp;|&nbsp;
                    <i class="bi bi-envelope text-secondary"></i>
                    <a href="mailto:<%= ecEmail %>" class="text-decoration-none text-secondary">
                        <%= ecEmail %>
                    </a>
                <% } %>
            </div>
            <form method="post">
                <input type="hidden" name="deleteEcId" value="<%= rs.getInt("id") %>">
                <button class="btn btn-sm btn-outline-danger"
                        onclick="return confirm('Remove this contact?');">
                    <i class="bi bi-trash"></i>
                </button>
            </form>
        </div>
    <%
        }
    }
    rs.close(); ps.close();
    %>
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
const audioCtx = new (window.AudioContext || window.webkitAudioContext)();

function playBreathSound(type) {
    const oscillator = audioCtx.createOscillator();
    const gainNode = audioCtx.createGain();

    oscillator.connect(gainNode);
    gainNode.connect(audioCtx.destination);

    if (type === 'in') {
        // Breath IN: rising soft tone
        oscillator.type = 'sine';
        oscillator.frequency.setValueAtTime(220, audioCtx.currentTime);
        oscillator.frequency.linearRampToValueAtTime(440, audioCtx.currentTime + 4);
        gainNode.gain.setValueAtTime(0, audioCtx.currentTime);
        gainNode.gain.linearRampToValueAtTime(0.15, audioCtx.currentTime + 1);
        gainNode.gain.linearRampToValueAtTime(0, audioCtx.currentTime + 4);
        oscillator.start(audioCtx.currentTime);
        oscillator.stop(audioCtx.currentTime + 4);
    } else if (type === 'out') {
        // Breath OUT: falling soft tone
        oscillator.type = 'sine';
        oscillator.frequency.setValueAtTime(440, audioCtx.currentTime);
        oscillator.frequency.linearRampToValueAtTime(220, audioCtx.currentTime + 4);
        gainNode.gain.setValueAtTime(0, audioCtx.currentTime);
        gainNode.gain.linearRampToValueAtTime(0.15, audioCtx.currentTime + 1);
        gainNode.gain.linearRampToValueAtTime(0, audioCtx.currentTime + 4);
        oscillator.start(audioCtx.currentTime);
        oscillator.stop(audioCtx.currentTime + 4);
    }
}

function startBreathing() {
    // Resume audio context (required by browsers after user gesture)
    audioCtx.resume();

    const c = document.getElementById("breathCircle");

    // Breathe In
    c.textContent = "Breathe In 🌬️";
    c.className = "breath-circle breath-in";
    playBreathSound('in');

    // Hold
    setTimeout(() => {
        c.textContent = "Hold...";
        c.className = "breath-circle";
    }, 4000);

    // Breathe Out
    setTimeout(() => {
        c.textContent = "Breathe Out 😮‍💨";
        c.className = "breath-circle breath-out";
        playBreathSound('out');
    }, 8000);

    // Done
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
