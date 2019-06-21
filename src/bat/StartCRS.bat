:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: StartCRS.bat
::

@echo off
set WAIT_SEC=10

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start_crsctl_status_resource
  crsctl status resource -t | findstr -i CRS-4535
  :                                      CRS-4535: Cluster Ready Services�ƒʐM�ł��܂���
  if %errorlevel% neq 0 goto :err_010

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start_crs
  crsctl start crs
  if %errorlevel% neq 0 goto :err_020

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start_crsctl_status_loop

  crsctl status resource -t | findstr -i CRS-4535
  :                                      CRS-4535: Cluster Ready Services�ƒʐM�ł��܂���
  if %errorlevel% equ 0 (
    echo %WAIT_SEC% waiting..
    timeout %WAIT_SEC% > nul
    goto :start_crsctl_status_loop
  )

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:done
  echo �N���X�^�N������
  exit /b 0

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:err_010
  echo �N���X�^�E�F�A�N���ς�
  exit /b 8

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:err_020
  echo �N���X�^�E�F�A�N���G���[
  exit /b 12
