# PowerShell Scripting Standards for Claude Code

This document defines the coding standards for PowerShell scripts in this repository. These are **operational field scripts**, not enterprise software. Keep them simple, functional, and maintainable.

---

## Core Philosophy

**These are down-and-dirty, field-ready scripts.**

Scripts in this repo are written by a sysadmin who:
- Works in locked-down air-gapped federal enclaves
- Uses GitHub web GUI (no local git workflow yet)
- Automates repetitive manual work
- Shares scripts with other admins of varying skill levels
- Deploys across 56+ offices with minimal customization

**The Standard: Chris's existing scripts ARE the baseline.**

Look at:
- `scripts/triage/triage_ping_sweep.ps1`
- `scripts/AD/ADUser_Quick_Info.ps1`
- `scripts/AD/ADComputer_Description_Updater.ps1`

These show the right level of complexity and approach.

---

## The Decision Filter

**Before adding ANY feature, ask:**
1. Does it add resilience (prevent failures, catch errors)?
2. Does it improve usability (easier for sysadmins to use)?
3. Does it add efficiency (faster, less typing)?
4. Does it provide net benefit (useful information/feedback)?

**If YES to any → include it**  
**If NO to all → leave it out**

---

## What To Include

### User-Friendly Prompts
```powershell
Write-Host "`nComputer Prefix (2 chars for AOR, 4 chars for site)" -ForegroundColor Cyan
Write-Host "Example: 'AB' for entire AOR, 'ABCD' for specific site`n" -ForegroundColor Gray
$Prefix = Read-Host "Prefix"
```

**Why:** Makes it clear what to enter (usability ✓)

### Progress Feedback
```powershell
$current = 0
foreach ($computer in $computers) {
    $current++
    $percent = [math]::Round(($current / $computers.Count) * 100)
    
    Write-Host "[$percent%] Processing $computer..." -NoNewline
    # do work
    Write-Host " DONE" -ForegroundColor Green
}
```

**Why:** Shows progress, prevents "is it frozen?" questions (usability ✓)

### Color-Coded Output
```powershell
Write-Host "SUCCESS" -ForegroundColor Green
Write-Host "FAILED" -ForegroundColor Red
Write-Host "Info message" -ForegroundColor Cyan
```

**Why:** Quick visual scanning of results (efficiency ✓)

### Summary Statistics
```powershell
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Results Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Total: $total"
Write-Host "Success: $success" -ForegroundColor Green
Write-Host "Failed: $failed" -ForegroundColor Red
```

**Why:** Quick status overview (usability ✓)

### GridView for Results
```powershell
$results | Out-GridView -Title "Results" -Wait
```

**Why:** Easy to select, copy, paste into emails/tickets (usability ✓, efficiency ✓)

### Clean Variable Initialization
```powershell
$computers = @()
$results = @()
$successCount = 0
$failCount = 0
```

**Why:** Clear intent, prevents errors (resilience ✓)

### Simple Parameters
```powershell
param(
    [ValidatePattern('^[A-Za-z]{2,4}$')]
    [string]$Prefix,
    
    [string[]]$SearchBases = @("<OU1>", "<OU2>"),
    
    [ValidateRange(1,30)]
    [int]$Timeout = 2
)
```

**Why:**
- Can run without prompts for quick re-runs (efficiency ✓)
- Validation catches bad input early (resilience ✓)
- Can override defaults when needed (usability ✓)

### Simple Validation
```powershell
if ([string]::IsNullOrEmpty($input)) {
    Write-Host "Input required" -ForegroundColor Red
    exit
}
```

**Why:** Fail fast with clear message (resilience ✓, usability ✓)

---

## What NOT To Include

### ❌ Module Importing
```powershell
# DON'T DO THIS
Import-Module ActiveDirectory -ErrorAction Stop
```

**Why not:** In all enclaves, available modules are already imported. PowerShell is configured by HQ. If you're writing an AD script, AD cmdlets just work. If they don't, the environment is broken and needs fixing - the script can't fix it.

**Do this instead:** Nothing. Just use `Get-ADComputer`, `Get-ADUser`, etc. They work.

### ❌ Logging Systems
```powershell
# DON'T DO THIS
function Write-Log {
    param($Message, $Level)
    Add-Content -Path $LogFile -Value "[$Timestamp] [$Level] $Message"
}
```

**Why not:** Quick triage scripts don't need logs. Output is visible immediately. Only add logging if specifically requested or if script makes changes that need audit trail.

### ❌ Complex Error Handling
```powershell
# DON'T DO THIS
try {
    $result = Get-Something
} catch [System.UnauthorizedException] {
    Write-Log "Unauthorized" -Level ERROR
} catch [System.TimeoutException] {
    Write-Log "Timeout" -Level ERROR
} catch {
    Write-Log "Unknown error" -Level ERROR
} finally {
    Cleanup
}
```

**Why not:** Over-engineering. Simple scripts fail fast and show the error.

**Do this instead:**
```powershell
# Simple error handling only when needed
try {
    $result = Get-Something -ErrorAction Stop
} catch {
    Write-Host "Failed: $_" -ForegroundColor Red
    exit
}
```

### ❌ CmdletBinding Unless Needed
```powershell
# DON'T DO THIS (unless pipeline support is actually needed)
[CmdletBinding()]
param(...)
```

**Why not:** Adds complexity for features that aren't used in operational scripts.

### ❌ Comment-Based Help
```powershell
# DON'T ADD UNLESS REQUESTED
<#
.SYNOPSIS
  Does something
