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

@WebServlet(name = "OrderManageServlet", value = "/order-manage")
public class OrderManageServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    private static final String SHIPPED = "shipped";
    private static final String DELIVERED = "delivered";
    private static final String CANCEL = "canceled";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String orderId = req.getParameter("order_id");

        if (action != null && orderId != null && !orderId.trim().isEmpty()) {
            try (Connection connection = dataSource.getConnection()) {
                boolean success;

                if ("shipped".equalsIgnoreCase(action)) {
                    success = updateOrderStatus(orderId, SHIPPED, connection);
                    if (success) {
                        resp.sendRedirect("11.Order-Management?message=Order shipped successfully!");
                    } else {
                        resp.sendRedirect("11.Order-Management?error=Failed to ship order!");
                    }
                } else if ("delivered".equalsIgnoreCase(action)) {
                    success = updateOrderStatus(orderId, DELIVERED, connection);
                    if (success) {
                        resp.sendRedirect("11.Order-Management?message=Order delivered successfully!");
                    } else {
                        resp.sendRedirect("11.Order-Management?error=Failed to deliver order!");
                    }
                } else if ("cancel".equalsIgnoreCase(action)) {
                    success = updateOrderStatus(orderId, CANCEL, connection);
                    if (success) {
                        resp.sendRedirect("11.Order-Management?message=Order canceled successfully!");
                    } else {
                        resp.sendRedirect("11.Order-Management?error=Failed to cancel order!");
                    }
                } else {
                    resp.sendRedirect("11.Order-Management?error=Invalid action!");
                }

            } catch (SQLException e) {
                e.printStackTrace();
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("Error: " + e.getMessage());
            }
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("Invalid request! Please provide a valid order ID and action.");
        }



    }


    private boolean updateOrderStatus(String orderId, String status, Connection connection) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, status);
            preparedStatement.setString(2, orderId);
            return preparedStatement.executeUpdate() > 0;
        }
    }



}
