# PowerShell_Tools Project Context

This document provides comprehensive context about this repository to help Claude Code understand the project structure, purpose, and how to effectively assist with script development.

---

## Project Overview

**Repository**: PowerShell_Tools  
**Owner**: HumintToShell  
**Purpose**: Operational PowerShell automation scripts for Windows system administration with a focus on Active Directory, user lifecycle management, and network triage

**Primary Use Case**: Federal IT environment with 56+ offices, large distributed Active Directory, air-gapped enclaves requiring portable scripts

---

## Repository Structure

```
PowerShell_Tools/
├── README.md                          # Main repository overview
├── .gitignore                         # Git ignore patterns
│
├── scripts/                           # Operational scripts (production use)
│   ├── AD/                           # Active Directory operations
│   │   ├── ADComputer_Description_Exporter.ps1
│   │   ├── ADComputer_Description_Updater.ps1
│   │   ├── ADUser_Quick_Info.ps1
│   │   └── LAPS_pull.ps1
│   ├── CSV Tools/                    # CSV processing utilities
│   │   └── CSV Intersection Matcher AD Enriched.ps1
│   ├── ad/                           # Additional AD scripts (lowercase naming - to be consolidated)
│   │   └── ADUser_audit_exporter.ps1
│   └── triage/                       # Network and troubleshooting tools
│       ├── Cmd_Post_Status.ps1
│       └── triage_ping_sweep.ps1
│
├── Docs/                             # Script-specific documentation
│   ├── ADComputer_Description_Updater.md
│   ├── ADUser_quick_info.md
│   ├── Aduser_audit_exporter.md
│   ├── CMD_Post.md
│   ├── CSV Intersection Matcher AD Enriched.md
│   ├── LAPS_Export.md
│   └── triage_ping_sweep.md
│
├── ScriptForge/                      # Script development toolkit (NEW)
│   ├── README.md                     # ScriptForge documentation
│   ├── STANDARDS.md                  # Coding standards (CRITICAL - read this!)
│   ├── PROJECT_CONTEXT.md            # This file
│   ├── PROMPTS.md                    # Example prompts for Claude Code
│   │
│   ├── templates/                    # Script templates
│   │   ├── base-template.ps1        # Universal foundation
│   │   ├── ad-user-ops.ps1          # AD user operations (future)
│   │   ├── ad-computer-ops.ps1      # AD computer operations (future)
│   │   ├── csv-processor.ps1        # CSV processing (future)
│   │   └── network-triage.ps1       # Network tools (future)
│   │
│   └── examples/                     # Example outputs
│       ├── generated/               # Scripts created with assistance
│       └── enhanced/                # Before/after enhancement examples
│
├── logs/                             # Placeholder for log outputs
└── templates/                        # Placeholder for CSV templates
```

---

## User Profile

### Background
- **Current Role**: GS-12 IT Specialist, Federal IT
- **Experience**: 23+ years operations (Army CI, HUMINT, contractor work)
- **IT Tenure**: ~2.5 years in systems administration
- **Career Goal**: Position as "AI guy" in IT contexts, potential post-retirement OSINT consulting

### Technical Context
- **Primary Language**: PowerShell (actively learning, 10-15 courses completed)
- **Environment**: Windows-heavy, Active Directory, enterprise network
- **Work Setup**: VS Code as admin, hybrid role (sysadmin + customer service)
- **Future Learning**: Bash and Python (minimal exposure currently)

### Operational Constraints
- Works in **air-gapped enclaves** - scripts must be portable
- Scripts used by **other admins** with varying skill levels
- **56+ offices** in organization - scripts need environment customization
- **Separate admin accounts** - logging must work for any user
- Scripts deployed via **USB/manual copy** in some environments

---

## Current Script Inventory

### Active Directory Scripts

**ADUser_Quick_Info.ps1**
- Purpose: Rapid user lookup during helpdesk calls
- Issues: Minimal error handling, no parameters, hardcoded properties
- Usage: Interactive only

**ADUser_audit_exporter.ps1**
- Purpose: Export user data for audits
- Issues: Basic structure, could use enhancement
- Note: In lowercase /ad/ directory (should be consolidated with /AD/)

**ADComputer_Description_Exporter.ps1**
- Purpose: Export computer descriptions from AD
- Usage: Pairs with updater script

**ADComputer_Description_Updater.ps1**
- Purpose: Bulk update computer descriptions from CSV
- Pattern: Multi-OU search (good example of established pattern)

**LAPS_pull.ps1**
- Purpose: Retrieve LAPS passwords
- Sensitivity: High - admin password retrieval

### CSV Processing Scripts

**CSV Intersection Matcher AD Enriched.ps1**
- Purpose: Compare two CSVs and enrich matches with AD data
- Pattern: Good example of CSV validation and AD integration
- Issues: Hardcoded paths, could use parameter support

### Network/Triage Scripts

