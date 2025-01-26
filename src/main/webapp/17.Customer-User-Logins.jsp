<%--
  Created by IntelliJ IDEA.
  User: Karl
  Date: 1/26/2025
  Time: 4:07 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>Customer User Logging</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css" />
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <style>

        #logging{
            position: absolute;
            left: 0;
            right: 0;
            margin: auto;
            top: 15%;
        }

    </style>
</head>

<body>

<div class="container mt-5" id="logging">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h2 class="text-center mb-4">Login</h2>


                    <%-- Display success or error message (centered) --%>
                    <% String error = request.getParameter("error"); %>

                    <% if (error != null) { %>
                    <div class="alert alert-danger text-center" role="alert">
                        <%= error %>
                    </div>
                    <% } %>


                    <form action="customer-login" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                            <i class="bi bi-eye-slash" id="togglePassword"></i>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Login</button>
                    </form>
                    <div class="text-center mt-3">
                        <a href="18.Customer-User-Registration.html.jsp">Create an Account!</a>
                    </div>
                    <div class="text-center mt-3">
                        <a href="19.Customer-Username-Password-Reset.jsp">Forgot your Password?</a>
                    </div>
                </div>
            </div>
            <div class="text-center mt-3">
                <a href="2.User's-Role.jsp" class="btn btn-outline-danger">Back</a>
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
