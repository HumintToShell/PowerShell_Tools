<#
.SYNOPSIS
  AD User Quick Info Lookup

.DESCRIPTION
  Retrieves key AD user attributes for helpdesk or sysadmin triage.
  Designed for rapid, one-off lookup during support calls.

.NOTES
  - Requires elevated privileges
  - Output is transient and console-based
  - Built for speed, clarity, and teachable handoff

.AUTHOR
  HumintToShell (https://github.com/HumintToShell)
#>

# Check for elevation
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script must be run as Administrator."
    exit
}

# Prompt for AD username
$ADUser = Read-Host: "Enter AD Username"

# Retrieve and display user info
Get-ADUser -Identity $ADUser -Properties * |
    Select-Object SamAccountName, ssn, Enabled, DisplayNamePrintable, Title, EmployeeID, LastLogonDate, PasswordLastSet, Mobile, Manager |
    Format-List
