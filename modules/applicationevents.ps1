$oApplicationEventsReport = @()

# $oApplicationEvents = Get-EventLog -ComputerName $sComputer -LogName Application -EntryType Error,Warning -Newest $EventNum
$oApplicationEvents = Get-EventLog -ComputerName $sComputer -LogName Application -EntryType Error,Warning -after (Get-Date).AddHours($iApplicationEventLastHours * -1)

foreach($oEvent in $oApplicationEvents) {
    $oRow = New-Object -Type PSObject -Property @{
        TimeGenerated = $oEvent.TimeGenerated
        EntryType = $oEvent.EntryType
        Source = $oEvent.Source
        Message = $oEvent.Message
    }
    $oApplicationEventsReport += $oRow
}
$sApplicationEventsReport = $oApplicationEventsReport | ConvertTo-Html -Fragment

$sContent += @"
	<h3>Application Warnings or Errors in the last $iApplicationEventLastHours hours</h3>
	<p>The following is a list of the last <b>Application log</b> events that had an Event Type of either Warning or Error on $sComputer</p>
	$sApplicationEventsReport
"@
