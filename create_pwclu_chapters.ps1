# Script to create chapters 2-5 for Player Who Can't Level Up

# Ensure directory exists
$chapterDir = "chapters\playerwhocantlevelup"
if (-not (Test-Path $chapterDir)) {
    New-Item -ItemType Directory -Path $chapterDir -Force
}

# Dates for the chapters (working backwards from April 24, 2024)
$dates = @(
    "Jan 22, 2021",
    "Jan 29, 2021",
    "Feb 5, 2021",
    "Feb 12, 2021"
)

# Create chapters 2-5
for ($chapterNum = 2; $chapterNum -le 5; $chapterNum++) {
    $dateIndex = $chapterNum - 2
    $releaseDate = $dates[$dateIndex]
    
    # Determine previous and next chapter links
    $prevChapter = $chapterNum - 1
    $nextChapter = $chapterNum + 1
    
    $chapterContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Player Who Can't Level Up - Chapter $chapterNum | ManhwaMosaic Clone</title>
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
                <a href="chapter-$prevChapter.html">« Previous Chapter</a>
                <a href="../../manga/player-who-cant-level-up.html">Manga Info</a>
                <a href="chapter-$nextChapter.html">Next Chapter »</a>
            </div>

            <div class="chapter-title">
                <h1>Player Who Can't Level Up - Chapter $chapterNum</h1>
                <p>Released: $releaseDate</p>
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
            <img src="../../images/chapter_images/playerwhocantlevelup/chapter-$chapterNum/pwclu-ch$chapterNum-1.jpg" alt="Chapter $chapterNum Page 1" class="chapter-image">
            <img src="../../images/chapter_images/playerwhocantlevelup/chapter-$chapterNum/pwclu-ch$chapterNum-2.jpg" alt="Chapter $chapterNum Page 2" class="chapter-image">
            <img src="../../images/chapter_images/playerwhocantlevelup/chapter-$chapterNum/pwclu-ch$chapterNum-3.jpg" alt="Chapter $chapterNum Page 3" class="chapter-image">
            <img src="../../images/chapter_images/playerwhocantlevelup/chapter-$chapterNum/pwclu-ch$chapterNum-4.jpg" alt="Chapter $chapterNum Page 4" class="chapter-image">
            <img src="../../images/chapter_images/playerwhocantlevelup/chapter-$chapterNum/pwclu-ch$chapterNum-5.jpg" alt="Chapter $chapterNum Page 5" class="chapter-image">
            <img src="../../images/chapter_images/playerwhocantlevelup/chapter-$chapterNum/pwclu-ch$chapterNum-6.jpg" alt="Chapter $chapterNum Page 6" class="chapter-image">
            <img src="../../images/chapter_images/playerwhocantlevelup/chapter-$chapterNum/pwclu-ch$chapterNum-7.jpg" alt="Chapter $chapterNum Page 7" class="chapter-image">
            <img src="../../images/chapter_images/playerwhocantlevelup/chapter-$chapterNum/pwclu-ch$chapterNum-8.jpg" alt="Chapter $chapterNum Page 8" class="chapter-image">
            <img src="../../images/chapter_images/playerwhocantlevelup/chapter-$chapterNum/pwclu-ch$chapterNum-9.jpg" alt="Chapter $chapterNum Page 9" class="chapter-image">
            <img src="../../images/chapter_images/playerwhocantlevelup/chapter-$chapterNum/pwclu-ch$chapterNum-10.jpg" alt="Chapter $chapterNum Page 10" class="chapter-image">

            <div class="chapter-nav">
                <a href="chapter-$prevChapter.html">« Previous Chapter</a>
                <a href="../../manga/player-who-cant-level-up.html">Manga Info</a>
                <a href="chapter-$nextChapter.html">Next Chapter »</a>
            </div>

            <button class="report-button">Report Chapter</button>

            <div class="comment-section">
                <h2>Comments</h2>
                
                <div class="comment">
                    <div class="comment-header">
                        <span class="comment-user">DungeonExplorer</span>
                        <span class="comment-date">$releaseDate</span>
                    </div>
                    <p>This chapter was amazing! The way the MC is developing strategies to overcome his inability to level up is really clever.</p>
                </div>

                <div class="comment">
                    <div class="comment-header">
                        <span class="comment-user">SystemMaster</span>
                        <span class="comment-date">$releaseDate</span>
                    </div>
                    <p>I love how the author is building this world. The contrast between the MC and other players who can level up normally creates such an interesting dynamic.</p>
                </div>

                <div class="comment">
                    <div class="comment-header">
                        <span class="comment-user">ManhwaFan99</span>
                        <span class="comment-date">$releaseDate</span>
                    </div>
                    <p>The art in this chapter was exceptional. Those action scenes were so well drawn! Can't wait for next week's release.</p>
                </div>
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
"@

    # Save the chapter file
    $chapterPath = "$chapterDir\chapter-$chapterNum.html"
    $chapterContent | Out-File -FilePath $chapterPath -Encoding utf8
    Write-Host "Created chapter $chapterNum at $chapterPath"
    
    # Create image directory for the chapter
    $imageDir = "images\chapter_images\playerwhocantlevelup\chapter-$chapterNum"
    if (-not (Test-Path $imageDir)) {
        New-Item -ItemType Directory -Path $imageDir -Force
        Write-Host "Created image directory: $imageDir"
    }
    
    # Create placeholder images for the chapter
    for ($i = 1; $i -le 10; $i++) {
        $pageContent = @"
Player Who Can't Level Up
Chapter $chapterNum - Page $i
Width: 800px
Height: 1200px
Background: #333333
Text Color: #ffffff
Description: This is a placeholder for chapter image content.
"@

        $fileName = "$imageDir\pwclu-ch$chapterNum-$i.jpg"
        $pageContent | Out-File -FilePath $fileName
        Write-Host "Created placeholder image: $fileName"
    }
}

Write-Host "All chapters and images created successfully!" 