:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: StopInstance.bat
::

@echo off
set WAIT_SEC=10
set NODE=%~1
set DATABASE=%~2

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start_srvctl_status_instance
  call srvctl status instance -d %DATABASE% -n %NODE% | findstr -i é¿çsíÜ
  if %errorlevel% neq 0 goto :err_010

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start_srvctl_start_instance
  call srvctl stop instance -d %DATABASE% -n %NODE%
  if %errorlevel% neq 0 goto :err_020

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start_srvctl_status_instance_last
  call srvctl status instance -d %DATABASE% -n %NODE% | findstr -i é¿çsíÜ
  if %errorlevel% neq 0 goto :exit_srvctl_status_instance_last
  timeout 10
  goto :start_srvctl_status_instance_last
:exit_srvctl_status_instance_last
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:done
  echo %NODE%è„ÇÃ%DATABASE%ÇÕí‚é~ê¨å˜
  exit /b 0

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:err_010
  echo %NODE%è„ÇÃ%DATABASE%ÇÕí‚é~çœÇ›
  exit /b 8

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:err_020
  echo %NODE%è„ÇÃ%DATABASE%í‚é~ÉGÉâÅ[
  exit /b 12
