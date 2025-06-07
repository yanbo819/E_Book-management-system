package cn_zjnu.servlet;

import java.io.IOException;
import java.util.ArrayList; // Keep for now as the original uses it for direct output
import java.util.logging.Level;
import java.util.logging.Logger;

import cn_zjnu.model.Cart;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AddToCartServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            HttpSession session = request.getSession();
            @SuppressWarnings("unchecked")
            ArrayList<Cart> cart_list = (ArrayList<Cart>) session.getAttribute("cart-list");

            if (cart_list == null) {
                cart_list = new ArrayList<>();
                Cart cm = new Cart();
                cm.setId(id);
                cm.setQuantity(1);
                cart_list.add(cm);
                session.setAttribute("cart-list", cart_list);
            } else {
                boolean itemExists = false;

                for (Cart c : cart_list) {
                    if (c.getId() == id) {
                        c.setQuantity(c.getQuantity() + 1);
                        itemExists = true;
                        break;
                    }
                }

                if (!itemExists) {
                    Cart cm = new Cart();
                    cm.setId(id);
                    cm.setQuantity(1);
                    cart_list.add(cm);
                }

                session.setAttribute("cart-list", cart_list);
            }

            response.sendRedirect("./");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid product ID for add to cart: " + request.getParameter("id"), e);
            response.sendRedirect("error.jsp");
        }
    }
}