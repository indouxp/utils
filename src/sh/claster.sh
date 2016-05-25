#!/bin/sh
###############################################################################
# cluster.sh
# /dev/shm/hb.sh.lockの一列目に、VIPを紐付ける
###############################################################################
SCRIPT=${0##*/}

LOCK_NAME=hb.sh.lock
LOCK_DIR=/dev/shm
LOCK_PATH=${LOCK_DIR:?}/${LOCK_NAME:?}

LOG_NAME=${0##*/}.log
LOG_DIR=/var/log
LOG_DIR=/tmp
LOG_PATH=${LOG_DIR:?}/${LOG_NAME:?}

###############################################################################
# 割り込み時
TERM() {
  echo "${SCRIPT:?} `date '+%Y%m%d.%H%M%S'` done." >> ${LOG_PATH:?}
  exit 0
}

###############################################################################
# 
if [ ! -r ${LOCK_PATH:?} ]; then
  echo "${SCRIPT:?}:${LOCK_PATH:?} not exist." 1>&2
  echo "${SCRIPT:?} done"
  exit 1
fi

###############################################################################
# 
trap 'TERM' 0 2 3 15

###############################################################################
# 
PREV="START"

###############################################################################
# 
VIP="192.168.0.252"
PIP=`ip addr show eth0 | grep "inet " | awk '{if ($0 ~ /192\.168\.0/) {print $2;exit 0}}' | sed "s%/.*%%"`
echo "${SCRIPT:?} `date '+%Y%m%d.%H%M%S'` VIP:[${VIP:?}]" >> ${LOG_PATH:?}
echo "${SCRIPT:?} `date '+%Y%m%d.%H%M%S'` PIP:[${PIP:?}]" >> ${LOG_PATH:?}

while true; do
  NOW=`awk '{print $1;}' $LOCK_PATH`
  if [ x"${NOW:?}" = x ]; then
    continue
  fi
  echo "NOW:${NOW} PREV:${PREV}"                         >> ${LOG_PATH:?}
  if [ X${NOW:?} = X${PREV} ]; then
    sleep 1
    continue
  else                                # 前回と異なる場合
    if [ ${NOW:?} = ${PIP:?} ]; then  # 自分が立ち上がる
      echo "${SCRIPT:?} `date '+%Y%m%d.%H%M%S'` PRIMARY" >> ${LOG_PATH:?}
      ip addr show dev eth0                              >> ${LOG_PATH:?}
      ip addr del ${VIP:?} dev eth0                      >> ${LOG_PATH:?} 2>&1
      ip addr add ${VIP:?} dev eth0                      >> ${LOG_PATH:?} 2>&1
      RC=$?
      echo "ip addr add ${VIP:?} dev eth0 RC:${RC:?}"    >> ${LOG_PATH:?}
      ip addr show dev eth0                              >> ${LOG_PATH:?}
    else
      echo "${SCRIPT:?} `date '+%Y%m%d.%H%M%S'` SECONDARY" >> ${LOG_PATH:?}
      ip addr show dev eth0                                >> ${LOG_PATH:?}
      ip addr del ${VIP:?} dev eth0                        >> ${LOG_PATH:?} 2>&1
      RC=$?
      echo "ip addr del ${VIP:?} dev eth0 RC:${RC:?}"      >> ${LOG_PATH:?}
      ip addr show dev eth0                                >> ${LOG_PATH:?}
    fi
  fi 
  sleep 1
  PREV=${NOW:?}
done
