<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Moffat Bay Marina</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/login.css">
</head>

<body>
<!-- Navigation Header -->
<header class="navbar">
    <div class="nav-container">
        <a href="index.jsp" class="Title">
            Moffat Bay Marina
        </a>

        <ul class="nav-links">
            <li class="nav-item"><a href="index.jsp" class="nav-link">Home</a></li>
            <li class="nav-item"><a href="about.jsp" class="nav-link">About Us</a></li>
            <li class="nav-item"><a href="contact.jsp" class="nav-link">Contact Us</a></li>

            <li class="nav-item dropdown">
                <span class="nav-link">Reservations ▾</span>
                <ul class="dropdown-menu">
                    <li><a href="reserve_slip.jsp">Slip Reservation</a></li>
                    <li><a href="reservation_summary.jsp">Reservation Summary</a></li>
                    <li><a href="reservation_lookup.jsp">Reservation Look Up</a></li>
                    <li><a href="waitlist_lookup.jsp">Wait List Look Up</a></li>
                </ul>
            </li>
        </ul>

        <div class="nav-actions">
            <a href="register.jsp" class="btn-nav-outline">Register</a>
            <a href="login.jsp" class="btn-nav-solid">Log In</a>
        </div>
    </div>
</header>

<main class="login-container">
    <div class="card">

        <div class="card-header">
            <h1>Customer Login</h1>
            <p>Log in to your Moffat Bay Marina account</p>
        </div>
        <div class="form-body">
            <%-- Display login error if redirected back with an error --%>
            <% if (request.getParameter("error") != null) { %>
            <div class="error-message">
                Invalid email address or password. Please try again.
            </div>
            <% } %>
            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="form-group">
                    <label for="email">
                        Username (Email Address) <span class="required">*</span>
                    </label>
                    <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="john.doe@example.com"
                            autocomplete="email"
                            required>
                </div>
                <div class="form-group">
                    <label for="password">
                        Password <span class="required">*</span>
                    </label>
                    <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Enter your password"
                            autocomplete="current-password"
                            required>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-submit">
                        Log In
                    </button>
                </div>

            </form>

            <div class="register-prompt">
                Don't have an account?
                <a href="register.jsp">Register here</a>
            </div>

        </div>
    </div>

</main>

</body>
</html>