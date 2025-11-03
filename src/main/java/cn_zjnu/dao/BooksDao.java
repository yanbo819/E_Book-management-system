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
                        // Store unit price; compute line totals in the view to avoid confusion
                        row.setPrice(rs.getDouble("price"));
                        row.setImage(rs.getString("image"));
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

    public List<Books> searchBooks(String searchQuery) {
        List<Books> books = new ArrayList<>();
        try {
            // Fuzzy search but by name only to align with requirements
            query = "SELECT * FROM products WHERE name LIKE ? ORDER BY name";
            pst = this.con.prepareStatement(query);
            String searchPattern = "%" + searchQuery + "%";
            pst.setString(1, searchPattern);
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
            LOGGER.log(Level.SEVERE, "Error searching books: " + e.getMessage(), e);
        } finally {
            closeResources(pst, rs);
        }
        return books;
    }

    public List<Books> searchBooksByExactName(String name) {
        List<Books> books = new ArrayList<>();
        try {
            query = "SELECT * FROM products WHERE LOWER(name) = LOWER(?) ORDER BY name";
            pst = this.con.prepareStatement(query);
            pst.setString(1, name);
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
            LOGGER.log(Level.SEVERE, "Error searching books by exact name: " + e.getMessage(), e);
        } finally {
            closeResources(pst, rs);
        }
        return books;
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