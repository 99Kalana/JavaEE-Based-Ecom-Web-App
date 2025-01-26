<%--
<%@ page import="org.example.javaee_ecommerce_web_application_aad.CartDTO" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
            <a class="nav-link text-white mx-3" href="14.Shopping-Cart">Shopping Cart</a>
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

        <%
            List<CartDTO> dataList = (List<CartDTO>) request.getAttribute("cartItems");
            if (dataList != null && !dataList.isEmpty()) {
        %>
        <table class="table table-bordered table-striped mt-3">
            <thead>
            <tr>
                <th>Product</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Total</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (CartDTO cartDTO : dataList) {
            %>
            <tr>
                <td><%= cartDTO.getProductId() %></td>
                <td><%= cartDTO.getPrice() %></td>
                <td>
                    <input type="number" min="1" value="<%= cartDTO.getQuantity() %>" data-id="<%= cartDTO.getProductId() %>" class="form-control quantity-input">
                </td>
                <td>$<%= cartDTO.getPrice() * cartDTO.getQuantity() %></td>
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
        <p><strong>Total Items:</strong> <span id="totalItems"></span></p>  &lt;%&ndash;<%= totalItems %>&ndash;%&gt;
        <p><strong>Total Price:</strong> $<span id="totalPrice"></span></p> &lt;%&ndash;<%= totalPrice %>&ndash;%&gt;
        <button class="btn btn-success btn-place-order" id="placeOrderButton">Place Order</button>
    </div>
</div>


<script src="assets/js/jquery-3.7.1.min.js"></script>

<script>
    const cartItems = ${cartItems};  // Pass cartItems as a JSON object from the request
    renderCart();
</script>

<script>
    // Render cart dynamically and update the session
    function renderCart() {
        const cartTableBody = $('#cartTableBody');
        cartTableBody.empty();

        let totalItems = 0;
        let totalPrice = 0;

        const cartItems = ${cartItems};  // Assuming cartItems are passed as a list in the request/session

        cartItems.forEach(item => {
            const itemTotal = item.price * item.quantity;
            totalItems += item.quantity;
            totalPrice += itemTotal;

            const row = `
                <tr>
                    <td>${item.product_name}</td>
                    <td>$${item.price.toFixed(2)}</td>
                    <td>
                        <input type="number" min="1" value="${item.quantity}" data-id="${item.product_id}" class="form-control quantity-input">
                    </td>
                    <td>$${itemTotal.toFixed(2)}</td>
                    <td>
                        <button class="btn btn-danger btn-sm btn-remove" data-id="${item.product_id}">Remove</button>
                    </td>
                </tr>
            `;
            cartTableBody.append(row);
        });

        $('#totalItems').text(totalItems);
        $('#totalPrice').text(totalPrice.toFixed(2));
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
        const itemIndex = cartItems.findIndex(item => item.product_id === productId);
        if (itemIndex !== -1) {
            cartItems.splice(itemIndex, 1);
            renderCart();
        }
    });

    // Place order
    $('#placeOrderButton').click(function () {
        if (cartItems.length === 0) {
            alert('Your cart is empty!');
            return;
        }

        const orderDetails = cartItems.map(item => ({
            product_id: item.product_id,
            quantity: item.quantity,
            price: item.price
        }));

        // Send order details to the server (mocked here)
        console.log('Placing order:', orderDetails);
        alert('Order placed successfully!');

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
--%>
