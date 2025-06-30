/**
 * Header Search with Suggestions
 * 
 * This script enhances the header search with auto-suggestions and improved UX
 */
document.addEventListener('DOMContentLoaded', function() {
    initHeaderSearch();
});

/**
 * Initialize enhanced header search
 */
function initHeaderSearch() {
    const searchContainer = document.querySelector('.header-search');
    if (!searchContainer) return;
    
    const searchInput = searchContainer.querySelector('input');
    const suggestionsContainer = searchContainer.querySelector('.search-suggestions');
    
    // Focus event handler
    searchInput.addEventListener('focus', function() {
        searchContainer.classList.add('focused');
        if (this.value.trim().length >= 2) {
            showSuggestions(this.value.trim());
        }
    });
    
    // Input event handler with debounce
    let debounceTimer;
    searchInput.addEventListener('input', function() {
        const query = this.value.trim();
        
        // Clear previous timeout
        clearTimeout(debounceTimer);
        
        // Hide suggestions if query is too short
        if (query.length < 2) {
            hideSuggestions();
            return;
        }
        
        // Set new timeout (300ms debounce)
        debounceTimer = setTimeout(() => {
            showSuggestions(query);
        }, 300);
    });
    
    // Click outside handler
    document.addEventListener('click', function(e) {
        if (!searchContainer.contains(e.target)) {
            searchContainer.classList.remove('focused');
            hideSuggestions();
        }
    });
    
    // Handle submission
    searchContainer.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const query = searchInput.value.trim();
        if (query) {
            window.location.href = `search.html?q=${encodeURIComponent(query)}`;
        }
    });
}

/**
 * Show search suggestions
 */
function showSuggestions(query) {
    const suggestionsContainer = document.querySelector('.header-search .search-suggestions');
    if (!suggestionsContainer) return;
    
    // Get search suggestions
    getMangaSuggestions(query)
        .then(suggestions => {
            // Clear previous suggestions
            suggestionsContainer.innerHTML = '';
            
            if (suggestions.length === 0) {
                const noResults = document.createElement('div');
                noResults.className = 'no-suggestions';
                noResults.textContent = 'No results found';
                suggestionsContainer.appendChild(noResults);
            } else {
                // Add suggestions to container
                suggestions.forEach(item => {
                    const suggestionItem = document.createElement('a');
                    suggestionItem.href = item.url;
                    suggestionItem.className = 'suggestion-item';
                    
                    // Add tags
                    let tagHtml = '';
                    if (item.isHot) tagHtml += '<span class="suggestion-tag hot">Hot</span>';
                    if (item.isNew) tagHtml += '<span class="suggestion-tag new">New</span>';
                    if (item.status === 'completed') tagHtml += '<span class="suggestion-tag completed">Completed</span>';
                    
                    // Create suggestion HTML
                    suggestionItem.innerHTML = `
                        <div class="suggestion-cover">
                            <img src="${item.cover}" alt="${item.title}" loading="lazy">
                        </div>
                        <div class="suggestion-info">
                            <div class="suggestion-title">${highligthMatch(item.title, query)}</div>
                            <div class="suggestion-meta">
                                <div class="suggestion-rating">
                                    <i class="fas fa-star"></i> ${item.rating}
                                </div>
                                ${tagHtml}
                            </div>
                        </div>
                    `;
                    
                    suggestionsContainer.appendChild(suggestionItem);
                });
                
                // Add "View all results" link
                const viewAllLink = document.createElement('a');
                viewAllLink.href = `search.html?q=${encodeURIComponent(query)}`;
                viewAllLink.className = 'view-all-results';
                viewAllLink.innerHTML = 'View all results <i class="fas fa-arrow-right"></i>';
                
                suggestionsContainer.appendChild(viewAllLink);
            }
            
            // Show suggestions container
            suggestionsContainer.style.display = 'block';
            
        })
        .catch(error => {
            console.error('Error getting search suggestions:', error);
        });
}

/**
 * Hide search suggestions
 */
function hideSuggestions() {
    const suggestionsContainer = document.querySelector('.header-search .search-suggestions');
    if (suggestionsContainer) {
        suggestionsContainer.style.display = 'none';
    }
}

/**
 * Highlight matching text
 */
function highligthMatch(text, query) {
    // Escape special regex characters
    const escapedQuery = query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    const regex = new RegExp(`(${escapedQuery})`, 'gi');
    return text.replace(regex, '<span class="highlight">$1</span>');
}

/**
 * Get manga suggestions (from search.js mock data)
 */
function getMangaSuggestions(query) {
    // Use the mock data function from search.js if available
    if (typeof window.getMockMangaData === 'function') {
        const results = window.getMockMangaData().filter(item => 
            item.title.toLowerCase().includes(query.toLowerCase())
        ).slice(0, 5); // Limit to 5 results
        
        return Promise.resolve(results);
    }
    
    // Fallback: Return placeholder data
    return Promise.resolve([
        {
            title: 'Solo Leveling',
            url: 'manga/solo-leveling.html',
            cover: 'images/covers/solo-leveling-ragnarok.jpg',
            rating: '4.8',
            isHot: true,
            isNew: false,
            status: 'completed'
        },
        {
            title: 'Overgeared',
            url: 'manga/overgeared.html',
            cover: 'images/covers/overgeared.jpg',
            rating: '4.6',
            isHot: false,
            isNew: true,
            status: 'ongoing'
        },
        {
            title: 'The Beginning After the End',
            url: 'manga/the-beginning-after-the-end.html',
            cover: 'images/covers/the-beginning-after-the-end.jpg',
            rating: '4.9',
            isHot: true,
            isNew: false,
            status: 'ongoing'
        }
    ].filter(item => 
        item.title.toLowerCase().includes(query.toLowerCase())
    ));
} 