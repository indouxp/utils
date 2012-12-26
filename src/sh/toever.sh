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
  SUBJECT="${SUBJECT:?}"
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
  for file in $*
  do
    mail2 ${file:?}
  done
fi

exit ${RC:?}
