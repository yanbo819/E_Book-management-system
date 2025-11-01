package cn_zjnu.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import cn_zjnu.conncation.DbCon;
import cn_zjnu.dao.UserDao;
import cn_zjnu.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L; // Add serialVersionUID
    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        // Basic validation
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            LOGGER.log(Level.WARNING, "Registration attempt with missing fields.");
            return;
        }

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPassword(password); 

        try {
            UserDao udao = new UserDao(DbCon.getConnection());
            if (udao.userRegister(user)) {
                LOGGER.log(Level.INFO, "User registered successfully: {0}", user.getEmail());
                request.getSession().setAttribute("auth", user); 
                response.sendRedirect("./"); 
            } else {
                LOGGER.log(Level.WARNING, "User registration failed for email: {0}", user.getEmail());
                response.sendRedirect("register.jsp?error=1"); 
            }
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database driver not found during registration.", e);
            response.sendRedirect("register.jsp?error=db_error");
        } catch (SQLException e) {
          
            if (e.getSQLState().startsWith("23")) { 
                LOGGER.log(Level.WARNING, "Registration failed due to duplicate email: " + user.getEmail(), e);
                response.sendRedirect("register.jsp?error=email_exists");
            } else {
                LOGGER.log(Level.SEVERE, "SQL error during registration for email: " + user.getEmail(), e);
                response.sendRedirect("register.jsp?error=db_error");
            }
        } catch (IOException e) { 
            LOGGER.log(Level.SEVERE, "IO error during registration for email: " + user.getEmail(), e);
            response.sendRedirect("register.jsp?error=servlet_error");
        }
    }
}