$myDir = Get-Location
Get-ChildItem -Path "$myDir\CoreTemp" -File -Filter *.csv | Remove-Item -Verbose
Get-ChildItem -Path "$myDir\DriveTests" -File | Remove-Item -Verbose
Get-ChildItem -Path "$myDir\TestLogs" -File | Remove-Item -Verbose
Remove-Item -Path "$myDir\Restults.txt"
clear
