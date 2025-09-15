# AD User Quick Info Lookup

## Purpose

Retrieves key AD user attributes for helpdesk or sysadmin triage.  
Designed for rapid, one-off lookup during support calls or access reviews.

## Usage

- Run with elevated privileges
- Prompts user for AD username via `Read-Host`
- Queries AD for selected attributes
- Displays results in console using `Format-List`

## Parameters

| Parameter     | Description                                  |
|---------------|----------------------------------------------|
| `ADUser`      | Username entered via CLI prompt              |

## Output

- Console output showing selected user attributes in list format

## Notes

- Requires elevation to access full user attributes
- Script is transient and read-only—no export or logging
- Uses `Read-Host` for simplicity and CLI compatibility
- Common attributes include:
  - `SamAccountName`: Login name
  - `Enabled`: Account status
  - `DisplayNamePrintable`: Full name
  - `Title`: Job role
  - `EmployeeID`: Internal identifier
  - `LastLogonDate`: Last login timestamp
  - `PasswordLastSet`: Password age
  - `Mobile`: Contact number
  - `Manager`: Supervisor (if populated)

## Author

Built by [HumintToShell](https://github.com/HumintToShell)  
Legacy-minded scripting for operational clarity, rapid triage, and teachable handoff.
