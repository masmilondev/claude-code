# =============================================================================
# Claude Code Discord Bot - Windows Start Script
# =============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

Write-Host "Starting Claude Code Discord Bot..." -ForegroundColor Cyan
Write-Host ""

# Check if config exists
$configPath = Join-Path $ScriptDir "config.json"
if (-not (Test-Path $configPath)) {
    Write-Host "[ERROR] config.json not found!" -ForegroundColor Red
    Write-Host "   Run install.ps1 first to set up the bot." -ForegroundColor Yellow
    exit 1
}

# Check if node_modules exists
$nodeModulesPath = Join-Path $ScriptDir "node_modules"
if (-not (Test-Path $nodeModulesPath)) {
    Write-Host "[INFO] Dependencies not installed. Running npm install..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to install dependencies" -ForegroundColor Red
        exit 1
    }
}

# Start the bot
node bot.js
