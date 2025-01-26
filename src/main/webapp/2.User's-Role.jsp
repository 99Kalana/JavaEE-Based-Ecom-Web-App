<%--
  Created by IntelliJ IDEA.
  User: Karl
  Date: 1/20/2025
  Time: 10:29 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User's Role</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

    <style>

        section{
            position: absolute;
            width: 100vw;
            height: 100vh;
        }

        section>#div1{
            position: relative;
            top: 30%;
            left: 0;
            right: 0;
            margin: auto;
        }
    </style>


</head>
<body>

<section>
    <div class="card mb-3 shadow p-3 mb-5 bg-body-tertiary rounded" id="div1" style="width: 840px; height: max-content; text-align: center">
        <div class="row g-0">
            <div class="col-md-4">
                <img src="resources/images/user's%20role.webp" class="img-fluid rounded-start" alt="user's role" style="width: max-content; height: 250px;">
            </div>
            <div class="col-md-8">
                <div class="card-body">
                    <h1 class="card-title">Who are you?</h1>
                    <p class="d-grid gap-3 d-md-block" style="position: relative; top: 50px;  margin: auto;">
                        <a href="3.Admin-Confirmation.jsp" class="btn btn-outline-primary" >Admin</a>
                        <a href="17.Customer-User-Logins.jsp" class="btn btn-outline-secondary" >User</a>
                    </p>
                </div>
            </div>
        </div>

        <a href="index.jsp" class="btn btn-outline-warning" style="position:relative; left: 0; right: 0; margin: auto; ">EXIT</a>

    </div>

</section>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
