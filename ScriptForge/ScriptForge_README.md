# ScriptForge

**Personal PowerShell script development and enhancement toolkit**

ScriptForge helps you write better scripts faster by providing templates with best practices built-in, tools to enhance existing scripts, and automated documentation generation. Built for operational clarity, portability across air-gapped environments, and professional portfolio development.

## Purpose

- **Write faster**: Generate new scripts from templates instead of starting from scratch
- **Write better**: All templates include error handling, logging, parameters, and best practices
- **Maintain easier**: Consistent structure across all scripts makes maintenance simpler
- **Deploy anywhere**: Clear placeholders make customization for different enclaves straightforward
- **Portfolio ready**: Professional-quality code and auto-generated documentation

## Philosophy

- **Modular**: Each script stands alone or integrates into larger workflows
- **Teachable**: Heavy commenting and clear structure for junior admins and future maintainers
- **Portable**: Works in air-gapped environments with minimal dependencies
- **Operational**: Built for real-world use, not theoretical perfection
- **Legacy-Grade**: Good ops should outlive the operator

## Project Structure

```
PowerShell_Tools/
├── README.md                          # Main repo overview
├── scripts/                           # Your operational scripts
│   ├── AD/
│   ├── CSV Tools/
│   └── triage/
├── Docs/                             # Script-specific documentation
├── ScriptForge/                      # Script development toolkit
│   ├── README.md                     # This file
│   │
│   ├── templates/                    # Script templates
│   │   ├── base-template.ps1        # Foundation for all scripts
│   │   ├── ad-user-ops.ps1          # AD user management template
│   │   ├── ad-computer-ops.ps1      # AD computer management template
│   │   ├── csv-processor.ps1        # CSV file processing template
│   │   └── network-triage.ps1       # Network connectivity testing template
│   │
│   ├── tools/                        # PowerShell development tools
│   │   ├── New-Script.ps1           # Generate new scripts from templates
│   │   ├── Enhance-Script.ps1       # Improve existing scripts
│   │   └── Build-Documentation.ps1  # Generate portfolio documentation
│   │
│   ├── config/                       # Configuration files
│   │   └── standards.json           # Coding standards and rules
│   │
│   └── examples/                     # Example outputs
│       ├── generated/               # Sample generated scripts
│       └── enhanced/                # Before/after enhancement examples
│
├── logs/
└── templates/
```

## Quick Start

### Generate a New Script

```powershell
# Interactive mode (recommended for first use)
.\ScriptForge\tools\New-Script.ps1

# Command-line mode (faster when you know what you want)
.\ScriptForge\tools\New-Script.ps1 -TemplateName "ad-user-ops" -ScriptName "BulkDisableUsers" -RequiresElevation
```

### Enhance an Existing Script

```powershell
# Analyze and enhance a script
.\ScriptForge\tools\Enhance-Script.ps1 -Path ".\scripts\AD\MyScript.ps1" -WhatIf

# Apply enhancements
.\ScriptForge\tools\Enhance-Script.ps1 -Path ".\scripts\AD\MyScript.ps1"
```

### Generate Documentation

```powershell
# Generate portfolio documentation from all scripts
.\ScriptForge\tools\Build-Documentation.ps1 -ScriptDirectory ".\scripts" -OutputPath ".\docs"
```

## Templates

### base-template.ps1
**Universal foundation for any PowerShell script**

Includes:
- Complete comment-based help
- CmdletBinding with parameter support
- Smart logging (auto-detects $env:TEMP\ScriptLogs)
- Error handling (try/catch/finally)
- WhatIf support
- Verbose output
- Progress indicators
- Structured output objects
- BEGIN/PROCESS/END blocks

Use for: Any script that doesn't fit specialized templates

### ad-user-ops.ps1
**Active Directory user management operations**

Inherits base template plus:
- AD module check and import
- Multi-OU search pattern
- Standard AD user properties
- Bulk operation support
- Audit logging

Use for: User provisioning, deprovisioning, bulk updates, audits

### ad-computer-ops.ps1
**Active Directory computer management operations**

Inherits base template plus:
- AD module check and import
- Multi-OU search pattern
- Computer naming convention support
- Site-based filtering
- Reachability testing

Use for: Computer management, inventory, site-based operations

### csv-processor.ps1
**CSV file processing and manipulation**

Inherits base template plus:
- CSV import with validation
- Column existence checking
- Data transformation patterns
- Export with timestamping
- Progress tracking for large files

Use for: Bulk operations, data imports/exports, reporting

### network-triage.ps1
**Network connectivity and troubleshooting**

Inherits base template plus:
- Ping sweeps
- Port testing
- Timeout handling
- Reachability reporting
- Grid view results

Use for: Troubleshooting, connectivity validation, infrastructure checks

## Features in Every Template

### Smart Logging
```powershell
# Automatically logs to $env:TEMP\ScriptLogs\ScriptName_TIMESTAMP.log
# Works for any user on any machine
# No setup required

# Custom location
.\MyScript.ps1 -LogPath "C:\CustomLogs\audit.log"

# Disable logging
.\MyScript.ps1 -NoLogging
```

