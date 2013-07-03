#!/bin/sh
BKIFS=${IFS}
term() {
  IFS=${BKIFS:?}
}
trap 'term' 0

for chk in PATH LD_LIBRARY_PATH
do
  eval paths=\$$chk                 #chkの中身の変数名の中身をpathsに代入する
  IFS=":"
  for path in $paths
  do
    [ ! -d ${path} ] && echo "ng:${path}"
  done
  IFS=${BKIFS:?}
done
exit 0

