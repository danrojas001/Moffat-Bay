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

@WebServlet("/reservation_summary")
public class ReservationSummaryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();

        Integer customerId = (Integer) session.getAttribute("customerId");
        if (customerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.getRequestDispatcher("reservation_summary.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();

        Integer customerId = (Integer) session.getAttribute("customerId");
        if (customerId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String boatIdString = request.getParameter("boatId");
        String slipIdString = request.getParameter("slipId");
        String checkInDateString = request.getParameter("checkInDate");
        String checkOutDateString = request.getParameter("checkOutDate");
        String shorePowerString = request.getParameter("shorePower");

        int boatId = Integer.parseInt(boatIdString);
        int slipId = Integer.parseInt(slipIdString);
        LocalDate checkInDate = LocalDate.parse(checkInDateString);
        LocalDate checkOutDate = LocalDate.parse(checkOutDateString);
        boolean shorePower = "true".equals(shorePowerString);

        DBConnection db = new DBConnection();

        try (Connection conn = db.getConnection()) {

            String boatSql = "SELECT boat_length FROM boats WHERE boat_id = ? AND customer_id = ?";

            BigDecimal boatLength;

            try (PreparedStatement ps = conn.prepareStatement(boatSql)) {
                ps.setInt(1, boatId);
                ps.setInt(2, customerId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        session.setAttribute("errorField", "boat");
                        session.setAttribute("errorMessage", "Could not verify your boat. Please try again.");
                        response.sendRedirect("reserve_slip");
                        return;
                    }
                    boatLength = rs.getBigDecimal("boat_length");
                }
            }

            BigDecimal monthlyCost = calculateMonthlyCost(boatLength, shorePower);

            String reservationsSql = "INSERT INTO reservations(customer_id, boat_id, slip_id, check_in_date, " +
                    "check_out_date, shore_power, monthly_cost) VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(reservationsSql)) {
                ps.setInt(1, customerId);
                ps.setInt(2, boatId);
                ps.setInt(3, slipId);
                ps.setDate(4, Date.valueOf(checkInDate));
                ps.setDate(5, Date.valueOf(checkOutDate));
                ps.setBoolean(6, shorePower);
                ps.setBigDecimal(7, monthlyCost);

                ps.executeUpdate();

                session.setAttribute(
                        "successMessage",
                        "Your reservation has been successfully confirmed!"
                );

                response.sendRedirect("index.jsp");

            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
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
