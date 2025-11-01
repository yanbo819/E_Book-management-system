package cn_zjnu.servlet;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import cn_zjnu.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet; 
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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