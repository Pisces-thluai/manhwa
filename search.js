/**
 * Search System
 * Handles search functionality for manga and chapters
 */
document.addEventListener('DOMContentLoaded', function() {
    initSearch();
});

/**
 * Initialize search functionality
 */
function initSearch() {
    setupSearchForm();
    setupAdvancedSearch();
    initializeSearchResults();
}

/**
 * Set up search form submission
 */
function setupSearchForm() {
    const searchForm = document.querySelector('.search-form');
    const searchInput = document.querySelector('.search-input');
    
    if (searchForm && searchInput) {
        searchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const query = searchInput.value.trim();
            
            if (query.length > 0) {
                performSearch(query);
            }
        });
        
        // Add live search functionality with debounce
        let searchTimeout;
        searchInput.addEventListener('input', function() {
            const query = searchInput.value.trim();
            
            // Clear previous timeout
            clearTimeout(searchTimeout);
            
            // Set new timeout (300ms debounce)
            if (query.length >= 2) {
                searchTimeout = setTimeout(() => {
                    performLiveSearch(query);
                }, 300);
            } else {
                hideSearchSuggestions();
            }
        });
        
        // Close suggestions on click outside
        document.addEventListener('click', function(e) {
            if (!searchForm.contains(e.target)) {
                hideSearchSuggestions();
            }
        });
    }
    
    // Check if we're on search results page
    const urlParams = new URLSearchParams(window.location.search);
    const query = urlParams.get('q');
    
    if (query && document.querySelector('.search-results')) {
        // Update search input
        if (searchInput) {
            searchInput.value = query;
        }
        
        // Update page title
        document.title = `Search results for: ${query}`;
        
        // Update heading
        const searchHeading = document.querySelector('.search-heading');
        if (searchHeading) {
            searchHeading.textContent = `Search results for: "${query}"`;
        }
        
        // Load search results
        loadSearchResults(query);
    }
}

/**
 * Set up advanced search features
 */
function setupAdvancedSearch() {
    const advancedSearchBtn = document.querySelector('.advanced-search-button');
    if (!advancedSearchBtn) return;
    
    advancedSearchBtn.addEventListener('click', function() {
        toggleAdvancedSearchPanel();
    });
    
    // Set up genre filters
    const genreCheckboxes = document.querySelectorAll('.genre-filters input[type="checkbox"]');
    genreCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            if (document.querySelector('.search-results')) {
                applySearchFilters();
            }
        });
    });
    
    // Set up other filters
    const statusFilter = document.querySelector('#status-filter');
    const sortFilter = document.querySelector('#sort-filter');
    
    [statusFilter, sortFilter].forEach(filter => {
        if (filter) {
            filter.addEventListener('change', function() {
                if (document.querySelector('.search-results')) {
                    applySearchFilters();
                }
            });
        }
    });
}

/**
 * Toggle the advanced search panel
 */
function toggleAdvancedSearchPanel() {
    const panel = document.querySelector('.advanced-search-panel');
    if (panel) {
        panel.classList.toggle('active');
    }
}

/**
 * Initialize search results page
 */
function initializeSearchResults() {
    const searchResults = document.querySelector('.search-results');
    if (!searchResults) return;
    
    // Check URL for filters
    const urlParams = new URLSearchParams(window.location.search);
    
    // Set up genre filters from URL
    const genres = urlParams.get('genres');
    if (genres) {
        const genreList = genres.split(',');
        genreList.forEach(genre => {
            const checkbox = document.querySelector(`.genre-filters input[value="${genre}"]`);
            if (checkbox) {
                checkbox.checked = true;
            }
        });
    }
    
    // Set status filter from URL
    const status = urlParams.get('status');
    if (status) {
        const statusSelect = document.querySelector('#status-filter');
        if (statusSelect) {
            statusSelect.value = status;
        }
    }
    
    // Set sort filter from URL
    const sort = urlParams.get('sort');
    if (sort) {
        const sortSelect = document.querySelector('#sort-filter');
        if (sortSelect) {
            sortSelect.value = sort;
        }
    }
}

/**
 * Perform search and redirect to search results page
 */
