# PowerShell Scripting Standards for Claude Code

This document defines the coding standards and patterns for all PowerShell scripts in this repository. When generating or enhancing scripts, Claude should follow these guidelines strictly.

---

## Core Principles

1. **Operational Focus** - Scripts must work in real-world enterprise environments
2. **Teachable Design** - Junior admins should understand the code
3. **Portable** - Must work across different enclaves with minimal customization
4. **Maintainable** - Code should outlive the original author
5. **Professional Quality** - Portfolio-ready standards

---

## Template Foundation

**CRITICAL: All scripts must start with base-template.ps1 as foundation**

Location: `ScriptForge/templates/base-template.ps1`

This template includes:
- Comment-based help structure
- CmdletBinding with parameter support
- Smart logging system
- Error handling (try/catch/finally)
- WhatIf support
- BEGIN/PROCESS/END blocks
- Progress indicators
- Structured output

---

## Required Elements in Every Script

### 1. Comment-Based Help

**MUST include at minimum:**

```powershell
<#
.SYNOPSIS
  [One-line description of what the script does]

.DESCRIPTION
  [Detailed description including purpose, behavior, and any important context]
  
.PARAMETER [ParameterName]
  [Description of what this parameter does]

.EXAMPLE
  .\ScriptName.ps1 -Parameter "Value"
  [Description of what this example demonstrates]

.NOTES
  - Requires: [List requirements like elevation, modules, etc.]
  - Author: HumintToShell (https://github.com/HumintToShell)
  - Last Modified: [YYYY-MM-DD]
  - Version: [X.X]

.LINK
  https://github.com/HumintToShell/PowerShell_Tools
#>
```

**Best Practices:**
- Synopsis should be clear and specific
- Description should explain the "why" not just the "what"
- Include multiple examples showing different use cases
- Document prerequisites clearly

---

### 2. CmdletBinding and Parameters

**ALWAYS use CmdletBinding:**

```powershell
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$true, 
               ValueFromPipeline=$true,
               HelpMessage="[Clear description of what this parameter does]")]
    [ValidateNotNullOrEmpty()]
    [string]$ParameterName,
    
    # Optional parameters
    [Parameter(Mandatory=$false)]
    [string]$LogPath,
    
    [Parameter(Mandatory=$false)]
    [switch]$NoLogging
)
```

**Parameter Guidelines:**
- Use descriptive names (PascalCase)
- Include HelpMessage for all mandatory parameters
- Use appropriate validation attributes:
  - `ValidateNotNullOrEmpty()` for required strings
  - `ValidatePattern()` for formatted inputs (e.g., computer names)
  - `ValidateRange()` for numeric bounds
  - `ValidateSet()` for fixed options
  - `ValidateScript()` for complex validation
- Always include LogPath and NoLogging as optional parameters
- Use `SupportsShouldProcess=$true` for any script that makes changes

---

### 3. Smart Logging System

**Default Logging Pattern:**

```powershell
#region Logging Configuration

if (-not $NoLogging) {
    if ([string]::IsNullOrEmpty($LogPath)) {
        # Auto-detect: Use current user's temp directory
        $LogPath = Join-Path $env:TEMP "ScriptLogs"
        
        # Create if doesn't exist
        if (-not (Test-Path $LogPath)) {
            New-Item -ItemType Directory -Path $LogPath -Force | Out-Null
        }
        
        # Create log file with script name and timestamp
        $LogFile = Join-Path $LogPath "$($MyInvocation.MyCommand.Name)_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
    } else {
        $LogFile = $LogPath
    }
    
    Write-Verbose "Logging to: $LogFile"
} else {
    Write-Verbose "Logging disabled"
    $LogFile = $null
}

function Write-Log {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('INFO','WARNING','ERROR','SUCCESS')]
        [string]$Level = 'INFO'
    )
    
    if ($LogFile) {
        $Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        $LogEntry = "[$Timestamp] [$Level] $Message"
        Add-Content -Path $LogFile -Value $LogEntry
    }
    
    switch ($Level) {
        'INFO'    { Write-Verbose $Message }
        'WARNING' { Write-Warning $Message }
        'ERROR'   { Write-Error $Message }
        'SUCCESS' { Write-Host $Message -ForegroundColor Green }
    }
}

Write-Log "Script started by $env:USERNAME on $env:COMPUTERNAME" -Level INFO

#endregion
```

