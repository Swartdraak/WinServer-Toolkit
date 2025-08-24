## Summary
- **Increment**: Inc<NN> — <Topic>
- **Branch**: feature/inc<NN>-<topic>
- **Scope**: <what this PR implements>

## Artifacts changed/added
- [ ] `config/settings.schema.json`
- [ ] `config/settings.example.json`
- [ ] `archetypes/catalog.json`
- [ ] `scripts/entrypoints/Setup-Template.ps1`
- [ ] `lib/Common.psm1`
- [ ] `tests/...`
- [ ] other: …

## Quality gates
- [ ] **PSScriptAnalyzer** = 0 errors (attach/paste summary)
- [ ] **Pester** = all tests pass (attach/paste summary)
- [ ] **Offline-by-default** validated (`C:\Stage`; no downloads unless `-AllowDownloads`)
- [ ] **STIG-first** behavior reflected and documented
- [ ] **Idempotent** & **-WhatIf** parity for entry scripts

## Wiki updates (links-only)
- [ ] RFCX rows: <links>
- [ ] CP rows: <links>
- [ ] AID rows: <links>

## Labels (auto via labeler)
- area/* applied by path
- type/* applied by path

## Risks / Rollback
- Risks:
- Rollback plan:

## Reviewers
- @Swartdraak

## Notes
- Runner preference: **windows-2019**; if unavailable, switch to **windows-2022**.