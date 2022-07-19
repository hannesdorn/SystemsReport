Function SystemReport()
{
    $OS = (Get-CimInstance -ClassName Win32_OperatingSystem).caption
    $SystemInfo = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Name, TotalVisibleMemorySize, FreePhysicalMemory
    $TotalRAM = $SystemInfo.TotalVisibleMemorySize/1MB
    $FreeRAM = $SystemInfo.FreePhysicalMemory/1MB
    $UsedRAM = [Math]::Round($TotalRAM - $FreeRAM, 2)
    $RAMPercent = [Math]::Round(($UsedRAM / $TotalRAM) * 100, 2)
    $TotalRAM = [Math]::Round($TotalRAM, 2)
    $FreeRAM = [Math]::Round($FreeRAM, 2)
    $UsedRAM = [Math]::Round($UsedRAM, 2)
    $RAMPercent = [Math]::Round($RAMPercent, 2)
    $Uptime = HostGetUptime($sComputer)

    $oProcessor = Get-CimInstance -ClassName Win32_processor | Measure-Object -property LoadPercentage -Average | Select Average

    # Create the chart using our Chart Function
    #$sRamImage = ChartCreatePie "RAM usage (Used/Free)" "GB" $UsedRAM $FreeRAM
    #<img src="data:image/png;base64,$sRamImage" class="system__chart-ram">
    #<img src="data:image/png;base64,$sCImage" class="system__chart-c">

    # Get free space of C:
    $oVolumeC = Get-CimInstance -ClassName Win32_Volume -Filter "DriveLetter = 'C:'" | Select-object @{n='UsedSpace'; Expression = {"{0:N2}" -f  (($_.Capacity - $_.FreeSpace)/1gb)}}, @{n='Percent'; Expression = {"{0:N2}" -f  ((($_.Capacity - $_.FreeSpace) / $_.Capacity) * 100)}}, @{n='Capacity';e={"{0:n2}" -f ($_.capacity/1gb)}}, @{n='FreeSpace';e={"{0:n2}" -f ($_.freespace/1gb)}}

    # Create the chart using our Chart Function
    #$sCImage = ChartCreatePie "C usage  (Used/Free)" "GB" $oVolumeC.UsedSpace $oVolumeC.FreeSpace

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
                <td>$RAMPercent % ($UsedRAM GB) of $TotalRAM GB used, $FreeRAM GB free</td>
            </tr>
            <tr>
                <td>C</td>
                <td>$($oVolumeC.'Percent') % ($($oVolumeC.UsedSpace) GB) of $($oVolumeC.Capacity) GB used, $($oVolumeC.FreeSpace) GB free</td>
            </tr>
        </table>
"@
}
