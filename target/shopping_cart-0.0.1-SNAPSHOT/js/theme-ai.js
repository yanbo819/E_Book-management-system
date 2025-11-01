// Theme Management
document.addEventListener('DOMContentLoaded', function() {
    const themeToggle = document.getElementById('themeToggle');
    const themeIcon = document.getElementById('themeIcon');
    const themeText = document.getElementById('themeText');
    const body = document.body;

    // Load saved theme preference
    const savedTheme = localStorage.getItem('theme') || 'light';
    setTheme(savedTheme);

    // Theme toggle event listener
    if (themeToggle) {
        themeToggle.addEventListener('click', function() {
            const currentTheme = body.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
            setTheme(currentTheme);
        });
    } else {
        console.warn('Theme toggle button not found. Please ensure the navbar includes the theme toggle.');
    }

    function setTheme(theme) {
        if (theme === 'dark') {
            body.setAttribute('data-theme', 'dark');
            if (themeIcon && themeText) {
                themeIcon.className = 'fas fa-moon';
                themeText.textContent = 'Dark';
            }
        } else {
            body.removeAttribute('data-theme');
            if (themeIcon && themeText) {
                themeIcon.className = 'fas fa-sun';
                themeText.textContent = 'Light';
            }
        }
        localStorage.setItem('theme', theme);
        
        // Dispatch custom event for other components that might need theme info
        window.dispatchEvent(new CustomEvent('themeChanged', { detail: { theme } }));
    }
});

