package org.example.javaee_ecommerce_web_application_aad;

import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.crypto.bcrypt.BCrypt;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "CustomerChangePasswordServlet", value = "/customer-password_change")
public class CustomerChangePasswordServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userId = req.getParameter("userid");
        String username = req.getParameter("username");
        String newPassword = req.getParameter("newPassword");

        try (Connection connection = dataSource.getConnection()) {
            String userQuery = "SELECT user_id FROM users WHERE user_id = ? AND username = ?";
            try (PreparedStatement userStmt = connection.prepareStatement(userQuery)) {
                userStmt.setString(1, userId);
                userStmt.setString(2, username);

                try (ResultSet resultSet = userStmt.executeQuery()) {
                    if (resultSet.next()) {
                        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                        String updateQuery = "UPDATE users SET password_hash = ? WHERE user_id = ?";

                        try (PreparedStatement updateStmt = connection.prepareStatement(updateQuery)) {
                            updateStmt.setString(1, hashedPassword);
                            updateStmt.setString(2, userId);

                            int rowsUpdated = updateStmt.executeUpdate();
                            if (rowsUpdated > 0) {
                                resp.sendRedirect("19.Customer-Username-Password-Reset.jsp?message=Password updated successfully.");
                            } else {
                                resp.sendRedirect("19.Customer-Username-Password-Reset.jsp?error=Failed to update password.");
                            }
                        }
                    } else {
                        resp.sendRedirect("19.Customer-Username-Password-Reset.jsp?error=Invalid User ID or Username.");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("19.Customer-Username-Password-Reset.jsp?error=Database Connection Error.");
        }
    }
}
