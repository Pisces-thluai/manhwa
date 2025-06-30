/**
 * Family Mode
 * Handles toggling of adult content visibility
 */
document.addEventListener('DOMContentLoaded', function() {
    // Get family mode toggle buttons
    const familyModeBtn = document.getElementById('family-mode-btn');
    const mobileFamilyModeBtn = document.getElementById('mobile-family-mode-btn');
    
    // Check if we're on adult pages
    const isAdultPage = document.body.classList.contains('adult-page');
    
    // Check if family mode is enabled in local storage
    const isFamilyModeEnabled = localStorage.getItem('familyMode') === 'enabled';
    
    console.log('Family mode is ' + (isFamilyModeEnabled ? 'enabled' : 'disabled'));
    console.log('Found family-mode-btn:', familyModeBtn !== null);
    console.log('Found mobile-family-mode-btn:', mobileFamilyModeBtn !== null);
    
    // Update button states initially
    if (familyModeBtn) {
        if (isFamilyModeEnabled) {
            familyModeBtn.classList.add('active');
        } else {
            familyModeBtn.classList.remove('active');
        }
    }
    
    if (mobileFamilyModeBtn) {
        if (isFamilyModeEnabled) {
            mobileFamilyModeBtn.classList.add('active');
        } else {
            mobileFamilyModeBtn.classList.remove('active');
        }
    }
    
    // Desktop family mode toggle
    if (familyModeBtn) {
        familyModeBtn.addEventListener('click', function() {
            console.log('Family mode button clicked');
            toggleFamilyMode();
        });
    }
    
    // Mobile family mode toggle
    if (mobileFamilyModeBtn) {
        mobileFamilyModeBtn.addEventListener('click', function() {
            console.log('Mobile family mode button clicked');
            toggleFamilyMode();
        });
    }
    
    function toggleFamilyMode() {
        const currentlyEnabled = localStorage.getItem('familyMode') === 'enabled';
        const newState = !currentlyEnabled;
        
        console.log('Toggling family mode from', currentlyEnabled, 'to', newState);
        
        // Save the new state
        localStorage.setItem('familyMode', newState ? 'enabled' : 'disabled');
        
        // Update button states immediately
        if (familyModeBtn) {
            familyModeBtn.classList.toggle('active', newState);
        }
        
        if (mobileFamilyModeBtn) {
            mobileFamilyModeBtn.classList.toggle('active', newState);
        }
        
        // Show toast notification
        showToast('Family Mode ' + (newState ? 'Enabled' : 'Disabled'));
        
        // Redirect to appropriate page when toggling Family Mode
        if (isAdultPage && newState) {
            // If we're on adult page and enabling family mode, go to main site
            redirectToFamilyPage();
        } else if (!isAdultPage && !newState) {
            // If we're on main site and disabling family mode, go to adult site
            redirectToAdultPage();
        }
    }
    
    function showToast(message, duration = 2000) {
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
    
    function redirectToFamilyPage() {
        console.log('Redirecting to family page');
        
        // Get current URL path
        const currentPath = window.location.pathname;
        
        // Map adult pages to their family-friendly equivalents (main site)
        if (currentPath.includes('/adult/')) {
            // Replace /adult/ with / in the path
            const familyPath = currentPath.replace('/adult/', '/');
            console.log('Redirecting from', currentPath, 'to', familyPath);
            window.location.href = familyPath;
            return;
        }
        
        // Handle specific adult pages
        const adultToFamilyMap = {
            '/adult/index.html': '/index.html',
            '/adult/': '/',
            '/adult.html': '/index.html',
            '/adult/pages/page-10.html': '/pages/page-10.html',
        };
        
        if (adultToFamilyMap[currentPath]) {
            console.log('Redirecting from', currentPath, 'to', adultToFamilyMap[currentPath]);
            window.location.href = adultToFamilyMap[currentPath];
            return;
        }
        
        // Default fallback - go to family homepage
        console.log('Default redirect to family homepage');
        window.location.href = '/index.html';
    }
    
    function redirectToAdultPage() {
        console.log('Redirecting to adult page');
        
        // Get current URL path
        const currentPath = window.location.pathname;
        
        // Map main pages to their adult equivalents
        const familyToAdultMap = {
            '/index.html': '/adult/index.html',
            '/': '/adult/',
            '/pages/page-10.html': '/adult/pages/page-10.html',
        };
        
        if (familyToAdultMap[currentPath]) {
            console.log('Redirecting from', currentPath, 'to', familyToAdultMap[currentPath]);
            window.location.href = familyToAdultMap[currentPath];
            return;
        }
        
        // If we can't find a specific mapping, try a default approach
        if (currentPath.endsWith('.html')) {
            const basePath = currentPath.substring(0, currentPath.length - 5);
            const adultPath = '/adult' + basePath + '.html';
            console.log('Redirecting from', currentPath, 'to', adultPath);
            window.location.href = adultPath;
        } else {
            // Default fallback - go to adult homepage
            console.log('Default redirect to adult homepage');
            window.location.href = '/adult/index.html';
        }
    }
});

/**
 * Initialize family mode functionality
 */
function initFamilyMode() {
    // Check current status
    const familyModeEnabled = localStorage.getItem('familyMode') === 'enabled';
    
    // Apply current state
    applyFamilyMode(familyModeEnabled);
    
    // Set up toggle buttons
    const familyModeButtons = document.querySelectorAll('.family-mode-button, .family-mode-toggle-mobile, #family-mode-btn, #mobile-family-mode-btn');
    
    familyModeButtons.forEach(button => {
        updateFamilyModeButton(button, familyModeEnabled);
        
        button.addEventListener('click', function() {
            const currentState = localStorage.getItem('familyMode') === 'enabled';
            const newState = !currentState;
            
            // Update localStorage
            localStorage.setItem('familyMode', newState ? 'enabled' : 'disabled');
            
            // Apply changes
            applyFamilyMode(newState);
            
            // Update all buttons
            familyModeButtons.forEach(btn => {
                updateFamilyModeButton(btn, newState);
            });
            
            // Show toast notification
            showFamilyModeToast(newState);
        });
    });
}

/**
 * Apply family mode state
 */
function applyFamilyMode(enabled) {
    document.body.classList.toggle('family-mode', enabled);
    
    // Hide/show adult content based on family mode
    const adultContent = document.querySelectorAll('.adult-content, .adult-category-link');
    
    adultContent.forEach(element => {
        if (enabled) {
            element.classList.add('hidden');
        } else {
            element.classList.remove('hidden');
        }
    });
}

/**
 * Update family mode button state
 */
function updateFamilyModeButton(button, enabled) {
    if (enabled) {
        button.classList.add('active');
    } else {
        button.classList.remove('active');
    }
}

/**
 * Show toast notification for family mode toggle
 */
function showFamilyModeToast(enabled) {
    // Create toast if it doesn't exist
    let toast = document.querySelector('.toast');
    
    if (!toast) {
        toast = document.createElement('div');
        toast.className = 'toast';
        document.body.appendChild(toast);
    }
    
    // Set message based on state
    const message = enabled ? 'Family Mode enabled. Adult content hidden.' : 'Family Mode disabled. Adult content visible.';
    
    // Set message and show
    toast.textContent = message;
    toast.classList.add('show');
    
    // Hide after duration
    setTimeout(() => {
        toast.classList.remove('show');
    }, 3000);
}

/**
 * Check if family mode is enabled
 */
function isFamilyModeEnabled() {
    return localStorage.getItem('familyMode') === 'enabled';
}

/**
 * Filter content based on family mode
 * This can be used to conditionally show/hide content when loading new elements
 */
function filterContentByFamilyMode(elementArray, adultContentSelector = '.adult-content') {
    const familyModeEnabled = isFamilyModeEnabled();
    
    if (!familyModeEnabled) return elementArray;
    
    // Filter out adult content
    return Array.from(elementArray).filter(element => {
        return !element.classList.contains('adult-content') && 
              !element.querySelector(adultContentSelector);
    });
}

/**
 * Mark content as adult
 */
function markContentAsAdult(element) {
    if (!element) return;
    
    element.classList.add('adult-content');
    
    // Hide if family mode is enabled
    if (isFamilyModeEnabled()) {
        element.classList.add('hidden');
    }
}

/**
 * Apply family mode to newly added content
 */
function applyFamilyModeToNewContent(container) {
    const adultContent = container.querySelectorAll('.adult-content, .adult-category-link');
    const familyModeEnabled = isFamilyModeEnabled();
    
    if (!familyModeEnabled) return;
    
    adultContent.forEach(element => {
        element.classList.add('hidden');
    });
}

// Export functions for use in other files
window.FamilyMode = {
    isFamilyModeEnabled,
    applyFamilyMode,
    filterContentByFamilyMode,
    markContentAsAdult,
    applyFamilyModeToNewContent
}; 