/**
 * Bookmarks System
 * Handles user bookmarks for manga and chapters
 */
document.addEventListener('DOMContentLoaded', function() {
    initBookmarks();
});

/**
 * Initialize bookmarks functionality
 */
function initBookmarks() {
    setupBookmarkButtons();
    
    // If on bookmarks page, load bookmarks
    if (document.querySelector('.bookmarks-container')) {
        loadBookmarksPage();
    }
}

/**
 * Set up bookmark buttons
 */
function setupBookmarkButtons() {
    // Find bookmark button on manga page
    const bookmarkBtn = document.querySelector('.user-action i.fa-bookmark');
    if (bookmarkBtn) {
        updateBookmarkButtonState();
        bookmarkBtn.addEventListener('click', toggleBookmark);
    }
    
    // Find bookmark buttons on chapter pages
    const chapterBookmarkBtn = document.querySelector('.chapter-actions .bookmark-btn');
    if (chapterBookmarkBtn) {
        updateChapterBookmarkState();
        chapterBookmarkBtn.addEventListener('click', toggleChapterBookmark);
    }
}

/**
 * Toggle manga bookmark state
 */
function toggleBookmark() {
    // Check if user is logged in
    if (!isUserLoggedIn()) {
        showLoginPrompt('Please login to bookmark manga');
        return;
    }
    
    const mangaId = getMangaIdFromPage();
    if (!mangaId) return;
    
    // Get current state
    const isBookmarked = isBookmarked(mangaId);
    
    if (isBookmarked) {
        removeBookmark(mangaId);
        showToast('Removed from bookmarks');
    } else {
        addBookmark(mangaId);
        showToast('Added to bookmarks');
    }
    
    // Update button state
    updateBookmarkButtonState();
}

/**
 * Add manga to bookmarks
 */
function addBookmark(mangaId) {
    // Get title and cover image
    const title = document.querySelector('.manga-title')?.textContent || document.title;
    const cover = document.querySelector('.manga-cover img')?.src || '';
    
    // Get latest chapter if available
    let latestChapter = '';
    const chapterLinks = document.querySelectorAll('.chapter-list .chapter-item a');
    if (chapterLinks.length > 0) {
        latestChapter = chapterLinks[0].textContent.trim();
    }
    
    // Create bookmark object
    const bookmark = {
        id: mangaId,
        title: title,
        cover: cover,
        url: window.location.pathname,
        latestChapter: latestChapter,
        addedAt: new Date().toISOString()
    };
    
    // Get existing bookmarks
    const userData = JSON.parse(localStorage.getItem('userData')) || {};
    if (!userData.bookmarks) {
        userData.bookmarks = [];
    }
    
    // Add to bookmarks if not already there
    if (!userData.bookmarks.some(b => b.id === mangaId)) {
        userData.bookmarks.push(bookmark);
        localStorage.setItem('userData', JSON.stringify(userData));
    }
}

/**
 * Remove manga from bookmarks
 */
function removeBookmark(mangaId) {
    // Get existing bookmarks
    const userData = JSON.parse(localStorage.getItem('userData')) || {};
    if (!userData.bookmarks) return;
    
    // Remove from bookmarks
    userData.bookmarks = userData.bookmarks.filter(b => b.id !== mangaId);
    localStorage.setItem('userData', JSON.stringify(userData));
}

/**
 * Check if manga is bookmarked
 */
function isBookmarked(mangaId) {
    const userData = JSON.parse(localStorage.getItem('userData')) || {};
    
    if (!userData.bookmarks) {
        return false;
    }
    
    return userData.bookmarks.some(b => b.id === mangaId);
}

/**
 * Toggle chapter bookmark state
 */
function toggleChapterBookmark() {
    // Check if user is logged in
    if (!isUserLoggedIn()) {
        showLoginPrompt('Please login to bookmark chapters');
        return;
    }
    
    const mangaId = getMangaIdFromChapter();
    const chapterId = getChapterId();
    
    if (!mangaId || !chapterId) return;
    
    // Get current state
    const isChapterBookmarked = isChapterBookmarked(mangaId, chapterId);
    
    if (isChapterBookmarked) {
        removeChapterBookmark(mangaId, chapterId);
        showToast('Removed from bookmarks');
    } else {
        addChapterBookmark(mangaId, chapterId);
        showToast('Added to bookmarks');
    }
    
    // Update button state
    updateChapterBookmarkState();
}

