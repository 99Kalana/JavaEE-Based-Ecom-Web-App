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

@WebServlet(urlPatterns = "/orderSearch")
public class OrderSearchServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String order_ID = req.getParameter("order_id");

        try (Connection connection = dataSource.getConnection()){

            if (order_ID != null) {

                String sql = "SELECT * FROM orders WHERE order_id = ?";
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setString(1, order_ID);

                ResultSet resultSet = preparedStatement.executeQuery();

                if (resultSet.next()) {

                    JsonObjectBuilder orderJson = Json.createObjectBuilder();

                    /*productJson.add("order_id", resultSet.getString("order_id"));
                    productJson.add("user_id", resultSet.getString("user_id"));
                    productJson.add("total_amount", resultSet.getString("total_amount"));
                    productJson.add("order_date", resultSet.getString("order_date"));
                    productJson.add("status", resultSet.getString("status"));*/

                    orderJson.add("order_id", resultSet.getString("order_id"));
                    orderJson.add("user_id", resultSet.getString("user_id"));
                    orderJson.add("totalAmount", resultSet.getDouble("total_amount")); // Numeric column
                    orderJson.add("orderDate", resultSet.getString("order_date")); // TIMESTAMP
                    orderJson.add("status", resultSet.getString("status")); // ENUM column as string

                    resp.setContentType("application/json");
                    resp.getWriter().write(orderJson.build().toString());

                } else {

                    JsonObjectBuilder response = Json.createObjectBuilder();
                    response.add("status", HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.add("message", "Not found Order data!");
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
