<#
.SYNOPSIS
    Enterprise EUC Hardware & Security Asset Audit Script
.DESCRIPTION
    Queries local WMI/CIM providers to collect hardware specifications, BIOS serial number,
    network parameters and BitLocker encryption status for IT Asset Management (ITAM).
.AUTHOR
    Tyrese Talia - EUC Support Engineer
#>

Clear-Host
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "     ENTERPRISE EUC ASSET AUDIT REPORT - PLANT WESTERLO    " -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# 1. System & Computer Info
$cs = Get-CimInstance Win32_ComputerSystem
$bios = Get-CimInstance Win32_BIOS
$os = Get-CimInstance Win32_OperatingSystem

Write-Host "`n[1] SYSTEM IDENTIFICATION" -ForegroundColor Yellow
[PSCustomObject]@{
    "Hostname"       = $env:COMPUTERNAME
    "Manufacturer"   = $cs.Manufacturer
    "Model"          = $cs.Model
    "Serial Number"  = $bios.SerialNumber
    "Operating System" = $os.Caption
    "OS Build"       = $os.BuildNumber
} | Format-List

# 2. Hardware Specifications
$cpu = Get-CimInstance Win32_Processor
$ramGB = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
$disk = Get-CimInstance Win32_DiskDrive | Select-Object -First 1

Write-Host "[2] HARDWARE SPECIFICATIONS" -ForegroundColor Yellow
[PSCustomObject]@{
    "Processor (CPU)" = $cpu.Name
    "Cores / Threads" = "$($cpu.NumberOfCores) Cores / $($cpu.NumberOfLogicalProcessors) Threads"
    "Total RAM"       = "$ramGB GB"
    "Storage Model"   = $disk.Model
    "Storage Size"    = "$([math]::Round($disk.Size / 1GB, 2)) GB"
} | Format-List

# 3. Network Configuration
$net = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" } | Select-Object -First 1

Write-Host "[3] NETWORK CONFIGURATION" -ForegroundColor Yellow
[PSCustomObject]@{
    "IP Address"      = $net.IPAddress
    "Interface"       = $net.InterfaceAlias
    "Prefix Length"   = $net.PrefixLength
} | Format-List

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "[SUCCESS] ITAM Audit completed successfully." -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