**triage_ping_sweep.ps1**
- Purpose: Ping multiple computers by site prefix
- **CRITICAL BUG**: Line 18 reads input but doesn't assign to `$prefix`, then line 32 tries to use undefined `$prefix`
- Naming Convention: Sites use 4-letter codes (AABB format)
  - First 2 letters (AA) = Area of Responsibility (AOR)
  - Last 2 letters (BB) = Specific site
  - User can search "AB" for all sites in AOR, or "ABCD" for specific site
- Pattern: Multi-OU search, interactive use only
- Enhancement Needed: Parameters, error handling, logging

**Cmd_Post_Status.ps1**
- Purpose: Command post status checking
- Context: Operational monitoring tool

---

## Established Patterns (From Existing Scripts)

### Multi-OU Search Pattern
**Why**: Large AD environment (56+ offices), searching entire domain times out  
**How**: Scripts search 2 specific OUs containing office's computers

```powershell
$searchBases = @(
    "OU=SiteA,DC=yourdomain,DC=com",
    "OU=SiteB,DC=yourdomain,DC=com"
)

foreach ($base in $searchBases) {
    $results += Get-ADComputer -Filter "Name -like '$prefix*'" -SearchBase $base
}
```

### Interactive Prompts
**Why**: Scripts often run by double-clicking, not command-line  
**How**: Use Read-Host for missing information

```powershell
$input = Read-Host "Prompt for user"
```

### GridView for Results
**Why**: Interactive review and filtering  
**How**: Display results in sortable/filterable grid

```powershell
$results | Out-GridView -Title "Results" -Wait
```

### Hardcoded Paths (Current State - Needs Improvement)
**Issue**: Most scripts have hardcoded "C:\REDACTED\" paths  
**Better**: Use parameters with placeholders `<FILE_PATH>`

---

## ScriptForge Purpose

**Goal**: Standardize script development to ensure:
1. All scripts follow best practices (logging, error handling, parameters)
2. Scripts are portable (clear placeholders for environment customization)
3. Scripts are maintainable (junior admins can understand and modify)
4. Development is faster (generate from templates, not from scratch)
5. Quality is consistent (all scripts meet professional standards)

**How It Works**:
User interacts with Claude Code web conversationally:
- "Generate a new script that does X"
- "Enhance my existing script by adding Y"
- "Fix the bug in script Z"

