# Daily Automated Route Checker
# This script runs the update check and can be scheduled to run daily

param(
    [switch]$AutoUpdate = $false,  # If true, automatically updates routes when changes found
    [switch]$Quiet = $false        # If true, only outputs when updates are found
)

$logFile = "logs\daily-check-$(Get-Date -Format 'yyyy-MM-dd').log"

# Create logs directory if it doesn't exist
if (!(Test-Path "logs")) {
    New-Item -ItemType Directory -Path "logs" | Out-Null
}

# Function to log with timestamp
function Write-Log {
    param($Message, $Color = "White")
    $timestamp = Get-Date -Format "HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    
    if (!$Quiet -or $Message.Contains("UPDATES FOUND")) {
        Write-Host $logMessage -ForegroundColor $Color
    }
    Add-Content -Path $logFile -Value $logMessage
}

Write-Log "🔄 Starting daily route check..." "Cyan"

try {
    # Run the update checker and capture output
    $checkResult = & ".\scripts\check-updates.ps1"
    
    # Check if updates were found by looking for recent JSON report
    $latestReport = Get-ChildItem "route-check-*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    
    if ($latestReport) {
        $report = Get-Content $latestReport.FullName | ConvertFrom-Json
        
        if ($report.HasUpdates) {
            Write-Log "🎯 UPDATES FOUND! New route data available." "Green"
            
            if ($AutoUpdate) {
                Write-Log "🚀 Auto-update enabled, proceeding with update..." "Yellow"
                
                # Backup current files
                Write-Log "💾 Creating backup..." "Cyan"
                & ".\scripts\backup-current.ps1"
                
                # Copy new files from temp directory
                Write-Log "📂 Copying new files..." "Cyan"
                if (Test-Path $report.TempDirectory) {
                    Copy-Item "$($report.TempDirectory)\*" "kmlfiles\" -Force
                    Write-Log "✅ Files copied from temp directory" "Green"
                }
                
                # Generate new static files
                Write-Log "⚙️ Generating new static files..." "Cyan"
                & ".\scripts\generate.ps1"
                
                # Deploy to live site
                Write-Log "🚀 Deploying to live site..." "Cyan"
                $deployMessage = "Auto-updated routes $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
                & ".\scripts\deploy.ps1" $deployMessage
                
                Write-Log "✅ Auto-update complete!" "Green"
            } else {
                Write-Log "ℹ️  Run with -AutoUpdate flag to automatically update, or manually update using:" "Yellow"
                Write-Log "   1. .\scripts\backup-current.ps1" "White"
                Write-Log "   2. Copy files from temp directory to kmlfiles\" "White"
                Write-Log "   3. .\scripts\generate.ps1" "White"
                Write-Log "   4. .\scripts\deploy.ps1 'Updated routes'" "White"
            }
        } else {
            Write-Log "✅ No updates found - routes are current" "Green"
        }
        
        # Clean up old reports (keep last 7 days)
        $oldReports = Get-ChildItem "route-check-*.json" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) }
        foreach ($oldReport in $oldReports) {
            Remove-Item $oldReport.FullName
            Write-Log "🗑️ Cleaned up old report: $($oldReport.Name)" "Gray"
        }
    } else {
        Write-Log "❌ No report file found - check may have failed" "Red"
    }
    
} catch {
    Write-Log "❌ Error during daily check: $($_.Exception.Message)" "Red"
}

Write-Log "✅ Daily check complete" "Cyan"

# Clean up old log files (keep last 30 days)
$oldLogs = Get-ChildItem "logs\daily-check-*.log" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }
foreach ($oldLog in $oldLogs) {
    Remove-Item $oldLog.FullName
}
