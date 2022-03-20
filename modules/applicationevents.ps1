Function ApplicationEventAllowed($oEvent)
{
    if (
        $oEvent.Level -eq 3 `
        -and $oEvent.ProviderName -eq "ASP.NET 4.0.30319.0" `
        -and $oEvent.Id -eq 1309
    ) {
        return $false
    }

    # Exchange Events Filtern
    # https://support.microsoft.com/en-us/topic/event-ids-1003-1309-and-4999-are-logged-after-installing-exchange-server-2019-cu8-1295c555-d590-4a06-a53a-c14a0f363ee3
    if (
        $oEvent.Level -eq 3 `
        -and $oEvent.ProviderName -eq "MSExchangeApplicationLogic" `
        -and $oEvent.Id -eq 3028
    ) {
        return $false
    }

    if (
        $oEvent.Level -eq 2 `
        -and $oEvent.ProviderName -eq "MSExchange Front End HTTP" `
        -and $oEvent.Id -eq 1003
    ) {
        return $false
    }

    if (
        $oEvent.Level -eq 2 `
        -and $oEvent.ProviderName -eq "MSExchange Common" `
        -and $oEvent.Id -eq 4999
    ) {
        return $false
    }

    foreach($oEventfilter in $aApplicationEventEventfilter) {
        if (
            $oEvent.Level -eq $oEventfilter.Level `
            -and $oEvent.ProviderName -eq $oEventfilter.ProviderName `
            -and $oEvent.Id -eq $oEventfilter.Id
        ) {
            return $false
        }
    }

    return $true
}

$oApplicationEventsReport = @()

try {
    $sError = ""
    #$aApplicationEvents = Get-EventLog -ComputerName $sComputer -LogName "Application" -EntryType Error,Warning,FailureAudit -after (Get-Date).AddHours($iApplicationEventLastHours * -1) -ErrorAction Stop
    $aApplicationEvents = Get-WinEvent -ComputerName $sComputer -FilterHashTable @{LogName='Application'; Level=1,2,3; 'StartTime' = (Get-Date).AddHours($iSystemEventLastHours * -1)}
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

foreach($oEvent in $aApplicationEvents) {
    $fReturn = ApplicationEventAllowed($oEvent)
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
    $oApplicationEventsReport += $oRow
}
$sApplicationEventsReport = $oApplicationEventsReport | ConvertTo-Html -Fragment

$sContent += @"
	<h3>Application Warnings or Errors in the last $iApplicationEventLastHours hours</h3>
	<p>The following is a list of the last <b>Application log</b> events that had an Event Type of either Warning or Error on $sComputer</p>
	$sApplicationEventsReport
    $sError
"@
