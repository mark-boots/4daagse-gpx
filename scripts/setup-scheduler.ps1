# Setup Windows Task Scheduler for Daily Route Checking
# This script creates a scheduled task to check for route updates daily

param(
    [string]$Time = "08:00",       # Time to run daily check (24-hour format)
    [switch]$AutoUpdate = $false,  # Whether to auto-update when changes found
    [switch]$Remove = $false       # Remove the scheduled task
)

$taskName = "4Daagse Route Checker"
$scriptPath = Join-Path (Get-Location) "scripts\daily-check.ps1"

if ($Remove) {
    Write-Host "🗑️ Removing scheduled task..." -ForegroundColor Yellow
    try {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction Stop
        Write-Host "✅ Scheduled task removed successfully" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error removing task: $($_.Exception.Message)" -ForegroundColor Red
    }
    return
}

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (!$isAdmin) {
    Write-Host "⚠️  This script needs to run as Administrator to create scheduled tasks" -ForegroundColor Yellow
    Write-Host "Please run PowerShell as Administrator and try again" -ForegroundColor Yellow
    return
}

Write-Host "⏰ Setting up daily route checker..." -ForegroundColor Cyan
Write-Host "   Time: $Time daily" -ForegroundColor White
Write-Host "   Auto-update: $AutoUpdate" -ForegroundColor White
Write-Host ""

# Create the action
$arguments = "-ExecutionPolicy Bypass -File `"$scriptPath`""
if ($AutoUpdate) {
    $arguments += " -AutoUpdate"
}
$arguments += " -Quiet"

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $arguments -WorkingDirectory (Get-Location)

# Create the trigger (daily at specified time)
$trigger = New-ScheduledTaskTrigger -Daily -At $Time

# Create task settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Create the principal (run as current user)
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive

# Register the task
try {
    $task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -Principal $principal
    Register-ScheduledTask -TaskName $taskName -InputObject $task -Force | Out-Null
    
    Write-Host "✅ Scheduled task created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📅 Task Details:" -ForegroundColor Cyan
    Write-Host "   Name: $taskName" -ForegroundColor White
    Write-Host "   Schedule: Daily at $Time" -ForegroundColor White
    Write-Host "   Script: $scriptPath" -ForegroundColor White
    Write-Host "   Auto-update: $AutoUpdate" -ForegroundColor White
    Write-Host ""
    Write-Host "🔧 Management Commands:" -ForegroundColor Yellow
    Write-Host "   View task: Get-ScheduledTask -TaskName '$taskName'" -ForegroundColor White
    Write-Host "   Run now: Start-ScheduledTask -TaskName '$taskName'" -ForegroundColor White
    Write-Host "   Remove: .\scripts\setup-scheduler.ps1 -Remove" -ForegroundColor White
    Write-Host ""
    Write-Host "📁 Logs will be saved to: logs\daily-check-YYYY-MM-DD.log" -ForegroundColor Gray
    
} catch {
    Write-Host "❌ Error creating scheduled task: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎯 What happens daily:" -ForegroundColor Cyan
if ($AutoUpdate) {
    Write-Host "   1. Check for route updates" -ForegroundColor White
    Write-Host "   2. If updates found: backup → update → deploy automatically" -ForegroundColor White
    Write-Host "   3. Log results" -ForegroundColor White
} else {
    Write-Host "   1. Check for route updates" -ForegroundColor White
    Write-Host "   2. If updates found: log notification (manual update required)" -ForegroundColor White
    Write-Host "   3. Log results" -ForegroundColor White
}
