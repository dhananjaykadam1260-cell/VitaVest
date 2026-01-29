package com.servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/SelectPlanServlet")
public class SelectPlanServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        int planId = Integer.parseInt(request.getParameter("planId"));
        String planName = request.getParameter("planName");
        String duration = request.getParameter("duration");
        String price = request.getParameter("price");

        session.setAttribute("selectedPlanId", planId);
        session.setAttribute("selectedPlanName", planName);
        session.setAttribute("selectedPlanDuration", duration); // ✅ MATCH
        session.setAttribute("selectedPlanPrice", price);

        response.sendRedirect("subscribe.jsp");
    }
}
