# Script to update all Solo Leveling chapter files with a complete chapter list in the dropdowns

# Define the chapter options HTML (fixed to remove duplicates)
$chapterOptions = @"
                        <option value="side-story-21.html">Side Story 21 - The End</option>
                        <option value="side-story-20.html">Side Story 20</option>
                        <option value="side-story-19.html">Side Story 19</option>
                        <option value="side-story-18.html">Side Story 18</option>
                        <option value="side-story-17.html">Side Story 17</option>
                        <option value="side-story-16.html">Side Story 16</option>
                        <option value="side-story-15.html">Side Story 15</option>
                        <option value="side-story-14.html">Side Story 14</option>
                        <option value="side-story-13.html">Side Story 13</option>
                        <option value="side-story-12.html">Side Story 12</option>
                        <option value="side-story-11.html">Side Story 11</option>
                        <option value="side-story-10.html">Side Story 10</option>
                        <option value="side-story-9.html">Side Story 9</option>
                        <option value="side-story-8.html">Side Story 8</option>
                        <option value="side-story-7.html">Side Story 7</option>
                        <option value="side-story-6.html">Side Story 6</option>
                        <option value="side-story-5.html">Side Story 5</option>
                        <option value="side-story-4.html">Side Story 4</option>
                        <option value="side-story-3.html">Side Story 3</option>
                        <option value="side-story-2.html">Side Story 2</option>
                        <option value="side-story-1.html">Side Story 1</option>
                        <option value="chapter-179.html">Chapter 179</option>
                        <option value="chapter-178.html">Chapter 178</option>
                        <option value="chapter-177.html">Chapter 177</option>
                        <option value="chapter-176.html">Chapter 176</option>
                        <option value="chapter-175.html">Chapter 175</option>
                        <option value="chapter-174.html">Chapter 174</option>
                        <option value="chapter-173.html">Chapter 173</option>
                        <option value="chapter-172.html">Chapter 172</option>
                        <option value="chapter-171.html">Chapter 171</option>
                        <option value="chapter-170.html">Chapter 170</option>
                        <option value="chapter-169.html">Chapter 169</option>
                        <option value="chapter-168.html">Chapter 168</option>
                        <option value="chapter-167.html">Chapter 167</option>
                        <option value="chapter-166.html">Chapter 166</option>
                        <option value="chapter-165.html">Chapter 165</option>
                        <option value="chapter-164.html">Chapter 164</option>
                        <option value="chapter-163.html">Chapter 163</option>
                        <option value="chapter-162.html">Chapter 162</option>
                        <option value="chapter-161.html">Chapter 161</option>
                        <option value="chapter-160.html">Chapter 160</option>
                        <option value="chapter-159.html">Chapter 159</option>
                        <option value="chapter-158.html">Chapter 158</option>
                        <option value="chapter-157.html">Chapter 157</option>
                        <option value="chapter-156.html">Chapter 156</option>
                        <option value="chapter-155.html">Chapter 155</option>
                        <option value="chapter-154.html">Chapter 154</option>
                        <option value="chapter-153.html">Chapter 153</option>
                        <option value="chapter-152.html">Chapter 152</option>
                        <option value="chapter-151.html">Chapter 151</option>
                        <option value="chapter-150.html">Chapter 150</option>
                        <option value="chapter-149.html">Chapter 149</option>
                        <option value="chapter-148.html">Chapter 148</option>
                        <option value="chapter-147.html">Chapter 147</option>
                        <option value="chapter-146.html">Chapter 146</option>
                        <option value="chapter-145.html">Chapter 145</option>
                        <option value="chapter-144.html">Chapter 144</option>
                        <option value="chapter-143.html">Chapter 143</option>
                        <option value="chapter-142.html">Chapter 142</option>
                        <option value="chapter-141.html">Chapter 141</option>
                        <option value="chapter-140.html">Chapter 140</option>
                        <option value="chapter-139.html">Chapter 139</option>
                        <option value="chapter-138.html">Chapter 138</option>
                        <option value="chapter-137.html">Chapter 137</option>
                        <option value="chapter-136.html">Chapter 136</option>
                        <option value="chapter-135.html">Chapter 135</option>
                        <option value="chapter-134.html">Chapter 134</option>
                        <option value="chapter-133.html">Chapter 133</option>
                        <option value="chapter-132.html">Chapter 132</option>
                        <option value="chapter-131.html">Chapter 131</option>
                        <option value="chapter-130.html">Chapter 130</option>
                        <option value="chapter-129.html">Chapter 129</option>
                        <option value="chapter-128.html">Chapter 128</option>
                        <option value="chapter-127.html">Chapter 127</option>
                        <option value="chapter-126.html">Chapter 126</option>
                        <option value="chapter-125.html">Chapter 125</option>
                        <option value="chapter-124.html">Chapter 124</option>
                        <option value="chapter-123.html">Chapter 123</option>
                        <option value="chapter-122.html">Chapter 122</option>
                        <option value="chapter-121.html">Chapter 121</option>
                        <option value="chapter-120.html">Chapter 120</option>
                        <option value="chapter-119.html">Chapter 119</option>
                        <option value="chapter-118.html">Chapter 118</option>
                        <option value="chapter-117.html">Chapter 117</option>
                        <option value="chapter-116.html">Chapter 116</option>
                        <option value="chapter-115.html">Chapter 115</option>
                        <option value="chapter-114.html">Chapter 114</option>
                        <option value="chapter-113.html">Chapter 113</option>
                        <option value="chapter-112.html">Chapter 112</option>
                        <option value="chapter-111.html">Chapter 111</option>
                        <option value="chapter-110.html">Chapter 110</option>
                        <option value="chapter-109.html">Chapter 109</option>
                        <option value="chapter-108.html">Chapter 108</option>
                        <option value="chapter-107.html">Chapter 107</option>
                        <option value="chapter-106.html">Chapter 106</option>
                        <option value="chapter-105.html">Chapter 105</option>
                        <option value="chapter-104.html">Chapter 104</option>
                        <option value="chapter-103.html">Chapter 103</option>
                        <option value="chapter-102.html">Chapter 102</option>
                        <option value="chapter-101.html">Chapter 101</option>
                        <option value="chapter-100.html">Chapter 100</option>
                        <option value="chapter-99.html">Chapter 99</option>
                        <option value="chapter-98.html">Chapter 98</option>
                        <option value="chapter-97.html">Chapter 97</option>
                        <option value="chapter-96.html">Chapter 96</option>
                        <option value="chapter-95.html">Chapter 95</option>
                        <option value="chapter-94.html">Chapter 94</option>
                        <option value="chapter-93.html">Chapter 93</option>
                        <option value="chapter-92.html">Chapter 92</option>
                        <option value="chapter-91.html">Chapter 91</option>
                        <option value="chapter-90.html">Chapter 90</option>
                        <option value="chapter-89.html">Chapter 89</option>
                        <option value="chapter-88.html">Chapter 88</option>
                        <option value="chapter-87.html">Chapter 87</option>
                        <option value="chapter-86.html">Chapter 86</option>
                        <option value="chapter-85.html">Chapter 85</option>
                        <option value="chapter-84.html">Chapter 84</option>
                        <option value="chapter-83.html">Chapter 83</option>
                        <option value="chapter-82.html">Chapter 82</option>
                        <option value="chapter-81.html">Chapter 81</option>
                        <option value="chapter-80.html">Chapter 80</option>
                        <option value="chapter-79.html">Chapter 79</option>
                        <option value="chapter-78.html">Chapter 78</option>
                        <option value="chapter-77.html">Chapter 77</option>
                        <option value="chapter-76.html">Chapter 76</option>
                        <option value="chapter-75.html">Chapter 75</option>
                        <option value="chapter-74.html">Chapter 74</option>
                        <option value="chapter-73.html">Chapter 73</option>
                        <option value="chapter-72.html">Chapter 72</option>
                        <option value="chapter-71.html">Chapter 71</option>
                        <option value="chapter-70.html">Chapter 70</option>
                        <option value="chapter-69.html">Chapter 69</option>
                        <option value="chapter-68.html">Chapter 68</option>
                        <option value="chapter-67.html">Chapter 67</option>
                        <option value="chapter-66.html">Chapter 66</option>
                        <option value="chapter-65.html">Chapter 65</option>
                        <option value="chapter-64.html">Chapter 64</option>
                        <option value="chapter-63.html">Chapter 63</option>
                        <option value="chapter-62.html">Chapter 62</option>
                        <option value="chapter-61.html">Chapter 61</option>
                        <option value="chapter-60.html">Chapter 60</option>
                        <option value="chapter-59.html">Chapter 59</option>
                        <option value="chapter-58.html">Chapter 58</option>
                        <option value="chapter-57.html">Chapter 57</option>
                        <option value="chapter-56.html">Chapter 56</option>
                        <option value="chapter-55.html">Chapter 55</option>
                        <option value="chapter-54.html">Chapter 54</option>
                        <option value="chapter-53.html">Chapter 53</option>
                        <option value="chapter-52.html">Chapter 52</option>
                        <option value="chapter-51.html">Chapter 51</option>
                        <option value="chapter-50.html">Chapter 50</option>
                        <option value="chapter-49.html">Chapter 49</option>
                        <option value="chapter-48.html">Chapter 48</option>
                        <option value="chapter-47.html">Chapter 47</option>
                        <option value="chapter-46.html">Chapter 46</option>
                        <option value="chapter-45.html">Chapter 45</option>
                        <option value="chapter-44.html">Chapter 44</option>
                        <option value="chapter-43.html">Chapter 43</option>
                        <option value="chapter-42.html">Chapter 42</option>
                        <option value="chapter-41.html">Chapter 41</option>
                        <option value="chapter-40.html">Chapter 40</option>
                        <option value="chapter-39.html">Chapter 39</option>
                        <option value="chapter-38.html">Chapter 38</option>
                        <option value="chapter-37.html">Chapter 37</option>
                        <option value="chapter-36.html">Chapter 36</option>
                        <option value="chapter-35.html">Chapter 35</option>
                        <option value="chapter-34.html">Chapter 34</option>
                        <option value="chapter-33.html">Chapter 33</option>
                        <option value="chapter-32.html">Chapter 32</option>
                        <option value="chapter-31.html">Chapter 31</option>
                        <option value="chapter-30.html">Chapter 30</option>
                        <option value="chapter-29.html">Chapter 29</option>
                        <option value="chapter-28.html">Chapter 28</option>
                        <option value="chapter-27.html">Chapter 27</option>
                        <option value="chapter-26.html">Chapter 26</option>
                        <option value="chapter-25.html">Chapter 25</option>
                        <option value="chapter-24.html">Chapter 24</option>
                        <option value="chapter-23.html">Chapter 23</option>
                        <option value="chapter-22.html">Chapter 22</option>
                        <option value="chapter-21.html">Chapter 21</option>
                        <option value="chapter-20.html">Chapter 20</option>
                        <option value="chapter-19.html">Chapter 19</option>
                        <option value="chapter-18.html">Chapter 18</option>
                        <option value="chapter-17.html">Chapter 17</option>
                        <option value="chapter-16.html">Chapter 16</option>
                        <option value="chapter-15.html">Chapter 15</option>
                        <option value="chapter-14.html">Chapter 14</option>
                        <option value="chapter-13.html">Chapter 13</option>
                        <option value="chapter-12.html">Chapter 12</option>
                        <option value="chapter-11.html">Chapter 11</option>
                        <option value="chapter-10.html">Chapter 10</option>
                        <option value="chapter-9.html">Chapter 9</option>
                        <option value="chapter-8.html">Chapter 8</option>
                        <option value="chapter-7.html">Chapter 7</option>
                        <option value="chapter-6.html">Chapter 6</option>
                        <option value="chapter-5.html">Chapter 5</option>
                        <option value="chapter-4.html">Chapter 4</option>
                        <option value="chapter-3.html">Chapter 3</option>
                        <option value="chapter-2.html">Chapter 2</option>
                        <option value="chapter-1.html">Chapter 1</option>
                        <option value="chapter-0.html">Chapter 0 - Prologue</option>
