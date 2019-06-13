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
  call srvctl status instance -d %DATABASE% -n %NODE% | findstr -i 実行中
  if %errorlevel% neq 0 goto :err_010

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start_srvctl_start_instance
  call srvctl stop instance -d %DATABASE% -n %NODE%
  if %errorlevel% neq 0 goto :err_020

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:done
  echo %NODE%上の%DATABASE%は停止成功
  exit /b 0

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:err_010
  echo %NODE%上の%DATABASE%は停止済み
  exit /b 8

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:err_020
  echo %NODE%上の%DATABASE%停止エラー
  exit /b 12
