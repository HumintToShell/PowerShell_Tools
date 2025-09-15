# AD Computer Description Updater

## Purpose

Updates AD computer object descriptions based on a CSV file.  
Designed to pair with the export script (`ad_description_export.ps1`) for bulk editing workflows.

## Usage

- Run with elevated privileges
- Imports CSV containing `Name` and `Description` columns
- Searches across multiple predefined OUs
- Updates AD description field for each matching computer

## Parameters

| Parameter     | Description                                  |
|---------------|----------------------------------------------|
| `csvFile`     | Path to CSV file containing updates          |
| `SearchBase`  | OU paths defined internally (dual search)    |

> ⚠️ OU paths and CSV location are redacted in public repo. Replace with enclave-specific values before internal deployment.

## Output

- Console output confirming updates
- Optional Out-GridView pause for review

## Notes

- Requires elevation to modify AD objects
- Script is write-back capable—use with care
- Designed for modular, teachable workflows across enclaves

## Example CSV

```csv
Name,Description
DEHQ001,Command Post - Primary
DERA002,Remote Access Node
