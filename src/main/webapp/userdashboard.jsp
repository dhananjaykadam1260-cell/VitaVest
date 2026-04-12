<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.time.LocalDate, java.sql.Timestamp" %>

<%
    /* ============================================================
       SECURITY: Read userId from session — NOT hardcoded
       ============================================================ */
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/vitevista_db?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC",
        "root", "root"
    );

    String userName  = "User";
    String planName  = "No Active Plan";
    String planStatus = "INACTIVE";
    Timestamp planEndDate = null;

    int checkins = 0, journals = 0, goals = 0;

    PreparedStatement ps;
    ResultSet rs;

    /* ---------- USER NAME ---------- */
    ps = con.prepareStatement("SELECT name FROM users WHERE id=?");
    ps.setInt(1, userId);
    rs = ps.executeQuery();
    if (rs.next()) userName = rs.getString("name");
    rs.close(); ps.close();

    /* ---------- ACTIVE PLAN (session first, then DB) ---------- */
    if (session.getAttribute("planName") != null) {
        planName   = (String)    session.getAttribute("planName");
        planStatus = (String)    session.getAttribute("planStatus");
        LocalDate end = (LocalDate) session.getAttribute("planEndDate");
        if (end != null) planEndDate = Timestamp.valueOf(end.atStartOfDay());
    } else {
        ps = con.prepareStatement(
            "SELECT p.plan_name, s.end_date FROM subscriptions s " +
            "JOIN plans p ON s.plan_id = p.id " +
            "WHERE s.user_id=? AND s.start_date<=NOW() AND s.end_date>=NOW()"
        );
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        if (rs.next()) {
            planName    = rs.getString("plan_name");
            planEndDate = rs.getTimestamp("end_date");
            planStatus  = "ACTIVE";
        }
        rs.close(); ps.close();
    }

    /* ---------- STATS ---------- */
    ps = con.prepareStatement("SELECT COUNT(*) FROM checkins WHERE user_id=?");
    ps.setInt(1, userId); rs = ps.executeQuery();
    if (rs.next()) checkins = rs.getInt(1);
    rs.close(); ps.close();

    ps = con.prepareStatement("SELECT COUNT(*) FROM journals WHERE user_id=?");
    ps.setInt(1, userId); rs = ps.executeQuery();
    if (rs.next()) journals = rs.getInt(1);
    rs.close(); ps.close();

    ps = con.prepareStatement("SELECT COUNT(*) FROM goals WHERE user_id=? AND completed=1");
    ps.setInt(1, userId); rs = ps.executeQuery();
    if (rs.next()) goals = rs.getInt(1);
    rs.close(); ps.close();

    /* ---------- WELLNESS LOGS: SAVE (POST handlers) ---------- */
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        if (request.getParameter("save_steps") != null) {
            int steps = Integer.parseInt(request.getParameter("steps_count"));
            ps = con.prepareStatement(
                "INSERT INTO wellness_logs (user_id, log_type, value, logged_at) VALUES (?, 'steps', ?, NOW()) " +
                "ON DUPLICATE KEY UPDATE value = value + ?, logged_at = NOW()"
            );
            ps.setInt(1, userId); ps.setInt(2, steps); ps.setInt(3, steps);
            ps.executeUpdate(); ps.close();
        }

        if (request.getParameter("save_study") != null) {
            int studyMins = Integer.parseInt(request.getParameter("study_minutes"));
            ps = con.prepareStatement(
                "INSERT INTO wellness_logs (user_id, log_type, value, logged_at) VALUES (?, 'study', ?, NOW())"
            );
            ps.setInt(1, userId); ps.setInt(2, studyMins);
            ps.executeUpdate(); ps.close();
        }

        if (request.getParameter("save_exercise") != null) {
            int exMins = Integer.parseInt(request.getParameter("exercise_minutes"));
            ps = con.prepareStatement(
                "INSERT INTO wellness_logs (user_id, log_type, value, logged_at) VALUES (?, 'exercise', ?, NOW())"
            );
            ps.setInt(1, userId); ps.setInt(2, exMins);
            ps.executeUpdate(); ps.close();
        }

        if (request.getParameter("save_calories") != null) {
            int cal = Integer.parseInt(request.getParameter("calories_count"));
            ps = con.prepareStatement(
                "INSERT INTO wellness_logs (user_id, log_type, value, logged_at) VALUES (?, 'calories', ?, NOW())"
            );
            ps.setInt(1, userId); ps.setInt(2, cal);
            ps.executeUpdate(); ps.close();
        }

        /* ---------- EMERGENCY CONTACT: SAVE ---------- */
        if (request.getParameter("ec_name") != null) {
            ps = con.prepareStatement("SELECT COUNT(*) FROM emergency_contacts WHERE user_id=?");
            ps.setInt(1, userId); rs = ps.executeQuery();
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
                ps.executeUpdate(); ps.close();
            }
        }

        /* ---------- EMERGENCY CONTACT: DELETE ---------- */
        if (request.getParameter("deleteEcId") != null) {
            int deleteEcId = Integer.parseInt(request.getParameter("deleteEcId"));
            ps = con.prepareStatement("DELETE FROM emergency_contacts WHERE id=? AND user_id=?");
            ps.setInt(1, deleteEcId); ps.setInt(2, userId);
            ps.executeUpdate(); ps.close();
        }

        /* ---------- FEEDBACK: SAVE ---------- */
        if (request.getParameter("feedback") != null && request.getParameter("deleteId") == null) {
            ps = con.prepareStatement(
                "INSERT INTO feedback (user_id, message, status) VALUES (?, ?, 'new')"
            );
            ps.setInt(1, userId);
            ps.setString(2, request.getParameter("feedback"));
            ps.executeUpdate(); ps.close();
        }

        /* ---------- FEEDBACK: DELETE ---------- */
        if (request.getParameter("deleteId") != null) {
            int deleteId = Integer.parseInt(request.getParameter("deleteId"));
            ps = con.prepareStatement("DELETE FROM feedback WHERE id=? AND user_id=?");
            ps.setInt(1, deleteId); ps.setInt(2, userId);
            ps.executeUpdate(); ps.close();
        }
    }

    /* ---------- WELLNESS LOGS: FETCH TODAY TOTALS ---------- */
    int todaySteps = 0, todayStudy = 0, todayExercise = 0, todayCalories = 0;
    ps = con.prepareStatement(
        "SELECT log_type, SUM(value) as total FROM wellness_logs " +
        "WHERE user_id=? AND DATE(logged_at)=CURDATE() GROUP BY log_type"
    );
    ps.setInt(1, userId); rs = ps.executeQuery();
    while (rs.next()) {
        String lt  = rs.getString("log_type");
        int    val = rs.getInt("total");
        if ("steps".equals(lt))    todaySteps    = val;
        if ("study".equals(lt))    todayStudy    = val;
        if ("exercise".equals(lt)) todayExercise = val;
        if ("calories".equals(lt)) todayCalories = val;
    }
    rs.close(); ps.close();

    /* ---------- EMERGENCY CONTACT COUNT ---------- */
    ps = con.prepareStatement("SELECT COUNT(*) FROM emergency_contacts WHERE user_id=?");
    ps.setInt(1, userId); rs = ps.executeQuery();
    int totalEc = 0;
    if (rs.next()) totalEc = rs.getInt(1);
    rs.close(); ps.close();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>VitaVest | Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=DM+Serif+Display&display=swap" rel="stylesheet">

