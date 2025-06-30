# Script to create placeholder cover images for manga titles

# Ensure directory exists
if (-not (Test-Path "images\covers")) {
    New-Item -ItemType Directory -Path "images\covers" -Force
}

# Create Ooh La La cover placeholder
$oohLaLaText = @"
Ooh La La Cover Placeholder
Width: 250px
Height: 350px
Background: #333333
Text Color: #ffffff
Description: Cover shows a young woman with long brown hair
and a professional-looking man in a business suit, with a
romantic atmosphere and modern city backdrop.
"@

$oohLaLaText | Out-File -FilePath "images\covers\ooh-la-la-cover.jpg"
Write-Host "Created Ooh La La cover placeholder"

# Create Writer Sung's Life cover placeholder
$writerSungsLifeText = @"
Writer Sung's Life Cover Placeholder
Width: 250px
Height: 350px
Background: #333333
Text Color: #ffffff
Description: Cover shows a tired-looking man in his 30s sitting
at a desk surrounded by drawing supplies and manuscript pages,
with a thought bubble showing his manhwa character.
"@

$writerSungsLifeText | Out-File -FilePath "images\covers\writer-sungs-life-cover.jpg"
Write-Host "Created Writer Sung's Life cover placeholder"

# Create Counter cover placeholder
$counterText = @"
Counter Cover Placeholder
Width: 250px
Height: 350px
Background: #333333
Text Color: #ffffff
Description: Cover shows a team of five people with supernatural
abilities facing off against a dark shadowy entity, with an
urban nighttime setting and glowing supernatural effects.
"@

$counterText | Out-File -FilePath "images\covers\counter-cover.jpg"
Write-Host "Created Counter cover placeholder"

Write-Host "All cover placeholders created successfully!" 