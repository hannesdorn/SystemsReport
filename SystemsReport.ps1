#
# Systems Report
#
# powershell.exe -File SystemsReport.ps1

[string]$sVersion = "0.4.2"

# Functions
. "functions\host.ps1"
. "functions\sendreport.ps1"

# List disk
# 20 %/10 GB: if free space is lower than 20 % or is lower then 10 GB
# 0 %/10 GB: if free space is lower then 10 GB
# 20 %/0 GB: if free space is lower then 20 %
# 100 %/10 GB: disk is always listed
class Diskspace {
    [string]$Drive      # C:
    [int]$FreePercent   # 20 -> 20 %
    [float]$FreeSpace   # 10 -> 10 GB
}

class Eventfilter {
    [string]$Level      # 1 = Critical, 2 = Error, 3 = Warning,
    [string]$ProviderName
    [int]$Id
}

# Default settings
[string]$sMailServer = "host.domain.loc"
[string]$sMailServerPort = "25"
[string]$sMailUsername = ""
[string]$sMailPassword = ""
[bool]$fMailServerSSL = $false
[string]$sMailFrom = "administrator@domain.loc"
[string]$sMailTo = "it@domain.loc"
[int]$iDiskspace = 20
[array]$aDiskspace = @()
[int]$iProccesses = 10
[int]$iSystemEventLastHours = 25
[array]$aSystemEventEventfilter = @()
[int]$iApplicationEventLastHours = 25
[array]$aApplicationEventEventfilter = @()

# Config
. ".\config\config.ps1"

# Report template
. "templates\html.ps1"

[string]$sCurrentTimeString = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
[string]$sCurrentTime = Get-Date -Format "yyyy-MM-dd HH-mm-ss"
[String]$sComputer = (Get-Item env:computername).Value

#
# Create the report parts
#
$sContent = "<h2>$sComputer Report $sCurrentTimeString ($sVersion)</h2>"
. "modules\system.ps1"
. "modules\disk.ps1"
. "modules\windowsupdate.ps1"
. "modules\systemevents.ps1"
. "modules\applicationevents.ps1"
. "modules\service.ps1"
. "modules\process.ps1"

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
