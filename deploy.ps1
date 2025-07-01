# Quick deploy script for web app changes
# Usage: .\deploy.ps1 "Your commit message"

param(
    [Parameter(Mandatory=$true)]
    [string]$CommitMessage
)

Write-Host "🚀 Deploying changes to GitHub Pages..." -ForegroundColor Green

# Add all changes
git add .

# Commit with provided message
git commit -m $CommitMessage

# Push to GitHub
git push

Write-Host "✅ Deployed! Check https://github.com/mark-boots/4daagse-gpx/actions for deployment status" -ForegroundColor Green
Write-Host "🌐 Site will be live in 2-10 minutes at: https://mark-boots.github.io/4daagse-gpx/" -ForegroundColor Cyan
