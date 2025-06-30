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

# Get all HTML files in the pages directory that match page-*.html pattern
$pageHtmlFiles = Get-ChildItem -Path "./pages" -Filter "page-*.html"

Log-Message "Found $($pageHtmlFiles.Count) page HTML files to fix."

foreach ($file in $pageHtmlFiles) {
    Log-Message "Processing $($file.FullName)..."
    
    # Read the file content
    $content = Get-Content -Path $file.FullName -Raw
    
    # Check if the file has the family-mode-toggle class
    if ($content -match 'family-mode-toggle') {
        Log-Message "  Family mode toggle already exists in $($file.Name), checking if it works properly..."
    }
    
    # Fix the logo section with proper family mode toggle
    # This replaces the logo div with family-mode-label span with the logo + family mode toggle button
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
    
    Log-Message "  Fixed $($file.Name) Family Mode toggle."
}

Log-Message "All page HTML files have been fixed with proper Family Mode toggle!" 