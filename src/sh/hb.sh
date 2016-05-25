#!/bin/sh
###############################################################################
# hb.sh
# HB_PRIMARYと、HB_SECONDARYに、pingし、LOCK_PATHに、生死を書き出す 
###############################################################################

LOCK_NAME=${0##*/}.lock
LOCK_DIR=/dev/shm
LOCK_PATH=${LOCK_DIR:?}/${LOCK_NAME:?}

LOG_NAME=${0##*/}.log
LOG_DIR=/var/log
LOG_DIR=/tmp
LOG_PATH=${LOG_DIR:?}/${LOG_NAME:?}

###############################################################################
# 割り込み時
TERM() {
  rm -f /dev/shm/hb.sh.lock
  exit 0
}

HB_PRIMARY="192.168.11.80"
HB_PRIMARY="192.168.0.80"
HB_SECONDARY="192.168.11.81"
HB_SECONDARY="192.168.0.81"
IP_PRIMARY="192.168.0.80"
IP_SECONDARY="192.168.0.81"

ADDRESS="${HB_PRIMARY:?} ${HB_SECONDARY:?}"

trap 'TERM' 0 2 3 15

PREV="START"
while true; do
  DIFF=0
  for ADR in ${ADDRESS:?}
  do
    if ping -c 1 ${ADR:?} > /dev/null 2>&1; then
      case ${ADR:?} in
      ${HB_PRIMARY:?})
        #echo "1:${ADR:?}"
        echo -n "${IP_PRIMARY:?} "   >  ${LOCK_PATH:?}
        ;;
      ${HB_SECONDARY:?})
        #echo "2:${ADR:?}"
        echo -n "${IP_SECONDARY:?} " >> ${LOCK_PATH:?}
        ;;
      esac
    fi
  done
  if [ X"${PREV}" != X"`cat ${LOCK_PATH:?}`" ]; then
    DIFF=1
  fi
  echo "# ${0##*/}:`date '+%Y%m%d.%H%M%S'`" >> ${LOCK_PATH:?}
  if [ "${DIFF:?}" = "1" ]; then
    echo "${PREV:?} != `cat ${LOCK_PATH:?}`" >> ${LOG_PATH:?}
  fi
  PREV=`sed 's/#.*$//' ${LOCK_PATH:?}`
  sleep 1
done
