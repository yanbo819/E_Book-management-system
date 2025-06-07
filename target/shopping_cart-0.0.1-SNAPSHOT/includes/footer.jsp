<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4">
                <h5>About E-Book</h5>
                <p>Your premier destination for digital reading. Discover thousands of books across all genres at competitive prices.</p>
            </div>
            <div class="col-md-2 mb-4">
                <h5>Quick Links</h5>
                <p><a href="index.jsp">Home</a></p>
                <p><a href="#">New Releases</a></p>
                <p><a href="#">Bestsellers</a></p>
                <p><a href="#">Categories</a></p>
            </div>
            <div class="col-md-2 mb-4">
                <h5>Help</h5>
                <p><a href="#">My Account</a></p>
                <p><a href="#">Order Tracking</a></p>
                <p><a href="#">FAQ</a></p>
                <p><a href="#">Contact Us</a></p>
            </div>
            <div class="col-md-4 mb-4">
                <h5>Newsletter</h5>
                <p>Subscribe to get special offers, free giveaways, and new book alerts.</p>
                <div class="input-group mt-3">
                    <input type="email" class="form-control" placeholder="Your email address" aria-label="Your email address">
                    <button class="btn btn-primary" type="button">Subscribe</button>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2023 E-Book Store. All rights reserved.</p>
        </div>
    </div>
</footer>

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
    
    // Quantity control functionality for cart
    document.querySelectorAll('.btn-incre').forEach(button => {
        button.addEventListener('click', (e) => {
            e.preventDefault();
            const input = button.parentElement.querySelector('.form-control');
            let quantity = parseInt(input.value);
            input.value = quantity + 1;
            // You would typically send an AJAX request here to update the quantity in the session/database
            // window.location.href = 'quantity-inc-dec?action=inc&id=' + button.dataset.productId;
        });
    });
    
    document.querySelectorAll('.btn-decre').forEach(button => {
        button.addEventListener('click', (e) => {
            e.preventDefault();
            const input = button.parentElement.querySelector('.form-control');
            let quantity = parseInt(input.value);
            if (quantity > 1) {
                input.value = quantity - 1;
 
            }
        });
    });

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