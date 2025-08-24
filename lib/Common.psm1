<#
Module: lib/Common.psm1
Purpose: Shared helper utilities used by scripts and entrypoints. Keep helpers small, testable, and free of side effects where possible.
#>

function Write-LogJson {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [hashtable] $Entry
    )
    $json = $Entry | ConvertTo-Json -Depth 10
    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    # Ensure each entry is a single-line JSON record (append newline)
    Add-Content -Path $Path -Value ($json + "`n") -Force
}

function Test-JsonSyntax {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Path
    )
    if (-not (Test-Path $Path)) { return @{ Ok = $false; Message = "File not found: $Path" } }
    try {
        $raw = Get-Content -Path $Path -Raw -ErrorAction Stop
        $null = $raw | ConvertFrom-Json -ErrorAction Stop
        return @{ Ok = $true; Message = 'OK' }
    } catch {
        return @{ Ok = $false; Message = $_.Exception.Message }
    }
}

function Test-SettingsAgainstSchema {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $SettingsPath,
        [Parameter(Mandatory)] [string] $SchemaPath
    )
    # Lightweight, deterministic checks that mirror the strict rules described in STRUCTURE.md
    if (-not (Test-Path $SettingsPath)) { Write-Error "Settings file not found: $SettingsPath"; return $false }
    if (-not (Test-Path $SchemaPath)) { Write-Error "Schema file not found: $SchemaPath"; return $false }
    $syntax = Test-JsonSyntax -Path $SettingsPath
    if (-not $syntax.Ok) { Write-Error "Invalid JSON: $($syntax.Message)"; return $false }
    try {
        $s = Get-Content -Path $SettingsPath -Raw | ConvertFrom-Json
    } catch {
        Write-Error "Failed to parse settings as JSON: $_"; return $false
    }

    # Top-level required keys
    $requiredTop = @('global','roles')
    foreach ($k in $requiredTop) {
        if (-not $s.PSObject.Properties.Name.Contains($k)) { Write-Error "Missing top-level key: $k"; return $false }
    }

    # Validate 'global' required properties (Org, Environment, ArtifactStageRoot)
    $global = $s.global
    foreach ($gk in @('Org','Environment','ArtifactStageRoot')) {
        if (-not $global.PSObject.Properties.Name.Contains($gk)) { Write-Error "Missing global.$gk"; return $false }
    }

    # Validate roles array shape
    if (-not ($s.roles -is [System.Array])) { Write-Error 'roles must be an array'; return $false }
    foreach ($r in $s.roles) {
        if (-not ($r.PSObject.Properties.Name -contains 'id')) { Write-Error 'Every role must have "id"'; return $false }
        if (-not ($r.PSObject.Properties.Name -contains 'parameters')) { Write-Error 'Every role must have "parameters"'; return $false }
        if (-not ($r.parameters -is [System.Management.Automation.PSCustomObject] -or $r.parameters -is [hashtable])) { Write-Error 'role.parameters must be an object'; return $false }

        # Ensure secret property naming convention: keys ending in Secret must start with secret://
        foreach ($pName in $r.parameters.PSObject.Properties.Name) {
            if ($pName -match 'Secret$') {
                $val = $r.parameters.$pName
                if (-not ($val -is [string] -and $val -match '^secret:\/\/')) { Write-Error "Parameter $($r.id).$pName must be a secret:// reference"; return $false }
            }
        }
    }

    return $true
}

function Get-CatalogRoles {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)] [string] $CatalogPath = (Join-Path (Get-Location) 'archetypes\catalog.json')
    )
    if (-not (Test-Path $CatalogPath)) { throw "Catalog not found: $CatalogPath" }
    $raw = Get-Content -Path $CatalogPath -Raw
    $obj = $raw | ConvertFrom-Json
    return $obj.roles
}

function Find-RoleById {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Id,
        [string] $CatalogPath = (Join-Path (Get-Location) 'archetypes\catalog.json')
    )
    $roles = Get-CatalogRoles -CatalogPath $CatalogPath
    return $roles | Where-Object { $_.id -eq $Id }
}

function Resolve-SecretUri {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $Uri
    )
    if (-not ($Uri -match '^secret:\/\/')) { throw 'Not a secret:// URI' }
    # simple split into components: secret://Org/Service/Purpose (remaining path allowed)
    $trim = $Uri -replace '^secret:\/\/',''
    $parts = $trim -split '/'
    return [PSCustomObject]@{
        Org = $parts[0]
        Service = if ($parts.Count -gt 1) { $parts[1] } else { '' }
        Purpose = if ($parts.Count -gt 2) { ($parts[2..($parts.Count-1)] -join '/') } else { '' }
        Raw = $Uri
    }
}

function Write-AtomicJson {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $TargetPath,
        [Parameter(Mandatory)] [string] $Content
    )
    $dir = Split-Path $TargetPath -Parent
    # If $TargetPath is just a filename (no directory), Split-Path returns empty string.
    if ([string]::IsNullOrWhiteSpace($dir)) { $dir = $null } 
    if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $tmp = [System.IO.Path]::GetTempFileName()
    try {
        $Content | Out-File -FilePath $tmp -Encoding UTF8
        $syntax = Test-JsonSyntax -Path $tmp
        if (-not $syntax.Ok) { throw "Content failed JSON syntax check: $($syntax.Message)" }
        Move-Item -Path $tmp -Destination $TargetPath -Force
        return $true
    } catch {
        if (Test-Path $tmp) { Remove-Item $tmp -Force }
        throw
    }
}

function New-Checkpoint {
    param(
        [string]$CheckpointDir = 'C:\\ProgramData\\WinServerToolkit\\checkpoints',
        [string]$Name = (Get-Date -Format 'yyyyMMdd-HHmmss')
    )
    if (-not (Test-Path $CheckpointDir)) { New-Item -ItemType Directory -Path $CheckpointDir -Force | Out-Null }
    $path = Join-Path $CheckpointDir "checkpoint-$Name.txt"
    "Checkpoint created at $(Get-Date -Format o)" | Out-File -FilePath $path -Encoding UTF8
    return $path
}

function Find-StagedArtifact {
    param(
        [string]$ArtifactName,
        [string]$StageRoot = 'C:\\Stage'
    )
    if (-not (Test-Path $StageRoot)) { return $null }
    $found = Get-ChildItem -Path $StageRoot -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -match [regex]::Escape($ArtifactName) }
    return $found
}

if ($PSModuleInfo) {
    Export-ModuleMember -Function *
}
