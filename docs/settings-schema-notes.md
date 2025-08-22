# Settings Schema Notes

- Single `settings.schema.json` governs the entire configuration.
- Unknown/extra properties fail validation.
- Required properties reflect the union of selected roles.
- Enumerations/regex validation enforce format (e.g., CIDR for subnets).
- Defaults may be specified in `settings.example.json` but are **not** required to satisfy the schema for optional fields.