function performSearch(query) {
    // Get filters
    const filters = collectSearchFilters();
    
    // Build search URL
    let searchUrl = `search.html?q=${encodeURIComponent(query)}`;
    
    // Add filters to URL
    if (filters.genres.length > 0) {
        searchUrl += `&genres=${encodeURIComponent(filters.genres.join(','))}`;
    }
    
    if (filters.status) {
        searchUrl += `&status=${encodeURIComponent(filters.status)}`;
    }
    
    if (filters.sort) {
        searchUrl += `&sort=${encodeURIComponent(filters.sort)}`;
    }
    
    // Redirect to search page
    window.location.href = searchUrl;
}

/**
 * Perform live search for suggestions
 */
function performLiveSearch(query) {
    // In a real app, this would be an API call
    // For this demo, we'll use mock data
    getMangaSuggestions(query)
        .then(results => {
            displaySearchSuggestions(results);
        })
        .catch(error => {
            console.error('Error performing live search:', error);
        });
}

/**
 * Display search suggestions dropdown
 */
function displaySearchSuggestions(results) {
    // Find or create suggestions container
    let suggestionsContainer = document.querySelector('.search-suggestions');
    const searchForm = document.querySelector('.search-form');
    
    if (!suggestionsContainer) {
        suggestionsContainer = document.createElement('div');
        suggestionsContainer.className = 'search-suggestions';
        searchForm.appendChild(suggestionsContainer);
    }
    
    // Clear previous suggestions
    suggestionsContainer.innerHTML = '';
    
    if (results.length === 0) {
        suggestionsContainer.innerHTML = '<div class="suggestion-item no-results">No results found</div>';
        suggestionsContainer.classList.add('active');
        return;
    }
    
    // Add new suggestions
    results.forEach(item => {
        const suggestionItem = document.createElement('div');
        suggestionItem.className = 'suggestion-item';
        
        suggestionItem.innerHTML = `
            <a href="${item.url}">
                <div class="suggestion-thumb">
                    <img src="${item.cover}" alt="${item.title}" loading="lazy">
                </div>
                <div class="suggestion-info">
                    <div class="suggestion-title">${item.title}</div>
                    <div class="suggestion-meta">
                        <span class="suggestion-rating">
                            <i class="fas fa-star"></i> ${item.rating}
                        </span>
                        <span class="suggestion-views">
                            <i class="fas fa-eye"></i> ${item.views}
                        </span>
                    </div>
                </div>
            </a>
        `;
        
        suggestionsContainer.appendChild(suggestionItem);
        
        // Add event listener
        suggestionItem.addEventListener('click', function() {
            window.location.href = item.url;
        });
    });
    
    // Show suggestions
    suggestionsContainer.classList.add('active');
}

/**
 * Hide search suggestions
 */
function hideSearchSuggestions() {
    const suggestionsContainer = document.querySelector('.search-suggestions');
    if (suggestionsContainer) {
        suggestionsContainer.classList.remove('active');
    }
}

/**
 * Load search results on search page
 */
function loadSearchResults(query) {
    // Get filters
    const filters = collectSearchFiltersFromURL();
    
    // In a real app, this would be an API call
    // For this demo, we'll use mock data
    getMangaSearchResults(query, filters)
        .then(results => {
            displaySearchResults(results);
        })
        .catch(error => {
            console.error('Error loading search results:', error);
        });
}

/**
 * Display search results on page
 */
function displaySearchResults(results) {
    const searchResultsContainer = document.querySelector('.search-results');
    if (!searchResultsContainer) return;
    
    // Clear previous results
    searchResultsContainer.innerHTML = '';
    
    if (results.length === 0) {
        searchResultsContainer.innerHTML = '<div class="no-results">No results found</div>';
        return;
    }
    
    // Add new results
    results.forEach(item => {
        const resultItem = document.createElement('div');
        resultItem.className = 'search-item manhwa-card';
        resultItem.dataset.mangaId = item.id;
        
        resultItem.innerHTML = `
            <div class="card-thumb">
                <a href="${item.url}">
                    <img src="${item.cover}" alt="${item.title}" loading="lazy">
                </a>
                ${item.status === 'completed' ? '<span class="completed-badge">COMPLETED</span>' : ''}
            </div>
            <div class="card-body">
                <h3 class="card-title">
                    <a href="${item.url}">${item.title}</a>
                </h3>
                <div class="card-meta">
                    <div class="stars">
                        <i class="fas fa-star"></i>
                        <span>${item.rating}</span>
                    </div>
                    <div class="views">
                        <i class="fas fa-eye"></i>
                        <span>${item.views}</span>
                    </div>
                </div>
            </div>
        `;
        
        searchResultsContainer.appendChild(resultItem);
    });
    
    // Setup pagination if needed
    if (results.length > 24) {
        // This would be handled by the pagination.js
        if (window.Pagination) {
            window.Pagination.setupPagination();
        }
    }
}

