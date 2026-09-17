<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    boolean loggedIn = session != null && session.getAttribute("customerId") != null;
    boolean searchSubmitted = request.getParameter("searchType") != null;
    List<Map<String, Object>> reservations = (List<Map<String, Object>>) request.getAttribute("reservations");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Moffat Bay Marina - Reservation Look Up</title>
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
            <h1>Reservation Lookup</h1>
            <p>Search for your current reservations by email or Reservation ID</p>
        </div>

        <div class="content">
            <form action="reservation_lookup" method="GET">

                <!-- Lookup input -->
                <h2 class="section-title">Criteria Select </h2>
                <div class="grid">
                    <div class="group full-width">
                        <label for="searchType">Search By:</label>
                        <select id="searchType" name="searchType">
                            <option value="email">Email</option>
                            <option value="reservationId">Reservation ID</option>
                        </select>
                        <span class="field-hint">Choose to search by Email or Reservation ID.</span>
                    </div>

                    <div class="group full-width">
                        <label for="searchValue" id="searchValueLabel">Email:</label>
                        <input
                                type="email"
                                id="searchValue"
                                name="searchValue"
                                placeholder="Enter your email"
                                required/>
                    </div>
                </div>

                <div class="actions">
                    <button type="submit" class="btn btn-submit">Search Reservations</button>
                </div>

            </form>
        </div>
    </div>
    <br>

    <% if (searchSubmitted) { %>
    <div class="card">
        <div class="card-header">
            <h1>Current Reservations</h1>
            <p>Your current reservation details:</p>
        </div>

        <div class="content">
            <% if (reservations == null || reservations.isEmpty()) { %>
            <div class="no-reservations">
                <h2>No reservations found</h2>
                <p>
                    We couldn't find any reservations matching your search.
                    Please check your information and try again.
                </p>
            </div>
            <% } else { %>
            <div class="table-container">
                <table class="reservation-table">
                    <thead>
                    <tr>
                        <th>Reservation ID</th>
                        <th>Boat Name</th>
                        <th>Slip Number</th>
                        <th>Check-In Date</th>
                        <th>Check-Out Date</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Map<String, Object> reservation : reservations) { %>
                    <tr>
                        <td><%= reservation.get("reservation_id") %></td>
                        <td><%= reservation.get("boat_name") %></td>
                        <td><%= reservation.get("slip_number") %></td>
                        <td><%= reservation.get("check_in_date") %></td>
                        <td><%= reservation.get("check_out_date") %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
    <% } %>

</main>

<script>
    const searchType = document.getElementById("searchType");
    const searchValue = document.getElementById("searchValue");
    const searchValueLabel = document.getElementById("searchValueLabel");

    searchType.addEventListener("change", function () {

        if (this.value === "email") {
            searchValueLabel.textContent = "Email:";
            searchValue.placeholder = "Enter your email";
            searchValue.type = "email";
        } else {
            searchValueLabel.textContent = "Reservation ID:";
            searchValue.placeholder = "Enter reservation ID";
            searchValue.type = "text";
        }
    });
</script>

</body>
</html>