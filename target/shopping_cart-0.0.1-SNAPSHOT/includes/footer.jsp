<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:bundle basename="messages">
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4">
                <h5><fmt:message key="footer.about.title"/></h5>
                <p><fmt:message key="footer.about.text"/></p>
            </div>
            <div class="col-md-2 mb-4">
                <h5><fmt:message key="footer.links.title"/></h5>
                <p><a href="index.jsp"><fmt:message key="footer.link.home"/></a></p>
                <p><a href="#"><fmt:message key="footer.link.new"/></a></p>
                <p><a href="#"><fmt:message key="footer.link.best"/></a></p>
                <p><a href="#"><fmt:message key="footer.link.categories"/></a></p>
            </div>
            <div class="col-md-2 mb-4">
                <h5><fmt:message key="footer.help.title"/></h5>
                <p><a href="#"><fmt:message key="footer.help.account"/></a></p>
                <p><a href="#"><fmt:message key="footer.help.tracking"/></a></p>
                <p><a href="#"><fmt:message key="footer.help.faq"/></a></p>
                <p><a href="#"><fmt:message key="footer.help.contact"/></a></p>
            </div>
            <div class="col-md-4 mb-4">
                <h5><fmt:message key="footer.news.title"/></h5>
                <p><fmt:message key="footer.news.text"/></p>
                <div class="input-group mt-3">
                    <input type="email" class="form-control" placeholder="<fmt:message key='footer.news.placeholder'/>" aria-label="Your email address">
                    <button class="btn btn-primary" type="button"><fmt:message key="footer.news.subscribe"/></button>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p><fmt:message key="footer.copy"><fmt:param value="2025"/></fmt:message></p>
        </div>
    </div>
</footer>
</fmt:bundle>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
<script>
    // Add hover effect to cards
    document.querySelectorAll('.card').forEach(card => {
        card.addEventListener('mouseenter', () => {
            card.style.transform = 'translateY(-10px)';
            card.style.boxShadow = '0 15px 40px rgba(42, 45, 62, 0.18)';
        });
        
        card.addEventListener('mouseleave', () => {
            card.style.transform = 'translateY(0)';
            card.style.boxShadow = '0 12px 30px rgba(0, 0, 0, 0.08)';
        });
    });
    
    // Remove JS interception on +/- so server-side quantity change works via links

    const currentPath = window.location.pathname;
    const fileName = currentPath.substring(currentPath.lastIndexOf('/') + 1);
    document.querySelectorAll('.nav-link').forEach(link => {
        if (link.getAttribute('href') === fileName) {
            link.classList.add('active');
        } else if (fileName === '' && link.getAttribute('href') === 'index.jsp') {
    
            link.classList.add('active');
        }
    });

</script>
</body>
</html>