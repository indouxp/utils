@echo off
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: �J�����g����̑��΃p�X��powrshell�����s
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
setlocal
set NAME=%~n0
set FOLDER=%~dp0
set PS="%*"

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: �J�n
echo %DATE% %TIME% %NAME%: START

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ���s
set PSExecutionPolicyPreference=remoteSigned
powershell "%FOLDER%\%PS%; exit $lastexitcode"
set RC=%errorlevel%
if %RC% neq 0 (
  echo %DATE% %TIME% %NAME%: %PS1SCRIPT% ���s RC=%RC%
  goto :ERROR
)
echo %DATE% %TIME% %NAME%: %PS1SCRIPT% ����

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ����I��
:DONE
  echo %DATE% %TIME% %NAME%: DONE
  exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: �ُ�I��
:ERROR
  echo %DATE% %TIME% %NAME%: ABEND
  exit /b %RC%
