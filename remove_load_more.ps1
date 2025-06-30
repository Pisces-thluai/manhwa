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

# Get all HTML files in the manga directory
$mangaFiles = Get-ChildItem -Path "./manga" -Filter "*.html" | Where-Object { $_.Name -ne "template-manga.html" }

Log-Message "Found $($mangaFiles.Count) manga files to process."

foreach ($file in $mangaFiles) {
    $mangaName = $file.BaseName
    
    Log-Message "Processing $($file.Name)..."
    
    # Read the current manga file
    $content = Get-Content -Path $file.FullName -Raw
    
    # Check if the file contains the load more button
    if ($content -match '<div class="load-more">') {
        Log-Message "  Removing 'Load More Chapters' button from $($file.Name)..."
        
        # Remove the load more button and its container
        $content = $content -replace '<div class="load-more">[\s\S]*?</div>\s*(?=</div>)', ''
        
        # Save the updated content
        $content | Set-Content -Path $file.FullName
        
        Log-Message "  Updated $($file.Name) successfully."
    } else {
        Log-Message "  No 'Load More Chapters' button found in $($file.Name). Skipping."
    }
}

Log-Message "All manga detail pages have been updated!" 