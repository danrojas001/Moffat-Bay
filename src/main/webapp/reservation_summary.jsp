<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.time.LocalDate" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    boolean loggedIn = session != null && session.getAttribute("customerId") != null;
    String firstName = (String) request.getAttribute("firstName");
    String lastName = (String) request.getAttribute("lastName");
    String boatName = (String) request.getAttribute("boatName");
    BigDecimal boatLength = (BigDecimal) request.getAttribute("boatLength");
    String slipNumber = (String) request.getAttribute("slipNumber");
    LocalDate checkInDate = (LocalDate) request.getAttribute("checkInDate");
    LocalDate checkOutDate = (LocalDate) request.getAttribute("checkOutDate");
    BigDecimal monthlyCost = (BigDecimal) request.getAttribute("monthlyCost");
    Boolean shorePower = (Boolean) request.getAttribute("shorePower");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Moffat Bay Marina - Reservation Summary</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/reservation_summary.css">
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
                    <li><a href="reservation_summary">Reservation Summary</a></li>
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
            <h1>Reservation Summary</h1>
            <p>Please review your reservation details before confirming.</p>
        </div>

        <form action="${pageContext.request.contextPath}/reservation_summary" method="POST" class="content">

            <input type="hidden" name="boatId" value="<%= request.getAttribute("boatId") %>">
            <input type="hidden" name="slipId" value="<%= request.getAttribute("slipId") %>">

            <!-- Section 1: Reservation Information -->
            <h2 class="section-title">1. Customer & Vessel Information</h2>
            <div class="grid">
                <div class="group">
                    <label for="firstName">First Name</label>
                    <input
                            type="text"
                            id="firstName"
                            value="<%= firstName %>"
                            readonly/>
                </div>

                <div class="group">
                    <label for="lastName">Last Name</label>
                    <input
                            type="text"
                            id="lastName"
                            value="<%= lastName %>"
                            readonly/>
                </div>

                <div class="group">
                    <label for="boatName">Boat Name</label>
                    <input
                            type="text"
                            id="boatName"
                            value="<%= boatName %>"
                            readonly/>
                    <span class="field-hint">
                    Your registered boat.
                </span>
                </div>

                <div class="group">
                    <label for="boatLength">Boat Length</label>
                    <input
                            type="text"
                            id="boatLength"
                            value="<%= boatLength %> ft"
                            readonly/>
                    <span class="field-hint">
                    Youe registered boat's name.
                </span>
                </div>

                <div class="group">
                    <label for="checkInDate">Check-In Date</label>
                    <input
                            type="text"
                            id="checkInDate"
                            name="checkInDate"
                            value="<%= checkInDate %>"
                            readonly/>
                </div>

                <div class="group">
                    <label for="checkOutDate">Check-Out Date</label>
                    <input
                            type="text"
                            id="checkOutDate"
                            name="checkOutDate"
                            value="<%= checkOutDate %>"
                            readonly/>
                    <span class="field-hint">
                    Reservations are one month in length.
                </span>
                </div>

                <div class="group">
                    <label for="slipNumber">Assigned Slip</label>
                    <input
                            type="text"
                            id="slipNumber"
                            value="<%= slipNumber %>"
                            readonly/>
                </div>
            </div>

            <!-- Section 2: Cost Breakdown -->
            <h2 class="section-title">2. Cost Breakdown</h2>
            <div class="grid">
                <div class="group">
                    <label>Slip Cost</label>
                    <input
                            type="text"
                            value="<%= String.format("$%.2f",
                            boatLength.multiply(new BigDecimal("10.50"))) %>"
                            readonly/>
                </div>

                <div class="group">
                    <label>Shore Power</label>
                    <input
                            type="text"
                            value="<%= Boolean.TRUE.equals(shorePower) ? "$10.00" : "$0.00" %>"
                            readonly/>
                    <span class="field-hint">
                        <%= Boolean.TRUE.equals(shorePower)
                                ? "Shore power included"
                                : "Shore power not selected" %>
                    </span>
                    <input
                            type="hidden"
                            name="shorePower"
                            value="<%= Boolean.TRUE.equals(shorePower) %>">
                </div>


                <div class="group">
                    <label>Monthly Total</label>
                    <input
                            type="text"
                            value="<%= String.format("$%.2f", monthlyCost) %>"
                            readonly/>
                    <span class="field-hint">Slip cost + shore power</span>
                </div>
            </div>

            <!-- Form Buttons -->
            <div class="actions">
                <a href="reserve_slip" class="btn btn-edit">Edit Reservation</a>
                <button type="submit" class="btn btn-submit">Confirm Reservation</button>
            </div>
        </form>
    </div>
</main>
</body>
</html>