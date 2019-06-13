:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: Stop.bat
::

@echo off

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
: StopInstance.bat実行
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
call %~dp0StopInstance.bat %COMPUTERNAME% orcl
set RC=%errorlevel%
if %RC% neq 0 goto :err_020

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
: StopCRS.bat実行
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
call %~dp0StopCRS.bat
set RC=%errorlevel%
if %RC% neq 0 goto :err_010

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:done
  echo インスタンス停止成功
  exit /b 0

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:err_010
  echo StopCRS.bat失敗
  exit /b %RC%

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:err_020
  echo StopInstance.bat失敗
  exit /b %RC%
