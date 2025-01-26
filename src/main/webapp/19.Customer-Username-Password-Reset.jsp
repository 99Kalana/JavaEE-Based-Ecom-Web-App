<%--
  Created by IntelliJ IDEA.
  User: Karl
  Date: 1/22/2025
  Time: 7:48 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h2 class="text-center mb-4">Change Password</h2>

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

                    <form action="customer-password_change" method="post">
                        <!-- User ID -->
                        <div class="mb-3">
                            <label for="userid" class="form-label">User ID</label>
                            <input type="text" class="form-control" id="userid" name="userid" required>
                        </div>
                        <!-- Username -->
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <!-- New Password -->
                        <div class="mb-3">
                            <label for="newPassword" class="form-label">New Password</label>
                            <input type="text" class="form-control" id="newPassword" name="newPassword" required>
                        </div>
                        <!-- Submit Button -->
                        <button type="submit" class="btn btn-primary w-100">Update Password</button>
                    </form>
                    <div class="text-center mt-3">
                        <a href="17.Customer-User-Logins.jsp">Back to Login</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

