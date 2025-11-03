package cn_zjnu.servlet;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/LanguageServlet")
public class LanguageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Set<String> SUPPORTED = new HashSet<>(Arrays.asList("en", "zh", "ar"));

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String lang = request.getParameter("lang");
        if (lang == null || !SUPPORTED.contains(lang)) {
            lang = "en"; // default
        }
        request.getSession().setAttribute("lang", lang);

        // Redirect back to the same page if possible, else to home
        String referer = request.getHeader("Referer");
        String contextPath = request.getContextPath();
        String fallback = contextPath + "/index.jsp";

        if (referer != null) {
            try {
                URI ref = new URI(referer);
                String path = ref.getPath();
                // Only allow redirect within the same webapp context
                if (path != null && path.startsWith(contextPath)) {
                    String query = ref.getQuery();
                    String target = path + (query != null ? ("?" + query) : "");
                    response.sendRedirect(target);
                    return;
                }
            } catch (URISyntaxException ignored) {}
        }
        response.sendRedirect(fallback);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
