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
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ProductListServlet", value = "/9.Product-Management")
public class ProductListServlet extends HttpServlet {

    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<ProductsDTO> productList = new ArrayList<>();
        try {
            Connection connection = dataSource.getConnection();

            String sql = "SELECT * FROM products";
            Statement stm = connection.createStatement();
            ResultSet rst = stm.executeQuery(sql);

            while (rst.next()){
                ProductsDTO productsDTO = new ProductsDTO(
                        rst.getString(1),
                        rst.getString(2),
                        rst.getString(3),
                        rst.getDouble(4),
                        rst.getInt(5),
                        rst.getString(6),
                        rst.getString(7),
                        rst.getString(8)
                );
                productList.add(productsDTO);
            }

            req.setAttribute("products", productList);

            RequestDispatcher rd = req.getRequestDispatcher("9.Product-Management.jsp");
            rd.forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("9.Product-Management.jsp?error=Product list failed to load");
        }
    }
}

