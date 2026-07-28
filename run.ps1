# Docker run for Windows. Usage: .\run.ps1
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

Write-Host "========================================"
Write-Host " Skin Cancer Detector (Docker)"
Write-Host "========================================"
Write-Host ""

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker not found. Install Docker Desktop."
    Read-Host "Press Enter to exit"
    exit 1
}

try {
    docker info | Out-Null
} catch {
    Write-Host "Docker Desktop is not running. Start it, then retry."
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Building and starting..."
Write-Host "Open browser: http://localhost:7860"
Write-Host "Press Ctrl+C to stop."
Write-Host ""

docker compose up --build
