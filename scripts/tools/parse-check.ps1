$path = 'scripts\entrypoints\Setup-Template.ps1'
$tokens = [ref]$null
$errors = [ref]@()
[System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$errors)
if ($errors.Value.Count -eq 0) {
    Write-Host "PARSE_OK"
    exit 0
} else {
    foreach ($e in $errors.Value) {
        Write-Host "PARSE_ERROR: $($e.Message) at $($e.Extent.StartLineNumber):$($e.Extent.StartColumn)"
    }
    exit 2
}
