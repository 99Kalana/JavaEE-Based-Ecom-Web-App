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

@WebServlet(name = "CustomerRegisterServlet", value = "/customer-register")
public class CustomerRegisterServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

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
            preparedStatement.setString(6, "CUSTOMER"); // Setting role to "CUSTOMER"


            int affectedRowCount = preparedStatement.executeUpdate();


            if (affectedRowCount > 0) {

                resp.sendRedirect("18.Customer-User-Registration.html.jsp?message=Customer saved successfully");
            } else {

                resp.sendRedirect("18.Customer-User-Registration.html.jsp?error=Fail to save customer user");
            }
        } catch (Exception e) {
            e.printStackTrace();

            resp.sendRedirect("18.Customer-User-Registration.html.jsp?error=Fail to save customer user!");
        }
    }
}
