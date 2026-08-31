<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Moffat Bay Marina</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/register.css">
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

<!-- Main Registration Form Container -->
<main class="register-container">
    <div class="card">
        <div class="card-header">
            <h1>Create Your Account</h1>
            <p>Already registered with us? <a href="login.jsp">Sign in here</a></p>
        </div>

        <div class="form-body">
            <form action="#" method="POST">

                <!-- Section 1: Account Information -->
                <h2 class="form-section-title">1. Account Details</h2>
                <div class="form-grid">

                    <div class="form-group full-width">
                        <label for="email">Email Address (Username) <span class="required">*</span></label>
                        <input
                                type="email"
                                id="email"
                                name="email"
                                placeholder="john.doe@example.com"
                                required/>
                        <span class="field-hint">Your email address will serve as your unique account login username.</span>
                    </div>

                    <div class="form-group full-width">
                        <label for="password">Password <span class="required">*</span></label>
                        <input
                                type="password"
                                id="password"
                                name="password"
                                minlength="8"
                                pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}"
                                placeholder="••••••••••••"
                                required/>
                        <span class="field-hint">Must be at least 8 characters long and contain at least 1 uppercase and 1 lowercase letter.</span>
                    </div>

                    <div class="form-group">
                        <label for="firstName">First Name <span class="required">*</span></label>
                        <input
                                type="text"
                                id="firstName"
                                name="firstName"
                                placeholder="John"
                                required/>
                    </div>

                    <div class="form-group">
                        <label for="lastName">Last Name <span class="required">*</span></label>
                        <input
                                type="text"
                                id="lastName"
                                name="lastName"
                                placeholder="Doe"
                                required/>
                    </div>

                    <div class="form-group full-width">
                        <label for="telephone">Telephone Number <span class="required">*</span></label>
                        <input
                                type="tel"
                                id="telephone"
                                name="telephone"
                                placeholder="(777) 123-4567"
                                required/>
                    </div>

                </div>

                <!-- Section 2: Vessel Details -->
                <h2 class="form-section-title">2. Vessel Information</h2>
                <div class="form-grid">

                    <div class="form-group">
                        <label for="boatName">Boat Name <span class="required">*</span></label>
                        <input
                                type="text"
                                id="boatName"
                                name="boatName"
                                placeholder="Barracuda  II"
                                required/>
                    </div>

                    <div class="form-group">
                        <label for="boatLength">Boat Length (ft) <span class="required">*</span></label>
                        <input
                                type="number"
                                id="boatLength"
                                name="boatLength"
                                min="1"
                                max="200"
                                placeholder="36"
                                required/>
                        <span class="field-hint">Length overall (LOA) including platforms/bowsprits.</span>
                    </div>

                </div>

                <!-- Form Buttons -->
                <div class="form-actions">
                    <button type="submit" class="btn btn-submit">Register Account & Vessel</button>
                    <button type="reset" class="btn btn-reset">Clear Form</button>
                </div>

            </form>
        </div>
    </div>

</main>

</body>
</html>
