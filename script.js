// Basic script functionality
document.addEventListener('DOMContentLoaded', function() {
    // Mobile menu toggle
    const menuToggle = document.querySelector('.menu-toggle');
    const mainNav = document.querySelector('.main-nav');
    
    if (menuToggle && mainNav) {
        menuToggle.addEventListener('click', function() {
            mainNav.classList.toggle('active');
        });
    }
    
    // Header search functionality (restored)
    const searchForm = document.querySelector('.header-search form');
    const searchInput = document.querySelector('.header-search input');
    
    if (searchForm && searchInput) {
        // Handle form submission
        searchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const query = searchInput.value.trim();
            if (query) {
                window.location.href = `search.html?q=${encodeURIComponent(query)}`;
            }
        });
        
        // Handle search page query parameters and form submission
        if (window.location.pathname.includes('search.html')) {
            const urlParams = new URLSearchParams(window.location.search);
            const searchQuery = urlParams.get('q');
            const pageSearchInput = document.querySelector('.search-page input[name="search"]');
            const pageSearchForm = document.querySelector('.search-page form');
            
            if (searchQuery && pageSearchInput) {
                pageSearchInput.value = searchQuery;
                document.querySelector('.search-results h2').textContent = `Search Results for "${searchQuery}"`;
            }
            
            if (pageSearchForm) {
                pageSearchForm.addEventListener('submit', function(e) {
                    e.preventDefault();
                    const query = pageSearchInput.value.trim();
                    if (query) {
                        window.location.href = `search.html?q=${encodeURIComponent(query)}`;
                    }
                });
            }
        }
    }
    
    // Close notice bar
    const noticeClose = document.querySelector('.notice-close');
    if (noticeClose) {
        noticeClose.addEventListener('click', function() {
            const noticeBar = document.querySelector('.notice-bar');
            noticeBar.style.display = 'none';
        });
    }
    
    // Slider navigation
    const sliderContent = document.querySelector('.slider-content');
    const sliderNavLeft = document.querySelector('.slider-nav.left');
    const sliderNavRight = document.querySelector('.slider-nav.right');
    
    if (sliderContent && sliderNavLeft && sliderNavRight) {
        const slideWidth = 200; // Approximate width of each slide including margins
        
        sliderNavLeft.addEventListener('click', function() {
            sliderContent.scrollBy({
                left: -slideWidth * 2,
                behavior: 'smooth'
            });
        });
        
        sliderNavRight.addEventListener('click', function() {
            sliderContent.scrollBy({
                left: slideWidth * 2,
                behavior: 'smooth'
            });
        });
    }
    
    // View toggle (grid/list)
    const gridView = document.querySelector('.grid-view');
    const listView = document.querySelector('.list-view');
    const manhwaGrid = document.querySelector('.manhwa-grid');
    
    if (gridView && listView && manhwaGrid) {
        gridView.addEventListener('click', function() {
            manhwaGrid.classList.remove('list-layout');
            gridView.classList.add('active');
            listView.classList.remove('active');
            localStorage.setItem('viewMode', 'grid');
        });
        
        listView.addEventListener('click', function() {
            manhwaGrid.classList.add('list-layout');
            listView.classList.add('active');
            gridView.classList.remove('active');
            localStorage.setItem('viewMode', 'list');
        });
        
        // Apply saved view mode
        const savedViewMode = localStorage.getItem('viewMode');
        if (savedViewMode === 'list') {
            listView.click();
        }
    }
    
    // Bookmark functionality
    const bookmarkButtons = document.querySelectorAll('.bookmark-btn, .bookmark');
    
    if (bookmarkButtons.length > 0) {
        bookmarkButtons.forEach(button => {
            button.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                const mangaCard = this.closest('[data-manga-id]');
                if (!mangaCard) return;
                
                const mangaId = mangaCard.getAttribute('data-manga-id');
                const bookmarks = JSON.parse(localStorage.getItem('bookmarks') || '[]');
                
                const isBookmarked = bookmarks.includes(mangaId);
                
                if (isBookmarked) {
                    // Remove bookmark
                    const index = bookmarks.indexOf(mangaId);
                    bookmarks.splice(index, 1);
                    this.innerHTML = '<i class="far fa-bookmark"></i>';
                } else {
                    // Add bookmark
                    bookmarks.push(mangaId);
                    this.innerHTML = '<i class="fas fa-bookmark"></i>';
                }
                
                localStorage.setItem('bookmarks', JSON.stringify(bookmarks));
            });
        });
        
        // Update bookmark icons based on saved bookmarks
        const bookmarks = JSON.parse(localStorage.getItem('bookmarks') || '[]');
        bookmarkButtons.forEach(button => {
            const mangaCard = button.closest('[data-manga-id]');
            if (!mangaCard) return;
            
            const mangaId = mangaCard.getAttribute('data-manga-id');
            const isBookmarked = bookmarks.includes(mangaId);
            
            if (isBookmarked) {
                button.innerHTML = '<i class="fas fa-bookmark"></i>';
            }
        });
    }
});

