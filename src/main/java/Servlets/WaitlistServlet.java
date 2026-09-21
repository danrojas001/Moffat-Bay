package Servlets;

import Database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Logger;

@WebServlet("/waitlist")
public class WaitlistServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(WaitlistServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||  session.getAttribute("customerId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Integer customerId = (Integer)session.getAttribute("customerId");
        String boatIdString = request.getParameter("boatId");
        String slipTypeIdString = request.getParameter("slipTypeId");

        if (boatIdString == null || slipTypeIdString == null) {
            request.setAttribute("errorField", "waitlist");
            request.setAttribute("errorMessage", "Unable to add you to waitlist.");
            request.getRequestDispatcher("reserve.jsp").forward(request, response);
            return;
        }

        int boatId;
        int slipTypeId;

        try {
            boatId = Integer.parseInt(boatIdString);
            slipTypeId = Integer.parseInt(slipTypeIdString);
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid boat ID or slip type ID submitted for waitlist.");
            request.setAttribute("errorField", "waitlist");
            request.setAttribute("errorMessage", "Invalid boatId and/or slipTypeId.");
            request.getRequestDispatcher("reserve.jsp").forward(request, response);
            return;
        }

        DBConnection db = new DBConnection();

        try (Connection conn = db.getConnection()) {

            String waitlistSql = "INSERT INTO wait_list(customer_id, boat_id, slip_type_id) VALUES (?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(waitlistSql)) {
                ps.setInt(1, customerId);
                ps.setInt(2, boatId);
                ps.setInt(3, slipTypeId);
                ps.executeUpdate();
                response.sendRedirect("waitlist_lookup.jsp");
            }

        } catch (SQLException e) {
            LOGGER.severe("Database error while adding customer to waitlist: " + e.getMessage());
            request.setAttribute("errorField", "waitlist");
            request.setAttribute("errorMessage", "Unable to add you to the waitlist at this time. Please try again later.");
        }

        request.getRequestDispatcher("reserve.jsp").forward(request, response);
    }
}
