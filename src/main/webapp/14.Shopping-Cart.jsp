<%@ page import="org.example.javaee_ecommerce_web_application_aad.CartDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .cart-container {
            margin-top: 60px;
        }
        .cart-table th, .cart-table td {
            vertical-align: middle;
            text-align: center;
        }
        .order-summary {
            margin-top: 20px;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
        }
        .btn-place-order {
            width: 100%;
            margin-top: 10px;
        }

        #cart{
            position: absolute;
            left: 0;
            right: 0;
            margin: auto;
            top: 14%;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Customer Homepage</a>
        <h5 style="color: white; position: relative; left: 18%;">- Shopping Cart -</h5>
        <div class="d-flex ms-auto me-3">
            <a class="nav-link text-white mx-3" href="13.Product-Browsing.jsp">Product Browse</a>
            <a class="nav-link text-white mx-3" href="14.Shopping-Cart.jsp">Shopping Cart</a>
            <a class="nav-link text-white mx-3" href="#">View Order History</a>
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
                        <a class="nav-link active" aria-current="page" href="#">Profile Manage</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="17.Customer-User-Logins.jsp" style="color: red">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<div class="container cart-container" id="cart">

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


        <%
            List<CartDTO> dataList = (List<CartDTO>) request.getAttribute("cartItems");
            if (dataList != null && !dataList.isEmpty()) {
        %>
        <table class="table table-bordered table-striped mt-3">
            <thead>
            <tr>
                <th>Product ID</th>
                <th>Product Name</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Total</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody id="cartTableBody">
            <%
                for (CartDTO cartDTO : dataList) {
            %>
            <tr>
                <td><%= cartDTO.getProductId() %></td>
                <td><%= cartDTO.getProductName()%>></td>
                <td><%= cartDTO.getPrice() %></td>
                <td>
                    <input type="number" min="1" value="<%= cartDTO.getQuantity() %>" data-id="<%= cartDTO.getProductId() %>" class="form-control quantity-input">
                </td>
                <td>Rs<%= cartDTO.getPrice() * cartDTO.getQuantity() %></td>
                <td>
                    <button class="btn btn-danger btn-sm btn-remove" data-id="<%= cartDTO.getProductId() %>">Remove</button>
                </td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="8" class="text-center">No Cart Data Found</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>

    <!-- Order Summary -->
    <div class="order-summary">
        <h4>Order Summary</h4>
        <%
            List<CartDTO> cartItems = (List<CartDTO>) request.getAttribute("cartItems");
            int totalItems = request.getAttribute("totalItems") != null ? (int) request.getAttribute("totalItems") : 0;
            double totalPrice = request.getAttribute("totalPrice") != null ? (double) request.getAttribute("totalPrice") : 0.0;
        %>
        <p><strong>Total Items:</strong> <span id="totalItems"><%= totalItems %></span></p>
        <p><strong>Total Price:</strong> $<span id="totalPrice"><%= totalPrice %></span></p>
        <button class="btn btn-success btn-place-order" id="placeOrderButton">Place Order</button>
    </div>
</div>


<script src="assets/js/jquery-3.7.1.min.js"></script>

<script>
    let cartItems = [];
    <% if (cartItems != null && !cartItems.isEmpty()) { %>
    cartItems = <%= new Gson().toJson(cartItems) %>;
    <% } %>
</script>


<script>
    function renderCart() {
        const cartTableBody = $('#cartTableBody');
        cartTableBody.empty();

        let totalItems = 0;
        let totalPrice = 0;

        <%
            //List<CartDTO> items = (List<CartDTO>) request.getAttribute("cartItems");
            if (cartItems != null && !cartItems.isEmpty()) {
                for (CartDTO item : cartItems) {
                    double itemTotal = item.getPrice() * item.getQuantity();
        %>

        cartItems.forEach(item => {
            const itemTotal = item.price * item.quantity;
            totalItems += item.quantity;
            totalPrice += itemTotal;

            const row = `
            <tr>
                <td><%= item.getProductId() %></td>
                <td><%= item.getProductName() %></td>
                <td>$<%= String.format("%.2f", item.getPrice()) %></td>
                <td>
                    <input type="number" min="1" value="<%= item.getQuantity() %>" data-id="<%= item.getProductId() %>" class="form-control quantity-input">
                </td>
                <td>$<%= String.format("%.2f", itemTotal) %></td>
                <td>
                    <button class="btn btn-danger btn-sm btn-remove" data-id="<%= item.getProductId() %>">Remove</button>
                </td>
            </tr>
        `;
            cartTableBody.append(row);
        });

        <%
                }
            }
        %>

        $('#totalItems').text(totalItems);
        $('#totalPrice').text(`Rs ${totalPrice.toFixed(2)}`);
    }


    // Update cart quantity
    $(document).on('change', '.quantity-input', function () {
        const productId = $(this).data('id');
        const newQuantity = parseInt($(this).val());
        const item = cartItems.find(item => item.product_id === productId);
        if (item) {
            item.quantity = newQuantity;
            renderCart();
        }
    });

    // Remove item from cart
    $(document).on('click', '.btn-remove', function () {
        const productId = $(this).data('id');

        cartItems = cartItems.filter(item => item.productId !== productId);

        // Send update to session
        $.post('UpdateCartServlet', { cartItems: JSON.stringify(cartItems) });

        renderCart();
    });

    // Place order
    $('#placeOrderButton').click(function () {
        if (cartItems.length === 0) {
            alert('Your cart is empty!');
            return;
        }

        $.ajax({
            type: 'POST',
            url: 'http://localhost:8080/JavaEE_ECommerce_Web_Application_AAD_war_exploded/cartPlaceOrder', // Ensure this is the correct backend endpoint
            contentType: 'application/json',
            data: JSON.stringify(cartItems),
            success: function (response) {
                alert('Order placed successfully!');
                //window.location.href = 'orderConfirmation.jsp'; // Redirect to confirmation page
            },
            error: function (error) {
                console.error('Error placing order:', error);
                alert('Failed to place order. Try again.');
            }
        });

        // Clear cart
        cartItems.length = 0;
        renderCart();
    });

    // Initialize
    renderCart();
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
