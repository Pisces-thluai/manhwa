# Script to create placeholder cover image for Player Who Can't Level Up

# Ensure directory exists
if (-not (Test-Path "images\covers")) {
    New-Item -ItemType Directory -Path "images\covers" -Force
}

# Create cover placeholder
$coverText = @"
Player Who Can't Level Up Cover Placeholder
Width: 250px
Height: 350px
Background: #333333
Text Color: #ffffff
Description: Cover shows a young man with black hair and determined expression,
wearing casual clothes and holding a mysterious skill book.
"@

$coverText | Out-File -FilePath "images\covers\player-who-cant-level-up-cover.jpg"
Write-Host "Cover placeholder created" 