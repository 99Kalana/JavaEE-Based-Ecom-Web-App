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

@WebServlet(name = "CategoryListServlet", value = "/10.Category-Management")
public class CategoryListServlet extends HttpServlet {
    @Resource(name = "java:comp/env/jdbc/pool")
    private DataSource dataSource;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<CategoryDTO> categoryList = new ArrayList<>();
        try {
            Connection connection = dataSource.getConnection();

            String sql = "SELECT * FROM categories";
            Statement stm = connection.createStatement();
            ResultSet rst = stm.executeQuery(sql);

            while (rst.next()){
                CategoryDTO categoryDTO = new CategoryDTO(
                        rst.getString(1),
                        rst.getString(2)
                );
                categoryList.add(categoryDTO);
            }

            req.setAttribute("categories", categoryList);

            RequestDispatcher rd = req.getRequestDispatcher("10.Category-Management.jsp");
            rd.forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("10.Category-Management.jsp?error=Product list failed to load");
        }
    }

}
