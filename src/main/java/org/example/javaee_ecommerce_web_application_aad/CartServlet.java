package org.example.javaee_ecommerce_web_application_aad;

import jakarta.annotation.Resource;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


/*@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Fetch the cart items from session
        List<CartDTO> cartItems = (List<CartDTO>) request.getSession().getAttribute("cartItems");

        int totalItems = 0;
        double totalPrice = 0.0;

        if (cartItems != null) {
            for (CartDTO item : cartItems) {
                totalItems += item.getQuantity();
                totalPrice += item.getPrice() * item.getQuantity();
            }
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("totalPrice", totalPrice);

        request.getRequestDispatcher("14.Shopping-Cart.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle placing the order

        List<CartDTO> cartItems = (List<CartDTO>) request.getSession().getAttribute("cartItems");
        if (cartItems == null || cartItems.isEmpty()) {
            response.getWriter().write("Your cart is empty!");
            return;
        }

        // Start a transaction
        Connection conn = null;
        PreparedStatement orderStmt = null;
        PreparedStatement orderDetailsStmt = null;
        PreparedStatement updateStockStmt = null;

        try {
            conn = dataSource.getConnection();
            conn.setAutoCommit(false);  // Begin transaction

            // Get the user ID from session
            String userId = (String) request.getSession().getAttribute("userId");

            // Generate order ID
            String orderId = generateOrderId(conn);

            // Insert order into the orders table
            String orderSQL = "INSERT INTO orders (order_id, user_id, total_amount, status) VALUES (?, ?, ?, ?)";
            orderStmt = conn.prepareStatement(orderSQL);
            orderStmt.setString(1, orderId);
            orderStmt.setString(2, userId);
            double totalAmount = calculateTotalAmount(cartItems);
            orderStmt.setDouble(3, totalAmount);
            orderStmt.setString(4, "PENDING");
            orderStmt.executeUpdate();

            // Insert order details into the order_details table
            String orderDetailsSQL = "INSERT INTO order_details (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            orderDetailsStmt = conn.prepareStatement(orderDetailsSQL);

            for (CartDTO item : cartItems) {
                orderDetailsStmt.setString(1, orderId);
                orderDetailsStmt.setString(2, item.getProductId());
                orderDetailsStmt.setInt(3, item.getQuantity());
                orderDetailsStmt.setDouble(4, item.getPrice());
                orderDetailsStmt.addBatch();

                // Update the stock
                String updateStockSQL = "UPDATE products SET stock = stock - ? WHERE product_id = ?";
                updateStockStmt = conn.prepareStatement(updateStockSQL);
                updateStockStmt.setInt(1, item.getQuantity());
                updateStockStmt.setString(2, item.getProductId());
                updateStockStmt.executeUpdate();
            }

            // Execute batch for order details insertion
            orderDetailsStmt.executeBatch();

            // Commit transaction
            conn.commit();

            // Clear the cart session
            request.getSession().removeAttribute("cartItems");

            // Redirect to order confirmation page
            response.sendRedirect("/14.Shopping-Cart");

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();  // Rollback on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            response.getWriter().write("Error placing the order, please try again later.");
        } finally {
            try {
                if (orderStmt != null) orderStmt.close();
                if (orderDetailsStmt != null) orderDetailsStmt.close();
                if (updateStockStmt != null) updateStockStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }


    private String generateOrderId(Connection conn) throws SQLException {
        // Generate order ID (O001, O002, etc.)
        String query = "SELECT MAX(CAST(SUBSTRING(order_id, 2) AS UNSIGNED)) FROM orders";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int maxId = rs.getInt(1);
                return "O" + String.format("%04d", maxId + 1);
            } else {
                return "O0001";  // Start from O0001 if no orders exist
            }
        }
    }

    private double calculateTotalAmount(List<CartDTO> cartItems) {
        double totalAmount = 0.0;
        for (CartDTO item : cartItems) {
            totalAmount += item.getPrice() * item.getQuantity();
        }
        return totalAmount;
    }

}*/


