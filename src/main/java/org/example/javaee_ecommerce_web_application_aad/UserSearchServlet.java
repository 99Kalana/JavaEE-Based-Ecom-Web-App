package org.example.javaee_ecommerce_web_application_aad;

import jakarta.annotation.Resource;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.json.Json;
import javax.json.JsonObjectBuilder;
import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(urlPatterns = "/userSearch")
public class UserSearchServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String userId = req.getParameter("user_id");

        try (Connection connection = dataSource.getConnection()){

            if (userId != null) {

                String sql = "SELECT * FROM users WHERE user_id = ?";
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setString(1, userId);

                ResultSet resultSet = preparedStatement.executeQuery();

                if (resultSet.next()) {

                    JsonObjectBuilder productJson = Json.createObjectBuilder();

                    productJson.add("user_id", resultSet.getString("user_id"));
                    productJson.add("username", resultSet.getString("username"));
                    productJson.add("password_hash", resultSet.getString("password_hash"));
                    productJson.add("email", resultSet.getString("email"));
                    productJson.add("isActive", resultSet.getBoolean("is_active")); // Retrieve as boolean
                    productJson.add("role", resultSet.getString("role"));

                    resp.setContentType("application/json");
                    resp.getWriter().write(productJson.build().toString());

                } else {

                    JsonObjectBuilder response = Json.createObjectBuilder();
                    response.add("status", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.add("message", "Not found User data!");
                    response.add("data", "");


                    resp.setContentType("application/json");
                    resp.getWriter().print(response.build().toString());

                }
            }

        }catch (Exception e){
            e.printStackTrace();
            JsonObjectBuilder response = Json.createObjectBuilder();
            response.add("status", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.add("message", e.getMessage());
            response.add("data", "");
            resp.setContentType("application/json");
            resp.getWriter().print(response.build().toString());

        }

    }


}