// AI Assistant
class AIAssistant {
    constructor() {
        this.chatContainer = null;
        this.messagesContainer = null;
        this.inputField = null;
        this.isOpen = false;
        this.responses = {
            // Website usage responses
            'how to use': 'Welcome to yanbo E-Book Store! Here\'s how to use our website:\n\n1. **Browse Books**: View all available books on the home page\n2. **Search**: Use the search bar to find specific books or categories\n3. **Add to Cart**: Click "Add to Cart" on any book you like\n4. **Manage Cart**: View and modify your cart by clicking the cart icon\n5. **Order**: Click "Buy Now" for immediate purchase or checkout from your cart\n6. **Account**: Login to track your orders and manage your account',
            
            'login': 'To login to your account:\n\n1. Click the "Login" button in the navigation bar\n2. Enter your email and password\n3. Click "Login" to access your account\n\nIf you don\'t have an account, click "Register" to create one with your email, name, and password.',
            
            'register': 'To create a new account:\n\n1. Click "Login" in the navigation, then "Register"\n2. Fill in your name, email, and password\n3. Click "Register" to create your account\n4. You\'ll be automatically logged in after registration',
            
            'cart': 'Managing your shopping cart:\n\n1. **Add Items**: Click "Add to Cart" on any book\n2. **View Cart**: Click the cart icon in the navigation\n3. **Change Quantity**: Use +/- buttons to adjust quantities\n4. **Remove Items**: Click "Remove" to delete items\n5. **Checkout**: Click "Check Out" to complete your purchase',
            
            'search': 'Using the search feature:\n\n1. **Search Bar**: Located in the top navigation\n2. **Keywords**: Enter book names, authors, or categories\n3. **Results**: View matching books on the search results page\n4. **Clear Search**: Click "Back to All Books" to see all books again',
            
            'orders': 'Viewing your orders:\n\n1. **Login Required**: You must be logged in to view orders\n2. **Orders Page**: Click "Orders" in the navigation\n3. **Order History**: See all your past purchases\n4. **Order Details**: View quantities, prices, and dates\n5. **Cancel Orders**: Use "Cancel" if needed (when available)',
            
            'themes': 'Switching between light and dark themes:\n\n1. **Theme Toggle**: Click the sun/moon button in the navigation\n2. **Light Theme**: Default bright theme with dark text\n3. **Dark Theme**: Dark background with light text\n4. **Auto Save**: Your preference is saved automatically\n5. **All Pages**: Theme applies to the entire website',
            
            'payment': 'Currently, our checkout process is simplified for demonstration. In a real implementation, you would:\n\n1. Add items to cart\n2. Click "Check Out"\n3. Enter shipping details\n4. Choose payment method\n5. Complete secure payment\n\nFor this demo, clicking "Check Out" will process your order immediately.',
            
            'contact': 'For support or questions:\n\n- This AI assistant can help with website usage\n- Check the footer for additional information\n- Browse our FAQ section\n- Use the search feature to find specific books\n\nI\'m here to help you navigate and use our e-book store effectively!',
            
            'help': 'I can help you with:\n\n✅ **Website Navigation**: How to browse and use all features\n✅ **Account Management**: Login, registration, and profile\n✅ **Shopping**: Cart management, checkout, and orders\n✅ **Search & Discovery**: Finding books by title, author, or category\n✅ **Customization**: Switching between light and dark themes\n✅ **Troubleshooting**: Common issues and solutions\n\n**Quick Start Commands:**\n• "how to search" - Learn search features\n• "how to buy" - Shopping and checkout guide\n• "switch theme" - Change appearance\n• "my account" - Account management help',
            
            'books': 'Our book collection includes:\n\n📚 **Fiction**: Novels, short stories, and literary works\n📖 **Non-Fiction**: Educational, biographies, and factual books\n🔬 **Science**: Technical and scientific publications\n💻 **Technology**: Programming, IT, and tech guides\n🎨 **Arts**: Creative and artistic books\n\nUse the search bar to find books by title, author, or category. All books are displayed with prices, categories, and cover images.',
            
            'checkout': 'To complete your purchase:\n\n1. **Add Books**: Click "Add to Cart" on books you want\n2. **Review Cart**: Click the cart icon in navigation\n3. **Check Items**: Verify books and quantities\n4. **Checkout**: Click "Check Out" button\n5. **Complete**: Your order will be processed\n\n**Quick Purchase**: Use "Buy Now" for immediate single-book orders.\n\n**Note**: Make sure you\'re logged in to track your orders!',
            
            'categories': 'Browse books by category:\n\n📚 **Available Categories:**\n• Fiction - Novels and stories\n• Non-Fiction - Educational content\n• Science - Technical and research\n• Technology - Programming and IT\n• Biography - Life stories\n• History - Historical accounts\n\n**How to Browse:**\n• Use the search bar with category names\n• Look for category labels on each book\n• Filter results by typing category + keyword',
            
            'account management': 'Managing your account:\n\n**Login Benefits:**\n• Track your order history\n• Faster checkout process\n• Personalized recommendations\n• Secure account dashboard\n\n**Account Actions:**\n• View past orders in "Orders" section\n• Update your preferences\n• Logout securely when done\n\n**Security**: Always logout on shared computers!',
            
            'troubleshooting': 'Common issues and solutions:\n\n**Search Not Working:**\n• Check spelling and try different keywords\n• Use broader terms (e.g., "science" instead of specific titles)\n• Clear your search and try again\n\n**Cart Issues:**\n• Refresh the page if items don\'t appear\n• Make sure you\'re logged in\n• Check if books are still available\n\n**Theme Problems:**\n• Click the sun/moon button in navigation\n• Your preference saves automatically\n• Refresh if theme doesn\'t apply',
            
            'default': 'I\'m your yanbo E-Book Store assistant! 🤖\n\n**I can help with:**\n• 🏠 Website navigation\n• 👤 Account & login help\n• 🛒 Shopping & checkout\n• 🔍 Search tips\n• 🎨 Theme customization\n• 📚 Book categories\n• 🛠️ Troubleshooting\n\n**Try asking:**\n• "How do I search for books?"\n• "Help with checkout"\n• "Switch to dark theme"\n• "What categories are available?"\n\nWhat would you like to know?'
        };
        this.init();
    }

    init() {
        this.createChatInterface();
        this.bindEvents();
    }

    createChatInterface() {
        // Create chat toggle button
        const toggleButton = document.createElement('button');
        toggleButton.className = 'ai-chat-toggle';
        toggleButton.innerHTML = '<i class="fas fa-robot"></i>';
        toggleButton.title = 'Chat with AI Assistant';
        document.body.appendChild(toggleButton);

        // Create chat container
        const chatContainer = document.createElement('div');
        chatContainer.className = 'ai-chat-container';
        chatContainer.innerHTML = `
            <div class="ai-chat-header">
                <h4><i class="fas fa-robot me-2"></i>AI Assistant</h4>
                <button class="ai-chat-close">&times;</button>
            </div>
            <div class="ai-chat-messages">
                <div class="ai-message bot">
                    Hello! I'm your AI assistant for yanbo E-Book Store. I can help you understand how to use our website, search for books, manage your cart, and more. What would you like to know?
                </div>
            </div>
            <div class="ai-chat-input-container">
                <input type="text" class="ai-chat-input" placeholder="Ask me anything about using this website...">
                <button class="ai-chat-send"><i class="fas fa-paper-plane"></i></button>
            </div>
        `;
        document.body.appendChild(chatContainer);

        this.chatContainer = chatContainer;
        this.messagesContainer = chatContainer.querySelector('.ai-chat-messages');
        this.inputField = chatContainer.querySelector('.ai-chat-input');
    }

