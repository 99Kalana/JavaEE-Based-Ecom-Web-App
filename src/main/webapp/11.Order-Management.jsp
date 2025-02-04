<%@ page import="org.example.javaee_ecommerce_web_application_aad.OrdersDTO" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

    <style>
        #order_form {
            position: absolute;
            left: 0;
            right: 0;
            margin: auto;
        }

        #order_form .btn {
            min-width: 120px;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Admin Homepage</a>
        <h5 style="color: white; position: relative; left: 18%;">- Order Management -</h5>
        <div class="d-flex ms-auto me-3">
            <a class="nav-link text-white mx-3" href="<%= request.getContextPath() %>/9.Product-Management">Product Management</a>
            <a class="nav-link text-white mx-3" href="<%= request.getContextPath() %>/10.Category-Management">Category Management</a>
            <a class="nav-link text-white mx-3" href="<%= request.getContextPath() %>/11.Order-Management">Order Management</a>
            <a class="nav-link text-white mx-3" href="<%= request.getContextPath() %>/12.User-Management">User Management</a>
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
                        <a class="nav-link" href="4.Admin-User-Logins.jsp" style="color: red">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<div class="container mt-5" id="order_form">
    <!-- Product Form -->
    <div class="card my-4">
        <div class="card-header">View Order Details</div>
        <div class="card-body">
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
            <form id="itemForm" method="post" action="order-manage">
                <div class="row mb-3">
                    <div class="col">
                        <label for="order_id" class="form-label">Order ID</label>
                        <input type="text" class="form-control" id="order_id" name="order_id" placeholder="Order ID" required>
                    </div>
                    <div class="col">
                        <label for="user_id" class="form-label">User ID</label>
                        <input type="text" class="form-control" id="user_id" name="user_id" placeholder="User ID" required>
                    </div>
                    <div class="col">
                        <label for="total_amount" class="form-label">Total Amount</label>
                        <input type="text" class="form-control" id="total_amount" name="total_amount" placeholder="Total Amount" required>
                    </div>
                    <div class="col">
                        <label for="order_date" class="form-label">Order Date</label>
                        <input type="text" class="form-control" id="order_date" name="order_date" placeholder="Order Date" required>
                    </div>
                    <div class="col">
                        <label for="status" class="form-label">Status</label>
                        <input type="text" class="form-control" id="status" name="status" placeholder="Status" required>
                    </div>
                </div>

                <!-- Button Row -->
                <div class="row mb-3">
                    <div class="col d-flex justify-content-center">
                        <button type="button" id="searchOrder" class="btn btn-outline-info mx-2">Search Order Details</button>
                        <button type="submit" id="orderShipped" name="action" value="shipped" class="btn btn-primary mx-2">Order Shipped</button>
                        <button type="submit" id="orderDelivered" name="action" value="delivered" class="btn btn-warning mx-2">Order Delivered</button>
                        <button type="submit" id="orderCancel" name="action" value="cancel" class="btn btn-danger mx-2">Cancel Order</button>
                        <button type="reset" id="clearOrder" class="btn btn-success mx-2">Clear</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Order Table -->
    <h3 class="mt-5">Order List</h3>
    <%
        List<OrdersDTO> dataList = (List<OrdersDTO>) request.getAttribute("orders");
        if (dataList != null && !dataList.isEmpty()) {
    %>
    <table class="table table-bordered table-striped mt-3">
        <thead>
        <tr>
            <th>order_id</th>
            <th>user_id</th>
            <th>order_date</th>
            <th>total_amount</th>
            <th>status</th>
        </tr>
        </thead>
        <tbody id="orderTableBody">
        <%
            for (OrdersDTO ordersDTO : dataList) {
        %>
        <tr>
            <td><%= ordersDTO.getOrder_Id() %></td>
            <td><%= ordersDTO.getUser_Id() %></td>
            <td><%= ordersDTO.getOrder_date() %></td>
            <td><%= ordersDTO.getTotal_amount() %></td>
            <td><%= ordersDTO.getStatus() %></td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="8" class="text-center">No Order Found</td>
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
        if (!currentPath.includes("11.Order-Management")) {
            // Redirect to the "index" page if not already there
            window.location.href = "11.Order-Management";
        }
    };
</script>

<script>

    $('#searchOrder').on('click', function () {
        const orderId = $('#order_id').val().trim();
        if (orderId) {
            searchOrder(); // Perform AJAX search
        } else {
            alert('Please enter a Order ID.');
        }
    });


    $('#order_id').on('keypress', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            searchOrder();
        }
    });

    function searchOrder() {
        const orderId = $('#order_id').val().trim();
        if (!orderId) {
            alert('Please enter a Order ID.');
            return;
        }

        $.ajax({
            url: 'http://localhost:8080/JavaEE_ECommerce_Web_Application_AAD_war_exploded/orderSearch',
            type: 'GET',
            data: { order_id: orderId },
            headers: {
                "Content-Type": "application/json"
            },
            success: function (response) {

                if (response) {
                    $('#user_id').val(response.user_id);
                    $('#total_amount').val(response.totalAmount);
                    $('#order_date').val(response.orderDate);
                    $('#status').val(response.status);
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
