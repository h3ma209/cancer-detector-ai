@echo off
setlocal EnableExtensions
cd /d "%~dp0"

where py >nul 2>&1
if errorlevel 1 (
  where python >nul 2>&1
  if errorlevel 1 (
    echo Python not found.
    echo Install Python 3.12 from https://www.python.org/downloads/
    echo IMPORTANT: check "Add python.exe to PATH" during install.
    start https://www.python.org/downloads/release/python-31210/
    exit /b 1
  )
  set "PY=python"
) else (
  set "PY=py -3.12"
  %PY% -V >nul 2>&1
  if errorlevel 1 set "PY=py -3"
)

if not exist "clean_skin_model.keras" (
  echo Missing clean_skin_model.keras in this folder.
  exit /b 1
)

if not exist ".venv\Scripts\python.exe" (
  echo Creating virtual environment...
  %PY% -m venv .venv
  if errorlevel 1 (
    echo Failed to create venv. Install Python 3.12 and retry.
    exit /b 1
  )
  echo Installing dependencies ^(first time only, can take a few minutes^)...
  ".venv\Scripts\python.exe" -m pip install -U pip
  ".venv\Scripts\python.exe" -m pip install -r requirements.txt
  if errorlevel 1 (
    echo pip install failed.
    exit /b 1
  )
)

echo Starting app on http://localhost:7860 ...
echo Press Ctrl+C to stop.
set GRADIO_SERVER_NAME=0.0.0.0
set GRADIO_SERVER_PORT=7860
".venv\Scripts\python.exe" app.py
