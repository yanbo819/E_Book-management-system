<%@page import="cn_zjnu.model.User"%>
<%
    User auth = (User) request.getSession().getAttribute("auth");
    if (auth != null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="includes/head.jsp"></jsp:include>
<jsp:include page="includes/navbar.jsp"></jsp:include>

<fmt:bundle basename="messages">
<div class="container d-flex align-items-center justify-content-center">
    <section id="login-page">
        <div class="form-container">
            <div class="form-header">
                <h2><fmt:message key="login.header"/></h2>
            </div>
            <div class="form-body">
                <% String message = (String) request.getAttribute("message");
                   String messageType = (String) request.getAttribute("messageType");
                   if (message != null && !message.isEmpty()) { %>
                    <div class="message <%= messageType %> mb-4"><%= message %></div>
                <% } %>
                <form action="<%= request.getContextPath() %>/LoginServlet" method="post">
                    <div class="form-group">
                        <label for="login-email"><fmt:message key="login.email"/></label>
                        <input type="email" class="form-control" id="login-email" name="email" required placeholder="Email">
                    </div>
                    <div class="form-group">
                        <label for="login-password"><fmt:message key="login.password"/></label>
                        <input type="password" class="form-control" id="login-password" name="password" required placeholder="••••••••">
                    </div>
                    <button type="submit" class="btn btn-primary w-100 mt-3"><fmt:message key="login.submit"/></button>
                </form>
                <div class="register-link mt-4 text-center">
                    <p><fmt:message key="login.noAccount"/> <a href="register.jsp"><fmt:message key="login.createAccount"/></a></p>
                </div>
            </div>
        </div>
    </section>
</div>

<jsp:include page="includes/footer.jsp"></jsp:include>

</fmt:bundle>