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
EXTERNAL_SERVER="www.google.co.jp"

###############################################################################
mail2(){
  TEXT=$1
  SUBJECT="${SUBJECT:?}-`date '+%Y%m%d.%H%M%S'`:${TEXT:?}"
  su - indou -c "sed -n '/SCAN SUMMARY/,\$p' ${LOG:?} |\
                  mail -s \"${SUBJECT}\" ${MAILTO:?}"
}

###############################################################################
# 前回の処理が今日の場合は終了。又、前回の処理成功ファイルを削除。
[ -f ${LASTRUN:?} ] && exit 0
rm -f /var/log/${NAME:?}.last.at.*

###############################################################################
# 外部サーバーへのpingによりネットワークの接続を確認
echo "${NAME:?}:`date`:start." > ${LOG:?}
until ping -c1 ${EXTERNAL_SERVER:?}
do
  sleep 60
  echo "${NAME:?}:`date`:sleeping." >> ${LOG:?}
done

###############################################################################
RC=0

###############################################################################
#
CMD="freshclam"
echo "`date '+%Y%m%d %H%M%S'`:${CMD:?} START" >> ${LOG:?}
${CMD:?} >> ${LOG:?} 2>&1
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "${CMD:?} fail. RC:${RC:?}" 1>&2
  mail2 "${CMD:?}:${RC:?}"
  exit ${RC:?}
fi
echo "`date '+%Y%m%d %H%M%S'`:${CMD:?} DONE " >> ${LOG:?}

###############################################################################
#
CMD="clamscan"
echo "`date '+%Y%m%d %H%M%S'`:${CMD:?} START" >> ${LOG:?}
nice ${CMD:?} --exclude-dir=/sys/ --infected --remove --recursive / >> ${LOG:?} 2>&1
RC=$?

if [ "${RC:?}" -ne "0" ]; then
  echo "${CMD:?} fail. RC:${RC:?}" 1>&2
  mail2 "${CMD:?}:${RC:?}"
  exit ${RC:?}
fi
echo "`date '+%Y%m%d %H%M%S'`:${CMD:?} DONE " >> ${LOG:?}

###############################################################################
# 正常終了
mail2 "done"
# last.atファイルは正常時のみ作成される
touch ${LASTRUN:?}
exit ${RC:?}
