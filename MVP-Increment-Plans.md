# MVP Increments — Objectives & Acceptance

## Inc 1 — Foundations + Security
**Objectives**: Interactive wizard, catalog complete, strict schema, settings.example, STIG enforcement default, checkpoints, offline behavior, structured logging, `-WhatIf`/`-NoApply` parity.  
**Acceptance**:
- Catalog lists all parameters for DC/DNS, WSUS, FS, SQL, MECM (role contracts only; no env values).
- Wizard de-duplicates prompts via `reuseId`; writes valid `config/settings.json`.
- Schema rejects unknown keys; logs clear validation errors.
- STIG enforcement tasks execute with dry-run support and produce logs with `stig_rule_id` fields.
- Offline-first behavior: honors `C:\Stage` search and prompts for missing items.
- Checkpoint created before changes; cleanup optional on success.
- PSScriptAnalyzer = 0 errors (for code phase); Pester tests for schema + wizard flows.

## Inc 2 — Hardening & Offline
**Objectives**: Expand STIG mapping tables; finalize logging fields/PII policy; enhance offline artifact UX.  
**Acceptance**:
- Mapping table links task → STIG rule IDs with log coverage.
- Logs include: timestamp, action, result, target, `stig_rule_id`, duration, redaction policy documented.
- Offline artifact prompts include per-role manifests.

## Inc 3 — DC/DNS (thin vertical)
**Objectives**: Baseline AD DS + DNS config (minimal).  
**Acceptance**: Build script honors schema, idempotency, logging, and offline constraints; dry-run parity.

## Inc 4 — WSUS (thin vertical)
## Inc 5 — File Services (baseline)
## Inc 6 — SQL Server (baseline)
## Inc 7 — MECM (baseline)
## Inc 8 — MVP Polish & Docs Freeze
