# PowerShell script to update links from pages to chapters
$files = Get-ChildItem -Path . -Recurse -Include "*.html"

foreach ($file in $files) {
    Write-Host "Processing file: $($file.FullName)"
    
    # Read the content
    $content = Get-Content -Path $file.FullName -Raw
    
    # Replace href="pages/ with href="chapters/
    $updatedContent = $content -replace 'href="pages/', 'href="chapters/'
    $updatedContent = $updatedContent -replace 'href="../pages/', 'href="../chapters/'
    
    # Replace image paths
    $updatedContent = $updatedContent -replace 'src="https://via.placeholder.com/250x350"', 'src="../images/covers/the-beginning-after-the-end.jpg"'
    
    # Update window.location.href
    $updatedContent = $updatedContent -replace 'window.location.href = ''../pages/', 'window.location.href = ''../chapters/'
    
    # Write the updated content back to the file
    Set-Content -Path $file.FullName -Value $updatedContent
    
    Write-Host "Updated file: $($file.FullName)"
}

Write-Host "Link update complete!" 
