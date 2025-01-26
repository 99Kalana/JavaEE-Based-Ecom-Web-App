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
import java.sql.SQLException;

@WebServlet(urlPatterns = "/productSearch")
public class ProductSearchServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String product_ID = req.getParameter("product_id");

        try (Connection connection = dataSource.getConnection()){

            if (product_ID != null) {

                String sql = "SELECT * FROM products WHERE product_id = ?";
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setString(1, product_ID);

                ResultSet resultSet = preparedStatement.executeQuery();

                if (resultSet.next()) {

                    JsonObjectBuilder productJson = Json.createObjectBuilder();

                    productJson.add("product_id", resultSet.getString("product_id"));
                    productJson.add("product_name", resultSet.getString("product_name"));
                    productJson.add("description", resultSet.getString("description"));
                    productJson.add("price", resultSet.getString("price"));
                    productJson.add("stock", resultSet.getString("stock"));
                    productJson.add("category_id", resultSet.getString("category_id"));
                    productJson.add("category_name", resultSet.getString("category_name"));
                    productJson.add("image_path", resultSet.getString("image_path"));

                    resp.setContentType("application/json");
                    resp.getWriter().write(productJson.build().toString());

                } else {

                    JsonObjectBuilder response = Json.createObjectBuilder();
                    response.add("status", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.add("message", "Not found Product data!");
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



