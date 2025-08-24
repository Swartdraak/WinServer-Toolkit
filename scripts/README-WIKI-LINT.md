# Wiki Lint

This script checks the wiki for the presence of the required Status Footer and validates evidence links (commit|PR patterns).

Usage:

```powershell
pwsh .\scripts\wiki-lint.ps1 -Path '..\winserver-toolkit.wiki' -Report 'reports\wiki-lint.csv'
```

The script will write a CSV report with columns `File,HasFooter,EvidenceLinksFound,EvidenceLinkCount`.
