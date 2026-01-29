package com.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

import com.dao.UserDAO;
import com.model.User;
import com.util.EmailUtil;
import com.util.PasswordUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        String hashedPassword = PasswordUtil.hashPassword(password);


        User user = new User(name, email, hashedPassword);


        boolean isSaved = UserDAO.registerUser(user);

        if (isSaved) {

        	String subject = "🎉 Welcome to VitaVest!";
        	String message =
        	        "Hi " + name + ",\n\n" +
        	        "Welcome to *VitaVest*! 💚\n\n" +
        	        "We’re excited to have you on board. Your account has been created successfully, and you’re all set to begin your health and wellness journey with us.\n\n" +
        	        "Explore personalized plans, track your progress, and take a step towards a healthier lifestyle.\n\n" +
        	        "Stay fit, stay strong! 💪\n\n" +
        	        "Warm regards,\n" +
        	        "Team VitaVest";


            EmailUtil.sendEmail(email, subject, message);

            response.sendRedirect("login.jsp");

        } else {
            response.sendRedirect("register.jsp?error=1");
        }
    }
}
