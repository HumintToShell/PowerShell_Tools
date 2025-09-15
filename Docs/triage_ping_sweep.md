# Network Ping Sweep Tool

## Purpose

Performs a prefix-based ping sweep across AD computers.  
Designed for rapid triage during outages or connectivity checks.

## Usage

- Prompts user for prefix (e.g., `DEHQ`)
- Queries AD for matching computers
- Pings each machine once
- Displays results in Out-GridView

## Parameters

| Parameter     | Description                                  |
|---------------|----------------------------------------------|
| `Prefix`      | Computer name prefix used to filter machines |
| `SearchBase`  | OU path to scope the AD query                |

> ⚠️ OU path is redacted in public repo. Replace with enclave-specific value before internal deployment.

## Output

- Interactive grid view showing each machine and its ping status

## Notes

- No elevation required
- Designed for fast, disposable triage
- Prefix logic allows reuse across enclaves

## Author

Built by [HumintToShell](https://github.com/HumintToShell)  
Legacy-minded scripting for real-world operational support.