**Logging Rules:**
- Default to `$env:TEMP\ScriptLogs` (works for all users)
- Include timestamp in log filename
- Use Write-Log function for all logging
- Log levels: INFO, WARNING, ERROR, SUCCESS
- Always log script start/end
- Log important operations and their outcomes
- Include username and computer name in logs

---

### 4. Error Handling

**Required try/catch pattern:**

```powershell
try {
    # Main logic here
    Write-Log "Performing operation on $Item" -Level INFO
    
    # Actual operation
    
    Write-Log "Successfully processed $Item" -Level SUCCESS
    
} catch {
    Write-Log "Failed to process ${Item}: $_" -Level ERROR
    
    # Decide whether to continue or stop
    # For non-critical errors, continue
    # For critical errors: throw
    
} finally {
    # Cleanup code that runs regardless of success/failure
    Write-Progress -Activity "Processing" -Completed
}
```

**Error Handling Guidelines:**
- Wrap risky operations in try/catch
- Log all errors with context
- Decide per-operation whether to continue or stop
- Use finally block for cleanup
- Provide helpful error messages
- Don't silently fail

---

### 5. Multi-OU Search Pattern

**Standard pattern for Active Directory environments:**

```powershell
# Environment-Specific Configuration
# These OUs contain all computers/users for this office
# Scoped search improves performance in large AD domains
$SearchBases = @(
    "<YOUR_WORKSTATIONS_OU>",  # e.g., "OU=Office42_Workstations,OU=Region,DC=domain,DC=com"
    "<YOUR_SERVERS_OU>"         # e.g., "OU=Office42_Servers,OU=Region,DC=domain,DC=com"
)

# Aggregate results from all search locations
$Results = @()
foreach ($SearchBase in $SearchBases) {
    try {
        $Results += Get-ADComputer -Filter $Filter `
                                   -SearchBase $SearchBase `
                                   -ErrorAction Stop
        Write-Log "Found $($Results.Count) items in $SearchBase" -Level INFO
    } catch {
        Write-Log "Error searching $SearchBase : $_" -Level WARNING
        # Continue to next OU
    }
}

if ($Results.Count -eq 0) {
    Write-Log "No items found matching criteria in configured OUs" -Level WARNING
    return
}
```

**Why This Pattern:**
- Your AD has 56+ offices, searching entire domain is slow
- Scoping to specific OUs dramatically improves performance
- Handles errors per-OU (if one fails, continue with others)
- Clear placeholder makes customization obvious
- Comments explain the "why" for future maintainers

---

### 6. Placeholder System

**Standard placeholders for environment-specific values:**

```powershell
# Domain and OU paths
$DomainName = "<YOUR_DOMAIN>"                    # e.g., "contoso.com"
$OUPath = "<OU_PATH>"                           # e.g., "OU=Users,DC=contoso,DC=com"
$SearchBases = @(
    "<YOUR_WORKSTATIONS_OU>",                   # Workstations OU path
    "<YOUR_SERVERS_OU>"                         # Servers OU path
)

# File paths
$InputPath = "<INPUT_FILE_PATH>"                # e.g., "C:\Scripts\Input\data.csv"
$OutputPath = "<OUTPUT_FILE_PATH>"              # e.g., "C:\Scripts\Output\results.csv"

# Server names
$ServerName = "<SERVER_NAME>"                   # e.g., "DC01.contoso.com"
$FileServer = "<FILE_SERVER>"                   # e.g., "FS01.contoso.com"
```

**Placeholder Rules:**
- Use ALL_CAPS with angle brackets: `<PLACEHOLDER_NAME>`
- Include example in comment: `# e.g., "actual.value"`
- Make them obvious and searchable (Ctrl+F for `<`)
- Script should fail gracefully if placeholders aren't replaced
- Group related placeholders together

---

### 7. Progress Indicators

**For operations processing multiple items:**

```powershell
$TotalItems = $Items.Count
$CurrentItem = 0

foreach ($Item in $Items) {
    $CurrentItem++
    $PercentComplete = [math]::Round(($CurrentItem / $TotalItems) * 100)
    
    Write-Progress -Activity "Processing Items" `
                   -Status "Processing $Item ($CurrentItem of $TotalItems)" `
                   -PercentComplete $PercentComplete
    
    # Work here
}

Write-Progress -Activity "Processing Items" -Completed
```

