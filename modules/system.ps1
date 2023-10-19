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

    $sDisks = ""
    $aDiskinfo = Get-CimInstance Win32_LogicalDisk | Where-Object{$_.DriveType -eq 3}
    foreach($oDiskinfo in $aDiskinfo) {
        $sDisks = $sDisks + @"
        <tr>
            <td>$($oDiskinfo.Name)</td>
            <td>$([Math]::Round(($oDiskinfo.Size - $oDiskinfo.FreeSpace) / $oDiskinfo.Size * 100, 2)) % ($([Math]::Round(($oDiskinfo.Size - $oDiskinfo.FreeSpace) / 1gb, 2)) GB) of $([Math]::Round($oDiskinfo.Size / 1gb, 2)) GB used, $([Math]::Round($oDiskinfo.FreeSpace / 1gb), 2) GB free</td>
        </tr>
"@
    }

    # Create the chart using our Chart Function
    #$sCImage = ChartCreatePie "C usage  (Used/Free)" "GB" $oVolumeC.UsedSpace $oVolumeC.FreeSpace

    return @"
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
            $($sDisks)
        </table>
"@
}
