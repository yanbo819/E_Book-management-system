package cn_zjnu.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

import cn_zjnu.model.Cart;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/QuantityIncDecServlet")
public class QuantityIncDecServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(QuantityIncDecServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if (action == null || idParam == null || idParam.isEmpty()) {
            LOGGER.log(Level.WARNING, "Missing action or ID parameter for quantity adjustment.");
            response.sendRedirect("cart.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            @SuppressWarnings("unchecked")
            ArrayList<Cart> cart_list = (ArrayList<Cart>) request.getSession().getAttribute("cart-list");

            if (cart_list != null) {
                for (Cart c : cart_list) {
                    if (c.getId() == id) {
                        if (action.equals("inc")) {
                            int quantity = c.getQuantity();
                            quantity++;
                            c.setQuantity(quantity);
                            LOGGER.log(Level.INFO, "Increased quantity for cart item ID: {0}", id);
                        } else if (action.equals("dec")) {
                            int quantity = c.getQuantity();
                            if (quantity > 1) { 
                                quantity--;
                                c.setQuantity(quantity);
                                LOGGER.log(Level.INFO, "Decreased quantity for cart item ID: {0}", id);
                            }
                        }
                        break; 
                    }
                }
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid product ID for quantity adjustment: " + idParam, e);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in QuantityIncDecServlet", e);
        }
        response.sendRedirect("cart.jsp");
    }
}