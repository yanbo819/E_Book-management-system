<%@page import="cn_zjnu.model.User"%>
<%@page import="cn_zjnu.model.Cart"%>
<%@page import="java.util.*"%>
<%
    User auth = (User) request.getSession().getAttribute("auth");
    List<Cart> cart_list = (ArrayList<Cart>) session.getAttribute("cart-list");
    int cart_size = 0;
    if (cart_list != null) {
        cart_size = cart_list.size();
    }
%>
<nav class="navbar navbar-expand-lg navbar-light">
    <div class="container">
        <a class="navbar-brand" href="index.jsp"><i class="fas fa-book-open"></i>E-Book</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link <%= "index.jsp".equals(request.getRequestURI().substring(request.getRequestURI().lastIndexOf('/') + 1)) ? "active" : "" %>" aria-current="page" href="index.jsp"><i class="fas fa-home me-1"></i>Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= "cart.jsp".equals(request.getRequestURI().substring(request.getRequestURI().lastIndexOf('/') + 1)) ? "active" : "" %>" href="cart.jsp"><i class="fas fa-shopping-cart me-1"></i>Cart <span class="badge bg-primary"><%= cart_size %></span></a>
                </li>
                <% if (auth != null) { %>
                    <li class="nav-item">
                        <a class="nav-link <%= "orders.jsp".equals(request.getRequestURI().substring(request.getRequestURI().lastIndexOf('/') + 1)) ? "active" : "" %>" href="orders.jsp"><i class="fas fa-clipboard-list me-1"></i>Orders</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="LogoutServlet"><i class="fas fa-sign-out-alt me-1"></i>Logout</a>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="nav-link <%= "login.jsp".equals(request.getRequestURI().substring(request.getRequestURI().lastIndexOf('/') + 1)) ? "active" : "" %>" href="login.jsp"><i class="fas fa-user-circle me-1"></i>Login</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>