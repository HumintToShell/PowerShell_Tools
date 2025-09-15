# Local Admin Password Exporter (LAPS)

## Purpose

This script retrieves LAPS-managed local admin passwords for machines matching a site-specific prefix.  
Designed for use during site visits where network access may be limited or unavailable.

## Usage

- Run with elevated privileges (Administrator required)
- Prompts for site prefix via GUI (VisualBasic InputBox)
- Filters AD computers by prefix and OU
- Retrieves `ms-Mcs-AdmPwd` property for each machine
- Displays results in Out-GridView for review
- Exports selected entries to CSV with date-stamped filename

## Parameters

| Parameter     | Description                                  |
|---------------|----------------------------------------------|
| `Prefix`      | Computer name prefix used to filter machines |
| `SearchBase`  | OU path(s) to scope the AD query             |

> ⚠️ OU paths are redacted in public repo. Replace with enclave-specific values before internal deployment.

## Output

- Interactive grid view for user selection
- CSV export to designated folder (path redacted in public version)

## Notes

- Requires elevated privileges to access LAPS attributes
- VisualBasic InputBox used for quick GUI prompt; can be swapped for `Read-Host` if needed
- Script is designed for pre-deployment credential prep, not persistent logging

## Example

```powershell
# Prompt for prefix
$Prefix = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Computer Name Prefix")

# Retrieve passwords
Get-ADComputer -Filter "Name -like '$Prefix*'" -Properties ms-Mcs-AdmPwd
