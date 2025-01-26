package org.example.javaee_ecommerce_web_application_aad;

import jakarta.annotation.Resource;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import javax.json.Json;
import javax.json.JsonObjectBuilder;
import javax.sql.DataSource;
import java.io.File;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ProductManageServlet", value = "/product-manage")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ProductManageServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    private static final String UPLOAD_DIR = "resources/productImages"; // Directory for storing images

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if (action != null) {
            try (Connection connection = dataSource.getConnection()) {
                switch (action) {
                    case "save":
                        saveProduct(req, connection);
                        resp.sendRedirect("9.Product-Management?message=Product saved successfully!");
                        break;
                    case "update":
                        updateProduct(req, connection);
                        resp.sendRedirect("9.Product-Management?message=Product updated successfully!");
                        break;
                    case "delete":
                        deleteProduct(req, connection);
                        resp.sendRedirect("9.Product-Management?message=Product deleted successfully!");
                        break;
                    default:
                        resp.sendRedirect("9.Product-Management?error=Invalid action!");
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

    private void saveProduct(HttpServletRequest req, Connection connection) throws SQLException, IOException, ServletException {

        String sql = "INSERT INTO products (product_id, product_name, description, price, stock, category_id, category_name, image_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        String imagePath = uploadImage(req); // Upload image and get the file path

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, req.getParameter("product_id"));
            stmt.setString(2, req.getParameter("product_name"));
            stmt.setString(3, req.getParameter("description"));
            stmt.setDouble(4, Double.parseDouble(req.getParameter("price")));
            stmt.setInt(5, Integer.parseInt(req.getParameter("stock")));
            stmt.setString(6, req.getParameter("category_id"));
            stmt.setString(7, req.getParameter("category_name"));
            stmt.setString(8, imagePath);

            stmt.executeUpdate();
        }
    }

    private void updateProduct(HttpServletRequest req, Connection connection) throws SQLException, IOException, ServletException {
        String sql = "UPDATE products SET product_name = ?, description = ?, price = ?, stock = ?, category_id = ?, category_name = ?, image_path = ? WHERE product_id = ?";

        String imagePath = uploadImage(req); // Upload image and get the file path

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, req.getParameter("product_name"));
            stmt.setString(2, req.getParameter("description"));
            stmt.setDouble(3, Double.parseDouble(req.getParameter("price")));
            stmt.setInt(4, Integer.parseInt(req.getParameter("stock")));
            stmt.setString(5, req.getParameter("category_id"));
            stmt.setString(6, req.getParameter("category_name"));
            stmt.setString(7, imagePath);
            stmt.setString(8, req.getParameter("product_id"));

            stmt.executeUpdate();
        }
    }

    private void deleteProduct(HttpServletRequest req, Connection connection) throws SQLException {
        String sql = "DELETE FROM products WHERE product_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, req.getParameter("product_id"));
            stmt.executeUpdate();
        }
    }

    private String uploadImage(HttpServletRequest req) throws IOException, ServletException {
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        String imagePath = null;
        for (Part part : req.getParts()) {
            if (part.getName().equals("image_path") && part.getSize() > 0) {
                String fileName = extractFileName(part);
                imagePath = UPLOAD_DIR + File.separator + fileName;
                part.write(uploadPath + File.separator + fileName);
            }
        }
        return imagePath;
    }

    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) {
            return null;
        }
        for (String content : contentDisposition.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return null;
    }

}
