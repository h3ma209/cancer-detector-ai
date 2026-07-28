@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo ========================================
echo  Skin Cancer Detector ^(Docker^)
echo ========================================
echo.

where docker >nul 2>&1
if errorlevel 1 (
  echo Docker not found.
  echo Install Docker Desktop: https://www.docker.com/products/docker-desktop/
  pause
  exit /b 1
)

docker info >nul 2>&1
if errorlevel 1 (
  echo Docker Desktop is not running.
  echo Start Docker Desktop, wait until it says Running, then try again.
  pause
  exit /b 1
)

if not exist "Dockerfile" (
  echo Missing Dockerfile in:
  echo %CD%
  pause
  exit /b 1
)

if not exist "docker-compose.yml" (
  echo Missing docker-compose.yml in:
  echo %CD%
  pause
  exit /b 1
)

if not exist "clean_skin_model.keras" (
  echo Missing clean_skin_model.keras in:
  echo %CD%
  pause
  exit /b 1
)

echo Building and starting...
echo Open browser: http://localhost:7860
echo Press Ctrl+C to stop.
echo.

docker compose up --build
set "EC=%ERRORLEVEL%"

echo.
if not "%EC%"=="0" (
  echo Docker exited with error code %EC%.
  pause
  exit /b %EC%
)

echo Stopped.
pause
exit /b 0
