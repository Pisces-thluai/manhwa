$baseTemplate = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Read Solo Leveling {0} online at ManhwaMosaic">
    <title>Solo Leveling - {0} - ManhwaMosaic</title>
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
                <a href="../../index.html">Home</a> / <a href="../../manga/solo-leveling.html">Solo Leveling</a> / {0}
            </div>
            <h1 class="chapter-title">Solo Leveling: {0}</h1>
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
                <a href="{1}" class="nav-btn" id="prev-chapter"><i class="fas fa-chevron-left"></i> Prev</a>
                <a href="{2}" class="nav-btn" id="next-chapter">Next <i class="fas fa-chevron-right"></i></a>
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
            <!-- Images will be lazy-loaded here -->
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/{3}/sl-{3}-1.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/{3}/sl-{3}-2.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/{3}/sl-{3}-3.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/{3}/sl-{3}-4.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/{3}/sl-{3}-5.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/{3}/sl-{3}-6.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/{3}/sl-{3}-7.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/{3}/sl-{3}-8.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/{3}/sl-{3}-9.jpg" class="chapter-image" loading="lazy">
            <img src="../../images/chapter_images/placeholder.jpg" data-src="../../images/chapter_images/solo-leveling/{3}/sl-{3}-10.jpg" class="chapter-image" loading="lazy">
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
                <a href="{1}" class="nav-btn" id="prev-chapter-bottom"><i class="fas fa-chevron-left"></i> Prev</a>
                <a href="{2}" class="nav-btn" id="next-chapter-bottom">Next <i class="fas fa-chevron-right"></i></a>
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
            
            for (let i = 0; i <= 179; i++) {
                const option = document.createElement('option');
                option.value = `chapter-${'i'}.html`;
                option.textContent = `Chapter ${'i'}`;
                
                if (`chapter-${'i'}.html` === currentChapter) {
                    option.selected = true;
                }
                
                chapterSelect.appendChild(option);
                
                const optionBottom = option.cloneNode(true);
                chapterSelectBottom.appendChild(optionBottom);
            }
            
            // Add side stories
            for (let i = 1; i <= 21; i++) {
                const option = document.createElement('option');
                option.value = `side-story-${'i'}.html`;
                option.textContent = `Side Story ${'i'}`;
                
                if (`side-story-${'i'}.html` === currentChapter) {
                    option.selected = true;
                }
                
                chapterSelect.appendChild(option);
                
                const optionBottom = option.cloneNode(true);
                chapterSelectBottom.appendChild(optionBottom);
            }
        });
    </script>
</body>
</html>
"@

# Create directory if it doesn't exist
$outputDir = "chapters/solo-leveling"
if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory -Force
}

# Generate regular chapters (1-179)
for ($i = 1; $i -le 179; $i++) {
    $chapterTitle = "Chapter $i"
    $imgFolderName = "chapter-$i"
    
    # Determine prev and next chapter links
    if ($i -eq 1) {
        $prevChapter = "chapter-0.html" # Prologue
    } else {
        $prevChapter = "chapter-$($i-1).html"
    }
    
    if ($i -eq 179) {
        $nextChapter = "side-story-1.html" # First side story after chapters
    } else {
        $nextChapter = "chapter-$($i+1).html"
    }
    
    $outputPath = Join-Path $outputDir "chapter-$i.html"
    $fileContent = $baseTemplate -f $chapterTitle, $prevChapter, $nextChapter, $imgFolderName
    Set-Content -Path $outputPath -Value $fileContent
    Write-Host "Created chapter-$i.html"
}

# Generate side stories (1-20)
for ($i = 1; $i -le 20; $i++) {
    $chapterTitle = "Side Story $i"
    $imgFolderName = "side-story-$i"
    
    # Determine prev and next chapter links
    if ($i -eq 1) {
        $prevChapter = "chapter-179.html" # Last regular chapter
    } else {
        $prevChapter = "side-story-$($i-1).html"
    }
    
    if ($i -eq 20) {
        $nextChapter = "side-story-21.html" # Already exists
    } else {
        $nextChapter = "side-story-$($i+1).html"
    }
    
    $outputPath = Join-Path $outputDir "side-story-$i.html"
    $fileContent = $baseTemplate -f $chapterTitle, $prevChapter, $nextChapter, $imgFolderName
    Set-Content -Path $outputPath -Value $fileContent
    Write-Host "Created side-story-$i.html"
}

Write-Host "All chapter files have been created successfully!" 