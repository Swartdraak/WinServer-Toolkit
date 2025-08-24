param(
    [string]$prefix = "AID",
    [int]$number = 1
)

# Generate an ID using America/Anchorage local date in YYYYMMDD format
$tz = [System.TimeZoneInfo]::FindSystemTimeZoneById('Alaskan Standard Time')
$now = [System.TimeZoneInfo]::ConvertTime([DateTime]::UtcNow, $tz)
$date = $now.ToString('yyyyMMdd')

$formatted = "{0}-{1}-{2:D3}" -f $prefix, $date, $number
Write-Output $formatted
