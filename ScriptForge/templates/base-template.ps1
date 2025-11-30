# PowerShell Script Template
# Purpose: [What this script does]
# Author: HumintToShell
# Last Modified: [Date]

# Parameters (if useful for quick re-runs)
param(
    [ValidatePattern('...')]  # Add validation if it prevents errors
    $RequiredParam,
    
    $OptionalParam = "default_value"
)

# User prompt with clear example
Write-Host "`n[What do you need?]" -ForegroundColor Cyan
Write-Host "Example: [show actual example]`n" -ForegroundColor Gray
$userInput = Read-Host "Input"

# Simple validation if needed
if ([string]::IsNullOrEmpty($userInput)) {
    Write-Host "Input required" -ForegroundColor Red
    exit
}

# Environment-specific configuration (CUSTOMIZE FOR EACH ENCLAVE)
$SearchBases = @(
    "<YOUR_WORKSTATIONS_OU>",  # e.g., "OU=Office42_Workstations,OU=Region,DC=domain,DC=com"
    "<YOUR_SERVERS_OU>"         # e.g., "OU=Office42_Servers,OU=Region,DC=domain,DC=com"
)

# Get data from AD or other source
$items = @()
foreach ($OU in $SearchBases) {
    try {
        $items += Get-ADComputer -Filter "Name -like '$userInput*'" -SearchBase $OU -ErrorAction Stop
    } catch {
        Write-Warning "Error querying $OU : $_"
    }
}

# Check if we got results
if ($items.Count -eq 0) {
    Write-Host "`nNo items found matching: $userInput" -ForegroundColor Yellow
    exit
}

Write-Host "`nFound $($items.Count) items. Processing...`n" -ForegroundColor Green

# Initialize results
$results = @()
$current = 0
$successCount = 0
$failCount = 0

# Process items with progress
foreach ($item in $items) {
    $current++
    $percent = [math]::Round(($current / $items.Count) * 100)
    
    Write-Host "[$percent%] Processing $item..." -NoNewline
    
    # DO THE ACTUAL WORK HERE
    try {
        # Example: Test-Connection, Set-ADUser, etc.
        $result = Do-Something -Target $item
        
        Write-Host " SUCCESS" -ForegroundColor Green
        $status = "Success"
        $successCount++
        
    } catch {
        Write-Host " FAILED" -ForegroundColor Red
        $status = "Failed"
        $failCount++
    }
    
    # Collect results
    $results += [PSCustomObject]@{
        Item    = $item
        Status  = $status
        Details = $result
    }
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Processing Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total:   $($items.Count)"
Write-Host "Success: $successCount" -ForegroundColor Green
Write-Host "Failed:  $failCount" -ForegroundColor $(if ($failCount -gt 0) { 'Red' } else { 'Gray' })
Write-Host "========================================`n" -ForegroundColor Cyan

# Display results for copy/paste
$results | Out-GridView -Title "Results" -Wait
