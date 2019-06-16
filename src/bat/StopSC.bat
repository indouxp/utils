:@echo off
set TMPBAT=StopSC_tmp.bat

:call .\run-ps.bat StopSC.ps1 %TMPBAT%
call .\run-ps.bat StopSC.ps1 StopSC_tmp.bat
set RC=%errorlevel%
echo %RC%

:call .\%TMPBAT%
call .\StopSC_tmp.bat
set RC=%errorlevel%
echo %RC%
