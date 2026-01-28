# Hook: Check for existing SOPs on session start
# This hook scans for SOP.md files and notifies about pending work

$SopDir = Join-Path $PWD "docs\SOP"

Write-Host ""
Write-Host "=== CHECKING FOR ACTIVE SOPS ==="
Write-Host ""

if (Test-Path $SopDir) {
    # Find all SOP.md files
    $SopFiles = Get-ChildItem -Path $SopDir -Filter "SOP.md" -Recurse -File -ErrorAction SilentlyContinue

    if ($SopFiles) {
        $ActiveCount = 0
        $CompletedCount = 0

        foreach ($sop in $SopFiles) {
            # Extract topic from path
            $Topic = $sop.DirectoryName -replace [regex]::Escape($SopDir), '' -replace '^\\', ''

            # Read file content
            $Content = Get-Content $sop.FullName -Raw -ErrorAction SilentlyContinue

            # Get current status
            $StatusMatch = [regex]::Match($Content, '\*\*Status\*\*:\s*(.+)')
            $Status = if ($StatusMatch.Success) { $StatusMatch.Groups[1].Value.Trim() } else { "Unknown" }

            # Get progress
            $ProgressMatch = [regex]::Match($Content, 'Overall Progress:\s*(\d+)%')
            $Progress = if ($ProgressMatch.Success) { $ProgressMatch.Groups[1].Value } else { "0" }

            # Get current phase
            $PhaseMatch = [regex]::Match($Content, '\*\*Current Step\*\*:\s*(.+)')
            $Phase = if ($PhaseMatch.Success) { $PhaseMatch.Groups[1].Value.Trim() } else { "Unknown" }

            # Get type
            $TypeMatch = [regex]::Match($Content, '\*\*Type\*\*:\s*(.+)')
            $Type = if ($TypeMatch.Success) { $TypeMatch.Groups[1].Value.Trim() } else { "Unknown" }

            if ($Status -eq "COMPLETED") {
                $CompletedCount++
            } else {
                $ActiveCount++
                Write-Host "SOP: $Topic"
                Write-Host "  Type: $Type"
                Write-Host "  Status: $Status"
                Write-Host "  Progress: $Progress%"
                Write-Host "  Current: $Phase"
                Write-Host "  File: $($sop.FullName)"

                # Check for linked plan
                $PlanPathMatch = [regex]::Match($Content, '\- \*\*Path\*\*:\s*`([^`]+)`')
                if ($PlanPathMatch.Success) {
                    $PlanPath = $PlanPathMatch.Groups[1].Value
                    $FullPlanPath = Join-Path $PWD $PlanPath
                    if (Test-Path $FullPlanPath) {
                        $PlanContent = Get-Content $FullPlanPath -Raw -ErrorAction SilentlyContinue
                        $PlanProgressMatch = [regex]::Match($PlanContent, 'Overall Progress:\s*(.+)')
                        $PlanProgress = if ($PlanProgressMatch.Success) { $PlanProgressMatch.Groups[1].Value.Trim() } else { "Unknown" }
                        Write-Host "  Plan: $PlanPath ($PlanProgress)"
                    }
                }
                Write-Host ""
            }
        }

        Write-Host "--------------------------------"
        Write-Host "Active SOPs: $ActiveCount"
        Write-Host "Completed SOPs: $CompletedCount"
        Write-Host ""

        if ($ActiveCount -gt 0) {
            Write-Host "To continue work:"
            Write-Host '  "Read docs/SOP/{topic}/{subtopic}/SOP.md and continue"'
            Write-Host ""
            Write-Host "To check status:"
            Write-Host '  "Read docs/SOP/{topic}/{subtopic}/SOP.md and show status"'
        }
    } else {
        Write-Host "No SOPs found."
        Write-Host ""
        Write-Host "To create a new SOP:"
        Write-Host '  "Read .claude/commands/sop.md and create SOP for: {your request}"'
    }
} else {
    Write-Host "No SOP directory found."
    Write-Host ""
    Write-Host "To create a new SOP:"
    Write-Host '  "Read .claude/commands/sop.md and create SOP for: {your request}"'
}

Write-Host ""
Write-Host "================================"
Write-Host ""
