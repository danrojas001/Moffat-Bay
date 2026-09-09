<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    boolean loggedIn = session != null && session.getAttribute("customerId") != null;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Moffat Bay Marina - About Us</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/landing.css">
    <link rel="stylesheet" href="css/about.css">
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

<main class="viewport">
    <div class="hero-block">
        <h1>About Us</h1>
        <p class="about-intro">Welcome to Moffat Bay Marina, your premier destination for sage, scenic, and reliable
            docking. We're
            here
        to provide a comfortable, convenient place to keep your boat while you enjoy everything the bay has to offer
            .</p>
    </div>

    <div class="amenities-container">
        <div class="sub-header">
            <h1>Amenities</h1>
        </div>
        <div class="amenities-row">
            <div class="about-box">
                <span>💡</span>
                <h3>Well lit</h3>
                <p>Secure, modern docks with bright lighting for safe access day and night.</p>
            </div>
            <div class="about-box">
                <span>🛡️</span>
                <h3>Safety</h3>
                <p>24/7 on-site security and surveillance help keep your boat and belongings protected.</p>
            </div>
            <div class="about-box">
                <span>🚿</span>
                <h3>Facilities</h3>
                <p>Clean restrooms, private showers, and convenient laundry facilities are available.</p>
            </div>
            <div class="about-box">
                <span>⛽</span>
                <h3>Fuel</h3>
                <p>Convenient on-site fuel dock with a pump-out station for easy service.</p>
            </div>
        </div>
    </div>

    <!-- Customer Testimonials Section -->
    <div class="price-container">
        <div class="sub-header">
            <h1>Transparent Pricing</h1>
        </div>
        <div class="price-row">
            <div class="about-box">
                <span>💲</span>
                <h3>Rate</h3>
                <p>$10.50 per foot of vessel length (LOA) per month.</p>
            </div>
            <div class="about-box">
                <span>⚡</span>
                <h3>Shore Power</h3>
                <p>Flat $10 for shore power per month.</p>
            </div>
        </div>
    </div>

    <div class="alert-container">
        <div class="sub-header">
            <h1>Boat Length</h1>
        </div>
        <div class="alert-row">
                <p>Our marina accommodates boats up to <strong>50 feet</strong> in length.</p>
                <p>Please contact us if you have questions about size or availability.</p>
        </div>
    </div>

    <div class="contact-container">
        <div class="sub-header">
            <h1>Harbormaster info</h1>
        </div>
        <div class="contact-row">
            <div class="contact-item">
                <span>📍</span>
                <h3>Address</h3>
                <p>123 Marina Way, Moffat Bay</p>
            </div>
            <div class="contact-item">
                <span>📞</span>
                <h3>Phone</h3>
                <p>(555) 867-5309</p>
            </div>
            <div class="contact-item">
                <span>📻</span>
                <h3>VHF Channel</h3>
                <p>Channel 16 / Working Channel 72</p>
            </div>
        </div>
    </div>


    <!-- Footer -->
    <footer class="footer-compact">
        Moffat Bay Marina Reservation System | &copy; 2026 Moffat Bay Marina
    </footer>

</main>

</body>
</html>