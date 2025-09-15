# Command Post Status Checker

## Purpose

Verifies online status of all command post machines using AD queries and ping tests.  
Designed for regular users to perform routine checks without elevated privileges.

## Usage

- Filters AD computers by naming convention and description
- Pings each machine once using `Test-Connection`
- Displays results in Out-GridView for easy review

## Parameters

| Parameter     | Description                                  |
|---------------|----------------------------------------------|
| `SearchBase`  | OU path to scope the AD query                |
| `Name`        | Filters for machines starting with `DEHQ*`   |
| `Description` | Filters for machines with `*post*` in description |

> ⚠️ OU path is redacted in public repo. Replace with enclave-specific value before internal deployment.

## Output

- Interactive grid view showing each machine and its ping status

## Notes

- No elevation required
- Description filtering is best-effort and may vary by site
- Designed for quick, repeatable checks by non-admin personnel

## Author

Built by [HumintToShell](https://github.com/HumintToShell)  
Operationally scoped for clarity, speed, and teachable handoff.
