package org.example.javaee_ecommerce_web_application_aad;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.sql.DataSource;
import java.io.IOException;

@WebServlet(name = "AdminAuthorizationServlet", value = "/admin-authorize")
public class AdminAuthorizationServlet extends HttpServlet {

    /*@Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;*/

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String enteredPassword = req.getParameter("password");

        String correctPassword = "ecommerce123";

        if (correctPassword.equals(enteredPassword)) {
            // Redirect to Admin Login page with a success message
            resp.sendRedirect("4.Admin-User-Logins.jsp?message=Authorization successful. Welcome!");
        } else {
            // Redirect back to Admin Confirmation page with an error message
            resp.sendRedirect("3.Admin-Confirmation.jsp?error=Invalid password. Please try again.");
        }

    }
}
