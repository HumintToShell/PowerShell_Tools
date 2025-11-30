# Claude Code Prompts for PowerShell_Tools

This document provides example prompts for common tasks when working with Claude Code web on the PowerShell_Tools repository.

---

## Getting Started

### First Session Setup

```
Read the following files to understand this project:
1. ScriptForge/STANDARDS.md - coding standards
2. ScriptForge/PROJECT_CONTEXT.md - repository context
3. ScriptForge/templates/base-template.ps1 - script foundation

Then let me know you're ready to help with PowerShell script development.
```

### Quick Context Refresh

```
Quickly review ScriptForge/STANDARDS.md and PROJECT_CONTEXT.md to understand 
my PowerShell scripting standards and project context. Let me know when ready.
```

---

## Generating New Scripts

### Basic Script Generation

```
Create a new PowerShell script called [SCRIPT_NAME].ps1 that [DESCRIPTION].

Requirements:
- Use base-template.ps1 as foundation
- Follow STANDARDS.md patterns
- Include logging to $env:TEMP\ScriptLogs
- Add parameter support
- Include error handling

Save to: scripts/[CATEGORY]/[SCRIPT_NAME].ps1
```

**Example:**
```
Create a new PowerShell script called Get-StaleComputers.ps1 that finds AD 
computer accounts that haven't logged in for 90+ days.

Requirements:
- Use base-template.ps1 as foundation
- Follow STANDARDS.md patterns
- Include logging to $env:TEMP\ScriptLogs
- Add parameter for days threshold (default 90)
- Include error handling
- Export results to CSV

Save to: scripts/AD/Get-StaleComputers.ps1
```

### AD User Operations Script

```
Create an AD user management script that [SPECIFIC_TASK].

Requirements:
- Start with base-template.ps1
- Include ActiveDirectory module check
- Use multi-OU search pattern from STANDARDS.md
- Accept CSV input OR interactive mode
- Log all changes to $env:TEMP\ScriptLogs
- Support -WhatIf for testing
- Include progress indicators
- Export results

Save to: scripts/AD/[SCRIPT_NAME].ps1
```

**Example:**
```
Create an AD user management script that bulk disables user accounts from a CSV file.

Requirements:
- Start with base-template.ps1
- Include ActiveDirectory module check
- Use multi-OU search pattern from STANDARDS.md
- Accept CSV input (column: SamAccountName) OR interactive mode
- Log all changes to $env:TEMP\ScriptLogs
- Support -WhatIf for testing
- Include progress indicators
- Export success/failure results to CSV

Save to: scripts/AD/Disable-BulkUsers.ps1
```

### Network/Triage Script

```
Create a network troubleshooting script that [SPECIFIC_TASK].

Requirements:
- Start with base-template.ps1
- Include connection testing with timeout
- Use site naming convention (AABB format)
- Display results in GridView
- Optional CSV export
- Include progress indicators
- Log test results

Save to: scripts/triage/[SCRIPT_NAME].ps1
```

**Example:**
```
Create a network troubleshooting script that tests port connectivity to 
multiple servers.

Requirements:
- Start with base-template.ps1
- Test ports 80, 443, 3389, 445 (parameterized)
- Accept list of servers from CSV or parameter
- Display results in GridView
- Optional CSV export
- Include timeout parameter (default 5 seconds)
- Show progress while testing
- Log all test results

Save to: scripts/triage/Test-PortConnectivity.ps1
```

### CSV Processing Script

```
Create a CSV processing script that [SPECIFIC_TASK].

Requirements:
- Start with base-template.ps1
- Validate CSV exists and has required columns
- Include error handling for file I/O
- Show progress for large files
- Export results with timestamp
- Log operations

Save to: scripts/CSV Tools/[SCRIPT_NAME].ps1
```

---

## Enhancing Existing Scripts

### General Enhancement

