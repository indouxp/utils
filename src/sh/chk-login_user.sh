#!/bin/sh
###############################################################################
#
# sudo もしくは、rootで実行する
# lastコマンドを実行し、indou以外のログインがある場合は、shutdown -h する。
#
###############################################################################
NAME=${0##*/}
TMP=/tmp/${NAME:?}.tmp
LOG=/home/indou/${NAME:?}.log
DF='+%Y/%m/%d %H:%M:%S'

#
# 最終ログイン履歴からindou以外を抽出
#
last | grep -v indou | grep -v "wtmp" > ${TMP:?}
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "${NAME:?}:ERROR 010" 1>&2
  exit ${RC:?}
fi
echo "${NAME:?}: $(date $DF) last, grep OK" > ${LOG:?}

#
# ログイン履歴数カウント
#
NUM=$(awk '{if(NF>0){print;}}' ${TMP:?} | wc -l)
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "${NAME:?}:ERROR 020" 1>&2
  exit ${RC:?}
fi
echo "${NAME:?}: $(date $DF) awk, wc OK" > ${LOG:?}

#
# ログイン履歴がある場合は、エラー
#
if [ "${NUM:?}" -ne "0" ]; then
  echo "${NAME:?}:ERROR 030" 1>&2
  mv ${TMP:?} /home/indou
  if [ ! -e /tmp/${NAME:?}.stop ]; then
    logger "${NAME:?} shutdown at `date '+%Y/%m/%d %H:%M:%S'`"
    shutdown -h now
  fi
  exit ${NUM:?}
fi
echo "${NAME:?}: $(date $DF) others no login" > ${LOG:?}

#
# 正常終了
#
exit 0
