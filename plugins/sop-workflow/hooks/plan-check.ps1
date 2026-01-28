# Hook: Check for existing plans on session start
# This hook scans for PLAN.md files and notifies about pending work

$DocsDir = Join-Path $PWD "docs"

if (Test-Path $DocsDir) {
    # Find all PLAN.md files
    $PlanFiles = Get-ChildItem -Path $DocsDir -Filter "PLAN.md" -Recurse -File -ErrorAction SilentlyContinue

    if ($PlanFiles) {
        Write-Host "=== EXISTING PLANS DETECTED ==="
        Write-Host ""

        foreach ($plan in $PlanFiles) {
            # Extract topic from path
            $Topic = $plan.DirectoryName -replace [regex]::Escape($DocsDir), '' -replace '^\\', ''

            # Read file content
            $Content = Get-Content $plan.FullName -Raw -ErrorAction SilentlyContinue

            # Get current status
            $StatusMatch = [regex]::Match($Content, '\*\*Status\*\*:\s*(.+)')
            $Status = if ($StatusMatch.Success) { $StatusMatch.Groups[1].Value.Trim() } else { "Unknown" }

            # Get progress
            $ProgressMatch = [regex]::Match($Content, 'Overall Progress:\s*(.+)')
            $Progress = if ($ProgressMatch.Success) { $ProgressMatch.Groups[1].Value.Trim() } else { "Unknown" }

            # Get next task
            $NextTaskMatch = [regex]::Match($Content, '\*\*Next Task\*\*:\s*(.+)')
            $NextTask = if ($NextTaskMatch.Success) { $NextTaskMatch.Groups[1].Value.Trim() } else { "Unknown" }

            Write-Host "Plan: $Topic"
            Write-Host "  File: $($plan.FullName)"
            Write-Host "  Status: $Status"
            Write-Host "  Progress: $Progress"
            Write-Host "  Next: $NextTask"
            Write-Host ""
        }

        Write-Host "To continue work, use: /continue-plan {path-to-PLAN.md}"
        Write-Host "================================"
    }
}