**Progress Guidelines:**
- Show progress for operations with 5+ items
- Include current/total count
- Update percent complete
- Always complete the progress bar when done
- Keep status messages concise

---

### 8. Interactive vs. Scriptable

**Support both interactive and automated use:**

```powershell
param(
    [Parameter(Mandatory=$false)]
    [string]$UserInput
)

# If parameter not provided, prompt interactively
if ([string]::IsNullOrEmpty($UserInput)) {
    Write-Host "`nPlease provide input" -ForegroundColor Cyan
    Write-Host "Example: AB for entire AOR, ABCD for specific site`n" -ForegroundColor Gray
    
    do {
        $UserInput = Read-Host "Input"
        if ([string]::IsNullOrEmpty($UserInput)) {
            Write-Warning "Input is required. Please try again."
        }
    } while ([string]::IsNullOrEmpty($UserInput))
}

# Now use $UserInput (works whether provided or prompted)
```

**Guidelines:**
- All parameters should be optional with interactive fallback
- Provide helpful prompts with examples
- Validate input whether from parameter or prompt
- Scripts should work in scheduled tasks (all params provided)
- Scripts should work when double-clicked (prompts for missing)

---

### 9. Output Patterns

**Structured output for automation:**

```powershell
# Return objects, not strings
$Result = [PSCustomObject]@{
    ComputerName    = $Computer
    Status          = "Success"
    ResponseTime    = $Ping.ResponseTime
    Timestamp       = Get-Date
    ProcessedBy     = $env:USERNAME
}

return $Result
```

**For collections:**
```powershell
$Results = @()

foreach ($Item in $Items) {
    $Results += [PSCustomObject]@{
        Item   = $Item
        Status = "Processed"
        # ... other properties
    }
}

# Multiple output options
$Results | Out-GridView -Title "Results" -Wait              # Interactive review
$Results | Export-Csv -Path $OutputPath -NoTypeInformation  # Export
return $Results                                              # Pipeline
```

---

### 10. BEGIN/PROCESS/END Structure

**Use proper pipeline support:**

```powershell
BEGIN {
    # One-time setup
    # Initialize variables
    # Check prerequisites
    # Setup logging
}

PROCESS {
    # Main logic
    # Runs once per pipeline item
    # Or once if not receiving pipeline input
}

END {
    # Cleanup
    # Summary reporting
    # Close connections
    # Return final results
}
```

---

## Specialized Patterns

### Active Directory Scripts

**Requirements:**
```powershell
# Check for AD module
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Log "ActiveDirectory module not found" -Level ERROR
    throw "This script requires the ActiveDirectory PowerShell module"
}

Import-Module ActiveDirectory -ErrorAction Stop
Write-Log "Loaded ActiveDirectory module" -Level INFO
```

**Common AD patterns:**
- Always use `-ErrorAction` on AD cmdlets
- Include multi-OU search pattern
- Handle objects not found gracefully
- Use `-Properties` to get specific attributes (not `*`)

### CSV Processing Scripts

**CSV validation:**
```powershell
# Validate CSV exists
if (-not (Test-Path $CsvPath)) {
    Write-Log "CSV file not found: $CsvPath" -Level ERROR
    throw "CSV file does not exist"
}

# Import and validate
try {
    $Data = Import-Csv -Path $CsvPath -ErrorAction Stop
} catch {
    Write-Log "Failed to import CSV: $_" -Level ERROR
    throw
}

# Validate required columns
$RequiredColumns = @('Name', 'Email', 'Department')
$MissingColumns = $RequiredColumns | Where-Object { $_ -notin $Data[0].PSObject.Properties.Name }