```
Enhance scripts/[PATH]/[SCRIPT_NAME].ps1 by:
1. Reading STANDARDS.md to understand requirements
2. Analyzing current script
3. Adding missing elements:
   - Parameter block with CmdletBinding
   - Smart logging to $env:TEMP\ScriptLogs
   - Error handling (try/catch)
   - WhatIf support if making changes
   - Progress indicators if processing multiple items
   - Structured output
4. Preserving all existing functionality
5. Updating version to [X.X] and Last Modified date
6. Creating summary of changes made

Save enhanced version as: scripts/[PATH]/[SCRIPT_NAME].ps1
```

**Example:**
```
Enhance scripts/triage/triage_ping_sweep.ps1 by:
1. Reading STANDARDS.md to understand requirements
2. Analyzing current script
3. Adding missing elements:
   - Fix the undefined $prefix bug (line 18/32)
   - Parameter block with CmdletBinding
   - Smart logging to $env:TEMP\ScriptLogs
   - Error handling (try/catch)
   - WhatIf support
   - Progress indicators
   - Structured output
   - Optional CSV export
4. Preserving all existing functionality
5. Updating version to 2.0 and Last Modified date
6. Creating summary of changes made

Save enhanced version as: scripts/triage/triage_ping_sweep.ps1
```

### Add Specific Feature

```
Add [FEATURE] to scripts/[PATH]/[SCRIPT_NAME].ps1

Requirements:
- Preserve existing functionality
- Follow STANDARDS.md patterns
- Update version number
- Document the addition in .NOTES section
```

**Example:**
```
Add CSV export functionality to scripts/AD/ADUser_Quick_Info.ps1

Requirements:
- Add -ExportPath parameter (optional)
- If provided, export results to CSV
- Use timestamped filename if directory provided
- Preserve existing GridView display
- Follow STANDARDS.md patterns
- Update version number to 1.1
- Document the addition in .NOTES section
```

### Fix Specific Bug

```
Fix the bug in scripts/[PATH]/[SCRIPT_NAME].ps1 where [BUG_DESCRIPTION].

Provide:
1. Analysis of the problem
2. Root cause
3. Proposed fix
4. Implementation
5. Updated script with fix applied
```

**Example:**
```
Fix the bug in scripts/triage/triage_ping_sweep.ps1 where $prefix is used 
on line 32 but never defined.

Provide:
1. Analysis of the problem
2. Root cause (Read-Host on line 18 not assigned)
3. Proposed fix
4. Implementation
5. Updated script with fix applied and version bumped to 1.1
```

---

## Documentation Tasks

### Generate Script Documentation

```
Generate markdown documentation for scripts/[PATH]/[SCRIPT_NAME].ps1

Include:
- Purpose and description
- Prerequisites
- Parameters with descriptions
- Usage examples (at least 3)
- Common scenarios
- Deployment notes (placeholder customization)
- Troubleshooting tips

Save to: Docs/[SCRIPT_NAME].md
```

### Update README

```
Update the main README.md to include the new script [SCRIPT_NAME].ps1

Add:
- Script description to appropriate section
- Link to documentation
- Brief usage example
- Maintain existing format and structure
```

### Create Deployment Checklist

```
Create a deployment checklist for scripts/[PATH]/[SCRIPT_NAME].ps1

Include:
- Placeholder values to replace
- Prerequisites to verify
- Testing steps
- Environment-specific customizations
- Rollback procedure

Save to: Docs/Deploy_[SCRIPT_NAME].md
```

---

## Code Review and Analysis

### Analyze Existing Script

```
Analyze scripts/[PATH]/[SCRIPT_NAME].ps1 and provide:

1. What it does (purpose and functionality)
2. Current patterns it uses well
3. Issues or missing elements per STANDARDS.md:
   - Parameter support
   - Error handling
   - Logging
   - Progress indicators
   - Documentation
4. Recommendations for improvement
5. Estimated effort to enhance (minor/moderate/major)

Don't make changes yet, just analyze.
```

### Compare Scripts for Patterns

