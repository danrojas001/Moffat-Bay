package Servlets;

import Database.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Logger;

@WebServlet("/waitlist_lookup")
public class WaitlistLookupServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(WaitlistLookupServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DBConnection db = new DBConnection();

        int smallCount = 0;
        int mediumCount = 0;
        int largeCount = 0;

        // Query to count waitlist entries grouped by slip_type_id
        String query = "SELECT slip_type_id, COUNT(*) AS wait_count FROM wait_list GROUP BY slip_type_id";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int slipTypeId = rs.getInt("slip_type_id");
                int count = rs.getInt("wait_count");

                switch (slipTypeId) {
                    case 1:
                        smallCount = count;
                        break;
                    case 2:
                        mediumCount = count;
                        break;
                    case 3:
                        largeCount = count;
                        break;
                }
            }

        } catch (SQLException e) {
            LOGGER.severe("Database error while fetching waitlist counts: " + e.getMessage());
            e.printStackTrace();
        }

        // Pass counts to the JSP
        request.setAttribute("smallWaitlistCount", smallCount);
        request.setAttribute("mediumWaitlistCount", mediumCount);
        request.setAttribute("largeWaitlistCount", largeCount);

        // Forward to the JSP view
        request.getRequestDispatcher("waitlist_lookup.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}