<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    boolean loggedIn = session != null && session.getAttribute("customerId") != null;
    String errorField = (String) request.getAttribute("errorField");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String boatName = (String) request.getAttribute("boatName");
    BigDecimal boatLength = (BigDecimal) request.getAttribute("boatLength");
    Integer boatId = (Integer) request.getAttribute("boatId");
    Integer slipTypeId = (Integer) request.getAttribute("slipTypeId");
    boolean showWaitlist = Boolean.TRUE.equals(request.getAttribute("showWaitlist"));
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Moffat Bay Marina - Reserve Slip</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/reserve.css">
</head>

<body>
<!-- Navigation Header -->
<header class="navbar">
    <div class="nav-container">
        <a href="index.jsp" class="Title">Moffat Bay Marina</a>

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

<!-- Main Slip Reservation Form Container -->
<main class="large-container">
    <div class="card">
        <div class="card-header">
            <h1>Reserve a Marina Slip</h1>
            <p>Reserve a slip for your registered boat at Moffat Bay Marina.</p>
        </div>

        <div class="content">
            <form action="reserve" method="POST">
                <!-- Section 1: Vessel Information -->
                <h2 class="section-title">1. Vessel Information</h2>
                <div class="grid">
                    <div class="group">
                        <label for="boatName">Boat Name</label>
                        <input
                                type="text"
                                id="boatName"
                                value="<%= boatName %>"
                                readonly/>
                        <span class="field-hint">Your registered boat.</span>
                    </div>

                    <div class="group">
                        <label for="boatLength">Boat Length</label>
                        <input
                                type="text"
                                id="boatLength"
                                value="<%= boatLength %> ft"
                                readonly/>
                        <span class="field-hint">Your boat length determines the appropriate slip category.</span>
                    </div>
                </div>

                <!-- Section 2: Reservation Details -->
                <%
                    if (errorMessage != null && "availability".equals(errorField)) {
                %>
                <div class="field-error">
                    <%= errorMessage %>
                </div>
                <%
                    }
                %>

                <h2 class="section-title">2. Reservation Details</h2>
                <div class="grid">
                    <div class="group">
                        <label for="checkInDate">Check-In Date<span class="required">*</span>
                        </label>
                        <input
                                type="date"
                                id="checkInDate"
                                name="checkInDate"
                                min="<%= java.time.LocalDate.now() %>"
                                required/>
                        <%
                            if ("checkInDate".equals(errorField)) {
                        %>
                        <span class="field-error"><%= errorMessage %></span>
                        <%
                            }
                        %>
                        <span class="field-hint">Select the date you plan to arrive at the marina.</span>
                    </div>

                    <div class="group">
                        <label for="checkOutDate">Check-Out Date</label>
                        <input
                                type="text"
                                id="checkOutDate"
                                readonly/>
                        <span class="field-hint">Reservations are one month in length.</span>
                    </div>

                    <div class="group checkbox-group">
                        <label for="shorePower" class="checkbox-label">
                            <input
                                    type="checkbox"
                                    id="shorePower"
                                    name="shorePower"
                                    value="true"
                                    checked/>
                            <span>Include Shore Power</span>
                        </label>
                        <span class="field-hint">Add shore power to your reservation.</span>
                    </div>
                </div>

                <!-- Form Buttons -->
                <div class="actions">
                    <button type="submit" class="btn btn-submit">Check Availability & Reserve</button>
                </div>

            </form>
        </div>
    </div>

</main>

<% if (showWaitlist) { %>
<div id="waitlistModal" class="modal">
    <div class="modal-content">
        <h2>No Available Slips</h2>
        <p>
            We're sorry! There are no slips available which could accommodate your <strong><%= boatLength %>
            ft</strong> boat.
        </p>
        <p>Would you like to be added to our waitlist?</p>
        <div class="modal-actions">
            <form action="${pageContext.request.contextPath}/waitlist" method="POST">
                <input type="hidden" name="boatId" value="<%= boatId %>">
                <input type="hidden" name="slipTypeId" value="<%= slipTypeId %>">
                <button type="submit" class="btn btn-submit">Join Waitlist</button>
                <a href="${pageContext.request.contextPath}/reserve" class="btn btn-edit">No thanks</a>
            </form>
        </div>
    </div>
</div>
<% } %>

<script>
    document.getElementById("checkInDate").addEventListener("change", function () {

        if (this.value) {
            let checkInDate = new Date(this.value);

            checkInDate.setMonth(checkInDate.getMonth() + 1);

            let day = String(checkInDate.getDate()).padStart(2, "0");

            let monthNames = [
                "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
            ];

            let month = monthNames[checkInDate.getMonth()];
            let year = checkInDate.getFullYear();

            document.getElementById("checkOutDate").value =
                day + "-" + month + "-" + year;

        } else {
            document.getElementById("checkOutDate").value = "";
        }
    });
</script>
</body>
</html>