/**
 * Rating System
 * Handles user ratings, average ratings display, and rating interactions
 */
document.addEventListener('DOMContentLoaded', function() {
    initRatingSystem();
});

/**
 * Initialize rating system
 */
function initRatingSystem() {
    setupRatingStars();
    initRatingModal();
    formatRatingNumbers();
}

/**
 * Set up interactive rating stars on manga pages
 */
function setupRatingStars() {
    // Find rating UI elements on page
    const ratingAction = document.querySelector('.user-action i.fa-star');
    if (ratingAction) {
        ratingAction.addEventListener('click', showRatingModal);
    }
    
    // Update all rating displays
    updateRatingDisplays();
}

/**
 * Initialize the rating modal
 */
function initRatingModal() {
    // Create rating modal if it doesn't exist
    if (!document.querySelector('.rating-modal')) {
        const modalHtml = `
            <div class="rating-modal">
                <div class="rating-container">
                    <div class="rating-header">
                        <h3>Rate this Manhwa</h3>
                        <button class="close-rating"><i class="fas fa-times"></i></button>
                    </div>
                    <div class="rating-stars">
                        <i class="far fa-star" data-rating="1"></i>
                        <i class="far fa-star" data-rating="2"></i>
                        <i class="far fa-star" data-rating="3"></i>
                        <i class="far fa-star" data-rating="4"></i>
                        <i class="far fa-star" data-rating="5"></i>
                    </div>
                    <p class="rating-hint">Click a star to rate</p>
                    <div class="rating-actions">
                        <button class="btn-submit-rating" disabled>Submit</button>
                    </div>
                </div>
            </div>
        `;
        
        // Add to body
        const modalElement = document.createElement('div');
        modalElement.innerHTML = modalHtml;
        document.body.appendChild(modalElement.firstElementChild);
        
        // Set up event listeners
        const closeBtn = document.querySelector('.close-rating');
        if (closeBtn) {
            closeBtn.addEventListener('click', hideRatingModal);
        }
        
        // Set up star hover and click
        const stars = document.querySelectorAll('.rating-stars i');
        stars.forEach(star => {
            star.addEventListener('mouseover', highlightStars);
            star.addEventListener('mouseout', resetStars);
            star.addEventListener('click', selectRating);
        });
        
        // Set up submit button
        const submitBtn = document.querySelector('.btn-submit-rating');
        if (submitBtn) {
            submitBtn.addEventListener('click', submitRating);
        }
    }
}

/**
 * Show the rating modal
 */
function showRatingModal() {
    // Check if user is logged in
    if (!isUserLoggedIn()) {
        showLoginPrompt('Please login to rate manhwa');
        return;
    }
    
    const modal = document.querySelector('.rating-modal');
    if (modal) {
        modal.classList.add('active');
        
        // Get manga ID from page
        const mangaId = getMangaIdFromPage();
        modal.dataset.mangaId = mangaId;
        
        // Check if user has already rated this manga
        const userRating = getUserRating(mangaId);
        if (userRating) {
            setSelectedRating(userRating);
        } else {
            resetStars();
        }
    }
}

/**
 * Hide the rating modal
 */
function hideRatingModal() {
    const modal = document.querySelector('.rating-modal');
    if (modal) {
        modal.classList.remove('active');
    }
}

/**
 * Highlight stars on hover
 */
function highlightStars(e) {
    const stars = document.querySelectorAll('.rating-stars i');
    const hoveredRating = parseInt(e.target.dataset.rating);
    
    stars.forEach((star, index) => {
        if (index < hoveredRating) {
            star.classList.remove('far');
            star.classList.add('fas');
        } else {
            star.classList.remove('fas');
            star.classList.add('far');
        }
    });
    
    // Update hint text
    const hintText = document.querySelector('.rating-hint');
    if (hintText) {
        const ratingTexts = ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];
        hintText.textContent = ratingTexts[hoveredRating] || 'Click a star to rate';
    }
}

/**
 * Reset stars when mouse leaves
 */
