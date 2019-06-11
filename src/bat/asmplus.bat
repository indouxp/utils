:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: local ASMへのsqlplus
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off
set NAME=%~n0%~x0
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if "%*"=="" goto :ERROR_010

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set NODENO=%1
shift
set ORACLE_HOME=%1
shift
set USERPASS=%1
shift
set USERPASS=%USERPASS% %1
shift
set USERPASS=%USERPASS% %1

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
set ORACLE_SID=+ASM%NODENO%
set CMD=%ORACLE_HOME%\bin\sqlplus %USERPASS%
echo ORACLE_SID=%ORACLE_SID%
echo ORACLE_HOME=%ORACLE_HOME%
echo %CMD%
%CMD%
set RC=%errorlevel%

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:SUCCESS
  exit /b %RC%

:ERROR_010
  echo +ASMnにsqlplus接続します。
  echo 使用方法
  echo ^> %NAME% ノード番号 グリッドホーム USER/PASS
  echo 例
  echo ^> %NAME% 2 c:\oracle\grid\11.2\gridhome / as sysdba
  echo ^> %NAME% 1 c:\app\18.3.0\grid system/manager
  exit /b 9


