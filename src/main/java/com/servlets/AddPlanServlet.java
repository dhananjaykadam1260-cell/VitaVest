package com.servlets;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddPlanServlet")
public class AddPlanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String planName = request.getParameter("plan_name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String durationStr = request.getParameter("duration_days");

        // Server-side validation
        if(planName == null || planName.isEmpty() ||
           priceStr == null || priceStr.isEmpty() ||
           durationStr == null || durationStr.isEmpty()) {

            request.setAttribute("error", "Please fill in all required fields.");
            request.getRequestDispatcher("add-plan.jsp").forward(request, response);
            return;
        }

        try {
            double price = Double.parseDouble(priceStr);
            int durationDays = Integer.parseInt(durationStr);

            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/vitevista_db", "root", "root")) {

                String sql = "INSERT INTO plans(plan_name, description, price, duration_days) VALUES(?,?,?,?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, planName);
                ps.setString(2, description);
                ps.setDouble(3, price);
                ps.setInt(4, durationDays);

                int rows = ps.executeUpdate();
                if(rows > 0) {
                    response.sendRedirect("admin-plans.jsp?success=Plan added successfully");
                } else {
                    request.setAttribute("error", "Failed to add plan.");
                    request.getRequestDispatcher("add-plan.jsp").forward(request, response);
                }
            }

        } catch(NumberFormatException e) {
            request.setAttribute("error", "Invalid price or duration.");
            request.getRequestDispatcher("add-plan.jsp").forward(request, response);
        } catch(Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong: " + e.getMessage());
            request.getRequestDispatcher("add-plan.jsp").forward(request, response);
        }
    }
}
