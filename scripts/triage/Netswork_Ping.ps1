# Select which group of computers you want to ping
Read-Host "Computer Name Prefix / Location"

# Define the OU search bases. These are scoped to reduce search time.
# If only one OU is needed, it's best to filter directly in the Get-ADComputer cmdlet.
$searchBases = @(
    "OU=SiteA,DC=yourdomain,DC=com", # <-- Update with your actual OU path
    "OU=SiteB,DC=yourdomain,DC=com"  # <-- Update with your actual OU path
)

# Initialize array to collect computer names
$computernames = @()

# Query each OU for computers matching the prefix
foreach ($base in $searchBases) {
    $computernames += Get-ADComputer -Filter "Name -like '$prefix*'" -SearchBase $base |
        Select-Object -ExpandProperty Name
}

# Initialize array for ping results
$PingResults = @()

# Ping each computer and store results
foreach ($computer in $computernames) {
    Write-Host "Pinging $computer..."
    $pingresult = Test-Connection -ComputerName $computer -Count 1 -TimeoutSeconds 2
    $PingResults += New-Object PSObject -Property @{
        ComputerName = $computer
        Status       = if ($pingresult) { "Reachable" } else { "Not Reachable" }
    }
}

# Display results in interactive grid view for readability and usability
$PingResults | Out-GridView -Title "Ping Results" -Wait
