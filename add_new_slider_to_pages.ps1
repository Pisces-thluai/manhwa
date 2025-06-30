# This PowerShell script adds the NEW ON MANHWAMOSAIC slider section to all pages

# Function to add slider section to an HTML file if it doesn't already exist
function Add-SliderSection {
    param(
        [string]$filePath,
        [string]$relativePath = ""  # Path to adjust image/link references
    )

    if (Test-Path $filePath) {
        $content = Get-Content -Path $filePath -Raw
        
        # Check if the slider section already exists
        if ($content -notlike "*NEW ON MANHWAMOSAIC*") {
            Write-Host "Adding slider section to $filePath"
            
            # Find the position to insert our slider section (after the notice-bar div)
            if ($content -match '<main>') {
                $insertPosition = $content.IndexOf('<main>') + 7
                
                # Create the slider section HTML with adjusted paths
                $sliderSection = @"

        <section class="featured-titles">
            <div class="section-header">
                <h2>NEW ON MANHWAMOSAIC</h2>
            <div class="slider-container">
                <button class="slider-nav left"><i class="fas fa-chevron-left"></i></button>
                <div class="slider-content">
                    <div class="slider-item" data-manga-id="black-crow">
                        <a href="${relativePath}manga/black-crow.html">
                            <div class="slider-image">
                            <img src="${relativePath}images/covers/black-crow.jpg" alt="Black Crow">
                            </div>
                            <div class="slider-info">
                                <h3>Black Crow</h3>
                            </div>
                        </a>
                    </div>
                    <div class="slider-item" data-manga-id="solo-leveling-ragnarok">
                        <a href="${relativePath}manga/solo-leveling-ragnarok.html">
                            <div class="slider-image">
                            <img src="${relativePath}images/covers/solo-leveling-ragnarok.jpg" alt="Solo Leveling: Ragnarok">
                            </div>
                            <div class="slider-info">
                                <h3>Solo Leveling: Ragnarok</h3>
                            </div>
                        </a>
                    </div>
                    <div class="slider-item" data-manga-id="the-rankers-guide">
                        <a href="${relativePath}manga/the-rankers-guide.html">
                            <div class="slider-image">
                            <img src="${relativePath}https://i.postimg.cc/L5VQ2MND/the-rankers-guide-to-live-an-ordinary-life.jpg" alt="The Rankers Guide to Live an Ordinary Life">
                            </div>
                            <div class="slider-info">
                                <h3>The Rankers Guide</h3>
                            </div>
                        </a>
                    </div>
                    <div class="slider-item" data-manga-id="my-life-as-a-player">
                        <a href="${relativePath}manga/my-life-as-a-player.html">
                            <div class="slider-image">
                            <img src="${relativePath}images/covers/my-life-as-a-player.jpg" alt="My Life as a Player">
                            </div>
                            <div class="slider-info">
                                <h3>My Life as a Player</h3>
                            </div>
                        </a>
                    </div>
                    <div class="slider-item" data-manga-id="11336">
                        <a href="${relativePath}manga/11336.html">
                            <div class="slider-image">
                            <img src="${relativePath}https://i.postimg.cc/rsdzL8VX/11336-lezhin-manhwa-free-224x314.webp" alt="11336">
                            </div>
                            <div class="slider-info">
                                <h3>11336</h3>
                            </div>
                        </a>
                    </div>
                    <div class="slider-item" data-manga-id="not-exactly-an-ignorant">
                        <a href="${relativePath}manga/not-exactly-an-ignorant.html">
                            <div class="slider-image">
                            <img src="${relativePath}images/covers/not-exactly-an-ignorant.jpg" alt="Not Exactly An Ignorant">
                            </div>
                            <div class="slider-info">
                                <h3>Not Exactly An Ignorant</h3>
                            </div>
                        </a>
                    </div>
                    <div class="slider-item" data-manga-id="refused-destructive-route">
                        <a href="${relativePath}manga/refused-destructive-route.html">
                            <div class="slider-image">
                            <img src="${relativePath}images/covers/refused-destructive-route.jpg" alt="I Refused the Destructive Route of a Villain">
                            </div>
                            <div class="slider-info">
                                <h3>I Refused the Destructive Route of a Villain</h3>
                            </div>
                        </a>
                    </div>
                    <div class="slider-item" data-manga-id="becoming-a-wicked-witch">
                        <a href="${relativePath}manga/becoming-a-wicked-witch.html">
                            <div class="slider-image">
                            <img src="${relativePath}images/covers/becoming-a-wicked-witch.jpg" alt="Becoming a Wicked Witch With a Paladin's First Night">
                            </div>
                            <div class="slider-info">
                                <h3>Becoming a Wicked Witch</h3>
                            </div>
                        </a>
                    </div>
                    <div class="slider-item" data-manga-id="you-my-devil">
                        <a href="${relativePath}manga/you-my-devil.html">
                            <div class="slider-image">
                            <img src="${relativePath}images/covers/you-my-devil.jpg" alt="You, My Devil">
                            </div>
                            <div class="slider-info">
                                <h3>You, My Devil</h3>
                            </div>
                        </a>
                    </div>
                    <div class="slider-item" data-manga-id="created-harem-avoid-male-lead">
                        <a href="${relativePath}manga/created-harem-avoid-male-lead.html">
                            <div class="slider-image">
                            <img src="${relativePath}images/covers/created-harem-avoid-male-lead.jpg" alt="I Created a Harem to Avoid the Male Lead">
                            </div>
                            <div class="slider-info">
                                <h3>I Created a Harem to Avoid the Male Lead</h3>
                            </div>
                        </a>
                    </div>
                </div>
                <button class="slider-nav right"><i class="fas fa-chevron-right"></i></button>
            </div>
        </section>

"@
                
                # Insert the slider section
                $newContent = $content.Insert($insertPosition, $sliderSection)
                Set-Content -Path $filePath -Value $newContent
                
                Write-Host "Slider section added to $filePath" -ForegroundColor Green
            }
            else {
                Write-Host "Could not find a suitable position to insert slider section in $filePath" -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "Slider section already exists in $filePath" -ForegroundColor Cyan
        }
    }
    else {
        Write-Host "File not found: $filePath" -ForegroundColor Red
    }
}

# Regular pages 2 to 15
Write-Host "Processing regular pages..." -ForegroundColor Blue
for ($i = 2; $i -le 15; $i++) {
    Add-SliderSection -filePath "pages/page-$i.html" -relativePath "../"
}

# Adult pages 1 to 62
Write-Host "Processing adult pages..." -ForegroundColor Blue
for ($i = 1; $i -le 62; $i++) {
    if ($i -eq 1) {
        # Main adult page
        Add-SliderSection -filePath "adult/index.html" -relativePath "../"
    }
    else {
        Add-SliderSection -filePath "adult/pages/$i.html" -relativePath "../../"
    }
}

Write-Host "Done! All pages updated with the NEW ON MANHWAMOSAIC slider." -ForegroundColor Green 