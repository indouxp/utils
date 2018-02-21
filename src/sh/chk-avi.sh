#!/bin/sh
###############################################################################
#
# motionの出力するaviファイルの数を数えて、前回との差がある場合、talk.shを呼び出す
# nohup でバックグラウンド実行するか、/etc/rc.localからnohup でバックグラウンド実行させる。
#
###############################################################################
NAME=${0##*/}
UTF8=/tmp/${NAME:?}.utf8
SJIS=/tmp/${NAME:?}.cp932

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
    LAST=`ls -1 ${TARGET_DIR:?}/*.avi | tail -1 | sed "s%${TARGET_DIR:?}%%"`
    SIZE=`stat -c %s ${TARGET_DIR:?}${LAST:?}`
    echo "DEBUG:$LAST:$SIZE"
    if [ 200000 -le ${SIZE:?} ]; then
      cat <<EOT | tee ${UTF8:?} | nkf -s > ${SJIS:?}
動体を検知しました。AVIファイルが、${ORG_AVI:?}ファイルから、${NOW_AVI:?}ファイルに増加しました。"
EOT
      cat ${UTF8:?}   > ${NOTICE:?}
      cat <<EOT | tee -a ${UTF8:?} | nkf -s >> ${SJIS:?}
${NOW:?}
      http://192.168.0.254/${LAST:?}
EOT
      cat ${UTF8:?}   | mail -s "${NAME:?}" indou.tsystem@gmail.com,toshikoyumechan@ezweb.ne.jp
      cat ${SJIS:?}   | mail -s "${NAME:?}" indou.tsystem@docomo.ne.jp
    fi
    echo "動体を検知しました。${ORG_AVI:?} -> ${NOW_AVI:?} ${NOW:?}"              >> ${LOG:?}
#  else
#    echo "変化はありません。${ORG_AVI:?} -> ${NOW_AVI:?} ${NOW:?}"                >> ${LOG:?}
  fi
  sleep ${SLEEP_SEC:?}
  ORG_AVI=${NOW_AVI:?}
done
