##
# Update-All-Sites.ps1
# PowerShell script to apply all new features across the site
##

# Display start message
Write-Host "Starting site-wide update to apply all new features..." -ForegroundColor Green

# Create js directory if it doesn't exist
if (-not (Test-Path "js")) {
    Write-Host "Creating js directory..." -ForegroundColor Yellow
    New-Item -Path "js" -ItemType Directory
}

# Create css directory if it doesn't exist
if (-not (Test-Path "css")) {
    Write-Host "Creating css directory..." -ForegroundColor Yellow
    New-Item -Path "css" -ItemType Directory
}

# Copy files from root to js directory if they exist
$jsFiles = @(
    "auth.js",
    "timeago.js",
    "pagination.js",
    "ratings.js", 
    "views.js",
    "search.js",
    "bookmarks.js",
    "family-mode.js",
    "report.js",
    "comments.js"
)

foreach ($file in $jsFiles) {
    if (Test-Path $file) {
        Write-Host "Moving $file to js directory..." -ForegroundColor Yellow
        Move-Item -Path $file -Destination "js/$file" -Force
    } elseif (-not (Test-Path "js/$file")) {
        Write-Host "Creating empty $file in js directory..." -ForegroundColor Yellow
        New-Item -Path "js/$file" -ItemType File
    }
}

# Copy CSS files to css directory
$cssFiles = @(
    "auth.css",
    "search.css"
)

foreach ($file in $cssFiles) {
    if (Test-Path $file) {
        Write-Host "Moving $file to css directory..." -ForegroundColor Yellow
        Move-Item -Path $file -Destination "css/$file" -Force
    } elseif (-not (Test-Path "css/$file")) {
        Write-Host "Creating empty $file in css directory..." -ForegroundColor Yellow
        New-Item -Path "css/$file" -ItemType File
    }
}

# Create HTML files if they don't exist
$htmlFiles = @(
    "login.html",
    "register.html",
    "search.html",
    "bookmarks.html"
)

foreach ($file in $htmlFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "Creating empty $file..." -ForegroundColor Yellow
        New-Item -Path $file -ItemType File
    }
}

# Update all manga pages to include new features
Write-Host "Updating all manga pages..." -ForegroundColor Yellow
$mangaFiles = Get-ChildItem -Path "manga" -Filter "*.html"

