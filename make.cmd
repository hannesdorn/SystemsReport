@echo off
if "%~1" == "" echo "%~nx0 Version, z.B. 0.3.0" & goto :eof
set filename=releases\SystemsReport-v%1.zip

if exist %filename% del %filename%
zip.exe %filename% Mailtest.cmd Mailtest.ps1 SystemsMonitor.cmd SystemsMonitor.ps1  SystemsReport.cmd SystemsReport.ps1 config\config-sample.ps1 functions\* modules\* templates\* version.txt
CertUtil -hashfile %filename% sha256 | find /V "SHA256-Hash" | find /V "CertUtil" > %filename%.sha256
