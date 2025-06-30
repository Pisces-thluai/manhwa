/**
 * View Counter System
 * Tracks and displays view counts for chapters and manga
 */
document.addEventListener('DOMContentLoaded', function() {
    initViewCounter();
});

/**
 * Initialize view counter
 */
function initViewCounter() {
    trackPageView();
    formatViewCounts();
}

/**
 * Track page view
 */
function trackPageView() {
    // Determine page type
    const pageType = getPageType();
    const pageId = getPageId();
    
    if (!pageType || !pageId) return;
    
    // Check if this view has been counted in this session
    const viewKey = `${pageType}_${pageId}_viewed`;
    if (sessionStorage.getItem(viewKey)) {
        return;
    }
    
    // Mark as viewed in this session
    sessionStorage.setItem(viewKey, 'true');
    
    // Increment view count
    incrementViewCount(pageType, pageId);
    
    // If this is a chapter, also increment manga views
    if (pageType === 'chapter') {
        const mangaId = getMangaIdFromChapter(pageId);
        if (mangaId) {
            incrementViewCount('manga', mangaId);
        }
    }
    
    // Update view display if on page
    setTimeout(updateViewDisplay, 1000);
}

/**
 * Get page type (manga or chapter)
 */
function getPageType() {
    const path = window.location.pathname;
    
    if (path.includes('/manga/')) {
        return 'manga';
    } else if (path.includes('/chapters/')) {
        return 'chapter';
    }
    
    return null;
}

/**
 * Get page ID from URL
 */
function getPageId() {
    const path = window.location.pathname;
    
    // For manga pages
    let match = path.match(/\/manga\/([^\/]+)\.html/);
    if (match && match[1]) {
        return match[1];
    }
    
    // For chapter pages
    match = path.match(/\/chapters\/([^\/]+)\/([^\/]+)\.html/);
    if (match && match[2]) {
        return match[2];
    }
    
    return null;
}

/**
 * Get manga ID from chapter
 */
function getMangaIdFromChapter(chapterId) {
    const path = window.location.pathname;
    
    // Extract manga folder name from path
    const match = path.match(/\/chapters\/([^\/]+)\//);
    if (match && match[1]) {
        return match[1];
    }
    
    // Try to extract from chapter ID
    const mangaMatch = chapterId.match(/^(.*?)-chapter-\d+$/);
    if (mangaMatch && mangaMatch[1]) {
        return mangaMatch[1];
    }
    
    // Try to extract from breadcrumb
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
 * Increment view count
 */
function incrementViewCount(type, id) {
    // Get view counts from localStorage
    const viewCounts = JSON.parse(localStorage.getItem('viewCounts')) || {};
    
    // Initialize if needed
    if (!viewCounts[type]) {
        viewCounts[type] = {};
    }
    
    // Increment count
    viewCounts[type][id] = (viewCounts[type][id] || 0) + 1;
    
    // Save back to localStorage
    localStorage.setItem('viewCounts', JSON.stringify(viewCounts));
    
    // In a real app, we would also send this to a server
    // sendViewToServer(type, id);
}

/**
 * Update view display on current page
 */
function updateViewDisplay() {
    const pageType = getPageType();
    const pageId = getPageId();
    
    if (!pageType || !pageId) return;
    
    // Get total views
    const views = getTotalViews(pageType, pageId);
    
    // Update display
    if (pageType === 'manga') {
        const viewElement = document.querySelector('.manga-rating-views span');
        if (viewElement) {
            viewElement.textContent = formatViewCount(views);
        }
    } else if (pageType === 'chapter') {
        // Check if we have a chapter view counter
        const viewElement = document.querySelector('.chapter-views');
        if (viewElement) {
            viewElement.textContent = formatViewCount(views) + ' views';
        } else {
            // Try to create one if not exists
            const chapterTitle = document.querySelector('.chapter-title');
            if (chapterTitle) {
                const viewSpan = document.createElement('span');
                viewSpan.className = 'chapter-views';
                viewSpan.textContent = formatViewCount(views) + ' views';
                chapterTitle.appendChild(viewSpan);
            }
        }
    }
}

/**
 * Get total views for a page (including server-side views)
 */
function getTotalViews(type, id) {
    // Base view count (this would come from the server in a real app)
    const baseViewCounts = {
        manga: {
            'the-beginning-after-the-end': 27200000,
            'overgeared': 10400000,
            'arcane-sniper': 4400000,
            'high-school-legend-red-dragon': 443600,
            'high-school-devil': 1200000,
            'solo-leveling': 31500000,
            'solo-leveling-ragnarok': 3100000,
        },
        chapter: {}
    };
    
    // Get base views
    const baseViews = (baseViewCounts[type] && baseViewCounts[type][id]) || Math.floor(Math.random() * 5000000);
    
    // Get local views
    const viewCounts = JSON.parse(localStorage.getItem('viewCounts')) || {};
    const localViews = (viewCounts[type] && viewCounts[type][id]) || 0;
    
    return baseViews + localViews;
}

/**
 * Format view count with suffix (K, M)
 */
function formatViewCount(count) {
    if (count >= 1000000) {
        return (count / 1000000).toFixed(1) + 'M';
    } else if (count >= 1000) {
        return (count / 1000).toFixed(1) + 'K';
    } else {
        return count;
    }
}

/**
 * Format all view counts on the page
 */
function formatViewCounts() {
    // Format manga card view counts
    const viewElements = document.querySelectorAll('.manhwa-card .views span, .slider-item .views span');
    
    viewElements.forEach(element => {
        const text = element.textContent.trim();
        
        // Check if it's already formatted
        if (text.endsWith('M') || text.endsWith('K')) {
            return;
        }
        
        const number = parseInt(text.replace(/[^\d]/g, ''));
        
        if (!isNaN(number)) {
            element.textContent = formatViewCount(number);
        }
    });
}

/**
 * Send view to server (mock function)
 */
function sendViewToServer(type, id) {
    // In a real app, this would make an API call
    console.log(`Sending ${type} view for ${id} to server`);
    
    // Mock implementation
    return new Promise(resolve => {
        setTimeout(() => {
            resolve({ success: true });
        }, 500);
    });
}

// Export functions for use in other files
window.ViewCounter = {
    formatViewCount,
    updateViewDisplay,
    trackPageView
}; 