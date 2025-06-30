# PowerShell script to replace problematic lines in all pages using a corrected template
$files = Get-ChildItem -Path "adult/pages/*.html" -File | Where-Object { $_.Name -ne "2.html" }

# Get the corrected content for replacement
$correctedFile = Get-Content -Path "adult/pages/2.html" -Raw
$lastLine = ($correctedFile -split '<a href="62.html" class="next">Last »</a>')[1]
$copyrightLine = ($correctedFile -split '© 2019-2025 ManhwaMosaic. All rights reserved.')[1]

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    
    # Replace the problematic strings
    $content = $content -replace 'Last Â»', 'Last »'
    $content = $content -replace 'Â© 2019-2025', '© 2019-2025'
    
    # Write the updated content back to the file
    $content | Out-File -FilePath $file.FullName -Encoding UTF8
    
    Write-Host "Fixed encoding in: $($file.Name)"
}

Write-Host "All files have been fixed!" 