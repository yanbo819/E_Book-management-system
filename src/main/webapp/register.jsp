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
    <section id="register-page">
        <div class="form-container">
            <div class="form-header">
                <h2>Join E-Book Store</h2>
            </div>
            <div class="form-body">
                <% String message = (String) request.getAttribute("message");
                   String messageType = (String) request.getAttribute("messageType");
                   if (message != null && !message.isEmpty()) { %>
                    <div class="message <%= messageType %> mb-4"><%= message %></div>
                <% } %>
                <form action="RegisterServlet" method="post">
                    <div class="form-group">
                        <label for="register-name">Full Name</label>
                        <input type="text" class="form-control" id="name" name="name" required placeholder="Enter your full name">
                    </div>
                    <div class="form-group">
                        <label for="register-email">Email Address</label>
                        <input type="email" class="form-control" id="email" name="email" required placeholder="Enter your email">
                    </div>
                    <div class="form-group">
                        <label for="register-phone">Phone Number</label>
                        <input type="tel" class="form-control" id="phone" name="phone" required placeholder="Enter your phone number">
                    </div>
                    <div class="form-group">
                        <label for="register-password">Password</label>
                        <input type="password" class="form-control" id="password" name="password" required placeholder="Create a password">
                    </div>
                    <button type="submit" class="btn btn-primary w-100 mt-3">Register</button>
                </form>
                <div class="login-link mt-4 text-center">
                    <p>Already have an account? <a href="login.jsp">Login Here</a></p>
                </div>
            </div>
        </div>
    </section>
</div>

<jsp:include page="includes/footer.jsp"></jsp:include>