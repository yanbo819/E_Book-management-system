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
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="includes/head.jsp"></jsp:include>
<jsp:include page="includes/navbar.jsp"></jsp:include>

<fmt:bundle basename="messages">
<div class="container">
    <section id="orders-page" class="mb-5">
        <div class="page-header">
            <h2><fmt:message key="orders.header"/></h2>
            <p class="lead"><fmt:message key="orders.sub"/></p>
        </div>
        
        <% if (orders != null && !orders.isEmpty()) { %>
        <div class="table-container">
            <table class="table">
                <thead>
                    <tr>
                        <th scope="col"><fmt:message key="orders.col.id"/></th>
                        <th scope="col"><fmt:message key="orders.col.name"/></th>
                        <th scope="col"><fmt:message key="orders.col.qty"/></th>
                        <th scope="col"><fmt:message key="orders.col.price"/></th>
                        <th scope="col"><fmt:message key="orders.col.date"/></th>
                        <th scope="col"><fmt:message key="orders.col.status"/></th>
                        <th scope="col"><fmt:message key="orders.col.actions"/></th>
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
                                                        <span class="badge <%= "Pending".equals(o.getStatus()) ? "bg-warning" : "bg-success" %>">
                                                            <% if ("Pending".equals(o.getStatus())) { %>
                                                                <fmt:message key="status.pending"/>
                                                            <% } else { %>
                                                                <fmt:message key="status.delivered"/>
                                                            <% } %>
                                                        </span>
                                                </td>
                        <td class="cart-table-actions">
                            <% if ("Pending".equals(o.getStatus())) { %>
                            <a class="btn btn-sm btn-danger" href="<%= request.getContextPath() %>/CancelOrderServlet?id=<%= o.getOrderId() %>"><fmt:message key="btn.cancel"/></a>
                            <% } else { %>
                            <button class="btn btn-sm btn-secondary" disabled><fmt:message key="btn.delivered"/></button>
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
            <h3><fmt:message key="orders.empty.title"/></h3>
            <p><fmt:message key="orders.empty.sub"/></p>
            <a href="index.jsp" class="btn btn-primary mt-4"><fmt:message key="btn.browseBooks"/></a>
        </div>
        <% } %>
    </section>
</div>

<jsp:include page="includes/footer.jsp"></jsp:include>

</fmt:bundle>