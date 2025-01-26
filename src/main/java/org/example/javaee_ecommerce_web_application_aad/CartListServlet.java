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

@WebServlet(name = "CartListServlet", value = "/14.Shopping-Cart")
public class CartListServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<CartDTO> cartList = new ArrayList<>();

        String sql = "SELECT * FROM cart";

        try (Connection connection = dataSource.getConnection();
             Statement stm = connection.createStatement();
             ResultSet rst = stm.executeQuery(sql)) {

            while (rst.next()){
                CartDTO cartDTO = new CartDTO(
                        rst.getInt(1),
                        rst.getString(2),
                        rst.getString(3),
                        rst.getInt(4),
                        rst.getDouble(5)
                );
                cartList.add(cartDTO);
            }
            req.setAttribute("cartItems", cartList);
            RequestDispatcher rd = req.getRequestDispatcher("14.Shopping-Cart.jsp");
            rd.forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();  // Log the error
            resp.sendRedirect("14.Shopping-Cart.jsp?error=Product list failed to load");
        }
    }
}
