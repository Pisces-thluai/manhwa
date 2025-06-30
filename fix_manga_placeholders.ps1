param (
    [switch]$Verbose
)

function Log-Message {
    param (
        [string]$Message
    )
    
    if ($Verbose) {
        Write-Host $Message
    }
}

# Get all HTML files in the manga directory
$mangaFiles = Get-ChildItem -Path "./manga" -Filter "*.html" | Where-Object { $_.Name -ne "template-manga.html" }

Log-Message "Found $($mangaFiles.Count) manga files to process."

foreach ($file in $mangaFiles) {
    $mangaName = $file.BaseName
    $mangaSlug = $mangaName.ToLower().Replace(" ", "-")
    
    Log-Message "Processing $($file.Name)..."
    
    # Read the current manga file
    $content = Get-Content -Path $file.FullName -Raw
    
    # Check for any remaining placeholders
    if ($content -match '\[MANGA_' -or $content -match '\[CHAPTER_' -or $content -match '\[LAST_CHAPTER\]') {
        Log-Message "  Fixing remaining placeholders in $($file.Name)..."
        
        # Extract manga title
        if ($content -match '<title>(.*?) - ManhwaMosaic') {
            $mangaTitle = $matches[1]
        } else {
            $mangaTitle = $mangaName -replace "-", " "
        }
        
        # Extract manga description from old content or create a placeholder
        if ($content -match '<div class="manga-description">\s*<p>(.*?)</p>' -or 
            $content -match '<div class="description-content">\s*<p>(.*?)</p>' -or 
            $content -match '<p>(.*?)</p>') {
            $mangaDescription = $matches[1]
        } else {
            $mangaDescription = "Read $mangaTitle online for free on ManhwaMosaic."
        }
        
        # Extract genres or use placeholders
        $genresList = @()
        if ($content -match '<div class="manga-genres">(.*?)</div>' -or
            $content -match '<span class="genre-tag">(.*?)</span>' -or
            $content -match '<span class="genre">(.*?)</span>') {
            if ($content -match '<span class="genre[^"]*">(.*?)</span>') {
                foreach ($match in [regex]::Matches($content, '<span class="genre[^"]*">(.*?)</span>')) {
                    $genresList += $match.Groups[1].Value
                }
            }
        }
        
        if ($genresList.Count -eq 0) {
            $genresList = @("Action", "Adventure", "Fantasy")
        }
        
        # Create genre tags HTML
        $genresHtml = ""
        foreach ($genre in $genresList) {
            $genresHtml += "<span class=`"genre-tag`">$genre</span>`n"
        }
        
        # Create tags HTML
        $tagsHtml = ""
        $tags = @("MANHWA", "FANTASY", "ADVENTURE", "ACTION")
        foreach ($tag in $tags) {
            $tagsHtml += "<span class=`"tag`">$tag</span>`n"
        }
        
        # Create status
        $mangaStatus = "Ongoing"
        if ($content -match 'status">([^<]+)<' -or
            $content -match 'Status[^:]*?:[^<]*?<[^>]*?>([^<]+)') {
            $mangaStatus = $matches[1].Trim()
        }
        
        # Create status tag
        $statusTag = "HOT"
        if ($mangaStatus -eq "Completed") {
            $statusTag = "END"
        }
        
        # Create chapter list HTML
        $chaptersHtml = ""
        $chapterCount = 5
        
        # Try to determine the actual chapter count
        $chapterDir = "./chapters/$mangaSlug"
        if (Test-Path $chapterDir) {
            $chapterFiles = Get-ChildItem -Path $chapterDir -Filter "*.html"
            $chapterCount = $chapterFiles.Count
            if ($chapterCount -eq 0) {
                $chapterCount = 5
            }
        }
        
        for ($i = $chapterCount; $i -ge 1; $i--) {
            $date = (Get-Date).AddDays(-$i * 7).ToString("MMM d, yy")
            $chaptersHtml += @"
                <li class="chapter-item">
                    <a href="../chapters/$mangaSlug/chapter-$i.html" class="chapter-link">Chapter $i</a>
                    <span class="chapter-date">$date</span>
                </li>
"@
        }
        
        # Replace all remaining placeholders
        $content = $content.Replace("[MANGA_TITLE]", $mangaTitle)
        $content = $content.Replace("[MANGA_SLUG]", $mangaSlug)
        $content = $content.Replace("[MANGA_DESCRIPTION]", $mangaDescription)
        $content = $content.Replace("[MANGA_RATING]", "4.5")
        $content = $content.Replace("[MANGA_VOTES]", "3.2K")
        $content = $content.Replace("[MANGA_VIEWS]", "100K")
        $content = $content.Replace("[MANGA_STATUS]", $mangaStatus)
        $content = $content.Replace("[MANGA_STATUS_TAG]", $statusTag)
        $content = $content.Replace("[MANGA_AUTHOR]", "Author Name")
        $content = $content.Replace("[MANGA_ARTIST]", "Artist Name")
        $content = $content.Replace("[MANGA_YEAR]", "2023")
        $content = $content.Replace("[MANGA_PUBLISHER]", "ManhwaMosaic")
        $content = $content.Replace("[MANGA_BOOKMARKS]", "1.5K")
        $content = $content.Replace("[MANGA_ALT_TITLES]", "Alternative: $mangaTitle")
        $content = $content.Replace("[MANGA_GENRE_1]", "Action")
        $content = $content.Replace("[MANGA_GENRE_2]", "Adventure")
        $content = $content.Replace("[MANGA_GENRE_3]", "Fantasy")
        $content = $content.Replace("[MANGA_GENRE_4]", "Drama")
        $content = $content.Replace("[MANGA_TAG_1]", "MANHWA")
        $content = $content.Replace("[MANGA_TAG_2]", "FANTASY")
        $content = $content.Replace("[MANGA_TAG_3]", "ADVENTURE")
        $content = $content.Replace("[MANGA_TAG_4]", "ACTION")
        $content = $content.Replace("[MANGA_TAG_5]", "DRAMA")
        $content = $content.Replace("[CHAPTER_NUMBER]", $chapterCount.ToString())
        $content = $content.Replace("[CHAPTER_NUMBER-1]", ($chapterCount - 1).ToString())
        $content = $content.Replace("[CHAPTER_DATE]", (Get-Date).ToString("MMM d, yy"))
        $content = $content.Replace("[PREV_CHAPTER_DATE]", (Get-Date).AddDays(-7).ToString("MMM d, yy"))
        $content = $content.Replace("[LAST_CHAPTER]", $chapterCount.ToString())
        
        # Replace genre placeholders with actual genres
        if ($content -match '<div class="manga-genres">\s*<span class="genre-tag">\[MANGA_GENRE_') {
            $content = $content -replace '<div class="manga-genres">.*?</div>', "<div class=`"manga-genres`">`n$genresHtml</div>"
        }
        
        # Replace tag placeholders with actual tags
        if ($content -match '<div class="tag-list">\s*<span class="tag">\[MANGA_TAG_') {
            $content = $content -replace '<div class="tag-list">.*?</div>', "<div class=`"tag-list`">`n$tagsHtml</div>"
        }
        
        # Replace chapter list if it still has placeholders
        if ($content -match '<ul class="chapter-list">.*?\[CHAPTER_' -or $content -match '<ul class="chapter-list">.*?Chapter \[CHAPTER_NUMBER\]') {
            $content = $content -replace '<ul class="chapter-list">.*?</ul>', "<ul class=`"chapter-list`">`n$chaptersHtml</ul>"
        }
        
        # Save the updated content
        $content | Set-Content -Path $file.FullName
        
        Log-Message "  Updated $($file.Name) with proper values."
    } else {
        Log-Message "  $($file.Name) has no placeholders. Skipping."
    }
}

Log-Message "All manga detail pages have been updated with proper values!" 