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
$sRamImage = ChartCreatePie "RAM Usage Chart (Used/Free)" "GB" $FreeRAM $UsedRAM

$sHtmlStyles += @"
        .system__list {
            float: left;
            width: 500px;
        }
"@

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
            <td>Total RAM</td>
            <td>$TotalRAM GB</td>
        </tr>
        <tr>
            <td>Free RAM</td>
            <td>$FreeRAM GB ($RAMPercentFree %)</td>
        </tr>
        <tr>
            <td>Average CPU</td>
            <td>$($oProcessor.Average) %</td>
        </tr>
	</table>

    <img src="data:image/png;base64,$sRamImage" class="system__chart-ram">
"@
