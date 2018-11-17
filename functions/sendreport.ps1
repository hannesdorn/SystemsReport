Function SendReport([string]$sMailServer, [string]$sMailServerPort, [bool]$fMailServerSSL, [string]$sMailUsername, [string]$sMailPassword, [string]$sMailFrom, [string]$sMailTo, [string]$sSubject, [string]$sMessage)
{
    $oSmtpClient = New-Object Net.Mail.SmtpClient($sMailServer, $sMailServerPort)
    $oSmtpClient.EnableSsl = $fMailServerSSL
    $oSmtpClient.Credentials = New-Object System.Net.NetworkCredential($sMailUsername, $sMailPassword);

    $oMailMessage = New-Object Net.Mail.MailMessage
    $oMailMessage.From = $sMailFrom
    $oMailMessage.ReplyTo = $sMailFrom
    foreach($sTo in $sMailTo) {
        $oMailMessage.To.Add($sTo)
    }
    $oMailMessage.Subject = $sSubject
    $oMailMessage.IsBodyHtml = $true
    $oMailMessage.Body = $sMessage

    $oSmtpClient.Send($oMailMessage)
}
