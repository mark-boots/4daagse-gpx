# Two-step route update: generate files, then deploy separately
# Usage: .\update-routes.ps1 "Added new 2026 routes"

param(
    [Parameter(Mandatory=$true)]
    [string]$CommitMessage
)

Write-Host "🗺️ Full route update process..." -ForegroundColor Green

# Step 1: Generate files
Write-Host "📁 Generating static files..." -ForegroundColor Yellow
.\generate.ps1

# Step 2: Pause for review
Write-Host ""
Write-Host "⏸️  Files are ready in docs/ folder" -ForegroundColor Yellow
Write-Host "� Review and make any frontend changes now" -ForegroundColor Cyan
Write-Host "🚀 Press any key when ready to deploy..." -ForegroundColor Green
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Step 3: Deploy
Write-Host ""
Write-Host "🚀 Deploying to GitHub Pages..." -ForegroundColor Yellow
.\deploy.ps1 $CommitMessage
