package Servlets;

import Database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RegistrationServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Collect information
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String telephone = request.getParameter("telephone");
        String boatName = request.getParameter("boatName");
        String boatLength = request.getParameter("boatLength");

        String validationError = validateUserInfo(email, password, firstName, lastName, telephone, boatName, boatLength);

        if (validationError != null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, validationError);
            return;
        }

        // Hash password
        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt(12));


        String customerSql = "INSERT INTO customers (email, password_hash, first_name, last_name, telephone) VALUES " +
                "(?, ?, ?, ?, ?)";

        String boatSql = "INSERT INTO boats (customer_id, boat_name, boat_length) VALUES (?, ?, ?)";

        DBConnection db = new DBConnection();

        // Connect to DB, create/fill/execute prepared statements
        try (Connection conn = db.getConnection()) {

            conn.setAutoCommit(false);

            int customerId;

            try (PreparedStatement ps = conn.prepareStatement(customerSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, email);
                ps.setString(2, passwordHash);
                ps.setString(3, firstName);
                ps.setString(4, lastName);
                ps.setString(5, telephone);

                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) {
                        throw new SQLException("Couldn't retrieve the generated key");
                    }
                    customerId = rs.getInt(1);
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(boatSql)) {
                ps.setInt(1, customerId);
                ps.setString(2, boatName);
                ps.setString(3, boatLength);

                ps.executeUpdate();
            }
            conn.commit();
            response.sendRedirect("login.jsp");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Registration Failed");
        }
    }

    private String validateUserInfo(String email, String password, String firstName, String lastName,
                                    String telephone, String boatName, String boatLength) {
        // Validate email
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        if (email == null || !email.matches(emailRegex)) {
            return "Please enter a valid email address.";
        }

        // Validate password
        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z]).{8,}$";
        if (password == null || !password.matches(passwordRegex)) {
            return "Password must be at least 8 characters and contain 1 uppercase and 1 lowercase letter.";
        }

        // Validate first name
        if (firstName == null || firstName.isBlank()) {
            return "First name is required.";
        }

        // Validate last name
        if (lastName == null || lastName.isBlank()) {
            return "Last name is required.";
        }

        // Validate phone number
        if (telephone == null || telephone.isBlank()) {
            return "telephone is required.";
        }

        // Validate boat name
        if (boatName == null || boatName.isBlank()) {
            return "Boat name is required.";
        }

        // Validate boat length
        if (boatLength == null || boatLength.isBlank()) {
            return "Boat length is required.";
        }
        return null;
    }
}