if ($MissingColumns) {
    Write-Log "CSV missing required columns: $($MissingColumns -join ', ')" -Level ERROR
    throw "Invalid CSV format"
}
```

### Network Scripts

**Connection testing pattern:**
```powershell
try {
    $Ping = Test-Connection -ComputerName $Computer `
                           -Count 1 `
                           -TimeoutSeconds $Timeout `
                           -ErrorAction Stop
    
    $IsReachable = $true
    $ResponseTime = $Ping.ResponseTime
    
} catch {
    $IsReachable = $false
    $ResponseTime = $null
    Write-Log "$Computer is not reachable" -Level WARNING
}
```

---

## Code Style

### Naming Conventions

- **Scripts**: `Verb-NounDescription.ps1` (e.g., `Get-ADUserInfo.ps1`)
- **Functions**: PascalCase (e.g., `Write-Log`, `Test-Connection`)
- **Variables**: camelCase or PascalCase (e.g., `$computerName`, `$SearchBases`)
- **Parameters**: PascalCase (e.g., `-ComputerName`, `-SearchBase`)

### Formatting

- **Indentation**: 4 spaces (no tabs)
- **Line length**: Max 120 characters (prefer 100)
- **Braces**: Opening brace on same line
- **Operators**: Spaces around operators (`$a -eq $b`, not `$a-eq$b`)
- **Comments**: Space after # (`# Comment`, not `#Comment`)

### Comments

- Comment the **why**, not the **what**
- Use regions to organize code sections
- Include examples in complex sections
- Explain business logic and decisions
- Document workarounds and gotchas

**Good comments:**
```powershell
# Scoped to these OUs for performance - full domain search times out
# Using timeout of 2 seconds to balance accuracy with speed during incident response
# AD replication delay means we check both DCs
```

**Bad comments:**
```powershell
# Set variable to value
# Loop through items
# Call function
```

---

## Version Control

### Script Metadata

**Update these on each change:**
```powershell
.NOTES
  - Version: 2.1
  - Last Modified: 2024-11-30
```

### Commit Messages

**Format:**
```
[Action] Brief description

Detailed explanation of what changed and why.
Include any breaking changes or required updates.
```

**Examples:**
```
Add bulk user provisioning script

New script for onboarding users from CSV. Includes validation,
password generation, and OU placement based on department.

Enhance ping sweep with parameters and error handling

- Fixed undefined $prefix bug
- Added parameter block for automation support
- Implemented logging and error handling
- Added CSV export option
```

---

## Testing Requirements

Before considering a script complete:

- [ ] Test with `-WhatIf` flag
- [ ] Test with `-Verbose` flag
- [ ] Test with invalid input
- [ ] Test with missing prerequisites
- [ ] Test in target environment
- [ ] Verify logging works
- [ ] Verify error handling catches errors
- [ ] Check help is complete: `Get-Help .\Script.ps1 -Full`

---

## Deployment Checklist

Before deploying to new enclave:

- [ ] Replace all `<PLACEHOLDER>` values
- [ ] Update OU paths for environment
- [ ] Update domain names
- [ ] Update server names
- [ ] Update file paths
- [ ] Test with `-WhatIf` in new environment
- [ ] Verify logging destination is accessible
- [ ] Document environment-specific customizations

---

## Common Pitfalls to Avoid

1. **Silent failures** - Always log errors
2. **Hardcoded paths** - Use placeholders
3. **No validation** - Validate all inputs
4. **Missing help** - Include complete help block
5. **No error handling** - Wrap risky operations in try/catch
6. **Scope creep** - Keep scripts focused on one job
7. **Over-engineering** - Simple and readable beats clever
8. **No testing** - Always test with -WhatIf first

---

## Priority Order When Generating Scripts

1. **Start with base-template.ps1**
2. **Add script-specific parameters**
3. **Implement core logic in PROCESS block**
4. **Add appropriate error handling**
5. **Include logging at key points**
6. **Add progress indicators if processing multiple items**
7. **Test thoroughly**
8. **Document with examples**

---

## When Enhancing Existing Scripts

1. **Preserve working functionality** - Don't break what works
2. **Add, don't replace** - Enhance rather than rewrite
3. **Maintain compatibility** - Existing usage should still work
4. **Document changes** - Update version and notes
5. **Test before committing** - Verify enhancements work

---

## Quality Indicators

A good script:
- ✅ Works when double-clicked (prompts for missing input)
- ✅ Works when scheduled (all parameters can be provided)
- ✅ Logs important operations automatically
- ✅ Handles errors gracefully
- ✅ Shows progress for long operations
- ✅ Returns structured data
- ✅ Junior admin can understand it
- ✅ Works across different enclaves with minimal changes
- ✅ Includes complete help documentation
- ✅ Supports -WhatIf for testing

---

**End of Standards Document**

When Claude Code generates or enhances scripts, it should reference this document to ensure compliance with all standards.
