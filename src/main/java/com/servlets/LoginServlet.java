package com.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

import com.dao.UserDAO;
import com.model.User;
import com.util.PasswordUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null ||
            email.trim().isEmpty() || password.trim().isEmpty()) {

            response.sendRedirect("login.jsp?error=empty");
            return;
        }

        User user = UserDAO.getUserByEmail(email);

        if (user != null &&
            PasswordUtil.checkPassword(password, user.getPassword())) {

            HttpSession session = request.getSession();

            
            session.setAttribute("user", user);

            
            session.setAttribute("userId", user.getId());
            session.setAttribute("email", user.getEmail());

            response.sendRedirect("userdashboard.jsp");
        } else {
            response.sendRedirect("login.jsp?error=invalid");
        }
    }
}
