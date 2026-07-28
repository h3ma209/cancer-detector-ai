# Native Windows run — no Docker.
# Usage:  .\run.ps1
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

function Find-Python {
    foreach ($cmd in @(
        { py -3.12 -c "import sys; print(sys.executable)" },
        { py -3 -c "import sys; print(sys.executable)" },
        { python -c "import sys; print(sys.executable)" }
    )) {
        try {
            $path = & $cmd 2>$null
            if ($LASTEXITCODE -eq 0 -and $path) { return $path.Trim() }
        } catch {}
    }
    return $null
}

$python = Find-Python
if (-not $python) {
    Write-Host "Python not found."
    Write-Host "Install Python 3.12 from https://www.python.org/downloads/"
    Write-Host 'IMPORTANT: check "Add python.exe to PATH" during install.'
    Start-Process "https://www.python.org/downloads/release/python-31210/"
    exit 1
}

if (-not (Test-Path "clean_skin_model.keras")) {
    Write-Error "Missing clean_skin_model.keras in this folder."
}

$venvPython = Join-Path $PSScriptRoot ".venv\Scripts\python.exe"
if (-not (Test-Path $venvPython)) {
    Write-Host "Creating virtual environment..."
    & $python -m venv .venv
    Write-Host "Installing dependencies (first time only, can take a few minutes)..."
    & $venvPython -m pip install -U pip
    & $venvPython -m pip install -r requirements.txt
}

Write-Host "Starting app on http://localhost:7860 ..."
Write-Host "Press Ctrl+C to stop."
$env:GRADIO_SERVER_NAME = "0.0.0.0"
$env:GRADIO_SERVER_PORT = "7860"
& $venvPython app.py
