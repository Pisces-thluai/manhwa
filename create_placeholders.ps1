# Script to create placeholder image files for manga chapters

# Ensure directories exist
$directories = @(
    "images\chapter_images\overgeared\chapter-271",
    "images\chapter_images\overgeared",
    "images\covers"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force
    }
}

# Create logo placeholder
$logoText = @"
ManhwaMosaic Logo Placeholder
Width: 150px
Height: 40px
Background: #ff5555
Text Color: #ffffff
"@
$logoText | Out-File -FilePath "images\covers\logo.jpg"
Write-Host "Logo placeholder created"

# Create Overgeared Chapter 271 placeholder files
for ($i=1; $i -le 10; $i++) {
    $content = @"
Image placeholder for Overgeared Chapter 271 Page $i
Width: 800px
Height: 1200px
Background: #333333
Text Color: #ffffff
"@
    $filePath = "images\chapter_images\overgeared\chapter-271\overgeared-ch271-$i.jpg"
    $content | Out-File -FilePath $filePath
    Write-Host "Created placeholder for chapter 271 page $i"
}

# Create Overgeared Chapter 1 placeholder files
for ($i=1; $i -le 10; $i++) {
    $content = @"
Image placeholder for Overgeared Chapter 1 Page $i
Width: 800px
Height: 1200px
Background: #333333
Text Color: #ffffff
"@
    $filePath = "images\chapter_images\overgeared\overgeared-ch1-$i.jpg"
    $content | Out-File -FilePath $filePath
    Write-Host "Created placeholder for chapter 1 page $i"
}

# Verify content creation
Write-Host "Placeholder files created successfully!"
Get-ChildItem "images\chapter_images\overgeared\chapter-271" | Format-Table Name
Get-ChildItem "images\chapter_images\overgeared" -Filter "overgeared-ch1-*.jpg" | Format-Table Name 