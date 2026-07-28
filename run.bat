@echo off
setlocal EnableExtensions
cd /d "%~dp0"

echo ========================================
echo  Skin Cancer Detector
echo ========================================
echo.

REM Keep window open on any failure when double-clicked
goto :main

:fail
echo.
echo FAILED. See message above.
pause
exit /b 1

:main
where py >nul 2>&1
if not errorlevel 1 (
  py -3.12 -V >nul 2>&1
  if not errorlevel 1 (
    set "PY=py -3.12"
    goto :have_python
  )
  py -3 -V >nul 2>&1
  if not errorlevel 1 (
    set "PY=py -3"
    goto :have_python
  )
)

where python >nul 2>&1
if not errorlevel 1 (
  python -V >nul 2>&1
  if not errorlevel 1 (
    set "PY=python"
    goto :have_python
  )
)

echo Python not found on PATH.
echo.
echo 1. Install Python 3.12:
echo    https://www.python.org/downloads/release/python-31210/
echo 2. During install, CHECK: "Add python.exe to PATH"
echo 3. Close this window, open a NEW one, run run.bat again.
echo.
start "" "https://www.python.org/downloads/release/python-31210/"
goto :fail

:have_python
echo Using: %PY%
%PY% -V
echo.

if not exist "app.py" (
  echo Missing app.py in:
  echo %CD%
  goto :fail
)

if not exist "clean_skin_model.keras" (
  echo Missing clean_skin_model.keras in:
  echo %CD%
  goto :fail
)

if not exist "requirements.txt" (
  echo Missing requirements.txt in:
  echo %CD%
  goto :fail
)

if not exist ".venv\Scripts\python.exe" (
  echo Creating virtual environment...
  %PY% -m venv .venv
  if errorlevel 1 (
    echo Could not create .venv
    goto :fail
  )

  echo Installing packages ^(first time only^)...
  ".venv\Scripts\python.exe" -m pip install -U pip
  if errorlevel 1 goto :fail
  ".venv\Scripts\python.exe" -m pip install -r requirements.txt
  if errorlevel 1 (
    echo pip install failed.
    goto :fail
  )
  echo.
)

echo Starting app...
echo Open browser: http://localhost:7860
echo Press Ctrl+C to stop.
echo.

set GRADIO_SERVER_NAME=0.0.0.0
set GRADIO_SERVER_PORT=7860
".venv\Scripts\python.exe" app.py
set "EC=%ERRORLEVEL%"

echo.
if not "%EC%"=="0" (
  echo App exited with error code %EC%.
  pause
  exit /b %EC%
)

echo App stopped.
pause
exit /b 0
