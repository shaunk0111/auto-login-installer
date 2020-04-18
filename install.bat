@echo on
echo %~dp0
Powershell.exe -ExecutionPolicy Unrestricted -File %~dp0\kiosk-installer.ps1 -install
pause
