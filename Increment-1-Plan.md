# Increment 1 — Foundations + Security (Deep Plan)

## Scope
- Interactive wizard (no GUI) that composes `config/settings.json` using `archetypes/catalog.json` and `config/settings.example.json` (fallbacks on blanks).
- Strict `config/settings.schema.json` validation (fail fast).
- STIG enforcement default (WS2019/WS2022 pinned versions).
- Offline-first: `C:\Stage` search, then per-item prompts; `-AllowDownloads` override.
- Checkpoints before changes; optional cleanup on success.
- Structured logging with no secrets.

## Work Breakdown Structure (WBS)
1. Catalog completion (roles: DC/DNS, WSUS, FS, SQL, MECM) — keys, types, prompts, validation, `reuseId`, dependencies.
2. Example config coverage (`settings.example.json`) — global + per-role examples.
3. Schema authoring (`settings.schema.json`) — strict; unknown keys fail.
4. Wizard:
   - Prompt planning + de-dup map (`reuseId` registry).
   - Prompt engine + fallback logic.
   - Settings writer and schema validator.
5. STIG enforcement host-prep (enforcement-only skeleton; report fields finalized).
6. Offline artifact discovery + prompting.
7. Checkpoint create/cleanup.
8. Logging framework (JSON-lines + transcript; fields, levels, redactions).
9. Tests: unit (schema), integration (wizard flow, dry-run), style (PSSA).
10. Docs updates (USAGE, CONFIGURATION, SECURITY, DEFINITIONS).

## Acceptance Criteria (explicit)
- Union of selected roles → prompts de-duplicated via `reuseId`.
- Empty answers fallback to example values where present; otherwise re-prompt/abort for required fields.
- Schema rejects unknown keys; errors logged with clear hints.
- `-WhatIf` emits planned actions, STIG rule IDs, and artifact lookups without changing state.
- Checkpoint created; on success, optional cleanup.
- Logs redact secret values and include correlation IDs per run.

## Risks & Mitigations
- Over-hardening breaks role setup → **Mitigation**: start with enforcement set + exception capture; document exceptions in SECURITY.
- Offline gaps → **Mitigation**: per-role manifests + prompts; allow targeted `-AllowDownloads` for specific tools.

## Milestones
- M1: Catalog/schema/example baselined + wizard prompt map.
- M2: Wizard writes valid `settings.json`; schema passes; dry-run output reviewed.
- M3: STIG enforcement skeleton + logging fields landed; offline prompts demo.
- M4: Tests passing; docs aligned; handoff to Inc 2.