@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Determine the action (e.g., view cart or place order)
        String action = request.getParameter("action");
        if ("view".equalsIgnoreCase(action)) {
            // View cart functionality
            List<CartDTO> cartItems = (List<CartDTO>) request.getSession().getAttribute("cartItems");

            int totalItems = 0;
            double totalPrice = 0.0;

            if (cartItems != null) {
                for (CartDTO item : cartItems) {
                    totalItems += item.getQuantity();
                    totalPrice += item.getPrice() * item.getQuantity();
                }
            }

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("totalPrice", totalPrice);

            RequestDispatcher dispatcher = request.getRequestDispatcher("14.Shopping-Cart.jsp");
            dispatcher.forward(request, response);

        } else if ("placeOrder".equalsIgnoreCase(action)) {
            // Place order functionality
            List<CartDTO> cartItems = (List<CartDTO>) request.getSession().getAttribute("cartItems");
            if (cartItems == null || cartItems.isEmpty()) {
                response.getWriter().write("Your cart is empty!");
                return;
            }

            Connection conn = null;
            PreparedStatement orderStmt = null;
            PreparedStatement orderDetailsStmt = null;
            PreparedStatement updateStockStmt = null;

            try {
                conn = dataSource.getConnection();
                conn.setAutoCommit(false); // Begin transaction

                // Get the user ID from session
                String userId = (String) request.getSession().getAttribute("userId");

                // Generate order ID
                String orderId = generateOrderId(conn);

                // Insert order into the orders table
                String orderSQL = "INSERT INTO orders (order_id, user_id, total_amount, status) VALUES (?, ?, ?, ?)";
                orderStmt = conn.prepareStatement(orderSQL);
                orderStmt.setString(1, orderId);
                orderStmt.setString(2, userId);
                double totalAmount = calculateTotalAmount(cartItems);
                orderStmt.setDouble(3, totalAmount);
                orderStmt.setString(4, "PENDING");
                orderStmt.executeUpdate();

                // Insert order details into the order_details table
                String orderDetailsSQL = "INSERT INTO order_details (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
                orderDetailsStmt = conn.prepareStatement(orderDetailsSQL);

                for (CartDTO item : cartItems) {
                    orderDetailsStmt.setString(1, orderId);
                    orderDetailsStmt.setString(2, item.getProductId());
                    orderDetailsStmt.setInt(3, item.getQuantity());
                    orderDetailsStmt.setDouble(4, item.getPrice());
                    orderDetailsStmt.addBatch();

                    // Update the stock
                    String updateStockSQL = "UPDATE products SET stock = stock - ? WHERE product_id = ?";
                    updateStockStmt = conn.prepareStatement(updateStockSQL);
                    updateStockStmt.setInt(1, item.getQuantity());
                    updateStockStmt.setString(2, item.getProductId());
                    updateStockStmt.executeUpdate();
                }

                // Execute batch for order details insertion
                orderDetailsStmt.executeBatch();

                // Commit transaction
                conn.commit();

                // Clear the cart session
                request.getSession().removeAttribute("cartItems");

                // Redirect to order confirmation page
                response.sendRedirect("/14.Shopping-Cart");

            } catch (SQLException e) {
                if (conn != null) {
                    try {
                        conn.rollback(); // Rollback on error
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                }
                e.printStackTrace();
                response.getWriter().write("Error placing the order, please try again later.");
            } finally {
                try {
                    if (orderStmt != null) orderStmt.close();
                    if (orderDetailsStmt != null) orderDetailsStmt.close();
                    if (updateStockStmt != null) updateStockStmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            response.getWriter().write("Invalid action!");
        }
    }

    private String generateOrderId(Connection conn) throws SQLException {
        String query = "SELECT MAX(CAST(SUBSTRING(order_id, 2) AS UNSIGNED)) FROM orders";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int maxId = rs.getInt(1);
                return "O" + String.format("%04d", maxId + 1);
            } else {
                return "O0001";
            }
        }
    }

    private double calculateTotalAmount(List<CartDTO> cartItems) {
        double totalAmount = 0.0;
        for (CartDTO item : cartItems) {
            totalAmount += item.getPrice() * item.getQuantity();
        }
        return totalAmount;
    }
}



