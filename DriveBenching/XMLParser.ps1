$myDir = Get-Location
Start-Transcript -OutputDirectory "$myDir\TestLogs"
$fileLocation = "$myDir\DriveTests\C Read.xml"
[xml]$xmlFile = Get-Content -Path $fileLocation

$osName = $xmlFile.WinSat.SystemConfig.OSVersion.ProductName
$osBuild = $xmlFile.WinSat.SystemConfig.OSVersion.Build

$cpuName = $xmlFile.WinSAT.SystemConfig.Processor.Instance.ProcessorName
$coreCount = $xmlFile.WinSAT.SystemConfig.Processor.Instance.NumCores
$threadCount = $xmlFile.WinSAT.SystemConfig.Processor.Instance.NumCPUs

$ramSize = $xmlFile.WinSat.SystemConfig.Memory.TotalPhysical.Size

# need to figure out way to iterate over multiple gpu's and storage

$gpuName = $xmlFile.WinSAT.SystemConfig.Graphics.AdapterDescription
