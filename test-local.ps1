# Test locally before deploying
# Usage: .\test-local.ps1

Write-Host "Starting local test server..." -ForegroundColor Green
Write-Host "Serving from docs/ folder" -ForegroundColor Yellow
Write-Host "Open http://localhost:8000 in your browser" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
Write-Host ""

Set-Location docs
python -m http.server 8000
