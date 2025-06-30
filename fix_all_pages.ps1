# PowerShell script to directly replace problematic strings in all files
$files = Get-ChildItem -Path "adult/pages/*.html" -File

foreach ($file in $files) {
    # Read the entire file content as a single string
    $content = [System.IO.File]::ReadAllText($file.FullName)
    
    # Replace the problematic strings
    $content = $content.Replace("Last Â»", "Last »")
    $content = $content.Replace("Â© 2019-2025", "© 2019-2025")
    
    # Write the content back
    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
    
    Write-Host "Processed: $($file.Name)"
}

Write-Host "All files have been processed!" 