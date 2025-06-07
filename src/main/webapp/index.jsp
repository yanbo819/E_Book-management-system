<%@page import="cn_zjnu.model.*"%>
<%@page import="cn_zjnu.dao.*"%>
<%@page import="cn_zjnu.conncation.DbCon"%>
<%@page import="java.util.*"%>
<%
    User auth = (User) request.getSession().getAttribute("auth");
    List<Cart> cart_list = (ArrayList<Cart>) session.getAttribute("cart-list");
    if (cart_list != null) {
        request.setAttribute("cart_list", cart_list);
    }
    
    // Fetch all books
    BooksDao bdao = new BooksDao(DbCon.getConnection());
    List<Books> list = bdao.getAllBooks();
%>
<jsp:include page="includes/head.jsp"></jsp:include>
<jsp:include page="includes/navbar.jsp"></jsp:include>

<div class="container">
    <section id="home-page" class="mb-5">
        <div class="page-header">
            <h2>Discover Your Next Read</h2>
            <p class="lead">Explore our curated collection of bestsellers and new releases</p>
        </div>
        
        <div class="row">
            <%
                if (!list.isEmpty()) {
                    for (Books b : list) {
            %>
            <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                <div class="card h-100">
                    <img src="product.images/<%= b.getImage() %>" class="card-img-top" alt="<%= b.getName() %>">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title text-truncate" title="<%= b.getName() %>"><%= b.getName() %></h5>
                        <h6 class="price">$<%= String.format("%.2f", b.getPrice()) %></h6>
                        <h6 class="category"><%= b.getCategory() %></h6>
                        <div class="mt-auto d-flex justify-content-between">
                            <a href="AddToCartServlet?id=<%= b.getId() %>" class="btn btn-dark btn-sm">Add to Cart</a>
                            <a href="OrderNowServlet?quantity=1&id=<%= b.getId() %>" class="btn btn-primary btn-sm">Buy Now</a>
                        </div>
                    </div>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="col-12">
                <div class="empty-state">
                    <i class="fas fa-book-reader"></i>
                    <h3>No Books Available</h3>
                    <p>It looks like our shelves are empty right now. Please check back later!</p>
                </div>
            </div>
            <%
                }
            %>
        </div>
    </section>
</div>

<jsp:include page="includes/footer.jsp"></jsp:include>