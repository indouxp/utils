#!/bin/sh
# 第一引数で与えられたファイルの各行のバイト数をカウント
# 第二引数が与えられた場合はその行のみ
#
if [ "$#" -lt "1" ]; then
  cat <<EOT 1>&2
  \$ `basename $0` FILE no
EOT
  exit 1
fi

TARGET=$1
if [ "2" -le "$#" ]; then
  ROW=$2  # でも仕掛
fi

ROWS=`wc -l ${TARGET:?} | cut -f1 -d" "`

for i in `awk -vrows=${ROWS:?} 'BEGIN{for(i = 1; i <= rows; i++) {print i;}}'`
do
	awk -vno=${i:?} 'BEGIN{printf("%3d:", no);}'
	echo "`head -n${i:?} ${TARGET:?} | tail -n1 | wc -c`:`head -n${i:?} ${TARGET:?} | tail -n1`"
done
exit 0
