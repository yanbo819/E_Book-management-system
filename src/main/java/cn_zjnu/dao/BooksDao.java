package cn_zjnu.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException; 
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level; 
import java.util.logging.Logger;

import cn_zjnu.model.Books;
import cn_zjnu.model.Cart;

public class BooksDao {
    private static final Logger LOGGER = Logger.getLogger(BooksDao.class.getName());
    private final Connection con;
    private String query;
    private PreparedStatement pst;
    private ResultSet rs;

    public BooksDao(Connection con) {
        this.con = con;
    }
    

    public List<Books> getAllBooks() { 
        List<Books> books = new ArrayList<>();
        try {
            query = "select * from products"; 
            pst = this.con.prepareStatement(query);
            rs = pst.executeQuery();
            while (rs.next()) {
                Books row = new Books();
                row.setId(rs.getInt("id"));
                row.setName(rs.getString("name"));
                row.setCategory(rs.getString("category"));
                row.setPrice(rs.getDouble("price"));
                row.setImage(rs.getString("image"));
                books.add(row);
            }
        } catch (SQLException e) { 
            LOGGER.log(Level.SEVERE, "Error fetching all books: " + e.getMessage(), e); 
        } finally {
            closeResources(pst, rs); 
        }
        return books;
    }

    public List<Cart> getCartBooks(ArrayList<Cart> cartList) { 
        List<Cart> books = new ArrayList<>();
        try {
            if (cartList != null && !cartList.isEmpty()) { 
                for (Cart item : cartList) {
                    query = "select * from products where id=?";
                    pst = this.con.prepareStatement(query);
                    pst.setInt(1, item.getId());
                    rs = pst.executeQuery();
                    while (rs.next()) {
                        Cart row = new Cart();
                        row.setId(rs.getInt("id"));
                        row.setName(rs.getString("name"));
                        row.setCategory(rs.getString("category"));
                        row.setPrice(rs.getDouble("price") * item.getQuantity());
                        row.setQuantity(item.getQuantity());
                        books.add(row);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching cart books: " + e.getMessage(), e);
        } finally {
            closeResources(pst, rs); 
        }
        return books;
    }

    public double getTotalCartPrice(ArrayList<Cart> cartList) {
        double sum = 0;
        try {
            if (cartList != null && !cartList.isEmpty()) { 
                for (Cart item : cartList) {
                    query = "select price from products where id=?"; 
                    pst = this.con.prepareStatement(query);
                    pst.setInt(1, item.getId());
                    rs = pst.executeQuery();
                    while (rs.next()) {
                        sum += rs.getDouble("price") * item.getQuantity();
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating total cart price: " + e.getMessage(), e);
        } finally {
            closeResources(pst, rs); 
        }
        return sum;
    }

    
    private void closeResources(PreparedStatement pst, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error closing JDBC resources: " + e.getMessage(), e);
        }
    }
}