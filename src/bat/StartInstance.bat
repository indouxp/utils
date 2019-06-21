:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: StartInstance.bat
::

@echo off
set WAIT_SEC=10
set NODE=%~1
set DATABASE=%~2

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start_crsctl_status_resource_asm
  crsctl status resource ora.asm | findstr -i STATE | findstr -i ONLINE | findstr -i %NODE%
  if %errorlevel% neq 0 (
    echo %WAIT_SEC% waiting..
    timeout %WAIT_SEC% > nul
    goto :start_crsctl_status_resource_asm
  )

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start_srvctl_status_instance
  call srvctl status instance -d %DATABASE% -n %NODE% | findstr -i ���s��
  if %errorlevel% equ 0 goto :err_010

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start_srvctl_start_instance
  call srvctl start instance -d %DATABASE% -n %NODE%
  if %errorlevel% neq 0 goto :err_020

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:done
  echo �C���X�^���X�N������
  exit /b 0

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:err_010
  echo %NODE%���%INSTANCE%�͋N���ς�
  exit /b 8

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:err_020
  echo %NODE%���%INSTANCE%�N���G���[
  exit /b 12
