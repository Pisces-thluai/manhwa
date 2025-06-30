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

Log-Message "Found $($pageHtmlFiles.Count) page HTML files to check for script references."

foreach ($file in $pageHtmlFiles) {
    Log-Message "Processing $($file.Name)..."
    
    # Read the file content
    $content = Get-Content -Path $file.FullName -Raw
    
    # Remove duplicate script.js references
    if ($content -match '<script src="script\.js"></script>(\s*)<script src="../script\.js"></script>') {
        Log-Message "  Found duplicate script.js references in $($file.Name), fixing..."
        $content = $content -replace '<script src="script\.js"></script>(\s*)<script src="../script\.js"></script>', '<script src="../script.js"></script>'
    }
    
    # Remove any script references that point to non-existent files
    $content = $content -replace '<script src="script\.js"></script>', ''
    
    # Fix footer links to use proper paths
    $content = $content -replace '<a href="index\.html">Home</a>', '<a href="../index.html">Home</a>'
    $content = $content -replace '<a href="privacy\.html">Privacy Policy</a>', '<a href="../privacy.html">Privacy Policy</a>'
    $content = $content -replace '<a href="terms\.html">Terms of Service</a>', '<a href="../terms.html">Terms of Service</a>'
    $content = $content -replace '<a href="contact\.html">Contact</a>', '<a href="../contact.html">Contact</a>'
    
    # Save the modified content
    $content | Set-Content -Path $file.FullName
    
    Log-Message "  Updated $($file.Name) script references and footer links."
}

Log-Message "All page HTML files have been checked and script references fixed!" 