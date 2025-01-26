package org.example.javaee_ecommerce_web_application_aad;

import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


import javax.sql.DataSource;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = "/addToCart")
public class BrowseProductServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;


    /*@Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Get the session and user ID
        HttpSession session = req.getSession();
        String userId = (String) session.getAttribute("user_id");
        System.out.println("User ID: " + userId); // Debugging line

        if (userId == null) {
            // If the user is not logged in, redirect to the login page
            resp.sendRedirect("17.Customer-User-Logins.jsp");
            return;
        }

        // Get the product ID and quantity from the request parameters
        String productId = req.getParameter("product_id");
        int quantity = Integer.parseInt(req.getParameter("quantity"));

        // Now, save the cart item into the 'cart' table in the database
        try (Connection connection = dataSource.getConnection()) {
            String query = "INSERT INTO cart (user_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                preparedStatement.setString(1, userId);
                preparedStatement.setString(2, productId);
                preparedStatement.setInt(3, quantity);
                preparedStatement.setDouble(4,);
                preparedStatement.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle error gracefully, e.g., show an error message
        }

        // Redirect back to the product page or cart page after adding the product to the cart
        resp.sendRedirect("13.Product-Browsing.jsp");
    }*/


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("user_id");
        String productId = request.getParameter("product_id");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        if (userId == null) {
            response.sendRedirect("17.Customer-User-Logins.jsp?error=Please log in to add items to your cart.");
            return;
        }

        try (Connection connection = dataSource.getConnection()) {
            // Fetch the price of the product
            String fetchPriceQuery = "SELECT price FROM products WHERE product_id = ?";
            double price = 0.0;

            try (PreparedStatement fetchPriceStmt = connection.prepareStatement(fetchPriceQuery)) {
                fetchPriceStmt.setString(1, productId);
                try (ResultSet rs = fetchPriceStmt.executeQuery()) {
                    if (rs.next()) {
                        price = rs.getDouble("price");
                    } else {
                        response.sendRedirect("13.Product-Browsing.jsp?error=Product not found.");
                        return;
                    }
                }
            }

            // Insert the item into the cart
            String insertCartQuery = "INSERT INTO cart (user_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            try (PreparedStatement insertCartStmt = connection.prepareStatement(insertCartQuery)) {
                insertCartStmt.setString(1, userId);
                insertCartStmt.setString(2, productId);
                insertCartStmt.setInt(3, quantity);
                insertCartStmt.setDouble(4, price);
                insertCartStmt.executeUpdate();
            }

            response.sendRedirect("14.Shopping-Cart.jsp?message=Item added to cart successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("13.Product-Browsing.jsp?error=An error occurred while adding to cart.");
        }
    }
}
