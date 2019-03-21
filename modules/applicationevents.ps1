$oApplicationEventsReport = @()

try {
    $sError = ""
    $oApplicationEvents = Get-EventLog -ComputerName $sComputer -LogName "Application" -EntryType Error,Warning -after (Get-Date).AddHours($iApplicationEventLastHours * -1) -ErrorAction Stop
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

foreach($oEvent in $oApplicationEvents) {
    $oRow = [pscustomobject][ordered]@{
        "Time&nbsp;generated&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" = $oEvent.TimeGenerated
        "Entry&nbsp;type" = $oEvent.EntryType
        "ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" = $oEvent.EventID
        "Source" = $oEvent.Source
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
