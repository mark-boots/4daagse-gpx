# Backup Current KML Files
# This script backs up your current KML files before updating

$backupDir = "backups\$(Get-Date -Format 'yyyy-MM-dd-HHmm')"

Write-Host "💾 Creating backup of current KML files..." -ForegroundColor Cyan

# Create backup directory
if (!(Test-Path "backups")) {
    New-Item -ItemType Directory -Path "backups" | Out-Null
}
New-Item -ItemType Directory -Path $backupDir | Out-Null

# Copy KML files
if (Test-Path "kmlfiles") {
    Copy-Item "kmlfiles\*" $backupDir -Recurse
    Write-Host "✅ KML files backed up to: $backupDir" -ForegroundColor Green
    
    # List backed up files
    $files = Get-ChildItem $backupDir
    Write-Host ""
    Write-Host "📁 Backed up files:" -ForegroundColor Yellow
    foreach ($file in $files) {
        Write-Host "  - $($file.Name)" -ForegroundColor White
    }
} else {
    Write-Host "⚠️  No kmlfiles directory found" -ForegroundColor Yellow
}

# Also backup docs folder
$docsBackup = Join-Path $backupDir "docs"
if (Test-Path "docs") {
    Copy-Item "docs" $docsBackup -Recurse
    Write-Host "✅ Docs folder also backed up" -ForegroundColor Green
}

Write-Host ""
Write-Host "💾 Backup complete: $backupDir" -ForegroundColor Green
