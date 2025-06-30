/**
 * TimeAgo.js
 * Handles relative time formatting for chapter dates
 */
document.addEventListener('DOMContentLoaded', function() {
    initTimeAgo();
});

/**
 * Initialize TimeAgo functionality
 */
function initTimeAgo() {
    updateAllTimeElements();
    
    // Update times every minute
    setInterval(updateAllTimeElements, 60000);
}

/**
 * Update all time elements
 */
function updateAllTimeElements() {
    // Find all chapter dates
    const chapterDates = document.querySelectorAll('.chapter-date');
    
    chapterDates.forEach(dateElement => {
        if (dateElement.dataset.timestamp) {
            const timestamp = dateElement.dataset.timestamp;
            dateElement.textContent = formatTimeAgo(timestamp);
        } else if (dateElement.textContent) {
            // If no data-timestamp attribute, try to parse the text content
            // Store original date if not already stored
            if (!dateElement.dataset.originalDate) {
                dateElement.dataset.originalDate = dateElement.textContent.trim();
            }
            
            // Try to parse the date
            const parsedDate = parseDate(dateElement.dataset.originalDate);
            if (parsedDate) {
                dateElement.dataset.timestamp = parsedDate.toISOString();
                dateElement.textContent = formatTimeAgo(parsedDate.toISOString());
            }
        }
    });
}

/**
 * Format a timestamp into a relative time string
 */
function formatTimeAgo(timestamp) {
    const date = new Date(timestamp);
    const now = new Date();
    
    // Check if date is valid
    if (isNaN(date.getTime())) {
        return '';
    }
    
    const seconds = Math.floor((now - date) / 1000);
    const minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);
    
    // Format based on how recent
    if (seconds < 60) {
        return 'Just now';
    } else if (minutes < 60) {
        return minutes + (minutes === 1 ? ' minute ago' : ' minutes ago');
    } else if (hours < 24) {
        return hours + (hours === 1 ? ' hour ago' : ' hours ago');
    } else if (hours < 48) {
        return 'Yesterday';
    } else if (hours < 72) {
        return '2 days ago';
    } else if (hours < 96) {
        return '3 days ago';
    } else {
        // Format based on month and year
        const thisYear = now.getFullYear();
        const dateYear = date.getFullYear();
        
        // Format month as Jan, Feb, etc.
        const month = date.toLocaleString('en-US', { month: 'short' });
        const day = date.getDate();
        
        if (dateYear === thisYear) {
            return `${month} ${day}`;
        } else {
            return `${month} ${day}, ${dateYear}`;
        }
    }
}

/**
 * Add "UP" tag for very recent chapters
 */
function addUpTag(element, timestamp) {
    const date = new Date(timestamp);
    const now = new Date();
    
    // Calculate hours difference
    const hoursDiff = Math.floor((now - date) / (1000 * 60 * 60));
    
    // If less than 24 hours old
    if (hoursDiff < 24) {
        const upTag = document.createElement('span');
        upTag.className = 'up-tag';
        upTag.textContent = 'UP';
        
        // Add UP tag before the time text
        element.parentNode.insertBefore(upTag, element);
    }
}

/**
 * Parse a date string into a Date object
 * Handles various formats:
 * - May 3, 24
 * - May 3, 2024
 * - 05/03/24
 * - 05/03/2024
 * - 2024-05-03
 * - etc.
 */
function parseDate(dateString) {
    // Already a date object
    if (dateString instanceof Date) {
        return dateString;
    }
    
    // Try standard date parsing
    let parsedDate = new Date(dateString);
    if (!isNaN(parsedDate.getTime())) {
        return parsedDate;
    }
    
    // Try to parse common date formats
    let match;
    
    // Format: May 3, 24 or May 3, 2024
    match = dateString.match(/([A-Za-z]+)\s+(\d{1,2}),\s+(\d{2,4})/);
    if (match) {
        const month = getMonthFromName(match[1]);
        const day = parseInt(match[2]);
        let year = parseInt(match[3]);
        
        // Handle 2-digit year
        if (year < 100) {
            year += 2000;
        }
        
        return new Date(year, month, day);
    }
    
    // Format: 05/03/24 or 05/03/2024
    match = dateString.match(/(\d{1,2})\/(\d{1,2})\/(\d{2,4})/);
    if (match) {
        const month = parseInt(match[1]) - 1; // JS months are 0-indexed
        const day = parseInt(match[2]);
        let year = parseInt(match[3]);
        
        // Handle 2-digit year
        if (year < 100) {
            year += 2000;
        }
        
        return new Date(year, month, day);
    }
    
    // Format: 2024-05-03
    match = dateString.match(/(\d{4})-(\d{1,2})-(\d{1,2})/);
    if (match) {
        const year = parseInt(match[1]);
        const month = parseInt(match[2]) - 1; // JS months are 0-indexed
        const day = parseInt(match[3]);
        
        return new Date(year, month, day);
    }
    
    // If all parsing attempts fail, return null
    return null;
}

/**
 * Convert month name to month index
 */
function getMonthFromName(name) {
    const months = {
        'jan': 0, 'january': 0,
        'feb': 1, 'february': 1,
        'mar': 2, 'march': 2,
        'apr': 3, 'april': 3,
        'may': 4,
        'jun': 5, 'june': 5,
        'jul': 6, 'july': 6,
        'aug': 7, 'august': 7,
        'sep': 8, 'september': 8,
        'oct': 9, 'october': 9,
        'nov': 10, 'november': 10,
        'dec': 11, 'december': 11
    };
    
    return months[name.toLowerCase()] || 0;
}

/**
 * Add UP badge to recent chapters
 */
function markRecentChapters() {
    const chapterItems = document.querySelectorAll('.chapter-item');
    
    chapterItems.forEach(item => {
        const dateElement = item.querySelector('.chapter-date');
        if (dateElement && dateElement.dataset.timestamp) {
            const timestamp = dateElement.dataset.timestamp;
            const date = new Date(timestamp);
            const now = new Date();
            
            // Calculate hours difference
            const hoursDiff = Math.floor((now - date) / (1000 * 60 * 60));
            
            // If less than 24 hours old
            if (hoursDiff < 24) {
                const chapterLink = item.querySelector('.chapter-link');
                if (chapterLink && !chapterLink.querySelector('.up-tag')) {
                    const upTag = document.createElement('span');
                    upTag.className = 'up-tag';
                    upTag.textContent = 'UP';
                    chapterLink.appendChild(upTag);
                }
            }
        }
    });
}

// Export functions for use in other files
window.TimeAgo = {
    formatTimeAgo,
    parseDate,
    addUpTag,
    markRecentChapters,
    updateAllTimeElements
}; 