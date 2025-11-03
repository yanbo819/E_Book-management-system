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
    <section id="register-page">
        <div class="form-container">
            <div class="form-header">
                <h2><fmt:message key="register.header"/></h2>
            </div>
            <div class="form-body">
                <% String message = (String) request.getAttribute("message");
                   String messageType = (String) request.getAttribute("messageType");
                   if (message != null && !message.isEmpty()) { %>
                    <div class="message <%= messageType %> mb-4"><%= message %></div>
                <% } %>
                <form action="<%= request.getContextPath() %>/RegisterServlet" method="post">
                    <div class="form-group">
                        <label for="register-name"><fmt:message key="register.fullName"/></label>
                        <input type="text" class="form-control" id="name" name="name" required placeholder="John Doe">
                    </div>
                    <div class="form-group">
                        <label for="register-email"><fmt:message key="register.email"/></label>
                        <input type="email" class="form-control" id="email" name="email" required placeholder="email@example.com">
                    </div>
                    <div class="form-group">
                        <label for="register-phone"><fmt:message key="register.phone"/></label>
                        <input type="tel" class="form-control" id="phone" name="phone" required placeholder="+86 123456789">
                    </div>
                    <div class="form-group">
                        <label for="register-password"><fmt:message key="register.password"/></label>
                        <input type="password" class="form-control" id="password" name="password" required placeholder="••••••••">
                    </div>
                    <button type="submit" class="btn btn-primary w-100 mt-3"><fmt:message key="register.submit"/></button>
                </form>
                <div class="login-link mt-4 text-center">
                    <p><fmt:message key="register.haveAccount"/> <a href="login.jsp"><fmt:message key="register.loginHere"/></a></p>
                </div>
            </div>
        </div>
    </section>
</div>

<jsp:include page="includes/footer.jsp"></jsp:include>

</fmt:bundle>