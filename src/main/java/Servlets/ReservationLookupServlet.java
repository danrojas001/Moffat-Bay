package Servlets;

import Database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/reservation_lookup")
public class ReservationLookupServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchType = request.getParameter("searchType");
        String searchValue = request.getParameter("searchValue");

        List<Map<String, Object>> reservations = new ArrayList<>();

        // Only query the database if search parameters were submitted
        if (searchType != null && searchValue != null && !searchValue.trim().isEmpty()) {
            DBConnection db = new DBConnection();
            
            // Join reservations with customers, boats, and slips to match the JSP table columns
            StringBuilder query = new StringBuilder(
                "SELECT r.reservation_id, b.boat_name, s.slip_number, r.check_in_date, r.check_out_date " +
                "FROM reservations r " +
                "JOIN customers c ON r.customer_id = c.customer_id " +
                "JOIN boats b ON r.boat_id = b.boat_id " +
                "JOIN slips s ON r.slip_id = s.slip_id "
            );

            if ("reservationId".equals(searchType)) {
                query.append("WHERE r.reservation_id = ?");
            } else {
                query.append("WHERE c.email = ?");
            }

            try (Connection conn = db.getConnection();
                 PreparedStatement ps = conn.prepareStatement(query.toString())) {
                
                if ("reservationId".equals(searchType)) {
                    ps.setInt(1, Integer.parseInt(searchValue.trim()));
                } else {
                    ps.setString(1, searchValue.trim());
                }

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> res = new HashMap<>();
                        res.put("reservation_id", rs.getInt("reservation_id"));
                        res.put("boat_name", rs.getString("boat_name"));
                        res.put("slip_number", rs.getString("slip_number"));
                        res.put("check_in_date", rs.getDate("check_in_date"));
                        res.put("check_out_date", rs.getDate("check_out_date"));
                        reservations.add(res);
                    }
                }
            } catch (SQLException | NumberFormatException e) {
                // Log exception if needed, or leave reservations list empty to display "no results"
                e.printStackTrace();
            }
        }

        request.setAttribute("reservations", reservations);
        request.getRequestDispatcher("reservation_lookup.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}