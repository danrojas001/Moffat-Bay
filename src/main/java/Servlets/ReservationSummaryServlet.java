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
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
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

        String firstNameString = request.getParameter("firstName");
        String lastNameString = request.getParameter("lastName");
        String boatIdString = request.getParameter("boatId");
        String slipIdString = request.getParameter("slipId");
        String checkInDateString = request.getParameter("checkInDate");
        String checkOutDateString = request.getParameter("checkOutDate");
        String shorePowerString = request.getParameter("shorePower");
        String monthlyCostString = request.getParameter("monthlyCost");


        int boatId = Integer.parseInt(boatIdString);
        int slipId = Integer.parseInt(slipIdString);
        LocalDate checkInDate = LocalDate.parse(checkInDateString);
        LocalDate checkOutDate = LocalDate.parse(checkOutDateString);
        boolean shorePower = "true".equals(shorePowerString);
        BigDecimal monthlyCost = new BigDecimal(monthlyCostString);

        DBConnection db = new DBConnection();

        try (Connection conn = db.getConnection()) {

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
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
