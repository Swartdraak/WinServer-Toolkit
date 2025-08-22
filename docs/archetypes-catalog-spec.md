# Archetypes Catalog — Spec

## Purpose
Define role contracts that the wizard uses to prompt and compose `settings.json`.

## Structure (example)
- `role`: string (e.g., "dc-dns", "wsus", "fs", "sql", "mecm")
- `params`: array of objects
  - `key`: string (JSON path-friendly)
  - `type`: string (string|int|bool|enum|array|object)
  - `prompt`: string (admin-facing)
  - `validation`: regex or enum list or custom rule id
  - `required`: bool
  - `reuseId`: string — prompts sharing the same concept across roles
  - `dependsOn`: array of `key` references
  - `secret`: bool (when value should be a secret reference)

## Rules
- No environment values in the catalog; only contracts.
- Prefer `reuseId` for shared concepts (domain name, site name, content paths).
- Keep prompts succinct; validation errors must be precise.
