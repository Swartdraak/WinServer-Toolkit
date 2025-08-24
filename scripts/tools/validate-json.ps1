$paths = @('archetypes/catalog.json','config/settings.example.json','config/settings.schema.json')
foreach ($p in $paths) {
    try {
        Get-Content -Raw -Path $p | ConvertFrom-Json > $null
        Write-Host "$p parsed OK"
    } catch {
        Write-Host "PARSE_ERROR: $p -> $($_.Exception.Message)"
    }
}
