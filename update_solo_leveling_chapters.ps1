# Function to create a chapter file with lazy loading
function Create-ChapterFile {
    param (
        [string]$chapterType,
        [int]$chapterNumber
    )

    # Determine chapter title and filename
    if ($chapterType -eq "chapter") {
        $chapterTitle = "Chapter $chapterNumber"
        $fileName = "chapter-$chapterNumber.html"
        $imgPrefix = "ch$chapterNumber"
    } else {
        $chapterTitle = "Side Story $chapterNumber"
        $fileName = "side-story-$chapterNumber.html"
        $imgPrefix = "ss$chapterNumber"
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
        
        .load-all-images {
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 15px 0;
        }
        
        .load-all-images span {
            margin-right: 10px;
            font-weight: 600;
            font-size: 14px;
        }
        
        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 24px;
        }
        
        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 24px;
        }
        
        .slider:before {
            position: absolute;
            content: "";
            height: 16px;
            width: 16px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        
        input:checked + .slider {
            background-color: #ff5555;
        }
        
        input:checked + .slider:before {
            transform: translateX(26px);
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
        
        .report-button {
            background-color: transparent;
            border: 1px solid #ff5555;
            color: #ff5555;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 500;
            cursor: pointer;
            margin-top: 20px;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }
        
        .report-button:hover {
            background-color: #ff5555;
            color: #ffffff;
        }
        
        .report-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.8);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        
        .report-modal.active {
            display: flex;
        }
        
        .report-content {
            background-color: #1a2634;
            padding: 25px;
            border-radius: 10px;
            width: 90%;
            max-width: 500px;
            position: relative;
        }
        
        .close-modal {
            position: absolute;
            top: 15px;
            right: 15px;
            font-size: 20px;
            cursor: pointer;
            color: #a0a0b0;
        }
        
        .close-modal:hover {
            color: #ff5555;
        }
        
        .report-form h3 {
            margin-bottom: 20px;
            font-size: 18px;
        }
        
        .report-option {
            margin-bottom: 10px;
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
        
        <div class="load-all-images">
            <span>Load all images</span>
            <label class="toggle-switch">
                <input type="checkbox" id="load-all-toggle">
                <span class="slider"></span>
            </label>
        </div>
        
        <div class="reader-content" id="reader-content">
            <!-- Lazy-loaded images -->
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/$imgPrefix/sl-$imgPrefix-1.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/$imgPrefix/sl-$imgPrefix-2.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/$imgPrefix/sl-$imgPrefix-3.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/$imgPrefix/sl-$imgPrefix-4.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/$imgPrefix/sl-$imgPrefix-5.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/$imgPrefix/sl-$imgPrefix-6.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/$imgPrefix/sl-$imgPrefix-7.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/$imgPrefix/sl-$imgPrefix-8.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/$imgPrefix/sl-$imgPrefix-9.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/$imgPrefix/sl-$imgPrefix-10.jpg" class="chapter-image" loading="lazy">
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
        
        <button class="report-button" id="report-btn">Report Issue</button>
    </div>
    
    <div class="report-modal" id="report-modal">
        <div class="report-content">
            <span class="close-modal" id="close-modal">&times;</span>
            <div class="report-form">
                <h3>Report an Issue</h3>
                <div class="report-option">
                    <input type="radio" id="missing-images" name="report-issue" value="missing-images">
                    <label for="missing-images">Missing Images</label>
                </div>
                <div class="report-option">
                    <input type="radio" id="wrong-order" name="report-issue" value="wrong-order">
                    <label for="wrong-order">Images in Wrong Order</label>
                </div>
                <div class="report-option">
                    <input type="radio" id="low-quality" name="report-issue" value="low-quality">
                    <label for="low-quality">Low Quality Images</label>
                </div>
                <div class="report-option">
                    <input type="radio" id="wrong-chapter" name="report-issue" value="wrong-chapter">
                    <label for="wrong-chapter">Wrong Chapter Content</label>
                </div>
                <div class="report-option">
                    <input type="radio" id="other-issue" name="report-issue" value="other">
                    <label for="other-issue">Other</label>
                </div>
                <textarea placeholder="Describe the issue in detail..." style="width: 100%; padding: 10px; margin-top: 15px; height: 100px; background-color: #263545; border: 1px solid #374357; color: #ffffff; border-radius: 5px;"></textarea>
                <button class="nav-btn" style="margin-top: 15px; width: 100%;">Submit Report</button>
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
            // Get the modals
            const reportModal = document.getElementById('report-modal');
            const reportBtn = document.getElementById('report-btn');
            const closeModal = document.getElementById('close-modal');
            
            // Toggle report modal
            reportBtn.addEventListener('click', function() {
                reportModal.classList.add('active');
            });
            
            closeModal.addEventListener('click', function() {
                reportModal.classList.remove('active');
            });
            
            window.addEventListener('click', function(event) {
                if (event.target == reportModal) {
                    reportModal.classList.remove('active');
                }
            });
            
            // Lazy loading images
            const loadAllToggle = document.getElementById('load-all-toggle');
            const lazyImages = document.querySelectorAll('img[loading="lazy"]');
            
            loadAllToggle.addEventListener('change', function() {
                if (this.checked) {
                    lazyImages.forEach(img => {
                        img.src = img.dataset.src;
                    });
                }
            });
            
            // Populate chapter selector
            const chapterSelect = document.getElementById('chapter-select');
            const chapterSelectBottom = document.getElementById('chapter-select-bottom');
            
            // Set the current chapter as selected
            const currentChapter = window.location.pathname.split('/').pop();
            
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

    Write-Host "Created $fileName with lazy loading functionality"
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

Write-Host "All chapter files have been updated with lazy loading functionality!" 