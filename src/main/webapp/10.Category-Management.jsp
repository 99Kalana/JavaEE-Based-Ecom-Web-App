<%@ page import="java.sql.*" %>
<%@ page import="org.example.javaee_ecommerce_web_application_aad.CategoryDTO" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Category Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

    <style>
        #category_form {
            position: absolute;
            left: 0;
            right: 0;
            margin: auto;
        }

        #category_form .btn {
            min-width: 120px;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Admin Homepage</a>
        <h5 style="color: white; position: relative; left: 18%;">- Category Management -</h5>
        <div class="d-flex ms-auto me-3">
            <a class="nav-link text-white mx-3" href="9.Product-Management">Product Management</a>
            <a class="nav-link text-white mx-3" href="10.Category-Management">Category Management</a>
            <a class="nav-link text-white mx-3" href="orderManagement.jsp">Order Management</a>
            <a class="nav-link text-white mx-3" href="userManagement.jsp">User Management</a>
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
                        <a class="nav-link active" aria-current="page" href="profileManage.jsp">Profile Manage</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="4.Admin-User-Logins.jsp" style="color: red">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<div class="container mt-5" id="category_form">
    <!-- Category Form -->
    <div class="card my-4">
        <div class="card-header">Enter Category Details</div>
        <div class="card-body">

                <%
                    String categoryID = "CA001";  // Default starting category ID
                    String errorDB = null;

                    // Database connection
                    String dbURL = "jdbc:mysql://localhost:3306/ecommerce";
                    String dbUsername = "root";
                    String dbPassword = "Ijse@1234";

                    try (Connection connection = DriverManager.getConnection(dbURL, dbUsername, dbPassword)) {
                        String query = "SELECT category_id FROM categories ORDER BY category_id DESC LIMIT 1";
                        try (PreparedStatement preparedStatement = connection.prepareStatement(query);
                             ResultSet resultSet = preparedStatement.executeQuery()) {
                            if (resultSet.next()) {
                                String lastCategoryId = resultSet.getString("category_id");

                                // Ensure the last category_id follows the expected format "CA###"
                                if (lastCategoryId != null && lastCategoryId.matches("CA\\d{3}")) {
                                    int newId = Integer.parseInt(lastCategoryId.substring(2)) + 1;
                                    categoryID = String.format("CA%03d", newId); // Format with 3 digits
                                } else {
                                    // Handle case where the ID doesn't match the expected format
                                    categoryID = "CA001"; // Default fallback
                                }
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


            <form id="itemForm" method="post" action="category-manage" >
                <div class="row mb-3">
                    <div class="col">
                        <label for="category_id" class="form-label">Category ID</label>
                        <input type="text" class="form-control" id="category_id" name="category_id" placeholder="Category ID" value="<%= categoryID %>" required>
                    </div>
                    <div class="col">
                        <label for="category_name" class="form-label">Category Name</label>
                        <input type="text" class="form-control" id="category_name" name="category_name" placeholder="Category Name" required>
                    </div>
                </div>

                <!-- Button Row -->
                <div class="row mb-3">
                    <div class="col d-flex justify-content-center">
                        <button type="submit" id="saveCategory" name="action" value="save" class="btn btn-primary mx-2">Save Category</button>
                        <button type="submit" id="updateCategory" name="action" value="update" class="btn btn-warning mx-2">Update Category</button>
                        <button type="submit" id="deleteCategory" name="action" value="delete" class="btn btn-danger mx-2">Delete Category</button>
                        <button type="button" id="searchCategory" class="btn btn-outline-info mx-2" >Search Category</button>
                        <button type="reset" id="clearCategory" class="btn btn-success mx-2">Clear</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Category Table -->
    <h3 class="mt-5">Category List</h3>
    <%
        List<CategoryDTO> dataList = (List<CategoryDTO>) request.getAttribute("categories");
        if (dataList != null && !dataList.isEmpty()) {
    %>
    <table class="table table-bordered table-striped mt-3">
        <thead>
        <tr>
            <th>category_id</th>
            <th>category_name</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (CategoryDTO categoryDTO : dataList) {
        %>
        <tr>
            <td><%= categoryDTO.getCategory_id() %></td>
            <td><%= categoryDTO.getCategory_name() %></td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="8" class="text-center">No Category Found</td>
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
        if (!currentPath.includes("10.Category-Management")) {
            // Redirect to the "index" page if not already there
            window.location.href = "10.Category-Management";
        }
    };
</script>

<script>

    $('#searchCategory').on('click', function () {
        const productId = $('#category_id').val().trim();
        if (productId) {
            searchProduct(); // Perform AJAX search
        } else {
            alert('Please enter a Product ID.');
        }
    });


    $('#category_id').on('keypress', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            searchProduct();
        }
    });

    function searchProduct() {
        const categoryId = $('#category_id').val().trim();
        if (!categoryId) {
            alert('Please enter a Product ID.');
            return;
        }

        $.ajax({
            url: 'http://localhost:8080/JavaEE_ECommerce_Web_Application_AAD_war_exploded/categorySearch',
            type: 'GET',
            data: { category_id: categoryId },
            headers: {
                "Content-Type": "application/json"
            },
            success: function (response) {

                if (response) {
                    $('#category_name').val(response.category_name);
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
