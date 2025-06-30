/**
 * Search System
 * Handles search functionality for manga and chapters
 */
document.addEventListener('DOMContentLoaded', function() {
    // Initialize search page if we're on it
    if (window.location.pathname.includes('search.html')) {
        initSearchPage();
    }

    // Attach mock data to window for header search to use
    window.getMockMangaData = getMockMangaData;
});

/**
 * Initialize search page functionality
 */
function initSearchPage() {
    // Get search query from URL
    const urlParams = new URLSearchParams(window.location.search);
    const searchQuery = urlParams.get('q');
    const searchInput = document.getElementById('search-input');
    const searchForm = document.getElementById('search-form');
    const resultsContainer = document.getElementById('search-results');
    const resultsTitle = document.querySelector('.search-results h2');
    const filtersToggle = document.getElementById('filters-toggle');
    const advancedFilters = document.getElementById('advanced-filters');
    const sortSelect = document.getElementById('sort');
    const genreFilters = document.querySelectorAll('.genre-checkbox input');
    const statusFilters = document.querySelectorAll('.status-checkbox input');
    
    // Set initial search query in input field
    if (searchQuery && searchInput) {
        searchInput.value = searchQuery;
        if (resultsTitle) {
            resultsTitle.textContent = `Search Results for "${searchQuery}"`;
        }
        
        // Perform search with the query
        performSearch(searchQuery);
    }
    
    // Handle search form submission
    if (searchForm) {
        searchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get search query
            const query = searchInput.value.trim();
            if (query) {
                // Update URL with new query
                const url = new URL(window.location);
                url.searchParams.set('q', query);
                window.history.pushState({}, '', url);
                
                // Update results title
                if (resultsTitle) {
                    resultsTitle.textContent = `Search Results for "${query}"`;
                }
                
                // Perform search
                performSearch(query);
            }
        });
    }
    
    // Toggle advanced filters
    if (filtersToggle && advancedFilters) {
        filtersToggle.addEventListener('click', function() {
            advancedFilters.classList.toggle('expanded');
            this.classList.toggle('active');
            
            const isExpanded = advancedFilters.classList.contains('expanded');
            this.querySelector('span').textContent = isExpanded ? 'Hide Filters' : 'Show Filters';
            this.querySelector('i').className = isExpanded ? 'fas fa-chevron-up' : 'fas fa-chevron-down';
        });
    }
    
    // Handle sorting and filter changes
    if (sortSelect) {
        sortSelect.addEventListener('change', function() {
            performSearch(searchInput.value.trim());
        });
    }
    
    // Handle genre filter changes
    genreFilters.forEach(filter => {
        filter.addEventListener('change', function() {
            performSearch(searchInput.value.trim());
        });
    });
    
    // Handle status filter changes
    statusFilters.forEach(filter => {
        filter.addEventListener('change', function() {
            performSearch(searchInput.value.trim());
        });
    });
}

/**
 * Perform search and display results
 */
function performSearch(query) {
    const resultsContainer = document.getElementById('search-results-container');
    if (!resultsContainer) return;
    
    // Clear previous results
    resultsContainer.innerHTML = '';
    
    // Get filters
    const selectedSort = document.getElementById('sort')?.value || 'relevance';
    const selectedGenres = Array.from(document.querySelectorAll('.genre-checkbox input:checked')).map(input => input.value);
    const selectedStatuses = Array.from(document.querySelectorAll('.status-checkbox input:checked')).map(input => input.value);
    
    // If family mode is enabled, don't show adult content
    const familyModeEnabled = localStorage.getItem('familyMode') === 'enabled';
    
    // Get mock data
    let results = getMockMangaData();
    
    // Filter by query
    if (query) {
        results = results.filter(item => item.title.toLowerCase().includes(query.toLowerCase()));
    }
    
    // Apply genre filters
    if (selectedGenres.length > 0) {
        results = results.filter(item => 
            selectedGenres.some(genre => item.genres.includes(genre))
        );
    }
    
    // Apply status filters
    if (selectedStatuses.length > 0) {
        results = results.filter(item => selectedStatuses.includes(item.status));
    }
    
    // Filter adult content if family mode is enabled
    if (familyModeEnabled) {
        results = results.filter(item => !item.isAdult);
    }
    
    // Apply sorting
    switch (selectedSort) {
        case 'title-asc':
            results.sort((a, b) => a.title.localeCompare(b.title));
            break;
        case 'title-desc':
            results.sort((a, b) => b.title.localeCompare(a.title));
            break;
        case 'rating-desc':
            results.sort((a, b) => b.rating - a.rating);
            break;
        case 'newest':
            results.sort((a, b) => b.dateAdded - a.dateAdded);
            break;
        case 'popularity':
            results.sort((a, b) => b.views - a.views);
            break;
    }
    
    // Display results
    displaySearchResults(results);
    
    // Update result count
    const resultCount = document.getElementById('result-count');
    if (resultCount) {
        resultCount.textContent = `${results.length} results found`;
    }
}

