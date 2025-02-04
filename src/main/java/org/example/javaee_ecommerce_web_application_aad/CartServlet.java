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


@WebServlet("/cartPlaceOrder")
public class CartServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {



        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("user_id"); // Retrieve user ID from session

        if (userId == null) {
            response.sendRedirect("17.Customer-User-Logins.jsp"); // Redirect if user is not logged in
            return;
        }

        Connection conn = null;
        PreparedStatement orderStmt = null;
        PreparedStatement orderDetailsStmt = null;
        PreparedStatement updateStockStmt = null;
        PreparedStatement clearCartStmt = null;
        ResultSet rs = null;

        try {
            conn = dataSource.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // **Step 1: Calculate Total Order Amount**
            String totalQuery = "SELECT SUM(price * quantity) FROM cart WHERE user_id = ?";
            PreparedStatement totalStmt = conn.prepareStatement(totalQuery);
            totalStmt.setString(1, userId);
            rs = totalStmt.executeQuery();
            double totalAmount = 0.0;
            if (rs.next()) {
                totalAmount = rs.getDouble(1);
            }

            if (totalAmount == 0) {
                response.sendRedirect("14.Shopping-Cart.jsp?error=empty"); // Prevent empty orders
                return;
            }

            // **Step 2: Create New Order**
            String orderId = generateOrderId(conn); // Generate order ID like O001, O002
            String insertOrder = "INSERT INTO orders (order_id, user_id, total_amount) VALUES (?, ?, ?)";
            orderStmt = conn.prepareStatement(insertOrder);
            orderStmt.setString(1, orderId);
            orderStmt.setString(2, userId);
            orderStmt.setDouble(3, totalAmount);
            orderStmt.executeUpdate();

            // **Step 3: Insert Order Details and Update Stock**
            String cartQuery = "SELECT product_id, quantity, price FROM cart WHERE user_id = ?";
            PreparedStatement cartStmt = conn.prepareStatement(cartQuery);
            cartStmt.setString(1, userId);
            rs = cartStmt.executeQuery();

            String insertOrderDetail = "INSERT INTO order_details (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            orderDetailsStmt = conn.prepareStatement(insertOrderDetail);

            String updateStock = "UPDATE products SET stock = stock - ? WHERE product_id = ?";
            updateStockStmt = conn.prepareStatement(updateStock);

            while (rs.next()) {
                String productId = rs.getString("product_id");
                int quantity = rs.getInt("quantity");
                double price = rs.getDouble("price");

                // Insert into order_details
                orderDetailsStmt.setString(1, orderId);
                orderDetailsStmt.setString(2, productId);
                orderDetailsStmt.setInt(3, quantity);
                orderDetailsStmt.setDouble(4, price);
                orderDetailsStmt.executeUpdate();

                // Update stock in products
                updateStockStmt.setInt(1, quantity);
                updateStockStmt.setString(2, productId);
                updateStockStmt.executeUpdate();
            }

            // **Step 4: Clear User's Cart**
            String clearCart = "DELETE FROM cart WHERE user_id = ?";
            clearCartStmt = conn.prepareStatement(clearCart);
            clearCartStmt.setString(1, userId);
            clearCartStmt.executeUpdate();

            // Commit Transaction
            conn.commit();
            response.sendRedirect("14.Shopping-Cart.jsp?orderId=" + orderId); // Redirect to success page

        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback(); // Rollback on error
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("14.Shopping-Cart.jsp?error=order_failed");
        } finally {
            // Close all resources
            close(rs);
            close(orderStmt);
            close(orderDetailsStmt);
            close(updateStockStmt);
            close(clearCartStmt);
            close(conn);
        }
    }

    // **Method to Generate Order ID (e.g., O001, O002)**
    private String generateOrderId(Connection conn) throws SQLException {
        String query = "SELECT order_id FROM orders ORDER BY order_date DESC LIMIT 1";
        PreparedStatement stmt = conn.prepareStatement(query);
        ResultSet rs = stmt.executeQuery();
        String newOrderId = "O001";

        if (rs.next()) {
            String lastId = rs.getString("order_id");
            int num = Integer.parseInt(lastId.substring(1)) + 1;
            newOrderId = String.format("O%03d", num);
        }

        rs.close();
        stmt.close();
        return newOrderId;
    }

    // **Utility Method to Close Resources**
    private void close(AutoCloseable resource) {
        if (resource != null) {
            try {
                resource.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }


    }



}



