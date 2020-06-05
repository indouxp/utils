#!/bin/sh
###############################################################################
# softbank光のルータ画面からwan側のアドレスを取得する。
# 以前と異なるアドレス取得時はメール

# crontab設定
#0 * * * * /home/pi/utils/src/sh/get-wanSideAddress.sh
#5 * * * * /home/pi/utils/src/sh/set-ddns.sh
###############################################################################
NAME=`basename $0`
USERID="user"
PASSWD="user"
TMPFILE=/tmp/${NAME:?}.tmp
OUTPUT=/tmp/${NAME:?}.out
PREVIOUS=/tmp/${NAME:?}.prev
MAILTO=indou.tsystem@yahoo.ne.jp
SUBJECT="WAN ADDRESS address infomation."

###############################################################################
# httpアクセス
###############################################################################
if wget                             \
    --http-user=${USERID:?}         \
    --http-password=${PASSWD:?}     \
    --output-document=${TMPFILE:?}  \
    http://172.16.255.254/settei.html > /dev/null 2>&1
then
  nkf -w ${TMPFILE:?}               |
    grep "WANIP=\"[0-9.][0-9.]*\""  |
    grep -o "[0-9.][0-9.]*"         > ${OUTPUT:?}
else
  echo "${NAME:?}: wget fail." 1>&2
  exit 9
fi


###############################################################################
# 午前0時台
###############################################################################
if [ date '+%H' = "15" ]; then
  if cat ${OUTPUT:?} | mail -s ${SUBJECT:?} ${MAILTO:?}; then
    exit 0
  else
    echo "${NAME:?}: mail fail." 1>&2
    exit 9
  fi
fi

###############################################################################
# 前回と相違
###############################################################################
if diff ${OUTPUT:} ${PREVIOUS:?}; then
  if cat ${OUTPUT:?} | mail -s ${SUBJECT:?} ${MAILTO:?}; then
    exit 0
  else
    echo "${NAME:?}: mail fail." 1>&2
    exit 9
  fi
fi

mv ${OUTPUT:?} ${PREVIOUS:?}

