# Update this repository, the pinned darsia submodule and the Python environment.
#
# Usage:
#   .\update.ps1            # users: get the darsia version this repository pins
#   .\update.ps1 -Latest    # maintainers: move darsia to its newest upstream commit
#
# If PowerShell blocks the script, run:
#   powershell -ExecutionPolicy Bypass -File .\update.ps1

param([switch]$Latest)

$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

function Fail($msg) {
    Write-Host ""
    Write-Host "ERROR: $msg" -ForegroundColor Red
    exit 1
}

foreach ($tool in "git", "uv") {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        Fail "'$tool' was not found. See the Prerequisites section of README.md."
    }
}

Write-Host "==> Fetching the latest version of this repository..."
git pull
if ($LASTEXITCODE -ne 0) {
    Fail "'git pull' failed. If you have local changes, commit or stash them and run this script again."
}

if ($Latest) {
    Write-Host "==> Moving darsia to the newest upstream commit..."
    git submodule update --init --remote external/darsia
} else {
    Write-Host "==> Checking out the darsia version pinned by this repository..."
    git submodule update --init --recursive
}
if ($LASTEXITCODE -ne 0) { Fail "Updating the darsia submodule failed." }

Write-Host "==> Updating the Python environment (uv sync)..."
uv sync
if ($LASTEXITCODE -ne 0) { Fail "'uv sync' failed." }

$version = git -C external/darsia describe --tags --always
Write-Host ""
Write-Host "Done. darsia version in use: $version" -ForegroundColor Green
Write-Host "Start the GUI with:  uv run darsia"

if ($Latest) {
    Write-Host ""
    Write-Host "To make this darsia version the new default for everyone, run:"
    Write-Host "  git add external/darsia uv.lock"
    Write-Host "  git commit -m `"Update darsia submodule`""
    Write-Host "  git push"
}