/**
 * Apply search filters on results page
 */
function applySearchFilters() {
    // Get current query
    const urlParams = new URLSearchParams(window.location.search);
    const query = urlParams.get('q') || '';
    
    // Get current filters
    const filters = collectSearchFilters();
    
    // Update URL without reload
    let newUrl = `search.html?q=${encodeURIComponent(query)}`;
    
    if (filters.genres.length > 0) {
        newUrl += `&genres=${encodeURIComponent(filters.genres.join(','))}`;
    }
    
    if (filters.status) {
        newUrl += `&status=${encodeURIComponent(filters.status)}`;
    }
    
    if (filters.sort) {
        newUrl += `&sort=${encodeURIComponent(filters.sort)}`;
    }
    
    window.history.pushState({}, '', newUrl);
    
    // Reload search results with new filters
    getMangaSearchResults(query, filters)
        .then(results => {
            displaySearchResults(results);
        })
        .catch(error => {
            console.error('Error applying filters:', error);
        });
}

/**
 * Collect search filters from form
 */
function collectSearchFilters() {
    const filters = {
        genres: [],
        status: '',
        sort: ''
    };
    
    // Collect genre filters
    const genreCheckboxes = document.querySelectorAll('.genre-filters input[type="checkbox"]:checked');
    genreCheckboxes.forEach(checkbox => {
        filters.genres.push(checkbox.value);
    });
    
    // Collect status filter
    const statusFilter = document.querySelector('#status-filter');
    if (statusFilter && statusFilter.value) {
        filters.status = statusFilter.value;
    }
    
    // Collect sort filter
    const sortFilter = document.querySelector('#sort-filter');
    if (sortFilter && sortFilter.value) {
        filters.sort = sortFilter.value;
    }
    
    return filters;
}

/**
 * Collect search filters from URL
 */
function collectSearchFiltersFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    
    const filters = {
        genres: [],
        status: '',
        sort: ''
    };
    
    // Get genres
    const genres = urlParams.get('genres');
    if (genres) {
        filters.genres = genres.split(',');
    }
    
    // Get status
    const status = urlParams.get('status');
    if (status) {
        filters.status = status;
    }
    
    // Get sort
    const sort = urlParams.get('sort');
    if (sort) {
        filters.sort = sort;
    }
    
    return filters;
}

/**
 * Get manga suggestions (mock data for demo)
 */
function getMangaSuggestions(query) {
    // Mock data for suggestions
    const allManga = getMockMangaData();
    
    // Filter based on query
    const results = allManga.filter(item => 
        item.title.toLowerCase().includes(query.toLowerCase())
    ).slice(0, 5); // Limit to 5 results
    
    return Promise.resolve(results);
}

/**
 * Get manga search results (mock data for demo)
 */
function getMangaSearchResults(query, filters) {
    // Mock data for search results
    let results = getMockMangaData();
    
    // Filter by query
    if (query) {
        results = results.filter(item => 
            item.title.toLowerCase().includes(query.toLowerCase())
        );
    }
    
    // Apply filters
    if (filters.genres.length > 0) {
        results = results.filter(item => 
            item.genres.some(genre => filters.genres.includes(genre))
        );
    }
    
    if (filters.status) {
        results = results.filter(item => item.status === filters.status);
    }
    
    // Apply sorting
    if (filters.sort) {
        switch (filters.sort) {
            case 'views-desc':
                results.sort((a, b) => parseFloat(b.views.replace(/[KM]/g, '')) - parseFloat(a.views.replace(/[KM]/g, '')));
                break;
            case 'views-asc':
                results.sort((a, b) => parseFloat(a.views.replace(/[KM]/g, '')) - parseFloat(b.views.replace(/[KM]/g, '')));
                break;
            case 'rating-desc':
                results.sort((a, b) => parseFloat(b.rating) - parseFloat(a.rating));
                break;
            case 'rating-asc':
                results.sort((a, b) => parseFloat(a.rating) - parseFloat(b.rating));
                break;
            case 'latest':
                results.sort((a, b) => new Date(b.updated) - new Date(a.updated));
                break;
            case 'oldest':
                results.sort((a, b) => new Date(a.updated) - new Date(b.updated));
                break;
        }
    }
    
    return Promise.resolve(results);
}

