Function WindowsUpdateReport()
{
    $oWindowsUpdate = @()

    $oService = Get-Service -Name "wuauserv"

    $sWUStartMode = $oService.StartType
    $sWUStatus = $oService.Status

    try {
        if (Test-Connection -ComputerName $sComputer -Count 1 -Quiet) {
            # check if the computer is the same where this script is running
            if ($sComputer -eq (Get-Item env:computername).Value) {
                $oUpdateSession = New-Object -ComObject Microsoft.Update.Session
            } else {
                $oUpdateSession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session", $sComputer))
            }
            $oUpdateSearcher = $oUpdateSession.CreateUpdateSearcher()
            $oSearchResult = $oUpdateSearcher.Search("IsAssigned=1 and IsHidden=0 and IsInstalled=0")
            $oCritical = $oSearchResult.updates | where { $_.MsrcSeverity -eq "Critical" }
            $oImportant = $oSearchResult.updates | where { $_.MsrcSeverity -eq "Important" }
            $oOther = $oSearchResult.updates | where { $_.MsrcSeverity -eq $null }

            # Get windows updates counters
            $iTotalUpdates = $($oSearchResult.updates.count)
            $iTotalCriticalUp = $($oCritical.count)
            $iTotalImportantUp = $($oImportant.count)

            if ($iTotalUpdates -gt 0) {
                $fUpdatesToInstall = $true
            } else {
                $fUpdatesToInstall = $false
            }
        } else {
            # if cannot connected to the server the updates are listed as not defined
            $iTotalUpdates = "undefined"
            $iTotalCriticalUp = "undefined"
            $iTotalImportantUp = "undefined"
        }
    } catch {
        # if an error occurs the updates are listed as not defined
        Write-Warning "$sComputer`: $_"
        $iTotalUpdates = "error"
        $iTotalCriticalUp = "error"
        $iTotalImportantUp = "error"
        $fUpdatesToInstall = $false
    }

    # Making registry connection to the local/remote computer
    $oRegCon = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]"LocalMachine", $sComputer)

    $oRegSubKeysCBS = $oRegCon.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\").GetSubKeyNames()
    $fCBSRebootPend = $oRegSubKeysCBS -contains "RebootPending"

    # Query WUAU from the registry
    $oRegWUAU = $oRegCon.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\")
    $oRegSubKeysWUAU = $oRegWUAU.GetSubKeyNames()
    $fWUAURebootReq = $oRegSubKeysWUAU -contains "RebootRequired"

    If ($fCBSRebootPend -or $fWUAURebootReq) {
        $fMachineNeedsRestart = $true
    } else {
        $fMachineNeedsRestart = $false
    }

    # Closing registry connection
    $oRegCon.Close()

    $oRow = [pscustomobject][ordered]@{
        "Windows Update Service" = $sWUStartMode
        "Windows Update Status" = $sWUStatus
        "Updates to install" = $fUpdatesToInstall
        "Total of updates" = $iTotalUpdates
        "Total of critical updates" = $iTotalCriticalUp
        "Total of important updates" = $iTotalImportantUp
        "Reboot pending" = $fMachineNeedsRestart
    }
    $oWindowsUpdate += $oRow
    $sWindowsUpdate = $oWindowsUpdate | ConvertTo-Html -Fragment

    # Create HTML report for the current system
    return @"
        <h3>Windows Update</h3>
        <p>The system $sComputer has Windows Updates ready to be installed, Windows Updates configured to be checked manually or it required a reboot.</p>
        $sWindowsUpdate
"@
}
