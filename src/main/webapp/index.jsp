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
    
    // Check if this is a search request
    boolean isSearch = "true".equals(request.getParameter("search"));
    List<Books> list;
    String searchQuery = "";
    
    if (isSearch && session.getAttribute("searchResults") != null) {
        list = (List<Books>) session.getAttribute("searchResults");
        searchQuery = (String) session.getAttribute("searchQuery");
    } else {
        // Fetch all books
        BooksDao bdao = new BooksDao(DbCon.getConnection());
        list = bdao.getAllBooks();
    }
%>
<jsp:include page="includes/head.jsp"></jsp:include>
<jsp:include page="includes/navbar.jsp"></jsp:include>

<div class="container">
    <section id="home-page" class="mb-5">
        <div class="page-header">
            <% if (isSearch && !searchQuery.isEmpty()) { %>
                <h2>Search Results for "<%= searchQuery %>"</h2>
                <p class="lead">Found <%= list.size() %> book(s) matching your search</p>
                <a href="index.jsp" class="btn btn-outline-primary mt-2">
                    <i class="fas fa-arrow-left me-1"></i>Back to All Books
                </a>
            <% } else { %>
                <h2>Discover Your Next Read</h2>
                <p class="lead">Explore our curated collection of bestsellers and new releases</p>
            <% } %>
        </div>
        
        <!-- Error Messages -->
        <% 
            String errorMessage = (String) session.getAttribute("errorMessage");
            String errorType = request.getParameter("error");
            if (errorMessage != null) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <%= errorMessage %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% session.removeAttribute("errorMessage"); %>
        <% } else if (errorType != null) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="fas fa-info-circle me-2"></i>
                <% if ("search".equals(errorType)) { %>
                    Search temporarily unavailable. Please try again later.
                <% } else if ("db".equals(errorType)) { %>
                    Database connection issue. Please refresh the page.
                <% } else { %>
                    An error occurred. Please try again.
                <% } %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
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
                    <i class="fas fa-search"></i>
                    <% if (isSearch) { %>
                        <h3>No Books Found</h3>
                        <p>We couldn't find any books matching "<%= searchQuery %>". Try different keywords or browse all books.</p>
                        <a href="index.jsp" class="btn btn-primary">Browse All Books</a>
                    <% } else { %>
                        <h3>No Books Available</h3>
                        <p>It looks like our shelves are empty right now. Please check back later!</p>
                    <% } %>
                </div>
            </div>
            <%
                }
            %>
        </div>
    </section>
</div>

<jsp:include page="includes/footer.jsp"></jsp:include>