package Servlets;

import Database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {

    private static final Logger logger = Logger.getLogger(RegistrationServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        Collect information
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String telephone = request.getParameter("telephone");
        String boatName = request.getParameter("boatName");
        String BoatLength = request.getParameter("BoatLength");

//        Validate email and password formats
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        if (email == null || !email.matches(emailRegex)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Please enter a valid email address.");
            return;
        }

        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z]).{8,}$";
        if (password == null || !password.matches(passwordRegex)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,"Password must be at least 8 characters and contain" +
                    " 1 uppercase and 1 lowercase letter.");
            return;
        }

//        Hash password
        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt(12));

        String sql = "INSERT INTO users (email, password_hash, firstName, lastName, telephone, boatName, BoatLength) VALUES (?, ?," +
                " ?, ?, ?, ?, ?)";

        DBConnection db = new DBConnection();

//        Connect to DB, create/fill/execute prepared statement
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, passwordHash);
            ps.setString(3, firstName);
            ps.setString(4, lastName);
            ps.setString(5, telephone);
            ps.setString(6, boatName);
            ps.setString(7, BoatLength);

            ps.executeUpdate();

            response.sendRedirect("login.jsp");
        } catch (SQLException e) {
            logger.log(Level.SEVERE, e.getMessage(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Registration Failed");
        }
    }
}
