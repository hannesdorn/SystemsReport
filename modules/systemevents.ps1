$oSystemEventsReport = @()

try {
    $sError = ""
    $oSystemEvents = Get-EventLog -ComputerName $sComputer -LogName "System" -EntryType Error,Warning -after (Get-Date).AddHours($iSystemEventLastHours * -1) -ErrorAction Stop
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

foreach($oEvent in $oSystemEvents) {
    if (
        ($oEvent.Source -eq "Schannel" -and $oEvent.EventID -eq 36888 -and $oEvent.ReplacementStrings[0] -eq "10" -and $oEvent.ReplacementStrings[1] -eq "1203") `
        -or ($oEvent.Source -eq "Schannel" -and $oEvent.EventID -eq 36888 -and $oEvent.ReplacementStrings[0] -eq "40" -and $oEvent.ReplacementStrings[1] -eq "1205") `
        -or ($oEvent.Source -eq "KLIF" -and $oEvent.EventID -eq 5 -and $oEvent.EntryType -eq "Error") `
        -or ($oEvent.Source -eq "Disk" -and $oEvent.EventID -eq 51 -and $oEvent.EntryType -eq "Warning") `
        -or ($oEvent.Source -eq "FilterManager" -and $oEvent.EventID -eq 3 -and $oEvent.EntryType -eq "Error")
    ) {
        Continue
    }

    $oRow = [pscustomobject][ordered]@{
        "Time generated" = $oEvent.TimeGenerated
        "Entry type" = $oEvent.EntryType
        "Source" = $oEvent.Source
        "Message" = $oEvent.Message
    }
    $oSystemEventsReport += $oRow
}
$sSystemEventsReport = $oSystemEventsReport | ConvertTo-Html -Fragment

$sContent += @"
	<h3>System Warnings or Errors in the last $iSystemEventLastHours hours</h3>
	<p>The following is a list of the last <b>System log</b> events that had an Event Type of either Warning or Error on $sComputer</p>
	$sSystemEventsReport
    $sError
"@
