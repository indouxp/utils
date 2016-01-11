#!/bin/sh
###############################################################################
# $HOSTSのシャットダウン
###############################################################################

HOSTS="192.168.11.170 192.168.11.171"

for HOST in $HOSTS
do
  if ping -c 1 ${HOST:?} >/dev/null; then
    NAME=`su pi -c "ssh pi@${HOST:?} 'hostname'"`
    su pi -c "ssh pi@${HOST:?} 'hostname; sudo shutdown -h now'"
    COUNT=0
    while true
    do
      ping -c 1 ${HOST:?} >/dev/null
      RC=$?
      if [ "${RC:?}" -ne "0" ]; then
        echo "${NAME:?} done"
        break
      fi
      COUNT=$((COUNT +1))
      echo "$$(date '+%Y%m%d %H%M%S')):${NAME:?} alive." 1>&2
      if [ 180 -lt ${COUNT:?} ]; then
        echo "shutdown ${NAME:?} fail." 1>&2
        break
      fi
    done
  else
    echo "${HOST:?} still shutdown"
  fi
done
