package org.example.javaee_ecommerce_web_application_aad;

import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.crypto.bcrypt.BCrypt;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "CustomerLoginServlet",value = "/customer-login")
public class CustomerLoginServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try (Connection connection = dataSource.getConnection()) {
            // SQL query to fetch the password hash and user status
            String query = "SELECT user_id, password_hash, is_active, role FROM users WHERE username = ?";
            try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                preparedStatement.setString(1, username);
                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    if (resultSet.next()) {
                        String hashedPassword = resultSet.getString("password_hash");
                        boolean isActive = resultSet.getBoolean("is_active");
                        String userId = resultSet.getString("user_id"); // Get the user ID from the result
                        String userRole = resultSet.getString("role");

                        if (!isActive) {
                            // If the user is inactive, redirect with an error
                            resp.sendRedirect("17.Customer-User-Logins.jsp?error=Your account is inactive.");
                            return;
                        }

                        if (!userRole.equals("CUSTOMER")) {
                            resp.sendRedirect("17.Customer-User-Logins.jsp?error=Wrong User Role!");
                            return;
                        }

                        // Check if the password is correct using BCrypt
                        if ( BCrypt.checkpw(password, hashedPassword)) {
                            // If the password matches, set the session attribute and redirect
                            HttpSession session = req.getSession();
                            session.setAttribute("user_id", userId); // Store the user ID in the session
                            resp.sendRedirect("8.Customer-Homepage.jsp");
                        } else {
                            // If the password is incorrect, redirect with an error
                            resp.sendRedirect("17.Customer-User-Logins.jsp?error=Invalid password.");
                        }
                    } else {
                        // If the username is not found, redirect with an error
                        resp.sendRedirect("17.Customer-User-Logins.jsp?error=Invalid username.");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("17.Customer-User-Logins.jsp?error=Database Connection Error");
        }


    }
}
