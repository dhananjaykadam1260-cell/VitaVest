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

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Handle POST request
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("delete".equals(action) && idParam != null) {
            int userId = Integer.parseInt(idParam);

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/vitevista_db", "root", "root"
                );

                String sql = "DELETE FROM users WHERE id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
                int rows = ps.executeUpdate();
                con.close();

                if (rows > 0) {
                    response.sendRedirect("admin-users.jsp?msg=deleted");
                } else {
                    response.sendRedirect("admin-users.jsp?msg=notfound");
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin-users.jsp?msg=error");
            }

        } else {
            response.sendRedirect("admin-users.jsp?msg=invalid");
        }
    }

  
}
