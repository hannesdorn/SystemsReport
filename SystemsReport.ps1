#
# Systems Report
#
# powershell.exe -File SystemsReport.ps1

# functions
. "functions\chart.ps1"
. "functions\host.ps1"

# config
. ".\config.ps1"

# report template
. "templates\html.ps1"

$sCurrentTime = Get-Date -Format yyyy.MM.dd
[String]$sComputer = (Get-Item env:computername).Value

#
# Create the report parts
#
$sContent = "<h2>$sComputer Report</h2>"
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
    $x = New-Item -ItemType Directory -Path ((Get-Location).Path + "\reports")
}

$sHtmlMessage | Out-File ((Get-Location).Path + "\reports\" + $sCurrentTime + " Report.htm")

#
# Email report
#

$oSmtpClient = New-Object Net.Mail.SmtpClient($sMailServer)
$oSmtpClient.Credentials = New-Object System.Net.NetworkCredential($sMailUsername, $sMailPassword);

$oMailMessage = New-Object Net.Mail.MailMessage
$oMailMessage.From = $sMailFrom
$oMailMessage.ReplyTo = $sMailFrom
foreach($sTo in $sMailTo) {
    $oMailMessage.To.Add($sTo)
}
$oMailMessage.Subject = "Systems Report $sComputer"
$oMailMessage.IsBodyHtml = $true
$oMailMessage.Body = $sHtmlMessage

$oSmtpClient.Send($oMailMessage)