.DESCRIPTION
  Long description...
.PARAMETER Name
  Parameter description...
.EXAMPLE
  Example usage...
.NOTES
  Various notes...
#>
```

**Why not:** These scripts are self-documenting through clear prompts and variable names. Help blocks are rarely used by the target audience (sysadmins who read the code).

### ❌ BEGIN/PROCESS/END Blocks
```powershell
# DON'T DO THIS (unless actually processing pipeline input)
BEGIN { }
PROCESS { }
END { }
```

**Why not:** Operational scripts don't use pipeline. Just write linear code.

---

## Standard Script Structure

### Minimal Working Structure
```powershell
# Parameters (if useful for re-runs)
param(
    [ValidatePattern('...')]
    $RequiredParam,
    
    $OptionalParam = "default"
)

# Import modules if needed (one line, no checking)
Import-Module ActiveDirectory -ErrorAction Stop

# User prompt with example
Write-Host "`nWhat do you need?" -ForegroundColor Cyan
Write-Host "Example: AB or ABCD`n" -ForegroundColor Gray
$input = Read-Host "Input"

# Get data
$items = Get-ADComputer -Filter "Name -like '$input*'" -SearchBase "<OU>"

Write-Host "`nFound $($items.Count) items. Processing...`n" -ForegroundColor Green

# Initialize results
$results = @()
$current = 0

