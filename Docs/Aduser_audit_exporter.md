 AD User Audit Exporter

## Purpose

Retrieves selected AD user attributes for audit or review.  
Designed for flexible use—user can modify `Select-Object` to target specific fields.

## Usage

- Run with elevated privileges
- Queries AD users from specified OU
- Displays results in Out-GridView for review and filtering
- Exports selected entries to CSV with date-stamped filename

## Parameters

| Parameter     | Description                                  |
|---------------|----------------------------------------------|
| `SearchBase`  | OU path to scope the AD query                |
| `Select-Object` | Modify to include desired AD attributes     |

> ⚠️ OU path and output directory are redacted in public repo. Replace with enclave-specific values before internal deployment.

## Output

- Interactive grid view for user selection
- CSV export to designated folder

## Notes

- Requires elevation to access full user attributes
- Designed for audit prep, not persistent logging
- Easily adapted for different roles, departments, or attributes

## Author

Built by [HumintToShell](https://github.com/HumintToShell)  
Legacy-minded scripting for operational clarity and teachable handoff.
