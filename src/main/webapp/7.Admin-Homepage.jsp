<%--
  Created by IntelliJ IDEA.
  User: Karl
  Date: 1/22/2025
  Time: 7:10 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Homepage</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>
<body>

<nav class="navbar navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="7.Admin-Homepage.jsp">Admin Homepage</a>
        <div class="d-flex ms-auto me-3">
            <a class="nav-link text-white mx-3" href="<%= request.getContextPath() %>/9.Product-Management">Product Management</a>
            <a class="nav-link text-white mx-3" href="<%= request.getContextPath() %>/10.Category-Management">Category Management</a>
            <a class="nav-link text-white mx-3" href="<%= request.getContextPath() %>/11.Order-Management">Order Management</a>
            <a class="nav-link text-white mx-3" href="<%= request.getContextPath() %>/12.User-Management">User Management</a>
        </div>
        <button class="navbar-toggler" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasDarkNavbar"
                aria-controls="offcanvasDarkNavbar" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="offcanvas offcanvas-end text-bg-dark" tabindex="-1" id="offcanvasDarkNavbar"
             aria-labelledby="offcanvasDarkNavbarLabel">
            <div class="offcanvas-header">
                <h5 class="offcanvas-title" id="offcanvasDarkNavbarLabel">E-Commerce</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Close"></button>
            </div>
            <div class="offcanvas-body">
                <ul class="navbar-nav justify-content-end flex-grow-1 pe-3">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="<%= request.getContextPath() %>/profile-management.jsp">Profile Manage</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/4.Admin-User-Logins.jsp" style="color: red">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<div class="container" style="margin-top: 280px;">
    <div class="row">

        <div class="col-md-6 mb-4">
            <div class="card shadow-sm">
                <div class="card-body text-center">
                    <h5 class="card-title">Product Management</h5>
                    <p class="card-text">Manage products, add new ones, and update existing records.</p>
                    <a href="<%= request.getContextPath() %>/9.Product-Management" class="btn btn-primary">Go to Products</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 mb-4">
            <div class="card shadow-sm">
                <div class="card-body text-center">
                    <h5 class="card-title">Category Management</h5>
                    <p class="card-text">Add and organize categories for your store.</p>
                    <a href="<%= request.getContextPath() %>/10.Category-Management" class="btn btn-primary">Go to Categories</a>
                </div>
            </div>
        </div>
    </div>
    <div class="row">

        <div class="col-md-6 mb-4">
            <div class="card shadow-sm">
                <div class="card-body text-center">
                    <h5 class="card-title">Order Management</h5>
                    <p class="card-text">View all orders placed by customers.</p>
                    <a href="<%= request.getContextPath() %>/11.Order-Management" class="btn btn-primary">Go to Orders</a>
                </div>
            </div>
        </div>

        <div class="col-md-6 mb-4">
            <div class="card shadow-sm">
                <div class="card-body text-center">
                    <h5 class="card-title">User Management</h5>
                    <p class="card-text">Manage user accounts and permissions.</p>
                    <a href="<%= request.getContextPath() %>/12.User-Management" class="btn btn-primary">Go to Users</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>

