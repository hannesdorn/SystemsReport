#
# Systems Monitor
#
# powershell.exe -File SystemsMonitor.ps1

[string]$sVersion = "0.2.1"

# Functions
. "functions\sendreport.ps1"

# Config
. "functions\config.ps1"
. "config\config.ps1"

# Modules
. "modules\disk.ps1"

# Report template
. "templates\systemsmonitor.ps1"

[string]$sCurrentTimeString = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
[string]$sCurrentTime = Get-Date -Format "yyyy-MM-dd HH-mm-ss"
[String]$sComputer = (Get-Item env:computername).Value

#
# Create the report parts
#
$sContent = "<h2>$sComputer Report $sCurrentTimeString ($sVersion)</h2>"
$sDiskReport = DiskReport($false)
if ($sDiskReport -ne "") {
    $sContent += $sDiskReport

    # Assemble the final report from all our HTML sections
    $sHtmlMessage = $sHtmlHeader1 + $sHtmlStyles + $sHtmlHeader2 + $sContent + $sHtmlFooter

    # Save the report out to a file in the current path
    if (!(Test-Path((Get-Location).Path + "\reports"))) {
        New-Item -ItemType Directory -Path ((Get-Location).Path + "\reports")
    }
    $sHtmlMessage | Out-File ((Get-Location).Path + "\reports\" + $sCurrentTime + " monitor.htm")

    #
    # Email report
    #
    SendReport $sMailServer $sMailServerPort $fMailServerSSL $sMailUsername $sMailPassword $sMailFrom $sMailToMonitor "Systems Monitor $sComputer" $sHtmlMessage

    #
    # Send telegram message
    #
    $sContent = "Systems Monitor $sComputer`r`n$sDiskReport"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $sResponse = Invoke-RestMethod -Uri "https://api.telegram.org/bot$sTelegramToken/sendMessage?chat_id=$sTelegramChatId&text=$sContent"
}
