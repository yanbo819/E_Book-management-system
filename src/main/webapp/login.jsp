<%@page import="cn_zjnu.model.User"%>
<%
    User auth = (User) request.getSession().getAttribute("auth");
    if (auth != null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<jsp:include page="includes/head.jsp"></jsp:include>

<div class="container d-flex align-items-center justify-content-center">
    <section id="login-page">
        <div class="form-container">
            <div class="form-header">
                <h2>Welcome Back</h2>
            </div>
            <div class="form-body">
                <% String message = (String) request.getAttribute("message");
                   String messageType = (String) request.getAttribute("messageType");
                   if (message != null && !message.isEmpty()) { %>
                    <div class="message <%= messageType %> mb-4"><%= message %></div>
                <% } %>
                <form action="LoginServlet" method="post">
                    <div class="form-group">
                        <label for="login-email">Email Address</label>
                        <input type="email" class="form-control" id="login-email" name="email" required placeholder="Enter your email">
                    </div>
                    <div class="form-group">
                        <label for="login-password">Password</label>
                        <input type="password" class="form-control" id="login-password" name="password" required placeholder="Enter your password">
                    </div>
                    <button type="submit" class="btn btn-primary w-100 mt-3">Login</button>
                </form>
                <div class="register-link mt-4 text-center">
                    <p>Don't have an account? <a href="register.jsp">Create Account</a></p>
                </div>
            </div>
        </div>
    </section>
</div>

<jsp:include page="includes/footer.jsp"></jsp:include>