function resetStars() {
    const stars = document.querySelectorAll('.rating-stars i');
    const modal = document.querySelector('.rating-modal');
    const mangaId = modal?.dataset.mangaId;
    const selectedRating = modal?.dataset.selectedRating || 0;
    
    stars.forEach((star, index) => {
        if (index < selectedRating) {
            star.classList.remove('far');
            star.classList.add('fas');
        } else {
            star.classList.remove('fas');
            star.classList.add('far');
        }
    });
    
    // Reset hint text
    const hintText = document.querySelector('.rating-hint');
    if (hintText) {
        if (selectedRating > 0) {
            const ratingTexts = ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];
            hintText.textContent = ratingTexts[selectedRating] || 'Click a star to rate';
        } else {
            hintText.textContent = 'Click a star to rate';
        }
    }
}

/**
 * Select a rating
 */
function selectRating(e) {
    const rating = parseInt(e.target.dataset.rating);
    const modal = document.querySelector('.rating-modal');
    
    if (modal) {
        // Store selected rating
        modal.dataset.selectedRating = rating;
        
        // Update stars
        setSelectedRating(rating);
        
        // Enable submit button
        const submitBtn = document.querySelector('.btn-submit-rating');
        if (submitBtn) {
            submitBtn.disabled = false;
        }
    }
}

/**
 * Set selected rating in the UI
 */
function setSelectedRating(rating) {
    const stars = document.querySelectorAll('.rating-stars i');
    
    stars.forEach((star, index) => {
        if (index < rating) {
            star.classList.remove('far');
            star.classList.add('fas');
        } else {
            star.classList.remove('fas');
            star.classList.add('far');
        }
    });
    
    // Update hint text
    const hintText = document.querySelector('.rating-hint');
    if (hintText) {
        const ratingTexts = ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];
        hintText.textContent = ratingTexts[rating] || 'Click a star to rate';
    }
    
    // Enable submit button
    const submitBtn = document.querySelector('.btn-submit-rating');
    if (submitBtn) {
        submitBtn.disabled = false;
    }
}

/**
 * Submit a rating
 */
function submitRating() {
    const modal = document.querySelector('.rating-modal');
    if (!modal) return;
    
    const mangaId = modal.dataset.mangaId;
    const rating = parseInt(modal.dataset.selectedRating || 0);
    
    if (!mangaId || rating === 0) return;
    
    // Save rating (in a real app, this would be an API call)
    saveUserRating(mangaId, rating);
    
    // Update UI
    updateRatingDisplays();
    
    // Show confirmation
    showToast('Your rating has been submitted!');
    
    // Close modal
    hideRatingModal();
}

/**
 * Save user rating to localStorage
 */
function saveUserRating(mangaId, rating) {
    // Get user data
    const userData = JSON.parse(localStorage.getItem('userData')) || {};
    
    // Initialize ratings if doesn't exist
    if (!userData.ratings) {
        userData.ratings = {};
    }
    
    // Save rating
    userData.ratings[mangaId] = rating;
    
    // Save back to localStorage
    localStorage.setItem('userData', JSON.stringify(userData));
    
    // Update manga ratings
    updateMangaRating(mangaId, rating);
}

/**
 * Update manga rating in localStorage
 */
function updateMangaRating(mangaId, newRating) {
    // Get manga ratings data
    const ratingsData = JSON.parse(localStorage.getItem('mangaRatings')) || {};
    
    // Initialize manga rating if doesn't exist
    if (!ratingsData[mangaId]) {
        ratingsData[mangaId] = {
            totalRatings: 0,
            totalScore: 0,
            averageRating: 0
        };
    }
    
    // Get user data to check if this is an update
    const userData = JSON.parse(localStorage.getItem('userData')) || {};
    const oldRating = (userData.ratings || {})[mangaId] || 0;
    
    if (oldRating > 0) {
        // Update existing rating
        ratingsData[mangaId].totalScore = ratingsData[mangaId].totalScore - oldRating + newRating;
    } else {
        // Add new rating
        ratingsData[mangaId].totalRatings++;
        ratingsData[mangaId].totalScore += newRating;
    }
    
    // Calculate new average
    ratingsData[mangaId].averageRating = (
        ratingsData[mangaId].totalScore / ratingsData[mangaId].totalRatings
    ).toFixed(2);
    
    // Save back to localStorage
    localStorage.setItem('mangaRatings', JSON.stringify(ratingsData));
}

