Function ServiceIsServiceAllowed($oService)
{
    if (
        $oService.ServiceName -eq "edgeupdate" `
    ) {
        return $false
    }

    if (
        $oService.ServiceName -eq "spice-agent" `
    ) {
        return $false
    }

    foreach($oServicefilter in $aServicefilter) {
        if (
            $oService.ServiceName -eq $oServicefilter.Name `
        ) {
            return $false
        }
    }

    return $true
}

Function ServiceReport()
{
    $oServiceReport = @()

    $oServices = Get-Service | Where-Object {($_.StartType -eq "Auto") -and ($_.Status -match "Stopped|.*Starting|.*Paused") -and ($_.ServiceName -notmatch "CDPSvc.*|.*gupdate|.*RemoteRegistry|.*MapsBroker|.*sppsvc|.*WbioSrvc|.*ShellHWDetection|.*iphlpsvc|.*tiledatamodelsvc|.*clr_optimization_v4.0.30319_64|.*clr_optimization_v4.0.30319_32")}
    foreach($oService in $oServices) {
        $fReturn = ServiceIsServiceAllowed($oService)
        if ($fReturn -eq $false) {
            continue;
        }

        $oRow = [pscustomobject][ordered]@{
            "Name" = $oService.ServiceName
            "Status" = $oService.Status
            "Start mode" = $oService.StartType
        }
        $oServiceReport += $oRow
    }

    $sServiceReport = $oServiceReport | ConvertTo-Html -Fragment

    return @"
        <h3>System Services - Automatic Startup but not Running</h3>
        <p>The following services are those which are set to Automatic startup type, yet are currently not running on $sComputer</p>
        $sServiceReport
"@
}
