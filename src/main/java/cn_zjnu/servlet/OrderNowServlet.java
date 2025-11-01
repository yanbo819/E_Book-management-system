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

@WebServlet("/OrderNowServlet")
public class OrderNowServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(OrderNowServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();

        User auth = (User) request.getSession().getAttribute("auth");

        if (auth != null) {
            String productIdParam = request.getParameter("id");
            String productQuantityParam = request.getParameter("quantity");

            if (productIdParam == null || productIdParam.isEmpty() || productQuantityParam == null || productQuantityParam.isEmpty()) {
                LOGGER.log(Level.WARNING, "Missing product ID or quantity for order-now request.");
                response.sendRedirect("error.jsp");
                return;
            }

            try {
                int productId = Integer.parseInt(productIdParam);
                int productQuantity = Integer.parseInt(productQuantityParam);

                if (productQuantity <= 0) {
                    productQuantity = 1;
                    LOGGER.log(Level.INFO, "Invalid quantity provided, defaulting to 1 for product ID: {0}", productId);
                }

                Order orderModel = new Order();
                orderModel.setId(productId);
                orderModel.setUid(auth.getId());
                orderModel.setQuantity(productQuantity);
                orderModel.setDate(formatter.format(date));

                OrderDao orderDao = new OrderDao(DbCon.getConnection());
                boolean result = orderDao.insertOrder(orderModel);

                if (result) {
                    
                    @SuppressWarnings("unchecked")
                    ArrayList<Cart> cart_list = (ArrayList<Cart>) request.getSession().getAttribute("cart-list");
                    if (cart_list != null) {
                        cart_list.removeIf(c -> c.getId() == productId); 
                        request.getSession().setAttribute("cart-list", cart_list);
                    }
                    response.sendRedirect("orders.jsp?status=order_success");
                } else {
                    LOGGER.log(Level.WARNING, "Order failed for product ID: {0}, user ID: {1}", new Object[]{productId, auth.getId()});
                    response.sendRedirect("orders.jsp?status=order_failed");
                }
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid numeric input for product ID or quantity.", e);
                response.sendRedirect("error.jsp");
            } catch (ClassNotFoundException | SQLException e) {
                LOGGER.log(Level.SEVERE, "Database error during order processing for product ID: " + productIdParam + ", user ID: " + auth.getId(), e);
                response.sendRedirect("error.jsp");
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}