/**
 * Initialize Report Chapter Modal
 */
function initReportSystem() {
    // Create report button for chapters
    const chapterContainer = document.querySelector('.chapter-container');
    if (chapterContainer) {
        const reportBtn = document.createElement('button');
        reportBtn.className = 'report-btn';
        reportBtn.innerHTML = '<i class="fas fa-flag"></i> Report Chapter';
        chapterContainer.appendChild(reportBtn);
        
        // Create report modal
        createReportModal();
        
        // Add event listener
        reportBtn.addEventListener('click', function() {
            openReportModal();
        });
    }
    
    // Add report button to all pages
    const footerContainer = document.querySelector('.footer-container');
    if (footerContainer && !document.querySelector('.report-modal')) {
        createReportModal();
    }
}

/**
 * Create the report modal
 */
function createReportModal() {
    const modal = document.createElement('div');
    modal.className = 'report-modal';
    
    modal.innerHTML = `
        <div class="report-container">
            <div class="report-header">
                <h3>Report Chapter</h3>
                <button class="close-report"><i class="fas fa-times"></i></button>
            </div>
            <div class="report-options">
                <label class="report-option">
                    <input type="radio" name="report-reason" value="missing-pages"> Missing pages
                </label>
                <label class="report-option">
                    <input type="radio" name="report-reason" value="images-not-loading"> Images not loading
                </label>
                <label class="report-option">
                    <input type="radio" name="report-reason" value="wrong-chapter"> Wrong chapter
                </label>
                <label class="report-option">
                    <input type="radio" name="report-reason" value="other"> Other
                </label>
            </div>
            <div class="report-comment">
                <textarea placeholder="Your Comment"></textarea>
            </div>
            <div class="report-actions">
                <button class="btn-cancel">Cancel</button>
                <button class="btn-submit">Submit</button>
            </div>
        </div>
    `;
    
    document.body.appendChild(modal);
    
    // Add event listeners
    const closeBtn = modal.querySelector('.close-report');
    const cancelBtn = modal.querySelector('.btn-cancel');
    const submitBtn = modal.querySelector('.btn-submit');
    
    closeBtn.addEventListener('click', closeReportModal);
    cancelBtn.addEventListener('click', closeReportModal);
    
    submitBtn.addEventListener('click', function() {
        const reasonInput = modal.querySelector('input[name="report-reason"]:checked');
        const commentInput = modal.querySelector('textarea');
        
        if (!reasonInput) {
            showToast('Please select a reason for reporting');
            return;
        }
        
        const reportData = {
            reason: reasonInput.value,
            comment: commentInput.value,
            page: window.location.pathname,
            timestamp: new Date().toISOString()
        };
        
        // Save report to localStorage for demo purposes
        const reports = JSON.parse(localStorage.getItem('reports')) || [];
        reports.push(reportData);
        localStorage.setItem('reports', JSON.stringify(reports));
        
        showToast('Thank you for reporting the issue!');
        closeReportModal();
    });
}