/**
 * Add chapter to bookmarks
 */
function addChapterBookmark(mangaId, chapterId) {
    // Get chapter info
    const title = document.querySelector('.chapter-title h1')?.textContent || document.title;
    const mangaTitle = document.querySelector('.breadcrumb a[href*="/manga/"]')?.textContent || '';
    
    // Create chapter bookmark
    const chapterBookmark = {
        mangaId: mangaId,
        chapterId: chapterId,
        title: title,
        mangaTitle: mangaTitle,
        url: window.location.pathname,
        addedAt: new Date().toISOString()
    };
    
    // Get existing bookmarks
    const userData = JSON.parse(localStorage.getItem('userData')) || {};
    if (!userData.chapterBookmarks) {
        userData.chapterBookmarks = [];
    }
    
    // Add to bookmarks if not already there
    if (!userData.chapterBookmarks.some(b => b.chapterId === chapterId)) {
        userData.chapterBookmarks.push(chapterBookmark);
        localStorage.setItem('userData', JSON.stringify(userData));
    }
}

/**
 * Remove chapter from bookmarks
 */
function removeChapterBookmark(mangaId, chapterId) {
    // Get existing bookmarks
    const userData = JSON.parse(localStorage.getItem('userData')) || {};
    if (!userData.chapterBookmarks) return;
    
    // Remove from bookmarks
    userData.chapterBookmarks = userData.chapterBookmarks.filter(b => b.chapterId !== chapterId);
    localStorage.setItem('userData', JSON.stringify(userData));
}

/**
 * Check if chapter is bookmarked
 */
function isChapterBookmarked(mangaId, chapterId) {
    const userData = JSON.parse(localStorage.getItem('userData')) || {};
    
    if (!userData.chapterBookmarks) {
        return false;
    }
    
    return userData.chapterBookmarks.some(b => b.chapterId === chapterId);
}

/**
 * Update bookmark button state on manga page
 */
function updateBookmarkButtonState() {
    const bookmarkBtn = document.querySelector('.user-action i.fa-bookmark');
    if (!bookmarkBtn) return;
    
    const mangaId = getMangaIdFromPage();
    if (!mangaId) return;
    
    // Check if bookmarked
    const bookmarked = isBookmarked(mangaId);
    
    if (bookmarked) {
        bookmarkBtn.classList.remove('far');
        bookmarkBtn.classList.add('fas');
        bookmarkBtn.parentElement.classList.add('active');
    } else {
        bookmarkBtn.classList.remove('fas');
        bookmarkBtn.classList.add('far');
        bookmarkBtn.parentElement.classList.remove('active');
    }
}

/**
 * Update bookmark button state on chapter page
 */
function updateChapterBookmarkState() {
    const bookmarkBtn = document.querySelector('.chapter-actions .bookmark-btn');
    if (!bookmarkBtn) return;
    
    const mangaId = getMangaIdFromChapter();
    const chapterId = getChapterId();
    
    if (!mangaId || !chapterId) return;
    
    // Check if bookmarked
    const bookmarked = isChapterBookmarked(mangaId, chapterId);
    
    if (bookmarked) {
        bookmarkBtn.classList.add('active');
        bookmarkBtn.innerHTML = '<i class="fas fa-bookmark"></i> Bookmarked';
    } else {
        bookmarkBtn.classList.remove('active');
        bookmarkBtn.innerHTML = '<i class="far fa-bookmark"></i> Bookmark';
    }
}

/**
 * Load bookmarks on bookmarks page
 */
function loadBookmarksPage() {
    // Check if user is logged in
    if (!isUserLoggedIn()) {
        showLoginPrompt('Please login to view your bookmarks', true);
        return;
    }
    
    // Get tabs
    const mangaTab = document.querySelector('#manga-bookmarks-tab');
    const chaptersTab = document.querySelector('#chapter-bookmarks-tab');
    
    // Setup tab switching
    if (mangaTab && chaptersTab) {
        mangaTab.addEventListener('click', function() {
            showBookmarksTab('manga');
        });
        
        chaptersTab.addEventListener('click', function() {
            showBookmarksTab('chapters');
        });
    }
    
    // Show manga bookmarks by default
    showBookmarksTab('manga');
}

