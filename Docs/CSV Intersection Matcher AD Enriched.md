# CSV Intersection Matcher with AD Enrichment

## Purpose

Compares two CSV files based on a shared key (e.g., `emailaddress`) and identifies matching entries.  
Optionally enriches matched users with live AD data for reporting or audit purposes.

## Usage

- Run with elevated privileges
- Prompts user for shared key column name
- Imports two CSVs:
  - `Source1.csv`: First dataset (e.g., job roles, training records)
  - `Source2.csv`: Second dataset (e.g., asset issuance, access logs)
- Compares entries by shared key
- Queries AD for matched users to enrich with `Name`, `SamAccountName`, and `Title`
- Displays results in Out-GridView for review
- Exports selected entries to CSV with date-stamped filename

## Parameters

| Parameter     | Description                                  |
|---------------|----------------------------------------------|
| `key`         | Shared column name used for comparison       |
| `CSV paths`   | Must be updated internally before deployment |

## Output

- Interactive grid view for user selection
- CSV export to designated folder

## Notes

- Requires elevation to query AD
- CSVs must include the shared key column
- Designed for hybrid workflows where live data access is limited
- Easily adapted for:
  - Role-to-Asset matching
  - Training-to-Access validation
  - HR-to-AD reconciliation
  - License-to-Need audits

## Author

Built by [HumintToShell](https://github.com/HumintToShell)  
Legacy-minded scripting for operational clarity, hybrid data workflows, and teachable handoff.
