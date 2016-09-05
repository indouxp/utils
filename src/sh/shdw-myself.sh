#!/bin/sh
###############################################################################
# shoutdown host by ping gw
#
###############################################################################
LOG=/var/log/${0##*/}.log
GW=192.168.0.254

msg="`date '+%Y%m%d.%H%M%S'`:${0##*/}:start"
echo ${msg:?} | tee ${LOG:?} | logger

COUNT=0
while true
do
  if ! ping -c1 ${GW:?} >> ${LOG:?}; then
    COUNT=`expr ${COUNT:?} + 1`
    echo $COUNT
    if [ ${COUNT:?} -eq 5 ]; then
      break
    fi
    sleep 1
  else
    sleep 30
  fi
done

msg="`date '+%Y%m%d.%H%M%S'`:${0##*/}:shutdown"
echo ${msg:?} | tee -a ${LOG:?} | logger
