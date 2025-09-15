<#
.SYNOPSIS
  Command Post Status Checker

.DESCRIPTION
  Designed for regular users to verify online status of all command post machines.
  Filters AD computers by naming convention and description, then pings each.
  Results are displayed in an interactive grid view for easy review and copy/paste.

.NOTES
  - No elevation required
  - OU path must be updated per enclave
  - Description field is used as a best-effort filter (not guaranteed reliable)
  - Built for routine checks by non-admin personnel
#>

# Get all AD computers matching naming and description pattern
$computernames = Get-ADComputer -Filter * -SearchBase "OU=CommandPost,DC=yourdomain,DC=com" -Properties * |
    Where-Object {
        $_.Name -like "DEHQ*" -and $_.Description -like "*post*"
    } |
    Select-Object Name, Description

# Initialize array for ping results
$PingResults = @()

# Ping each computer and store results
foreach ($computer in $computernames) {
    $computer = $computer.Name
    Write-Host "Pinging $computer..."
    $pingresult = Test-Connection -ComputerName $computer -Count 1 -Quiet
    $PingResults += New-Object PSObject -Property @{
        ComputerName = $computer
        Status       = if ($pingresult) { "Reachable" } else { "Not Reachable" }
    }
}

# Display results in interactive grid view
$PingResults | Out-GridView -Title "Ping Results" -Wait
               
