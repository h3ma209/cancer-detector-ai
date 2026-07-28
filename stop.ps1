# Stop app:  .\stop.ps1
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

docker compose down
Write-Host "Stopped."
