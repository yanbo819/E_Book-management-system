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
        total = bdao.getTotalCartPrice(cart_list);
        request.setAttribute("total", total);
    }
%>

<jsp:include page="includes/head.jsp"></jsp:include>
<jsp:include page="includes/navbar.jsp"></jsp:include>

<div class="container">
    <section id="cart-page" class="mb-5">
        <div class="page-header">
            <h2>Your Shopping Cart</h2>
            <p class="lead">Review your selected books before checkout</p>
        </div>
        
        <% if (products != null && !products.isEmpty()) { %>
        <div class="total-price-section">
            <h3>Total Price: $<%= String.format("%.2f", total) %></h3>
            <a class="btn btn-primary" href="CheckOutServlet">Check Out</a>
        </div>
        
        <div class="table-container">
            <table class="table">
                <thead>
                    <tr>
                        <th scope="col">Name</th>
                        <th scope="col">Category</th>
                        <th scope="col">Price</th>
                        <th scope="col">Quantity</th>
                        <th scope="col">Actions</th>
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
                                <a class="btn btn-sm btn-decre" href="QuantityIncDecServlet?action=dec&id=<%= c.getId() %>"><i class="fas fa-minus"></i></a>
                                <input type="text" class="form-control" value="<%= c.getQuantity() %>" readonly>
                                <a class="btn btn-sm btn-incre" href="QuantityIncDecServlet?action=inc&id=<%= c.getId() %>"><i class="fas fa-plus"></i></a>
                            </div>
                        </td>
                        <td class="cart-table-actions">
                            <a class="btn btn-sm btn-primary" href="OrderNowServlet?quantity=<%= c.getQuantity() %>&id=<%= c.getId() %>">Buy</a>
                            <a class="btn btn-sm btn-danger" href="RemoveFromCartServlet?id=<%= c.getId() %>">Remove</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <div class="empty-state">
            <i class="fas fa-shopping-basket"></i>
            <h3>Your Cart is Empty</h3>
            <p>Looks like you haven't added anything to your cart yet. Start shopping now!</p>
            <a href="index.jsp" class="btn btn-primary mt-4">Browse Books</a>
        </div>
        <% } %>
    </section>
</div>

<jsp:include page="includes/footer.jsp"></jsp:include>