foreach ($file in $mangaFiles) {
    Write-Host "Updating $($file.Name)..." -ForegroundColor Cyan
    
    # Read file content
    $content = Get-Content -Path $file.FullName -Raw
    $updated = $false
    
    # Add script tags for new features if they don't exist
    if (-not ($content -match "<script src=`"../js/ratings.js`"></script>")) {
        $content = $content -replace "</body>", "<script src=`"../js/ratings.js`"></script>`n</body>"
        $updated = $true
    }
    
    if (-not ($content -match "<script src=`"../js/views.js`"></script>")) {
        $content = $content -replace "</body>", "<script src=`"../js/views.js`"></script>`n</body>"
        $updated = $true
    }
    
    if (-not ($content -match "<script src=`"../js/bookmarks.js`"></script>")) {
        $content = $content -replace "</body>", "<script src=`"../js/bookmarks.js`"></script>`n</body>"
        $updated = $true
    }
    
    if (-not ($content -match "<script src=`"../js/timeago.js`"></script>")) {
        $content = $content -replace "</body>", "<script src=`"../js/timeago.js`"></script>`n</body>"
        $updated = $true
    }
    
    if (-not ($content -match "<script src=`"../js/comments.js`"></script>")) {
        $content = $content -replace "</body>", "<script src=`"../js/comments.js`"></script>`n</body>"
        $updated = $true
    }
    
    # Add Discord link in footer if it doesn't exist
    if (-not ($content -match "Discord</a>")) {
        $content = $content -replace "<div class=`"footer-nav`">", "<div class=`"footer-nav`">`n                <a href=`"https://discord.gg/toonily`" target=`"_blank`">Discord</a>"
        $updated = $true
    }
    
    # Write updated content back to file if changes were made
    if ($updated) {
        Set-Content -Path $file.FullName -Value $content
        Write-Host "  - Updated $($file.Name)" -ForegroundColor Green
    } else {
        Write-Host "  - No changes needed for $($file.Name)" -ForegroundColor Gray
    }
}

# Update all chapter pages to include new features
Write-Host "Updating all chapter pages..." -ForegroundColor Yellow
$chapterDirs = Get-ChildItem -Path "chapters" -Directory

foreach ($dir in $chapterDirs) {
    $chapterFiles = Get-ChildItem -Path $dir.FullName -Filter "*.html"
    
    foreach ($file in $chapterFiles) {
        Write-Host "Updating $($dir.Name)/$($file.Name)..." -ForegroundColor Cyan
        
        # Read file content
        $content = Get-Content -Path $file.FullName -Raw
        $updated = $false
        
        # Add script tags for new features if they don't exist
        if (-not ($content -match "<script src=`"../../js/views.js`"></script>")) {
            $content = $content -replace "</body>", "<script src=`"../../js/views.js`"></script>`n</body>"
            $updated = $true
        }
        
        if (-not ($content -match "<script src=`"../../js/bookmarks.js`"></script>")) {
            $content = $content -replace "</body>", "<script src=`"../../js/bookmarks.js`"></script>`n</body>"
            $updated = $true
        }
        
        if (-not ($content -match "<script src=`"../../js/timeago.js`"></script>")) {
            $content = $content -replace "</body>", "<script src=`"../../js/timeago.js`"></script>`n</body>"
            $updated = $true
        }
        
        if (-not ($content -match "<script src=`"../../js/comments.js`"></script>")) {
            $content = $content -replace "</body>", "<script src=`"../../js/comments.js`"></script>`n</body>"
            $updated = $true
        }
        
        if (-not ($content -match "<script src=`"../../js/report.js`"></script>")) {
            $content = $content -replace "</body>", "<script src=`"../../js/report.js`"></script>`n</body>"
            $updated = $true
        }
        
        # Add report button if it doesn't exist
        if (-not ($content -match "report-chapter")) {
            $reportButtonHtml = @"
<div class="chapter-actions">
    <button class="report-chapter">
        <i class="fas fa-flag"></i> Report Chapter
    </button>
</div>
"@
            $content = $content -replace "(<div class=`"chapter-content`">)", "$reportButtonHtml`n`$1"
            $updated = $true
        }
        
        # Add Discord link in footer if it doesn't exist
        if (-not ($content -match "Discord</a>")) {
            $content = $content -replace "<div class=`"footer-nav`">", "<div class=`"footer-nav`">`n                <a href=`"https://discord.gg/toonily`" target=`"_blank`">Discord</a>"
            $updated = $true
        }
        
        # Write updated content back to file if changes were made
        if ($updated) {
            Set-Content -Path $file.FullName -Value $content
            Write-Host "  - Updated $($dir.Name)/$($file.Name)" -ForegroundColor Green
        } else {
            Write-Host "  - No changes needed for $($dir.Name)/$($file.Name)" -ForegroundColor Gray
        }
    }
}

# Update index.html to include new features
Write-Host "Updating index.html..." -ForegroundColor Yellow
if (Test-Path "index.html") {
    $content = Get-Content -Path "index.html" -Raw
    $updated = $false
    
    # Add script tags for new features if they don't exist
    if (-not ($content -match "<script src=`"js/ratings.js`"></script>")) {
        $content = $content -replace "</body>", "<script src=`"js/ratings.js`"></script>`n</body>"
        $updated = $true
    }
    
    if (-not ($content -match "<script src=`"js/views.js`"></script>")) {
        $content = $content -replace "</body>", "<script src=`"js/views.js`"></script>`n</body>"
        $updated = $true
    }
    
    if (-not ($content -match "<script src=`"js/timeago.js`"></script>")) {
        $content = $content -replace "</body>", "<script src=`"js/timeago.js`"></script>`n</body>"
        $updated = $true
    }
    
    if (-not ($content -match "<script src=`"js/comments.js`"></script>")) {
        $content = $content -replace "</body>", "<script src=`"js/comments.js`"></script>`n</body>"
        $updated = $true
    }
    
    # Add Discord link in footer if it doesn't exist
    if (-not ($content -match "Discord</a>")) {
        $content = $content -replace "<div class=`"footer-nav`">", "<div class=`"footer-nav`">`n            <a href=`"https://discord.gg/toonily`" target=`"_blank`">Discord</a>"
        $updated = $true
    }
    
    # Write updated content back to file if changes were made
    if ($updated) {
        Set-Content -Path "index.html" -Value $content
        Write-Host "  - Updated index.html" -ForegroundColor Green
    } else {
        Write-Host "  - No changes needed for index.html" -ForegroundColor Gray
    }
}

# Update family mode functionality
Write-Host "Checking family mode implementation..." -ForegroundColor Yellow

# Check if family mode scripts exist and are running the latest versions
if (-not (Test-Path "js/family-mode.js")) {
    Write-Host "Creating family-mode.js..." -ForegroundColor Yellow
    
    $familyModeJs = @"
/**
 * Family Mode
 * Handles toggling of adult content visibility
 */
document.addEventListener('DOMContentLoaded', function() {
    initFamilyMode();
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
    const familyModeButtons = document.querySelectorAll('.family-mode-button, .family-mode-toggle-mobile');
    
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
"@
    
    Set-Content -Path "js/family-mode.js" -Value $familyModeJs
}

# Run existing family mode scripts
& .\add_family_mode_to_chapters.ps1
& .\add_family_mode_to_manga.ps1
& .\add_family_mode_to_pages.ps1

# Create report.js if it doesn't exist
if (-not (Test-Path "js/report.js")) {
    Write-Host "Creating report.js..." -ForegroundColor Yellow
    
    $reportJs = @"
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
"@
    
    Set-Content -Path "js/report.js" -Value $reportJs
}

# Create comments.js if it doesn't exist
if (-not (Test-Path "js/comments.js")) {
    Write-Host "Creating comments.js..." -ForegroundColor Yellow
    
    $commentsJs = @"
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
"@
    
    Set-Content -Path "js/comments.js" -Value $commentsJs
}

# Create manga-games.html if it doesn't exist
if (-not (Test-Path "manga-games.html")) {
    Write-Host "Creating manga-games.html..." -ForegroundColor Yellow
    
    $mangaGamesHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manga Games - Toonily Clone</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <header>
        <div class="header-container">
            <div class="logo">
                <a href="index.html">
                    <img src="images/logo.png" alt="Toonily Clone">
                </a>
            </div>
            
            <div class="family-mode-toggle">
                <button id="family-mode-btn">Family Mode</button>
            </div>
            
            <nav class="main-nav">
                <ul>
                    <li><a href="index.html">Home</a></li>
                    <li class="dropdown">
                        <a href="#">Manhwa</a>
                        <div class="dropdown-content">
                            <a href="search.html">Search</a>
                            <a href="new.html">New</a>
                            <a href="trending.html">Trending</a>
                            <a href="completed.html">Completed</a>
                        </div>
                    </li>
                    <li><a href="manga-games.html" class="active">Manga Games</a></li>
                </ul>
            </nav>
            
            <div class="header-right">
                <div class="search-toggle">
                    <i class="fas fa-search"></i>
                </div>
                <div class="auth-links">
                    <a href="login.html">Login</a>
                    <a href="register.html">Register</a>
                </div>
                <div class="menu-toggle">
                    <i class="fas fa-bars"></i>
                </div>
            </div>
        </div>
    </header>
    
    <div class="search-overlay">
        <div class="search-container">
            <input type="text" placeholder="Search titles, authors, genres...">
            <button class="search-btn"><i class="fas fa-search"></i></button>
            <div class="close-search"><i class="fas fa-times"></i></div>
        </div>
    </div>
    
    <main>
        <div class="manga-games-page">
            <div class="page-header">
                <h1>Manga Games</h1>
                <p>Play free manga and anime-inspired games!</p>
            </div>
            
            <div class="games-grid">
                <div class="game-card">
                    <div class="game-thumbnail">
                        <img src="images/games/game1.jpg" alt="Game 1">
                        <div class="game-overlay">
                            <button class="play-button">Play Now</button>
                        </div>
                    </div>
                    <div class="game-info">
                        <h3>Anime Battle Arena</h3>
                        <p>Fighting game with popular anime characters</p>
                        <div class="game-meta">
                            <span class="game-rating">
                                <i class="fas fa-star"></i> 4.8
                            </span>
                            <span class="game-plays">
                                <i class="fas fa-gamepad"></i> 250K
                            </span>
                        </div>
                    </div>
                </div>
                
                <div class="game-card">
                    <div class="game-thumbnail">
                        <img src="images/games/game2.jpg" alt="Game 2">
                        <div class="game-overlay">
                            <button class="play-button">Play Now</button>
                        </div>
                    </div>
                    <div class="game-info">
                        <h3>Manga Puzzle</h3>
                        <p>Solve puzzles featuring your favorite manga characters</p>
                        <div class="game-meta">
                            <span class="game-rating">
                                <i class="fas fa-star"></i> 4.5
                            </span>
                            <span class="game-plays">
                                <i class="fas fa-gamepad"></i> 180K
                            </span>
                        </div>
                    </div>
                </div>
                
                <div class="game-card">
                    <div class="game-thumbnail">
                        <img src="images/games/game3.jpg" alt="Game 3">
                        <div class="game-overlay">
                            <button class="play-button">Play Now</button>
                        </div>
                    </div>
                    <div class="game-info">
                        <h3>Anime Runner</h3>
                        <p>Endless runner with anime-inspired obstacles</p>
                        <div class="game-meta">
                            <span class="game-rating">
                                <i class="fas fa-star"></i> 4.2
                            </span>
                            <span class="game-plays">
                                <i class="fas fa-gamepad"></i> 320K
                            </span>
                        </div>
                    </div>
                </div>
                
                <div class="game-card">
                    <div class="game-thumbnail">
                        <img src="images/games/game4.jpg" alt="Game 4">
                        <div class="game-overlay">
                            <button class="play-button">Play Now</button>
                        </div>
                    </div>
                    <div class="game-info">
                        <h3>Tower Defense: Anime Edition</h3>
                        <p>Defend your base with anime heroes</p>
                        <div class="game-meta">
                            <span class="game-rating">
                                <i class="fas fa-star"></i> 4.7
                            </span>
                            <span class="game-plays">
                                <i class="fas fa-gamepad"></i> 420K
                            </span>
                        </div>
                    </div>
                </div>
                
                <div class="game-card">
                    <div class="game-thumbnail">
                        <img src="images/games/game5.jpg" alt="Game 5">
                        <div class="game-overlay">
                            <button class="play-button">Play Now</button>
                        </div>
                    </div>
                    <div class="game-info">
                        <h3>Manga Match 3</h3>
                        <p>Match-3 puzzle game with manga characters</p>
                        <div class="game-meta">
                            <span class="game-rating">
                                <i class="fas fa-star"></i> 4.3
                            </span>
                            <span class="game-plays">
                                <i class="fas fa-gamepad"></i> 280K
                            </span>
                        </div>
                    </div>
                </div>
                
                <div class="game-card">
                    <div class="game-thumbnail">
                        <img src="images/games/game6.jpg" alt="Game 6">
                        <div class="game-overlay">
                            <button class="play-button">Play Now</button>
                        </div>
                    </div>
                    <div class="game-info">
                        <h3>Anime Quiz</h3>
                        <p>Test your knowledge of anime and manga</p>
                        <div class="game-meta">
                            <span class="game-rating">
                                <i class="fas fa-star"></i> 4.6
                            </span>
                            <span class="game-plays">
                                <i class="fas fa-gamepad"></i> 390K
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <footer>
        <div class="footer-nav">
            <a href="index.html">Home</a>
            <a href="privacy.html">Privacy Policy</a>
            <a href="terms.html">Terms of Service</a>
            <a href="contact.html">Contact</a>
            <a href="https://discord.gg/toonily" target="_blank">Discord</a>
        </div>
        <div class="copyright">
            © 2023-2024 Toonily Clone. All rights reserved.
        </div>
    </footer>
    
    <script src="js/script.js"></script>
    <script src="js/family-mode.js"></script>
</body>
</html>
"@
    
    Set-Content -Path "manga-games.html" -Value $mangaGamesHtml
}

Write-Host "Site-wide update completed successfully!" -ForegroundColor Green
Write-Host "New features added:" -ForegroundColor Yellow
Write-Host "- Authentication system (auth.js, login.html, register.html)" -ForegroundColor Cyan
Write-Host "- Dynamic time display (timeago.js)" -ForegroundColor Cyan
Write-Host "- Pagination system (pagination.js)" -ForegroundColor Cyan
Write-Host "- Rating system (ratings.js)" -ForegroundColor Cyan
Write-Host "- View counting system (views.js)" -ForegroundColor Cyan
Write-Host "- Search system (search.js, search.html)" -ForegroundColor Cyan
Write-Host "- Bookmarking system (bookmarks.js)" -ForegroundColor Cyan
Write-Host "- Report system (report.js)" -ForegroundColor Cyan
Write-Host "- Comments integration (comments.js)" -ForegroundColor Cyan
Write-Host "- Discord integration" -ForegroundColor Cyan
Write-Host "- Manga Games page (manga-games.html)" -ForegroundColor Cyan

# Provide next steps
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Magenta
Write-Host "1. Create a CSS file (style.css) in the css directory" -ForegroundColor White
Write-Host "2. Create or update remaining HTML templates (bookmarks.html, profile.html)" -ForegroundColor White
Write-Host "3. Create images needed for games and UI elements" -ForegroundColor White
Write-Host "4. Test all features and ensure compatibility" -ForegroundColor White 