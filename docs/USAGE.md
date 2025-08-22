# USAGE

## Prereqs (conceptual)
- Windows Server 2019 or 2022 (Core supported).
- PowerShell 5.1+.
- Local admin rights.
- Optional: `-AllowDownloads` to fetch prerequisites; otherwise prepare offline artifacts under `C:\Stage\...`.

## Flow (MVP-Interactive)
1) Run the Interactive Config Wizard.
2) Select archetypes; answer prompts (de-duplicated by `reuseId`).
3) Review generated `config/settings.json`.
4) Dry-run with `-WhatIf` / `-NoApply` and check logs.
5) Apply: creates a checkpoint; enforces STIG baseline; logs structured events.
6) On success, optionally remove the checkpoint.

See **WORKFLOWS.md** for diagrams and edge-case handling.
