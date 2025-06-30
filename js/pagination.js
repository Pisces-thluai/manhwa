document.addEventListener('DOMContentLoaded', function() {
    // Pagination configuration
    const itemsPerPage = 12;
    let currentPage = 1;
    
    // Function to create pagination
    function createPagination(totalItems) {
        if (!totalItems) return;
        
        // Create pagination container if it doesn't exist
        let paginationContainer = document.querySelector('.pagination-container');
        if (!paginationContainer) {
            paginationContainer = document.createElement('div');
            paginationContainer.className = 'pagination-container';
            
            const searchContainer = document.querySelector('.search-container');
            if (searchContainer) {
                searchContainer.appendChild(paginationContainer);
            }
        }
        
        // Calculate total pages
        const totalPages = Math.ceil(totalItems / itemsPerPage);
        if (totalPages <= 1) {
            paginationContainer.style.display = 'none';
            return;
        }
        
        // Show pagination
        paginationContainer.style.display = 'flex';
        
        // Create pagination HTML
        paginationContainer.innerHTML = '';
        
        // Previous button
        const prevBtn = document.createElement('button');
        prevBtn.className = 'pagination-btn prev';
        prevBtn.innerHTML = '<i class="fas fa-chevron-left"></i>';
        prevBtn.disabled = currentPage === 1;
        prevBtn.addEventListener('click', () => {
            if (currentPage > 1) {
                goToPage(currentPage - 1);
            }
        });
        paginationContainer.appendChild(prevBtn);
        
        // Page numbers
        const maxVisiblePages = 5;
        const startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
        const endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
        
        if (startPage > 1) {
            // First page
            addPageButton(1);
            
            if (startPage > 2) {
                // Ellipsis
                const ellipsis = document.createElement('span');
                ellipsis.className = 'pagination-ellipsis';
                ellipsis.textContent = '...';
                paginationContainer.appendChild(ellipsis);
            }
        }
        
        // Page numbers
        for (let i = startPage; i <= endPage; i++) {
            addPageButton(i);
        }
        
        if (endPage < totalPages) {
            if (endPage < totalPages - 1) {
                // Ellipsis
                const ellipsis = document.createElement('span');
                ellipsis.className = 'pagination-ellipsis';
                ellipsis.textContent = '...';
                paginationContainer.appendChild(ellipsis);
            }
            
            // Last page
            addPageButton(totalPages);
        }
        
        // Next button
        const nextBtn = document.createElement('button');
        nextBtn.className = 'pagination-btn next';
        nextBtn.innerHTML = '<i class="fas fa-chevron-right"></i>';
        nextBtn.disabled = currentPage === totalPages;
        nextBtn.addEventListener('click', () => {
            if (currentPage < totalPages) {
                goToPage(currentPage + 1);
            }
        });
        paginationContainer.appendChild(nextBtn);
        
        function addPageButton(pageNum) {
            const pageBtn = document.createElement('button');
            pageBtn.className = `pagination-btn page-num ${pageNum === currentPage ? 'active' : ''}`;
            pageBtn.textContent = pageNum;
            pageBtn.addEventListener('click', () => goToPage(pageNum));
            paginationContainer.appendChild(pageBtn);
        }
    }
    
    // Function to navigate to a specific page
    function goToPage(pageNum) {
        currentPage = pageNum;
        
        // Update display of items
        const allItems = document.querySelectorAll('.manhwa-item');
        
        if (allItems.length === 0) return;
        
        const startIndex = (currentPage - 1) * itemsPerPage;
        const endIndex = startIndex + itemsPerPage;
        
        allItems.forEach((item, index) => {
            item.style.display = (index >= startIndex && index < endIndex) ? '' : 'none';
        });
        
        // Update pagination
        createPagination(allItems.length);
        
        // Scroll back to top of results
        const searchContainer = document.querySelector('.search-container');
        if (searchContainer) {
            searchContainer.scrollIntoView({ behavior: 'smooth' });
        }
    }
    
    // Initialize pagination after search results are populated
    const searchResultsObserver = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
                // Wait a bit for all items to be added
                setTimeout(() => {
                    const allItems = document.querySelectorAll('.manhwa-item');
                    createPagination(allItems.length);
                    goToPage(1);
                }, 100);
            }
        });
    });
    
    const searchResults = document.querySelector('.search-results');
    if (searchResults) {
        searchResultsObserver.observe(searchResults, { childList: true });
    }
}); 