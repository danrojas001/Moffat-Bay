package Servlets;

import Database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.logging.Logger;

@WebServlet("/reserve_slip")
public class ReservationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ReservationServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();

        Integer customerId = (Integer)session.getAttribute("customerId");
        if (customerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String errorField = (String) session.getAttribute("errorField");
        String errorMessage = (String) session.getAttribute("errorMessage");
        session.removeAttribute("errorField");
        session.removeAttribute("errorMessage");
        request.setAttribute("errorField", errorField);
        request.setAttribute("errorMessage", errorMessage);

        DBConnection db = new DBConnection();

        try (Connection conn = db.getConnection()) {

            String boatSql = "SELECT boat_id, boat_name, boat_length FROM boats WHERE customer_id = ?";

            try (PreparedStatement ps = conn.prepareStatement(boatSql)) {
                ps.setInt(1, customerId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        request.setAttribute("errorMessage", "No boat associated with this account.");
                        request.getRequestDispatcher("reserve_slip.jsp").forward(request, response);
                        return;
                    }

                    int boatId = rs.getInt("boat_id");
                    String boatName = rs.getString("boat_name");
                    BigDecimal boatLength = rs.getBigDecimal("boat_length");

                    request.setAttribute("boatId", boatId);
                    request.setAttribute("boatName", boatName);
                    request.setAttribute("boatLength", boatLength);
                }

                request.getRequestDispatcher("reserve_slip.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error when retrieving boat information" + e.getMessage());
            throw new ServletException("Unable to retrieve boat information", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();

        Integer customerId = (Integer) session.getAttribute("customerId");
        if (customerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String checkInDateString = request.getParameter("checkInDate");
        boolean shorePower = "true".equals(request.getParameter("shorePower"));

        ValidationError validationError = validateCheckInDate(checkInDateString);
        if (validationError != null) {
            request.setAttribute("errorField", validationError.field());
            request.setAttribute("errorMessage", validationError.message());
            request.getRequestDispatcher("reserve_slip.jsp").forward(request, response);
            return;
        }

        LocalDate checkInDate = LocalDate.parse(checkInDateString);
        LocalDate checkOutDate = checkInDate.plusMonths(1);

        DBConnection db = new DBConnection();

        try (Connection conn = db.getConnection()) {

            String customerAndBoatSql = "SELECT c.first_name, c.last_name, b.boat_id, b.boat_name, b.boat_length FROM" +
                    " customers c JOIN boats b ON c.customer_id = b.customer_id WHERE c.customer_id = ?";

            String firstName;
            String lastName;
            int boatId;
            String boatName;
            BigDecimal boatLength;

            try (PreparedStatement ps = conn.prepareStatement(customerAndBoatSql)) {
                ps.setInt(1, customerId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        return;
                    }
                    firstName = rs.getString("first_name");
                    lastName = rs.getString("last_name");
                    boatId = rs.getInt("boat_id");
                    boatName = rs.getString("boat_name");
                    boatLength = rs.getBigDecimal("boat_length");
                }
            }

            String slipTypeSql = "SELECT slip_type_id FROM slip_types WHERE slip_length >= ? ORDER BY slip_length ASC" +
                    " LIMIT 1";

            int slipTypeId;

            try (PreparedStatement ps = conn.prepareStatement(slipTypeSql)) {
                ps.setBigDecimal(1, boatLength);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        return;
                    }
                    slipTypeId = rs.getInt("slip_type_id");
                }
            }

            String slipSql = "Select s.slip_id, s.slip_number FROM slips s WHERE s.slip_type_id = ? AND NOT EXISTS " +
                    "(SELECT 1 FROM reservations r WHERE r.slip_id = s.slip_id AND r.check_in_date < ? AND r" +
                    ".check_out_date > ?) ORDER BY s.slip_number LIMIT 1";

            int slipId;
            String slipNumber;

            try (PreparedStatement ps = conn.prepareStatement(slipSql)) {
                ps.setInt(1, slipTypeId);
                ps.setDate(2, Date.valueOf(checkOutDate));
                ps.setDate(3, Date.valueOf(checkInDate));

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        request.setAttribute("errorField", "availability");
                        request.setAttribute("errorMessage", "There are no slips available for your boat's size and " +
                                "your chosen dates.");
                        request.setAttribute("boatName", boatName);
                        request.setAttribute("boatLength", boatLength);
                        request.getRequestDispatcher("reserve_slip.jsp").forward(request, response);
                        return;
                    }
                    slipId = rs.getInt("slip_id");
                    slipNumber = rs.getString("slip_number");
                }
            }

            BigDecimal monthlyCost = calculateMonthlyCost(boatLength, shorePower);

            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("boatId", boatId);
            request.setAttribute("boatName", boatName);
            request.setAttribute("boatLength", boatLength);
            request.setAttribute("slipId", slipId);
            request.setAttribute("slipNumber", slipNumber);
            request.setAttribute("checkInDate", checkInDate);
            request.setAttribute("checkOutDate", checkOutDate);
            request.setAttribute("shorePower", shorePower);
            request.setAttribute("monthlyCost", monthlyCost);

            request.getRequestDispatcher("reservation_summary.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            LOGGER.severe("Database error while preparing reservation: " + e.getMessage());
            throw new ServletException("Unable to prepare reservations: ", e);
        }
    }

    /*
    record for storing validation error field and message used in method validateUserInfo.
     */
    private record ValidationError(String field, String message) {
    }

    /*
    Validates Check-in date
     */
    private ValidationError validateCheckInDate(String checkInDateString) {
        if (checkInDateString == null || checkInDateString.isBlank()) {
            return new ValidationError("checkInDate", "Please select a check-in date");
        }
        try {
            LocalDate checkInDate = LocalDate.parse(checkInDateString);
            if (checkInDate.isBefore(LocalDate.now())) {
                return new ValidationError("checkInDate", "Check-in date cannot be before current date");
            }
        } catch (DateTimeParseException e) {
            return new ValidationError("checkInDate", "Please select a valid check-in date");
        }
        return null;
    }

    /*
    Calculates monthly cost
     */
    private BigDecimal calculateMonthlyCost(BigDecimal boatLength, boolean shorePower) {
        BigDecimal cost = boatLength.multiply(BigDecimal.TEN);

        // 5% increase to slip cost
        cost = cost.multiply(new BigDecimal("1.05"));

        if (shorePower) {
            cost = cost.add(BigDecimal.TEN);
        }
        return cost;
    }
}
