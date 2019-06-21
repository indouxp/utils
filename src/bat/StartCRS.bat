:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: StartCRS.bat
::

@echo off
set WAIT_SEC=10

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start_crsctl_status_resource
  crsctl status resource -t | findstr -i CRS-4535
  :                                      CRS-4535: Cluster Ready Servicesと通信できません
  if %errorlevel% neq 0 goto :err_010

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start_crs
  crsctl start crs
  if %errorlevel% neq 0 goto :err_020

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start_crsctl_status_loop

  crsctl status resource -t | findstr -i CRS-4535
  :                                      CRS-4535: Cluster Ready Servicesと通信できません
  if %errorlevel% equ 0 (
    echo %WAIT_SEC% waiting..
    timeout %WAIT_SEC% > nul
    goto :start_crsctl_status_loop
  )

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:done
  echo クラスタ起動成功
  exit /b 0

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:err_010
  echo クラスタウェア起動済み
  exit /b 8

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:err_020
  echo クラスタウェア起動エラー
  exit /b 12
