# Hook: Update SOP file timestamp and optionally sync with PLAN.md
# Usage: sop-update.ps1 <sop_file> [sync]

param(
    [Parameter(Mandatory=$true)]
    [string]$SopFile,
    [string]$SyncMode
)

$Today = Get-Date -Format "yyyy-MM-dd"

if (-not (Test-Path $SopFile)) {
    Write-Host "Error: SOP file not found: $SopFile"
    exit 1
}

Write-Host "Updating SOP: $SopFile"

# Read file content
$Content = Get-Content $SopFile -Raw

# Update Last Updated date
$Content = $Content -replace '\*\*Last Updated\*\*:\s*\d{4}-\d{2}-\d{2}', "**Last Updated**: $Today"

# Calculate progress
$TotalTasks = 25
$PhaseCompleted = ([regex]::Matches($Content, '^\- \[x\] \*\*\d', [System.Text.RegularExpressions.RegexOptions]::Multiline)).Count
$Percent = [math]::Floor($PhaseCompleted * 100 / $TotalTasks)

Write-Host "Progress: $PhaseCompleted/$TotalTasks tasks ($Percent%)"

# Update overall progress line
$Content = $Content -replace '\*\*Overall Progress\*\*:\s*\d+%\s*\(\d+/\d+\s*steps\)', "**Overall Progress**: $Percent% ($PhaseCompleted/$TotalTasks steps)"

# Write updated content
Set-Content -Path $SopFile -Value $Content -NoNewline

# If sync mode, also update linked PLAN.md
if ($SyncMode -eq "sync") {
    # Extract plan path from SOP
    $PlanPathMatch = [regex]::Match($Content, '\- \*\*Path\*\*:\s*`([^`]+)`')

    if ($PlanPathMatch.Success) {
        $PlanPath = $PlanPathMatch.Groups[1].Value
        $FullPlanPath = Join-Path $PWD $PlanPath

        if (Test-Path $FullPlanPath) {
            Write-Host "Syncing with PLAN: $PlanPath"

            $PlanContent = Get-Content $FullPlanPath -Raw

            # Update plan timestamp
            $PlanContent = $PlanContent -replace '\*\*Last Updated\*\*:\s*\d{4}-\d{2}-\d{2}', "**Last Updated**: $Today"

            # Get plan progress
            $PlanCompleted = ([regex]::Matches($PlanContent, '\[x\]')).Count
            $PlanIncomplete = ([regex]::Matches($PlanContent, '\[ \]')).Count
            $PlanTotal = $PlanCompleted + $PlanIncomplete

            if ($PlanTotal -gt 0) {
                $PlanPercent = [math]::Floor($PlanCompleted * 100 / $PlanTotal)
                Write-Host "Plan Progress: $PlanCompleted/$PlanTotal tasks ($PlanPercent%)"
            }

            Set-Content -Path $FullPlanPath -Value $PlanContent -NoNewline
        } else {
            Write-Host "Warning: Linked plan not found: $PlanPath"
        }
    } else {
        Write-Host "No linked plan found in SOP"
    }
}

Write-Host "SOP updated successfully"
