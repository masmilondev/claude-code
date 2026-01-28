# =============================================================================
# Discord Notification Hook for Delete Operations
# Part of sop-workflow plugin - Windows PowerShell version
# =============================================================================

param(
    [string]$Command
)

# Discord Webhook URL - Update this with your webhook
$DiscordWebhook = if ($env:DISCORD_WEBHOOK_URL) { $env:DISCORD_WEBHOOK_URL } else { "YOUR_WEBHOOK_URL_HERE" }

# Extract what's being deleted
$DeleteTarget = if ($Command -match 'rm\s+(.+)') { $Matches[1] } else { $Command }

# Current timestamp
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Working directory
$WorkingDir = Get-Location

# Computer/hostname
$Hostname = $env:COMPUTERNAME

# Build Discord message
$Message = @{
    content = @"
:wastebasket: **Delete Request Alert** :wastebasket:

**Computer:** $Hostname
**Time:** $Timestamp
**Directory:** $WorkingDir
**Command:** ``$DeleteTarget``

:warning: Claude Code is requesting to delete files.
:stopwatch: Waiting for your approval in terminal...
"@
} | ConvertTo-Json -Compress

# Send to Discord (in background, non-blocking)
Start-Job -ScriptBlock {
    param($Webhook, $Message)
    try {
        Invoke-RestMethod -Uri $Webhook -Method Post -ContentType "application/json" -Body $Message -ErrorAction SilentlyContinue | Out-Null
    } catch {
        # Ignore errors
    }
} -ArgumentList $DiscordWebhook, $Message | Out-Null

# Exit with 0 to allow the permission prompt to continue
exit 0
