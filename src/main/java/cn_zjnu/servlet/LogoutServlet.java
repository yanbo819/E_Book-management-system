package cn_zjnu.servlet;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import cn_zjnu.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet; 
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); 
        if (session != null && session.getAttribute("auth") != null) {
            String userEmail = ((User) session.getAttribute("auth")).getEmail();
            session.removeAttribute("auth");
            session.invalidate(); 
            LOGGER.log(Level.INFO, "User logged out: {0}", userEmail);
        }
        response.sendRedirect("./");
    }
}