@setlocal enableextensions
@cd /d "%~dp0"
powershell -command "& {Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force}"

start CoreTemp\CoreTemp.exe
powershell.exe -file CleanUp.ps1
powershell.exe -file StartCBRunner.ps1
powershell.exe -file KillCoreTemp.ps1
powershell.exe -file DriveBench.ps1
powershell.exe -file LogParser.ps1

pause

::Create install bat to avoid CNU issues