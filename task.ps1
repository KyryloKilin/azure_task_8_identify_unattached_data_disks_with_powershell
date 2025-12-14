# Write your code here
# task.ps1
$ErrorActionPreference = "Stop"

$rg = "mate-azure-task-5"

# Получаем все managed disks в RG
$disks = Get-AzDisk -ResourceGroupName $rg

# Для понимания значений можно (один раз) посмотреть:
# $disks | Select Name, DiskState, ManagedBy | Format-Table

# Фильтр unattached: либо DiskState == 'Unattached', либо ManagedBy пустой
$unattached = $disks | Where-Object {
    ($_.DiskState -eq "Unattached") -or ($null -eq $_.ManagedBy) -or ($_.ManagedBy -eq "")
}

# Сохраняем полезную инфу (можно больше полей — обычно это ок)
$result = $unattached | Select-Object `
    Name,
    Location,
    DiskSizeGB,
    @{Name="Sku"; Expression = { $_.Sku.Name }},
    DiskState,
    ManagedBy,
    TimeCreated,
    Id

# Экспорт в result.json в корень репо
$result | ConvertTo-Json -Depth 6 | Set-Content -Path "./result.json" -Encoding utf8