/**
 * Show specific bookmarks tab
 */
function showBookmarksTab(tab) {
    // Update tabs
    const mangaTab = document.querySelector('#manga-bookmarks-tab');
    const chaptersTab = document.querySelector('#chapter-bookmarks-tab');
    
    if (mangaTab && chaptersTab) {
        if (tab === 'manga') {
            mangaTab.classList.add('active');
            chaptersTab.classList.remove('active');
        } else {
            mangaTab.classList.remove('active');
            chaptersTab.classList.add('active');
        }
    }
    
    // Show relevant bookmarks
    if (tab === 'manga') {
        showMangaBookmarks();
    } else {
        showChapterBookmarks();
    }
}

/**
 * Show manga bookmarks
 */
function showMangaBookmarks() {
    const container = document.querySelector('.bookmarks-container');
    if (!container) return;
    
    // Get bookmarks
    const userData = JSON.parse(localStorage.getItem('userData')) || {};
    const bookmarks = userData.bookmarks || [];
    
    // Clear container
    container.innerHTML = '';
    
    // Add heading
    container.innerHTML = '<h2>Manga Bookmarks</h2>';
    
    if (bookmarks.length === 0) {
        container.innerHTML += '<div class="no-bookmarks">You have no manga bookmarks</div>';
        return;
    }
    
    // Create grid
    const grid = document.createElement('div');
    grid.className = 'manhwa-grid bookmarks-grid';
    
    // Add bookmarks
    bookmarks.forEach(bookmark => {
        const card = document.createElement('div');
        card.className = 'manhwa-card bookmark-card';
        
        card.innerHTML = `
            <div class="card-thumb">
                <a href="${bookmark.url}">
                    <img src="${bookmark.cover}" alt="${bookmark.title}" loading="lazy">
                </a>
                <div class="bookmark-actions">
                    <button class="remove-bookmark" data-id="${bookmark.id}">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </div>
            <div class="card-body">
                <h3 class="card-title">
                    <a href="${bookmark.url}">${bookmark.title}</a>
                </h3>
                <div class="card-meta">
                    <div class="latest-chapter">
                        ${bookmark.latestChapter ? `Latest: ${bookmark.latestChapter}` : ''}
                    </div>
                    <div class="bookmark-date">
                        ${formatDate(bookmark.addedAt)}
                    </div>
                </div>
            </div>
        `;
        
        grid.appendChild(card);
    });
    
    container.appendChild(grid);
    
    // Add remove event listeners
    const removeButtons = document.querySelectorAll('.remove-bookmark');
    removeButtons.forEach(button => {
        button.addEventListener('click', function() {
            const mangaId = button.dataset.id;
            removeBookmark(mangaId);
            
            // Remove from DOM
            const card = button.closest('.bookmark-card');
            card.remove();
            
            // Check if any bookmarks left
            if (document.querySelectorAll('.bookmark-card').length === 0) {
                container.innerHTML = '<h2>Manga Bookmarks</h2><div class="no-bookmarks">You have no manga bookmarks</div>';
            }
            
            showToast('Removed from bookmarks');
        });
    });
}

/**
 * Show chapter bookmarks
 */
