@echo off
%~d0
cd "%~dp0"
powershell -File "%~dp0%~n0.ps1"
