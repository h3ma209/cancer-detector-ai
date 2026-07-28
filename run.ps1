# Run from project folder:  .\run.ps1
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error "Docker not found. Install Docker Desktop, then retry."
}

try {
    docker info | Out-Null
} catch {
    Write-Error "Docker Desktop not running. Start it, wait until ready, then retry."
}

Write-Host "Building and starting app on http://localhost:7860 ..."
docker compose up --build
