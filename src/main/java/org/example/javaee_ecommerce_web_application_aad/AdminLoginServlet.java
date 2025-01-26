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

@WebServlet(name = "AdminLoginServlet",value = "/admin-login")
public class AdminLoginServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try (Connection connection = dataSource.getConnection()) {

            String query = "SELECT password_hash FROM users WHERE username = ?";
            try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                preparedStatement.setString(1, username);
                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    if (resultSet.next()) {
                        String hashedPassword = resultSet.getString("password_hash");


                        if (BCrypt.checkpw(password, hashedPassword)) {

                            resp.sendRedirect("7.Admin-Homepage.jsp");
                        } else {

                            resp.sendRedirect("4.Admin-User-Logins.jsp?error=Invalid password.");
                        }
                    } else {

                        resp.sendRedirect("4.Admin-User-Logins.jsp?error=Invalid username.");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("4.Admin-User-Logins.jsp?error=Database Connection Error");
        }


    }
}
