<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Moffat Bay Marina</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/landing.css">
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

<!-- Main Viewport Content -->
<main class="app-viewport">

    <!-- Hero Block -->
    <div class="hero-block">
        <span class="hero-badge">Harbor & Marina Services</span>
        <h1>Your Safe Haven on Moffat Bay</h1>
        <p>Secure premier slip accommodations with flexible date selection, 30 AMP electrical service, deep-water
            access, and gated dock security.</p>
    </div>

    <!-- Features Bar -->
    <div class="features-row">
        <div class="feature-box">
            <span>🛥️</span>
            <h3>Deep Water Slips</h3>
            <p>Up to 50+ ft LOA with generous fairway clearances.</p>
        </div>
        <div class="feature-box">
            <span>⚡</span>
            <h3>30 AMP Power</h3>
            <p>Dedicated dockside electrical hookups available.</p>
        </div>
        <div class="feature-box">
            <span>🛡️</span>
            <h3>Gated Access</h3>
            <p>Round-the-clock dock security & captain amenities.</p>
        </div>
    </div>

    <!-- Customer Testimonials Section -->
    <div class="testimonials-row">

        <div class="testimonial-card">
            <div>
                <div class="testimonial-stars">★★★★★</div>
                <p class="testimonial-quote">
                    "Smooth docking and top-tier facilities. Deep water made bringing in our 42' cruiser stress-free,
                    and the dockmasters took our lines the second we pulled in."
                </p>
            </div>
            <div class="testimonial-author">
                <span class="author-name">Brian Mitchell</span>
                <span class="author-vessel"> Circuit Breaker• 42ft Express</span>
            </div>
        </div>

        <div class="testimonial-card">
            <div>
                <div class="testimonial-stars">★★★★★</div>
                <p class="testimonial-quote">
                    "Moffat Bay is our favorite weekend harbor. Reliable power hookups, ultra-clean showers, and secure
                    gated access give us complete peace of mind."
                </p>
            </div>
            <div class="testimonial-author">
                <span class="author-name">Marcus Vance</span>
                <span class="author-vessel">Right on Time • 35ft Sailboat</span>
            </div>
        </div>

    </div>

    <!-- Call to Action -->
    <div class="cta-row">
        <a href="reserve_slip.jsp" class="btn-main-cta">Reserve Your Slip Online</a>
    </div>

    <!-- Footer -->
    <footer class="footer-compact">
        Moffat Bay Marina Reservation System | &copy; 2026 Moffat Bay Marina
    </footer>

</main>

</body>
</html>
