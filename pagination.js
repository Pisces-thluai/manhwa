/**
 * Pagination System
 * Handles pagination for chapter listings, search results, and manga listings
 */
document.addEventListener('DOMContentLoaded', function() {
    initPagination();
});

/**
 * Initialize pagination on relevant pages
 */
function initPagination() {
    // Check if we're on a page that needs pagination
    if (document.querySelector('.chapter-list') || 
        document.querySelector('.search-results') || 
        document.querySelector('.manhwa-grid')) {
        setupPagination();
    }
}

/**
 * Set up pagination for the current page
 */
function setupPagination() {
    // Determine what type of pagination we need
    if (document.querySelector('.chapter-list')) {
        setupChapterPagination();
    } else if (document.querySelector('.search-results')) {
        setupSearchPagination();
    } else if (document.querySelector('.manhwa-grid')) {
        setupManhwaPagination();
    }
}

/**
 * Set up pagination for chapter listings
 */
function setupChapterPagination() {
    const chapterList = document.querySelector('.chapter-list');
    const chapters = Array.from(chapterList.querySelectorAll('.chapter-item'));
    
    // If fewer than 20 chapters, no pagination needed
    if (chapters.length <= 20) {
        return;
    }
    
    // Hide all chapters beyond page 1
    const itemsPerPage = 20;
    
    // Store original chapter list for reference
    chapterList.dataset.totalItems = chapters.length;
    
    // Create and append pagination controls
    const paginationContainer = createPaginationControls(Math.ceil(chapters.length / itemsPerPage));
    
    // Insert after chapter list
    const chaptersSection = document.querySelector('.chapters-section');
    if (chaptersSection) {
        const loadMore = chaptersSection.querySelector('.load-more');
        if (loadMore) {
            loadMore.remove(); // Remove "Load More" button
        }
        chaptersSection.appendChild(paginationContainer);
    }
    
    // Set up initial state - display first page only
    updateChapterDisplay(1, itemsPerPage);
    
    // Highlight current page
    highlightCurrentPage(1);
}

/**
 * Update chapter display based on current page
 */
