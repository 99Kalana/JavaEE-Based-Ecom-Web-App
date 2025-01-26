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

@WebServlet(name = "CategoryManageServlet", value = "/category-manage")
public class CategoryManageServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if (action != null) {
            try (Connection connection = dataSource.getConnection()) {
                switch (action) {
                    case "save":
                        saveCategory(req, connection);
                        resp.sendRedirect("10.Category-Management?message=Product saved successfully!");
                        break;
                    case "update":
                        updateCategory(req, connection);
                        resp.sendRedirect("10.Category-Management?message=Product updated successfully!");
                        break;
                    case "delete":
                        deleteCategory(req, connection);
                        resp.sendRedirect("10.Category-Management?message=Product deleted successfully!");
                        break;
                    default:
                        resp.sendRedirect("10.Category-Management?error=Invalid action!");
                }
            } catch (SQLException e) {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("Error: " + e.getMessage());
            }
        } else {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("No action specified!");
        }
    }


    private void saveCategory(HttpServletRequest req, Connection connection) throws SQLException, IOException, ServletException {

        String sql = "INSERT INTO categories (category_id, category_name) VALUES (?, ?)";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, req.getParameter("category_id"));
            stmt.setString(2, req.getParameter("category_name"));

            stmt.executeUpdate();
        }
    }

    private void updateCategory(HttpServletRequest req, Connection connection) throws SQLException, IOException, ServletException {
        String sql = "UPDATE categories SET category_name = ? WHERE category_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, req.getParameter("category_name"));
            stmt.setString(2, req.getParameter("category_id"));

            stmt.executeUpdate();
        }
    }

    private void deleteCategory(HttpServletRequest req, Connection connection) throws SQLException {
        String sql = "DELETE FROM categories WHERE category_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, req.getParameter("category_id"));
            stmt.executeUpdate();
        }
    }


}
