#!/bin/sh
###############################################################################
# shoutdown host by ping default gateway
#
###############################################################################
export LANG=ja_JP.utf8
LOG=/var/log/${0##*/}.log
TMP=/var/tmp/${0##*/}.tmp
GW=192.168.0.1
DF='+%Y%m%d.%H%M%S'
NAME=${0##*/}
MAILTO="indou.tsystem@gmail.com,toshikoyumechan@yahoo.ne.jp"

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
NTPQ=0
while true
do
  if ! ping -c1 ${GW:?} > /dev/null 2>&1; then
    COUNT=`expr ${COUNT:?} + 1`
    msg="`date ${DF:?}`:${NAME:?}:ping status fail. ${COUNT:?} times."
    echo ${msg:?} | tee -a ${LOG:?} | logger
    if [ ${COUNT:?} -eq 5 ]; then # 5 * sleep 10なら、shutdown
      break
    fi
    sleep 10
  else
    if [ "${NTPQ:?}" -eq "0" ]; then
      if ntpq -p | grep -E '^\*'; then
        msg="`date ${DF:?}`:${NAME:?}:time synchronization success."
        echo ${msg:?} | tee -a ${LOG:?} | logger
        NTPQ=1
      fi
    fi
    COUNT=0 # shutdownまでのカウントをクリア
    sleep 30
  fi
done

# シャットダウン
msg="`date ${DF:?}`:${NAME:?}:`hostname` shutdown"
echo ${msg:?} | tee -a ${LOG:?} | logger
echo ${msg:?} | mail -s "shutdown" ${MAILTO:?}
sleep 10  # メールを飛ばすため
tail -n 100 ${LOG:?} > ${TMP:?} &&  mv ${TMP:?} ${LOG:?}
shutdown -h now

