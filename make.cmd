@echo off
if exist SystemsReport.zip del SystemsReport.zip
zip.exe SystemsReport.zip SystemsReport.cmd SystemsReport.ps1 config\config-sample.ps1 functions\* modules\* reports\.emptydir templates\* MSChart.exe version.txt
