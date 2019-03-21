@echo off
if exist SystemsReport.zip del SystemsReport.zip
zip.exe SystemsReport.zip SystemsReport.cmd SystemsReport.ps1 config-sample.ps1 functions\* modules\* templates\* version.txt
