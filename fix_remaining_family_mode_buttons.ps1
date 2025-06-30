param (
    [switch]$Verbose
)

function Log-Message {
    param (
        [string]$Message
    )
    
    if ($Verbose) {
        Write-Host $Message
    }
}

# Get all HTML files in the pages directory
$pageHtmlFiles = Get-ChildItem -Path "./pages" -Filter "page-*.html"

Log-Message "Found $($pageHtmlFiles.Count) page HTML files to check."

foreach ($file in $pageHtmlFiles) {
    Log-Message "Processing $($file.Name)..."
    
    # Read the file content
    $content = Get-Content -Path $file.FullName -Raw
    
    # Check if the file already has the family-mode-toggle class with a button
    if ($content -match 'family-mode-toggle' -and $content -match 'id="family-mode-btn"') {
        Log-Message "  Family Mode toggle button already exists in $($file.Name), skipping."
        continue
    }
    
    # Replace different variations of the logo section
    
    # Case 1: Logo with "../index.html" and family-mode-label
    $content = $content -replace '<div class="logo">(\s*)<a href="../index.html">(\s*)<img[^>]*>(\s*)</a>(\s*)<span class="family-mode-label">Family Mode</span>(\s*)</div>', @'
<div class="logo">
                <a href="../index.html">
                    <img src="../images/logo.png" alt="ManhwaMosaic">
                </a>
            </div>
            <div class="family-mode-toggle">
                <button id="family-mode-btn">Family Mode</button>
            </div>
'@

    # Case 2: Logo with "index.html" and family-mode-label
    $content = $content -replace '<div class="logo">(\s*)<a href="index.html">(\s*)<img[^>]*>(\s*)</a>(\s*)<span class="family-mode-label">Family Mode</span>(\s*)</div>', @'
<div class="logo">
                <a href="../index.html">
                    <img src="../images/logo.png" alt="ManhwaMosaic">
                </a>
            </div>
            <div class="family-mode-toggle">
                <button id="family-mode-btn">Family Mode</button>
            </div>
'@

    # Case 3: Logo without family-mode-label
    $content = $content -replace '<div class="logo">(\s*)<a href="index.html">(\s*)<img[^>]*>(\s*)</a>(\s*)</div>', @'
<div class="logo">
                <a href="../index.html">
                    <img src="../images/logo.png" alt="ManhwaMosaic">
                </a>
            </div>
            <div class="family-mode-toggle">
                <button id="family-mode-btn">Family Mode</button>
            </div>
'@

    # Ensure proper links in the navigation
    $content = $content -replace '<li><a href="index.html">Home</a></li>', '<li><a href="../index.html">Home</a></li>'
    $content = $content -replace '<a href="search.html">Search</a>', '<a href="../search.html">Search</a>'
    $content = $content -replace '<a href="new.html">New</a>', '<a href="../new.html">New</a>'
    $content = $content -replace '<a href="trending.html">Trending</a>', '<a href="../trending.html">Trending</a>'
    $content = $content -replace '<a href="completed.html">Completed</a>', '<a href="../completed.html">Completed</a>'
    
    # Add adult.html link if it doesn't exist
    if ($content -notmatch 'adult\.html') {
        $content = $content -replace '<a href="../completed.html">Completed</a>(\s*)</div>', @'
<a href="../completed.html">Completed</a>
                            <a href="../adult.html" class="adult-category-link">18+ Content</a>
                        </div>
'@

        # Also check for the completed.html without the "../" prefix
        $content = $content -replace '<a href="completed.html">Completed</a>(\s*)</div>', @'
<a href="../completed.html">Completed</a>
                            <a href="../adult.html" class="adult-category-link">18+ Content</a>
                        </div>
'@
    }
    
    # Add mobile family mode button if it doesn't exist
    if ($content -notmatch 'id="mobile-family-mode-btn"') {
        $content = $content -replace '<li><a href="[^"]*">Manga Games</a></li>(\s*)</ul>', @'
<li><a href="../manga-games.html">Manga Games</a></li>
                    <li class="mobile-only"><button id="mobile-family-mode-btn">Family Mode</button></li>
                </ul>
'@
    }
    
    # Fix auth links
    $content = $content -replace '<a href="login.html">Login</a>', '<a href="../login.html" class="btn-login">Login</a>'
    $content = $content -replace '<a href="register.html">Register</a>', '<a href="../register.html" class="btn-register">Register</a>'
    
    # Add family-mode.js script reference if it doesn't exist
    if ($content -notmatch 'family-mode\.js') {
        $content = $content -replace '</body>', @'
    <script src="../script.js"></script>
    <script src="../dark-mode.js"></script>
    <script src="../reader-settings.js"></script>
    <script src="../family-mode.js"></script>
</body>
'@
    }
    
    # Save the modified content
    $content | Set-Content -Path $file.FullName
    
    Log-Message "  Updated $($file.Name) with proper Family Mode toggle and fixed links."
}

Log-Message "All page HTML files have been checked and updated!" 