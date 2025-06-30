# This PowerShell script adds manga titles from Toonily's page 2 to our page 2
# Avoiding duplicates that are already on our home page

# Function to add manga cards to page 2
function Add-MangaCards {
    param(
        [string]$filePath
    )

    if (Test-Path $filePath) {
        $content = Get-Content -Path $filePath -Raw
        
        # Check if we already modified the page
        if ($content -notlike "*The Chronicles of Heavenly Demon*") {
            Write-Host "Adding manga cards to $filePath"
            
            # Find the position to insert our manga cards (before the pagination)
            if ($content -match '<div class="pagination">') {
                $insertPosition = $content.IndexOf('<div class="pagination">')
                
                # Get the position of the closing div for the manhwa-grid
                $gridClosingPosition = $content.LastIndexOf('</div>', $insertPosition)
                
                # Create the manga cards HTML
                $mangaCards = @"
                <!-- Added manga titles from Toonily page 2 -->
                <div class="manhwa-card">
                    <a href="../manga/the-chronicles-of-heavenly-demon.html">
                        <div class="manhwa-image">
                            <img src="../images/covers/the-chronicles-of-heavenly-demon.jpg" alt="The Chronicles of Heavenly Demon">
                        </div>
                        <div class="manhwa-info">
                            <h3>The Chronicles of Heavenly Demon</h3>
                            <div class="rating-row">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <span>4.55</span>
                                </div>
                                <div class="views">
                                    <span>6.1M</span>
                                </div>
                            </div>
                            <div class="chapters">
                                <div class="chapter">
                                    <a href="../chapters/chronicles-of-heavenly-demon/chapter-234.html">Chapter 234</a>
                                    <span class="date">May 3, 24</span>
                                </div>
                                <div class="chapter">
                                    <a href="../chapters/chronicles-of-heavenly-demon/chapter-233.html">Chapter 233</a>
                                    <span class="date">May 3, 24</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="manhwa-card">
                    <a href="../manga/ooh-la-la.html">
                        <div class="manhwa-image">
                            <img src="../images/covers/ooh-la-la.jpg" alt="Ooh La La">
                        </div>
                        <div class="manhwa-info">
                            <h3>Ooh La La</h3>
                            <div class="rating-row">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <span>4.75</span>
                                </div>
                                <div class="views">
                                    <span>673.2K</span>
                                </div>
                            </div>
                            <div class="chapters">
                                <div class="chapter">
                                    <a href="../chapters/ooh-la-la/chapter-55.html">Chapter 55</a>
                                    <span class="date">Dec 24, 23</span>
                                </div>
                                <div class="chapter">
                                    <a href="../chapters/ooh-la-la/chapter-54.html">Chapter 54</a>
                                    <span class="date">Dec 24, 23</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="manhwa-card">
                    <a href="../manga/writer-sungs-life.html">
                        <div class="manhwa-image">
                            <img src="../images/covers/writer-sungs-life.jpg" alt="Writer Sung's Life">
                        </div>
                        <div class="manhwa-info">
                            <h3>Writer Sung's Life</h3>
                            <div class="rating-row">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <span>4.15</span>
                                </div>
                                <div class="views">
                                    <span>613.3K</span>
                                </div>
                            </div>
                            <div class="chapters">
                                <div class="chapter">
                                    <a href="../chapters/writer-sungs-life/chapter-33.html">Chapter 33</a>
                                    <span class="date">Dec 23, 23</span>
                                </div>
                                <div class="chapter">
                                    <a href="../chapters/writer-sungs-life/chapter-32.html">Chapter 32</a>
                                    <span class="date">Dec 17, 23</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="manhwa-card">
                    <a href="../manga/counter.html">
                        <div class="manhwa-image">
                            <img src="../images/covers/counter.jpg" alt="Counter">
                            <span class="end-tag">END</span>
                        </div>
                        <div class="manhwa-info">
                            <h3>Counter</h3>
                            <div class="rating-row">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <span>4.55</span>
                                </div>
                                <div class="views">
                                    <span>235.1K</span>
                                </div>
                            </div>
                            <div class="chapters">
                                <div class="chapter">
                                    <a href="../chapters/counter/chapter-38.html">Chapter 38</a>
                                    <span class="date">Nov 22, 23</span>
                                </div>
                                <div class="chapter">
                                    <a href="../chapters/counter/chapter-37.html">Chapter 37</a>
                                    <span class="date">Nov 22, 23</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="manhwa-card">
                    <a href="../manga/malcolm-the-superstar-detective.html">
                        <div class="manhwa-image">
                            <img src="../images/covers/malcolm-the-superstar-detective.jpg" alt="Malcolm, The Superstar Detective">
                            <span class="end-tag">END</span>
                        </div>
                        <div class="manhwa-info">
                            <h3>Malcolm, The Superstar Detective</h3>
                            <div class="rating-row">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <span>3.5</span>
                                </div>
                                <div class="views">
                                    <span>145.5K</span>
                                </div>
                            </div>
                            <div class="chapters">
                                <div class="chapter">
                                    <a href="../chapters/malcolm-the-superstar-detective/chapter-50.html">Chapter 50</a>
                                    <span class="date">Nov 22, 23</span>
                                </div>
                                <div class="chapter">
                                    <a href="../chapters/malcolm-the-superstar-detective/chapter-49.html">Chapter 49</a>
                                    <span class="date">Nov 22, 23</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="manhwa-card">
                    <a href="../manga/the-amazing-siblings.html">
                        <div class="manhwa-image">
                            <img src="../images/covers/the-amazing-siblings.jpg" alt="The Amazing Siblings">
                            <span class="end-tag">END</span>
                        </div>
                        <div class="manhwa-info">
                            <h3>The Amazing Siblings</h3>
                            <div class="rating-row">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <span>4.15</span>
                                </div>
                                <div class="views">
                                    <span>584.2K</span>
                                </div>
                            </div>
                            <div class="chapters">
                                <div class="chapter">
                                    <a href="../chapters/the-amazing-siblings/chapter-200.html">Chapter 200</a>
                                    <span class="date">Nov 22, 23</span>
                                </div>
                                <div class="chapter">
                                    <a href="../chapters/the-amazing-siblings/chapter-199.html">Chapter 199</a>
                                    <span class="date">Nov 22, 23</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="manhwa-card">
                    <a href="../manga/love-rebooted.html">
                        <div class="manhwa-image">
                            <img src="../images/covers/love-rebooted.jpg" alt="Love Rebooted">
                            <span class="end-tag">END</span>
                        </div>
                        <div class="manhwa-info">
                            <h3>Love Rebooted</h3>
                            <div class="rating-row">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <span>4.35</span>
                                </div>
                                <div class="views">
                                    <span>738.2K</span>
                                </div>
                            </div>
                            <div class="chapters">
                                <div class="chapter">
                                    <a href="../chapters/love-rebooted/epilogue.html">Epilogue</a>
                                    <span class="date">Mar 14, 24</span>
                                </div>
                                <div class="chapter">
                                    <a href="../chapters/love-rebooted/chapter-64.html">Chapter 64</a>
                                    <span class="date">Mar 11, 24</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>

                <div class="manhwa-card">
                    <a href="../manga/fff-class-trash-hero.html">
                        <div class="manhwa-image">
                            <img src="../images/covers/fff-class-trash-hero.jpg" alt="FFF-Class Trash Hero">
                        </div>
                        <div class="manhwa-info">
                            <h3>FFF-Class Trash Hero</h3>
                            <div class="rating-row">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <span>4.45</span>
                                </div>
                                <div class="views">
                                    <span>4.3M</span>
                                </div>
                            </div>
                            <div class="chapters">
                                <div class="chapter">
                                    <a href="../chapters/fff-class-trash-hero/chapter-172.html">Chapter 172</a>
                                    <span class="date">Nov 9, 23</span>
                                </div>
                                <div class="chapter">
                                    <a href="../chapters/fff-class-trash-hero/chapter-171.html">Chapter 171</a>
                                    <span class="date">Oct 31, 23</span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>

"@
                
                # Insert the manga cards
                $newContent = $content.Insert($gridClosingPosition, $mangaCards)
                Set-Content -Path $filePath -Value $newContent
                
                Write-Host "Manga cards added to $filePath" -ForegroundColor Green
            }
            else {
                Write-Host "Could not find a suitable position to insert manga cards in $filePath" -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "Manga cards already exist in $filePath" -ForegroundColor Cyan
        }
    }
    else {
        Write-Host "File not found: $filePath" -ForegroundColor Red
    }
}

# Process page 2
Write-Host "Processing page 2..." -ForegroundColor Blue
Add-MangaCards -filePath "pages/page-2.html"

Write-Host "Done! Page 2 updated with new manga titles." -ForegroundColor Green
