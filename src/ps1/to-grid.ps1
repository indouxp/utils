#
# dir /s /a-d | findstr /L ""�f�B���N�g�� �t�@�C��"" > FILE
# FILE�������Ƃ��ăT�C�Y�ŏ����ɕ��ёւ��āA�O���b�h�\������B
#
get-content -encoding string $in_path |
foreach-object `
  -begin {
    $prev = """"
    $last = $false
  }`
  -process {
    if ($_ -match '�t�@�C���̑���:') {  # ����ڍs�̓X�L�b�v
      $last = $true
    }
    if ($last -eq $false) {
      if ($_ -match '�o�C�g$') {
        $arr = $_ -split ""\s+""
        $size = [Int64]($arr[3] -replace ',', """")
        $outrec = New-Object PSObject |
            Add-Member noteproperty ""�T�C�Y"" $size   -pass |
            Add-Member noteproperty ""�p�X""   $prev   -pass
        $outrec
      }
      $prev = $_ -replace ""�̃f�B���N�g��"", """"
    }
  } | sort-object ""�T�C�Y"" | out-gridview
