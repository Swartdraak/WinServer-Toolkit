# Contributing

## Branching & Commits
- Default working branch: `dev`. Feature branches → PR into `dev`.
- Conventional Commits (e.g., `feat(wizard):`, `fix(schema):`, `docs(security):`).

## PR Requirements
- Pester tests pass; PSScriptAnalyzer = 0 errors (for code-bearing PRs).
- Docs updated (USAGE / CONFIGURATION / DEFINITIONS / SECURITY / MIGRATION if impacted).
- Include `-WhatIf` logs for workflow-affecting changes (if applicable).

## Filing Issues
- Use the templates under `.github/ISSUE_TEMPLATE/`.
- Include: version/commit, OS (2019/2022), steps, expected/actual, redacted logs.

## Security
- Do not place secrets in issues/PRs. Use secret references (`secret://Org/Service/Purpose`).
