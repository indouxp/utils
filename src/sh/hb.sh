#!/bin/sh
###############################################################################
# hb.sh
# HB_PRIMARYと、HB_SECONDARYに、pingし、LOCK_PATHに、生死を書き出す 
###############################################################################
export LANG=ja_JP.UTF-8

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
  echo "${0##*/}:`date '+%Y%m%d.%H%M%S'`:END" >> ${LOG_PATH:?}
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

echo "${0##*/}:`date '+%Y%m%d.%H%M%S'`:START" > ${LOG_PATH:?}
PREV="START"
while true; do
  DIFF=0
  OUT=""
  for ADR in ${ADDRESS:?}
  do
    if ping -c 1 ${ADR:?} > /dev/null 2>&1; then
      case ${ADR:?} in
      ${HB_PRIMARY:?})
        #echo "1:${ADR:?}"
        OUT="${IP_PRIMARY:?} "
        ;;
      ${HB_SECONDARY:?})
        #echo "2:${ADR:?}"
        OUT="${OUT:?}${IP_SECONDARY:?} "
        ;;
      esac
    fi
  done
  if [ X"${PREV}" != X"${OUT:?}" ]; then
    DIFF=1
  fi
  echo "${OUT:?}# ${0##*/}:`date '+%Y%m%d.%H%M%S'`" > ${LOCK_PATH:?}
  if [ "${DIFF:?}" = "1" ]; then
    echo "${PREV:?} \!= `cat ${LOCK_PATH:?}`" >> ${LOG_PATH:?}
  fi
  PREV=${OUT:?}
  sleep 1
done
