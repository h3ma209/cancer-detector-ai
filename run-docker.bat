@echo off
setlocal
cd /d "%~dp0"

where docker >nul 2>&1
if errorlevel 1 (
  echo Docker not found. Prefer run.bat instead ^(no Docker needed^).
  exit /b 1
)

docker info >nul 2>&1
if errorlevel 1 (
  echo Docker Desktop not running / virtualization failed.
  echo Easier path: double-click run.bat ^(Python only^).
  exit /b 1
)

docker compose up --build
