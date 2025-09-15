.SYNOPSIS
  AD Computer Description Exporter

.DESCRIPTION
  Retrieves computer names and descriptions from AD, scoped by prefix across multiple OUs.
  Designed for audit prep and bulk editing workflows. Results are reviewed in Out-GridView and exported to CSV.
  Companion script applies changes from CSV back to AD.

.NOTES
  - OU paths are redacted in public repo
  - Output path should be updated before internal deployment
  - Script is read-only and safe for audit use
  - Built for modular, teachable workflows

.AUTHOR
  HumintToShell (https://github.com/HumintToShell)
#>

# Prompt for computer name prefix
Add-Type -AssemblyName Microsoft.VisualBasic
$prefix = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Computer Name Prefix / Location")

# Get current date for filename suffix
$date = Get-Date -Format "ddMMMyy"

# Define OU search bases (update internally)
$searchBases = @(
    "OU=SiteA,DC=yourdomain,DC=com",
    "OU=SiteB,DC=yourdomain,DC=com"
)

# Initialize results array
$computers = @()

# Query both OUs and filter by prefix
foreach ($base in $searchBases) {
    $computers += Get-ADComputer -Filter "Name -like '$prefix*'" -SearchBase $base -Properties *
}

# Select name and description, then pass to grid view
$computers |
    Select-Object Name, Description |
    Out-GridView -Title "Review Computer Descriptions" -PassThru |
    Export-Csv -Path "C:\REDACTED\AD_Descriptions_$date.csv" -NoTypeInformation
