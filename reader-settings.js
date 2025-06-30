/**
 * Reader Settings & User Preferences
 * Manages reading history, bookmarks, and reader customization options
 */
document.addEventListener('DOMContentLoaded', function() {
    initContinueReading();
    initBookmarkButtons();
    initReadingSlider();
    initNoticeBar();
    setupFiltersSorting();
    setupViewToggle();
    initReaderSettings();
});

/**
 * Initialize the "Continue Reading" section
 */
function initContinueReading() {
    const readingSlider = document.querySelector('.reading-slider');
    const readingSection = document.querySelector('.user-reading');
    
    if (!readingSlider || !readingSection) return;
    
    // Get reading history from localStorage
    const readingHistory = JSON.parse(localStorage.getItem('readingHistory')) || [];
    
    // If no reading history, hide the section
    if (readingHistory.length === 0) {
        readingSection.style.display = 'none';
        return;
    }
    
    // Display the most recent 6 items from reading history
    const recentItems = readingHistory.slice(0, 6);
    
    recentItems.forEach(item => {
        const itemElement = document.createElement('div');
        itemElement.className = 'reading-item';
        
        itemElement.innerHTML = `
            <a href="${item.url}">
                <div class="reading-image">
                    <img src="${item.cover}" alt="${item.title}">
                    <div class="reading-progress" style="width: ${item.progress}%"></div>
                </div>
                <div class="reading-info">
                    <h4>${item.title}</h4>
                    <p>Chapter ${item.chapter}</p>
                </div>
            </a>
        `;
        
        readingSlider.appendChild(itemElement);
    });
}

/**
 * Initialize bookmark functionality
 */
function initBookmarkButtons() {
    const bookmarkButtons = document.querySelectorAll('.bookmark, .bookmark-btn');
    
    bookmarkButtons.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            const card = this.closest('.manhwa-card, .slider-item');
            const link = card.querySelector('a');
            const title = card.querySelector('h3, .slider-info h3').textContent;
            const coverImg = card.querySelector('img').src;
            
            // Toggle bookmark state
            const isBookmarked = this.classList.contains('bookmarked');
            
            // Update UI
            if (isBookmarked) {
                this.classList.remove('bookmarked');
                this.querySelector('i').classList.remove('fas');
                this.querySelector('i').classList.add('far');
                showToast(`Removed "${title}" from bookmarks`);
                removeBookmark(link.href);
            } else {
                this.classList.add('bookmarked');
                this.querySelector('i').classList.remove('far');
                this.querySelector('i').classList.add('fas');
                showToast(`Added "${title}" to bookmarks`);
                addBookmark({
                    title: title,
                    url: link.href,
                    cover: coverImg,
                    date: new Date().toISOString()
                });
            }
        });
    });
    
    // Initialize bookmark state from localStorage
    loadBookmarkState();
}

/**
 * Add bookmark to localStorage
 */
function addBookmark(bookmarkData) {
    const bookmarks = JSON.parse(localStorage.getItem('bookmarks')) || [];
    
    // Check if already bookmarked
    const existingIndex = bookmarks.findIndex(b => b.url === bookmarkData.url);
    
    if (existingIndex >= 0) {
        bookmarks[existingIndex] = bookmarkData;
    } else {
        bookmarks.push(bookmarkData);
    }
    
    localStorage.setItem('bookmarks', JSON.stringify(bookmarks));
}

/**
 * Remove bookmark from localStorage
 */
function removeBookmark(url) {
    const bookmarks = JSON.parse(localStorage.getItem('bookmarks')) || [];
    const filteredBookmarks = bookmarks.filter(b => b.url !== url);
    localStorage.setItem('bookmarks', JSON.stringify(filteredBookmarks));
}

/**
 * Load bookmark state from localStorage
 */
function loadBookmarkState() {
    const bookmarks = JSON.parse(localStorage.getItem('bookmarks')) || [];
    const bookmarkButtons = document.querySelectorAll('.bookmark, .bookmark-btn');
    
    bookmarkButtons.forEach(btn => {
        const card = btn.closest('.manhwa-card, .slider-item');
        const link = card.querySelector('a').href;
        
        if (bookmarks.some(b => b.url === link)) {
            btn.classList.add('bookmarked');
            btn.querySelector('i').classList.remove('far');
            btn.querySelector('i').classList.add('fas');
        }
    });
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
 * Initialize reading slider functionality
 */
function initReadingSlider() {
    // Could add slider navigation here if needed
}

/**
 * Initialize notice bar close button
 */
function initNoticeBar() {
    const closeBtn = document.querySelector('.notice-close');
    const noticeBar = document.querySelector('.notice-bar');
    
    if (closeBtn && noticeBar) {
        closeBtn.addEventListener('click', function() {
            noticeBar.style.display = 'none';
            localStorage.setItem('noticeHidden', 'true');
        });
        
        // Check if notice was previously hidden
        if (localStorage.getItem('noticeHidden') === 'true') {
            noticeBar.style.display = 'none';
        }
    }
}

/**
 * Setup filters and sorting functionality
 */
function setupFiltersSorting() {
    const filterBtn = document.querySelector('.filter-btn');
    const filterContent = document.querySelector('.filter-content');
    const sortBtn = document.querySelector('.sort-btn');
    const sortContent = document.querySelector('.sort-content');
    
    // Toggle filter dropdown
    if (filterBtn && filterContent) {
        filterBtn.addEventListener('click', function() {
            filterContent.classList.toggle('show');
            if (sortContent) sortContent.classList.remove('show');
        });
    }
    
    // Toggle sort dropdown
    if (sortBtn && sortContent) {
        sortBtn.addEventListener('click', function() {
            sortContent.classList.toggle('show');
            if (filterContent) filterContent.classList.remove('show');
        });
    }
    
    // Close dropdowns when clicking elsewhere
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.filter-dropdown') && filterContent) {
            filterContent.classList.remove('show');
        }
        if (!e.target.closest('.sort-dropdown') && sortContent) {
            sortContent.classList.remove('show');
        }
    });
    
    // Section tabs (All, Manhwa, Manga, etc.)
    const sectionTabs = document.querySelectorAll('.section-tab');
    const sliderItems = document.querySelectorAll('.slider-item');
    
    sectionTabs.forEach(tab => {
        tab.addEventListener('click', function() {
            // Update active tab
            sectionTabs.forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            
            const target = this.dataset.target;
            
            // Filter items
            sliderItems.forEach(item => {
                if (target === 'all' || item.dataset.type === target) {
                    item.style.display = '';
                } else {
                    item.style.display = 'none';
                }
            });
        });
    });
}

