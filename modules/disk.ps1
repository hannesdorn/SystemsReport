Function DiskspaceIsDiskspaceToLow($oDiskinfo)
{
    foreach($oDiskspace in $aDiskspace) {
        if ($oDiskspace.Drive -ne $oDiskinfo.DeviceID) {
            continue
        }
        if (($oDiskinfo.FreeSpace / $oDiskinfo.Size) * 100 -lt $oDiskspace.FreePercent) {
            return $true
        }
        if ($oDiskinfo.FreeSpace / 1gb -lt $oDiskspace.FreeSpace) {
            return $true
        }

        return $false;
    }

	if (($oDiskinfo.FreeSpace / $oDiskinfo.Size) * 100 -lt $iDiskspace) {
        return $true
    }

	return $false
}

$oDiskinfoReport = @()

$aDiskinfo = Get-CimInstance Win32_LogicalDisk | Where-Object{$_.DriveType -eq 3}

foreach($oDiskinfo in $aDiskinfo) {
    $fReturn = DiskspaceIsDiskspaceToLow($oDiskinfo)
    if ($fReturn -eq $false) {
        continue;
    }

    $oRow = [pscustomobject][ordered]@{
        "Name" = $oDiskinfo.Name
        "Drive&nbsp;Type" = $oDiskinfo.DriveType
        "Volume&nbsp;Name" = $oDiskinfo.VolumeName
        "Size&nbsp;(GB)" = [Math]::Round($oDiskinfo.Size / 1gb, 2)
        "FreeSpace&nbsp;(GB)" = [Math]::Round($oDiskinfo.FreeSpace / 1gb, 2)
        "Percent&nbsp;free" = [Math]::Round($oDiskinfo.FreeSpace / $oDiskinfo.Size * 100, 2)
    }
    $oDiskinfoReport += $oRow
}
$sDiskinfoReport = $oDiskinfoReport | ConvertTo-Html -Fragment

$sContent += @"
	<h3>Disk Info</h3>
	<p>Drive(s) listed below have to low free space. Drives above the threshold will not be listed.</p>
    $sDiskinfoReport
"@
