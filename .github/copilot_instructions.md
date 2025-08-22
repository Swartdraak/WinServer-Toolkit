# Copilot Instructions — WinServer-Toolkit

## Intent
PowerShell-first toolkit to 1) harden Server (Core-friendly) into a template, then 2) build configured hosts from `config/settings.json` + selected archetypes.

Security-first: DISA STIG default (WS2019 v3r5, WS2022 v2r5). Idempotent. Privacy-safe logging. Offline by default unless `-AllowDownloads` is set.

## Landmarks
- `archetypes/catalog.json`: role catalog (parameters, prompts, validation, `reuseId`, dependencies). No env values.
- `config/settings.example.json`: example values for all settings (global + per-role). Used **only** if admin leaves prompt blank.
- `config/settings.schema.json`: strict schema; unknown keys fail.
- `scripts/entrypoints/`: thin user entry scripts.
- `lib/Common.psm1`: shared helpers.
- `docs/`: usage, configuration, workflows, security, definitions.

## Conventions
- Idempotent; -WhatIf/-NoApply; JSON-lines + transcript logging (no secrets).
- Secrets via SecretManagement + CredMan: `secret://<Org>/<Service>/<Purpose>`.
- Offline-first: search `C:\Stage` unless `-AllowDownloads` is used.
- De-dup prompts with `reuseId`; validate via schema; write `config/settings.json`.

## Tests & Docs
- Pester + PSSA; docs must be updated with any param/behavior changes.
