:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: local ASM�ւ�sqlplus
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
  echo +ASMn��sqlplus�ڑ����܂��B
  echo �g�p���@
  echo ^> %NAME% �m�[�h�ԍ� �O���b�h�z�[�� USER/PASS
  echo ��
  echo ^> %NAME% 2 c:\oracle\grid\11.2\gridhome / as sysdba
  echo ^> %NAME% 1 c:\app\18.3.0\grid system/manager
  exit /b 9


