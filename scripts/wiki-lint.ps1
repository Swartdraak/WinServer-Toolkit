<#
  Simple wiki-lint: checks for footer snippet and validates evidence links (commit|pull) patterns.
  Usage: pwsh .\scripts\wiki-lint.ps1 -Path '..\winserver-toolkit.wiki' -Report 'reports\wiki-lint.csv'
#>
param(
    [string]$Path = "..\winserver-toolkit.wiki",
    [string]$Report = "reports\wiki-lint.csv"
)

$files = Get-ChildItem -Path $Path -Filter '*.md' -Recurse
$result = @()

foreach ($f in $files) {
    $text = Get-Content $f.FullName -Raw
    $hasFooter = $text -match "\*\*Status:\*\*"
    $evidenceLinks = Select-String -InputObject $text -Pattern "https:\/\/github.com\/.+\/(commit|pull)\/[0-9a-fA-F]+" -AllMatches
    $row = [PSCustomObject]@{
        File = $f.FullName
        HasFooter = $hasFooter
        EvidenceLinksFound = ($evidenceLinks.Matches.Count -gt 0)
        EvidenceLinkCount = $evidenceLinks.Matches.Count
    }
    $result += $row
}

$dir = Split-Path $Report -Parent
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
$result | Export-Csv -Path $Report -NoTypeInformation -Force
Write-Output "Wrote report: $Report"
