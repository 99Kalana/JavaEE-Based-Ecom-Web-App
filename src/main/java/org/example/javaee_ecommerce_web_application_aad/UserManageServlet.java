package org.example.javaee_ecommerce_web_application_aad;

import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "UserManageServlet", value = "/user-manage")
public class UserManageServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String userId = req.getParameter("user_id");

        if (action != null && userId != null && !userId.trim().isEmpty()) {
            try (Connection connection = dataSource.getConnection()) {
                boolean success;
                if ("activate".equalsIgnoreCase(action)) {
                    success = updateUserStatus(userId, true, connection);
                    if (success) {
                        resp.sendRedirect("12.User-Management?message=User activated successfully!");
                    } else {
                        resp.sendRedirect("12.User-Management?error=Failed to activate user!");
                    }
                } else if ("deactivate".equalsIgnoreCase(action)) {
                    success = updateUserStatus(userId, false, connection);
                    if (success) {
                        resp.sendRedirect("12.User-Management?message=User deactivated successfully!");
                    } else {
                        resp.sendRedirect("12.User-Management?error=Failed to deactivate user!");
                    }
                } else {
                    resp.sendRedirect("12.User-Management?error=Invalid action!");
                }
            } catch (SQLException e) {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("Error: " + e.getMessage());
            }
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("Invalid request! Please provide a valid user ID and action.");
        }
    }

    private boolean updateUserStatus(String userId, boolean isActive, Connection connection) throws SQLException {
        String sql = "UPDATE users SET is_active = ? WHERE user_id = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setBoolean(1, isActive);
            preparedStatement.setString(2, userId);
            return preparedStatement.executeUpdate() > 0;
        }
    }
}
