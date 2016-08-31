#!/bin/sh
###############################################################################
# shoutdown host by ping gw
#
###############################################################################
LOG=/var/log/${0##*/}.log
WAIT_SEC=30
GW=192.168.0.254

msg="`date '+%Y%m%d.%H%M%S'`:${0##*/}:start"
echo ${msg:?} | tee ${LOG:?} | logger
while true
do
  if ! ping -c1 ${GW:?} >> ${LOG:?}; then
    break
  fi
  sleep ${WAIT_SEC:?}
done
msg="`date '+%Y%m%d.%H%M%S'`:${0##*/}:shutdown"
echo ${msg:?} | tee -a ${LOG:?} | logger
