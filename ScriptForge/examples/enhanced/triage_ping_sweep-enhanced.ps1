# Network Triage - Ping Sweep by Site Prefix
# Purpose: Quick check of computer reachability during connectivity issues
# Author: HumintToShell
# Last Modified: 2024-11-30

param(
    [ValidatePattern('^[A-Za-z]{2,4}$')]
    $Prefix,
    
    $SearchBases = @(
        "<YOUR_WORKSTATIONS_OU>",
        "<YOUR_SERVERS_OU>"
    ),
    
    [ValidateRange(1,30)]
    [int]$Timeout = 2
)

# Prompt for prefix if not provided
if ([string]::IsNullOrEmpty($Prefix)) {
    Write-Host "`nComputer Prefix (2 chars for AOR, 4 chars for site)" -ForegroundColor Cyan
    Write-Host "Example: 'AB' for entire AOR, 'ABCD' for specific site`n" -ForegroundColor Gray
    
    do {
        $Prefix = Read-Host "Prefix"
        if ($Prefix -notmatch '^[A-Za-z]{2,4}$') {
            Write-Host "Must be 2-4 letters. Try again." -ForegroundColor Red
        }
    } while ($Prefix -notmatch '^[A-Za-z]{2,4}$')
}

$Prefix = $Prefix.ToUpper()

# Get computers from AD
Write-Host "`nSearching for computers matching: $Prefix*" -ForegroundColor Cyan

$computers = @()
foreach ($OU in $SearchBases) {
    try {
        $computers += Get-ADComputer -Filter "Name -like '$Prefix*'" -SearchBase $OU -ErrorAction Stop | 
            Select-Object -ExpandProperty Name
    } catch {
        Write-Warning "Error searching $OU : $_"
    }
}

if ($computers.Count -eq 0) {
    Write-Host "`nNo computers found matching: $Prefix*" -ForegroundColor Yellow
    exit
}

# Remove duplicates and sort
$computers = $computers | Select-Object -Unique | Sort-Object

Write-Host "Found $($computers.Count) computers. Starting ping sweep...`n" -ForegroundColor Green

# Ping each computer
$results = @()
$current = 0
$reachable = 0
$unreachable = 0

foreach ($computer in $computers) {
    $current++
    $percent = [math]::Round(($current / $computers.Count) * 100)
    
    Write-Host "[$percent%] Pinging $computer..." -NoNewline
    
    $ping = Test-Connection -ComputerName $computer -Count 1 -TimeoutSeconds $Timeout -Quiet
    
    if ($ping) {
        Write-Host " SUCCESS" -ForegroundColor Green
        $status = "Reachable"
        $reachable++
    } else {
        Write-Host " FAILED" -ForegroundColor Red
        $status = "Not Reachable"
        $unreachable++
    }
    
    $results += [PSCustomObject]@{
        Computer = $computer
        Status   = $status
    }
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Ping Sweep Results: $Prefix*" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total:         $($computers.Count)"
Write-Host "Reachable:     $reachable" -ForegroundColor Green
Write-Host "Not Reachable: $unreachable" -ForegroundColor $(if ($unreachable -gt 0) { 'Red' } else { 'Gray' })
Write-Host "========================================`n" -ForegroundColor Cyan

# GridView for copy/paste
$results | Out-GridView -Title "Ping Results: $Prefix*" -Wait
