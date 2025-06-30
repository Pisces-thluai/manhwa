/**
 * Comments System
 * Placeholder for Disqus integration
 */
document.addEventListener('DOMContentLoaded', function() {
    initCommentsSection();
});

/**
 * Initialize the comments section
 */
function initCommentsSection() {
    const contentContainer = document.querySelector('.chapter-content, .manga-content');
    if (!contentContainer) return;
    
    // Create comments section if it doesn't exist
    let commentsSection = document.querySelector('.comments-section');
    if (!commentsSection) {
        commentsSection = document.createElement('div');
        commentsSection.className = 'comments-section';
        contentContainer.after(commentsSection);
    }
    
    // Add Disqus placeholder
    commentsSection.innerHTML = `
        <div class="comments-container">
            <div class="disqus-notice">
                <div class="notice-box">
                    <i class="fas fa-exclamation-circle"></i>
                    <p>Disqus isn't available at the moment on our website. We are looking into a solution.</p>
                </div>
            </div>
            <div class="comments-login-area">
                <h3>Comments</h3>
                <div class="login-prompt">
                    <p>Please <a href="${getRelativePath('login.html')}">login</a> to leave a comment.</p>
                </div>
            </div>
            <div class="comments-form" style="display: none;">
                <textarea placeholder="Write your comment here..."></textarea>
                <div class="comment-actions">
                    <button class="btn-submit-comment">Submit</button>
                </div>
            </div>
            <div class="comments-list">
                <!-- Comments will be loaded here -->
                <div class="no-comments-message">No comments yet. Be the first to comment!</div>
            </div>
        </div>
    `;
    
    // Check if user is logged in (demo)
    if (localStorage.getItem('isLoggedIn') === 'true') {
        showCommentForm();
    }
    
    // Add event listeners
    const commentForm = commentsSection.querySelector('.comments-form');
    if (commentForm) {
        const submitBtn = commentForm.querySelector('.btn-submit-comment');
        submitBtn.addEventListener('click', submitComment);
    }
    
    // Load demo comments
    loadComments();
}

/**
 * Show the comment form for logged in users
 */
function showCommentForm() {
    const loginArea = document.querySelector('.login-prompt');
    const commentForm = document.querySelector('.comments-form');
    
    if (loginArea && commentForm) {
        loginArea.style.display = 'none';
        commentForm.style.display = 'block';
    }
}

/**
 * Submit a new comment (demo)
 */
function submitComment() {
    const textarea = document.querySelector('.comments-form textarea');
    if (!textarea || !textarea.value.trim()) {
        showToast('Please write a comment before submitting');
        return;
    }
    
    const commentData = {
        user: localStorage.getItem('username') || 'User',
        content: textarea.value.trim(),
        date: new Date().toISOString(),
        likes: 0,
        page: window.location.pathname
    };
    
    // Save to localStorage for demo
    const comments = JSON.parse(localStorage.getItem('pageComments') || '{}');
    const pageComments = comments[window.location.pathname] || [];
    pageComments.unshift(commentData);
    comments[window.location.pathname] = pageComments;
    
    localStorage.setItem('pageComments', JSON.stringify(comments));
    
    // Clear form and reload comments
    textarea.value = '';
    loadComments();
    showToast('Comment posted successfully!');
}

/**
 * Load comments for the current page (demo)
 */
function loadComments() {
    const commentsList = document.querySelector('.comments-list');
    if (!commentsList) return;
    
    // Get comments from localStorage
    const comments = JSON.parse(localStorage.getItem('pageComments') || '{}');
    const pageComments = comments[window.location.pathname] || [];
    
    if (pageComments.length === 0) {
        commentsList.innerHTML = '<div class="no-comments-message">No comments yet. Be the first to comment!</div>';
        return;
    }
    
    // Create HTML for comments
    let commentsHTML = '';
    pageComments.forEach(comment => {
        const date = new Date(comment.date);
        const dateStr = formatCommentDate(date);
        
        commentsHTML += `
            <div class="comment">
                <div class="comment-header">
                    <div class="comment-user">${comment.user}</div>
                    <div class="comment-date">${dateStr}</div>
                </div>
                <div class="comment-content">${comment.content}</div>
                <div class="comment-actions">
                    <button class="like-btn" data-date="${comment.date}">
                        <i class="far fa-heart"></i> <span>${comment.likes}</span>
                    </button>
                    <button class="reply-btn" data-date="${comment.date}">
                        <i class="far fa-comment"></i> Reply
                    </button>
                </div>
            </div>
        `;
    });
    
    commentsList.innerHTML = commentsHTML;
    
    // Add event listeners to like buttons
    const likeButtons = commentsList.querySelectorAll('.like-btn');
    likeButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            const date = this.dataset.date;
            likeComment(date);
        });
    });
}

/**
 * Like a comment (demo)
 */
function likeComment(commentDate) {
    const comments = JSON.parse(localStorage.getItem('pageComments') || '{}');
    const pageComments = comments[window.location.pathname] || [];
    
    const commentIndex = pageComments.findIndex(c => c.date === commentDate);
    if (commentIndex !== -1) {
        pageComments[commentIndex].likes++;
        comments[window.location.pathname] = pageComments;
        localStorage.setItem('pageComments', JSON.stringify(comments));
        
        // Update UI
        const likeBtn = document.querySelector(`.like-btn[data-date="${commentDate}"]`);
        if (likeBtn) {
            const likeCount = likeBtn.querySelector('span');
            likeCount.textContent = pageComments[commentIndex].likes;
        }
    }
}

/**
 * Format date for comments
 */
function formatCommentDate(date) {
    const now = new Date();
    const diffMs = now - date;
    const diffSecs = Math.floor(diffMs / 1000);
    const diffMins = Math.floor(diffSecs / 60);
    const diffHours = Math.floor(diffMins / 60);
    const diffDays = Math.floor(diffHours / 24);
    
    if (diffSecs < 60) {
        return 'Just now';
    } else if (diffMins < 60) {
        return `${diffMins} minute${diffMins > 1 ? 's' : ''} ago`;
    } else if (diffHours < 24) {
        return `${diffHours} hour${diffHours > 1 ? 's' : ''} ago`;
    } else if (diffDays < 7) {
        return `${diffDays} day${diffDays > 1 ? 's' : ''} ago`;
    } else {
        return date.toLocaleDateString('en-US', {
            year: 'numeric', 
            month: 'short', 
            day: 'numeric'
        });
    }
}

/**
 * Get the relative path to another file
 */
function getRelativePath(targetPath) {
    // Get current path depth
    const pathParts = window.location.pathname.split('/');
    const depth = pathParts.length - 2; // -1 for the file itself, -1 because array is 0-indexed
    
    // For root-level pages, no prefix needed
    if (depth <= 0) {
        return targetPath;
    }
    
    // For deeper pages, add the appropriate number of "../"
    let prefix = '';
    for (let i = 0; i < depth; i++) {
        prefix += '../';
    }
    
    return prefix + targetPath;
} 