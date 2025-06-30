/**
 * Comments System
 * Integrates with Disqus for comments
 */
document.addEventListener('DOMContentLoaded', function() {
    initDisqusComments();
});

/**
 * Initialize Disqus comments
 */
function initDisqusComments() {
    // Check if comments section exists
    const commentsSection = document.querySelector('.comments-section');
    if (!commentsSection) return;
    
    // Check if Disqus is available
    if (typeof DISQUS === 'undefined') {
        // Disqus is not loaded, show placeholder
        commentsSection.innerHTML = `
            <div class="disqus-placeholder">
                <p>Disqus isn't available at the moment on our website. We are looking into a solution.</p>
                <button class="load-comments-btn">Try Loading Comments</button>
            </div>
        `;
        
        // Add event listener to try loading comments
        const loadBtn = commentsSection.querySelector('.load-comments-btn');
        if (loadBtn) {
            loadBtn.addEventListener('click', attemptLoadDisqus);
        }
    }
}

/**
 * Attempt to load Disqus comments
 */
function attemptLoadDisqus() {
    const commentsSection = document.querySelector('.comments-section');
    if (!commentsSection) return;
    
    commentsSection.innerHTML = '<div id="disqus_thread"></div>';
    
    try {
        // This is a placeholder for Disqus integration code
        // In a real app, you would use your Disqus shortname
        const disqusShortname = 'toonily-clone';
        const disqusConfig = function() {
            this.page.url = window.location.href;
            this.page.identifier = window.location.pathname;
        };
        
        // Try to load Disqus
        (function() {
            const d = document, s = d.createElement('script');
            s.src = 'https://' + disqusShortname + '.disqus.com/embed.js';
            s.setAttribute('data-timestamp', +new Date());
            (d.head || d.body).appendChild(s);
        })();
        
        // If Disqus doesn't load within 5 seconds, show error
        setTimeout(() => {
            if (document.querySelector('#disqus_thread') && document.querySelector('#disqus_thread').children.length === 0) {
                document.querySelector('#disqus_thread').innerHTML = `
                    <div class="disqus-error">
                        <p>Comments couldn't be loaded. Please try again later.</p>
                    </div>
                `;
            }
        }, 5000);
    } catch (e) {
        console.error('Error loading Disqus:', e);
        commentsSection.innerHTML = `
            <div class="disqus-error">
                <p>There was an error loading comments. Please try again later.</p>
            </div>
        `;
    }
}

/**
 * Add comments section to current page if it doesn't exist
 */
function addCommentsSection() {
    // Check if we're on a manga or chapter page
    const isContentPage = document.querySelector('.manga-content, .chapter-content');
    if (!isContentPage) return;
    
    // Check if comments section already exists
    if (document.querySelector('.comments-section')) return;
    
    // Create comments section
    const commentsSection = document.createElement('div');
    commentsSection.className = 'comments-section';
    commentsSection.innerHTML = `
        <div class="section-title">
            <h2>Comments</h2>
        </div>
        <div class="disqus-placeholder">
            <p>Disqus isn't available at the moment on our website. We are looking into a solution.</p>
            <button class="load-comments-btn">Try Loading Comments</button>
        </div>
    `;
    
    // Add comments section to the page
    const contentContainer = document.querySelector('.manga-content, .chapter-content');
    contentContainer.appendChild(commentsSection);
    
    // Add event listener to try loading comments
    const loadBtn = commentsSection.querySelector('.load-comments-btn');
    if (loadBtn) {
        loadBtn.addEventListener('click', attemptLoadDisqus);
    }
}

// Export functions for use in other files
window.Comments = {
    initDisqusComments,
    addCommentsSection
}; 