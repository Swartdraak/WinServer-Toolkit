# SECURITY

## Baseline
- DISA STIG — Windows Server 2019: **Version 3, Release 5** (as listed in DISA SCAP page).  
- DISA STIG — Windows Server 2022: **Version 2, Release 5** (as listed in DISA SCAP page).

These versions are pinned for the initial docs. If updated, amend this file and CHANGELOG.

## Enforcement Mode
- Default: **Enforce**. Switches exist for discovery/dry-run, but docs and tests assume enforcement by default.

## Logging
- Structured JSON-lines + transcript; include `stig_rule_id` when applicable; never log secret values.

## Secrets
- Use SecretManagement + CredMan; configurations store only **secret references** `secret://<Org>/<Service>/<Purpose>`.

## Offline
- Offline by default. If `-AllowDownloads` is not set, search `C:\Stage` then prompt for missing items individually.
