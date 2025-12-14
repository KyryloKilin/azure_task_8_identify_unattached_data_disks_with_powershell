# task.ps1
$ErrorActionPreference = "Stop"

$rg = "mate-azure-task-5"

# Get all disks in required RG
$disks = Get-AzDisk -ResourceGroupName $rg

# Unattached = DiskState == Unattached OR ManagedBy is empty/null
$unattached = $disks | Where-Object {
  ($_.DiskState -eq "Unattached") -or ([string]::IsNullOrEmpty($_.ManagedBy))
}

# IMPORTANT: wrap into @() so JSON starts with [ ... ] always
$result = @(
  $unattached | Select-Object `
    ResourceGroupName,
    Name,
    DiskState,
    ManagedBy,
    Location,
    DiskSizeGB,
    Sku,
    TimeCreated,
    Id
)

# Export to result.json in repo root
$result | ConvertTo-Json -Depth 10 | Set-Content -Path "$PSScriptRoot/result.json" -Encoding utf8
