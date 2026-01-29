package com.servlets;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;

import com.util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ConfirmPaymentServlet")
public class ConfirmPaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(); 

        int planId = Integer.parseInt(session.getAttribute("selectedPlanId").toString());
        String planName = session.getAttribute("selectedPlanName").toString();
        int duration = Integer.parseInt(
                session.getAttribute("selectedPlanDuration").toString() 
        );

        BigDecimal price = new BigDecimal(
                session.getAttribute("selectedPlanPrice").toString()
        );

        LocalDate startDate = LocalDate.now();
        LocalDate endDate = startDate.plusDays(duration);

        Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/vitevista_db?serverTimezone=UTC",
                "root", "root"
            );

           
            int userId = Integer.parseInt(session.getAttribute("userId").toString());

            
            String email = null;
            PreparedStatement psEmail =
                    con.prepareStatement("SELECT email FROM users WHERE id=?");
            psEmail.setInt(1, userId);
            ResultSet rsEmail = psEmail.executeQuery();

            if (rsEmail.next()) {
                email = rsEmail.getString("email");
            }
            rsEmail.close();
            psEmail.close();

           
            PreparedStatement psSub = con.prepareStatement(
                "INSERT INTO subscriptions (user_id, plan_id, start_date, end_date, status) " +
                "VALUES (?, ?, ?, ?, 'active')"
            );
            psSub.setInt(1, userId);
            psSub.setInt(2, planId);
            psSub.setDate(3, Date.valueOf(startDate));
            psSub.setDate(4, Date.valueOf(endDate));
            psSub.executeUpdate();
            psSub.close();

            
            EmailUtil.sendEmail(
            	    email,
            	    "🎉 VitaVista Membership Activated Successfully!",
            	    "Hello,\n\n" +
            	    "Great news! Your *VitaVista* membership has been activated successfully. 💚\n\n" +
            	    "Here are your membership details:\n\n" +
            	    "📌 Plan Name   : " + planName + "\n" +
            	    "⏳ Duration    : " + duration + " days\n" +
            	    "💳 Amount Paid : ₹" + price + "\n" +
            	    "📅 Valid Till  : " + endDate + "\n\n" +
            	    "You now have full access to all premium features designed to support your health and wellness journey.\n\n" +
            	    "If you need any help or have questions, we’re always here for you.\n\n" +
            	    "Stay healthy, stay happy! 🌱\n\n" +
            	    "Best regards,\n" +
            	    "Team VitaVista"
            	);


            
            session.setAttribute("planName", planName);
            session.setAttribute("planStatus", "ACTIVE");
            session.setAttribute("planEndDate", endDate);

            response.sendRedirect("userdashboard.jsp?payment=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        } finally {
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }
    }
}
