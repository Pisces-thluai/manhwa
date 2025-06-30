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
$pageHtmlFiles = Get-ChildItem -Path "./pages" -Filter "*.html"

Log-Message "Found $($pageHtmlFiles.Count) page HTML files to check for duplicate script references."

foreach ($file in $pageHtmlFiles) {
    Log-Message "Processing $($file.Name)..."
    
    # Read the file content
    $content = Get-Content -Path $file.FullName -Raw
    
    # Check for duplicate script references
    if ($content -match '<script src="../script.js"></script>(\s*)<script src="../script.js"></script>') {
        # Fix duplicate script references
        $content = $content -replace '<script src="../script.js"></script>(\s*)<script src="../script.js"></script>', '<script src="../script.js"></script>'
        
        # Save the modified content
        $content | Set-Content -Path $file.FullName
        
        Log-Message "  Fixed duplicate script references in $($file.Name)."
    } else {
        Log-Message "  No duplicate script references found in $($file.Name)."
    }
}

Log-Message "All page HTML files have been checked for duplicate script references!" 