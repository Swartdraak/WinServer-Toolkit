# Copilot Instructions — WinServer-Toolkit

## Purpose
Implement the MVP (Inc1→Inc8) in feature branches, obeying the Wiki as canonical, and gate each increment with analyzers/tests before advancing.

## Canonical Sources & Precedence
Planning → **Wiki (canonical)** → Contracts (schema+catalog) → Implementation outputs → Code & Progress Reference.  
If information is missing, append an RFCX row (strict table) in the Wiki.

## Branching & Commits
- Branch per increment: `feature/inc<NN>-<topic>`.
- Conventional Commits (`feat(inc1): …`).
- Open a PR at the end of each increment; do not self-merge.

## Canonical Paths
- `archetypes/catalog.json` — role contracts (no env values; include `reuseId`).
- `config/settings.schema.json` — strict; top-level `global` + `roles`; `additionalProperties:false`.
- `config/settings.example.json` — fallback-only (never secrets; use `secret://<Org>/<Service>/<Purpose>`).
- `scripts/entrypoints/` — all user-facing entry scripts; `SupportsShouldProcess`; honor `-WhatIf`.
- `lib/Common.psm1` — helpers (JSON IO; stage discovery; JSONL logger).
- `tests/` — Pester tests; fixtures in `tests/Data`.

## Quality & Gates
- PSScriptAnalyzer = **0 errors**; Pester = **all tests pass**.
- STIG-first (WS2019 v3r5; WS2022 v2r5). Offline-by-default: search `C:\Stage`; only download with `-AllowDownloads`.
- Idempotent behavior; -WhatIf parity for entry scripts.
- Update Wiki pages and trackers for every artifact.

## IDs & Ownership
- IDs use **America/Anchorage** local date: `YYYYMMDD-###`.
- AID rows: set `Owner_Chat` to the active implementation chat; Version_Commit = “Pending commit” until merged.
- Page ownership passes to the implementing chat when a change is approved.

## Trackers (strict tables; evidence = links-only)
- RFCX Queue — context needs
- CP Register — policy/plan changes
- Master AID Index — artifact identity/evidence
Auto-labels: configure `.github/labeler.yml`; CI workflow applies labels.

## Increment Loop
1) Read Wiki core pages.
2) RFCX if context missing; CP for plan/doc changes; await approval.
3) Implement artifacts at canonical paths (+ `.gitkeep` as needed).
4) Add/update tests and fixtures.
5) Run analyzers/tests and fix all issues.
6) Append AID rows in the Wiki (links-only).
7) Open a PR; request @Swartdraak; include gate checklist and links.

## Do / Do Not
- Do: keep edits in repo + Wiki; follow canonical paths; log RFCX/CP/AID rows.
- Do not: push to main; recreate Approved/Review artifacts without CP; log/commit secrets.