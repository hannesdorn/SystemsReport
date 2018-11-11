#
# Systems Report
#
# powershell.exe -File SystemsReport.ps1

# functions
. functions\chart.ps1
. functions\host.ps1

# config
. config\config.ps1

# report template
. template\html.ps1

$sCurrentTime = Get-Date -Format yyyy.MM.dd
[String]$sComputer = (Get-Item env:computername).Value

#
# Create the report parts
#
$sContent = "<h2>$sComputer Report</h2>"
. "modules\system.ps1"
. "modules\disk.ps1"
. "modules\windowsupdate.ps1"
. "modules\process.ps1"
. "modules\service.ps1"
. "modules\systemevents.ps1"
. "modules\applicationevents.ps1"

# Assemble the final report from all our HTML sections
$sHtmlMessage = $sHtmlHeader1 + $sHtmlStyles + $sHtmlHeader2 + $sContent + $sHtmlFooter

# Save the report out to a file in the current path
$sHtmlMessage | Out-File ((Get-Location).Path + "\reports\" + $sCurrentTime + " Report.htm")

#
# Email report
#

$oSmtpClient = new-object Net.Mail.SmtpClient($sMailServer)

$oMailMessage = new-object Net.Mail.MailMessage
$oMailMessage.From = $sMailFrom
$oMailMessage.ReplyTo = $sMailFrom
foreach($sTo in $sMailTo) {
    $oMailMessage.To.Add($sTo)
}
$oMailMessage.subject = "Systems Report $sComputer"
$oMailMessage.IsBodyHtml = $true
$oMailMessage.Body = $sHtmlMessage

$oSmtpClient.Send($oMailMessage)
