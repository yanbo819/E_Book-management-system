package cn_zjnu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import cn_zjnu.model.Order;

public class OrderDao {
    private static final Logger LOGGER = Logger.getLogger(OrderDao.class.getName());
    private final Connection con;

    public OrderDao(Connection con) {
        this.con = con;
    }

    // This method inserts an order into the database
    public boolean insertOrder(Order model) {
        boolean result = false;
        String query = "insert into orders (p_id, u_id, o_quantity, o_date) values(?,?,?,?)";
        try (PreparedStatement pst = this.con.prepareStatement(query)) { // Use try-with-resources
            pst.setInt(1, model.getId());
            pst.setInt(2, model.getUid());
            pst.setInt(3, model.getQuantity());
            pst.setString(4, model.getDate());
            int rowsAffected = pst.executeUpdate();
            if (rowsAffected > 0) {
                result = true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting order: " + e.getMessage(), e);
        }
        return result;
    }

    public List<Order> getUserOrders(int userId) {
        List<Order> list = new ArrayList<>();
        String query = "select o.o_id, o.p_id, o.u_id, o.o_quantity, o.o_date, p.name, p.category, p.price " +
                "from orders o join products p on p.id = o.p_id " +
                "where o.u_id=? order by o.o_id desc";

        try (PreparedStatement pst = this.con.prepareStatement(query)) {
            pst.setInt(1, userId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("o_id"));
                    order.setId(rs.getInt("p_id"));
                    order.setUid(rs.getInt("u_id"));
                    order.setName(rs.getString("name"));
                    order.setCategory(rs.getString("category"));
                    order.setPrice(rs.getDouble("price"));
                    order.setQuantity(rs.getInt("o_quantity"));
                    order.setDate(rs.getString("o_date"));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching user orders", e);
        }
        return list;
    }

    // New method to cancel an order
    public boolean cancelOrder(int id) { // Changed return type to boolean to indicate success
        boolean result = false;
        String query = "delete from orders where o_id=?";
        try (PreparedStatement pst = this.con.prepareStatement(query)) { // Use try-with-resources
            pst.setInt(1, id);
            int rowsAffected = pst.executeUpdate();
            if (rowsAffected > 0) {
                result = true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error cancelling order (ID: " + id + "): " + e.getMessage(), e);
        }
        return result;
    }
}