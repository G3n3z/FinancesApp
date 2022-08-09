package com.finances.backend.data.conection;

import java.sql.*;

public class ConnectionFactory {
    private static final String url = "jdbc:mysql://localhost:3306/finances?verifyServerCertificate=false&useSSL=true";

    public static Connection getConection() throws SQLException {
        return DriverManager.getConnection(url, "root", "12345678");
    }

    public static void closeConnectionAndStatement(AutoCloseable connection, AutoCloseable stm) {
        try {
            if (connection != null)
                connection.close();
            if(stm != null)
                stm.close();
        } catch (Exception ignored) {

        }
    }

    public static void closeStatement(Statement stm) {
        try {
            stm.close();
        } catch (SQLException ignored) {
        }
    }

    public static void commit(Connection con) {
        try {
            con.commit();
        } catch (SQLException ignored) {
        }
    }

    public static void rollback(Connection con) {
        try {
            con.rollback();
        } catch (SQLException ignored) {
        }
    }

    public static void closeConnection(Connection con) {
        try {
            con.close();
        } catch (SQLException ignored) {
        }
    }
}
