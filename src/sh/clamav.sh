#!/bin/sh
###############################################################################
# freshclam後、clamscanをniceで行う。
# $Header$
###############################################################################
NAME="clamav.sh" # atコマンドでは、basename $0は、shとなってしまう。
SUBJECT="`hostname`:`uname -s`:${NAME:?}:`date '+%Y%m%d.%H%M%S'`"
MAILTO="tatsuo-i@mtb.biglobe.ne.jp"
LASTRUN=/var/log/${NAME:?}.last.at.`date '+%Y%m%d'`
LOG=/var/log/${NAME:?}.log

###############################################################################
mail2(){
  TEXT=$1
  SUBJECT="${SUBJECT:?}-`date '+%Y%m%d.%H%M%S'`:${TEXT:?}"
  sed -n "/SCAN SUMMARY/,\$p" ${LOG:?}|
    mail -s "${SUBJECT}" ${MAILTO:?}
}

###############################################################################
[ -f ${LASTRUN:?} ] && exit 0

###############################################################################
RC=0
date > ${LOG:?}

###############################################################################
CMD="freshclam"
${CMD:?} >> ${LOG:?} 2>&1
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "${CMD:?} fail. RC:${RC:?}" 1>&2
  mail2 "${CMD:?}:${RC:?}"
  exit ${RC:?}
fi

###############################################################################
CMD="clamscan"
nice ${CMD:?} --exclude-dir=/sys/ --infected --remove --recursive / >> ${LOG:?} 2>&1
RC=$?

if [ "${RC:?}" -ne "0" ]; then
  echo "${CMD:?} fail. RC:${RC:?}" 1>&2
  mail2 "${CMD:?}:${RC:?}"
  exit ${RC:?}
fi

###############################################################################
mail2 "done"
rm -f /var/log/${NAME:?}.last.at.* && touch ${LASTRUN:?}
exit ${RC:?}


