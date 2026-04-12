<%@ page contentType="text/html;charset=UTF-8" %>
<%
    
    if (session.getAttribute("selectedPlanId") == null ||
        session.getAttribute("selectedPlanName") == null ||
        session.getAttribute("selectedPlanDuration") == null ||
        session.getAttribute("selectedPlanPrice") == null) {
        response.sendRedirect("plans.jsp");
        return;
    }

    
    int planId = Integer.parseInt(String.valueOf(session.getAttribute("selectedPlanId")));
    String planName = String.valueOf(session.getAttribute("selectedPlanName"));
    String duration = String.valueOf(session.getAttribute("selectedPlanDuration"));
    String price = String.valueOf(session.getAttribute("selectedPlanPrice"));


    String upiId = "9527365004@ybl";       
    String payeeName = "VitaVista";       

    
    String upiAmount = price.replace(",", "").trim();

    String upiUrl = "upi://pay?pa=" + upiId +
                    "&pn=" + payeeName +
                    "&am=" + upiAmount +
                    "&cu=INR";

    String qrApi = "https://api.qrserver.com/v1/create-qr-code/?size=220x220&data=" + upiUrl;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>VitaVista | Complete Payment</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    body {
        background: linear-gradient(135deg, #eef2f6, #dbe4f0);
        font-family: "Segoe UI", sans-serif;
    }
    .payment-card {
        max-width: 450px;
        border-radius: 16px;
        margin: auto;
        margin-top: 60px;
    }
    .qr-box {
        border: 2px dashed #ccc;
        padding: 20px;
        border-radius: 12px;
        background: #fff;
    }
</style>
</head>
<body>

<div class="container">
    <div class="card payment-card p-4 shadow">
        <h3 class="text-center mb-3">💳 Complete Payment</h3>
        <hr>

        <!-- Plan Details -->
        <div class="mb-3">
            <p class="mb-1"><b>Plan:</b> <%= planName %></p>
            <p class="mb-1"><b>Duration:</b> <%= duration %> Months</p>
            <p class="mb-1">
                <b>Amount:</b>
                <span class="text-success fw-bold fs-5">₹<%= price %></span>
            </p>
        </div>

        <!-- QR Section -->
        <h6 class="text-center mt-3">Scan & Pay Using UPI</h6>
        <div class="qr-box text-center my-3">
            <img src="<%= qrApi %>" alt="UPI QR Code" class="img-fluid">
            <p class="text-muted mt-2 mb-0" style="font-size:13px;">
                Pay via Google Pay / PhonePe / Paytm
            </p>
        </div>

        <!-- Confirm Payment -->
        <form action="ConfirmPaymentServlet" method="post">
            <!-- Hidden inputs to pass plan info -->
            <input type="hidden" name="planId" value="<%= planId %>">
            <input type="hidden" name="planName" value="<%= planName %>">
            <input type="hidden" name="duration" value="<%= duration %>">
            <input type="hidden" name="price" value="<%= price %>">

            <button type="submit" class="btn btn-success w-100 rounded-pill">
                ✅ I Have Paid – Confirm Payment
            </button>
        </form>

        <p class="text-center text-muted mt-3" style="font-size:12px;">
            Your subscription will be activated after payment verification
        </p>
    </div>
</div>

</body>
</html>
