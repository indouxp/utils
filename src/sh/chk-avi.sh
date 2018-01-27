#!/bin/sh
NAME=${0##*/}

LOG_DIR=/var/tmp
LOG_NAME=${NAME:?}.log
LOG=${LOG_DIR:?}/${LOG_NAME:?}

NOTICE=/home/pi/notice.txt
TARGET_DIR=/mnt/usb8G/webcam
SLEEP_SEC=5

ORG_AVI=$(ls ${TARGET_DIR:?}/*.avi | wc -l)
while true
do
  NOW_AVI=$(ls ${TARGET_DIR:?}/*.avi | wc -l)
  NOW=`date '+%m月%d日 %H時%M分%S秒'`
  if [ "${NOW_AVI:?}" -ne "${ORG_AVI:?}" ]; then
    echo "動体を検知しました。${ORG_AVI:?} -> ${NOW_AVI:?}" >  ${NOTICE:?}
    echo "動体を検知しました。$NOW"                         >> ${LOG:?}
  #else
  #  echo "変化はありません。$NOW"   > ${NOTICE:?}
  fi
  sleep ${SLEEP_SEC:?}
  ORG_AVI=${NOW_AVI:?}
done
