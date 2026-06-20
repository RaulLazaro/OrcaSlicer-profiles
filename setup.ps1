param(
    [switch]$Remove
)

$ErrorActionPreference = "Stop"

$repoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$orcaDir = "$env:APPDATA\OrcaSlicer\user\default"

if (-not (Test-Path "$env:APPDATA\OrcaSlicer\user")) {
    Write-Error "OrcaSlicer user config directory not found: $env:APPDATA\OrcaSlicer\user"
    exit 1
}

if ($Remove) {
    if (Test-Path $orcaDir) {
        $item = Get-Item $orcaDir
        if ($item.LinkType) {
            Remove-Item $orcaDir -Force
            Write-Host "Removed symlink: $orcaDir" -ForegroundColor Green
        } else {
            Write-Warning "Not a symlink: $orcaDir"
        }
    } else {
        Write-Warning "Not found: $orcaDir"
    }
    exit 0
}

Write-Host "Creating symlink: OrcaSlicer user default -> $repoDir" -ForegroundColor Cyan

if (Test-Path $orcaDir) {
    $item = Get-Item $orcaDir
    if ($item.LinkType) {
        Remove-Item $orcaDir -Force
        Write-Host "  Removed existing symlink" -ForegroundColor Yellow
    } else {
        $backup = "$orcaDir.bak"
        Move-Item $orcaDir $backup -Force
        Write-Host "  Backed up existing directory to: $backup" -ForegroundColor Yellow
    }
}

New-Item -ItemType Junction -Path $orcaDir -Target $repoDir | Out-Null
Write-Host "  Created junction: $orcaDir -> $repoDir" -ForegroundColor Green
Write-Host "Done. Restart OrcaSlicer to see the profiles." -ForegroundColor Cyan
