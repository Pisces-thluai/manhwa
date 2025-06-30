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
        
        # Replace all remaining placeholders
        $content = $content.Replace("[MANGA_TITLE]", $mangaName)
        $content = $content.Replace("[MANGA_SLUG]", $mangaSlug)
        $content = $content.Replace("[MANGA_DESCRIPTION]", "Read $mangaName online for free on ManhwaMosaic.")
        $content = $content.Replace("[MANGA_RATING]", "4.5")
        $content = $content.Replace("[MANGA_VOTES]", "3.2K")
        $content = $content.Replace("[MANGA_VIEWS]", "100K")
        $content = $content.Replace("[MANGA_STATUS]", "Ongoing")
        $content = $content.Replace("[MANGA_STATUS_TAG]", "HOT")
        $content = $content.Replace("[MANGA_AUTHOR]", "Author Name")
        $content = $content.Replace("[MANGA_ARTIST]", "Artist Name")
        $content = $content.Replace("[MANGA_YEAR]", "2023")
        $content = $content.Replace("[MANGA_PUBLISHER]", "ManhwaMosaic")
        $content = $content.Replace("[MANGA_BOOKMARKS]", "1.5K")
        $content = $content.Replace("[MANGA_ALT_TITLES]", "Alternative: $mangaName")
        $content = $content.Replace("[MANGA_GENRE_1]", "Action")
        $content = $content.Replace("[MANGA_GENRE_2]", "Adventure")
        $content = $content.Replace("[MANGA_GENRE_3]", "Fantasy")
        $content = $content.Replace("[MANGA_GENRE_4]", "Drama")
        $content = $content.Replace("[MANGA_TAG_1]", "MANHWA")
        $content = $content.Replace("[MANGA_TAG_2]", "FANTASY")
        $content = $content.Replace("[MANGA_TAG_3]", "ADVENTURE")
        $content = $content.Replace("[MANGA_TAG_4]", "ACTION")
        $content = $content.Replace("[MANGA_TAG_5]", "DRAMA")
        $content = $content.Replace("[CHAPTER_NUMBER]", "5")
        $content = $content.Replace("[CHAPTER_NUMBER-1]", "4")
        $content = $content.Replace("[CHAPTER_DATE]", (Get-Date).ToString("MMM d, yy"))
        $content = $content.Replace("[PREV_CHAPTER_DATE]", (Get-Date).AddDays(-7).ToString("MMM d, yy"))
        $content = $content.Replace("[LAST_CHAPTER]", "5")
        
        # Save the updated content
        $content | Set-Content -Path $file.FullName
        
        Log-Message "  Updated $($file.Name) with proper values."
    } else {
        Log-Message "  $($file.Name) has no placeholders. Skipping."
    }
}

Log-Message "All manga detail pages have been updated with proper values!" 