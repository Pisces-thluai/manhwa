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
    
    # Check if the file contains the load more JavaScript functionality
    if ($content -match '// Load more chapters functionality[\s\S]*?loadMoreBtn\.addEventListener') {
        Log-Message "  Removing 'Load More Chapters' JavaScript functionality from $($file.Name)..."
        
        # Remove the load more JavaScript functionality
        $content = $content -replace '// Load more chapters functionality[\s\S]*?setTimeout\(\(\) => \{[\s\S]*?\}, \d+\)\;[\s\S]*?\}\)\;', ''
        
        # Save the updated content
        $content | Set-Content -Path $file.FullName
        
        Log-Message "  Updated $($file.Name) successfully."
    } else {
        Log-Message "  No 'Load More Chapters' JavaScript functionality found in $($file.Name). Skipping."
    }
}

Log-Message "All manga detail pages have been updated!" 