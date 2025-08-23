# WinServer-Toolkit — Repository Structure (Skeleton)

This skeleton shows the canonical layout. Empty directories include a `.gitkeep` so chats and CI can see expected paths.

```
archetypes/                 # catalog.json (role contracts; top-level: "roles": []; NO "$schema")
config/                     # settings.schema.json (strict), settings.example.json (fallbacks), settings.json (wizard output)
data/
  baselines/
    stig/                   # docs + mapping tables only; never commit binaries
  inventories/
    samples/                # sample inventories for tests/demos
docs/                       # USAGE, CONFIGURATION, WORKFLOWS, SECURITY, DEFINITIONS, API, MIGRATION
lib/                        # Common.psm1 (shared helpers)
scripts/
  entrypoints/              # user-facing entry scripts (e.g., Setup-Template.ps1)
  tools/                    # utility scripts (non-entry)
  roles/                    # future role-specific scripts (role-* subfolders)
tests/
  Unit/                     # unit tests (Pester)
  Integration/              # integration tests
  Data/                     # test data (settings.valid.json, settings.invalid.json)
.github/
  workflows/                # ci.pester.yml, ci.pssa.yml
```

## Schema & Catalog Locks (Inc1)
- **Catalog** `archetypes/catalog.json`
  - Top-level key: `roles` (array).
  - Each role: `id`, `name`, `parameters[]` with `{ key, type, prompt, required, validation, reuseId, dependsOn, secret? }`.
  - **No environment values. No "$schema".** This file is a contract, not a JSON schema.
- **Schema** `config/settings.schema.json` (strict)
  - Top-level keys: `global`, `roles`.
  - `global` = `{ Org, Environment (Lab|Dev|Test|Prod), ArtifactStageRoot (path), AllowDownloads (bool), Proxy{Http,Https} }`.
  - `roles` = array of objects `{ id, parameters{...} }` (NOT strings).
  - `additionalProperties: false` at **every** object level.
- **Examples** `config/settings.example.json`
  - Mirrors the schema; used only when an admin leaves a prompt blank.
  - No secret values; use `secret://<Org>/<Service>/<Purpose>` references.

## Entrypoints & Behavior
- Entrypoints live under `scripts/entrypoints/` and are **interactive** for MVP.
- Use PowerShell `-WhatIf` via `SupportsShouldProcess`; default posture is enforce (hardening).
- Offline-first: search `C:\Stage` unless `-AllowDownloads` is provided.
- Secrets: SecretManagement + CredMan; never log secret values.
