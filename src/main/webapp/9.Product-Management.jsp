
<%@ page import="org.example.javaee_ecommerce_web_application_aad.ProductsDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %><%--
  Created by IntelliJ IDEA.
  User: Karl
  Date: 1/22/2025
  Time: 8:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Product Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        #product_form {
            position: absolute;
            left: 0;
            right: 0;
            margin: auto;
        }

        #product_form .btn {
            min-width: 120px;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="7.Admin-Homepage.jsp">Admin Homepage</a>
        <h5 style="color: white; position: relative; left: 18%;">- Product Management -</h5>
        <div class="d-flex ms-auto me-3">
            <a class="nav-link text-white mx-3" href="9.Product-Management">Product Management</a>
            <a class="nav-link text-white mx-3" href="10.Category-Management">Category Management</a>
            <a class="nav-link text-white mx-3" href="order-management.jsp">Order Management</a>
            <a class="nav-link text-white mx-3" href="user-management.jsp">User Management</a>
        </div>
        <button class="navbar-toggler" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasDarkNavbar" aria-controls="offcanvasDarkNavbar" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="offcanvas offcanvas-end text-bg-dark" tabindex="-1" id="offcanvasDarkNavbar" aria-labelledby="offcanvasDarkNavbarLabel">
            <div class="offcanvas-header">
                <h5 class="offcanvas-title" id="offcanvasDarkNavbarLabel">E-Commerce</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Close"></button>
            </div>
            <div class="offcanvas-body">
                <ul class="navbar-nav justify-content-end flex-grow-1 pe-3">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="profile-manage.jsp">Profile Manage</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="4.Admin-User-Logins.jsp" style="color: red">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<div class="container mt-5" id="product_form">
    <!-- Product Form -->
    <div class="card my-4">
        <div class="card-header">Enter Product Details</div>
        <div class="card-body">


            <%
                String productID = "P001";
                String errorDB = null;

                // Database connection
                String dbURL = "jdbc:mysql://localhost:3306/ecommerce";
                String dbUsername = "root";
                String dbPassword = "Ijse@1234";

                try (Connection connection = DriverManager.getConnection(dbURL, dbUsername, dbPassword)) {
                    String query = "SELECT product_id FROM products ORDER BY product_id DESC LIMIT 1";
                    try (PreparedStatement preparedStatement = connection.prepareStatement(query);
                         ResultSet resultSet = preparedStatement.executeQuery()) {
                        if (resultSet.next()) {
                            String lastUserId = resultSet.getString("product_id");
                            int newId = Integer.parseInt(lastUserId.substring(1)) + 1;
                            productID = String.format("P%03d", newId);
                        }
                    }
                } catch (SQLException e) {
                    errorDB = "Error connecting to the database: " + e.getMessage();
                    e.printStackTrace();
                }
            %>

            <% if (errorDB != null) { %>
            <div class="alert alert-danger text-center" role="alert">
                <%= errorDB %>
            </div>
            <% } %>


            <%-- Display success or error message (centered) --%>
            <% String message = request.getParameter("message"); %>
            <% String error = request.getParameter("error"); %>

            <% if (message != null) { %>
            <div class="alert alert-success text-center" role="alert">
                <%= message %>
            </div>
            <% } %>

            <% if (error != null) { %>
            <div class="alert alert-danger text-center" role="alert">
                <%= error %>
            </div>
            <% } %>

            <%--Category part--%>

            <%
                List<Map<String, String>> categoryList = new ArrayList<>();
                /*String dbURL = "jdbc:mysql://localhost:3306/ecommerce";
                String dbUsername = "root";
                String dbPassword = "Ijse@1234";*/

                try (Connection connection = DriverManager.getConnection(dbURL, dbUsername, dbPassword)) {
                    String query = "SELECT category_id, category_name FROM categories";  // Assuming you have a categories table
                    try (PreparedStatement preparedStatement = connection.prepareStatement(query);
                         ResultSet resultSet = preparedStatement.executeQuery()) {
                        while (resultSet.next()) {
                            Map<String, String> categoryMap = new HashMap<>();
                            categoryMap.put("category_id", resultSet.getString("category_id"));
                            categoryMap.put("category_name", resultSet.getString("category_name"));
                            categoryList.add(categoryMap);
                        }
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                request.setAttribute("categoryList", categoryList);
            %>



            <form id="itemForm" method="post" action="${pageContext.request.contextPath}/product-manage" enctype="multipart/form-data">
                <div class="row mb-3">
                    <div class="col">
                        <label for="product_id" class="form-label">Product ID</label>
                        <input type="text" class="form-control" id="product_id" name="product_id" placeholder="Product ID and Press Enter for Search" value="<%= productID %>" required>
                    </div>
                    <div class="col">
                        <label for="product_name" class="form-label">Product Name</label>
                        <input type="text" class="form-control" id="product_name" name="product_name" placeholder="Product Name" required>
                    </div>
                    <div class="col">
                        <label for="description" class="form-label">Product Description</label>
                        <input type="text" class="form-control" id="description" name="description" placeholder="Product Description" required>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col">
                        <label for="price" class="form-label">Product Price</label>
                        <input type="text" class="form-control" id="price" name="price" placeholder="Product Price" required>
                    </div>
                    <div class="col">
                        <label for="stock" class="form-label">Product Stock QTY</label>
                        <input type="text" class="form-control" id="stock" name="stock" placeholder="Product Stock QTY" required>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col">
                        <label for="category_id" class="form-label">Category ID</label>
                        <select class="form-select" id="category_id" name="category_id" onchange="updateCategoryName()">
                            <option selected>Open this to select Category ID</option>

                            <%
                                for (Map<String, String> category : categoryList) {
                                    String categoryId = category.get("category_id");
                                    String categoryName = category.get("category_name");
                            %>
                            <option value="<%= categoryId %>"><%= categoryId %></option>
                            <% } %>

                        </select>
                    </div>
                    <div class="col">
                        <label for="category_name" class="form-label">Category Name</label>
                        <input type="text" class="form-control" id="category_name" name="category_name" placeholder="Category Name" required>

                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col">
                        <label for="image_path" class="form-label">Product Image</label>
                        <input type="file" class="form-control" id="image_path" name="image_path" accept="image/*">
                    </div>
                </div>
                <!-- Button Row -->
                <div class="row mb-3">
                    <div class="col d-flex justify-content-center">
                        <button type="submit" id="saveProduct" name="action" value="save" class="btn btn-primary mx-2">Save Product</button>
                        <button type="submit" id="updateProduct" name="action" value="update" class="btn btn-warning mx-2">Update Product</button>
                        <button type="submit" id="deleteProduct" name="action" value="delete" class="btn btn-danger mx-2">Delete Product</button>
                        <button type="button" id="searchProduct" class="btn btn-outline-info mx-2" >Search Product</button>
                        <button type="reset" id="clearProduct" class="btn btn-success mx-2">Clear</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Product Table -->
    <h3 class="mt-5">Product List</h3>
    <a class="btn btn-outline-info" href="9.Product-Management">View All Products</a>

    <%
        List<ProductsDTO> dataList = (List<ProductsDTO>) request.getAttribute("products");
        if (dataList != null && !dataList.isEmpty()) {
    %>
    <table class="table table-bordered table-striped mt-3">
        <thead>
        <tr>
            <th>product_id</th>
            <th>product_name</th>
            <th>product_description</th>
            <th>product_price</th>
            <th>product_stock_qty</th>
            <th>ID_Category</th>
            <th>category_name</th>
            <th>product_image</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (ProductsDTO productsDTO : dataList) {
        %>
        <tr>
            <td><%= productsDTO.getProduct_id() %></td>
            <td><%= productsDTO.getProduct_name() %></td>
            <td><%= productsDTO.getDescription() %></td>
            <td><%= productsDTO.getPrice() %></td>
            <td><%= productsDTO.getStock() %></td>
            <td><%= productsDTO.getCategory_id() %></td>
            <td><%= productsDTO.getCategory_name() %></td>
            <td>
                <% if (productsDTO.getImage_path() != null) { %>
                <img src="<%= productsDTO.getImage_path() %>" alt="Product Image" style="max-width: 100px; max-height: 100px;">
                <% } else { %>
                <span>No Image</span>
                <% } %>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="8" class="text-center">No Products Found</td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>


</div>

<script src="assets/js/jquery-3.7.1.min.js"></script>

<script>
    window.onload = function() {
        // Get the current URL path
        var currentPath = window.location.pathname;

        // Check if we're on the index page by matching the current path with the target path
        if (!currentPath.includes("9.Product-Management")) {
            // Redirect to the "index" page if not already there
            window.location.href = "9.Product-Management";
        }
    };
</script>



<script>
    function updateCategoryName() {
        const selectedCategoryId = $("#category_id").val();
        const categoryList = <%= new com.google.gson.Gson().toJson(categoryList) %>;

        const selectedCategory = categoryList.find(function(category) {
            return category.category_id === selectedCategoryId;
        });

        if (selectedCategory) {
            $("#category_name").val(selectedCategory.category_name);
        } else {
            $("#category_name").val('');
        }
    }
</script>


<script>

    $('#searchProduct').on('click', function () {
        const productId = $('#product_id').val().trim();
        if (productId) {
            searchProduct(); // Perform AJAX search
        } else {
            alert('Please enter a Product ID.');
        }
    });


    $('#product_id').on('keypress', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            searchProduct();
        }
    });

    function searchProduct() {
        const productId = $('#product_id').val().trim();
        if (!productId) {
            alert('Please enter a Product ID.');
            return;
        }

        $.ajax({
            url: 'http://localhost:8080/JavaEE_ECommerce_Web_Application_AAD_war_exploded/productSearch',
            type: 'GET',
            data: { product_id: productId },
            headers: {
                "Content-Type": "application/json"
            },
            success: function (response) {

                if (response) {
                    $('#product_name').val(response.product_name);
                    $('#description').val(response.description);
                    $('#price').val(response.price);
                    $('#stock').val(response.stock);
                    $('#category_id').val(response.category_id);
                    $('#category_name').val(response.category_name);
                    $('#image_path').val(response.image_path);
                } else {
                    alert('No product data received.');
                }

            },
            error: function () {
                alert('Error searching product.');
            }
        });

    }

</script>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>

