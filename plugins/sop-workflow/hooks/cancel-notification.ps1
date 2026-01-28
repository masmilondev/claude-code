# =============================================================================
# Cancel Notification Hook (PostToolUse) - Fast
# Part of sop-workflow plugin - Windows PowerShell version
# =============================================================================
# Marks pending notifications as "responded" so they won't be sent
# =============================================================================

# Mark ALL pending markers as responded
$MarkerPattern = Join-Path $env:TEMP "claude-perm-*"
Get-ChildItem -Path $MarkerPattern -ErrorAction SilentlyContinue | ForEach-Object {
    "responded" | Set-Content -Path $_.FullName -NoNewline
}

Write-Output "{}"
