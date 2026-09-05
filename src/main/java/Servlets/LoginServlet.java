/*
 * Johnathan Smith
 * September 4, 2026
 * Moffat Bay Marina - Login backend
 */

package Servlets;

import Database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private static final String LOGIN_PAGE = "/login.jsp";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email != null) {
            email = email.trim();
        }

        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            showLoginError(request, response, "Email address and password are required.");
            return;
        }

        String sql = "SELECT customer_id, password_hash FROM customers WHERE email = ?";
        DBConnection db = new DBConnection();

        try (Connection connection = db.getConnection()) {
            if (connection == null) {
                throw new SQLException("Database connection could not be established.");
            }

            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, email);

                try (ResultSet results = statement.executeQuery()) {
                    if (results.next()) {
                        String storedHash = results.getString("password_hash");

                        if (passwordMatches(password, storedHash)) {
                            HttpSession oldSession = request.getSession(false);
                            if (oldSession != null) {
                                oldSession.invalidate();
                            }

                            HttpSession session = request.getSession(true);
                            session.setAttribute("customerId", results.getInt("customer_id"));
                            session.setAttribute("customerEmail", email);
                            session.setMaxInactiveInterval(30 * 60);

                            response.sendRedirect(request.getContextPath() + "/index.jsp");
                            return;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Login database error", e);
            showLoginError(request, response,
                    "The login service is temporarily unavailable. Please try again.");
            return;
        }

        showLoginError(request, response,
                "Invalid email address or password. Please try again.");
    }

    private boolean passwordMatches(String password, String storedHash) {
        if (storedHash == null || storedHash.isBlank()) {
            return false;
        }

        // jBCrypt 0.4 expects the $2a$ prefix. Existing class-project test data
        // may contain compatible $2b$ or $2y$ bcrypt hashes, so normalize only
        // the prefix before verification.
        if (storedHash.startsWith("$2b$") || storedHash.startsWith("$2y$")) {
            storedHash = "$2a$" + storedHash.substring(4);
        }

        try {
            return BCrypt.checkpw(password, storedHash);
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Stored password hash is not a valid bcrypt hash.");
            return false;
        }
    }

    private void showLoginError(HttpServletRequest request,
                                HttpServletResponse response,
                                String message)
            throws ServletException, IOException {
        request.setAttribute("loginError", message);
        request.getRequestDispatcher(LOGIN_PAGE).forward(request, response);
    }
}
