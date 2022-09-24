#
# Systems Report
#
# powershell.exe -File SystemsReport.ps1

[string]$sVersion = "0.6.4"

# Functions
. "functions\host.ps1"
. "functions\sendreport.ps1"

# Config
. "functions\config.ps1"
. "config\config.ps1"

# Modules
. "modules\system.ps1"
. "modules\disk.ps1"
. "modules\windowsupdate.ps1"
. "modules\systemevents.ps1"
. "modules\applicationevents.ps1"
. "modules\service.ps1"
. "modules\process.ps1"

# Report template
. "templates\systemsreport.ps1"

[string]$sCurrentTimeString = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
[string]$sCurrentTime = Get-Date -Format "yyyy-MM-dd HH-mm-ss"
[String]$sComputer = (Get-Item env:computername).Value

#
# Create the report parts
#
$sContent = "<h2>$sComputer Report $sCurrentTimeString ($sVersion)</h2>"
$sContent += SystemReport
$sContent += DiskReport($true)
$sContent += WindowsUpdateReport
$sContent += SystemEventsReport
$sContent += ApplicationEventsReport
$sContent += ServiceReport
$sContent += ProcessReport

# Assemble the final report from all our HTML sections
$sHtmlMessage = $sHtmlHeader1 + $sHtmlStyles + $sHtmlHeader2 + $sContent + $sHtmlFooter

# Save the report out to a file in the current path
if (!(Test-Path((Get-Location).Path + "\reports"))) {
    New-Item -ItemType Directory -Path ((Get-Location).Path + "\reports")
}
$sHtmlMessage | Out-File ((Get-Location).Path + "\reports\" + $sCurrentTime + " Report.htm")

#
# Email report
#
SendReport $sMailServer $sMailServerPort $fMailServerSSL $sMailUsername $sMailPassword $sMailFrom $sMailTo "Systems Report $sComputer" $sHtmlMessage
