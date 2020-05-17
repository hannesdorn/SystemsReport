#
# Systems Report: Mailtest
#
# powershell.exe -File SystemsReport.ps1

[string]$sVersion = "0.1.0"

# Functions
. "functions\sendreport.ps1"

# Default settings
[string]$sMailServer = "host.domain.loc"
[string]$sMailServerPort = "25"
[string]$sMailUsername = ""
[string]$sMailPassword = ""
[bool]$fMailServerSSL = $false
[string]$sMailFrom = "administrator@domain.loc"
[string]$sMailTo = "it@domain.loc"

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
$sContent = "<h2>$sComputer Mailtest $sCurrentTimeString ($sVersion)</h2>"

# Assemble the final report from all our HTML sections
$sHtmlMessage = $sHtmlHeader1 + $sHtmlStyles + $sHtmlHeader2 + $sContent + $sHtmlFooter

#
# Email report
#
SendReport $sMailServer $sMailServerPort $fMailServerSSL $sMailUsername $sMailPassword $sMailFrom $sMailTo "Systems Report Mailtest $sComputer" $sHtmlMessage
