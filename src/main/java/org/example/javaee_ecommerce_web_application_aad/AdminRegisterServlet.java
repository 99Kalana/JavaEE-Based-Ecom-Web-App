package org.example.javaee_ecommerce_web_application_aad;

import jakarta.annotation.Resource;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.crypto.bcrypt.BCrypt;

import javax.json.Json;
import javax.json.JsonObjectBuilder;
import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "AdminRegisterServlet", value = "/admin-register")
public class AdminRegisterServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    /*@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            // Fetch the last user ID from the database and generate a new one
            String lastUserId = getLastUserIdFromDatabase(dataSource);
            String newUserId = generateNewUserId(lastUserId);

            // Set the generated userId as a request attribute
            req.setAttribute("userid", newUserId);

            // Forward the request to the JSP page for rendering
            RequestDispatcher dispatcher = req.getRequestDispatcher("/5.Admin-User-Registration.jsp");
            dispatcher.forward(req, resp);

            resp.sendRedirect("5.Admin-User-Registration.jsp?error= User ID generated!");

        } catch (Exception e) {
            e.printStackTrace();

            resp.sendRedirect("5.Admin-User-Registration.jsp?error=Error on generating user ID!");
        }
    }


    private String getLastUserIdFromDatabase(DataSource dataSource) throws SQLException {
        String query = "SELECT user_id FROM users ORDER BY user_id DESC LIMIT 1";
        try (Connection connection = dataSource.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query);
             ResultSet resultSet = preparedStatement.executeQuery()) {
            if (resultSet.next()) {
                return resultSet.getString("user_id");
            }
        }
        return null;
    }

    private String generateNewUserId(String lastUserId) {
        if (lastUserId == null || lastUserId.isEmpty()) {
            return "U001";
        }
        int newId = Integer.parseInt(lastUserId.substring(1)) + 1;
        return String.format("U%03d", newId);
    }*/


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {

            String userId = req.getParameter("userid");
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            String email = req.getParameter("email");


            // Hash the password using BCrypt
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());


            String query = "INSERT INTO users (user_id, username, password_hash, email, is_active, role) VALUES (?, ?, ?, ?, ?, ?)";


            Connection connection = dataSource.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(query);


            preparedStatement.setString(1, userId);
            preparedStatement.setString(2, username);
            preparedStatement.setString(3, hashedPassword);
            preparedStatement.setString(4, email); // Set hashed password instead of plain password
            preparedStatement.setBoolean(5, true); // Setting is_active to true
            preparedStatement.setString(6, "ADMIN"); // Setting role to "ADMIN"


            int affectedRowCount = preparedStatement.executeUpdate();


            if (affectedRowCount > 0) {

                resp.sendRedirect("5.Admin-User-Registration.jsp?message=Admin user saved successfully");
            } else {

                resp.sendRedirect("5.Admin-User-Registration.jsp?error=Fail to save admin user");
            }
        } catch (Exception e) {
            e.printStackTrace();

            resp.sendRedirect("5.Admin-User-Registration.jsp?error=Fail to save admin user!");
        }
    }


}
