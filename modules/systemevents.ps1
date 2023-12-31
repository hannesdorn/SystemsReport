Function SystemEventIsEventAllowed($oEvent)
{
    if (
        $oEvent.Level -eq 2 `
        -and $oEvent.ProviderName -eq "Schannel" `
        -and $oEvent.Id -eq 36888 `
        -and $oEvent.Properties[0] -eq "10" `
        -and $oEvent.Properties[1] -eq "1200"
    ) {
        return $false
    }

    if (
        $oEvent.Level -eq 2 `
        -and $oEvent.ProviderName -eq "Schannel" `
        -and $oEvent.Id -eq 36888 `
        -and $oEvent.Properties[0] -eq "10" `
        -and $oEvent.Properties[1] -eq "1203"
    ) {
        return $false
    }

    if (
        $oEvent.Level -eq 2 `
        -and $oEvent.ProviderName -eq "Schannel" `
        -and $oEvent.Id -eq 36888 `
        -and $oEvent.Properties[0] -eq "40" `
        -and $oEvent.Properties[1] -eq "1205"
    ) {
        return $false
    }

    if (
        $oEvent.Level -eq 2 `
        -and $oEvent.ProviderName -eq "Schannel" `
        -and $oEvent.Id -eq 36874
    ) {
        return $false
    }

    if (
        $oEvent.Level -eq 2 `
        -and $oEvent.ProviderName -eq "Schannel" `
        -and $oEvent.Id -eq 36887
    ) {
        return $false
    }

    if (
        $oEvent.Level -eq 2 `
        -and $oEvent.ProviderName -eq "KLIF" `
        -and $oEvent.Id -eq 5
    ) {
        return $false
    }

    if (
        $oEvent.Level -eq 2 `
        -and $oEvent.ProviderName -eq "Microsoft-Windows-FilterManager" `
        -and $oEvent.Id -eq 3
    ) {
        return $false
    }

    if (
        $oEvent.Level -eq 2 `
        -and $oEvent.ProviderName -eq "UmrdpService" `
        -and $oEvent.Id -eq 1111
    ) {
        return $false
    }

    # https://support.microsoft.com/de-de/help/4022522/dcom-event-id-10016-is-logged-in-windows-10-windows-server
    # https://support.microsoft.com/de-de/help/4022522/dcom-event-id-10016-is-logged-in-windows
    if (
        $oEvent.Level -eq 3 `
        -and $oEvent.ProviderName -eq "Microsoft-Windows-DistributedCOM" `
        -and $oEvent.Id -eq 10016
    ) {
        return $false
    }

    foreach($oEventfilter in $aSystemEventEventfilter) {
        if (
            ($oEvent.Level -eq $oEventfilter.Level -or $oEventfilter.Level -eq 0)`
            -and ($oEvent.ProviderName -eq $oEventfilter.ProviderName -or $oEventfilter.ProviderName -eq '') `
            -and ($oEvent.Id -eq $oEventfilter.Id -or $oEventfilter.Id -eq 0) `
            -and ($oEvent.Message -match $oEventfilter.Message -or $oEventfilter.Message -eq '')
        ) {
            return $false
        }
    }

    return $true
}

Function SystemEventsReport()
{
    $oSystemEventsReport = @()

    try {
        $sError = ""
        $aSystemEvents = Get-WinEvent -ComputerName $sComputer -oldest -FilterHashTable @{LogName='System'; Level=1,2,3; 'StartTime' = (Get-Date).AddHours($iSystemEventLastHours * -1)}
    } catch [Exception]{
        $oError = $_
        switch($oError.Exception.GetType().FullName) {
            System.InvalidOperationException {
                $sError = $oError.Exception.Message
            }
            System.ArgumentException {
                $sError = $oError.Exception.Message
            }
            default {
                $sError = $oError.Exception.GetType().FullName
            }
        }
    }

    foreach($oEvent in $aSystemEvents) {
        $fReturn = SystemEventIsEventAllowed($oEvent)
        if ($fReturn -eq $false) {
            continue;
        }

        $oRow = [pscustomobject][ordered]@{
            "Time&nbsp;generated&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" = $oEvent.TimeCreated
            "Entry&nbsp;type" = $oEvent.LevelDisplayName
            "ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" = $oEvent.Id
            "Source" = $oEvent.ProviderName
            "Message" = $oEvent.Message
        }
        $oSystemEventsReport += $oRow
    }
    $sSystemEventsReport = $oSystemEventsReport | ConvertTo-Html -Fragment

    return @"
        <h3>System Warnings or Errors in the last $iSystemEventLastHours hours</h3>
        <p>The following is a list of the last <b>System log</b> events that had an Event Type of either Warning or Error on $sComputer</p>
        $sSystemEventsReport
        $sError
"@
}
