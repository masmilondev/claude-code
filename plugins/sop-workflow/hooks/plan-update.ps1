# Hook: Update plan file timestamp
# Called after task completion to update Last Updated field

param(
    [Parameter(Mandatory=$true)]
    [string]$PlanFile
)

$Today = Get-Date -Format "yyyy-MM-dd"

if (Test-Path $PlanFile) {
    # Read file content
    $Content = Get-Content $PlanFile -Raw

    # Update Last Updated date
    $Content = $Content -replace '\*\*Last Updated\*\*:\s*\d{4}-\d{2}-\d{2}', "**Last Updated**: $Today"

    # Write updated content
    Set-Content -Path $PlanFile -Value $Content -NoNewline

    Write-Host "Plan updated: $PlanFile"
}
