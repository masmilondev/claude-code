# =============================================================================
# Discord Notification Hook for Permission Requests (PreToolUse)
# Part of sop-workflow plugin - Windows PowerShell version
# =============================================================================
# Waits before sending notification
# If user responds within delay, notification is cancelled
# PostToolUse hook (cancel-notification.ps1) marks as "responded"
# =============================================================================

# Discord Webhook URL - UPDATE THIS or set DISCORD_WEBHOOK_URL env var
$DiscordWebhook = if ($env:DISCORD_WEBHOOK_URL) { $env:DISCORD_WEBHOOK_URL } else { "YOUR_WEBHOOK_URL_HERE" }

# Delay before sending notification (seconds)
$NotificationDelay = if ($env:NOTIFICATION_DELAY) { [int]$env:NOTIFICATION_DELAY } else { 10 }

# Read stdin
$Input = [Console]::In.ReadToEnd()

# Generate unique ID
$RequestId = "{0}_{1}" -f (Get-Date -UFormat %s), $PID
$MarkerFile = Join-Path $env:TEMP "claude-perm-$RequestId"
$DataFile = Join-Path $env:TEMP "claude-notif-data-$RequestId"

# Create marker
"pending" | Set-Content -Path $MarkerFile -NoNewline

# Extract tool info using regex
$ToolNameMatch = [regex]::Match($Input, '"tool_name"\s*:\s*"([^"]*)"')
$ToolName = if ($ToolNameMatch.Success) { $ToolNameMatch.Groups[1].Value } else { "Unknown" }

$FilePathMatch = [regex]::Match($Input, '"file_path"\s*:\s*"([^"]*)"')
$FilePath = if ($FilePathMatch.Success) { $FilePathMatch.Groups[1].Value } else { "" }

$CommandMatch = [regex]::Match($Input, '"command"\s*:\s*"([^"]*)"')
$Command = if ($CommandMatch.Success) { $CommandMatch.Groups[1].Value.Substring(0, [Math]::Min(300, $CommandMatch.Groups[1].Value.Length)) } else { "" }

$OldStringMatch = [regex]::Match($Input, '"old_string"\s*:\s*"([^"]*)"')
$OldString = if ($OldStringMatch.Success) { $OldStringMatch.Groups[1].Value.Substring(0, [Math]::Min(200, $OldStringMatch.Groups[1].Value.Length)) } else { "" }

$NewStringMatch = [regex]::Match($Input, '"new_string"\s*:\s*"([^"]*)"')
$NewString = if ($NewStringMatch.Success) { $NewStringMatch.Groups[1].Value.Substring(0, [Math]::Min(200, $NewStringMatch.Groups[1].Value.Length)) } else { "" }

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$Hostname = $env:COMPUTERNAME

# Build message content based on tool type
if ($ToolName -eq "Edit") {
    $Filename = Split-Path $FilePath -Leaf
    $OldClean = $OldString -replace '\\n', ' ' -replace '\\t', ' ' -replace '\s+', ' '
    $NewClean = $NewString -replace '\\n', ' ' -replace '\\t', ' ' -replace '\s+', ' '

    $Content = @"
:pencil2: **Claude Code - Edit Request**

:desktop_computer: **Host:** $Hostname
:clock1: **Time:** $Timestamp

:page_facing_up: **File:** ``$Filename``

:red_circle: **Remove:**
``````
$OldClean
``````

:green_circle: **Add:**
``````
$NewClean
``````

**Do you want to make this edit?**

:stopwatch: _Waiting for your response..._

------------------------
**Reply:** ``0`` Esc  |  ``1`` Yes  |  ``2`` Yes all  |  ``3 msg`` No
"@
}
elseif ($ToolName -eq "Write") {
    $Filename = Split-Path $FilePath -Leaf

    $Content = @"
:memo: **Claude Code - Write Request**

:desktop_computer: **Host:** $Hostname
:clock1: **Time:** $Timestamp

:page_facing_up: **File:** ``$Filename``

Create or overwrite this file.

**Do you want to write this file?**

:stopwatch: _Waiting for your response..._

------------------------
**Reply:** ``0`` Esc  |  ``1`` Yes  |  ``2`` Yes all  |  ``3 msg`` No
"@
}
elseif ($ToolName -eq "Bash") {
    $CmdClean = $Command -replace '\\n', ' ' -replace '\\t', ' ' -replace '\s+', ' '

    $Content = @"
:zap: **Claude Code - Run Command**

:desktop_computer: **Host:** $Hostname
:clock1: **Time:** $Timestamp

:computer: **Command:**
``````
$CmdClean
``````

**Do you want to run this command?**

:stopwatch: _Waiting for your response..._

------------------------
**Reply:** ``0`` Esc  |  ``1`` Yes  |  ``2`` Yes all  |  ``3 msg`` No
"@
}
else {
    $Content = @"
:bell: **Claude Code - Permission Request**

:desktop_computer: **Host:** $Hostname
:clock1: **Time:** $Timestamp

:wrench: **Action:** $ToolName

**Do you want to allow this?**

:stopwatch: _Waiting for your response..._

------------------------
**Reply:** ``0`` Esc  |  ``1`` Yes  |  ``2`` Yes all  |  ``3 msg`` No
"@
}

# Save content to file for background process
$Content | Set-Content -Path $DataFile -NoNewline

# Background process using Start-Job
$ScriptBlock = {
    param($Delay, $MarkerFile, $DataFile, $Webhook, $RequestId)

    Start-Sleep -Seconds $Delay

    if ((Test-Path $MarkerFile) -and ((Get-Content $MarkerFile -Raw) -eq "pending")) {
        $Content = Get-Content $DataFile -Raw
        $Payload = @{ content = $Content } | ConvertTo-Json -Compress

        try {
            Invoke-RestMethod -Uri $Webhook -Method Post -ContentType "application/json" -Body $Payload -ErrorAction SilentlyContinue | Out-Null
        } catch {
            # Ignore errors
        }
    }

    Remove-Item -Path $MarkerFile -ErrorAction SilentlyContinue
    Remove-Item -Path $DataFile -ErrorAction SilentlyContinue
}

Start-Job -ScriptBlock $ScriptBlock -ArgumentList $NotificationDelay, $MarkerFile, $DataFile, $DiscordWebhook, $RequestId | Out-Null

Write-Output "{}"
