package com.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM admins WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password); // plain password for now

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Login success
                HttpSession session = request.getSession();
                session.setAttribute("adminName", rs.getString("name"));
                response.sendRedirect("admin-dashboard.jsp");
            } else {
                // Login failed
                response.sendRedirect("adminlogin.jsp?error=Invalid+Email+or+Password");
            }

            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminlogin.jsp?error=Database+Error");
        }
    }
}
