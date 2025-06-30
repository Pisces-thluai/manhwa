# PowerShell script to create adult pages 1.html through 62.html
# Create adult/pages directory if it doesn't exist
if (-not (Test-Path -Path "adult/pages")) {
    New-Item -Path "adult/pages" -ItemType Directory
}

# Loop to create pages 1.html through 62.html
for ($i = 1; $i -le 62; $i++) {
    $fileName = "adult/pages/$i.html"
    $pageTitle = "Adult Content - Page $i"
    $prevPage = if ($i -gt 1) { ($i - 1).ToString() } else { "../index" }
    $nextPage = if ($i -lt 62) { ($i + 1).ToString() } else { "62" }

    # Create pagination links
    $paginationLinks = ""
    
    # First page link
    if ($i -eq 1) {
        $paginationLinks += '                <a href="../index.html">1</a>' + "`n"
    } else {
        $paginationLinks += '                <a href="../index.html">1</a>' + "`n"
    }
    
    # Pages 2-10
    for ($j = 2; $j -le 10; $j++) {
        if ($j -eq $i) {
            $paginationLinks += "                <a href=`"$j.html`" class=`"active`">$j</a>`n"
        } else {
            $paginationLinks += "                <a href=`"$j.html`">$j</a>`n"
        }
    }
    
    # If current page is > 10, add it specifically
    if ($i -gt 10) {
        $paginationLinks += "                <span class=`"page-more`">...</span>`n"
        $paginationLinks += "                <a href=`"$i.html`" class=`"active`">$i</a>`n"
    }
    
    # Last few pages
    if ($i -lt 60) {
        $paginationLinks += "                <span class=`"page-more`">...</span>`n"
        $paginationLinks += "                <a href=`"62.html`" class=`"next`">Last »</a>`n"
    } else {
        for ($j = 60; $j -le 62; $j++) {
            if ($j -eq $i) {
                $paginationLinks += "                <a href=`"$j.html`" class=`"active`">$j</a>`n"
            } else {
                $paginationLinks += "                <a href=`"$j.html`">$j</a>`n"
            }
        }
    }

    # HTML content for the page
    $content = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Read the latest manga, manhwa, and manhua online at ManhwaMosaic - Adult Content - Page $i">
    <title>ManhwaMosaic - Adult Content - Page $i</title>
    <link rel="stylesheet" href="../../styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="icon" type="image/png" href="../../favicon.png">
    <script>
        // Check if family mode is enabled and redirect to family version
        document.addEventListener('DOMContentLoaded', function() {
            const isFamilyModeEnabled = localStorage.getItem('familyMode') === 'enabled';
            
            // If family mode is enabled, redirect to main index.html
            if (isFamilyModeEnabled) {
                window.location.href = '../../index.html';
            }
        });
    </script>
