# Author - Zen Futral
# Created for use at Xidax

# This script automates the update and verification proceedure for windows systems.

Clear-Host
$myDir = Get-Location

#========================================
function Validate-Simple(){
    sfc /scannow
    Dism /Online /Cleanup-Image /RestoreHealth
}
function Validate-Advanced(){
    sfc /scannow
    Dism /Online /Cleanup-Image /RestoreHealth
    sfc /scannow
    sfc /scannow
    chkdsk /b /f /r
    Restart-Computer -Force
}
function Add-Startup(){
    $Trigger= New-ScheduledTaskTrigger -AtLogon
    $Action= New-ScheduledTaskAction -Execute "CMD.exe" -Argument "$myDir\ActualStarter.lnk" 
    Register-ScheduledTask -TaskName "AutoUpdate" -Trigger $Trigger -Action $Action -RunLevel Highest -Force
}
function Del-Startup(){
    Unregister-ScheduledTask -TaskName "AutoUpdate"
}
function Update-Windows(){
    Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -Force -AutoReboot
}
function Save-Progress($updates, $attempts, $prevUps){
    $updates | Export-Clixml -Path $myDir\currentupdates.xml
    $prevUps | Export-Clixml -Path $myDir\prevupdates.xml
    $attempts | Export-Clixml -Path $myDir\attempts.xml
}
function Load-Progress(){
    $pathExists = Test-Path -Path $myDir\currentupdates.xml
    if($pathExists){
        $updates = Import-Clixml -Path $myDir\currentupdates.xml
        $prevUps = Import-Clixml -Path $myDir\prevupdates.xml
        $attempts = Import-Clixml -Path $myDir\attempts.xml
    }else{
        $updates = Show-WindowsUpdate
        $attempts = 0   #Number of attempts
        $prevUps = $null    # Saves updates history to see if we are retrying the same updates
    }
    return $updates, $prevUps, $attempts
}
function Init-Modules(){
    Write-Host "Checking for NuGet Package Provider"
    $pp = Find-PackageProvider -name NuGet
    if ($pp){
        Write-Host "Package Provider NuGet is installed"
    }else{
        Write-Host "Installing NuGet Package Provider"
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    }

    Write-Host "Checking for TaskScheduler Module"
    $module = Find-Module -name TaskScheduler
    if ($module){
        Write-Host "Module TaskScheduler is installed"
    }else{
        Write-Host "Installing TaskScheduler Module"
        Install-Module -name TaskScheduler -Confirm:$true | Import-Module
    }

    Write-Host "Checking for PSWindowsUpdate Module"
    $module = Find-Module -name PSWindowsUpdate
    if ($module){
        Write-Host "Module PSWindowsUpdate is installed"
    }else{
        Write-Host "Installing PSWindowsUpdate Module"
        Install-Module -name PSWindowsUpdate -Confirm:$true | Import-Module
    }
}
function Start-Main($updates, $attempts, $prevUps){
    Add-Startup
    while ($updates){ #While there are updates
        Write-Host "Updates Found"
        
        if ($prevUps -eq $updates){ #Have we tried these updates before?
            $attempts += 1  # add attempt to counter

            if($attempts -eq 1){ # Tried once, work on second
                Write-Host "Attempting Updates (Stage: 2)"
                Validate-Simple
                Update-Windows
            }

            elseif ($attempts -eq 2) { # Tried twice, work on third
                Write-Host "Attempting Updates (Stage: 3)"
                Validate-Advanced
                Update-Windows
            }

            elseif ($attempts -eq 3) { # Tried thrice, work on fourth
                Write-Host "Attempting Updates (Stage: 4)"
                Write-Error -Message "updates Failed! Manual Intervention Required."
            }

        }else{ # First time doing set of updates
            Write-Host "Attempting Updates (Stage: 1)"
            $attempts = 0
            $prevUps = $updates
            Update-Windows 
        }
        $updates = Show-WindowsUpdate
    }
}
#========================================
Init-Modules
$updates, $prevUps, $attempts = Load-Progress
Start-Main -updates $updates -attempts $attempts -prevUps $prevUps

