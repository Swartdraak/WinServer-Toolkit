# Test harness for lib/Common.psm1 helpers
# Resolve and import the module file so exported functions are available
$modPath = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) '..\..\lib\Common.psm1' | Resolve-Path | Select-Object -ExpandProperty Path
Import-Module -Name $modPath -Force

Write-Host "Imported Common module from: $modPath"

$errors = @()

# 1) Test JSON syntax on catalog.json
$catalog = 'archetypes\catalog.json'
$syntax = Test-JsonSyntax -Path $catalog
if ($syntax.Ok) { Write-Host "PASS: $catalog syntax OK" } else { Write-Host "FAIL: $catalog syntax -> $($syntax.Message)"; $errors += $syntax.Message }

# 2) Test settings/schema
$settings = 'config\settings.example.json'
$schema = 'config\settings.schema.json'
$ok = Test-SettingsAgainstSchema -SettingsPath $settings -SchemaPath $schema
if ($ok) { Write-Host "PASS: settings/schema structural checks OK" } else { Write-Host "FAIL: settings/schema structural checks failed"; $errors += 'settings/schema' }

# 3) Get catalog roles and find a known role
$roles = Get-CatalogRoles
if ($roles.Count -gt 0) { Write-Host "PASS: catalog contains $($roles.Count) roles" } else { Write-Host "FAIL: no roles found in catalog"; $errors += 'no-roles' }

$role = Find-RoleById -Id 'role-ad-ds'
if ($role) { Write-Host "PASS: Found role-ad-ds" } else { Write-Host "WARN: role-ad-ds not found" }

# 4) Resolve secret URI
try {
    $res = Resolve-SecretUri -Uri 'secret://Contoso/sql/sa'
    Write-Host "PASS: Resolve-SecretUri -> $($res.Org)/$($res.Service)/$($res.Purpose)"
} catch {
    Write-Host "FAIL: Resolve-SecretUri threw: $_"; $errors += 'resolve-secret'
}

# 5) Write-AtomicJson roundtrip test
$tmpTarget = "temp-test-catalog.json"
$orig = Get-Content -Path $catalog -Raw
try {
    $ok = Write-AtomicJson -TargetPath $tmpTarget -Content $orig
    if ($ok) { Write-Host "PASS: Write-AtomicJson wrote $tmpTarget" } else { Write-Host "FAIL: Write-AtomicJson returned false"; $errors += 'atomic-write' }
} catch {
    Write-Host "FAIL: Write-AtomicJson exception: $_"; $errors += 'atomic-write-ex' }

if ($errors.Count -eq 0) { Write-Host "ALL TESTS PASSED" } else { Write-Host "SOME TESTS FAILED: $($errors -join ', ')" }

# Cleanup
if (Test-Path $tmpTarget) { Remove-Item $tmpTarget -Force }

exit ([int]($errors.Count -gt 0))
