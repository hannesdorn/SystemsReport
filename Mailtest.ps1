#
# Systems Report: Mailtest
#
# powershell.exe -File SystemsReport.ps1

[string]$sVersion = "0.1.2"

# Functions
. "functions\sendreport.ps1"

# Config
. "functions\config.ps1"
. "config\config.ps1"

# Report template
. "templates\mailtest.ps1"

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