### Clear Placeholders
```powershell
$Domain = "<YOUR_DOMAIN>"           # e.g., "contoso.com"
$OUPath = "<OU_PATH>"              # e.g., "OU=Users,DC=contoso,DC=com"
$SearchBases = @(
    "<OU_PATH_1>",                 # Update for your environment
    "<OU_PATH_2>"
)
```

### Multi-OU Search Pattern
```powershell
# Standard pattern for environments with distributed AD structure
# Searches multiple OUs for performance in large domains
$Results = @()
foreach ($SearchBase in $SearchBases) {
    $Results += Get-ADComputer -Filter $Filter -SearchBase $SearchBase -ErrorAction SilentlyContinue
}
```

### Interactive + Scriptable
```powershell
# Interactive use (prompts for missing parameters)
.\MyScript.ps1

# Automation use (no prompts)
.\MyScript.ps1 -Parameter "Value" -AnotherParameter "Value"

# Mixed (provides some, prompts for rest)
.\MyScript.ps1 -Parameter "Value"
```

## Deployment Workflow

### For New Enclave/Office

1. **Clone or copy** ScriptForge to new environment
2. **Customize placeholders** in generated scripts:
   - Domain names
   - OU paths
   - File paths
   - Server names
3. **Test** with `-WhatIf` and `-Verbose`
4. **Deploy** to production use

### Example Customization

```powershell
# Template placeholder
$SearchBases = @(
    "<YOUR_WORKSTATIONS_OU>",
    "<YOUR_SERVERS_OU>"
)

# Customized for Office 42
$SearchBases = @(
    "OU=Office42_Workstations,OU=EastRegion,DC=enterprise,DC=com",
    "OU=Office42_Servers,OU=EastRegion,DC=enterprise,DC=com"
)
```

## Best Practices

### When Writing New Scripts

1. **Start with a template** - Don't write from scratch
2. **Use parameters** - Make scripts flexible and automatable
3. **Include help** - Comment-based help for every script
4. **Handle errors** - Try/catch around risky operations
5. **Log appropriately** - Important operations should be logged
6. **Test with WhatIf** - Verify before executing destructive changes
7. **Keep it simple** - Junior admins should be able to understand it

### When Deploying to New Environment

1. **Search for placeholders** - Look for `<ALL_CAPS_TAGS>`
2. **Test in dev first** - Don't deploy untested to production
3. **Document customizations** - Note what was changed for that enclave
4. **Verify permissions** - Ensure service accounts have necessary rights

### When Maintaining Scripts

1. **Update version number** - Track changes in .NOTES section
2. **Update Last Modified date** - Keep documentation current
3. **Test after changes** - Regression testing with -WhatIf
4. **Commit to version control** - Git commit with meaningful message

## Coding Standards

### PowerShell Best Practices

- Use CmdletBinding on all functions/scripts
- Include comment-based help
- Use approved verbs (Get-, Set-, New-, Remove-, etc.)
- Parameter validation where appropriate
- Error handling with try/catch
- Write-Verbose for progress information
- SupportsShouldProcess for destructive operations

### Naming Conventions

- **Scripts**: `Verb-NounDescription.ps1` (e.g., `Get-ADUserInfo.ps1`)
- **Functions**: PascalCase (e.g., `Write-Log`, `Test-Connection`)
- **Variables**: camelCase or PascalCase (e.g., `$computerName`, `$SearchBases`)
- **Parameters**: PascalCase (e.g., `-ComputerName`, `-SearchBase`)

### Structure

- Always use BEGIN/PROCESS/END blocks for scripts that accept pipeline input
- Group related code in regions for readability
- Comment the "why" not the "what"
- Keep functions focused (one job per function)

## Troubleshooting

### "Template not found"

Ensure you're running from the correct directory:
```powershell
cd ScriptForge
.\tools\New-Script.ps1
```

### "ActiveDirectory module not found"

Install RSAT tools:
```powershell
# Windows 10/11
Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0

# Windows Server
Install-WindowsFeature RSAT-AD-PowerShell
```

### "Access denied" when creating logs

Default logging to `$env:TEMP\ScriptLogs` should always work. If not:
```powershell
# Check permissions
Test-Path $env:TEMP -PathType Container

# Use custom location
.\MyScript.ps1 -LogPath "C:\Temp\my.log"

# Disable logging
.\MyScript.ps1 -NoLogging
```

## Version History

### v1.0 (2024-11-30)
- Initial release
- Base template with comprehensive best practices
- New-Script.ps1 generator tool
- Enhanced ping sweep example
- Multi-OU search pattern
- Smart logging to user temp directory

## Future Enhancements

- [ ] Enhance-Script.ps1 tool (automatic script improvement)
- [ ] Build-Documentation.ps1 tool (portfolio generation)
- [ ] Bash script templates
- [ ] Python script templates
- [ ] Pester test templates
- [ ] CI/CD integration templates

## Contributing

This is a personal toolkit, but contributions are welcome if they:
- Maintain simplicity and operational focus
- Include clear documentation
- Follow existing coding standards
- Solve real-world problems

## License

This project is for personal and professional use. Modify and adapt as needed for your environment.

## Author

**HumintToShell**
- GitHub: https://github.com/HumintToShell
- Repo: https://github.com/HumintToShell/PowerShell_Tools

---

*Built with operational clarity and teachable design in mind. Good ops should outlive the operator.*
