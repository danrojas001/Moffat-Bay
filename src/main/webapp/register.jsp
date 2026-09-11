<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    boolean loggedIn = session != null && session.getAttribute("customerId") != null;
    String errorField = (String) request.getAttribute("errorField");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Moffat Bay Marina - Register</title>
    <link rel="stylesheet" href="css/style.css">
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
                    <li><a href="reserve_slip">Slip Reservation</a></li>
                    <li><a href="reservation_lookup.jsp">Reservation Look Up</a></li>
                    <li><a href="waitlist_lookup.jsp">Wait List Look Up</a></li>
                </ul>
            </li>
        </ul>

        <div class="nav-actions">
            <% if (loggedIn) { %>
            <form action="${pageContext.request.contextPath}/logout" method="POST">
                <button type="submit" class="btn-nav-solid">Log Out</button>
            </form>
            <% } else { %>
            <a href="register.jsp" class="btn-nav-outline">Register</a>
            <a href="login.jsp" class="btn-nav-solid">Log In</a>
            <% } %>
        </div>
    </div>
</header>

<main class="large-container">
    <div class="card">
        <div class="card-header">
            <h1>Create Your Account</h1>
            <p>Already registered with us? <a href="login.jsp">Sign in here</a></p>
        </div>

        <div class="content">
            <form action="register" method="POST">

                <!-- Section 1: Account Information -->
                <h2 class="section-title">1. Account Details</h2>
                <div class="grid">

                    <div class="group full-width">
                        <label for="email">Email Address (Username) <span class="required">*</span></label>
                        <input
                                type="email"
                                id="email"
                                name="email"
                                placeholder="john.doe@example.com"
                                required/>
                        <%
                            if ("email".equals(errorField)) {
                        %>
                        <span class="field-error"><%= errorMessage %></span>
                        <%
                            }
                        %>
                        <span class="field-hint">Your email address will serve as your unique account login username.</span>
                    </div>

                    <div class="group full-width">
                        <label for="password">Password <span class="required">*</span></label>
                        <input
                                type="password"
                                id="password"
                                name="password"
                                minlength="8"
                                pattern="(?=.*[a-z])(?=.*[A-Z]).{8,}"
                                placeholder="••••••••••••"
                                required/>
                        <%
                            if ("password".equals(errorField)) {
                        %>
                        <span class="field-error"><%= errorMessage %></span>
                        <%
                            }
                        %>
                        <span class="field-hint">Must be at least 8 characters long and contain at least 1 uppercase and 1 lowercase letter.</span>
                    </div>

                    <div class="group">
                        <label for="firstName">First Name <span class="required">*</span></label>
                        <input
                                type="text"
                                id="firstName"
                                name="firstName"
                                placeholder="John"
                                required/>
                        <%
                            if ("firstName".equals(errorField)) {
                        %>
                        <span class="field-error"><%= errorMessage %></span>
                        <%
                            }
                        %>
                    </div>

                    <div class="group">
                        <label for="lastName">Last Name <span class="required">*</span></label>
                        <input
                                type="text"
                                id="lastName"
                                name="lastName"
                                placeholder="Doe"
                                required/>
                        <%
                            if ("lastName".equals(errorField)) {
                        %>
                        <span class="field-error"><%= errorMessage %></span>
                        <%
                            }
                        %>
                    </div>

                    <div class="group full-width">
                        <label for="telephone">Telephone Number <span class="required">*</span></label>
                        <input
                                type="tel"
                                id="telephone"
                                name="telephone"
                                placeholder="777-123-4567"
                                required/>
                        <%
                            if ("telephone".equals(errorField)) {
                        %>
                        <span class="field-error"><%= errorMessage %></span>
                        <%
                            }
                        %>
                    </div>

                </div>

                <!-- Section 2: Vessel Details -->
                <h2 class="section-title">2. Vessel Information</h2>
                <div class="grid">

                    <div class="group">
                        <label for="boatName">Boat Name <span class="required">*</span></label>
                        <input
                                type="text"
                                id="boatName"
                                name="boatName"
                                placeholder="Barracuda  II"
                                required/>
                        <%
                            if ("boatName".equals(errorField)) {
                        %>
                        <span class="field-error"><%= errorMessage %></span>
                        <%
                            }
                        %>
                    </div>

                    <div class="group">
                        <label for="boatLength">Boat Length (ft) <span class="required">*</span></label>
                        <input
                                type="number"
                                id="boatLength"
                                name="boatLength"
                                min="5"
                                max="50"
                                step="0.1"
                                placeholder="5 - 50"
                                required/>
                        <%
                            if ("boatLength".equals(errorField)) {
                        %>
                        <span class="field-error"><%= errorMessage %></span>
                        <%
                            }
                        %>
                        <span class="field-hint">Length overall (LOA) in feet including platforms/bowsprits.</span>
                    </div>
                </div>

                <!-- Form Buttons -->
                <div class="actions">
                    <button type="submit" class="btn btn-submit">Register Account & Vessel</button>
                    <button type="reset" class="btn btn-reset">Clear Form</button>
                </div>

            </form>
        </div>
    </div>

</main>

</body>
</html>
