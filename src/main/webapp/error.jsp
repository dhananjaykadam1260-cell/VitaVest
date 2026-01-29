<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error Page</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
        }
        .error-container {
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            flex-direction: column;
            padding: 20px;
        }
        .error-code {
            font-size: 8rem;
            font-weight: bold;
            color: #dc3545;
        }
        .error-message {
            font-size: 1.5rem;
            margin-bottom: 20px;
            color: #495057;
        }
        .error-description {
            font-size: 1rem;
            margin-bottom: 30px;
            color: #6c757d;
        }
        .btn-home {
            padding: 10px 25px;
            font-size: 1.1rem;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">500</div>
        <div class="error-message">Oops! Something went wrong.</div>
        <div class="error-description">The server encountered an unexpected condition that prevented it from fulfilling your request.</div>
        <a href="LandingPage.jsp" class="btn btn-danger btn-home">Go Back Home</a>
    </div>

    <!-- Bootstrap JS (optional for interactive components) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
