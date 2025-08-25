<#
# Setup-Template.ps1 - Increment 1 entrypoint
# Minimal, parseable interactive/non-interactive entrypoint that uses lib/Common.psm1 helpers.
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$false)][switch] $NonInteractive,
    [Parameter(Mandatory=$false)][string[]] $Roles,
    [Parameter(Mandatory=$false)][string] $OutPath = 'config\settings.json'
)

Set-StrictMode -Version Latest

function Resolve-CommonModule {
    $candidates = @(Join-Path $PSScriptRoot '..\..\lib\Common.psm1', Join-Path $PSScriptRoot '..\lib\Common.psm1', Join-Path (Get-Location) 'lib\Common.psm1')
    foreach ($c in $candidates) { if (Test-Path $c) { return (Resolve-Path $c).Path } }
    return $null
}

function Prompt-ForArchetype {
    param($catalogObj)
    $archetypes = $catalogObj.roles | Where-Object { $_.type -eq 'composite' }
    if (-not $archetypes -or $archetypes.Count -eq 0) { throw 'No archetypes available' }
    if ($NonInteractive) { return $archetypes[0] }
    Write-Host 'Available archetypes:'
    for ($i=0; $i -lt $archetypes.Count; $i++) { Write-Host "[$($i+1)] $($archetypes[$i].id) - $($archetypes[$i].name)" }
    while ($true) {
        $choice = Read-Host 'Choose archetype by number or id (or type Cancel)'
        if ($choice -match '^(?i:cancel)$') { throw 'User cancelled' }
        if ($choice -as [int] -and $choice -ge 1 -and $choice -le $archetypes.Count) { return $archetypes[$choice-1] }
        $found = $archetypes | Where-Object { $_.id -eq $choice }
        if ($found) { return $found[0] }
        Write-Host 'Invalid selection' -ForegroundColor Yellow
    }
}

function Prompt-CollectParameters {
    param($roleDef, $defaults)
    $col = @{}
    foreach ($p in $roleDef.parameters) {
        $k = $p.key
        $default = $null
        if ($defaults -and $defaults.PSObject.Properties.Name -contains $k) { $default = $defaults.$k }
        if ($NonInteractive) { $col[$k] = $default; continue }

        if ($k -match 'Secret$') {
            while ($true) {
                $v = Read-Host "$($roleDef.id): $k (enter secret:// URI)"
                if ([string]::IsNullOrWhiteSpace($v)) { $col[$k] = $default; break }
                if ($v -match '^secret:\/\/') { $col[$k] = $v; break }
                Write-Host 'Value must be a secret:// URI' -ForegroundColor Yellow
            }
            continue
        }

        if ($p.type -eq 'boolean') {
            $v = Read-Host "$($roleDef.id): $k (y/n) [default: $($default -or 'n')]"
            $col[$k] = ($v -match '^(?i:y|true|1)$')
            continue
        }

        $v = Read-Host "$($roleDef.id): $k`nDefault: $default"
        if ([string]::IsNullOrWhiteSpace($v)) { $col[$k] = $default } else { $col[$k] = $v }
    }
    return $col
}

try {
    $common = Resolve-CommonModule
    if (-not $common) { throw 'lib/Common.psm1 not found' }
    Import-Module -Name $common -Force
} catch {
    Write-Error "Unable to import Common helpers: $_"; exit 20
}

$catalogPath = Join-Path $PSScriptRoot '..\..\archetypes\catalog.json'
$examplePath = Join-Path $PSScriptRoot '..\..\config\settings.example.json'
foreach ($p in @($catalogPath, $examplePath)) { if (-not (Test-Path $p)) { Write-Error "Required file missing: $p"; exit 21 } }

$cs = Test-JsonSyntax -Path $catalogPath
if (-not $cs.Ok) { Write-Error "Catalog JSON invalid: $($cs.Message)"; exit 22 }
$ss = Test-SettingsAgainstSchema -SettingsPath $examplePath -SchemaPath (Join-Path $PSScriptRoot '..\..\config\settings.schema.json')
if (-not $ss) { Write-Error 'Example settings failed structural checks'; exit 23 }

$catalogObj = Get-Content -Raw -Path $catalogPath | ConvertFrom-Json
$example = Get-Content -Raw -Path $examplePath | ConvertFrom-Json

if ($Roles -and $Roles.Count -gt 0) { $roleIds = $Roles } else { $sel = Prompt-ForArchetype -catalogObj $catalogObj; $roleIds = if ($sel.includes) { $sel.includes } else { @($sel.id) } }

Write-Host "Roles planned: $($roleIds -join ', ')"

$outRoles = @()
foreach ($rid in $roleIds) {
    $roleDef = Find-RoleById -Id $rid -CatalogPath $catalogPath
    if (-not $roleDef) { Write-Warning "Role not found: $rid"; continue }
    $exRole = $example.roles | Where-Object { $_.id -eq $rid } | Select-Object -First 1
    $defaults = if ($exRole) { $exRole.parameters } else { $null }
    $params = Prompt-CollectParameters -roleDef $roleDef -defaults $defaults
    $outRoles += [PSCustomObject]@{ id = $rid; parameters = $params }
}

$final = [PSCustomObject]@{ global = $example.global; roles = $outRoles }

Write-Host "Preparing to write $OutPath"
if ($PSCmdlet.ShouldProcess($OutPath, 'Write templated settings')) {
    $json = $final | ConvertTo-Json -Depth 10
    try { Write-AtomicJson -TargetPath $OutPath -Content $json; Write-Host "Wrote $OutPath"; $cp = New-Checkpoint; Write-Host "Checkpoint: $cp" } catch { Write-Error "Failed to write settings: $_"; exit 30 }
} else { Write-Host 'Dry-run, no files written. Use -WhatIf to simulate.' }

Write-Host 'Setup-Template complete.'