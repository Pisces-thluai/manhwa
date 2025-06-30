# Script to create placeholder chapter images for Player Who Can't Level Up

# Ensure directory exists
$chapterDir = "images\chapter_images\playerwhocantlevelup\chapter-1"
if (-not (Test-Path $chapterDir)) {
    New-Item -ItemType Directory -Path $chapterDir -Force
}

# Create 10 placeholder images for chapter 1
for ($i = 1; $i -le 10; $i++) {
    $pageContent = @"
Player Who Can't Level Up
Chapter 1 - Page $i
Width: 800px
Height: 1200px
Background: #333333
Text Color: #ffffff
Description: This is a placeholder for chapter image content.
"@

    $fileName = "$chapterDir\pwclu-ch1-$i.jpg"
    $pageContent | Out-File -FilePath $fileName
    Write-Host "Created placeholder image: $fileName"
}

Write-Host "All chapter 1 placeholder images created" 