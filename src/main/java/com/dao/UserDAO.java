package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.model.User;
import com.util.DBConnection;

public class UserDAO {

    // ================= REGISTER =================
    public static boolean registerUser(User user) {
        boolean status = false;

        String sql =
            "INSERT INTO users(name, email, password) VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // ================= LOGIN =================
    public static User getUserByEmail(String email) {
        User user = null;

        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User(
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("password")
                );

                
                user.setId(rs.getInt("id"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }
}