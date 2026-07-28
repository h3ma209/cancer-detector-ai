@echo off
setlocal
cd /d "%~dp0"

where docker >nul 2>&1
if errorlevel 1 (
  echo Docker not found. Install Docker Desktop, then retry.
  exit /b 1
)

docker info >nul 2>&1
if errorlevel 1 (
  echo Docker Desktop not running. Start it, wait until ready, then retry.
  exit /b 1
)

echo Building and starting app on http://localhost:7860 ...
docker compose up --build
