<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    boolean loggedIn = session != null && session.getAttribute("customerId") != null;
    Integer smallWaitlistCount = (Integer) request.getAttribute("smallWaitlistCount");
    Integer mediumWaitlistCount = (Integer) request.getAttribute("mediumWaitlistCount");
    Integer largeWaitlistCount = (Integer) request.getAttribute("largeWaitlistCount");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Moffat Bay Marina - Waitlist Look Up</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/reservation_lookup.css">
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
            <li class="nav-item dropdown">
                <span class="nav-link">Reservations ▾</span>
                <ul class="dropdown-menu">
                    <li><a href="reserve">Slip Reservation</a></li>
                    <li><a href="reservation_lookup">Reservation Look Up</a></li>
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
            <h1>Waitlist Queue</h1>
            <p>View the amount of customers currently in queue for each slip type.</p>
        </div>
        <div class="content">
            <div class="table-container">
                <table class="reservation-table">
                    <thead>
                    <tr>
                        <th>Slip Size Category</th>
                        <th>Customers Waiting</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>Small slip: Max 26ft</td>
                        <td><%= smallWaitlistCount != null ? smallWaitlistCount : 0 %></td>
                    </tr>
                    <tr>
                        <td>Medium Slip: Max 40ft</td>
                        <td><%= mediumWaitlistCount != null ? mediumWaitlistCount : 0 %></td>
                    </tr>
                    <tr>
                        <td>Large Slip: Max 50ft</td>
                        <td><%= largeWaitlistCount != null ? largeWaitlistCount : 0 %></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</main>

</body>
</html>