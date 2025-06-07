<%@page import="cn_zjnu.model.Order"%>
<%@page import="cn_zjnu.model.User"%>
<%@page import="cn_zjnu.dao.OrderDao"%>
<%@page import="cn_zjnu.conncation.DbCon"%>
<%@page import="java.util.*"%>

<%
    User auth = (User) request.getSession().getAttribute("auth");
    List<Order> orders = null;
    if (auth != null) {
        OrderDao orderDao = new OrderDao(DbCon.getConnection());
        orders = orderDao.getUserOrders(auth.getId());
    } else {
        response.sendRedirect("login.jsp"); // Redirect if not logged in
        return;
    }
%>

<jsp:include page="includes/head.jsp"></jsp:include>
<jsp:include page="includes/navbar.jsp"></jsp:include>

<div class="container">
    <section id="orders-page" class="mb-5">
        <div class="page-header">
            <h2>Your Orders</h2>
            <p class="lead">Track your recent purchases and their status</p>
        </div>
        
        <% if (orders != null && !orders.isEmpty()) { %>
        <div class="table-container">
            <table class="table">
                <thead>
                    <tr>
                        <th scope="col">Order ID</th>
                        <th scope="col">Book Name</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Price</th>
                        <th scope="col">Order Date</th>
                        <th scope="col">Status</th>
                        <th scope="col">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Order o : orders) { %>
                    <tr>
                        <td>#<%= o.getOrderId() %></td>
                        <td><%= o.getName() %></td>
                        <td><%= o.getQuantity() %></td>
                        <td>$<%= String.format("%.2f", o.getPrice()) %></td>
                        <td><%= o.getDate() %></td>
                        <td>
                            <span class="badge <%= "Pending".equals(o.getStatus()) ? "bg-warning" : "bg-success" %>"><%= o.getStatus() %></span>
                        </td>
                        <td class="cart-table-actions">
                            <% if ("Pending".equals(o.getStatus())) { %>
                            <a class="btn btn-sm btn-danger" href="CancelOrderServlet?id=<%= o.getOrderId() %>">Cancel</a>
                            <% } else { %>
                            <button class="btn btn-sm btn-secondary" disabled>Delivered</button>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <div class="empty-state">
            <i class="fas fa-box-open"></i>
            <h3>No Orders Yet</h3>
            <p>It seems you haven't placed any orders. Start exploring our books now!</p>
            <a href="index.jsp" class="btn btn-primary mt-4">Browse Books</a>
        </div>
        <% } %>
    </section>
</div>

<jsp:include page="includes/footer.jsp"></jsp:include>