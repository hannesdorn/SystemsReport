$sTopProcesses = Get-Process -ComputerName $sComputer | Sort WS -Descending | Select ProcessName, Id, WS -First $iProccesses | ConvertTo-Html -Fragment

$sContent += @"
    <h3>System Processes - Top $iProccesses Highest Memory Usage</h3>
    <p>The following $iProccesses processes are those consuming the highest amount of Working Set (WS) Memory (bytes) on $sComputer</p>
    $sTopProcesses
"@
