#!/bin/sh
###############################################################################
# $HOSTSのシャットダウン
###############################################################################
SCRIPT=${0##*/}
logger "${SCRIPT:?}:START"

HOSTS="192.168.11.170 192.168.11.171 192.168.0.254"

for HOST in $HOSTS
do
  msg="${SCRIPT:?}:ping to ${HOST:?}"
  logger $msg; echo $msg
  if ping -c 1 ${HOST:?} >/dev/null; then              # pingで生きているもの
    NAME=$(su pi -c "ssh pi@${HOST:?} 'hostname'")     # 名前取得
    msg="${SCRIPT:?}:ssh ${HOST:?} and shutdown"
    logger $msg; echo $msg
    su pi -c "ssh pi@${HOST:?} 'hostname; sudo shutdown -h now'"
    COUNT=0
    while true
    do
      ping -c 1 ${HOST:?} >/dev/null
      RC=$?
      if [ "${RC:?}" -ne "0" ]; then
        msg="${SCRIPT:?}:ping ${HOST:?} fail. ${NAME:?} done."
        logger $msg; echo $msg
        break
      fi
      COUNT=$((COUNT +1))
      echo "$(date '+%Y%m%d %H%M%S'):${NAME:?} alive." 1>&2
      if [ 180 -lt ${COUNT:?} ]; then
        msg="${SCRIPT:?}:ping ${NAME:?} alive. shutdown ${NAME:?} fail."
        logger $msg; echo $msg
        break
      fi
      sleep 1
    done
  else
    msg="${SCRIPT:?}:ping ${HOST:?} still shutdown."
    logger $msg; echo $msg
  fi
done
logger "${SCRIPT:?}:DONE"
