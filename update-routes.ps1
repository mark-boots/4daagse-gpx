# Full update script for when you have new KML files
# Usage: .\update-routes.ps1 "Added new 2026 routes"

param(
    [Parameter(Mandatory=$true)]
    [string]$CommitMessage
)

Write-Host "🗺️ Updating routes from KML files..." -ForegroundColor Green

# Step 1: Generate static files from KML
Write-Host "📁 Generating GPX files from KML..." -ForegroundColor Yellow
npm run generate-static

# Step 2: Copy to docs folder
Write-Host "📋 Copying files to docs folder..." -ForegroundColor Yellow
xcopy public\* docs\ /E /Y

# Step 3: Deploy
Write-Host "🚀 Deploying to GitHub Pages..." -ForegroundColor Yellow
git add .
git commit -m $CommitMessage
git push

Write-Host "✅ Routes updated and deployed!" -ForegroundColor Green
Write-Host "🌐 Site will be live in 2-10 minutes at: https://mark-boots.github.io/4daagse-gpx/" -ForegroundColor Cyan
