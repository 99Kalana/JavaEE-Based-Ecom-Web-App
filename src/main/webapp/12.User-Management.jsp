<%@ page import="org.example.javaee_ecommerce_web_application_aad.UserDTO" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        #user_form {
            position: absolute;
            left: 0;
            right: 0;
            margin: auto;
        }

        #user_form .btn {
            min-width: 120px;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Admin Homepage</a>
        <h5 style="color: white; position: relative; left: 18%;">- User Management -</h5>
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

<div class="container mt-5" id="user_form">
    <!-- User Form -->
    <div class="card my-4">
        <div class="card-header"> View and Manage Users</div>
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


            <form id="itemForm" method="post" action="user-manage">
                <div class="row mb-3">
                    <div class="col">
                        <label for="user_id" class="form-label">User ID</label>
                        <input type="text" class="form-control" id="user_id" name="user_id" placeholder="User ID" required>
                    </div>
                    <div class="col">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" class="form-control" id="username" name="username" placeholder="Username" required>
                    </div>
                    <div class="col">
                        <label for="email" class="form-label">Email</label>
                        <input type="text" class="form-control" id="email" name="email" placeholder="Email" required>
                    </div>
                    <div class="col">
                        <label for="is_active" class="form-label">Account Status</label>
                        <input type="text" class="form-control" id="is_active" name="account_status" placeholder="Account Status" required>
                    </div>
                    <div class="col">
                        <label for="role" class="form-label">User's Role</label>
                        <input type="text" class="form-control" id="role" name="user_role" placeholder="User's Role" required>
                    </div>
                </div>

                <!-- Button Row -->
                <div class="row mb-3">
                    <div class="col d-flex justify-content-center">
                        <button type="button" id="searchUser"  class="btn btn-outline-info mx-2">Search User Details</button>
                        <button type="submit" id="activateUser" name="action" value="activate" class="btn btn-warning mx-2">Activate User</button>
                        <button type="submit" id="deactivateUser" name="action" value="deactivate" class="btn btn-danger mx-2">Deactivate User</button>
                        <button type="reset" id="clearUser" class="btn btn-outline-success mx-2">Clear</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- User Table -->
    <h3 class="mt-5">User List</h3>
    <table class="table table-bordered table-striped mt-3">
        <thead>
        <tr>
            <th>User ID</th>
            <th>Username</th>
            <th>Email</th>
            <th>Account Status</th>
            <th>User Role</th>
        </tr>
        </thead>
        <tbody id="userTableBody">
        <%-- Dynamic User List Rendering --%>
        <%
            // Replace with actual data retrieval logic
            List<UserDTO> usersList = (List<UserDTO>) request.getAttribute("userList");
            if (usersList != null) {
                for (UserDTO userDTO : usersList) {
        %>
        <tr>
            <td><%= userDTO.getUser_id() %></td>
            <td><%= userDTO.getUser_name() %></td>
            <td><%= userDTO.getEmail() %></td>
            <td><%= userDTO.is_active() ? "Active" : "Inactive" %></td>
            <td><%= userDTO.getRole() %></td>
        </tr>
        <%
                }
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
        if (!currentPath.includes("12.User-Management")) {
            // Redirect to the "index" page if not already there
            window.location.href = "12.User-Management";
        }
    };
</script>

<script>

    $('#searchUser').on('click', function () {
        const userId = $('#user_id').val().trim();
        if (userId) {
            searchProduct(); // Perform AJAX search
        } else {
            alert('Please enter a Product ID.');
        }
    });


    $('#user_id').on('keypress', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            searchProduct();
        }
    });

    function searchProduct() {
        const userId = $('#user_id').val().trim();
        if (!userId) {
            alert('Please enter a User ID.');
            return;
        }

        $.ajax({
            url: 'http://localhost:8080/JavaEE_ECommerce_Web_Application_AAD_war_exploded/userSearch',
            type: 'GET',
            data: { user_id: userId },
            headers: {
                "Content-Type": "application/json"
            },
            success: function (response) {

                if (response) {
                    $('#username').val(response.username);
                    $('#email').val(response.email);
                    $('#is_active').val(response.isActive === true ? "Active" : "Inactive");
                    $('#role').val(response.role);
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
