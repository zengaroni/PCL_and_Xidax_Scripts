@setlocal enableextensions
@cd /d "%~dp0"
powershell -command "& {Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force}"
powershell.exe -file CleanUp.ps1
powershell.exe -file DriveBench.ps1
powershell.exe -file XMLParser.ps1
pause

::Create install bat to avoid CNU issues