```
Compare these scripts to identify common patterns:
- scripts/AD/[SCRIPT1].ps1
- scripts/AD/[SCRIPT2].ps1
- scripts/AD/[SCRIPT3].ps1

Identify:
1. Shared patterns (what's consistent)
2. Inconsistencies (what varies)
3. Best practices used
4. Opportunities for standardization

Suggest a specialized template based on common patterns.
```

---

## Batch Operations

### Enhance Multiple Scripts

```
Enhance all scripts in scripts/AD/ directory by:
1. Adding parameter support
2. Adding logging
3. Adding error handling
4. Following STANDARDS.md patterns
5. Updating versions and dates

Process them one at a time, asking for confirmation before each.
Start with: [SCRIPT_NAME].ps1
```

### Generate Documentation for All Scripts

```
Generate markdown documentation for all scripts in scripts/ directory.

For each script:
1. Extract information from comment-based help
2. Create documentation following template
3. Save to Docs/[SCRIPT_NAME].md
4. Update main README.md with link

Process systematically through each subdirectory.
```

---

## Troubleshooting and Debugging

### Debug Script Issue

```
Help debug an issue with scripts/[PATH]/[SCRIPT_NAME].ps1

Problem: [DESCRIPTION OF ISSUE]

Error message (if any): [ERROR]

Expected behavior: [WHAT SHOULD HAPPEN]

Actual behavior: [WHAT ACTUALLY HAPPENS]

Analyze and propose solution.
```

### Test Script Logic

```
Review the logic in scripts/[PATH]/[SCRIPT_NAME].ps1 for potential issues:

Focus on:
1. Error handling (what could go wrong?)
2. Edge cases (empty input, missing files, no results)
3. Performance (any bottlenecks?)
4. Security (any credentials or sensitive data?)

Provide recommendations for hardening.
```

---

## Template Development

### Create Specialized Template

```
Create a specialized template based on:
- scripts/[PATH]/[EXAMPLE_SCRIPT1].ps1
- scripts/[PATH]/[EXAMPLE_SCRIPT2].ps1

Template should include:
- All patterns from base-template.ps1
- Common patterns from these example scripts
- Appropriate placeholders
- Clear documentation of what to customize

Save to: ScriptForge/templates/[TEMPLATE_NAME].ps1
```

**Example:**
```
Create a specialized template for AD user operations based on:
- scripts/AD/ADUser_Quick_Info.ps1
- scripts/AD/ADUser_audit_exporter.ps1

Template should include:
- All patterns from base-template.ps1
- AD module check and import
- Multi-OU search pattern
- Common AD user properties
- Parameter block for user input
- Export to CSV pattern
- GridView display option

Save to: ScriptForge/templates/ad-user-ops.ps1
```

---

## Git and Version Control

### Prepare Commit

```
Review the changes I've made and suggest:
1. Appropriate commit message
2. Any additional changes needed before commit
3. Version number updates if not done
4. Documentation updates needed
```

### Create Feature Branch

```
I want to work on [FEATURE] without affecting main branch.

Create a plan for:
1. Branch name (following conventions)
2. Changes to make
3. Testing approach
4. Merge strategy
```

---

## Project Organization

### Reorganize Scripts

```
Help reorganize the scripts/ directory:

Current state: [DESCRIPTION]
Desired state: [DESCRIPTION]

Provide:
1. Recommended directory structure
2. Migration plan (what moves where)
3. Update paths in documentation
4. Git commands to execute
```

**Example:**
```
Help reorganize the scripts/ directory:

Current state: Have both /AD/ and /ad/ directories
Desired state: Single /AD/ directory with consistent naming

Provide:
1. Recommended directory structure
2. Migration plan (what moves where)
3. Update paths in documentation  
4. Git commands to execute
```

### Consolidate Similar Scripts

```
Review these scripts and determine if they should be consolidated:
- scripts/[PATH]/[SCRIPT1].ps1
- scripts/[PATH]/[SCRIPT2].ps1

If yes, provide:
1. Rationale for consolidation
2. Proposed unified script
3. Migration plan for users
4. Deprecation strategy for old scripts
```

