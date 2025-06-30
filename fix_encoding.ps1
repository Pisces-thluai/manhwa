# PowerShell script to fix encoding issues in all adult pages
$pageFiles = Get-ChildItem -Path "adult/pages/*.html"

foreach ($file in $pageFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    
    # Fix the "Last Â»" issue
    $content = $content -replace "Last Â»", "Last »"
    
    # Fix the copyright symbol
    $content = $content -replace "Â© 2019-2025", "© 2019-2025"
    
    # Write the updated content back to the file
    $content | Out-File -FilePath $file.FullName -Encoding UTF8
    
    Write-Host "Fixed encoding in: $($file.Name)"
}

Write-Host "Encoding issues fixed in all adult page files!" 