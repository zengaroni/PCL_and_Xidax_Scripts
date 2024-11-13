$myDir = Get-Location
Start-Transcript -OutputDirectory "$myDir\TestLogs"

$Drives = Get-PSDrive | Where-Object {$_.Provider -match "filesystem"} | Select Root
foreach ($drive in $Drives){
    # Fetches Drives, then formats to drive letter
	$drive = $drive -replace "@{Root=", "" 
	$drive = $drive.Substring(0, $drive.Length - 3)

	Write-Host "========Starting Test On Drive: $drive========"

    # Runs disk test, then stores output in xml
    winsat.exe disk -seq -read -drive $drive -count 1 -v -xml "$myDir\DriveTests\$drive Read.xml"
	winsat.exe disk -seq -write -drive $drive -count 1 -v -xml "$myDir\DriveTests\$drive Write.xml"

	Write-Host "========================================="
}