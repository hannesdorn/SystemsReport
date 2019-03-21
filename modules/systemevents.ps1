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
            ($oEvent.EntryType -eq "Error" -and $oEvent.Source -eq "Schannel" -and $oEvent.EventID -eq 36888 -and $oEvent.ReplacementStrings[0] -eq "10" -and $oEvent.ReplacementStrings[1] -eq "1200") `
        -or ($oEvent.EntryType -eq "Error" -and $oEvent.Source -eq "Schannel" -and $oEvent.EventID -eq 36888 -and $oEvent.ReplacementStrings[0] -eq "10" -and $oEvent.ReplacementStrings[1] -eq "1203") `
        -or ($oEvent.EntryType -eq "Error" -and $oEvent.Source -eq "Schannel" -and $oEvent.EventID -eq 36888 -and $oEvent.ReplacementStrings[0] -eq "40" -and $oEvent.ReplacementStrings[1] -eq "1205") `
        -or ($oEvent.EntryType -eq "Error" -and $oEvent.Source -eq "Schannel" -and $oEvent.EventID -eq 36874) `
        -or ($oEvent.EntryType -eq "Error" -and $oEvent.Source -eq "Schannel" -and $oEvent.EventID -eq 36887) `
        -or ($oEvent.EntryType -eq "Error" -and $oEvent.Source -eq "KLIF" -and $oEvent.EventID -eq 5) `
        -or ($oEvent.EntryType -eq "Error" -and $oEvent.Source -eq "Disk" -and $oEvent.EventID -eq 51) `
        -or ($oEvent.EntryType -eq "Error" -and $oEvent.Source -eq "FilterManager" -and $oEvent.EventID -eq 3)
    ) {
        Continue
    }

    $oRow = [pscustomobject][ordered]@{
        "Time&nbsp;generated&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" = $oEvent.TimeGenerated
        "Entry&nbsp;type" = $oEvent.EntryType
        "ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" = $oEvent.EventID
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
