$oServicesReport = @()

#$oServices = Get-WmiObject -Class Win32_Service -ComputerName $sComputer | Where-Object {($_.StartMode -eq "Auto") -and ($_.State -match "Stopped|.*Starting|.*Paused") -and ($_.Name -notmatch "CDPSvc.*|.*gupdate|.*RemoteRegistry|.*MapsBroker|.*sppsvc|.*WbioSrvc|.*ShellHWDetection|.*iphlpsvc|.*tiledatamodelsvc|.*clr_optimization_v4.0.30319_64|.*clr_optimization_v4.0.30319_32")}
$oServices = Get-Service | Where-Object {($_.StartType -eq "Auto") -and ($_.Status -match "Stopped|.*Starting|.*Paused") -and ($_.ServiceName -notmatch "CDPSvc.*|.*gupdate|.*RemoteRegistry|.*MapsBroker|.*sppsvc|.*WbioSrvc|.*ShellHWDetection|.*iphlpsvc|.*tiledatamodelsvc|.*clr_optimization_v4.0.30319_64|.*clr_optimization_v4.0.30319_32")}
foreach($oService in $oServices) {
    $oRow = [pscustomobject][ordered]@{
        "Name" = $oService.ServiceName
        "Status" = $oService.Status
        "Start mode" = $oService.StartType
    }
    $oServicesReport += $oRow
}

$sServicesReport = $oServicesReport | ConvertTo-Html -Fragment

$sContent += @"
    <h3>System Services - Automatic Startup but not Running</h3>
    <p>The following services are those which are set to Automatic startup type, yet are currently not running on $sComputer</p>
    $sServicesReport
"@
