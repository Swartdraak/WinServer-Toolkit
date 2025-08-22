# CONFIGURATION

## Files
- `archetypes/catalog.json` — role contract (params, prompts, validation, dependencies, `reuseId`). No environment values.
- `config/settings.example.json` — example values for all settings (global + per-role). Used **only** if the admin leaves a prompt blank.
- `config/settings.schema.json` — strict JSON Schema; unknown keys fail; types/required enforced.
- `config/settings.json` — output of the wizard.

## Wizard Resolution Order
1) Admin input (if provided)  
2) Fallback to `settings.example.json` (only when the admin leaves the prompt blank)  
3) If still empty and required → re-prompt or abort

## Secrets
- Use Microsoft.PowerShell.SecretManagement + Windows Credential Manager.
- Store **references only** like `secret://<Org>/<Service>/<Purpose>` in config/logs; never store secret values.

## Offline Artifacts
- Offline by default. Without `-AllowDownloads`, search `C:\Stage` for required media and tools; prompt per missing item.