/**
 * Open the report modal
 */
function openReportModal() {
    const modal = document.querySelector('.report-modal');
    if (modal) {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }
}

/**
 * Close the report modal
 */
function closeReportModal() {
    const modal = document.querySelector('.report-modal');
    if (modal) {
        modal.classList.remove('active');
        document.body.style.overflow = '';
        
        // Reset the form
        const reasonInputs = modal.querySelectorAll('input[name="report-reason"]');
        reasonInputs.forEach(input => {
            input.checked = false;
        });
        
        modal.querySelector('textarea').value = '';
    }
}

/**
 * Show toast notification
 */
function showToast(message, duration = 3000) {
    // Create toast if it doesn't exist
    let toast = document.querySelector('.toast');
    
    if (!toast) {
        toast = document.createElement('div');
        toast.className = 'toast';
        document.body.appendChild(toast);
    }
    
    // Set message and show
    toast.textContent = message;
    toast.classList.add('show');
    
    // Hide after duration
    setTimeout(() => {
        toast.classList.remove('show');
    }, duration);
}

/**
 * Update footer with Discord link
 */
function updateFooter() {
    const footerLinks = document.querySelector('.footer-links');
    if (footerLinks && !footerLinks.querySelector('.fa-discord')) {
        // Check if Discord link already exists
        let discordLink = Array.from(footerLinks.querySelectorAll('a')).find(a => a.textContent.includes('Discord'));
        
        if (!discordLink) {
            discordLink = document.createElement('a');
            discordLink.href = 'https://discord.gg/manhwamosaic';
            discordLink.target = '_blank';
            discordLink.innerHTML = 'Discord <i class="fab fa-discord"></i>';
            footerLinks.appendChild(discordLink);
        } else if (!discordLink.querySelector('.fa-discord')) {
            discordLink.innerHTML = 'Discord <i class="fab fa-discord"></i>';
        }
    }
}

/**
 * Track chapter views
 */
function trackView() {
    const isChapterPage = document.querySelector('.chapter-container');
    if (isChapterPage) {
        const path = window.location.pathname;
        const viewsData = JSON.parse(localStorage.getItem('chapterViews')) || {};
        
        // Only count one view per session
        if (!sessionStorage.getItem('viewed-' + path)) {
            viewsData[path] = (viewsData[path] || 0) + 1;
            localStorage.setItem('chapterViews', JSON.stringify(viewsData));
            sessionStorage.setItem('viewed-' + path, 'true');
        }
    }
}

/**
 * Initialize Disqus comments
 */
function initDisqusComments() {
    const commentsSection = document.querySelector('.comments-section');
    if (commentsSection) {
        const disqusNotice = document.createElement('div');
        disqusNotice.className = 'disqus-notice';
        disqusNotice.innerHTML = `
            <div class="notice-box">
                <i class="fas fa-exclamation-circle"></i>
                <p>Disqus isn't available at the moment on our website. We are looking into a solution.</p>
            </div>
            <div class="comments-placeholder">
                <div class="comments-header">
                    <h3>Comments</h3>
                </div>
                <div class="comments-login-prompt">
                    <p>Please <a href="../login.html">login</a> to leave a comment.</p>
                </div>
            </div>
        `;
        commentsSection.appendChild(disqusNotice);
    }
}

// Initialize these features when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initReportSystem();
    updateFooter();
    trackView();
    initDisqusComments();
    
    // Add "Report Chapter" button to the bottom of the page for a specific class
    if (document.querySelector('.chapter-container')) {
        const reportButton = document.createElement('button');
        reportButton.className = 'btn-report';
        reportButton.innerHTML = '<i class="fas fa-flag"></i> Report Chapter';
        reportButton.addEventListener('click', openReportModal);
        document.querySelector('.chapter-container').appendChild(reportButton);
    }
});
