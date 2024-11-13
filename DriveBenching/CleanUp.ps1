$myDir = Get-Location
Get-ChildItem -Path "$myDir\DriveTests" -File | Remove-Item -Verbose
Get-ChildItem -Path "$myDir\TestLogs" -File | Remove-Item -Verbose
Clear
