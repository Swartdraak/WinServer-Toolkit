# DEFINITIONS (function surface — planning skeleton)

| Name | Synopsis | Key Params | Idempotency Notes |
|------|----------|------------|-------------------|
| Setup-Template (entry) | Orchestrate baseline prep + STIG hardening | -WhatIf/-NoApply, -AllowDownloads | Detects state; creates checkpoint |
| Invoke-HostTemplate (entry) | Apply template steps to host | -SettingsPath | Skip when compliant |
| Test-Tooling | Validate prerequisites | — | Non-destructive |
| Validate-Settings | Strict JSON schema validation | -Path | Fails fast, logs |
| Prompt-ForParams | Drive prompts from catalog (`reuseId`) | — | De-duplicates |
| Get-Artifact | Offline lookup (`C:\Stage`), prompt fallback | — | No network unless allowed |
| New-Checkpoint | Create/cleanup restore point/VM checkpoint | — | Best-effort, logs |
| Write-LogEvent | Structured + transcript logging | — | Redacts secrets |