function updateChapterDisplay(currentPage, itemsPerPage) {
    const chapterList = document.querySelector('.chapter-list');
    const chapters = Array.from(chapterList.querySelectorAll('.chapter-item'));
    
    // Hide all chapters
    chapters.forEach(chapter => {
        chapter.style.display = 'none';
    });
    
    // Calculate start and end indices
    const startIdx = (currentPage - 1) * itemsPerPage;
    const endIdx = startIdx + itemsPerPage;
    
    // Display only current page chapters
    for (let i = startIdx; i < endIdx && i < chapters.length; i++) {
        chapters[i].style.display = '';
    }
    
    // Scroll to top of chapter list
    chapterList.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

/**
 * Set up pagination for search results
 */
function setupSearchPagination() {
    const searchResults = document.querySelector('.search-results');
    const items = Array.from(searchResults.querySelectorAll('.search-item'));
    
    // If fewer than 24 results, no pagination needed
    if (items.length <= 24) {
        return;
    }
    
    // Hide all results beyond page 1
    const itemsPerPage = 24;
    
    // Store original items count for reference
    searchResults.dataset.totalItems = items.length;
    
    // Create and append pagination controls
    const paginationContainer = createPaginationControls(Math.ceil(items.length / itemsPerPage));
    searchResults.after(paginationContainer);
    
    // Set up initial state - display first page only
    updateSearchDisplay(1, itemsPerPage);
    
    // Highlight current page
    highlightCurrentPage(1);
}

/**
 * Update search results display based on current page
 */
function updateSearchDisplay(currentPage, itemsPerPage) {
    const searchResults = document.querySelector('.search-results');
    const items = Array.from(searchResults.querySelectorAll('.search-item'));
    
    // Hide all results
    items.forEach(item => {
        item.style.display = 'none';
    });
    
    // Calculate start and end indices
    const startIdx = (currentPage - 1) * itemsPerPage;
    const endIdx = startIdx + itemsPerPage;
    
    // Display only current page results
    for (let i = startIdx; i < endIdx && i < items.length; i++) {
        items[i].style.display = '';
    }
    
    // Scroll to top of results
    searchResults.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

/**
 * Set up pagination for manga/manhwa grid
 */
function setupManhwaPagination() {
    const manhwaGrid = document.querySelector('.manhwa-grid');
    const items = Array.from(manhwaGrid.querySelectorAll('.manhwa-card'));
    
    // If fewer than 24 items, no pagination needed
    if (items.length <= 24) {
        return;
    }
    
    // Hide all items beyond page 1
    const itemsPerPage = 24;
    
    // Store original items count for reference
    manhwaGrid.dataset.totalItems = items.length;
    
    // Create and append pagination controls
    const paginationContainer = createPaginationControls(Math.ceil(items.length / itemsPerPage));
    manhwaGrid.after(paginationContainer);
    
    // Set up initial state - display first page only
    updateManhwaDisplay(1, itemsPerPage);
    
    // Highlight current page
    highlightCurrentPage(1);
}

/**
 * Update manga/manhwa grid display based on current page
 */
function updateManhwaDisplay(currentPage, itemsPerPage) {
    const manhwaGrid = document.querySelector('.manhwa-grid');
    const items = Array.from(manhwaGrid.querySelectorAll('.manhwa-card'));
    
    // Hide all items
    items.forEach(item => {
        item.style.display = 'none';
    });
    
    // Calculate start and end indices
    const startIdx = (currentPage - 1) * itemsPerPage;
    const endIdx = startIdx + itemsPerPage;
    
    // Display only current page items
    for (let i = startIdx; i < endIdx && i < items.length; i++) {
        items[i].style.display = '';
    }
    
    // Scroll to top of grid
    manhwaGrid.scrollIntoView({ behavior: 'smooth', block: 'start' });
}

/**
 * Create pagination controls
 */
function createPaginationControls(totalPages) {
    const paginationContainer = document.createElement('div');
    paginationContainer.className = 'pagination';
    
    // Get current page from URL or default to 1
    const urlParams = new URLSearchParams(window.location.search);
    const currentPage = parseInt(urlParams.get('page')) || 1;
    
    // First page link
    const firstPage = document.createElement('a');
    firstPage.href = '#';
    firstPage.className = 'pagination-link first';
    firstPage.textContent = '«';
    firstPage.addEventListener('click', e => {
        e.preventDefault();
        changePage(1);
    });
    paginationContainer.appendChild(firstPage);
    
    // Calculate page range
    let startPage = Math.max(1, currentPage - 2);
    let endPage = Math.min(totalPages, startPage + 4);
    
    // Adjust start if end is maxed out
    if (endPage === totalPages) {
        startPage = Math.max(1, endPage - 4);
    }
    
    // Create page links
    for (let i = startPage; i <= endPage; i++) {
        const pageLink = document.createElement('a');
        pageLink.href = '#';
        pageLink.className = 'pagination-link';
        pageLink.textContent = i;
        pageLink.dataset.page = i;
        
        if (i === currentPage) {
            pageLink.classList.add('active');
        }
        
        pageLink.addEventListener('click', e => {
            e.preventDefault();
            changePage(i);
        });
        
        paginationContainer.appendChild(pageLink);
    }
    
    // Last page link
    const lastPage = document.createElement('a');
    lastPage.href = '#';
    lastPage.className = 'pagination-link last';
    lastPage.textContent = 'Last »';
    lastPage.addEventListener('click', e => {
        e.preventDefault();
        changePage(totalPages);
    });
    paginationContainer.appendChild(lastPage);
    
    return paginationContainer;
}

/**
 * Change to a specific page
 */
function changePage(pageNumber) {
    // Update URL if possible
    if (history.pushState) {
        const url = new URL(window.location);
        url.searchParams.set('page', pageNumber);
        window.history.pushState({}, '', url);
    }
    
    // Determine what page type we're on and update display
    if (document.querySelector('.chapter-list')) {
        updateChapterDisplay(pageNumber, 20);
    } else if (document.querySelector('.search-results')) {
        updateSearchDisplay(pageNumber, 24);
    } else if (document.querySelector('.manhwa-grid')) {
        updateManhwaDisplay(pageNumber, 24);
    }
    
    // Highlight current page
    highlightCurrentPage(pageNumber);
}

/**
 * Highlight the current page in pagination controls
 */
function highlightCurrentPage(pageNumber) {
    // Remove active class from all links
    const pageLinks = document.querySelectorAll('.pagination-link');
    pageLinks.forEach(link => {
        link.classList.remove('active');
    });
    
    // Add active class to current page link
    const currentLink = document.querySelector(`.pagination-link[data-page="${pageNumber}"]`);
    if (currentLink) {
        currentLink.classList.add('active');
    }
}

// Export functions for use in other files
window.Pagination = {
    changePage,
    setupPagination
}; 