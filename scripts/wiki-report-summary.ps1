<#
  Summarize the reports/wiki-lint.csv produced by scripts/wiki-lint.ps1
  Usage: pwsh -NoProfile -File .\scripts\wiki-report-summary.ps1
#>

Param(
    [string]$Report = "reports/wiki-lint.csv"
)

if (-not (Test-Path $Report)) {
    Write-Error "Report not found: $Report"
    exit 2
}

$csv = Import-Csv $Report
$total = $csv.Count
$noFooter = ($csv | Where-Object { $_.HasFooter -eq 'False' }).Count
$templates = ($csv | Where-Object { $_.File -match 'Template' -or $_.File -match '_Sidebar.md|_Footer.md' }).Count

Write-Output "Total wiki pages: $total"
Write-Output "Pages missing footer: $noFooter"
Write-Output "Template or meta pages: $templates"

if ($noFooter -gt 0) {
    Write-Output "`nFiles missing the footer (sample):"
    $csv | Where-Object { $_.HasFooter -eq 'False' } | Select-Object -First 20 | ForEach-Object { Write-Output $_.File }
}

exit 0
