# PowerShell script to fix encoding issues by directly editing the files
$files = Get-ChildItem -Path "adult/pages/*.html" -File

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName)
    
    # Use regex replace with special character handling
    $content = $content -replace '<a href="62.html" class="next">Last .*?</a>', '<a href="62.html" class="next">Last »</a>'
    $content = $content -replace '.*? 2019-2025 ManhwaMosaic. All rights reserved.', '                © 2019-2025 ManhwaMosaic. All rights reserved.'
    
    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
    
    Write-Host "Fixed: $($file.Name)"
}

Write-Host "All files have been fixed!" 