/**
 * Report System
 * Handles chapter and content reporting
 */
document.addEventListener('DOMContentLoaded', function() {
    initReportSystem();
});

/**
 * Initialize report system
 */
function initReportSystem() {
    setupReportButtons();
    createReportModal();
}

/**
 * Set up report buttons
 */
function setupReportButtons() {
    const reportButtons = document.querySelectorAll('.report-chapter');
    
    reportButtons.forEach(button => {
        button.addEventListener('click', showReportModal);
    });
}

/**
 * Create report modal
 */
function createReportModal() {
    // Create modal if it doesn't exist
    if (!document.querySelector('.report-modal')) {
        const modalHtml = `
            <div class="report-modal">
                <div class="report-container">
                    <div class="report-header">
                        <h3>Report Chapter</h3>
                        <button class="close-report"><i class="fas fa-times"></i></button>
                    </div>
                    <div class="report-form">
                        <div class="report-options">
                            <p>Reason:</p>
                            <div class="report-option">
                                <input type="radio" id="report-missing" name="report-reason" value="missing">
                                <label for="report-missing">Missing pages</label>
                            </div>
                            <div class="report-option">
                                <input type="radio" id="report-loading" name="report-reason" value="loading">
                                <label for="report-loading">Images not loading</label>
                            </div>
                            <div class="report-option">
                                <input type="radio" id="report-wrong" name="report-reason" value="wrong">
                                <label for="report-wrong">Wrong chapter</label>
                            </div>
                            <div class="report-option">
                                <input type="radio" id="report-other" name="report-reason" value="other">
                                <label for="report-other">Other</label>
                            </div>
                        </div>
                        <div class="report-comment">
                            <p>Your Comment:</p>
                            <textarea placeholder="Provide additional details..."></textarea>
                        </div>
                        <div class="report-actions">
                            <button class="btn-submit-report">Submit</button>
                            <button class="btn-cancel-report">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        // Append modal to body
        const modalElement = document.createElement('div');
        modalElement.innerHTML = modalHtml;
        document.body.appendChild(modalElement.firstElementChild);
        
        // Set up event listeners
        const closeBtn = document.querySelector('.close-report');
        const cancelBtn = document.querySelector('.btn-cancel-report');
        const submitBtn = document.querySelector('.btn-submit-report');
        
        if (closeBtn) {
            closeBtn.addEventListener('click', hideReportModal);
        }
        
        if (cancelBtn) {
            cancelBtn.addEventListener('click', hideReportModal);
        }
        
        if (submitBtn) {
            submitBtn.addEventListener('click', submitReport);
        }
    }
}

/**
 * Show report modal
 */
function showReportModal() {
    const modal = document.querySelector('.report-modal');
    if (modal) {
        // Reset form
        const radioButtons = modal.querySelectorAll('input[type="radio"]');
        radioButtons.forEach(radio => radio.checked = false);
        
        const commentBox = modal.querySelector('textarea');
        if (commentBox) {
            commentBox.value = '';
        }
        
        // Show modal
        modal.classList.add('active');
        
        // Store chapter info
        const chapterTitle = document.querySelector('.chapter-title h1')?.textContent || document.title;
        modal.dataset.chapterTitle = chapterTitle;
        
        const chapterUrl = window.location.href;
        modal.dataset.chapterUrl = chapterUrl;
    }
}

/**
 * Hide report modal
 */
function hideReportModal() {
    const modal = document.querySelector('.report-modal');
    if (modal) {
        modal.classList.remove('active');
    }
}

/**
 * Submit report
 */
function submitReport() {
    const modal = document.querySelector('.report-modal');
    if (!modal) return;
    
    // Get selected reason
    const selectedReason = modal.querySelector('input[name="report-reason"]:checked')?.value;
    
    // Get comment
    const comment = modal.querySelector('textarea')?.value || '';
    
    // Validate
    if (!selectedReason) {
        alert('Please select a reason for your report.');
        return;
    }
    
    // Get chapter info
    const chapterTitle = modal.dataset.chapterTitle || '';
    const chapterUrl = modal.dataset.chapterUrl || '';
    
    // In a real app, this would send data to a server
    // For this demo, we'll just show a success message
    console.log('Submitting report:', {
        reason: selectedReason,
        comment: comment,
        chapterTitle: chapterTitle,
        chapterUrl: chapterUrl
    });
    
    // Hide modal
    hideReportModal();
    
    // Show confirmation
    showToast('Your report has been submitted. Thank you!');
}

/**
 * Add report button to chapter if it doesn't exist
 */
function addReportButton() {
    // Check if we're on a chapter page
    const isChapterPage = document.querySelector('.chapter-content');
    if (!isChapterPage) return;
    
    // Check if report button already exists
    if (document.querySelector('.report-chapter')) return;
    
    // Create report button
    const reportButton = document.createElement('button');
    reportButton.className = 'report-chapter';
    reportButton.innerHTML = '<i class="fas fa-flag"></i> Report Chapter';
    
    // Add event listener
    reportButton.addEventListener('click', showReportModal);
    
    // Add to chapter actions
    const chapterActions = document.querySelector('.chapter-actions');
    if (chapterActions) {
        chapterActions.appendChild(reportButton);
    } else {
        // Create chapter actions if it doesn't exist
        const chapterActionsDiv = document.createElement('div');
        chapterActionsDiv.className = 'chapter-actions';
        chapterActionsDiv.appendChild(reportButton);
        
        // Add chapter actions before chapter content
        const chapterContent = document.querySelector('.chapter-content');
        if (chapterContent) {
            chapterContent.parentNode.insertBefore(chapterActionsDiv, chapterContent);
        }
    }
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
window.Report = {
    addReportButton,
    showReportModal
};
