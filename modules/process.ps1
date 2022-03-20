$sTopProcesses = Get-Process | Sort WS -Descending | Select ProcessName, Id, @{n='Working Set (MB)';e={"{0:n2}" -f ($_.ws/1mb)}} -First $iProccesses | ConvertTo-Html -Fragment

$sContent += @"
    <h3>System Processes - Top $iProccesses Highest Memory Usage</h3>
    <p>The following $iProccesses processes are those consuming the highest amount of memory on $sComputer</p>
    $sTopProcesses
"@
