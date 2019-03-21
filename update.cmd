@echo off
%~d0
cd "%~p0"
call ..\..\..\shims\scoop.cmd update
call ..\..\..\shims\scoop.cmd update SystemsReport
