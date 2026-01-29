package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteFeedbackServlet")
public class DeleteFeedbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            response.sendRedirect("admin-feedback.jsp?msg=error");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/vitevista_db", "root", "root");

            PreparedStatement ps =
                    con.prepareStatement("DELETE FROM feedback WHERE id=?");
            ps.setInt(1, Integer.parseInt(id));

            int rows = ps.executeUpdate();

            ps.close();
            con.close();

            if (rows > 0) {
                response.sendRedirect("admin-feedback.jsp?msg=deleted");
            } else {
                response.sendRedirect("admin-feedback.jsp?msg=error");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-feedback.jsp?msg=error");
        }
    }
}
