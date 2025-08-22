# Logging Spec (structured + transcript)

## Structured log (JSON-lines)
Fields (minimum): `timestamp`, `level`, `run_id`, `component`, `action`, `target`, `result`, `details`, `duration_ms`, `stig_rule_id?`, `error_code?`

## Transcript
- PowerShell transcript in parallel; redactions applied for secret prompts/values.

## Redactions
- Never log secret values.
- For file paths under `C:\Stage`, log existence checks, not contents.
