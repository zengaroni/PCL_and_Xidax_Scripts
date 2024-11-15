# Author - Zen Futral
# Created for use at Xidax

# This script automates the identification and search for motherboard bios/drivers

Start-Transcript -OutputDirectory "C:\Windows\PSLogs\MoBoDriverFinder\" -NoClobber

$Manu = wmic baseboard get manufacturer | Select-Object -Index 2 | Out-String
$Prod = wmic baseboard get product | Select-Object -Index 2 | Out-String
$myVar = -join ($Manu.Trim(), "+", $Prod.Trim())
$myVar = $myVar.Replace(" ", "+")
Write-Host $myVar

$myUrl = -join("https://www.google.com/search?q=", $myVar, "+Bios+Update")

msinfo32.exe

try {
	[system.Diagnostics.Process]::Start("Chrome", $myUrl)
} catch {
	[system.Diagnostics.Process]::Start($myUrl)
}

pause