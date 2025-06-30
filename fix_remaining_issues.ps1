# Fix remaining encoding issues with direct string replacements
$files = Get-ChildItem -Path "adult/pages/*.html" -File

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName)
    
    # Fix the issue with double quotes
    $content = $content.Replace('Last Â»', 'Last »')
    $content = $content.Replace('Â©', '©')
    
    # Write the fixed content back to the file
    [System.IO.File]::WriteAllText($file.FullName, $content)
    
    Write-Host "Updated: $($file.Name)"
}

Write-Host "All encoding issues have been fixed!" 