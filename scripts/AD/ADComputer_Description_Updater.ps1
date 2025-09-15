<#
.SYNOPSIS
  AD Computer Description Updater

.DESCRIPTION
  Updates AD computer object descriptions based on a CSV file.
  Searches across multiple OUs to locate each computer.
  Designed to pair with the description export script.

.NOTES
  - Requires elevated privileges
  - OU paths are redacted in public repo
  - Output CSV must contain 'Name' and 'Description' columns
  - Built for modular, teachable workflows

.AUTHOR
  HumintToShell (https://github.com/HumintToShell)
#>

# Check for elevation
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script must be run as Administrator."
    exit
}

# Set path to CSV file (update internally)
$csvFile = "C:\REDACTED\AD_Descriptions.csv"

# Import CSV
$computers = Import-Csv $csvFile

# Define OU search bases (update internally)
$searchBases = @(
    "OU=SiteA,DC=yourdomain,DC=com",
    "OU=SiteB,DC=yourdomain,DC=com"
)

# Loop through each computer in the CSV
foreach ($computer in $computers) {
    $found = $false

    foreach ($base in $searchBases) {
        # Try to locate the computer in current OU
        $adComputer = Get-ADComputer -Filter "Name -eq '$($computer.Name)'" -SearchBase $base

        if ($adComputer) {
            # Update description
            Set-ADComputer -Identity $adComputer -Description $computer.Description
            Write-Host "Updated description for $($computer.Name)"
            $found = $true
            break
        }
    }

    if (-not $found) {
        Write-Host "Computer $($computer.Name) not found in defined OUs"
    }
}

# Optional: pause for review
Out-GridView -Title "Update Complete" -Wait