<style>
:root {
    --green:      #16a34a;
    --green-lt:   #dcfce7;
    --green-mid:  #bbf7d0;
    --bg:         #f0faf4;
    --card:       #ffffff;
    --border:     #e2e8f0;
    --text:       #1e293b;
    --muted:      #64748b;
    --danger:     #dc2626;
    --primary:    #2563eb;
    --warning:    #d97706;
    --radius:     18px;
    --shadow:     0 1px 4px rgba(0,0,0,.06), 0 4px 16px rgba(0,0,0,.04);
}

* { box-sizing: border-box; }

body {
    background: var(--bg);
    font-family: 'DM Sans', sans-serif;
    color: var(--text);
    margin: 0;
}

/* ── NAVBAR ── */
.vv-navbar {
    background: #fff;
    border-bottom: 1px solid var(--border);
    padding: 10px 0;
    position: sticky;
    top: 0;
    z-index: 100;
}

.vv-brand {
    font-family: 'DM Serif Display', serif;
    font-size: 1.35rem;
    color: var(--green) !important;
    text-decoration: none;
    display: flex;
    align-items: center;
    gap: 8px;
}

.vv-nav-link {
    font-size: .9rem;
    font-weight: 500;
    color: var(--muted) !important;
    text-decoration: none;
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 6px 12px;
    border-radius: 10px;
    transition: background .15s, color .15s;
}
.vv-nav-link:hover { background: var(--green-lt); color: var(--green) !important; }

