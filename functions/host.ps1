Function HostGetUptime($sComputerName)
{
	$oUptime = Get-CimInstance -ClassName Win32_OperatingSystem | Select LastBootUpTime
	# $oLastBootUpTime = $oUptime.ConvertToDateTime($oUptime.LastBootUpTime)
	$oTime = (Get-Date) - $oUptime.LastBootUpTime

    Return '{0:00} Days, {1:00} Hours, {2:00} Minutes, {3:00} Seconds' -f $oTime.Days, $oTime.Hours, $oTime.Minutes, $oTime.Seconds
}