# Process with progress
foreach ($item in $items) {
    $current++
    $percent = [math]::Round(($current / $items.Count) * 100)
    
    Write-Host "[$percent%] Processing $item..." -NoNewline
    
    # Do the work
    $result = Do-Something -Item $item
    
    if ($result) {
        Write-Host " SUCCESS" -ForegroundColor Green
        $status = "Success"
    } else {
        Write-Host " FAILED" -ForegroundColor Red
        $status = "Failed"
    }
    
    $results += [PSCustomObject]@{
        Item = $item
        Status = $status
    }
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Complete!" -ForegroundColor Cyan
Write-Host "Success: $(($results | Where Status -eq 'Success').Count)" -ForegroundColor Green
Write-Host "Failed: $(($results | Where Status -eq 'Failed').Count)" -ForegroundColor Red

# Display for copy/paste
$results | Out-GridView -Title "Results"
```

---

## Environment-Specific Configuration

### The Only Thing That Changes: OU Paths

**Use clear placeholders:**
```powershell
$SearchBases = @(
    "<YOUR_WORKSTATIONS_OU>",  # e.g., "OU=Office42_Workstations,OU=Region,DC=domain,DC=com"
    "<YOUR_SERVERS_OU>"         # e.g., "OU=Office42_Servers,OU=Region,DC=domain,DC=com"
)
```

**Why this pattern:**
- Easy to find with Ctrl+F
- Clear what needs customization
- Comment shows example format
- Script won't work until replaced (prevents accidents)

### Multi-OU Search Pattern
```powershell
# Your AD has 56+ offices - searching entire domain times out
# Scope to specific OUs for performance
$SearchBases = @(
    "<YOUR_WORKSTATIONS_OU>",
    "<YOUR_SERVERS_OU>"
)

$results = @()
foreach ($OU in $SearchBases) {
    try {
        $results += Get-ADComputer -Filter $Filter -SearchBase $OU -ErrorAction Stop
    } catch {
        Write-Warning "Error searching $OU : $_"
        # Continue to next OU
    }
}

if ($results.Count -eq 0) {
    Write-Host "No results found in configured OUs" -ForegroundColor Yellow
    exit
}
```

---

## Site Naming Convention

**Format:** `[AA][BB]-COMPUTERNAME`
- **AA** = Area of Responsibility (AOR) - covers multiple sites
- **BB** = Specific site within that AOR

**Examples:**
- `ABCD-WS001` - Workstation at site CD in AOR AB
- `ABEF-DC01` - Domain Controller at site EF in AOR AB

**User Input:**
- 2 chars (e.g., "AB") → Matches all sites in AOR: `ABCD*`, `ABEF*`, `ABGH*`
- 4 chars (e.g., "ABCD") → Matches only specific site: `ABCD*`

**Filter:**
```powershell
Get-ADComputer -Filter "Name -like '$Prefix*'"
```

---

## Air-Gapped Environment Constraints

**Reality:**
- PowerShell 5.x (whatever HQ installed)
- Locked down - no installing/downloading modules
- Modules are there or they aren't
- All enclaves share same base modules
- If you're writing an AD script, AD module exists

**Therefore:**
- Don't check if modules exist
- Don't try to install anything
- Just import and use
- Script fails fast if module missing

---

## When Enhancing Existing Scripts

**Look at Chris's original script first. That's the baseline.**

**Enhance with:**
- Better prompts (add examples, color)
- Progress indicators (percentages, status updates)
- Color-coded output (Green/Red/Cyan)
- Summary stats at the end
- GridView for results if not already there
- Cleaner variable initialization
- Better loop logic if needed

**Don't add:**
- Logging (unless script makes changes needing audit)
- Complex error handling
- Help documentation
- Enterprise patterns
- Anything not in the original unless it checks a box (resilience/usability/efficiency/benefit)

**Example:** `triage_ping_sweep.ps1` → enhanced version is a GOOD example of the right level of improvement.

---

## When Creating New Scripts

**Ask Chris:**
1. What commands are you already running manually?
2. What's the repetitive part?
3. What output do you need?

**Then generate:**
- The automation/loop of those commands
- User-friendly prompts
- Progress feedback
- Formatted output (GridView or summary)
- Placeholders for OUs
- That's it

**Don't generate:**
- Framework/boilerplate
- Module checking
- Logging systems
- Help documentation
- Unless specifically asked

---

## Code Style

### Variable Naming
- **Use clear names:** `$computers`, `$results`, `$successCount`
- **Avoid abbreviations:** `$cnt` → `$count`
- **PascalCase or camelCase:** Either is fine, just be consistent in one script

### Formatting
- **Indentation:** 4 spaces
- **Line length:** Whatever fits, no strict limit
- **Braces:** Opening brace on same line
- **Spacing:** Space after commas, around operators

### Comments
- Comment the "why" if it's not obvious
- Don't comment obvious things
- Keep it brief

**Good:**
```powershell
# Scoped to these OUs for performance - full domain search times out
```

**Bad:**
```powershell
# Loop through each computer
foreach ($computer in $computers) {
```

---

## Testing in Locked-Down Environments

**Before deploying:**
- Test interactively first
- Run with sample data
- Verify OUs are correct
- Check output format
- Make sure it's copy/paste friendly

**No formal testing framework needed.** Just run it and see if it works.

---

## Common Patterns

### Interactive Prompt with Validation
```powershell
Write-Host "`nEnter prefix (2-4 letters):" -ForegroundColor Cyan
do {
    $prefix = Read-Host "Prefix"
    if ($prefix -notmatch '^[A-Za-z]{2,4}$') {
        Write-Host "Must be 2-4 letters. Try again." -ForegroundColor Red
    }
} while ($prefix -notmatch '^[A-Za-z]{2,4}$')
```

### Safe AD Query
```powershell
try {
    $computers = Get-ADComputer -Filter "Name -like '$prefix*'" -SearchBase $OU -ErrorAction Stop
} catch {
    Write-Host "AD query failed: $_" -ForegroundColor Red
    exit
}
```

### Progress Loop
```powershell
$current = 0
$total = $items.Count

foreach ($item in $items) {
    $current++
    $percent = [math]::Round(($current / $total) * 100)
    Write-Host "[$percent%] Processing $item..." -NoNewline
    
    # work here
    
    Write-Host " DONE" -ForegroundColor Green
}
```

### Result Collection
```powershell
$results = @()

foreach ($item in $items) {
    $results += [PSCustomObject]@{
        Name = $item
        Status = "Processed"
        Details = $details
    }
}

$results | Out-GridView -Title "Results"
```

---

## Priority: Function Over Form

**Good script:**
- ✅ Does the job
- ✅ Easy to use
- ✅ Shows progress
- ✅ Produces useful output
- ✅ Can be customized for different enclaves (OU placeholders)
- ✅ Other sysadmins can understand it

**Bad script:**
- ❌ Over-engineered
- ❌ Complex for no benefit
- ❌ Requires setup/configuration
- ❌ Tries to be "enterprise grade"
- ❌ Has features nobody uses

---

## Version Control

**Chris uses GitHub web GUI - no local git workflow yet.**

When updating scripts:
- Edit directly in GitHub web interface
- Use descriptive commit messages
- That's it - keep it simple

---

## Remember

These are **operator scripts**, not software products.

They're written by someone who:
- Is learning scripting while doing the job
- Works in locked-down environments
- Needs things to just work
- Shares scripts with other admins
- Values function over form

**Match that reality.**

---

**End of Standards Document**

When Claude Code generates or enhances scripts, reference this document and Chris's existing scripts in the repo to maintain the right style and complexity level.
