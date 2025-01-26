
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.example.javaee_ecommerce_web_application_aad.ProductsDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Browsing</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        #productContainer {
            margin-top: 20px;
        }
        .product-card {
            min-height: 300px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            position: relative;
        }

        .product-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }

        .btn-add-to-cart {
            margin-top: 10px;
            width: 100%;
        }

        #productBrowse {
            position: absolute;
            left: 0;
            right: 0;
            margin: auto;
            top: 10%;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="">Admin Homepage</a>
        <h5 style="color: white; position: relative; left: 18%;">- Product Management -</h5>
        <div class="d-flex ms-auto me-3">
            <a class="nav-link text-white mx-3" href="13.Product-Browsing.jsp">Product Browse</a>
            <a class="nav-link text-white mx-3" href="14.Shopping-Cart.jsp">Shopping Cart</a>
            <a class="nav-link text-white mx-3" href="">View Order History</a>
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
                        <a class="nav-link" href="17.Customer-User-Logins.jsp" style="color: red">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<div class="container mt-4" id="productBrowse">
    <!-- Filter Options -->
    <div class="row mb-4">
        <div class="col-md-3">
            <%
                List<Map<String, String>> categoryList = new ArrayList<>();
                String dbURL = "jdbc:mysql://localhost:3306/ecommerce";
                String dbUsername = "root";
                String dbPassword = "Ijse@1234";

                // Fetch categories from the database
                try (Connection connection = DriverManager.getConnection(dbURL, dbUsername, dbPassword)) {
                    String query = "SELECT category_id, category_name FROM categories";
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

            <h5>Filter by Category</h5>
            <select id="categoryFilter" class="form-select">
                <option value="">All Categories</option>
                <%
                    for (Map<String, String> category : categoryList) {
                        String categoryId = category.get("category_id");
                        String categoryName = category.get("category_name");
                %>
                <option value="<%= categoryName %>"><%= categoryName %></option>
                <% } %>
            </select>

        </div>
        <div class="col-md-6">
            <h5>Search by Name</h5>
            <input type="text" id="searchInput" class="form-control" placeholder="Search for products...">
        </div>
        <div class="col-md-3">
            <h5>Sort by Price</h5>
            <select id="priceSort" class="form-select">
                <option value="asc">Price: Low to High</option>
                <option value="desc">Price: High to Low</option>
            </select>
        </div>
    </div>

    <!-- Products Grid -->
    <div id="productContainer" class="row row-cols-1 row-cols-md-3 g-4">
        <%
            List<ProductsDTO> products = new ArrayList<>();
            try (Connection connection = DriverManager.getConnection(dbURL, dbUsername, dbPassword)) {
                String query = "SELECT product_id, product_name, description, price, stock, category_name, image_path FROM products";  // Adjust query if necessary
                try (PreparedStatement preparedStatement = connection.prepareStatement(query);
                     ResultSet resultSet = preparedStatement.executeQuery()) {
                    while (resultSet.next()) {
                        ProductsDTO product = new ProductsDTO();
                        product.setProduct_id(resultSet.getString("product_id"));
                        product.setProduct_name(resultSet.getString("product_name"));
                        product.setDescription(resultSet.getString("description"));
                        product.setPrice(resultSet.getDouble("price"));
                        product.setStock(resultSet.getInt("stock"));
                        product.setCategory_name(resultSet.getString("category_name"));
                        product.setImage_path(resultSet.getString("image_path"));
                        products.add(product);
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            request.setAttribute("products", products);
        %>

        <%-- Display products dynamically --%>
        <%
            for (ProductsDTO product : products) {
        %>
        <div class="col">
            <div class="card product-card">
                <img src="<%= product.getImage_path() %>" alt="<%= product.getProduct_name() %>" class="card-img-top">
                <div class="card-body">
                    <h5 class="card-title"><%= product.getProduct_name() %></h5>
                    <p class="card-text"><%= product.getDescription() %></p>
                    <p><strong>Price:</strong> $<%= product.getPrice() %></p>
                    <p><strong>Stock:</strong> <%= product.getStock() %></p>
                    <p><strong>Category:</strong> <%= product.getCategory_name() %></p>
                    <button class="btn btn-primary btn-add-to-cart" data-id="<%= product.getProduct_id() %>">Add to Cart</button>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>
</div>

<script src="assets/js/jquery-3.7.1.min.js"></script>


<script>
    // Passing the products list to JavaScript as a JSON array
    var products = <%= new com.google.gson.Gson().toJson(request.getAttribute("products")) %>;

    $(document).ready(function () {
        // Filter products based on category, search, and sort order
        function filterProducts() {
            const category = $('#categoryFilter').val();
            const searchQuery = $('#searchInput').val().toLowerCase();
            const sortOrder = $('#priceSort').val();

            let filteredProducts = products;

            // Filter by category
            if (category) {
                filteredProducts = filteredProducts.filter(p => p.category_name === category);
            }

            // Filter by search query
            if (searchQuery) {
                filteredProducts = filteredProducts.filter(p =>
                    p.product_name.toLowerCase().includes(searchQuery)
                );
            }

            // Sort by price
            filteredProducts.sort((a, b) =>
                sortOrder === "asc" ? a.price - b.price : b.price - a.price
            );

            displayProducts(filteredProducts);
        }

        // Function to display products
        function displayProducts(products) {
            const container = $('#productContainer');
            container.empty();

            products.forEach(function (product) {
                const productCard =
                    '<div class="col">' +
                    '   <div class="card product-card">' +
                    '       <img src="' + product.image_path + '" alt="' + product.product_name + '" class="card-img-top">' +
                    '       <div class="card-body">' +
                    '           <h5 class="card-title">' + product.product_name + '</h5>' +
                    '           <p class="card-text">' + product.description + '</p>' +
                    '           <p><strong>Price:</strong> $' + product.price + '</p>' +
                    '           <p><strong>Stock:</strong> ' + product.stock + '</p>' +
                    '           <p><strong>Category:</strong> ' + product.category_name + '</p>' +
                    '           <button class="btn btn-primary btn-add-to-cart" data-id="' + product.product_id + '">Add to Cart</button>' +
                    '       </div>' +
                    '   </div>' +
                    '</div>';

                container.append(productCard);
            });
        }

        // Initialize product display
        displayProducts(products);

        // Event listeners for filters
        $('#categoryFilter, #priceSort').change(filterProducts);
        $('#searchInput').on('input', filterProducts);
    });
</script>

<script>
    $(document).ready(function () {
        // Add event listener for the Add to Cart buttons
        $('.btn-add-to-cart').on('click', function () {
            var productId = $(this).data('id');
            var quantity = 1;

            // Make AJAX POST request to add product to the cart
            $.ajax({
                url: 'http://localhost:8080/JavaEE_ECommerce_Web_Application_AAD_war_exploded/addToCart',  // Relative URL to the servlet
                type: 'POST',
                data: {
                    product_id: productId,
                    quantity: quantity
                },
                success: function (response) {
                    alert('Product added to cart successfully!');
                },
                error: function (xhr, status, error) {
                    alert('Failed to add product to cart.');
                }
            });
        });
    });
</script>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
