# WORKFLOWS

## Template → Build Path
- Interactive wizard composes `settings.json` from `catalog.json` + answers (+ example fallbacks on blanks).
- Strict validation (schema) before any action.
- Templating phase: checkpoint → apply baseline prep + STIG enforcement → structured logs.
- Build phases for roles arrive in later increments (DC/DNS → WSUS → FS → SQL → MECM).

## Offline-First
- No downloads unless `-AllowDownloads`.
- When offline, search `C:\Stage` first; then prompt for individual file paths if not found.