/**
 * Get user rating for a manga
 */
function getUserRating(mangaId) {
    const userData = JSON.parse(localStorage.getItem('userData')) || {};
    return (userData.ratings || {})[mangaId] || 0;
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
function showLoginPrompt(message) {
    // You can customize this to match your site's design
    const loginUrl = '../login.html?redirect=' + encodeURIComponent(window.location.href);
    
    if (confirm(message + '\n\nWould you like to login now?')) {
        window.location.href = loginUrl;
    }
}

/**
 * Update all rating displays on the page
 */
function updateRatingDisplays() {
    // Update manga page rating display
    const ratingDisplay = document.querySelector('.manga-rating-score');
    if (ratingDisplay) {
        const mangaId = getMangaIdFromPage();
        const rating = getMangaRating(mangaId);
        
        if (rating) {
            ratingDisplay.textContent = `${rating.averageRating} (${formatRatingCount(rating.totalRatings)})`;
        }
    }
    
    // Update user action star if user has already rated
    updateUserRatingStar();
    
    // Update all manhwa card ratings
    updateManhwaCardRatings();
}

/**
 * Update the user's rating star
 */
function updateUserRatingStar() {
    const ratingAction = document.querySelector('.user-action i.fa-star');
    if (ratingAction) {
        const mangaId = getMangaIdFromPage();
        const userRating = getUserRating(mangaId);
        
        if (userRating > 0) {
            ratingAction.classList.remove('far');
            ratingAction.classList.add('fas');
            ratingAction.parentElement.classList.add('active');
        } else {
            ratingAction.classList.remove('fas');
            ratingAction.classList.add('far');
            ratingAction.parentElement.classList.remove('active');
        }
    }
}

/**
 * Update ratings on manhwa cards
 */
function updateManhwaCardRatings() {
    const ratingElements = document.querySelectorAll('.manhwa-card .stars span, .slider-item .stars span');
    
    ratingElements.forEach(element => {
        const card = element.closest('.manhwa-card, .slider-item');
        if (!card) return;
        
        // Try to get manga ID
        const mangaId = card.dataset.mangaId;
        if (!mangaId) return;
        
        // Get rating data
        const rating = getMangaRating(mangaId);
        if (rating) {
            element.textContent = rating.averageRating;
        }
    });
}

/**
 * Get manga rating data
 */
function getMangaRating(mangaId) {
    const ratingsData = JSON.parse(localStorage.getItem('mangaRatings')) || {};
    return ratingsData[mangaId];
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
 * Format large numbers with suffix (K, M)
 */
function formatRatingCount(count) {
    if (count >= 1000000) {
        return (count / 1000000).toFixed(1) + 'M';
    } else if (count >= 1000) {
        return (count / 1000).toFixed(1) + 'K';
    } else {
        return count;
    }
}

/**
 * Format all rating numbers on the page
 */
function formatRatingNumbers() {
    const viewElements = document.querySelectorAll('.manhwa-card .views span, .manga-rating-views span, .slider-item .views span');
    
    viewElements.forEach(element => {
        const text = element.textContent.trim();
        const number = parseInt(text.replace(/[^\d]/g, ''));
        
        if (!isNaN(number)) {
            element.textContent = formatView(number);
        }
    });
}

/**
 * Format view count
 */
function formatView(count) {
    if (count >= 1000000) {
        return (count / 1000000).toFixed(1) + 'M';
    } else if (count >= 1000) {
        return (count / 1000).toFixed(1) + 'K';
    } else {
        return count;
    }
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
window.Ratings = {
    updateRatingDisplays,
    formatRatingCount,
    formatView,
    showRatingModal
}; 