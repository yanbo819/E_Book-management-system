<%@page import="cn_zjnu.model.Cart"%>
<%@page import="cn_zjnu.model.User"%>
<%@page import="cn_zjnu.dao.OrderDao"%>
<%@page import="cn_zjnu.dao.BooksDao"%>
<%@page import="cn_zjnu.conncation.DbCon"%>
<%@page import="java.util.*"%>

<%
    User auth = (User) request.getSession().getAttribute("auth");
    ArrayList<Cart> cart_list = (ArrayList<Cart>) session.getAttribute("cart-list");
    List<Cart> products = null;
    double total = 0;
    
    if (cart_list != null) {
        BooksDao bdao = new BooksDao(DbCon.getConnection());
        products = bdao.getCartBooks(cart_list);
        // Compute total in the view to reflect current quantities and unit prices reliably
        for (Cart p : products) {
            total += p.getPrice() * p.getQuantity();
        }
    }
%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="includes/head.jsp"></jsp:include>
<jsp:include page="includes/navbar.jsp"></jsp:include>

<fmt:bundle basename="messages">
<div class="container">
    <section id="cart-page" class="mb-5">
        <div class="page-header">
            <h2><fmt:message key="cart.header"/></h2>
            <p class="lead"><fmt:message key="cart.sub"/></p>
        </div>
        
        <% if (products != null && !products.isEmpty()) { %>
        <div class="total-price-section">
            <h3><fmt:message key="cart.total"/>: $<%= String.format("%.2f", total) %></h3>
            <a class="btn btn-primary" href="<%= request.getContextPath() %>/CheckOutServlet"><fmt:message key="btn.checkout"/></a>
        </div>
        
        <div class="table-container">
            <table class="table">
                <thead>
                    <tr>
                        <th scope="col"><fmt:message key="orders.col.name"/></th>
                        <th scope="col"><fmt:message key="common.category"/></th>
                        <th scope="col"><fmt:message key="cart.unitPrice"/></th>
                        <th scope="col"><fmt:message key="cart.quantity"/></th>
                        <th scope="col"><fmt:message key="cart.lineTotal"/></th>
                        <th scope="col"><fmt:message key="orders.col.actions"/></th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Cart c : products) { %>
                    <tr>
                        <td><%= c.getName() %></td>
                        <td><%= c.getCategory() %></td>
                        <td>$<%= String.format("%.2f", c.getPrice()) %></td>
                        <td>
                            <div class="quantity-control">
                                <a class="btn btn-sm btn-decre" href="<%= request.getContextPath() %>/QuantityIncDecServlet?action=dec&id=<%= c.getId() %>"><i class="fas fa-minus"></i></a>
                                <input type="text" class="form-control" value="<%= c.getQuantity() %>" readonly>
                                <a class="btn btn-sm btn-incre" href="<%= request.getContextPath() %>/QuantityIncDecServlet?action=inc&id=<%= c.getId() %>"><i class="fas fa-plus"></i></a>
                            </div>
                        </td>
                        <td>$<%= String.format("%.2f", (c.getPrice() * c.getQuantity())) %></td>
                        <td class="cart-table-actions">
                            <a class="btn btn-sm btn-primary" href="<%= request.getContextPath() %>/OrderNowServlet?quantity=<%= c.getQuantity() %>&id=<%= c.getId() %>"><fmt:message key="btn.buyNow"/></a>
                            <a class="btn btn-sm btn-danger" href="<%= request.getContextPath() %>/RemoveFromCartServlet?id=<%= c.getId() %>"><fmt:message key="btn.remove"/></a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <div class="empty-state">
            <i class="fas fa-shopping-basket"></i>
            <h3><fmt:message key="cart.empty.title"/></h3>
            <p><fmt:message key="cart.empty.sub"/></p>
            <a href="index.jsp" class="btn btn-primary mt-4"><fmt:message key="btn.browseBooks"/></a>
        </div>
        <% } %>
    </section>
</div>

<jsp:include page="includes/footer.jsp"></jsp:include>

</fmt:bundle>