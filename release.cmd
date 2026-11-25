@echo off
setlocal

set "TAG=%~1"
set "NOTES=%~2"

if "%TAG%"=="" (
    echo Fehler: Kein Tag angegeben
    echo %~n0 vX.x.x "Notes"
    exit /b 1
)
if "%NOTES%"=="" (
    echo Fehler: Keine Notes angegeben
    echo %~n0 vX.x.x "Notes"
    exit /b 1
)

set filename=releases\SystemsReport-%TAG%.zip

if exist %filename% del %filename%
7z.exe a %filename% Mailtest.cmd Mailtest.ps1 SystemsMonitor.cmd SystemsMonitor.ps1  SystemsReport.cmd SystemsReport.ps1 config\config-sample.ps1 functions\* modules\* templates\* version.txt
CertUtil -hashfile %filename% sha256 | find /V "SHA256-Hash" | find /V "CertUtil" > %filename%.sha256

set "TITLE=Release %TAG%"
set "FILE1=releases\SystemsReport-%TAG%.zip"
set "FILE2=releases\SystemsReport-%TAG%.zip.sha256"

:: 1. Lokalen Tag erstellen und zu GitHub pushen
git tag "%TAG%"
if errorlevel 1 (
    echo Fehler beim Erstellen des lokalen Tags.
    exit /b 1
)

git push origin "%TAG%"
if errorlevel 1 (
    echo Fehler beim Pushen des Tags zu GitHub.
    exit /b 1
)

:: 2. Release erstellen und beide Dateien direkt hochladen
gh release create "%TAG%" "%FILE1%" "%FILE2%" --title "%TITLE%" --notes "%NOTES%"
if errorlevel 1 (
    echo Fehler beim Erstellen des Releases oder Hochladen der Dateien.
    exit /b 1
)

echo Fertig! Tag %TAG% und Release inklusive Dateien wurden erstellt.
endlocal
