package cn_zjnu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import cn_zjnu.model.User;

public class UserDao {
    private static final Logger LOGGER = Logger.getLogger(UserDao.class.getName());
    private final Connection con;

    public UserDao(Connection con) {
        this.con = con;
    }

    public User userLogin(String email, String password) {
        User user = null;
        String query = "select * from users where email=? and password=?";
        try (PreparedStatement pst = this.con.prepareStatement(query)) { // Use try-with-resources
            pst.setString(1, email);
            pst.setString(2, password);
            try (ResultSet rs = pst.executeQuery()) { // Use try-with-resources for ResultSet
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setPhone(rs.getString("phone"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error during user login for email: " + email + ": " + e.getMessage(), e);
        }
        return user;
    }

    public boolean userRegister(User user) {
        boolean result = false;
        String query = "INSERT INTO users (name, email, phone, password) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pst = this.con.prepareStatement(query)) { // Use try-with-resources
            pst.setString(1, user.getName());
            pst.setString(2, user.getEmail());
            pst.setString(3, user.getPhone());
            pst.setString(4, user.getPassword());
            int rowsAffected = pst.executeUpdate();
            if (rowsAffected > 0) {
                result = true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Registration error for email: " + user.getEmail() + ": " + e.getMessage(), e);
        }
        return result;
    }
}