/* ── CARD / TILE ── */
.tile {
    background: var(--card);
    border-radius: var(--radius);
    border: 1px solid var(--border);
    padding: 24px;
    margin-bottom: 20px;
    box-shadow: var(--shadow);
}

.tile-title {
    font-size: 1rem;
    font-weight: 700;
    margin-bottom: 16px;
    display: flex;
    align-items: center;
    gap: 8px;
}

/* ── WELCOME BANNER ── */
.welcome-banner {
    background: linear-gradient(120deg, #16a34a 0%, #15803d 100%);
    color: #fff;
    border-radius: var(--radius);
    padding: 28px 32px;
    margin-bottom: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
    box-shadow: 0 4px 20px rgba(22,163,74,.25);
}
.welcome-banner h3 {
    font-family: 'DM Serif Display', serif;
    font-size: 1.6rem;
    margin: 0;
}
.welcome-banner p  { margin: 4px 0 0; opacity: .85; font-size: .9rem; }
.badge-plan {
    background: rgba(255,255,255,.2);
    color: #fff;
    border: 1px solid rgba(255,255,255,.4);
    border-radius: 40px;
    padding: 6px 18px;
    font-size: .85rem;
    font-weight: 600;
    backdrop-filter: blur(4px);
}

/* ── STAT CARDS ── */
.stat-card {
    background: var(--card);
    border-radius: var(--radius);
    border: 1px solid var(--border);
    padding: 22px 16px;
    text-align: center;
    box-shadow: var(--shadow);
    transition: transform .2s;
}
.stat-card:hover { transform: translateY(-3px); }
.stat-card .stat-num { font-size: 2.2rem; font-weight: 700; line-height: 1; }
.stat-card .stat-label { font-size: .8rem; color: var(--muted); margin-top: 4px; font-weight: 500; text-transform: uppercase; letter-spacing: .5px; }

/* ── CHECKIN / JOURNAL ROWS ── */
.log-row {
    background: var(--bg);
    border: 1px solid var(--border);
    border-radius: 12px;
    padding: 10px 14px;
    margin-bottom: 8px;
    font-size: .9rem;
}

/* ── BREATHING ── */
.breath-circle {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    background: radial-gradient(circle, #bbf7d0, #d1fae5);
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: .95rem;
    color: var(--green);
    margin: 0 auto 16px;
    transition: transform 4s ease, background 4s ease;
    border: 3px solid var(--green-mid);
    box-shadow: 0 0 0 0 rgba(22,163,74,.3);
}
.breath-in  { transform: scale(1.22); box-shadow: 0 0 0 12px rgba(22,163,74,.1); }
.breath-out { transform: scale(0.88); background: radial-gradient(circle, #e0f2fe, #bfdbfe); }

/* ── WELLNESS TOOL CARDS ── */
.wtool {
    background: var(--bg);
    border: 1px solid var(--border);
    border-radius: 14px;
    padding: 18px;
    height: 100%;
}
.wtool h6 { font-weight: 700; margin-bottom: 12px; font-size: .9rem; }
.big-num { font-size: 2rem; font-weight: 700; line-height: 1.1; }

/* ── FEEDBACK STATUS BADGES ── */
.badge-new      { background: #fef9c3; color: #854d0e; }
.badge-read     { background: #dbeafe; color: #1d4ed8; }
.badge-resolved { background: #dcfce7; color: #15803d; }

/* ── BUTTONS ── */
.btn-green { background: var(--green); color: #fff; border: none; border-radius: 40px; }
.btn-green:hover { background: #15803d; color: #fff; }
</style>
</head>

<body>

<!-- ══════════════════ NAVBAR ══════════════════ -->
<nav class="vv-navbar shadow-sm">
    <div class="container d-flex align-items-center justify-content-between flex-wrap gap-2">

        <a class="vv-brand" href="dashboard.jsp">
            <i class="bi bi-heart-pulse-fill"></i> VitaVest
        </a>

        <button class="navbar-toggler border-0 d-lg-none" type="button"
                data-bs-toggle="collapse" data-bs-target="#vvNav">
            <i class="bi bi-list fs-4"></i>
        </button>

        <div class="collapse navbar-collapse d-lg-flex justify-content-end" id="vvNav">
            <div class="d-flex flex-wrap gap-1 align-items-center mt-2 mt-lg-0">
                <a class="vv-nav-link" href="userdashboard.jsp">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
                <a class="vv-nav-link" href="new_checkin.jsp">
                    <i class="bi bi-heart"></i> Check-in
                </a>
                <a class="vv-nav-link" href="new_journal.jsp">
                    <i class="bi bi-journal-text"></i> Journal
                </a>
                <a class="vv-nav-link" href="goals.jsp">
                    <i class="bi bi-flag"></i> Goals
                </a>
                <a href="logout.jsp" class="btn btn-sm btn-outline-danger rounded-pill ms-2 px-3">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </a>
            </div>
        </div>

    </div>
</nav>

<!-- ══════════════════ MAIN ══════════════════ -->
<div class="container my-4">

    <!-- WELCOME BANNER -->
    <div class="welcome-banner">
        <div>
            <h3>Welcome back, <%= userName %> 🌿</h3>
            <p>Here's your wellness overview for today</p>
        </div>
        <span class="badge-plan"><i class="bi bi-award-fill me-1"></i><%= planName %></span>
    </div>

    <!-- SUBSCRIPTION CARD -->
    <div class="tile">
        <div class="tile-title">
            <i class="bi bi-award-fill text-success"></i> My Subscription
        </div>
        <% if ("ACTIVE".equals(planStatus)) { %>
            <span class="badge bg-success rounded-pill px-3">Active</span>
            <p class="mt-2 mb-0"><strong>Plan:</strong> <%= planName %></p>
            <p class="text-muted small">Valid till: <%= planEndDate %></p>
        <% } else { %>
            <span class="badge bg-secondary rounded-pill px-3">Inactive</span>
            <p class="text-muted mt-2 mb-2">Upgrade to unlock premium features.</p>
            <a href="plans.jsp" class="btn btn-green btn-sm px-4">
                <i class="bi bi-lightning-charge-fill me-1"></i>Upgrade Plan
            </a>
        <% } %>
    </div>

    <!-- STAT CARDS -->
    <div class="row g-3 mb-4">
        <div class="col-4">
            <div class="stat-card">
                <i class="bi bi-heart-pulse fs-3 text-success"></i>
                <div class="stat-num text-success"><%= checkins %></div>
                <div class="stat-label">Check-ins</div>
            </div>
        </div>
        <div class="col-4">
            <div class="stat-card">
                <i class="bi bi-journal-text fs-3 text-primary"></i>
                <div class="stat-num text-primary"><%= journals %></div>
                <div class="stat-label">Journals</div>
            </div>
        </div>
        <div class="col-4">
            <div class="stat-card">
                <i class="bi bi-flag-fill fs-3 text-warning"></i>
                <div class="stat-num text-warning"><%= goals %></div>
                <div class="stat-label">Goals Done</div>
            </div>
        </div>
    </div>

    <!-- RECENT CHECK-INS -->
    <div class="tile">
        <div class="tile-title"><i class="bi bi-heart-pulse text-success"></i> Recent Check-ins</div>
        <%
        ps = con.prepareStatement(
            "SELECT mood_score, stress_level, created_at FROM checkins WHERE user_id=? ORDER BY created_at DESC LIMIT 5"
        );
        ps.setInt(1, userId); rs = ps.executeQuery();
        if (!rs.isBeforeFirst()) { %>
            <p class="text-muted">No check-ins yet.</p>
        <% } else { while (rs.next()) { %>
            <div class="log-row">
                Mood <strong><%= rs.getInt("mood_score") %>/10</strong> &nbsp;·&nbsp;
                Stress <strong><%= rs.getInt("stress_level") %>/10</strong>
                <span class="text-muted float-end small"><%= rs.getTimestamp("created_at") %></span>
            </div>
        <% }} rs.close(); ps.close(); %>
    </div>

    <!-- RECENT JOURNALS -->
    <div class="tile">
        <div class="tile-title">
            <i class="bi bi-journal-text text-primary"></i> Recent Journals
            <% if (!"ACTIVE".equals(planStatus)) { %>
                <span class="badge bg-warning text-dark ms-1">Premium</span>
            <% } %>
        </div>
        <% if (!"ACTIVE".equals(planStatus)) { %>
            <p class="text-muted">Upgrade your plan to view journals.</p>
        <% } else {
            ps = con.prepareStatement(
                "SELECT title, created_at FROM journals WHERE user_id=? ORDER BY created_at DESC LIMIT 5"
            );
            ps.setInt(1, userId); rs = ps.executeQuery();
            if (!rs.isBeforeFirst()) { %>
                <p class="text-muted">No journals yet.</p>
            <% } else { while (rs.next()) { %>
                <div class="log-row">
                    <strong><%= rs.getString("title") %></strong>
                    <span class="text-muted float-end small"><%= rs.getTimestamp("created_at") %></span>
                </div>
            <% }} rs.close(); ps.close(); } %>
    </div>

    <!-- BREATHING EXERCISE -->
    <div class="tile text-center">
        <div class="tile-title justify-content-center"><i class="bi bi-wind text-info"></i> Breathing Exercise</div>
        <div id="breathCircle" class="breath-circle">Ready</div>
        <button class="btn btn-green px-4" onclick="startBreathing()">
            <i class="bi bi-play-fill me-1"></i> Start
        </button>
    </div>

    <!-- WELLNESS TOOLS -->
    <div class="tile">
        <div class="tile-title"><i class="bi bi-activity text-success"></i> Wellness Tools</div>
        <div class="row g-3">

            <!-- STEP COUNTER -->
            <div class="col-md-6">
                <div class="wtool">
                    <h6><i class="bi bi-person-walking text-success me-1"></i> Step Counter</h6>
                    <div class="text-center my-2">
                        <span class="big-num text-success" id="stepDisplay">0</span>
                        <span class="text-muted"> steps</span><br>
                        <small class="text-muted">
                            Today: <strong><%= todaySteps %></strong> steps
                            (~<strong><%= Math.round(todaySteps * 0.04) %></strong> cal burned)
                        </small>
                    </div>
                    <div class="d-flex gap-2 justify-content-center flex-wrap">
                        <button class="btn btn-sm btn-outline-success rounded-pill" onclick="addSteps(100)">+100</button>
                        <button class="btn btn-sm btn-outline-success rounded-pill" onclick="addSteps(500)">+500</button>
                        <button class="btn btn-sm btn-outline-success rounded-pill" onclick="addSteps(1000)">+1000</button>
                        <button class="btn btn-sm btn-green rounded-pill" onclick="saveSteps()">
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
                <div class="wtool">
                    <h6><i class="bi bi-fire text-danger me-1"></i> Calories Burned</h6>
                    <div class="text-center my-2">
                        <span class="big-num text-danger" id="calDisplay">0</span>
                        <span class="text-muted"> kcal</span><br>
                        <small class="text-muted">Today: <strong><%= todayCalories %></strong> kcal</small>
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
                <div class="wtool">
                    <h6><i class="bi bi-book text-primary me-1"></i> Study Timer</h6>
                    <div class="text-center my-2">
                        <span class="big-num text-primary" id="studyDisplay">25:00</span><br>
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
                <div class="wtool">
                    <h6><i class="bi bi-bicycle text-warning me-1"></i> Exercise Timer</h6>
                    <div class="text-center my-2">
                        <span class="big-num text-warning" id="exDisplay">00:00</span><br>
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

    <!-- EMERGENCY CONTACTS -->
    <div class="tile">
        <div class="tile-title"><i class="bi bi-telephone-fill text-danger"></i> Emergency Contacts</div>

        <% if (totalEc < 5) { %>
        <form method="post" class="mb-3">
            <div class="row g-2">
                <div class="col-md-3">
                    <input type="text" name="ec_name" class="form-control form-control-sm" placeholder="Name" required>
                </div>
                <div class="col-md-3">
                    <input type="text" name="ec_phone" class="form-control form-control-sm" placeholder="Phone number" required>
                </div>
                <div class="col-md-2">
                    <input type="text" name="ec_relationship" class="form-control form-control-sm" placeholder="Relation (e.g. Mom)">
                </div>
                <div class="col-md-3">
                    <input type="email" name="ec_email" class="form-control form-control-sm" placeholder="Email (optional)">
                </div>
                <div class="col-md-1">
                    <button class="btn btn-sm btn-danger rounded-pill w-100" title="Add Contact">
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
        ps.setInt(1, userId); rs = ps.executeQuery();
        if (!rs.isBeforeFirst()) { %>
            <p class="text-muted">No emergency contacts added yet.</p>
        <% } else { while (rs.next()) {
            String ecRel   = rs.getString("relationship");
            String ecEmail = rs.getString("email");
        %>
            <div class="log-row d-flex justify-content-between align-items-center">
                <div>
                    <strong><%= rs.getString("name") %></strong>
                    <% if (ecRel != null && !ecRel.isEmpty()) { %>
                        <span class="badge bg-light text-dark border ms-1 small"><%= ecRel %></span>
                    <% } %><br>
                    <i class="bi bi-telephone text-danger small"></i>
                    <a href="tel:<%= rs.getString("phone") %>" class="text-decoration-none text-dark small">
                        <%= rs.getString("phone") %>
                    </a>
                    <% if (ecEmail != null && !ecEmail.isEmpty()) { %>
                        &nbsp;·&nbsp;
                        <i class="bi bi-envelope text-secondary small"></i>
                        <a href="mailto:<%= ecEmail %>" class="text-decoration-none text-secondary small">
                            <%= ecEmail %>
                        </a>
                    <% } %>
                </div>
                <form method="post" class="ms-2">
                    <input type="hidden" name="deleteEcId" value="<%= rs.getInt("id") %>">
                    <button class="btn btn-sm btn-outline-danger rounded-pill"
                            onclick="return confirm('Remove this contact?');">
                        <i class="bi bi-trash"></i>
                    </button>
                </form>
            </div>
        <% }} rs.close(); ps.close(); %>
    </div>

    <!-- FEEDBACK -->
    <div class="tile">
        <div class="tile-title"><i class="bi bi-chat-left-heart-fill text-success"></i> Feedback</div>

        <form method="post" class="mb-3">
            <div class="mb-2">
                <textarea name="feedback" class="form-control" rows="3"
                          placeholder="Tell us how VitaVest helped you..." required></textarea>
            </div>
            <button class="btn btn-green px-4 btn-sm">
                <i class="bi bi-send me-1"></i> Submit Feedback
            </button>
        </form>

        <hr>
        <h6 class="text-muted mb-2" style="font-size:.85rem;text-transform:uppercase;letter-spacing:.5px;">
            Your Recent Feedback
        </h6>

        <%
        ps = con.prepareStatement(
            "SELECT id, message, status, created_at FROM feedback " +
            "WHERE user_id=? ORDER BY created_at DESC LIMIT 3"
        );
        ps.setInt(1, userId); rs = ps.executeQuery();
        if (!rs.isBeforeFirst()) { %>
            <p class="text-muted">No feedback submitted yet.</p>
        <% } else { while (rs.next()) {
            String status = rs.getString("status");
            String badgeCls = "resolved".equals(status) ? "badge-resolved" :
                              "read".equals(status)     ? "badge-read"     : "badge-new";
        %>
            <div class="log-row d-flex justify-content-between align-items-start gap-2">
                <div>
                    <p class="mb-1 small"><%= rs.getString("message") %></p>
                    <span class="badge rounded-pill px-2 py-1 <%= badgeCls %>" style="font-size:.75rem;">
                        <%= status.toUpperCase() %>
                    </span>
                    <span class="text-muted small ms-2"><%= rs.getTimestamp("created_at") %></span>
                </div>
                <form method="post" class="flex-shrink-0">
                    <input type="hidden" name="deleteId" value="<%= rs.getInt("id") %>">
                    <button class="btn btn-sm btn-outline-danger rounded-pill"
                            onclick="return confirm('Delete this feedback?');">
                        <i class="bi bi-trash"></i>
                    </button>
                </form>
            </div>
        <% }} rs.close(); ps.close(); %>
    </div>

</div><!-- /container -->

<!-- ══════════════════ SCRIPTS ══════════════════ -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
/* ─── BREATHING ─── */
const audioCtx = new (window.AudioContext || window.webkitAudioContext)();

function playBreathSound(type) {
    const osc  = audioCtx.createOscillator();
    const gain = audioCtx.createGain();
    osc.connect(gain); gain.connect(audioCtx.destination);
    osc.type = 'sine';
    if (type === 'in') {
        osc.frequency.setValueAtTime(220, audioCtx.currentTime);
        osc.frequency.linearRampToValueAtTime(440, audioCtx.currentTime + 4);
    } else {
        osc.frequency.setValueAtTime(440, audioCtx.currentTime);
        osc.frequency.linearRampToValueAtTime(220, audioCtx.currentTime + 4);
    }
    gain.gain.setValueAtTime(0, audioCtx.currentTime);
    gain.gain.linearRampToValueAtTime(0.12, audioCtx.currentTime + 1);
    gain.gain.linearRampToValueAtTime(0, audioCtx.currentTime + 4);
    osc.start(audioCtx.currentTime);
    osc.stop(audioCtx.currentTime + 4);
}

function startBreathing() {
    audioCtx.resume();
    const c = document.getElementById('breathCircle');
    c.textContent = 'Breathe In 🌬️';
    c.className = 'breath-circle breath-in';
    playBreathSound('in');
    setTimeout(() => { c.textContent = 'Hold...'; c.className = 'breath-circle'; }, 4000);
    setTimeout(() => { c.textContent = 'Breathe Out 😮‍💨'; c.className = 'breath-circle breath-out'; playBreathSound('out'); }, 8000);
    setTimeout(() => { c.textContent = 'Done 🌿'; c.className = 'breath-circle'; }, 12000);
}

/* ─── STEP COUNTER ─── */
let stepCount = 0;
function addSteps(n) { stepCount += n; document.getElementById('stepDisplay').textContent = stepCount; }
function resetSteps() { stepCount = 0; document.getElementById('stepDisplay').textContent = 0; }
function saveSteps() {
    if (stepCount === 0) { alert('Add some steps first!'); return; }
    document.getElementById('stepsInput').value = stepCount;
    document.getElementById('stepsForm').submit();
}

/* ─── CALORIES ─── */
let calCount = 0;
function addCal(n) { calCount += n; document.getElementById('calDisplay').textContent = calCount; }
function resetCal() { calCount = 0; document.getElementById('calDisplay').textContent = 0; }
function saveCal() {
    if (calCount === 0) { alert('Add some calories first!'); return; }
    document.getElementById('calInput').value = calCount;
    document.getElementById('calForm').submit();
}

/* ─── STUDY TIMER ─── */
let studyInterval = null, studyRunning = false;
let studyTotalSecs = 1500, studyRemaining = 1500, studyElapsedMins = 0;

function setStudyTimer() {
    const val = document.getElementById('studyPreset').value;
    const box = document.getElementById('studyCustom');
    if (val === 'custom') {
        box.style.setProperty('display', 'inline-block', 'important');
    } else {
        box.style.setProperty('display', 'none', 'important');
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
    if (preset === 'custom' && !studyRunning) {
        const cv = parseInt(document.getElementById('studyCustom').value);
        if (!cv || cv < 1) { alert('Enter custom minutes!'); return; }
        studyTotalSecs = cv * 60; studyRemaining = studyTotalSecs;
    }
    if (!studyRunning) {
        studyRunning = true;
        btn.innerHTML = '<i class="bi bi-pause-fill"></i> Pause';
        studyInterval = setInterval(() => {
            if (studyRemaining > 0) { studyRemaining--; updateStudyDisplay(); }
            else {
                clearInterval(studyInterval); studyRunning = false;
                studyElapsedMins = Math.round(studyTotalSecs / 60);
                btn.innerHTML = '<i class="bi bi-play-fill"></i> Start';
                alert('Study session complete! Saving ' + studyElapsedMins + ' min.');
                document.getElementById('studyInput').value = studyElapsedMins;
                document.getElementById('studyForm').submit();
            }
        }, 1000);
    } else {
        clearInterval(studyInterval); studyRunning = false;
        studyElapsedMins = Math.round((studyTotalSecs - studyRemaining) / 60);
        btn.innerHTML = '<i class="bi bi-play-fill"></i> Start';
        if (studyElapsedMins > 0 && confirm('Paused. Save ' + studyElapsedMins + ' min studied so far?')) {
            document.getElementById('studyInput').value = studyElapsedMins;
            document.getElementById('studyForm').submit();
        }
    }
}

function resetStudy() {
    clearInterval(studyInterval); studyRunning = false;
    const preset = document.getElementById('studyPreset').value;
    studyTotalSecs = (preset === 'custom' ? 25 : parseInt(preset)) * 60;
    studyRemaining = studyTotalSecs; updateStudyDisplay();
    document.getElementById('studyStartBtn').innerHTML = '<i class="bi bi-play-fill"></i> Start';
}

/* ─── EXERCISE TIMER ─── */
let exInterval = null, exRunning = false, exElapsedSecs = 0, exTargetSecs = 1800;

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
            exElapsedSecs++; updateExDisplay();
            if (exElapsedSecs >= exTargetSecs) {
                clearInterval(exInterval); exRunning = false;
                const mins = Math.round(exElapsedSecs / 60);
                btn.innerHTML = '<i class="bi bi-play-fill"></i> Start';
                alert('Exercise done! Saving ' + mins + ' min.');
                document.getElementById('exInput').value = mins;
                document.getElementById('exForm').submit();
            }
        }, 1000);
    } else {
        clearInterval(exInterval); exRunning = false;
        const mins = Math.round(exElapsedSecs / 60);
        btn.innerHTML = '<i class="bi bi-play-fill"></i> Start';
        if (mins > 0 && confirm('Paused. Save ' + mins + ' min exercised so far?')) {
            document.getElementById('exInput').value = mins;
            document.getElementById('exForm').submit();
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

</body>
</html>

<% con.close(); %>
