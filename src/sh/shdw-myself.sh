#!/bin/sh
###############################################################################
# shoutdown host by ping dns
#
###############################################################################
export LANG=ja_JP.utf8
LOG=/var/log/${0##*/}.log
TMP=/var/tmp/${0##*/}.tmp
DNS=192.168.0.254

msg="`date '+%Y%m%d.%H%M%S'`:${0##*/}:init"
echo ${msg:?} | tee -a ${LOG:?} | logger

while ! ntpq -p | grep '^*' > /dev/null
do
  sleep 1
done

msg="`date '+%Y%m%d.%H%M%S'`:${0##*/}:start"
echo ${msg:?} | tee -a ${LOG:?} | logger

COUNT=0
while true
do
  if ! ping -c1 ${DNS:?} > /dev/null 2>&1; then
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
tail -n 100 ${LOG:?} > ${TMP:?} &&  mv ${TMP:?} ${LOG:?}
shutdown -h now
