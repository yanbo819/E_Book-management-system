package cn_zjnu.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

import cn_zjnu.conncation.DbCon;
import cn_zjnu.dao.OrderDao;
import cn_zjnu.model.Cart;
import cn_zjnu.model.Order;
import cn_zjnu.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CheckOutServlet")
public class CheckOutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(CheckOutServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();

        @SuppressWarnings("unchecked")
        ArrayList<Cart> cart_list = (ArrayList<Cart>) request.getSession().getAttribute("cart-list");
        User auth = (User) request.getSession().getAttribute("auth");

        if (cart_list != null && auth != null && !cart_list.isEmpty()) { 
            try {
                OrderDao oDao = new OrderDao(DbCon.getConnection());
                boolean allOrdersInserted = true;
                for (Cart c : cart_list) {
                    Order order = new Order();
                    order.setId(c.getId());
                    order.setUid(auth.getId());
                    order.setQuantity(c.getQuantity());
                    order.setDate(formatter.format(date));

                    boolean result = oDao.insertOrder(order);
                    if (!result) {
                        allOrdersInserted = false;
                        LOGGER.log(Level.WARNING, "Failed to insert order for book ID: {0}, user ID: {1}", new Object[]{c.getId(), auth.getId()});
                        break; 
                    }
                }

                if (allOrdersInserted) {
                    cart_list.clear(); 
                    response.sendRedirect("orders.jsp?status=success");
                } else {
                    response.sendRedirect("orders.jsp?status=partial_failure"); 
                }

            } catch (ClassNotFoundException | SQLException e) {
                LOGGER.log(Level.SEVERE, "Database error during checkout for user " + auth.getId(), e);
                response.sendRedirect("error.jsp");
            }
        } else {
            if (auth == null) {
                response.sendRedirect("login.jsp");
            } else { 
                response.sendRedirect("cart.jsp?status=empty_cart");
            }
        }
    }
}