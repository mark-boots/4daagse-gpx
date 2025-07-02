# Check for updates to 4Daagse routes
# This script extracts Google Maps KML URLs from local KML files and compares the actual route data

param(
    [switch]$Force,
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# Set output encoding to UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Configuration
$WorkspaceRoot = Split-Path -Parent $PSScriptRoot
$KmlDir = Join-Path $WorkspaceRoot "kmlfiles"
$ChecksumFile = Join-Path $WorkspaceRoot "route-checksums.json"
$LogFile = Join-Path $WorkspaceRoot "update-check.log"

# Ensure log file exists
if (-not (Test-Path $LogFile)) {
    New-Item -ItemType File -Path $LogFile -Force | Out-Null
}

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    Write-Host $logEntry
    Add-Content -Path $LogFile -Value $logEntry -Encoding UTF8
}

function Get-StringChecksum {
    param([string]$Content)
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Content)
    $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
    return [System.BitConverter]::ToString($hash) -replace '-', ''
}

function Extract-KmlUrl {
    param([string]$KmlFilePath)
    try {
        $content = Get-Content -Path $KmlFilePath -Raw -Encoding UTF8
        
        # Extract URL from <href><![CDATA[...]]></href>
        if ($content -match '<href><!\[CDATA\[(.*?)\]\]></href>') {
            return $matches[1]
        }
        
        # Fallback: Extract URL from simple <href>...</href>
        if ($content -match '<href>(.*?)</href>') {
            return $matches[1]
        }
        
        Write-Log "Warning: Could not find href URL in $KmlFilePath"
        return $null
    } catch {
        Write-Log "Error reading KML file $KmlFilePath : $($_.Message)"
        return $null
    }
}

function Download-RouteData {
    param([string]$Url)
    try {
        Write-Log "Downloading route data from: $Url"
        
        # Create web request with proper headers
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")
        $webClient.Headers.Add("Accept", "application/vnd.google-earth.kml+xml,application/xml,text/xml,*/*")
        $webClient.Headers.Add("Accept-Language", "en-US,en;q=0.9,nl;q=0.8")
        
        $data = $webClient.DownloadString($Url)
        $webClient.Dispose()
        
        Write-Log "Successfully downloaded $($data.Length) characters"
        return $data
    } catch {
        Write-Log "Error downloading from $Url : $($_.Message)"
        return $null
    }
}

function Load-Checksums {
    if (Test-Path $ChecksumFile) {
        try {
            $content = Get-Content -Path $ChecksumFile -Raw -Encoding UTF8
            $jsonData = $content | ConvertFrom-Json
            
            # Convert PSCustomObject to hashtable for easier access
            $hashtable = @{}
            $jsonData.PSObject.Properties | ForEach-Object {
                $hashtable[$_.Name] = $_.Value
            }
            return $hashtable
        } catch {
            Write-Log "Warning: Could not load existing checksums: $($_.Message)"
            return @{}
        }
    }
    return @{}
}

function Save-Checksums {
    param([hashtable]$Checksums)
    $json = $Checksums | ConvertTo-Json -Depth 10
    Set-Content -Path $ChecksumFile -Value $json -Encoding UTF8
}

# Main execution
try {
    Write-Log "=== 4Daagse Route Update Checker ==="
    Write-Log "Checking actual Google Maps KML data for changes..."
    Write-Host ""
    
    if (-not (Test-Path $KmlDir)) {
        Write-Log "Error: KML directory not found: $KmlDir"
        exit 1
    }

    # Load existing checksums
    $existingChecksums = Load-Checksums
    $currentChecksums = @{}
    $changedFiles = @()

    # Check each KML file
    $kmlFiles = Get-ChildItem -Path $KmlDir -Filter "*.kml"
    Write-Log "Found $($kmlFiles.Count) KML files to check"
    Write-Host ""

    foreach ($file in $kmlFiles) {
        Write-Host "Processing: $($file.Name)" -ForegroundColor Cyan
        
        try {
            # Extract the Google Maps KML URL
            $kmlUrl = Extract-KmlUrl -KmlFilePath $file.FullName
            if (-not $kmlUrl) {
                Write-Host "  [ERROR] No URL found in KML file" -ForegroundColor Red
                continue
            }
            
            Write-Host "  URL: $kmlUrl" -ForegroundColor Gray
            
            # Download the actual route data
            $routeData = Download-RouteData -Url $kmlUrl
            if (-not $routeData) {
                Write-Host "  [ERROR] Download failed" -ForegroundColor Red
                continue
            }
            
            # Calculate checksum of the route data
            $currentHash = Get-StringChecksum -Content $routeData
            $currentChecksums[$file.Name] = @{
                "url" = $kmlUrl
                "hash" = $currentHash
                "lastChecked" = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
                "dataSize" = $routeData.Length
            }
            
            Write-Host "  Downloaded: $($routeData.Length) characters" -ForegroundColor Gray
            Write-Host "  Hash: $($currentHash.Substring(0,16))..." -ForegroundColor Gray
            
            if ($existingChecksums.ContainsKey($file.Name)) {
                $existingHash = $existingChecksums[$file.Name].hash
                if ($existingHash -ne $currentHash) {
                    Write-Host "  [CHANGED] Route data has been modified!" -ForegroundColor Yellow
                    $changedFiles += $file.Name
                } else {
                    Write-Host "  [OK] No changes detected" -ForegroundColor Green
                }
            } else {
                Write-Host "  [NEW] First time checking this route" -ForegroundColor Cyan
                $changedFiles += $file.Name
            }
        } catch {
            Write-Host "  [ERROR] $($_.Message)" -ForegroundColor Red
            Write-Log "Error processing $($file.Name): $($_.Message)"
        }
        
        Write-Host ""
    }

    # Save current checksums
    Save-Checksums -Checksums $currentChecksums

    # Report results
    Write-Host "=== SUMMARY ===" -ForegroundColor White -BackgroundColor DarkBlue
    Write-Host ""
    
    if ($changedFiles.Count -gt 0) {
        Write-Host "UPDATES FOUND! $($changedFiles.Count) route(s) changed:" -ForegroundColor Green -BackgroundColor DarkGreen
        Write-Host ""
        foreach ($file in $changedFiles) {
            Write-Host "  • $file" -ForegroundColor Yellow
        }
        
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Cyan
        Write-Host "1. Backup current files: .\scripts\backup-current.ps1" -ForegroundColor White
        Write-Host "2. Update routes: .\scripts\update-routes.ps1" -ForegroundColor White
        Write-Host "3. Deploy changes: .\scripts\deploy.ps1 'Updated routes'" -ForegroundColor White
        
        if ($Force) {
            Write-Host ""
            Write-Host "Auto-updating (Force mode enabled)..." -ForegroundColor Yellow
            & "$PSScriptRoot\update-routes.ps1"
        }
        
        exit 2  # Exit code 2 indicates updates are available
    } else {
        Write-Host "NO UPDATES" -ForegroundColor Green -BackgroundColor DarkGreen
        Write-Host "All routes are up to date!" -ForegroundColor Green
        exit 0
    }

} catch {
    Write-Log "Error during update check: $($_.Message)"
    Write-Log "Stack trace: $($_.ScriptStackTrace)"
    Write-Host "Error: $($_.Message)" -ForegroundColor Red
    exit 1
}
