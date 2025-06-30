# This PowerShell script adds the manga-cards.css stylesheet to all specified pages

# Function to add CSS link to an HTML file if it doesn't already exist
function Add-CSSLink {
    param(
        [string]$filePath
    )

    if (Test-Path $filePath) {
        $content = Get-Content -Path $filePath -Raw
        
        # Check if the CSS is already included
        if ($content -notlike "*manga-cards.css*") {
            Write-Host "Adding CSS link to $filePath"
            
            # Find the position to insert our CSS link (after the last stylesheet link)
            if ($content -match '<link[^>]*rel="stylesheet"[^>]*>') {
                $lastCSSLink = $Matches[0]
                $lastCSSLinkPosition = $content.LastIndexOf($lastCSSLink) + $lastCSSLink.Length
                
                # Create the new CSS link element
                $newCSSLink = "`n    <link rel=`"stylesheet`" href=`"css/manga-cards.css`">"
                
                # Insert the new CSS link after the last existing CSS link
                $newContent = $content.Insert($lastCSSLinkPosition, $newCSSLink)
                Set-Content -Path $filePath -Value $newContent
                
                Write-Host "CSS link added to $filePath" -ForegroundColor Green
            }
            else {
                Write-Host "Could not find a suitable position to insert CSS link in $filePath" -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "CSS link already exists in $filePath" -ForegroundColor Cyan
        }
    }
    else {
        Write-Host "File not found: $filePath" -ForegroundColor Red
    }
}

# Create the manga-cards.css directory if it doesn't exist
if (!(Test-Path "css")) {
    New-Item -Path "css" -ItemType Directory
}

# Regular pages 2 to 15
Write-Host "Processing regular pages..." -ForegroundColor Blue
for ($i = 2; $i -le 15; $i++) {
    Add-CSSLink -filePath "pages/page-$i.html"
}

# Adult pages 1 to 62
Write-Host "Processing adult pages..." -ForegroundColor Blue
for ($i = 1; $i -le 62; $i++) {
    if ($i -eq 1) {
        # Main adult page
        Add-CSSLink -filePath "adult/index.html"
    }
    else {
        Add-CSSLink -filePath "adult/pages/$i.html"
    }
}

Write-Host "Done! All pages updated." -ForegroundColor Green 