# Script to create Solo Leveling Ragnarok chapters 6-47

# Base chapter template
$chapterTemplate = @'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Solo Leveling: Ragnarok - Chapter {{CHAPTER_NUM}} | ManhwaMosaic Clone</title>
    <link rel="stylesheet" href="../../styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .chapter-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .chapter-image {
            width: 100%;
            margin-bottom: 10px;
            display: block;
        }
        .chapter-nav {
            display: flex;
            justify-content: space-between;
            margin: 20px 0;
            padding: 10px 0;
            border-top: 1px solid #333;
            border-bottom: 1px solid #333;
        }
        .chapter-title {
            text-align: center;
            margin-bottom: 30px;
        }
        .settings-bar {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            padding: 10px;
            background-color: #1e1e2d;
            border-radius: 5px;
        }
        .settings-bar select, .settings-bar button {
            background-color: #2d2d3d;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 3px;
        }
        .comment-section {
            margin-top: 40px;
        }
        .comment {
            background-color: #1e1e2d;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 5px;
        }
        .comment-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .comment-user {
            font-weight: bold;
            color: #ff5555;
        }
        .disabled-link {
            color: #666;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <header>
        <div class="header-container">
            <div class="logo">
                <a href="../../index.html">
                    <img src="../../images/covers/logo.jpg" alt="ManhwaMosaic">
                </a>
                <span class="family-mode-label">Family Mode</span>
            </div>
            <nav class="main-nav">
                <ul>
                    <li><a href="../../index.html">Home</a></li>
                    <li class="dropdown">
                        <a href="#">Manhwa</a>
                        <div class="dropdown-content">
                            <a href="../../search.html">Search</a>
                            <a href="../../new.html">New</a>
                            <a href="../../trending.html">Trending</a>
                            <a href="../../completed.html">Completed</a>
                        </div>
                    </li>
                    <li><a href="#">Manga Games</a></li>
                </ul>
            </nav>
            <div class="header-right">
                <div class="search-toggle">
                    <i class="fas fa-search"></i>
                </div>
                <div class="auth-links">
                    <a href="../../login.html">Login</a>
                    <a href="../../register.html">Register</a>
                </div>
                <div class="menu-toggle">
                    <i class="fas fa-bars"></i>
                </div>
            </div>
        </div>
    </header>

    <div class="search-overlay">
        <div class="search-container">
            <input type="text" placeholder="Search...">
            <button><i class="fas fa-search"></i></button>
            <div class="close-search"><i class="fas fa-times"></i></div>
        </div>
    </div>

    <div class="notice-bar">
        Disqus isn't available at the moment on our website. We are looking into a solution.
    </div>

    <main>
        <div class="chapter-container">
            <div class="chapter-nav">
                <a href="chapter-{{PREV_CHAPTER}}.html">« Previous Chapter</a>
                <a href="../../manga/solo-leveling-ragnarok.html">Manga Info</a>
                {{NEXT_CHAPTER_LINK}}
            </div>

            <div class="chapter-title">
                <h1>Solo Leveling: Ragnarok - Chapter {{CHAPTER_NUM}}</h1>
                <p>Released: {{RELEASE_DATE}}</p>
            </div>

            <div class="settings-bar">
                <div class="reading-mode">
                    <select>
                        <option selected>All pages</option>
                        <option>Single page</option>
                    </select>
                </div>
                <div class="quality-selector">
                    <select>
                        <option selected>High quality</option>
                        <option>Low quality</option>
                    </select>
                </div>
                <div class="width-selector">
                    <button>Fit width</button>
                </div>
            </div>

            <!-- Chapter images -->
            {{CHAPTER_IMAGES}}

            <div class="chapter-nav">
                <a href="chapter-{{PREV_CHAPTER}}.html">« Previous Chapter</a>
                <a href="../../manga/solo-leveling-ragnarok.html">Manga Info</a>
                {{NEXT_CHAPTER_LINK}}
            </div>

            <button class="report-button">Report Chapter</button>

            <div class="comment-section">
                <h2>Comments</h2>
                
                {{COMMENTS}}
            </div>
        </div>
    </main>

    <footer>
        <div class="footer-nav">
            <a href="../../index.html">Home</a>
            <a href="../../privacy.html">Privacy Policy</a>
            <a href="../../terms.html">Terms of Service</a>
            <a href="../../contact.html">Contact</a>
            <a href="#">Discord</a>
        </div>
        <div class="copyright">
            © 2019-2023 ManhwaMosaic.
        </div>
    </footer>
    
    <script src="../../script.js"></script>
    
    <div class="modal" id="reportModal">
        <div class="modal-content">
            <span class="close-modal">&times;</span>
            <h3>Report Chapter</h3>
            <form>
                <div class="form-group">
                    <label>Reason</label>
                    <div class="radio-options">
                        <label><input type="radio" name="reason" value="missing_pages"> Missing pages</label>
                        <label><input type="radio" name="reason" value="images_not_loading"> Images not loading</label>
                        <label><input type="radio" name="reason" value="wrong_chapter"> Wrong chapter</label>
                        <label><input type="radio" name="reason" value="other"> Other</label>
                    </div>
                </div>
                <div class="form-group">
                    <label>Your Comment</label>
                    <textarea rows="4"></textarea>
                </div>
                <div class="button-group">
                    <button type="submit">Submit</button>
                    <button type="button" class="cancel-button">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const reportButton = document.querySelector('.report-button');
            const reportModal = document.getElementById('reportModal');
            const closeModal = document.querySelector('.close-modal');
            const cancelButton = document.querySelector('.cancel-button');
            
            reportButton.addEventListener('click', function() {
                reportModal.style.display = 'flex';
            });
            
            closeModal.addEventListener('click', function() {
                reportModal.style.display = 'none';
            });
            
            cancelButton.addEventListener('click', function() {
                reportModal.style.display = 'none';
            });
            
            window.addEventListener('click', function(event) {
                if (event.target == reportModal) {
                    reportModal.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
'@

# Create directory for chapter images
for ($chapter = 6; $chapter -le 47; $chapter++) {
    $chapterDir = "images\chapter_images\sololevelingragnarok\chapter-$chapter"
    if (-not (Test-Path $chapterDir)) {
        New-Item -ItemType Directory -Path $chapterDir -Force | Out-Null
    }
}

# User names for comments
$userNames = @(
    "ShadowMonarch", "LevelUpKing", "RankA_Hunter", "AriseFromAshes", "MonarchOfShadows",
    "ShadowArmyGeneral", "DailyHunter", "ReturnToAshes", "AshborneLives", "WeeklyReader",
    "S_RankHunter", "HunterRank_S", "JinWooFan", "SystemAdmin", "GateWatcher",
    "BugHunter", "DungeonMaster", "SoloPlayer", "ShadowSoldier", "MonarchSlayer"
)

# Comment templates
$commentTemplates = @(
    "This chapter was amazing! The fight scenes just keep getting better.",
    "I can't believe what happened to {0}! Didn't see that coming at all.",
    "The art in this chapter is phenomenal. That double-page spread was breathtaking.",
    "The way {0} used their new ability was so clever. This author really knows how to build power systems.",
    "I'm getting more invested in this story with each chapter. Can't wait for next week!",
    "Did anyone else notice the subtle hint about {0}'s true identity? I think it confirms my theory.",
    "That cliffhanger is killing me! How am I supposed to wait a whole week now?",
    "The character development for {0} in this chapter was perfect. They've come so far.",
    "I love how they're expanding the lore. The worldbuilding in this series is top-notch.",
    "This might be my favorite chapter so far. Everything from the pacing to the reveals was perfect."
)

# Character names for comment templates
$characterNames = @(
    "Jin-Woo", "Sung Jin-Woo", "the new protagonist", "the Shadow Monarch", "the new Hunter",
    "the Guild Master", "the S-Rank", "the mysterious figure", "the villain", "the new character"
)

# Generate release dates (working backwards from April 3, 2025 for chapter 47)
$startDate = [datetime]::ParseExact("2025-04-03", "yyyy-MM-dd", $null)
$releaseDates = @()

for ($i = 47; $i -ge 6; $i--) {
    $date = $startDate.AddDays(($i - 47) * 7) # Weekly releases
    $formattedDate = $date.ToString("MMM d, yyyy")
    $releaseDates += $formattedDate
}

# Create chapters 6-47
for ($chapter = 6; $chapter -le 47; $chapter++) {
    $chapterContent = $chapterTemplate

    # Replace placeholders
    $chapterContent = $chapterContent.Replace("{{CHAPTER_NUM}}", $chapter)
    $chapterContent = $chapterContent.Replace("{{PREV_CHAPTER}}", ($chapter - 1))
    
    # Next chapter link
    if ($chapter -eq 47) {
        $nextChapterLink = '<span class="disabled-link">Next Chapter »</span>'
    } else {
        $nextChapterLink = "<a href=`"chapter-$($chapter + 1).html`">Next Chapter »</a>"
    }
    $chapterContent = $chapterContent.Replace("{{NEXT_CHAPTER_LINK}}", $nextChapterLink)
    
    # Release date
    $releaseIndex = 47 - $chapter
    $releaseDate = $releaseDates[$releaseIndex]
    $chapterContent = $chapterContent.Replace("{{RELEASE_DATE}}", $releaseDate)
    
    # Chapter images
    $chapterImages = ""
    for ($page = 1; $page -le 10; $page++) {
        $chapterImages += "            <img src=`"../../images/chapter_images/sololevelingragnarok/chapter-$chapter/slr-ch$chapter-$page.jpg`" alt=`"Chapter $chapter Page $page`" class=`"chapter-image`">`n"
        
        # Create placeholder image files
        $content = @"
Image placeholder for Solo Leveling: Ragnarok Chapter $chapter Page $page
Width: 800px
Height: 1200px
Background: #333333
Text Color: #ffffff
"@
        $content | Out-File -FilePath "images\chapter_images\sololevelingragnarok\chapter-$chapter\slr-ch$chapter-$page.jpg"
    }
    $chapterContent = $chapterContent.Replace("{{CHAPTER_IMAGES}}", $chapterImages)
    
    # Comments
    $comments = ""
    $commentCount = Get-Random -Minimum 2 -Maximum 5
    
    for ($i = 0; $i -lt $commentCount; $i++) {
        $userName = $userNames | Get-Random
        $commentTemplate = $commentTemplates | Get-Random
        $characterName = $characterNames | Get-Random
        $comment = $commentTemplate -f $characterName
        
        $dayOffset = Get-Random -Minimum 0 -Maximum 3
        $commentDate = [datetime]::ParseExact($releaseDate, "MMM d, yyyy", $null).AddDays($dayOffset)
        $formattedCommentDate = $commentDate.ToString("MMM d, yyyy")
        
        $comments += @"
                <div class="comment">
                    <div class="comment-header">
                        <span class="comment-user">$userName</span>
                        <span class="comment-date">$formattedCommentDate</span>
                    </div>
                    <p>$comment</p>
                </div>

"@
    }
    
    $chapterContent = $chapterContent.Replace("{{COMMENTS}}", $comments)
    
    # Write chapter file
    $chapterContent | Out-File -FilePath "chapters\sololevelingragnarok\chapter-$chapter.html" -Encoding utf8
    
    Write-Host "Created chapter $chapter"
}

Write-Host "All chapters created successfully!" 