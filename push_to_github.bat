@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0push_to_github.ps1"
set "RESULT=%ERRORLEVEL%"
echo.
if not "%RESULT%"=="0" echo Push dibatalkan. Baca pesan kesalahan di atas.
pause
exit /b %RESULT%