    bindEvents() {
        const toggleButton = document.querySelector('.ai-chat-toggle');
        const closeButton = document.querySelector('.ai-chat-close');
        const sendButton = document.querySelector('.ai-chat-send');

        toggleButton.addEventListener('click', () => this.toggleChat());
        closeButton.addEventListener('click', () => this.closeChat());
        sendButton.addEventListener('click', () => this.sendMessage());
        
        this.inputField.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.sendMessage();
            }
        });
    }

    toggleChat() {
        if (this.isOpen) {
            this.closeChat();
        } else {
            this.openChat();
        }
    }

    openChat() {
        this.chatContainer.style.display = 'flex';
        this.isOpen = true;
        this.inputField.focus();
    }

    closeChat() {
        this.chatContainer.style.display = 'none';
        this.isOpen = false;
    }

    sendMessage() {
        const message = this.inputField.value.trim();
        if (!message) return;

        // Add user message
        this.addMessage(message, 'user');
        this.inputField.value = '';

        // Generate and add AI response
        setTimeout(() => {
            const response = this.generateResponse(message);
            this.addMessage(response, 'bot');
        }, 500);
    }

    addMessage(message, sender) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `ai-message ${sender}`;
        messageDiv.innerHTML = message.replace(/\n/g, '<br>');
        this.messagesContainer.appendChild(messageDiv);
        this.messagesContainer.scrollTop = this.messagesContainer.scrollHeight;
    }

    generateResponse(message) {
        const lowerMessage = message.toLowerCase();
        
        // Check for specific keywords and return appropriate responses
        for (const [key, response] of Object.entries(this.responses)) {
            if (key !== 'default' && lowerMessage.includes(key)) {
                return response;
            }
        }
        
        // Enhanced pattern matching
        if (lowerMessage.includes('buy') || lowerMessage.includes('purchase') || lowerMessage.includes('checkout')) {
            return this.responses['checkout'];
        }
        
        if (lowerMessage.includes('dark') || lowerMessage.includes('light') || lowerMessage.includes('theme') || lowerMessage.includes('switch')) {
            return this.responses['themes'];
        }
        
        if (lowerMessage.includes('find') || lowerMessage.includes('look for') || lowerMessage.includes('search')) {
            return this.responses['search'];
        }
        
        if (lowerMessage.includes('account') || lowerMessage.includes('profile') || lowerMessage.includes('manage')) {
            return this.responses['account management'];
        }
        
        if (lowerMessage.includes('sign up') || lowerMessage.includes('create account') || lowerMessage.includes('register')) {
            return this.responses['register'];
        }
        
        if (lowerMessage.includes('category') || lowerMessage.includes('categories') || lowerMessage.includes('type')) {
            return this.responses['categories'];
        }
        
        if (lowerMessage.includes('problem') || lowerMessage.includes('issue') || lowerMessage.includes('error') || lowerMessage.includes('not working')) {
            return this.responses['troubleshooting'];
        }
        
        if (lowerMessage.includes('what') && (lowerMessage.includes('book') || lowerMessage.includes('available'))) {
            return this.responses['books'];
        }
        
        if (lowerMessage.includes('cart') && !lowerMessage.includes('search')) {
            return this.responses['cart'];
        }

        // Default response
        return this.responses['default'];
    }
}

// Search Form Enhancement
document.addEventListener('DOMContentLoaded', function() {
    // Initialize AI Assistant
    new AIAssistant();
    
    // Enhance search form
    const searchForm = document.querySelector('.search-form');
    const searchInput = document.querySelector('.search-input');
    
    if (searchForm && searchInput) {
        searchForm.addEventListener('submit', function(e) {
            const query = searchInput.value.trim();
            if (!query) {
                e.preventDefault();
                searchInput.focus();
                searchInput.placeholder = 'Please enter a search term...';
                setTimeout(() => {
                    searchInput.placeholder = 'Search books...';
                }, 2000);
                return false;
            }
        });
        
        // Clear search placeholder on focus
        searchInput.addEventListener('focus', function() {
            if (this.placeholder === 'Please enter a search term...') {
                this.placeholder = 'Search books...';
            }
        });
    }
});