/**
 * Mock manga data for demo
 */
function getMockMangaData() {
    return [
        {
            id: 'solo-leveling',
            title: 'Solo Leveling',
            url: '../manga/solo-leveling.html',
            cover: '../images/covers/solo-leveling.jpg',
            rating: '4.8',
            views: '31.5M',
            status: 'completed',
            genres: ['action', 'adventure', 'fantasy'],
            updated: '2023-04-15'
        },
        {
            id: 'overgeared',
            title: 'Overgeared',
            url: '../manga/overgeared.html',
            cover: '../images/covers/overgeared.jpg',
            rating: '4.65',
            views: '10.4M',
            status: 'ongoing',
            genres: ['action', 'adventure', 'fantasy'],
            updated: '2024-04-24'
        },
        {
            id: 'the-beginning-after-the-end',
            title: 'The Beginning After The End',
            url: '../manga/the-beginning-after-the-end.html',
            cover: '../images/covers/tbate.jpg',
            rating: '4.85',
            views: '27.2M',
            status: 'ongoing',
            genres: ['action', 'adventure', 'fantasy'],
            updated: '2024-04-17'
        },
        {
            id: 'arcane-sniper',
            title: 'Arcane Sniper',
            url: '../manga/arcane-sniper.html',
            cover: '../images/covers/arcane-sniper.jpg',
            rating: '4.45',
            views: '4.4M',
            status: 'ongoing',
            genres: ['action', 'adventure', 'fantasy'],
            updated: '2024-04-03'
        },
        {
            id: 'solo-leveling-ragnarok',
            title: 'Solo Leveling: Ragnarok',
            url: '../manga/solo-leveling-ragnarok.html',
            cover: '../images/covers/slr.jpg',
            rating: '4.7',
            views: '3.1M',
            status: 'ongoing',
            genres: ['action', 'adventure', 'fantasy'],
            updated: '2024-04-20'
        },
        {
            id: 'player-who-cant-level-up',
            title: 'Player Who Can\'t Level Up',
            url: '../manga/player-who-cant-level-up.html',
            cover: '../images/covers/pwclu.jpg',
            rating: '4.55',
            views: '7.6M',
            status: 'ongoing',
            genres: ['action', 'adventure', 'fantasy'],
            updated: '2024-04-24'
        },
        {
            id: 'the-rankers-guide',
            title: 'The Rankers Guide to Live an Ordinary Life',
            url: '../manga/the-rankers-guide.html',
            cover: '../images/covers/rankers-guide.jpg',
            rating: '3.55',
            views: '762.7K',
            status: 'ongoing',
            genres: ['action', 'fantasy', 'romance'],
            updated: '2024-04-28'
        },
        {
            id: 'my-life-as-a-player',
            title: 'My Life as a Player',
            url: '../manga/my-life-as-a-player.html',
            cover: '../images/covers/my-life-as-a-player.jpg',
            rating: '3.65',
            views: '191.8K',
            status: 'ongoing',
            genres: ['adult', 'drama', 'romance'],
            updated: '2024-04-13'
        },
        {
            id: 'love-rebooted',
            title: 'Love Rebooted',
            url: '../manga/love-rebooted.html',
            cover: '../images/covers/love-rebooted.jpg',
            rating: '4.35',
            views: '738.2K',
            status: 'completed',
            genres: ['adult', 'drama', 'romance'],
            updated: '2024-03-14'
        },
        {
            id: '11336',
            title: '11336',
            url: '../manga/11336.html',
            cover: '../images/covers/11336.jpg',
            rating: '4.2',
            views: '2.1M',
            status: 'ongoing',
            genres: ['action', 'fantasy', 'tragedy'],
            updated: '2024-04-05'
        }
    ];
}

// Export functions for use in other files
window.Search = {
    performSearch,
    applySearchFilters
}; 