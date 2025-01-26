<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: Karl
  Date: 1/22/2025
  Time: 2:12 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Sign Up</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card">
                <div class="card-body">
                    <h2 class="text-center mb-4">Sign Up</h2>

                    <%
                        String userId = "U001";
                        String error = null;

                        // Database connection
                        String dbURL = "jdbc:mysql://localhost:3306/ecommerce";
                        String dbUsername = "root";
                        String dbPassword = "Ijse@1234";

                        try (Connection connection = DriverManager.getConnection(dbURL, dbUsername, dbPassword)) {
                            String query = "SELECT user_id FROM users ORDER BY user_id DESC LIMIT 1";
                            try (PreparedStatement preparedStatement = connection.prepareStatement(query);
                                 ResultSet resultSet = preparedStatement.executeQuery()) {
                                if (resultSet.next()) {
                                    String lastUserId = resultSet.getString("user_id");
                                    int newId = Integer.parseInt(lastUserId.substring(1)) + 1;
                                    userId = String.format("U%03d", newId); // Format with leading zeros
                                }
                            }
                        } catch (SQLException e) {
                            error = "Error connecting to the database: " + e.getMessage();
                            e.printStackTrace();
                        }
                    %>

                    <% if (error != null) { %>
                    <div class="alert alert-danger text-center" role="alert">
                        <%= error %>
                    </div>
                    <% } %>

                    <% String message = request.getParameter("message"); %>
                    <% String error2 = request.getParameter("error"); %>

                    <% if (message != null) { %>
                    <div class="alert alert-success text-center" role="alert">
                        <%= message %>
                    </div>
                    <% } %>

                    <% if (error2 != null) { %>
                    <div class="alert alert-danger text-center" role="alert">
                        <%= error2 %>
                    </div>
                    <% } %>


                    <form action="customer-register" method="post">
                        <div class="mb-3">
                            <label for="userid" class="form-label">User ID</label>
                            <input type="text"  class="form-control" id="userid" name="userid" value="<%= userId %>" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Sign Up</button>
                    </form>
                    <div class="text-center mt-3">
                        <p>Already have an account? <a href="17.Customer-User-Logins.jsp">Login here</a>.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

