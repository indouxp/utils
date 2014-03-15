#!/bin/sh
# EXPLANATION:標準入力、または引数のファイルを読み込み、改行を省き、空白を%20に置き換え、bookmarkletとなる一行を出力する。
#
if [ "$#" -eq 0 ]; then
  tr -d "\n" | sed "s/ /%20/g"
else
  cat $* | tr -d "\n" | sed "s/ /%20/g"
fi
echo ""
