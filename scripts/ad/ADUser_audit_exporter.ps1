.SYNOPSIS
  AD User Audit Exporter

.DESCRIPTION
  Retrieves selected AD user attributes for audit or review.
  Designed for flexible use—user can modify `Select-Object` to target specific fields.
  Results are displayed in Out-GridView and exported to CSV.

.NOTES
  - Requires elevated privileges
  - OU path must be updated per enclave
  - Output path redacted for public repo
  - Built for audit prep and field review
#>

# Check for elevation
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script must be run as Administrator."
    exit
}

# Get current date for filename suffix
$date = Get-Date -Format "ddMMMyy"

# Query AD users from specified OU
Get-ADUser -Filter * -SearchBase "OU=Redacted,DC=yourdomain,DC=com" -Properties * |
    # Modify this line to select desired attributes
    Select-Object Name, Title, MobilePhone |
    # Review results in grid view
    Out-GridView -Title "AD User Audit" -PassThru |
    # Export selected entries to CSV
    Export-Csv -Path "C:\REDACTED\AD_Audit_$date.csv" -NoTypeInformation
