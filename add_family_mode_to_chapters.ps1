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

# Get all chapter directories
$chapterDirs = Get-ChildItem -Path "./chapters" -Directory

Log-Message "Found $($chapterDirs.Count) chapter directories to process."

foreach ($dir in $chapterDirs) {
    $chapterHtmlFiles = Get-ChildItem -Path $dir.FullName -Filter "*.html"
    
    Log-Message "Processing $($dir.Name) directory - $($chapterHtmlFiles.Count) HTML files found."
    
    foreach ($file in $chapterHtmlFiles) {
        if ($file.Name -eq "template-chapter.html") {
            continue  # Skip template file as we've already updated it
        }
        
        Log-Message "  Processing $($file.Name)..."
        
        # Read the file content
        $content = Get-Content -Path $file.FullName -Raw
        
        # Add header-search CSS if it doesn't exist
        if ($content -notmatch 'header-search\.css') {
            $content = $content -replace '<link rel="stylesheet" href="../styles\.css">', @'
<link rel="stylesheet" href="../styles.css">
    <link rel="stylesheet" href="../css/header-search.css">
'@
        }
        
        # Replace the logo section with the logo + family mode toggle
        $content = $content -replace '<div class="logo">(\s*)<a href="../index.html">(\s*)<img[^>]*>(\s*)</a>(\s*)</div>', @'
<div class="logo">
                <a href="../index.html">
                    <img src="../images/logo.png" alt="ManhwaMosaic">
                </a>
            </div>
            <div class="family-mode-toggle">
                <button id="family-mode-btn">Family Mode</button>
            </div>
'@
        
        # Add mobile family mode button
        $content = $content -replace '<li><a href="[^"]*">Manga Games</a></li>(\s*)</ul>', @'
<li><a href="../manga-games.html">Manga Games</a></li>
                    <li class="mobile-only"><button id="mobile-family-mode-btn">Family Mode</button></li>
                </ul>
'@
        
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
        
        # Add 18+ Content link if it doesn't exist
        if ($content -notmatch 'adult\.html') {
            $content = $content -replace '<a href="../completed\.html">Completed</a>(\s*)</div>', @'
<a href="../completed.html">Completed</a>
                            <a href="../adult.html" class="adult-category-link">18+ Content</a>
                        </div>
'@
        }
        
        # Add family-mode.js and header-search.js script references if they don't exist
        if ($content -notmatch 'family-mode\.js') {
            $content = $content -replace '<script src="../script\.js"></script>', @'
<script src="../js/family-mode.js"></script>
    <script src="../js/header-search.js"></script>
    <script src="../script.js"></script>
'@
        }
        
        # Add font links if they don't exist
        if ($content -notmatch 'fonts\.googleapis\.com') {
            $content = $content -replace '<link rel="stylesheet" href="https://cdnjs\.cloudflare\.com/ajax/libs/font-awesome/[^"]*">', @'
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="icon" type="image/png" href="../favicon.png">
'@
        }
        
        # Save the modified content
        $content | Set-Content -Path $file.FullName
        
        Log-Message "    Updated $($file.Name) with Family Mode toggle and search features."
    }
}

Log-Message "All chapter HTML files have been updated with Family Mode toggle and search features!" 