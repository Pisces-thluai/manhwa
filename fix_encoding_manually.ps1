# PowerShell script to fix encoding issues in all adult pages manually
$files = Get-ChildItem -Path "adult/pages/*.html" -File

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Encoding UTF8
    
    # Initialize a flag to track if changes are needed
    $needsUpdate = $false
    
    # Process each line
    for ($i = 0; $i -lt $content.Count; $i++) {
        if ($content[$i] -match "Last Â»") {
            $content[$i] = $content[$i] -replace "Last Â»", "Last »"
            $needsUpdate = $true
        }
        
        if ($content[$i] -match "Â© 2019-2025") {
            $content[$i] = $content[$i] -replace "Â© 2019-2025", "© 2019-2025"
            $needsUpdate = $true
        }
    }
    
    # Only update the file if changes were made
    if ($needsUpdate) {
        $content | Set-Content -Path $file.FullName -Encoding UTF8
        Write-Host "Fixed encoding in: $($file.Name)"
    }
}

Write-Host "All encoding issues fixed!" 