/**
 * Display search results
 */
function displaySearchResults(results) {
    const resultsContainer = document.getElementById('search-results-container');
    if (!resultsContainer) return;
    
    // Clear previous results
    resultsContainer.innerHTML = '';
    
    if (results.length === 0) {
        // No results found
        const noResults = document.createElement('div');
        noResults.className = 'no-results';
        noResults.innerHTML = `
            <div class="no-results-icon">
                <i class="fas fa-search"></i>
            </div>
            <h3>No Results Found</h3>
            <p>Try changing your search terms or filters.</p>
        `;
        resultsContainer.appendChild(noResults);
        return;
    }
    
    // Create results grid
    const resultsGrid = document.createElement('div');
    resultsGrid.className = 'manhwa-grid';
    
    // Add results
    results.forEach(item => {
        // Create card
        const card = document.createElement('div');
        card.className = 'manhwa-card';
        card.setAttribute('data-manga-id', item.id);
        
        // Add tags HTML
        let tagHtml = '';
        if (item.isHot) tagHtml += '<span class="hot-tag">HOT</span>';
        if (item.isNew) tagHtml += '<span class="new-tag">NEW</span>';
        if (item.isAdult) tagHtml += '<span class="adult-tag">18+</span>';
        
        // Create card content
        card.innerHTML = `
            <a href="${item.url}">
                <div class="manhwa-image">
                    <img src="${item.cover}" alt="${item.title}" loading="lazy">
                    ${tagHtml}
                </div>
                <div class="manhwa-info">
                    <h3>${item.title}</h3>
                    <div class="rating-row">
                        <div class="stars">
                            <i class="fas fa-star"></i>
                            <span>${item.rating.toFixed(2)}</span>
                        </div>
                        <div class="views">
                            <span>${formatViews(item.views)}</span>
                        </div>
                    </div>
                    <div class="genres">
                        ${item.genres.slice(0, 3).map(genre => `<span>${genre}</span>`).join('')}
                    </div>
                </div>
            </a>
            <button class="bookmark-btn" title="Bookmark">
                <i class="far fa-bookmark"></i>
            </button>
        `;
        
        resultsGrid.appendChild(card);
    });
    
    resultsContainer.appendChild(resultsGrid);
}

/**
 * Format views number (e.g. 1.2M, 400K)
 */
function formatViews(views) {
    if (views >= 1000000) {
        return (views / 1000000).toFixed(1) + 'M';
    } else if (views >= 1000) {
        return (views / 1000).toFixed(1) + 'K';
    }
    return views.toString();
}

/**
 * Get mock manga data for search results and suggestions
 */