</head>
<body class="adult-page">
    <header>
        <div class="header-container">
            <div class="logo">
                <a href="../index.html">
                    <img src="../../images/logo.png" alt="ManhwaMosaic">
                </a>
            </div>
            <div class="family-mode-toggle">
                <button id="family-mode-btn">Family Mode</button>
            </div>
            <nav class="main-nav">
                <ul>
                    <li><a href="../index.html">Home</a></li>
                    <li class="dropdown">
                        <a href="#">Manhwa <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="../search.html">Search</a>
                            <a href="../new.html">New</a>
                            <a href="../trending.html">Trending</a>
                            <a href="../completed.html">Completed</a>
                            <a href="../18plus.html" class="adult-category-link">18+ Content</a>
                        </div>
                    </li>
                    <li><a href="../manga-games.html">Manga Games</a></li>
                    <li class="mobile-only"><button id="mobile-family-mode-btn">Family Mode</button></li>
                </ul>
            </nav>
            <div class="header-right">
                <div class="search-toggle">
                    <i class="fas fa-search"></i>
                </div>
                <div class="auth-links">
                    <a href="../login.html" class="btn-login">Login</a>
                    <a href="../register.html" class="btn-register">Register</a>
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

    <div class="notice-bar">
        <div class="notice-content">
            <span>You are viewing adult content. Switch to Family Mode for all-ages content.</span>
            <button class="notice-close"><i class="fas fa-times"></i></button>
        </div>
    </div>
    
    <main>
        <section class="latest-releases">
            <div class="section-header">
                <h2>ADULT CONTENT - PAGE $i</h2>
                <div class="content-warning">
                    <p>Warning: The content below is intended for mature audiences only.</p>
                </div>
            </div>
            <div class="manhwa-grid">
                <div class="manhwa-card" data-manga-id="maki-and-friends" data-adult="true">
                    <a href="../manga/maki-and-friends.html">
                        <div class="manhwa-image">
                            <img src="../../images/covers/maki-and-friends.jpg" alt="Maki and Friends">
                            <span class="adult-tag">18+</span>
                        </div>
                        <div class="manhwa-info">
                            <h3>Maki and Friends</h3>
                            <div class="rating-row">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <span>4.5</span>
                                </div>
                                <div class="views">
                                    <span>213.6K</span>
                                </div>
                            </div>
                            <div class="chapters">
                                <div class="chapter">
                                    <a href="../chapters/maki-and-friends/chapter-257.html">Chapter 257</a>
                                    <span class="date">Apr 20, 25</span>
                                </div>
                                <div class="chapter">
                                    <a href="../chapters/maki-and-friends/chapter-256.html">Chapter 256</a>
                                    <span class="date">Apr 20, 25</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="manhwa-card" data-manga-id="go-away-mr-demon" data-adult="true">
                    <a href="../manga/go-away-mr-demon.html">
                        <div class="manhwa-image">
                            <img src="../../images/covers/go-away-mr-demon.jpg" alt="Go Away, Mr.Demon">
                            <span class="adult-tag">18+</span>
                        </div>
                        <div class="manhwa-info">
                            <h3>Go Away, Mr.Demon</h3>
                            <div class="rating-row">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <span>4.5</span>
                                </div>
                                <div class="views">
                                    <span>284.2K</span>
                                </div>
                            </div>
                            <div class="chapters">
                                <div class="chapter">
                                    <a href="../chapters/go-away-mr-demon/chapter-261.html">Chapter 261</a>
                                    <span class="date">Apr 20, 25</span>
                                </div>
                                <div class="chapter">
                                    <a href="../chapters/go-away-mr-demon/chapter-260.html">Chapter 260</a>
                                    <span class="date">Apr 20, 25</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="manhwa-card" data-manga-id="im-no-heroine" data-adult="true">
                    <a href="../manga/im-no-heroine.html">
                        <div class="manhwa-image">
                            <img src="../../images/covers/im-no-heroine.jpg" alt="I'm No Heroine!">
                            <span class="adult-tag">18+</span>
                        </div>
                        <div class="manhwa-info">
                            <h3>I'm No Heroine!</h3>
                            <div class="rating-row">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <span>4.55</span>
                                </div>
                                <div class="views">
                                    <span>1.5M</span>
                                </div>
                            </div>
                            <div class="chapters">
                                <div class="chapter">
                                    <a href="../chapters/im-no-heroine/chapter-80.html">Chapter 80</a>
                                    <span class="date">Apr 3, 25</span>
                                </div>
                                <div class="chapter">
                                    <a href="../chapters/im-no-heroine/chapter-79.html">Chapter 79</a>
                                    <span class="date">Mar 29, 25</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>
            </div>

            <div class="pagination">
$paginationLinks
            </div>
        </section>
    </main>

    <footer>
        <div class="footer-content">
            <div class="footer-nav">
                <a href="../index.html">Home</a>
                <a href="../privacy.html">Privacy Policy</a>
                <a href="../terms.html">Terms of Service</a>
                <a href="../contact.html">Contact</a>
                <a href="../discord.html">Discord</a>
            </div>
            <div class="copyright">
                © 2019-2025 ManhwaMosaic. All rights reserved.
            </div>
        </div>
    </footer>
    
    <script src="../../script.js"></script>
    <script src="../../dark-mode.js"></script>
    <script src="../../reader-settings.js"></script>
    <script src="../../family-mode.js"></script>
</body>
</html>
"@

    # Write content to file
    $content | Out-File -FilePath $fileName -Encoding UTF8
    Write-Host "Created file: $fileName"
}

# Also update the index.html pagination section to include links to the pages
$indexHtmlPath = "adult/index.html"
$indexContent = Get-Content $indexHtmlPath -Raw

# Find the pagination section and replace it
$paginationPattern = '<div class="pagination">[\s\S]+?</div>'
$newPagination = @"
            <div class="pagination">
                <a href="index.html" class="active">1</a>
                <a href="pages/2.html">2</a>
                <a href="pages/3.html">3</a>
                <a href="pages/4.html">4</a>
                <a href="pages/5.html">5</a>
                <a href="pages/6.html">6</a>
                <a href="pages/7.html">7</a>
                <a href="pages/8.html">8</a>
                <a href="pages/9.html">9</a>
                <a href="pages/10.html">10</a>
                <span class="page-more">...</span>
                <a href="pages/62.html" class="next">Last »</a>
            </div>
"@

# Update the index.html file
$updatedIndexContent = $indexContent -replace $paginationPattern, $newPagination
$updatedIndexContent | Out-File -FilePath $indexHtmlPath -Encoding UTF8

Write-Host "Updated pagination in index.html"
Write-Host "All 62 pages have been created successfully in the adult/pages directory!" 