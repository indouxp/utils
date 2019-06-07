#
# dir /s /a-d | findstr /L ""ディレクトリ ファイル"" > FILE
# FILEを引数としてサイズで昇順に並び替えて、グリッド表示する。
#
get-content -encoding string $in_path |
foreach-object `
  -begin {
    $prev = """"
    $last = $false
  }`
  -process {
    if ($_ -match 'ファイルの総数:') {  # これ移行はスキップ
      $last = $true
    }
    if ($last -eq $false) {
      if ($_ -match 'バイト$') {
        $arr = $_ -split ""\s+""
        $size = [Int64]($arr[3] -replace ',', """")
        $outrec = New-Object PSObject |
            Add-Member noteproperty ""サイズ"" $size   -pass |
            Add-Member noteproperty ""パス""   $prev   -pass
        $outrec
      }
      $prev = $_ -replace ""のディレクトリ"", """"
    }
  } | sort-object ""サイズ"" | out-gridview
