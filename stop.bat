@echo off
setlocal
cd /d "%~dp0"

if exist ".venv\Scripts\python.exe" (
  echo Closing app if running is enough: press Ctrl+C in the run window.
  echo Optional: remove venv with:  rmdir /s /q .venv
) else (
  echo Nothing to stop. App not set up yet.
)
