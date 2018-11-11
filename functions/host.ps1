Function HostGetUptime($sComputerName)
{
	$oUptime = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $sComputerName
	$oLastBootUpTime = $oUptime.ConvertToDateTime($oUptime.LastBootUpTime)
	$oTime = (Get-Date) - $oLastBootUpTime

    Return '{0:00} Days, {1:00} Hours, {2:00} Minutes, {3:00} Seconds' -f $oTime.Days, $oTime.Hours, $oTime.Minutes, $oTime.Seconds
}