Claude Code references:
- **STANDARDS.md** (how to write code)
- **templates/** (starting points)
- **PROJECT_CONTEXT.md** (understanding the environment)
- **PROMPTS.md** (example prompts)

---

## Critical Files for Claude Code

When starting a new session, Claude should read:

1. **STANDARDS.md** (FIRST - defines coding rules)
2. **PROJECT_CONTEXT.md** (this file - provides context)
3. **templates/base-template.ps1** (foundation for all scripts)
4. **PROMPTS.md** (example interactions)

---

## Environment-Specific Details

### Active Directory Structure
- **Large Enterprise AD**: 56+ offices, hundreds of OUs
- **Distributed**: Computers spread across multiple OUs
- **Performance Critical**: Scoped searches required (full domain times out)
- **Standard OUs per office**: Typically 2 OUs (Workstations, Servers)

### Naming Conventions
- **Sites**: 4-letter codes (AABB)
  - AA = Area of Responsibility
  - BB = Specific site within AOR
- **Computers**: `AABB-HOSTNAME` format
  - Examples: `ABCD-WS001`, `ABEF-DC01`, `ABGH-PRINT01`

### User Expectations
- **Junior admins**: Scripts must be readable and self-documenting
- **Air-gapped use**: Scripts can't depend on internet resources
- **Minimal setup**: Scripts should work with minimal configuration
- **Clear customization**: Obvious what needs to change per enclave

---

## Development Workflow

### Current State (Before ScriptForge)
1. User writes script from scratch
2. Copies patterns from existing scripts
3. Tests manually
4. Deploys via copy/paste
5. Documentation is manual

### Target State (With Claude Code)
1. User describes need to Claude Code
2. Claude generates script following STANDARDS.md
3. Claude uses base-template.ps1 as foundation
4. Script includes all best practices automatically
5. User customizes placeholders for environment
6. Script is ready for deployment

---

## Common Tasks Claude Will Help With

### Script Generation
- "Create a new script that [does X]"
- Starts with base-template.ps1
- Follows STANDARDS.md patterns
- Includes appropriate placeholders
- Ready for customization

### Script Enhancement
- "Enhance [script] by adding [feature]"
- Preserves existing functionality
- Adds requested improvements
- Updates version/notes
- Maintains compatibility

### Bug Fixes
- "Fix the bug in [script] where [issue]"
- Identifies problem
- Implements fix
- Tests solution
- Documents change

### Documentation
- "Generate documentation for [script]"
- Extracts comment-based help
- Creates markdown documentation
- Includes usage examples
- Updates README if needed

---

## Quality Standards

Scripts must meet these criteria:

**Functionality:**
- ✅ Works when double-clicked (interactive mode)
- ✅ Works when scheduled (parameter mode)
- ✅ Handles errors gracefully
- ✅ Logs important operations
- ✅ Shows progress for long operations

**Code Quality:**
- ✅ Follows STANDARDS.md patterns
- ✅ Includes complete help documentation
- ✅ Uses clear variable names
- ✅ Comments explain "why" not "what"
- ✅ Structured output (objects, not strings)

**Portability:**
- ✅ Clear placeholders for environment values
- ✅ Works across different enclaves
- ✅ No hardcoded credentials
- ✅ No internet dependencies
- ✅ Junior admin can understand it

**Professional:**
- ✅ Portfolio-ready quality
- ✅ Consistent with other scripts
- ✅ Proper version control
- ✅ Complete documentation
- ✅ Tested before deployment

---

## Git Workflow

### Commits
- Meaningful commit messages
- Group related changes
- Reference issues if applicable
- Include "why" in description

### Branches
- `main` - stable, tested code
- Feature branches for major changes
- Test before merging to main

### Documentation
- Update version numbers
- Update Last Modified dates
- Update README for new scripts
- Keep Docs/ folder current

---

## Success Metrics

**Script Development Time:**
- Before: 2+ hours to write a new script
- Target: 15-30 minutes with Claude Code assistance

**Script Quality:**
- Before: Inconsistent patterns, minimal error handling
- Target: All scripts follow STANDARDS.md, professional quality

**Maintenance:**
- Before: Only author can confidently modify
- Target: Any admin can understand and maintain

**Deployment:**
- Before: Manual find/replace, easy to miss customizations
- Target: Clear placeholders, deployment checklist

---

## Known Issues to Address

1. **Case inconsistency**: `/AD/` vs `/ad/` directories
2. **Hardcoded paths**: Most scripts have `C:\REDACTED\` paths
3. **Missing parameters**: Many scripts are interactive-only
4. **Limited error handling**: Most scripts lack try/catch
5. **No logging**: Most scripts don't log operations
6. **triage_ping_sweep bug**: `$prefix` undefined on line 32

---

## Future Enhancements

**Short Term:**
- Enhance all 8 existing scripts with STANDARDS.md patterns
- Fix triage_ping_sweep.ps1 bug
- Consolidate /ad/ and /AD/ directories
- Add parameters to interactive-only scripts

**Medium Term:**
- Create specialized templates (AD user ops, CSV processing, etc.)
- Build documentation generation capability
- Create deployment checklists
- Add Bash script templates

**Long Term:**
- Python script templates
- Testing framework (Pester)
- CI/CD integration
- Shared template library for team

---

## How Claude Code Should Assist

### When Generating New Scripts:
1. Read STANDARDS.md for patterns
2. Start with base-template.ps1
3. Customize for specific use case
4. Include all required elements
5. Use appropriate placeholders
6. Test generated script structure

### When Enhancing Existing Scripts:
1. Read the existing script first
2. Identify what needs improvement
3. Preserve working functionality
4. Add enhancements incrementally
5. Update version and notes
6. Document changes

### When Fixing Bugs:
1. Understand the problem
2. Identify root cause
3. Implement minimal fix
4. Test solution logic
5. Document what was fixed

### Communication Style:
- **Be direct** - No excessive explanations
- **Show code** - Provide actual implementations
- **Explain decisions** - Why this approach over alternatives
- **Ask clarifying questions** - Don't assume intent
- **Provide options** - When multiple approaches are valid

---

## Important Context for Claude

**User's Learning Style:**
- Learns by doing
- Values practical over theoretical
- Trusts intuition ("nudges")
- Systematic and methodical
- Operational mindset (mission-focused)

**User's Goals:**
- Build professional portfolio
- Become "AI guy" in IT context
- Prepare for post-retirement consulting
- Multiply operational impact
- Leave legacy of maintainable tools

**User's Constraints:**
- Limited time (work + homelab + family)
- Learning curve on new technologies
- Federal IT bureaucracy
- Air-gapped deployment requirements
- Must support less technical team members

---

## Session Context Preservation

For each Claude Code session:

1. **Start by reading**: STANDARDS.md, PROJECT_CONTEXT.md, PROMPTS.md
2. **Understand current state**: Review recent commits, open files
3. **Clarify intent**: Ask what user wants to accomplish
4. **Execute**: Generate, enhance, or fix as requested
5. **Document**: Update version, notes, commit message
6. **Verify**: Ensure script meets quality standards

---

## Teleport Feature Context

User may teleport sessions between Claude Code web and CLI:
- **Web → CLI**: To test scripts locally on Windows
- **CLI → Web**: To continue development in browser
- Context should transfer seamlessly
- Files are synced via Git

---

**End of Project Context**

This document should help Claude Code understand the full context of the PowerShell_Tools repository and provide effective assistance with script development, enhancement, and maintenance.
