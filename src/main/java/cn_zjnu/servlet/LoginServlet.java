package cn_zjnu.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import cn_zjnu.conncation.DbCon;
import cn_zjnu.dao.UserDao;
import cn_zjnu.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; 

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.sendRedirect("login.jsp");
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		
		String email = request.getParameter("email");
		String password = request.getParameter("password");

		if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
			request.setAttribute("errorMessage", "Email and password cannot be empty.");
			request.getRequestDispatcher("login.jsp").forward(request, response);
			return;
		}

		try {
			UserDao udao = new UserDao(DbCon.getConnection());
			User user = udao.userLogin(email, password);

			if (user != null) {
				HttpSession session = request.getSession();
				session.setAttribute("auth", user);
				LOGGER.log(Level.INFO, "User logged in: {0}", user.getEmail());
				response.sendRedirect("./");
			} else {
				request.setAttribute("errorMessage", "Invalid email or password.");
				request.getRequestDispatcher("login.jsp").forward(request, response);
				LOGGER.log(Level.WARNING, "Login failed for email: {0}", email);
			}
		} catch (ClassNotFoundException | SQLException e) {
			LOGGER.log(Level.SEVERE, "Database or class not found error during login for email: " + email, e);
			response.sendRedirect("error.jsp");
		}
	}
}