# =============================================================================
# Discord Notification Hook for Idle Prompts
# Part of sop-workflow plugin - Windows PowerShell version
# =============================================================================
# Triggered when Claude Code is waiting for user input (idle)
# =============================================================================

# Discord Webhook URL - UPDATE THIS or set DISCORD_WEBHOOK_URL env var
$DiscordWebhook = if ($env:DISCORD_WEBHOOK_URL) { $env:DISCORD_WEBHOOK_URL } else { "YOUR_WEBHOOK_URL_HERE" }

# Read stdin (contains notification info)
$Input = [Console]::In.ReadToEnd()

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$Hostname = $env:COMPUTERNAME

# Build notification content
$Content = @"
:hourglass_flowing_sand: **Claude Code - Waiting for Response**

:desktop_computer: **Host:** $Hostname
:clock1: **Time:** $Timestamp

Claude Code is idle and waiting for your input.

------------------------
Check your terminal to continue the conversation.
"@

# Create JSON payload
$Payload = @{ content = $Content } | ConvertTo-Json -Compress

# Send to Discord
try {
    Invoke-RestMethod -Uri $DiscordWebhook -Method Post -ContentType "application/json" -Body $Payload -ErrorAction SilentlyContinue | Out-Null
} catch {
    # Ignore errors
}

Write-Output "{}"