/**
 * Setup view toggle (grid/list view)
 */
function setupViewToggle() {
    const gridViewBtn = document.querySelector('.grid-view');
    const listViewBtn = document.querySelector('.list-view');
    const manhwaGrid = document.querySelector('.manhwa-grid');
    
    if (gridViewBtn && listViewBtn && manhwaGrid) {
        // Switch to grid view
        gridViewBtn.addEventListener('click', function() {
            manhwaGrid.classList.remove('list-layout');
            manhwaGrid.classList.add('grid-layout');
            gridViewBtn.classList.add('active');
            listViewBtn.classList.remove('active');
            localStorage.setItem('viewMode', 'grid');
        });
        
        // Switch to list view
        listViewBtn.addEventListener('click', function() {
            manhwaGrid.classList.remove('grid-layout');
            manhwaGrid.classList.add('list-layout');
            listViewBtn.classList.add('active');
            gridViewBtn.classList.remove('active');
            localStorage.setItem('viewMode', 'list');
        });
        
        // Apply saved view preference
        const savedView = localStorage.getItem('viewMode');
        if (savedView === 'list') {
            manhwaGrid.classList.add('list-layout');
            listViewBtn.classList.add('active');
            gridViewBtn.classList.remove('active');
        } else {
            manhwaGrid.classList.add('grid-layout');
            gridViewBtn.classList.add('active');
            listViewBtn.classList.remove('active');
        }
    }
}

// Basic reader settings
document.addEventListener('DOMContentLoaded', function() {
    // Settings toggle in reader pages
    const settingsToggle = document.querySelector('.settings-toggle');
    if (settingsToggle) {
        settingsToggle.addEventListener('click', function() {
            const settingsPanel = document.querySelector('.reader-settings');
            settingsPanel.classList.toggle('active');
        });
    }
    
    // Close settings panel when clicking outside
    document.addEventListener('click', function(e) {
        const settingsPanel = document.querySelector('.reader-settings');
        const settingsToggle = document.querySelector('.settings-toggle');
        
        if (settingsPanel && settingsPanel.classList.contains('active') && 
            !settingsPanel.contains(e.target) && 
            !settingsToggle.contains(e.target)) {
            settingsPanel.classList.remove('active');
        }
    });
    
    // Image width settings
    const widthOptions = document.querySelectorAll('.width-option');
    const readerImages = document.querySelectorAll('.reader-content img');
    
    if (widthOptions.length > 0 && readerImages.length > 0) {
        widthOptions.forEach(option => {
            option.addEventListener('click', function() {
                // Remove active class from all options
                widthOptions.forEach(o => o.classList.remove('active'));
                
                // Add active class to clicked option
                option.classList.add('active');
                
                const width = option.getAttribute('data-width');
                
                // Apply width to all images
                readerImages.forEach(img => {
                    if (width === 'full') {
                        img.style.width = '100%';
                    } else if (width === 'fit') {
                        img.style.width = 'auto';
                        img.style.maxWidth = '100%';
                    } else {
                        img.style.width = width + '%';
                    }
                });
                
                // Save preference
                localStorage.setItem('readerImageWidth', width);
            });
        });
        
        // Apply saved preference
        const savedWidth = localStorage.getItem('readerImageWidth');
        if (savedWidth) {
            const savedOption = document.querySelector(`.width-option[data-width="${savedWidth}"]`);
            if (savedOption) {
                savedOption.click();
            }
        }
    }
    
    // Close notice bar
    const noticeClose = document.querySelector('.notice-close');
    if (noticeClose) {
        noticeClose.addEventListener('click', function() {
            const noticeBar = document.querySelector('.notice-bar');
            noticeBar.style.display = 'none';
            localStorage.setItem('noticeHidden', 'true');
        });
    }
    
    // Check if notice should be hidden
    if (localStorage.getItem('noticeHidden') === 'true') {
        const noticeBar = document.querySelector('.notice-bar');
        if (noticeBar) {
            noticeBar.style.display = 'none';
        }
    }
}); 