---

## Advanced Tasks

### Create Script Pipeline

```
Create a workflow that chains these scripts:
1. [SCRIPT1] - [PURPOSE]
2. [SCRIPT2] - [PURPOSE]
3. [SCRIPT3] - [PURPOSE]

Provide:
1. Orchestration script that runs all three
2. Data passing between scripts
3. Error handling for pipeline
4. Logging of entire workflow
```

### Build Wrapper Script

```
Create a wrapper script that:
- Presents menu of available scripts
- Collects required parameters
- Executes selected script
- Logs all operations
- Provides summary of results

Include all scripts from scripts/[CATEGORY]/
```

---

## Learning and Exploration

### Explain Pattern

```
Explain this pattern from scripts/[PATH]/[SCRIPT_NAME].ps1:

[CODE_SNIPPET]

Include:
1. What it does
2. Why this approach
3. When to use this pattern
4. Any alternatives
```

### Compare Approaches

```
Compare these two approaches for [TASK]:

Approach 1: [DESCRIPTION/CODE]
Approach 2: [DESCRIPTION/CODE]

Analyze:
1. Pros and cons of each
2. Performance implications
3. Maintainability
4. Recommendation for this project
```

---

## Quick Reference

### Common Quick Prompts

**Generate new script:**
```
Create [SCRIPT_NAME] that [DOES_X], following STANDARDS.md, save to scripts/[CATEGORY]/
```

**Enhance script:**
```
Enhance scripts/[PATH]/[SCRIPT] following STANDARDS.md, preserve functionality
```

**Fix bug:**
```
Fix bug in scripts/[PATH]/[SCRIPT] where [ISSUE]
```

**Add feature:**
```
Add [FEATURE] to scripts/[PATH]/[SCRIPT], follow STANDARDS.md
```

**Create docs:**
```
Generate docs for scripts/[PATH]/[SCRIPT], save to Docs/
```

**Analyze script:**
```
Analyze scripts/[PATH]/[SCRIPT] per STANDARDS.md, don't change, just report
```

---

## Best Practices for Prompting

### Be Specific
❌ "Make this better"  
✅ "Add parameter support and error handling to this script following STANDARDS.md"

### Provide Context
❌ "Create a script"  
✅ "Create an AD user script that disables accounts from CSV, following base-template.ps1"

### Reference Standards
❌ "Add logging"  
✅ "Add logging following the smart logging pattern in STANDARDS.md"

### Specify Output
❌ "Fix this"  
✅ "Fix this and save the updated version to scripts/AD/ScriptName.ps1"

### Ask for Explanation
❌ Just accept code  
✅ "Explain why you chose this approach over alternatives"

---

## Session Management

### Start of Session

```
I'm starting work on [PROJECT/TASK]. Please review:
- STANDARDS.md
- PROJECT_CONTEXT.md
- Any relevant existing scripts

Then confirm you're ready to assist.
```

### Mid-Session Context

```
We've been working on [TASK]. Here's what we've done so far:
[SUMMARY]

Next I need: [NEXT_TASK]
```

### End of Session

```
We've completed [TASKS]. Please:
1. Summarize changes made
2. Suggest commit message
3. Identify any follow-up tasks
4. Note any context for next session
```

---

## Teleport Preparation

### Before Teleporting to CLI

```
I'm going to teleport this session to CLI to test locally.

Prepare:
1. Summary of what we've built
2. Testing steps
3. Any PowerShell-specific commands to run
4. Expected outcomes
```

### After Teleporting from CLI

```
I teleported from CLI after testing. Results:
[TEST_RESULTS]

Continue with: [NEXT_STEPS]
```

---

**End of Prompts Guide**

Use these prompts as templates, customizing for your specific needs. The key is being clear about requirements and referencing STANDARDS.md for consistency.
