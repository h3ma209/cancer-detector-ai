@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo Stopping Docker containers...
docker compose down
if errorlevel 1 (
  echo Failed to stop. Is Docker Desktop running?
  pause
  exit /b 1
)

echo Stopped.
pause
