#!/bin/sh
###############################################################################
# evernoteに、メール登録する。
# $revision:$
###############################################################################
NAME=`basename $0`
TMPFILE=/tmp/${NAME:?}.tmp.$$
SUBJECT="`hostname`:`uname -o`:`basename $0`:`date '+%Y%m%d.%H%M%S'`"
MAILTO="indouxp.1beb9@m.evernote.com"

term(){
  rm -f /tmp/`basename $0`.tmp.$$
}

trap 'term' 0 1 2 3 15

mail2(){
  BODY=$1
	# nkf
	# -j  JIS コードを出力する。(デフォルト)
	# -M  ヘッダ形式に変換する
	# -W  UTF-8 を仮定する
  SUBJECT=`echo "${SUBJECT:?}:$2" | nkf -W -M -j`
  cat ${BODY:?} | mail -s "${SUBJECT:?}" ${MAILTO:?}
  return $?
}

RC=0

if [ "$#" -eq "0" ]; then
  while read line
  do
    echo ${line:?}
  done > ${TMPFILE:?} 
  mail2 ${TMPFILE:?}
else
	#SUBJECT=""
  for file in $*
  do
		SUBJECT="${SUBJECT}${file:?} "
		echo ${file:?}
		ls -l ${file:?}
		expand -t2 ${file:?}
  done > ${TMPFILE:?}
  mail2 ${TMPFILE:?} ${SUBJECT:?}
fi

exit ${RC:?}
