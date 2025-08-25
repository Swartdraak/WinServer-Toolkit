$path = 'scripts\entrypoints\Setup-Template.ps1'
$script = Get-Content -Raw -Path $path
$tokens = $null
$errors = $null
[System.Management.Automation.Language.Parser]::ParseInput($script, [ref]$tokens, [ref]$errors) | Out-Null
if ($errors -and $errors.Count -gt 0) {
    foreach ($e in $errors) {
        Write-Host "PARSE_ERROR: $($e.Message) at $($e.Extent.StartLineNumber):$($e.Extent.StartColumn)"
    }
    exit 2
} else {
    Write-Host 'PARSE_OK'
    exit 0
}
