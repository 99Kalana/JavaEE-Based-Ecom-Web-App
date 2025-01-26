package org.example.javaee_ecommerce_web_application_aad;

import jakarta.annotation.Resource;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OrderListServlet", value = "/11.Order-Management")
public class OrderListServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<OrdersDTO> orderList = new ArrayList<>();
        try {
            Connection connection = dataSource.getConnection();

            String sql = "SELECT * FROM orders";
            Statement stm = connection.createStatement();
            ResultSet rst = stm.executeQuery(sql);

            while (rst.next()){
                OrdersDTO ordersDTO = new OrdersDTO(
                        rst.getString(1),
                        rst.getString(2),
                        rst.getBigDecimal(3),
                        rst.getTimestamp(4),
                        rst.getString(5)
                );
                orderList.add(ordersDTO);
            }

            req.setAttribute("orders", orderList);

            RequestDispatcher rd = req.getRequestDispatcher("11.Order-Management.jsp");
            rd.forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("11.Order-Management.jsp?error=Product list failed to load");
        }
    }
}
