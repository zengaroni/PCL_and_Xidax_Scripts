$myDir = Get-Location

function Fetch-SysInfo {
    [xml]$xmlFile = Get-ChildItem -Path "$myDir\DriveTests" -Force -Recurse -File | Select-Object -First 1 | Get-Content 
    $osName = $xmlFile.WinSat.SystemConfig.OSVersion.ProductName
    $osBuild = $xmlFile.WinSat.SystemConfig.OSVersion.Build
    $cpuName = $xmlFile.WinSAT.SystemConfig.Processor.Instance.ProcessorName
    $coreCount = $xmlFile.WinSAT.SystemConfig.Processor.Instance.NumCores
    $threadCount = $xmlFile.WinSAT.SystemConfig.Processor.Instance.NumCPUs
    $ramSize = $xmlFile.WinSat.SystemConfig.Memory.TotalPhysical.Size

    "$osName (Build Version: $osBuild)" | Out-File -FilePath $myDir\Results.txt -Append
    "===========================================" | Out-File -FilePath $myDir\Results.txt -Append
    $cpuName | Out-File -FilePath $myDir\Results.txt -Append
    "$coreCount C / $threadCount T" | Out-File -FilePath $myDir\Results.txt -Append
    "===========================================" | Out-File -FilePath $myDir\Results.txt -Append
    "RAM: $ramSize" | Out-File -FilePath $myDir\Results.txt -Append  
}

function Fetch-DriveBench {
    $myFiles = Get-ChildItem -Path "$myDir\DriveTests\" -Force -File

    foreach($file in $myFiles){
        [xml]$myFile = Get-Content "$myDir\DriveTests\$file" 
        $throughput = $myFile.WinSat.DiskAssessment.PerDiskData.Zone.ETWData.Throughput
        $myArray = @()

        foreach($float in $throughput){
            [double]$double = $float
            $myArray += $double
        }
        Write-Host ($myArray | Measure-Object -Average).average
    }
}

Fetch-SysInfo
Fetch-DriveBench
pause
