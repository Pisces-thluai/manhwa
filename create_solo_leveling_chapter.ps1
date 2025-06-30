# Function to create a chapter file
function Create-ChapterFile {
    param (
        [string]$chapterType,
        [int]$chapterNumber
    )

    # Determine chapter title and filename
    if ($chapterType -eq "chapter") {
        $chapterTitle = "Chapter $chapterNumber"
        $fileName = "chapter-$chapterNumber.html"
    } else {
        $chapterTitle = "Side Story $chapterNumber"
        $fileName = "side-story-$chapterNumber.html"
    }
    
    # Create output directory if it doesn't exist
    $outputDir = "chapters/solo-leveling"
    if (-not (Test-Path $outputDir)) {
        New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
    }
    
    # Full path for the new file
    $outputPath = Join-Path $outputDir $fileName
    
    # Create file content
    $content = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Read Solo Leveling $chapterTitle online at ManhwaMosaic">
    <title>Solo Leveling - $chapterTitle - ManhwaMosaic</title>
    <link rel="stylesheet" href="../../styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <link rel="icon" type="image/png" href="../../favicon.png">
    <style>
        body {
            background-color: #0f1923;
            color: #ffffff;
            font-family: 'Poppins', sans-serif;
        }
        
        .chapter-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .chapter-header {
            text-align: center;
            margin-bottom: 20px;
        }
        
        .chapter-title {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .chapter-breadcrumb {
            font-size: 14px;
            color: #a0a0b0;
            margin-bottom: 20px;
        }
        
        .chapter-breadcrumb a {
            color: #a0a0b0;
            text-decoration: none;
        }
        
        .chapter-breadcrumb a:hover {
            color: #ff5555;
        }
        
        .chapter-selector-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .chapter-selector {
            position: relative;
            width: 200px;
        }
        
        .chapter-selector select {
            width: 100%;
            padding: 8px 12px;
            border-radius: 20px;
            background-color: #1a2634;
            color: #ffffff;
            border: none;
            cursor: pointer;
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            padding-right: 30px;
        }
        
        .chapter-selector::after {
            content: "\f078";
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            pointer-events: none;
            font-size: 12px;
        }
        
        .chapter-navigation {
            display: flex;
            gap: 10px;
        }
        
        .nav-btn {
            padding: 8px 15px;
            border-radius: 20px;
            background-color: #ff5555;
            color: #ffffff;
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 80px;
        }
        
        .nav-btn:hover {
            background-color: #ff3333;
        }
        
        .reader-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin: 0 auto;
        }
        
        .chapter-image {
            max-width: 100%;
            height: auto;
            margin-bottom: 10px;
            display: block;
        }
    </style>
</head>
<body>
    <header>
        <div class="header-container">
            <div class="logo">
                <a href="../../index.html">
                    <img src="../../images/logo.png" alt="ManhwaMosaic">
                </a>
                <span class="family-mode-label">Family Mode</span>
            </div>
            <nav class="main-nav">
                <ul>
                    <li><a href="../../index.html">Home</a></li>
                    <li class="dropdown">
                        <a href="#">Manhwa <i class="fas fa-chevron-down"></i></a>
                        <div class="dropdown-content">
                            <a href="../../search.html">Search</a>
                            <a href="../../new.html">New</a>
                            <a href="../../trending.html">Trending</a>
                            <a href="../../completed.html">Completed</a>
                        </div>
                    </li>
                    <li><a href="../../manga-games.html">Manga Games</a></li>
                </ul>
            </nav>
            <div class="header-right">
                <div class="search-toggle">
                    <i class="fas fa-search"></i>
                </div>
                <div class="auth-links">
                    <a href="../../login.html" class="btn-login">Login</a>
                    <a href="../../register.html" class="btn-register">Register</a>
                </div>
                <div class="menu-toggle">
                    <i class="fas fa-bars"></i>
                </div>
            </div>
        </div>
    </header>

    <div class="chapter-container">
        <div class="chapter-header">
            <div class="chapter-breadcrumb">
                <a href="../../index.html">Home</a> / <a href="../../manga/solo-leveling.html">Solo Leveling</a> / $chapterTitle
            </div>
            <h1 class="chapter-title">Solo Leveling: $chapterTitle</h1>
        </div>
        
        <div class="chapter-selector-row">
            <div class="chapter-selector">
                <select id="chapter-select" onchange="if(this.value) window.location.href=this.value">
                    <option value="chapter-0.html">Chapter 0 - Prologue</option>
                    <option value="chapter-1.html">Chapter 1</option>
                    <!-- More chapters will be populated by JavaScript -->
                </select>
            </div>
            <div class="chapter-navigation">
                <a href="#" class="nav-btn" id="prev-chapter"><i class="fas fa-chevron-left"></i> Prev</a>
                <a href="#" class="nav-btn" id="next-chapter">Next <i class="fas fa-chevron-right"></i></a>
            </div>
        </div>
        
        <div class="reader-content" id="reader-content">
            <!-- Sample images (in a real site, these would be the actual chapter images) -->
            <img src="../../images/chapter_images/placeholder.jpg" class="chapter-image">
            <img src="../../images/chapter_images/placeholder.jpg" class="chapter-image">
            <img src="../../images/chapter_images/placeholder.jpg" class="chapter-image">
            <img src="../../images/chapter_images/placeholder.jpg" class="chapter-image">
            <img src="../../images/chapter_images/placeholder.jpg" class="chapter-image">
            <img src="../../images/chapter_images/placeholder.jpg" class="chapter-image">
            <img src="../../images/chapter_images/placeholder.jpg" class="chapter-image">
            <img src="../../images/chapter_images/placeholder.jpg" class="chapter-image">
            <img src="../../images/chapter_images/placeholder.jpg" class="chapter-image">
            <img src="../../images/chapter_images/placeholder.jpg" class="chapter-image">
        </div>
        
        <div class="chapter-selector-row">
            <div class="chapter-selector">
                <select id="chapter-select-bottom" onchange="if(this.value) window.location.href=this.value">
                    <option value="chapter-0.html">Chapter 0 - Prologue</option>
                    <option value="chapter-1.html">Chapter 1</option>
                    <!-- More chapters will be populated by JavaScript -->
                </select>
            </div>
            <div class="chapter-navigation">
                <a href="#" class="nav-btn" id="prev-chapter-bottom"><i class="fas fa-chevron-left"></i> Prev</a>
                <a href="#" class="nav-btn" id="next-chapter-bottom">Next <i class="fas fa-chevron-right"></i></a>
            </div>
        </div>
        
    </div>
    
    <footer>
        <div class="footer-content">
            <div class="footer-nav">
                <a href="../../index.html">Home</a>
                <a href="../../privacy.html">Privacy Policy</a>
                <a href="../../terms.html">Terms of Service</a>
                <a href="../../contact.html">Contact</a>
                <a href="../../discord.html">Discord</a>
            </div>
            <div class="copyright">
                © 2019-2025 ManhwaMosaic. All rights reserved.
            </div>
        </div>
    </footer>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Current chapter logic
            const currentPath = window.location.pathname;
            const currentFileName = currentPath.split('/').pop();
            
            // Set the current chapter in selectors
            const chapterSelects = document.querySelectorAll('#chapter-select, #chapter-select-bottom');
            chapterSelects.forEach(select => {
                const options = select.querySelectorAll('option');
                options.forEach(option => {
                    if (option.value === currentFileName) {
                        option.selected = true;
                    }
                });
            });
            
            // Navigation buttons
            // This would typically be populated with proper URLs based on the current chapter
            document.getElementById('prev-chapter').href = '#';
            document.getElementById('next-chapter').href = '#';
            document.getElementById('prev-chapter-bottom').href = '#';
            document.getElementById('next-chapter-bottom').href = '#';
        });
    </script>
</body>
</html>
"@

    # Write the content to the file
    Set-Content -Path $outputPath -Value $content -Force

    Write-Host "Created $fileName"
}

# Create directory if it doesn't exist
$outputDir = "chapters/solo-leveling"
if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory -Force
}

# Create regular chapters (1-179)
for ($i = 1; $i -le 179; $i++) {
    Create-ChapterFile -chapterType "chapter" -chapterNumber $i
}

# Create side stories (1-20)
for ($i = 1; $i -le 20; $i++) {
    Create-ChapterFile -chapterType "side-story" -chapterNumber $i
}

Write-Host "All chapter files have been created successfully!" 