# Contributing

## Branching & Commits
- Default working branch: `dev`. Feature branches → PR into `dev`.
- Conventional Commits (e.g., `feat(wizard):`, `fix(schema):`, `docs(security):`).

## PR Requirements
- Pester tests pass; PSScriptAnalyzer = 0 errors (for code-bearing PRs).
- Docs updated (USAGE / CONFIGURATION / DEFINITIONS / SECURITY / MIGRATION if impacted).
- Include `-WhatIf` logs for workflow-affecting changes (if applicable).

## Wiki front-matter and footer (status)
All non-template Wiki pages must include the standardized static footer (Status Footer) at the bottom of the page. Use the guidance and exact snippet in the Wiki at `Template-Front-Matter`.

Quick how-to (CP / AID / Wiki edits):
1. If you change schema/contracts, open a CP (copy the row from `Template — CP Row` into `CP Register`).
2. If you add or change artifacts, create/update an AID row in `Master AID Index` and include evidence links per the Evidence policy (links only to commit or PR).
3. Update the page footer: set `Status`, `Owner`, `Updated` (`YYYY-MM-DD`) and bump `Version` if semantics changed.
4. Push a regular PR to `dev` and use the PR template; CI will warn on missing footers or evidence link format issues.

### Running checks locally
Run repository tests locally before opening a PR:

Pester & PSScriptAnalyzer (PowerShell):
```powershell
pwsh -Command "Install-Module -Name Pester -Scope CurrentUser -Force"
pwsh -Command "Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force"
pwsh -File ./tests/run-all.ps1    # if present; otherwise run Invoke-Pester and Invoke-ScriptAnalyzer manually
```

Wiki lint (local):
```powershell
pwsh ./scripts/wiki-lint.ps1 -Path '..\winserver-toolkit.wiki' -Report 'reports\wiki-lint.csv'
```

## Filing Issues
- Use the templates under `.github/ISSUE_TEMPLATE/`.
- Include: version/commit, OS (2019/2022), steps, expected/actual, redacted logs.

## Security
- Do not place secrets in issues/PRs. Use secret references (`secret://Org/Service/Purpose`).
