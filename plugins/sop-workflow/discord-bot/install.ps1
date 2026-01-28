# =============================================================================
# Claude Code Discord Bot - Windows Installation Script
# =============================================================================

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "     Claude Code Discord Bot - Windows Installation         " -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Check for Node.js
try {
    $nodeVersion = node -v
    Write-Host "[OK] Node.js found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Node.js is not installed!" -ForegroundColor Red
    Write-Host "   Please install Node.js first: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Check for npm
try {
    $npmVersion = npm -v
    Write-Host "[OK] npm found: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] npm is not installed!" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Install dependencies
Write-Host "Installing dependencies..." -ForegroundColor Yellow
Set-Location $ScriptDir
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to install dependencies" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Dependencies installed" -ForegroundColor Green
Write-Host ""

# Check for config.json
$configPath = Join-Path $ScriptDir "config.json"
$configExamplePath = Join-Path $ScriptDir "config.example.json"

if (-not (Test-Path $configPath)) {
    Write-Host "[INFO] config.json not found!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Creating config.json from template..." -ForegroundColor Yellow
    Copy-Item $configExamplePath $configPath
    Write-Host ""
    Write-Host "Please edit config.json with your Discord bot token:" -ForegroundColor Cyan
    Write-Host "   $configPath" -ForegroundColor White
    Write-Host ""
    Write-Host "   You need to:" -ForegroundColor Yellow
    Write-Host "   1. Go to https://discord.com/developers/applications" -ForegroundColor White
    Write-Host "   2. Create a new application" -ForegroundColor White
    Write-Host "   3. Go to 'Bot' section and create a bot" -ForegroundColor White
    Write-Host "   4. Copy the bot token" -ForegroundColor White
    Write-Host "   5. Enable 'MESSAGE CONTENT INTENT' in Bot settings" -ForegroundColor White
    Write-Host "   6. Paste token in config.json" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "[OK] config.json exists" -ForegroundColor Green
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "              Installation Complete!                         " -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To start the bot:" -ForegroundColor Yellow
Write-Host "  cd $ScriptDir" -ForegroundColor White
Write-Host "  npm start" -ForegroundColor White
Write-Host ""
Write-Host "Or use the start script:" -ForegroundColor Yellow
Write-Host "  .\start.ps1" -ForegroundColor White
Write-Host ""

# Optional: Ask about Task Scheduler setup
Write-Host "Would you like to set up auto-start on login? (y/n)" -ForegroundColor Yellow
$autoStart = Read-Host

if ($autoStart -eq 'y' -or $autoStart -eq 'Y') {
    $taskName = "ClaudeCodeDiscordBot"
    $nodePath = (Get-Command node).Path
    $botPath = Join-Path $ScriptDir "bot.js"

    # Create scheduled task
    $action = New-ScheduledTaskAction -Execute $nodePath -Argument "`"$botPath`"" -WorkingDirectory $ScriptDir
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

    try {
        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
        Write-Host "[OK] Scheduled task created: $taskName" -ForegroundColor Green
        Write-Host ""
        Write-Host "   To start the bot now:" -ForegroundColor Yellow
        Write-Host "   Start-ScheduledTask -TaskName $taskName" -ForegroundColor White
        Write-Host ""
        Write-Host "   To remove auto-start:" -ForegroundColor Yellow
        Write-Host "   Unregister-ScheduledTask -TaskName $taskName -Confirm:`$false" -ForegroundColor White
    } catch {
        Write-Host "[ERROR] Failed to create scheduled task: $_" -ForegroundColor Red
        Write-Host "   You may need to run this script as Administrator" -ForegroundColor Yellow
    }
}

Write-Host ""
