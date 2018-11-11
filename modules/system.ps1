$OS = (Get-WmiObject Win32_OperatingSystem -computername $sComputer).caption
$SystemInfo = Get-WmiObject -Class Win32_OperatingSystem -computername $sComputer | Select-Object Name, TotalVisibleMemorySize, FreePhysicalMemory
$TotalRAM = $SystemInfo.TotalVisibleMemorySize/1MB
$FreeRAM = $SystemInfo.FreePhysicalMemory/1MB
$UsedRAM = $TotalRAM - $FreeRAM
$RAMPercentFree = ($FreeRAM / $TotalRAM) * 100
$TotalRAM = [Math]::Round($TotalRAM, 2)
$FreeRAM = [Math]::Round($FreeRAM, 2)
$UsedRAM = [Math]::Round($UsedRAM, 2)
$RAMPercentFree = [Math]::Round($RAMPercentFree, 2)
$Uptime = HostGetUptime($sComputer)

$oProcessor = Get-WmiObject -computername $sComputer win32_processor | Measure-Object -property LoadPercentage -Average | Select Average

# Create the chart using our Chart Function
$sRamImage = ChartCreatePie "RAM usage (Used/Free)" "GB" $FreeRAM $UsedRAM

# Get free space of C:
$oVolumeC = Get-WmiObject -Class win32_Volume -ComputerName $sComputer -Filter "DriveLetter = 'C:'" | Select-object @{n='percent free'; Expression = {"{0:N2}" -f  (($_.FreeSpace / $_.Capacity) * 100)}}, @{n='Capacity';e={"{0:n2}" -f ($_.capacity/1gb)}}, @{n='FreeSpace';e={"{0:n2}" -f ($_.freespace/1gb)}}

# Create the chart using our Chart Function
$sCImage = ChartCreatePie "C usage  (Used/Free)" "GB" $oVolumeC.Freespace $oVolumeC.Capacity

$sContent += @"
	<h3>System Info</h3>
	<table class="list system__list">
        <tr>
            <td>OS</td>
            <td>$OS</td>
        </tr>
        <tr>
            <td>Uptime</td>
            <td>$Uptime</td>
        </tr>
        <tr>
            <td>Average CPU</td>
            <td>$($oProcessor.Average) %</td>
        </tr>
        <tr>
            <td>RAM</td>
            <td>$RAMPercentFree % ($FreeRAM GB) of $TotalRAM GB free</td>
        </tr>
        <tr>
            <td>C</td>
            <td>$($oVolumeC.'percent free') % ($($oVolumeC.Freespace) GB) of $($oVolumeC.Capacity) GB free</td>
        </tr>
	</table>

    <img src="data:image/png;base64,$sRamImage" class="system__chart-ram">
    <img src="data:image/png;base64,$sCImage" class="system__chart-c">
"@
