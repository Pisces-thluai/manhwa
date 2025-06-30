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
$pageFiles = Get-ChildItem -Path "./pages" -Filter "*.html"

Log-Message "Found $($pageFiles.Count) page files to process."

foreach ($file in $pageFiles) {
    Log-Message "  Processing $($file.Name)..."
    
    # Read the file content
    $content = Get-Content -Path $file.FullName -Raw
    
    # Add header-search CSS if it doesn't exist
    if ($content -notmatch 'header-search\.css') {
        $content = $content -replace '<link rel="stylesheet" href="\.\.\/styles\.css">', @'
<link rel="stylesheet" href="../styles.css">
    <link rel="stylesheet" href="../css/header-search.css">
'@
    }
    
    # Replace the logo section with the logo + family mode toggle if needed
    if ($content -notmatch 'family-mode-toggle') {
        $content = $content -replace '<div class="logo">(\s*)<a href="\.\.\/index\.html">(\s*)<img[^>]*>(\s*)</a>(\s*)</div>', @'
<div class="logo">
                <a href="../index.html">
                    <img src="../images/logo.png" alt="ManhwaMosaic">
                </a>
            </div>
            <div class="family-mode-toggle">
                <button id="family-mode-btn">Family Mode</button>
            </div>
'@
    }
    
    # Add mobile family mode button if needed
    if ($content -notmatch 'mobile-family-mode-btn') {
        $content = $content -replace '<li><a href="[^"]*">Manga Games</a></li>(\s*)</ul>', @'
<li><a href="../manga-games.html">Manga Games</a></li>
                    <li class="mobile-only"><button id="mobile-family-mode-btn">Family Mode</button></li>
                </ul>
'@
    }
    
    # Replace search-toggle with header-search
    $content = $content -replace '<div class="search-toggle">(\s*)<i class="fas fa-search"></i>(\s*)</div>', @'
<div class="header-search">
                    <form>
                        <input type="text" placeholder="Search manga..." autocomplete="off">
                        <button type="submit"><i class="fas fa-search"></i></button>
                    </form>
                    <div class="search-suggestions"></div>
                </div>
'@

    # Remove search overlay - use Regex.Replace instead of -replace operator for multiline
    $searchOverlayPattern = [regex]::new('<div class="search-overlay">.*?</div>\s*</div>\s*</div>', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $content = $searchOverlayPattern.Replace($content, '')
    
    # Add family-mode.js and header-search.js script references
    if ($content -notmatch 'family-mode\.js') {
        $content = $content -replace '<script src="\.\.\/script\.js"></script>', @'
<script src="../js/family-mode.js"></script>
    <script src="../js/header-search.js"></script>
    <script src="../script.js"></script>
'@
    }
    
    # Save the modified content
    $content | Set-Content -Path $file.FullName
    
    Log-Message "    Updated $($file.Name) with search features."
}

# Now update all HTML files in the adult/pages directory
$adultPageFiles = Get-ChildItem -Path "./adult/pages" -Filter "*.html"

Log-Message "Found $($adultPageFiles.Count) adult page files to process."

foreach ($file in $adultPageFiles) {
    Log-Message "  Processing adult/pages/$($file.Name)..."
    
    # Read the file content
    $content = Get-Content -Path $file.FullName -Raw
    
    # Add header-search CSS if it doesn't exist
    if ($content -notmatch 'header-search\.css') {
        $content = $content -replace '<link rel="stylesheet" href="\.\.\/\.\.\/styles\.css">', @'
<link rel="stylesheet" href="../../styles.css">
    <link rel="stylesheet" href="../../css/header-search.css">
'@
    }
    
    # Replace the logo section with the logo + family mode toggle if needed (if not already present)
    if ($content -notmatch 'family-mode-toggle') {
        $content = $content -replace '<div class="logo">(\s*)<a href="\.\.\/index\.html">(\s*)<img[^>]*>(\s*)</a>(\s*)</div>', @'
<div class="logo">
                <a href="../index.html">
                    <img src="../../images/logo.png" alt="ManhwaMosaic">
                </a>
            </div>
            <div class="family-mode-toggle">
                <button id="family-mode-btn">Family Mode</button>
            </div>
'@
    }
    
    # Add mobile family mode button if needed (if not already present)
    if ($content -notmatch 'mobile-family-mode-btn') {
        $content = $content -replace '<li><a href="[^"]*">Manga Games</a></li>(\s*)</ul>', @'
<li><a href="../manga-games.html">Manga Games</a></li>
                    <li class="mobile-only"><button id="mobile-family-mode-btn">Family Mode</button></li>
                </ul>
'@
    }
    
    # Replace search-toggle with header-search
    $content = $content -replace '<div class="search-toggle">(\s*)<i class="fas fa-search"></i>(\s*)</div>', @'
<div class="header-search">
                    <form>
                        <input type="text" placeholder="Search manga..." autocomplete="off">
                        <button type="submit"><i class="fas fa-search"></i></button>
                    </form>
                    <div class="search-suggestions"></div>
                </div>
'@

    # Remove search overlay - use Regex.Replace instead of -replace operator for multiline
    $searchOverlayPattern = [regex]::new('<div class="search-overlay">.*?</div>\s*</div>\s*</div>', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $content = $searchOverlayPattern.Replace($content, '')
    
    # Add family-mode.js and header-search.js script references before the closing body tag
    if ($content -notmatch 'header-search\.js') {
        $content = $content -replace '</body>', @'
    <script src="../../js/family-mode.js"></script>
    <script src="../../js/header-search.js"></script>
</body>
'@
    }
    
    # Save the modified content
    $content | Set-Content -Path $file.FullName
    
    Log-Message "    Updated adult/pages/$($file.Name) with search features."
}

Log-Message "All page files have been updated with search features!" 