$sDiskInfo = Get-WMIObject -ComputerName $sComputer Win32_LogicalDisk | Where-Object{$_.DriveType -eq 3} | Where-Object{ ($_.freespace/$_.Size)*100 -lt $iDiskspace} `
| Select-Object Name, DriveType, VolumeName, @{n='Size (GB)';e={"{0:n2}" -f ($_.size/1gb)}}, @{n='FreeSpace (GB)';e={"{0:n2}" -f ($_.freespace/1gb)}}, @{n='PercentFree';e={"{0:n2}" -f ($_.freespace/$_.size*100)}} | ConvertTo-HTML -fragment

$sContent += @"
	<h3>Disk Info</h3>
	<p>Drive(s) listed below have less than $iDiskspace % free space. Drives above this threshold will not be listed.</p>
    $sDiskInfo
"@
