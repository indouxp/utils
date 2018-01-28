#!/bin/sh
NAME=${0##*/}

LOG_DIR=/var/log
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
  if [ "${ORG_AVI:?}" -lt "${NOW_AVI:?}" ]; then
    echo "動体を検知しました。動体検知ファイルが、${NOW_AVI:?}ファイルあります。" >  ${NOTICE:?}
    echo "動体を検知しました。${ORG_AVI:?} -> ${NOW_AVI:?} ${NOW:?}"              >> ${LOG:?}
  else
    echo "変化はありません。${ORG_AVI:?} -> ${NOW_AVI:?} ${NOW:?}"                >> ${LOG:?}
  fi
  sleep ${SLEEP_SEC:?}
  ORG_AVI=${NOW_AVI:?}
done
