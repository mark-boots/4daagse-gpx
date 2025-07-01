# Generate static files from KML and copy to docs folder
# Usage: .\generate.ps1

Write-Host "🗺️ Processing KML files and generating static content..." -ForegroundColor Green

# Step 1: Generate static files from KML
Write-Host "📁 Converting KML to GPX files..." -ForegroundColor Yellow
npm run generate-static

# Step 2: Copy to docs folder
Write-Host "📋 Copying files to docs folder..." -ForegroundColor Yellow
xcopy public\* docs\ /E /Y

Write-Host "✅ Files generated and copied to docs/ folder!" -ForegroundColor Green
Write-Host "📝 You can now review/edit files in docs/ before deploying" -ForegroundColor Cyan
Write-Host "🚀 When ready to deploy, run: .\deploy.ps1 'Your commit message'" -ForegroundColor Cyan