function getMockMangaData() {
    return [
        {
            id: 'solo-leveling',
            title: 'Solo Leveling',
            url: 'manga/solo-leveling.html',
            cover: 'images/covers/solo-leveling.jpg',
            rating: 4.8,
            views: 25000000,
            genres: ['Action', 'Adventure', 'Fantasy'],
            status: 'completed',
            isHot: true,
            isNew: false,
            isAdult: false,
            dateAdded: new Date('2022-01-15').getTime()
        },
        {
            id: 'overgeared',
            title: 'Overgeared',
            url: 'manga/overgeared.html',
            cover: 'images/covers/overgeared.jpg',
            rating: 4.65,
            views: 10400000,
            genres: ['Action', 'Adventure', 'Fantasy', 'Game'],
            status: 'ongoing',
            isHot: false,
            isNew: true,
            isAdult: false,
            dateAdded: new Date('2023-01-05').getTime()
        },
        {
            id: 'the-beginning-after-the-end',
            title: 'The Beginning After the End',
            url: 'manga/the-beginning-after-the-end.html',
            cover: 'images/covers/the-beginning-after-the-end.jpg',
            rating: 4.85,
            views: 27200000,
            genres: ['Action', 'Adventure', 'Fantasy', 'Isekai'],
            status: 'ongoing',
            isHot: true,
            isNew: false,
            isAdult: false,
            dateAdded: new Date('2022-06-20').getTime()
        },
        {
            id: 'solo-leveling-ragnarok',
            title: 'Solo Leveling: Ragnarok',
            url: 'manga/solo-leveling-ragnarok.html',
            cover: 'images/covers/solo-leveling-ragnarok.jpg',
            rating: 4.5,
            views: 5600000,
            genres: ['Action', 'Adventure', 'Fantasy', 'Sequel'],
            status: 'ongoing',
            isHot: true,
            isNew: true,
            isAdult: false,
            dateAdded: new Date('2023-09-28').getTime()
        },
        {
            id: 'the-rankers-guide',
            title: 'The Rankers Guide to Live an Ordinary Life',
            url: 'manga/the-rankers-guide.html',
            cover: 'images/covers/the-rankers-guide.jpg',
            rating: 3.55,
            views: 762700,
            genres: ['Action', 'Fantasy', 'Game'],
            status: 'ongoing',
            isHot: true,
            isNew: false,
            isAdult: false,
            dateAdded: new Date('2023-07-15').getTime()
        },
        {
            id: 'player-who-cant-level-up',
            title: 'Player Who Can\'t Level Up',
            url: 'manga/player-who-cant-level-up.html',
            cover: 'images/covers/player-who-cant-level-up.jpg',
            rating: 4.55,
            views: 7600000,
            genres: ['Action', 'Adventure', 'Fantasy'],
            status: 'ongoing',
            isHot: false,
            isNew: false,
            isAdult: false,
            dateAdded: new Date('2022-11-08').getTime()
        },
        {
            id: 'my-life-as-a-player',
            title: 'My Life as a Player',
            url: 'manga/my-life-as-a-player.html',
            cover: 'images/covers/my-life-as-a-player.jpg',
            rating: 3.65,
            views: 191800,
            genres: ['Drama', 'Romance', 'Adult'],
            status: 'ongoing',
            isHot: false,
            isNew: true,
            isAdult: true,
            dateAdded: new Date('2023-12-05').getTime()
        },
        {
            id: 'love-rebooted',
            title: 'Love Rebooted',
            url: 'manga/love-rebooted.html',
            cover: 'images/covers/love-rebooted.jpg',
            rating: 4.35,
            views: 738200,
            genres: ['Drama', 'Romance', 'Adult'],
            status: 'completed',
            isHot: false,
            isNew: false,
            isAdult: true,
            dateAdded: new Date('2022-05-18').getTime()
        },
        {
            id: '11336',
            title: '11336',
            url: 'manga/11336.html',
            cover: 'images/covers/11336.jpg',
            rating: 4.15,
            views: 520000,
            genres: ['Drama', 'Romance', 'Adult'],
            status: 'ongoing',
            isHot: false,
            isNew: false,
            isAdult: true,
            dateAdded: new Date('2023-02-14').getTime()
        },
        {
            id: 'black-crow',
            title: 'Black Crow',
            url: 'manga/black-crow.html',
            cover: 'images/covers/black-crow.jpg', 
            rating: 4.0,
            views: 203200,
            genres: ['Action', 'Mystery', 'Supernatural'],
            status: 'ongoing',
            isHot: false,
            isNew: true,
            isAdult: false,
            dateAdded: new Date('2024-01-20').getTime()
        },
        {
            id: 'arcane-sniper',
            title: 'Arcane Sniper',
            url: 'manga/arcane-sniper.html',
            cover: 'images/covers/arcane-sniper.jpg',
            rating: 4.45,
            views: 4400000,
            genres: ['Action', 'Adventure', 'Fantasy', 'Game'],
            status: 'ongoing',
            isHot: false,
            isNew: false,
            isAdult: false,
            dateAdded: new Date('2022-08-30').getTime()
        },
        {
            id: 'high-school-devil',
            title: 'High School Devil',
            url: 'manga/high-school-devil.html',
            cover: 'images/covers/high-school-devil.jpg',
            rating: 3.95,
            views: 1200000,
            genres: ['Comedy', 'Romance', 'School Life'],
            status: 'ongoing',
            isHot: false,
            isNew: false,
            isAdult: false,
            dateAdded: new Date('2022-10-12').getTime()
        }
    ];
}

// Export functions for use in other files
window.Search = {
    performSearch,
    applySearchFilters
};
