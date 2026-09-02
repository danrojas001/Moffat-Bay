// Dan Rojas
// Mod 9.2
// 26-Jul-26

package Database;

import java.sql.*;

public class DBConnection implements java.io.Serializable {

    private Connection conn;

    /*
    **********
    CONNECT TO THE DATABASE
    **********
     */
    public DBConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/moffat_db";
            String user = "moffat_user";
            String password = "pass";
            conn = DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            System.out.println("Error connecting to database in constructor.");
            e.printStackTrace();
        }
    }

    /*
    **********
    RETURN CURRENT CONNECTION TO THE DB
    **********
     */
    public Connection getConnection() {
        return conn;
    }

    /*
    **********
    CLOSE CONNECTION TO DATABASE
    **********
     */
    public void closeConnection() {
        try {
            if (conn != null) {
                conn.close();
                System.out.println("Database connections closed");
            }
        } catch (SQLException e) {
            System.out.println("Error closing connection to database.");
            e.printStackTrace();
        }
    }

}
