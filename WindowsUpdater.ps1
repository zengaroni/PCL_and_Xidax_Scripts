# Author - Zen Futral
# Created for use at Xidax

# This script automates the update and verification proceedure for windows systems.


# This script requires -RunAsAdministrator

Start-Transcript -OutputDirectory "C:\Windows\PSLogs\WinUp\" -NoClobber

function Update-Windows ($UpAttemptCount, $ServiceStartCount) {
	Clear-Host
	if (!(Test-Connection 8.8.8.8 -Count 1 -Quiet)) {	# Check for Internet connection
		Write-Host "No Internet Connection"
		Pause
	} 
	try {
		Write-Host "Checking for Updates"

		if((Show-WindowsUpdate -Confirm:$false).count -gt 0) {	# Tries to check for updates, if there are, update
			Write-Host "Windows Updates Found"
			Write-Host "Attempting"

			Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot -Confirm:$false

		} else {	# if no updates are found
				Write-Host "No Updates Found"
				Write-Host "Running Verification To Finalize"
				
				sfc /scannow
				Dism.exe /Online /Cleanup-Image /RestoreHealth
				Dism.exe /online /Cleanup-Image /StartComponentCleanup
				sfc /scannow
		}
		
	} catch [System.Management.Automation.CommandNotFoundException] {	# If unable to check for updates, download prereqs and try again	
		Write-Host "Prereqs Are Required"

		Write-Host "Installing Package Provider"
		Install-PackageProvider -Name NuGet -Force

		Write-Host "Installing Module"
		Install-Module PSWindowsUpdate -Force | Import-Module
		Update-Windows -UpAttemptCount:0, -ServiceStartCount 0

	} catch [System.Runtime.InteropServices.COMException] {	# If update service is not running
		Write-Host "Error Starting Update Service"
		Write-Host "Attemptting to Restart Service"
		
		If ($ServiceStartCount -eq 0){	# Try and restart 
			Restart-Service -name wuauserv -ErrorAction:SilentlyContinue
			Write-Host "Cannot Start Service"
			Update-Windows -UpAttemptCount:0, -ServiceStartCount:1

		} elseif ($ServiceStartCount -eq 1){	# If unable, verify and try again
			Write-Host "Verifying Windows Then Retrying"
			Dism.exe /Online /Cleanup-Image /RestoreHealth
			Dism.exe /online /Cleanup-Image /StartComponentCleanup
			sfc /scannow
			Restart-Service -name wuauserv -ErrorAction:SilentlyContinue
			Update-Windows -UpAttemptCount:0, -ServiceStartCount:2

		} else {	# Error out, something is wrong
			Write-Host "This Was Attempt 2, Manual Intervention Is Needed"
			pause	
		
		}
	} catch {
		wuauclt.exe /updatenow
		
		net stop wuauserv
		net stop cryptSvc
		net stop bits
		net stop msiserver
		
		Set-Location %Windir%\SoftwareDistribution
		Remove-Item /f /s /q Download
		
		net start wuauserv
		net start cryptSvc
		net start bits
		net start msiserver
		
		Clear-Host
		Write-Host "System Must Be Restarted to Finish Fix"
		Write-Host "Restarting Now"
		Restart-Computer
	}
}

Update-Windows -UpAttemptCount:0, -ServiceStartCount:0