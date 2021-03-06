:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: StopCRS.bat
::

@echo off
set WAIT_SEC=10

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start_crsctl_status_resource
  crsctl status resource | findstr -i CRS-4535
  :                                   CRS-4535: Cluster Ready Servicesと通信できません
  if %errorlevel% equ 0 goto :err_010

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start_crsctl_stop_crs
  crsctl stop crs
  if %errorlevel% neq 0 goto :err_020

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:done
  echo クラスタ停止成功
  exit /b 0

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:err_010
  echo クラスタウェア停止済み
  exit /b 8

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:err_020
  echo クラスタウェア停止エラー
  exit /b 12
