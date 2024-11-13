$myDir = Get-Location
Start-Transcript -Path "$myDir\TestLogs\CBScores.txt"
& "$myDir\CinebenchRunner.bat"
