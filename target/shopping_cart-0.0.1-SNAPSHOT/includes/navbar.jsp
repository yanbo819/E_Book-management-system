<%@page import="cn_zjnu.model.User"%>
<%@page import="cn_zjnu.model.Cart"%>
<%@page import="java.util.*"%>
<%
    User auth = (User) request.getSession().getAttribute("auth");
    List<Cart> cart_list = (ArrayList<Cart>) session.getAttribute("cart-list");
    int cart_size = 0;
    if (cart_list != null) {
        // show total quantity across items instead of just unique item count
        for (Cart c : cart_list) {
            cart_size += c.getQuantity();
        }
    }
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="_lang" value="${empty sessionScope.lang ? 'en' : sessionScope.lang}" />
<fmt:setLocale value="${_lang}" scope="session"/>
<fmt:bundle basename="messages">
<nav class="navbar navbar-expand-lg navbar-light">
    <div class="container">
            <a class="navbar-brand" href="<%= request.getContextPath() %>/index.jsp"><i class="fas fa-book-open"></i><fmt:message key="app.title"/></a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <!-- Removed inline search; using a top-right Search button with modal -->
            <ul class="navbar-nav mb-2 mb-lg-0">
                <!-- Theme Toggle -->
                <li class="nav-item me-3">
                    <button class="theme-toggle" id="themeToggle">
                        <i class="fas fa-sun" id="themeIcon"></i>
                        <span id="themeText" data-light="<fmt:message key='theme.light'/>" data-dark="<fmt:message key='theme.dark'/>"><fmt:message key="theme.light"/></span>
                    </button>
                </li>
                <li class="nav-item">
                                        <a class="nav-link <%= "index.jsp".equals(request.getRequestURI().substring(request.getRequestURI().lastIndexOf('/') + 1)) ? "active" : "" %>" aria-current="page" href="<%= request.getContextPath() %>/index.jsp"><i class="fas fa-home me-1"></i><fmt:message key="nav.home"/></a>
                </li>
                <li class="nav-item">
                                        <a class="nav-link <%= "cart.jsp".equals(request.getRequestURI().substring(request.getRequestURI().lastIndexOf('/') + 1)) ? "active" : "" %>" href="<%= request.getContextPath() %>/cart.jsp"><i class="fas fa-shopping-cart me-1"></i><fmt:message key="nav.cart"/> <span class="badge bg-primary"><%= cart_size %></span></a>
                </li>
                <% if (auth != null) { %>
                    <li class="nav-item">
                                                <a class="nav-link <%= "orders.jsp".equals(request.getRequestURI().substring(request.getRequestURI().lastIndexOf('/') + 1)) ? "active" : "" %>" href="<%= request.getContextPath() %>/orders.jsp"><i class="fas fa-clipboard-list me-1"></i><fmt:message key="nav.orders"/></a>
                    </li>
                    <li class="nav-item">
                                                <a class="nav-link" href="<%= request.getContextPath() %>/LogoutServlet"><i class="fas fa-sign-out-alt me-1"></i><fmt:message key="nav.logout"/></a>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                                                <a class="nav-link <%= "login.jsp".equals(request.getRequestURI().substring(request.getRequestURI().lastIndexOf('/') + 1)) ? "active" : "" %>" href="<%= request.getContextPath() %>/login.jsp"><i class="fas fa-user-circle me-1"></i><fmt:message key="nav.login"/></a>
                    </li>
                <% } %>
                <!-- Top-right Search button -->
                <li class="nav-item ms-3">
                                        <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#searchModal">
                                                <i class="fas fa-search me-1"></i><fmt:message key="nav.search"/>
                    </button>
                </li>
                <!-- Language button opens modal -->
                <li class="nav-item ms-2">
                    <button class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#languageModal">
                        <i class="fas fa-globe me-1"></i><fmt:message key="nav.language"/>
                    </button>
                </li>
            </ul>
        </div>
    </div>
 </nav>

<!-- Search Modal (exact match by title) -->
<div class="modal fade" id="searchModal" tabindex="-1" aria-labelledby="searchModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
            <h5 class="modal-title" id="searchModalLabel"><i class="fas fa-search me-2"></i><fmt:message key="modal.search.title"/></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form action="<%= request.getContextPath() %>/SearchServlet" method="get">
        <div class="modal-body">
            <input type="hidden" name="exact" value="1" />
            <div class="mb-3">
                                <label for="searchQuery" class="form-label"><fmt:message key="modal.search.label"/></label>
                <input type="text" id="searchQuery" class="form-control" name="query" placeholder="<fmt:message key='modal.search.placeholder'/>" required>
                                <div class="form-text"><fmt:message key="modal.search.help"/></div>
            </div>
        </div>
        <div class="modal-footer">
                      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><fmt:message key="btn.close"/></button>
                      <button type="submit" class="btn btn-primary"><fmt:message key="btn.search"/></button>
        </div>
      </form>
    </div>
  </div>
</div>


    <!-- Language Modal -->
    <div class="modal fade" id="languageModal" tabindex="-1" aria-labelledby="languageModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="languageModalLabel"><i class="fas fa-globe me-2"></i><fmt:message key="modal.lang.title"/></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="<%= request.getContextPath() %>/LanguageServlet" method="get">
                    <div class="modal-body">
                        <p class="mb-2"><fmt:message key="modal.lang.choose"/></p>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="lang" id="lang-en" value="en" <c:if test="${_lang eq 'en'}">checked</c:if> >
                            <label class="form-check-label" for="lang-en">English</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="lang" id="lang-zh" value="zh" <c:if test="${_lang eq 'zh'}">checked</c:if> >
                            <label class="form-check-label" for="lang-zh">中文</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="lang" id="lang-ar" value="ar" <c:if test="${_lang eq 'ar'}">checked</c:if> >
                            <label class="form-check-label" for="lang-ar">العربية</label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><fmt:message key="btn.close"/></button>
                        <button type="submit" class="btn btn-primary"><fmt:message key="btn.save"/></button>
                    </div>
                </form>
            </div>
        </div>
        </div>

    </fmt:bundle>