param($tmp)
###############################################################################
#
# sc.exe queryのSERVICE_NAME出力で、Oracleにヒットするサービスを、
# 止めるバッチファイルを作成する。
#
###############################################################################
$ErrorActionPreference = "Stop" # デフォルトでのErrorAction変更
Set-PSDebug -strict

[String]::Format('@echo off')      | out-file -filepath $tmp -Encoding Default
[String]::Format('echo {0}', $tmp) | out-file -filepath $tmp -Encoding Default -append

sc.exe query                  |
  where-object {
    $_ -match "^SERVICE_NAME:"
  }                           |
  where-object {
    $_ -match "Oracle"
  }                           |
  foreach-object {
    [String]::Format('sc.exe stop "{0}"', ($_ -replace "SERVICE_NAME: ", ""))
    [String]::Format('sc.exe stop "{0}"', ($_ -replace "SERVICE_NAME: ", "")) |
    out-file -filepath $tmp -Encoding Default -append
  }
