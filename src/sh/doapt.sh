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
  su - indou -c "grep "アップグレード" ${LOG:?} |\
                  mail -s \"${SUBJECT}\" ${MAILTO:?}"
}

###############################################################################
# 前回の処理が今日の場合は終了。又、前回の処理成功ファイルを削除。
[ -f ${LASTRUN:?} ] && exit 0
rm -f /var/log/${NAME:?}.last.at.*

###############################################################################
# 開始
echo "${NAME:?}:`date`:start." > ${LOG:?}

###############################################################################
# 外部サーバーへのpingによりネットワークの接続を確認
until ping -c1 ${EXTERNAL_SERVER:?}
do
  sleep 60
  echo "${NAME:?}:`date`:ping fail. sleeping." >> ${LOG:?}
done

###############################################################################
RC=0

###############################################################################
#
CMD="apt-get update"
echo "`date '+%Y%m%d %H%M%S'`:${CMD:?} START" >> ${LOG:?}
nice ${CMD:?} >> ${LOG:?} 2>&1
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "${CMD:?} fail. RC:${RC:?}" 1>&2
  echo "${CMD:?}:${RC:?}" | logger
  mail2 "${CMD:?}:${RC:?}"
  exit ${RC:?}
fi
echo "`date '+%Y%m%d %H%M%S'`:${CMD:?} DONE " >> ${LOG:?}

###############################################################################
#
CMD="apt-get upgrade -y"
echo "`date '+%Y%m%d %H%M%S'`:${CMD:?} START" >> ${LOG:?}
nice ${CMD:?} >> ${LOG:?} 2>&1
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "${CMD:?} fail. RC:${RC:?}" 1>&2
  echo "${CMD:?}:${RC:?}" | logger
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
