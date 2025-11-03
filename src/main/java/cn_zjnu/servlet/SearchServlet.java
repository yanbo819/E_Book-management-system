package cn_zjnu.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn_zjnu.conncation.DbCon;
import cn_zjnu.dao.BooksDao;
import cn_zjnu.model.Books;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(SearchServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    String searchQuery = request.getParameter("query");
    boolean exact = request.getParameter("exact") != null;
        
        try {
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                // Validate and sanitize search query
                String cleanQuery = searchQuery.trim();
                if (cleanQuery.length() > 100) {
                    cleanQuery = cleanQuery.substring(0, 100); // Limit query length
                }
                
        // Perform search (exact title match if requested)
        BooksDao bDao = new BooksDao(DbCon.getConnection());
        List<Books> searchResults = exact
            ? bDao.searchBooksByExactName(cleanQuery)
            : bDao.searchBooks(cleanQuery);
                
                // Store search results and query in session
                request.getSession().setAttribute("searchResults", searchResults);
                request.getSession().setAttribute("searchQuery", cleanQuery);
                request.getSession().setAttribute("searchResultCount", searchResults.size());
                
                // Redirect to search results page (context-path aware)
                response.sendRedirect(request.getContextPath() + "/index.jsp?search=true");
                
            } else {
                // Clear any existing search results and redirect to home
                request.getSession().removeAttribute("searchResults");
                request.getSession().removeAttribute("searchQuery");
                request.getSession().removeAttribute("searchResultCount");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
            
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database connection error during search", e);
            request.getSession().setAttribute("errorMessage", "Database connection error. Please try again.");
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=db");
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error during search: " + e.getMessage(), e);
            request.getSession().setAttribute("errorMessage", "Search error. Please try again.");
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=search");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}