"@

# Function to update a single chapter file
function Update-ChapterFile {
    param (
        [string]$filePath
    )
    
    # Get the current filename to mark it as selected
    $fileName = [System.IO.Path]::GetFileName($filePath)
    
    # Read the content of the file
    $content = Get-Content -Path $filePath -Raw
    
    # Create modified options where the current chapter is selected
    $modifiedOptions = $chapterOptions -replace "value=""$fileName"">", "value=""$fileName"" selected>"
    
    # First selector replacement - using regex to find between the select tags for top dropdown
    $pattern1 = '(<select id="chapter-select" onchange="if\(this\.value\) window\.location\.href=this\.value">)[\s\S]*?(<\/select>)'
    $replacement1 = "`${1}`n$modifiedOptions`n                    `${2}"
    $content = $content -replace $pattern1, $replacement1
    
    # Second selector replacement - for bottom dropdown
    $pattern2 = '(<select id="chapter-select-bottom" onchange="if\(this\.value\) window\.location\.href=this\.value">)[\s\S]*?(<\/select>)'
    $replacement2 = "`${1}`n$modifiedOptions`n                    `${2}"
    $content = $content -replace $pattern2, $replacement2
    
    # Write the modified content back to the file
    Set-Content -Path $filePath -Value $content
    
    Write-Host "Updated dropdown selectors in $fileName"
}

# Get all Solo Leveling chapter files
$chapterFiles = Get-ChildItem -Path "chapters/solo-leveling" -Filter "*.html"

# Process each file
foreach ($file in $chapterFiles) {
    Update-ChapterFile -filePath $file.FullName
}

Write-Host "All chapter files have been updated with the complete chapter list!" 