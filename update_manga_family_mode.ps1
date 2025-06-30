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

Log-Message "Starting manga family mode button update..."

# Get all manga HTML files
$mangaHtmlFiles = Get-ChildItem -Path "./manga" -Filter "*.html"

Log-Message "Found $($mangaHtmlFiles.Count) manga HTML files to check."

$updatedCount = 0
$alreadyCorrectCount = 0
$missingCount = 0

foreach ($file in $mangaHtmlFiles) {
    Log-Message "Processing $($file.Name)..."
    
    # Read the file content
    $content = Get-Content -Path $file.FullName -Raw
    
    # Check if the file has the correct family mode button
    if ($content -match '<div class="family-mode-toggle">\s*<button id="family-mode-btn">') {
        Log-Message "  File already has correct family mode button: $($file.Name)"
        $alreadyCorrectCount++
        continue
    }
    
    # Check if file needs family mode button added
    if ($content -notmatch '<div class="family-mode-toggle">') {
        Log-Message "  Adding family mode button to $($file.Name)..."
        
        # Replace the logo section with the logo + family mode toggle
        $content = $content -replace '<div class="logo">(\s*)<a href="../index.html">(\s*)<img[^>]*>(\s*)</a>(\s*)(?:<span class="family-mode-label">.*?</span>)?(\s*)</div>', @'
<div class="logo">
                <a href="../index.html">
                    <img src="../images/logo.png" alt="ManhwaMosaic">
                </a>
            </div>
            <div class="family-mode-toggle">
                <button id="family-mode-btn">Family Mode</button>
            </div>
'@
        
        # Replace deprecated family-mode-label if exists
        $content = $content -replace '<span class="family-mode-label">.*?</span>', ''
        
        # Save the modified content
        $content | Set-Content -Path $file.FullName
        
        Log-Message "  Updated $($file.Name) with Family Mode toggle."
        $updatedCount++
    }
    # Fix incorrect family mode button
    elseif ($content -match '<div class="family-mode-toggle">') {
        Log-Message "  Fixing family mode button in $($file.Name)..."
        
        $content = $content -replace '<div class="family-mode-toggle">(.*?)</div>', @'
<div class="family-mode-toggle">
                <button id="family-mode-btn">Family Mode</button>
            </div>
'@
        
        # Save the modified content
        $content | Set-Content -Path $file.FullName
        
        Log-Message "  Fixed family mode button in $($file.Name)."
        $updatedCount++
    }
    else {
        Log-Message "  Could not find appropriate place to add family mode button in $($file.Name)"
        $missingCount++
    }
}

Log-Message "Family mode button update complete!"
Log-Message "Summary:"
Log-Message "  - Already correct: $alreadyCorrectCount files"
Log-Message "  - Updated: $updatedCount files"
Log-Message "  - Missing (could not update): $missingCount files"
Log-Message "Total: $($mangaHtmlFiles.Count) files" 