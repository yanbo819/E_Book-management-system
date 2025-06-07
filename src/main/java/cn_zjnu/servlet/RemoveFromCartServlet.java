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

@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(RemoveFromCartServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                @SuppressWarnings("unchecked")
                ArrayList<Cart> cart_list = (ArrayList<Cart>) request.getSession().getAttribute("cart-list");

                if (cart_list != null) {
                  
                    boolean removed = cart_list.removeIf(c -> c.getId() == id); 
                    if (removed) {
                        LOGGER.log(Level.INFO, "Removed item ID: {0} from cart.", id);
                    } else {
                        LOGGER.log(Level.WARNING, "Attempted to remove non-existent item ID: {0} from cart.", id);
                    }
                } else {
                    LOGGER.log(Level.INFO, "Attempted to remove item from a null cart list.");
                }
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid product ID for remove-from-cart: " + idParam, e);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Unexpected error in RemoveFromCartServlet", e);
            }
        } else {
            LOGGER.log(Level.WARNING, "Missing product ID for remove-from-cart request.");
        }
        response.sendRedirect("cart.jsp"); 
    }
}