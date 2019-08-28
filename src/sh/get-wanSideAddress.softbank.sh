#!/bin/sh
###############################################################################
# softbank光のルータ画面からwan側のアドレスを取得する。
#
###############################################################################
NAME=`basename $0`
USERID="user"
PASSWD="user"
TMPFILE=/tmp/${NAME:?}.tmp
OUTPUT=/tmp/${NAME:?}.out
MAILTO=indou.tsystem@yahoo.ne.jp

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
  exit 1
fi

if cat ${OUTPUT:?} | mail -s "WAN ADDRESS address infomation." ${MAILTO:?}; then
  exit 0
else
  echo "${NAME:?}: mail fail." 1>&2
  exit 1
fi


