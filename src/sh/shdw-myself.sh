#!/bin/sh
###############################################################################
# shoutdown host by ping default gateway
#
###############################################################################
export LANG=ja_JP.utf8
LOG=/var/log/${0##*/}.log
TMP=/var/tmp/${0##*/}.tmp
GW=192.168.0.1
DF='+%Y%m%d.%H%M%S'`
NAME=${0##*/}
MAILTO="indou.tsystem@docomo.ne.jp,toshikoyumechan@yahoo.ne.jp"

# 初期化メッセージ
#msg="`date ${DF:?}`:${NAME:?}:init"
#echo ${msg:?} | tee -a ${LOG:?} | logger

# ntpqで、正しく同期しているサーバーがない場合は、同期を待つ
#while ! ntpq -p | grep -E '^(\*|\+)' > /dev/null
#do
#  sleep 1
#done

# 開始メッセージ
msg="`date ${DF:?}`:${NAME:?}:start"
echo ${msg:?} | tee -a ${LOG:?} | logger

# ポーリング
COUNT=0
while true
do
  if ! ping -c1 ${GW:?} > /dev/null 2>&1; then
    COUNT=`expr ${COUNT:?} + 1`
    msg="`date ${DF:?}`:${NAME:?}:ping status fail. ${COUNT:?} times."
    echo ${msg:?} | tee -a ${LOG:?} | logger
    if [ ${COUNT:?} -eq 5 ]; then
      break
    fi
    sleep 1
  else
    COUNT=0
    sleep 30
  fi
done

# シャットダウン
msg="`date ${DF:?}`:${NAME:?}:shutdown"
echo ${msg:?} | tee -a ${LOG:?} | logger
echo "${msg:?} `hostname`" | mail -s "shutdown" ${MAILTO:?}
tail -n 100 ${LOG:?} > ${TMP:?} &&  mv ${TMP:?} ${LOG:?}
shutdown -h now

