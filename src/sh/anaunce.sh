#!/bin/sh
###############################################################################
#
# ~/notice.txtの内容を、talk.shに送る
#
###############################################################################
NAME=${0##*/}

LOG_DIR=~/log
LOG_FILE=${NAME:?}.log
LOG_PATH=${LOG_DIR:?}/${LOG_FILE:?}

TALK=~/utils/src/sh/talk.sh
NOTICE=~/notice.txt
TMP_NOTICE=~/tmp/notice.txt
TMP_COUNT=~/tmp/count.txt
OLD_NOTICE=~/tmp/notice.old
MAX_TALK=5

DATE_FORMAT='+%Y%m%d.%H%M%S'

if [ ! -e ${NOTICE:?} ]; then
  echo "`date ${DATE_FORMAT:?}`:${NAME:?}:${NOTICE:?}がありません。" >> ${LOG_PATH:?}
  exit0
fi

# ~/notice.txtの更新時刻の取得
YMDHMS=`stat ${NOTICE:?} | grep "^Modify:" | sed 's/Modify: //' | sed 's/\..*$//'`
YMDHMS=`echo ${YMDHMS:?} | sed 's/[0-9][0-9][0-9][0-9]-//'` 
YMDHMS=`echo ${YMDHMS:?} | sed 's/-/月/'`
YMDHMS=`echo ${YMDHMS:?} | sed 's/ /日 /'`
YMDHMS=`echo ${YMDHMS:?} | sed 's/:/時/'`
YMDHMS=`echo ${YMDHMS:?} | sed 's/:/分/'`
YMDHMS=`echo ${YMDHMS:?} | sed 's/$/秒。/'`

# TMP_NOTICEに、更新時刻とnotice.txtの文字列を書き出す
echo -n ${YMDHMS:?} > ${TMP_NOTICE:?}
cat ${NOTICE:?} >> ${TMP_NOTICE:?}

touch ${OLD_NOTICE:?}
touch ${TMP_COUNT:?}

# TALKした回数ファイル
NOW=`cat ${TMP_COUNT:?}`
if [ "${NOW}" = "" ]; then
  NOW=1
else
  NOW=`expr ${NOW:?} + 1`
fi

if ! diff ${TMP_NOTICE:?} ${OLD_NOTICE:?} > /dev/null; then
  cat ${TMP_NOTICE:?} | ${TALK:?}
  echo "`date ${DATE_FORMAT:?}`:${NAME:?}:TALK:`nkf ${TMP_NOTICE:?}`" >> ${LOG_PATH:?}
  NOW=1
else
  if [ ${NOW:?} -lt ${MAX_TALK:?} ]; then
    cat ${TMP_NOTICE:?} | ${TALK:?}
    echo "`date ${DATE_FORMAT:?}`:${NAME:?}:TALK:`nkf ${TMP_NOTICE:?}`" >> ${LOG_PATH:?}
  fi
fi

echo $NOW > ${TMP_COUNT:?}
cp -p ${TMP_NOTICE:?} ${OLD_NOTICE:?}

exit 0
