<%--
  Created by IntelliJ IDEA.
  User: Karl
  Date: 1/22/2025
  Time: 1:04 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>Admin Confirmation</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css" />
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <style>
        /* Add any custom styles here */
    </style>
</head>

<body>
<%-- Container for the Admin Confirmation Form --%>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h2 class="text-center mb-4">Enter Provided Password for Admin Authorization</h2>

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

                    <%-- Form to handle admin confirmation --%>
                    <form action="admin-authorize" method="post">
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                            <i class="bi bi-eye-slash" id="togglePassword"></i>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Enter</button>
                    </form>
                    <div class="text-center mt-3">
                        <a href="2.User's-Role.jsp" class="btn btn-outline-danger">Back</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>



<script src="assets/js/jquery-3.7.1.min.js"></script>

<script>
    $(document).ready(function () {
        const togglePassword = $('#togglePassword');
        const password = $('#password');

        togglePassword.on('click', function () {
            const type = password.attr('type') === 'password' ? 'text' : 'password';
            password.attr('type', type);

            $(this).toggleClass('bi-eye bi-eye-slash');
        });
    });
</script>

</body>

</html>

