#!/bin/sh
###############################################################################
#
# motionの出力するaviファイルの数を数えて、前回との差がある場合、talk.shを呼び出す
# nohup でバックグラウンド実行するか、/etc/rc.localからnohup でバックグラウンド実行させる。
#
###############################################################################
NAME=${0##*/}

LOG_DIR=/var/log
LOG_NAME=${NAME:?}.log
LOG=${LOG_DIR:?}/${LOG_NAME:?}

NO=1
NOTICE=/home/pi/notice${NO:?}.txt
TARGET_DIR=/mnt/usb8G/webcam
SLEEP_SEC=5

ORG_AVI=$(ls ${TARGET_DIR:?}/*.avi | wc -l)
while true
do
  NOW_AVI=$(ls ${TARGET_DIR:?}/*.avi | wc -l)
  NOW=`date '+%m月%d日 %H時%M分%S秒'`
  if [ "${ORG_AVI:?}" -lt "${NOW_AVI:?}" ]; then
    echo "動体を検知しました。AVIファイルが、${ORG_AVI:?}ファイルから、${NOW_AVI:?}ファイルに増加しました。" >  ${NOTICE:?}
    cat <<EOT | tail ${NOTICE:?} | mail -s "${NAME:?}" indou.tsystem@gmail.com,toshikoyumechan@ezweb.ne.jp
動体を検知しました。AVIファイルが、${ORG_AVI:?}ファイルから、${NOW_AVI:?}ファイルに増加しました。"
EOT
#    echo "動体を検知しました。${ORG_AVI:?} -> ${NOW_AVI:?} ${NOW:?}"              >> ${LOG:?}
#  else
#    echo "変化はありません。${ORG_AVI:?} -> ${NOW_AVI:?} ${NOW:?}"                >> ${LOG:?}
  fi
  sleep ${SLEEP_SEC:?}
  ORG_AVI=${NOW_AVI:?}
done
