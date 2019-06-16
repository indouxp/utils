@echo off
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: カレントからの相対パスでpowrshellを実行
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
setlocal
set NAME=%~n0
set FOLDER=%~dp0
set PS="%*"

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: 開始
echo %DATE% %TIME% %NAME%: START

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: 実行
set PSExecutionPolicyPreference=remoteSigned
powershell "%FOLDER%\%PS%; exit $lastexitcode"
set RC=%errorlevel%
if %RC% neq 0 (
  echo %DATE% %TIME% %NAME%: %PS1SCRIPT% 失敗 RC=%RC%
  goto :ERROR
)
echo %DATE% %TIME% %NAME%: %PS1SCRIPT% 完了

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: 正常終了
:DONE
  echo %DATE% %TIME% %NAME%: DONE
  exit /b 0

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: 異常終了
:ERROR
  echo %DATE% %TIME% %NAME%: ABEND
  exit /b %RC%
