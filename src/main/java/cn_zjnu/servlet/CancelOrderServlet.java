package cn_zjnu.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import cn_zjnu.conncation.DbCon;
import cn_zjnu.dao.OrderDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CancelOrderServlet")
public class CancelOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(CancelOrderServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Actions that modify data (like cancelling an order) should ideally be POST requests.
        // For simplicity in this example, we'll continue with GET, but note the best practice.
        response.setContentType("text/html;charset=UTF-8");
        String orderIdParam = request.getParameter("id");
        if (orderIdParam != null && !orderIdParam.isEmpty()) { // Check for null and empty string
            try {
                int orderId = Integer.parseInt(orderIdParam);
                OrderDao orderDao = new OrderDao(DbCon.getConnection());
                boolean cancelled = orderDao.cancelOrder(orderId);
                if (cancelled) {
                    response.sendRedirect("orders.jsp?status=cancelled");
                } else {
                    response.sendRedirect("orders.jsp?status=cancel_failed");
                }
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid order ID for cancellation: " + orderIdParam, e);
                response.sendRedirect("error.jsp");
            } catch (ClassNotFoundException | SQLException e) {
                LOGGER.log(Level.SEVERE, "Error cancelling order (ID: " + orderIdParam + ")", e);
                response.sendRedirect("error.jsp");
            }
        } else {
            response.sendRedirect("orders.jsp?status=no_id"); // Redirect if no ID provided
        }
    }
}