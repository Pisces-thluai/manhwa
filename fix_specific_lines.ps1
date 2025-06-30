# PowerShell script to target specific problematic lines in each file
$files = Get-ChildItem -Path "adult/pages/*.html" -File | Where-Object { $_.Name -ne "2.html" -and $_.Name -ne "10.html" }
$correctLastLink = '<a href="62.html" class="next">Last »</a>'
$correctCopyright = '                © 2019-2025 ManhwaMosaic. All rights reserved.'

foreach ($file in $files) {
    # Read file as an array of lines
    $lines = Get-Content -Path $file.FullName -Encoding UTF8
    
    # Find and fix the problematic lines
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match 'Last .+?</a>') {
            $lines[$i] = $correctLastLink
        }
        if ($lines[$i] -match '2019-2025 ManhwaMosaic') {
            $lines[$i] = $correctCopyright
        }
    }
    
    # Write the fixed content back to the file
    $lines | Set-Content -Path $file.FullName -Encoding UTF8
    
    Write-Host "Fixed: $($file.Name)"
}

Write-Host "All files have been fixed!" 