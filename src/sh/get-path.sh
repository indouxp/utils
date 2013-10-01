#!/bin/bash
###############################################################################
# PATHの:を改行に変更し出力
# ~を展開しない不具合あり
###############################################################################

BKIFS=${IFS}
RC=0
term() {
  IFS=${BKIFS:?}
}
trap 'term' 0

#for chk in PATH LD_LIBRARY_PATH
for chk in PATH
do
  eval paths=\$$chk                 #chkの中身の変数名の中身をpathsに代入する
  IFS=":"
  for path in $paths
  do
    [ -d ${path} ] && echo "${path}"
    [ ! -d ${path} ] && echo "NG:${path}" && RC=1
  done
  IFS=${BKIFS:?}
done
exit ${RC}

