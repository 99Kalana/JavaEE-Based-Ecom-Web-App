<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>JSP - Hello World</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">

    <style>
        section {
            position: absolute;
            width: 100vw;
            height: 100vh;
        }

        section>#div1 {
            position: relative;
            top: 15%;
            left: 0;
            right: 0;
            margin: auto;
        }
    </style>
</head>
<body>

<section>
    <div class="card mb-3 shadow p-3 mb-5 bg-body-tertiary rounded " id="div1" style=" width: 800px; height: 630px; ">
        <div id="carouselExampleRide" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active ">
                    <img src="resources/images/ecom3.jpeg" class="d-block w-100 " alt="img3" style="width: 600px; height: 450px;">
                    <div class="carousel-caption d-none d-md-block">
                        <h3 style=" position:absolute; left: 0; right: 0; top: 20px; margin: auto;">Product Browsing</h3>
                    </div>
                </div>
                <div class="carousel-item">
                    <img src="resources/images/ecom1.jpg" class="d-block w-100" alt="img1" style="width: 600px; height: 450px;">
                    <div class="carousel-caption d-none d-md-block">
                        <h3 style=" position:absolute; left: 0; right: 0; top: 20px; margin: auto;">Cart Management</h3>

                    </div>
                </div>
                <div class="carousel-item">
                    <img src="resources/images/ecom2.png" class="d-block w-100" alt="img2" style="width: 600px; height: 450px;">
                    <div class="carousel-caption d-none d-md-block">
                        <h3 style=" position:absolute; left: 0; right: 0; top: 20px; margin: auto;">Order Placements</h3>
                    </div>
                </div>
            </div>

            <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleRide" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleRide" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>

        </div>
        <div class="card text-center">
            <div class="card-body">
                <h5 class="card-title">Welcome to e-Commerce</h5>
                <p class="card-text">JavaEE based E~Commerce Web Application</p>
                <a href="2.User's-Role.jsp" class="btn btn-primary">Start</a>
            </div>
        </div>
    </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

</body>
</html>