function showChapterBookmarks() {
    const container = document.querySelector('.bookmarks-container');
    if (!container) return;
    
    // Get bookmarks
    const userData = JSON.parse(localStorage.getItem('userData')) || {};
    const bookmarks = userData.chapterBookmarks || [];
    
    // Clear container
    container.innerHTML = '';
    
    // Add heading
    container.innerHTML = '<h2>Chapter Bookmarks</h2>';
    
    if (bookmarks.length === 0) {
        container.innerHTML += '<div class="no-bookmarks">You have no chapter bookmarks</div>';
        return;
    }
    
    // Create list
    const list = document.createElement('div');
    list.className = 'chapter-bookmarks-list';
    
    // Add bookmarks
    bookmarks.forEach(bookmark => {
        const item = document.createElement('div');
        item.className = 'chapter-bookmark-item';
        
        item.innerHTML = `
            <div class="chapter-bookmark-info">
                <h3 class="chapter-title">
                    <a href="${bookmark.url}">${bookmark.title}</a>
                </h3>
                <div class="manga-title">
                    ${bookmark.mangaTitle}
                </div>
            </div>
            <div class="bookmark-meta">
                <div class="bookmark-date">
                    ${formatDate(bookmark.addedAt)}
                </div>
                <button class="remove-chapter-bookmark" data-id="${bookmark.chapterId}">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        `;
        
        list.appendChild(item);
    });
    
    container.appendChild(list);
    
    // Add remove event listeners
    const removeButtons = document.querySelectorAll('.remove-chapter-bookmark');
    removeButtons.forEach(button => {
        button.addEventListener('click', function() {
            const chapterId = button.dataset.id;
            removeChapterBookmark(null, chapterId); // mangaId not needed for removal
            
            // Remove from DOM
            const item = button.closest('.chapter-bookmark-item');
            item.remove();
            
            // Check if any bookmarks left
            if (document.querySelectorAll('.chapter-bookmark-item').length === 0) {
                container.innerHTML = '<h2>Chapter Bookmarks</h2><div class="no-bookmarks">You have no chapter bookmarks</div>';
            }
            
            showToast('Removed from bookmarks');
        });
    });
}

/**
 * Get manga ID from current page
 */
function getMangaIdFromPage() {
    // Try to get from meta tag
    const metaTag = document.querySelector('meta[name="manga-id"]');
    if (metaTag) {
        return metaTag.getAttribute('content');
    }
    
    // Try to get from URL
    const path = window.location.pathname;
    const match = path.match(/\/manga\/([^\/]+)\.html/);
    if (match && match[1]) {
        return match[1];
    }
    
    // Fallback to document title
    const title = document.title.split('-')[0].trim();
    return slugify(title);
}

/**
 * Get manga ID from chapter page
 */
function getMangaIdFromChapter() {
    const path = window.location.pathname;
    
    // Extract manga folder name from path
    const match = path.match(/\/chapters\/([^\/]+)\//);
    if (match && match[1]) {
        return match[1];
    }
    
    // Try to get from breadcrumb
    const breadcrumb = document.querySelector('.breadcrumb');
    if (breadcrumb) {
        const mangaLink = breadcrumb.querySelector('a[href*="/manga/"]');
        if (mangaLink) {
            const href = mangaLink.getAttribute('href');
            const mangaMatch = href.match(/\/manga\/([^\/]+)\.html/);
            if (mangaMatch && mangaMatch[1]) {
                return mangaMatch[1];
            }
        }
    }
    
    return null;
}

/**
 * Get current chapter ID
 */
function getChapterId() {
    const path = window.location.pathname;
    
    // Extract chapter file name
    const match = path.match(/\/chapters\/[^\/]+\/([^\/]+)\.html/);
    if (match && match[1]) {
        return match[1];
    }
    
    return null;
}

/**
 * Check if user is logged in
 */
function isUserLoggedIn() {
    return localStorage.getItem('authToken') !== null;
}

/**
 * Show login prompt
 */
function showLoginPrompt(message, redirect = false) {
    // Build login URL
    const loginUrl = '../login.html' + (redirect ? '?redirect=' + encodeURIComponent(window.location.href) : '');
    
    if (confirm(message + '\n\nWould you like to login now?')) {
        window.location.href = loginUrl;
    }
}

/**
 * Format date to string
 */
function formatDate(dateStr) {
    const date = new Date(dateStr);
    return date.toLocaleDateString();
}

/**
 * Convert string to slug
 */
function slugify(text) {
    return text.toString().toLowerCase()
        .replace(/\s+/g, '-')           // Replace spaces with -
        .replace(/[^\w\-]+/g, '')       // Remove all non-word chars
        .replace(/\-\-+/g, '-')         // Replace multiple - with single -
        .replace(/^-+/, '')             // Trim - from start of text
        .replace(/-+$/, '');            // Trim - from end of text
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

// Export functions for use in other files
window.Bookmarks = {
    isBookmarked,
    toggleBookmark,
    updateBookmarkButtonState
}; 