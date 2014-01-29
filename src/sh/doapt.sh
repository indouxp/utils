#!/bin/sh
###############################################################################
# apt-get update後、apt-get upgradeをniceで行う。
# $revision:$
###############################################################################
NAME="doapt.sh"  # atで実行すると、basename $0は、shになるため
export LANG="ja_JP.UTF-8"
export PATH=${PATH:?}:/sbin
SUBJECT="`hostname`:`uname -s`:${NAME:?}:`date '+%Y%m%d.%H%M%S'`"
MAILTO="tatsuo-i@mtb.biglobe.ne.jp"
LASTRUN=/var/log/${NAME:?}.last.at.`date '+%Y%m%d'`
LOG=/var/log/${NAME:?}.log
EXTERNAL_SERVER="www.google.co.jp"

###############################################################################
mail2(){
  TEXT=$1
  SUBJECT="${SUBJECT:?}-`date '+%Y%m%d.%H%M%S'`:${TEXT:?}"
  grep "アップグレード" ${LOG:?} |
    mail -s "${SUBJECT}" ${MAILTO:?}
}

###############################################################################
[ -f ${LASTRUN:?} ] && exit 0

###############################################################################
echo "${NAME:?}:`date`:start." > ${LOG:?}
until ping -c1 ${EXTERNAL_SERVER:?}
do
  sleep 5
  echo "${NAME:?}:`date`:sleeping." >> ${LOG:?}
done

###############################################################################
RC=0

###############################################################################
CMD="apt-get update"
nice ${CMD:?} >> ${LOG:?} 2>&1
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "${CMD:?} fail. RC:${RC:?}" 1>&2
  mail2 "${CMD:?}:${RC:?}"
  exit ${RC:?}
fi

###############################################################################
CMD="apt-get upgrade -y"
nice ${CMD:?} >> ${LOG:?} 2>&1
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
