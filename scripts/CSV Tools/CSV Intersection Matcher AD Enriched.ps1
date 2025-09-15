<#
.SYNOPSIS
  CSV Intersection Matcher with AD Enrichment

.DESCRIPTION
  Compares two CSV files based on a shared key (e.g., email address) and identifies matching entries.
  Optionally enriches matched users with live AD data for reporting or audit purposes.

.NOTES
  - Requires elevation to query AD
  - CSVs must include a shared key column (default: emailaddress)
  - Output is filtered via Out-GridView and exported to CSV

.AUTHOR
  HumintToShell (https://github.com/HumintToShell)
#>

# Check for elevation
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script must be run as Administrator."
    exit
}

# Prompt for shared key column
$key = Read-Host "Enter shared key column name (e.g., emailaddress)"

# Import source CSVs
$csv1 = Import-Csv -Path "C:\REDACTED\Source1.csv"
$csv2 = Import-Csv -Path "C:\REDACTED\Source2.csv"

# Compare by shared key and find matches
$matches = Compare-Object -ReferenceObject $csv2 -DifferenceObject $csv1 -Property $key -IncludeEqual |
    Where-Object { $_.SideIndicator -eq "==" }

# Initialize enriched user list
$userlist = @()

foreach ($match in $matches) {
    $value = $match.$key
    Write-Output "Matching $key: $value"

    $user = Get-ADUser -Filter "$key -eq '$value'" -Properties * |
        Select-Object Name, SamAccountName, Title

    if ($user) { $userlist += $user }
}

# Timestamp for export
$date = Get-Date -Format "ddMMMyy"

# Review and export
$userlist |
    Out-GridView -Title "Matched Users with AD Enrichment" -PassThru |
    Export-Csv -Path "C:\REDACTED\MatchedUsers_$date.csv" -NoTypeInformation
