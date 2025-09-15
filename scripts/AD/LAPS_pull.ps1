<#
.SYNOPSIS
  Local Admin Password Exporter (LAPS)

.DESCRIPTION
  Retrieves LAPS passwords for computers matching a prefix.
  Designed for site visits where network access may be limited.
  Filters by OU and exports results to CSV after user review.

.NOTES
  - Requires elevated privileges
  - OU path must be updated per enclave
  - VisualBasic InputBox used for quick GUI prompt
  - Output path redacted for public repo
#>

# Check for elevation
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script must be run as Administrator."
    exit
}

# Prompt for computer name prefix
Add-Type -AssemblyName Microsoft.VisualBasic
$Prefix = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Computer Name Prefix")

# Define OU search bases (update per enclave)
$searchBases = @(
    "OU=SiteA,DC=yourdomain,DC=com",  # <-- Replace with actual OU paths internally
    "OU=SiteB,DC=yourdomain,DC=com"
)

# Collect matching computer names
$computers = @()
foreach ($base in $searchBases) {
    $computers += Get-ADComputer -Filter "Name -like '$Prefix*'" -SearchBase $base -Properties * |
        Select-Object -ExpandProperty Name
}

# Get current date for filename suffix
$date = Get-Date -Format "ddMMMyyyy"

# Initialize array to store passwords
$AdmPwd = @()

# Retrieve LAPS password for each computer
foreach ($computername in $computers) {
    Write-Host "Retrieving password for $computername..."
    $password = Get-ADComputer -Identity $computername -Properties ms-Mcs-AdmPwd |
        Select-Object Name, ms-Mcs-AdmPwd
    $AdmPwd += $password
}

# Review results in grid view, then export to CSV
$AdmPwd | Out-GridView -Title "LAPS Passwords" -PassThru |
    Export-Csv -Path "C:\REDACTED\LAPS_$date.csv" -NoTypeInformation
