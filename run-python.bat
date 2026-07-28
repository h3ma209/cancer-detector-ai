@echo off
setlocal EnableExtensions
cd /d "%~dp0"

REM Fallback: native Python (no Docker)
echo ========================================
echo  Skin Cancer Detector ^(Python^)
echo ========================================
echo.

where py >nul 2>&1
if not errorlevel 1 (
  py -3.12 -V >nul 2>&1
  if not errorlevel 1 ( set "PY=py -3.12" & goto :have_python )
  py -3 -V >nul 2>&1
  if not errorlevel 1 ( set "PY=py -3" & goto :have_python )
)

where python >nul 2>&1
if not errorlevel 1 (
  set "PY=python"
  goto :have_python
)

echo Python not found. Prefer run.bat with Docker instead.
pause
exit /b 1

:have_python
if not exist ".venv\Scripts\python.exe" (
  echo Creating venv + installing deps...
  %PY% -m venv .venv || ( pause & exit /b 1 )
  ".venv\Scripts\python.exe" -m pip install -U pip
  ".venv\Scripts\python.exe" -m pip install -r requirements.txt || ( pause & exit /b 1 )
)

set GRADIO_SERVER_NAME=0.0.0.0
set GRADIO_SERVER_PORT=7860
echo Open http://localhost:7860
".venv\Scripts\python.exe" app.py
pause
