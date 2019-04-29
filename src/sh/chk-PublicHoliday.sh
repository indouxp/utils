#!/bin/bash
###############################################################################
#
# chk-PublicHoliday.sh
# 日本の祝日カレンダーから休日を取得
# 20190429:仕掛
#
###############################################################################
NAME=${0##*/}

[ ! -x $(which curl) ] && echo "${NAME:?}: no curl." && exit 1
[ ! -x $(which printf) ] && echo "${NAME:?}: no printf." && exit 1

# 引数がない場合
[ $# -eq 0 ] && echo '$ '"${NAME:?} YEAR MM MM" && exit 9

# 引数1が9999の場合
if echo $1 | grep '^[0-9]\{4\}$' > /dev/null; then
  YEAR=$1
fi
# 引数が1つの場合
if [ $# -eq 1 ]; then
  START=1
  END=12
fi
# 引数1が999999の場合
if echo $1 | grep '^[0-9]\{6\}$' > /dev/null; then
  YEAR=$(echo $1 | cut -b 1-4); START=$(echo $1 | cut -b 5-6); END=$(echo $1 | cut -b 5-6)
fi
# 引数2が999999の場合
if echo $2 | grep '^[0-9]\{6\}$' > /dev/null; then
  YEAR=$(echo $2 | cut -b 1-4); END=$(echo $2 |cut -b 5-6)
fi
# 引数2が99の場合
if echo $2 | grep '^[0-9]\{2\}$' > /dev/null; then
  START=$(echo $2 | cut -b 1-2)
  END=$(echo $2 | cut -b 1-2)
fi
# 引数3が99の場合
if echo $3 | grep '^[0-9]\{2\}$' > /dev/null; then
  END=$(echo $3 | cut -b 1-2)
fi

for m in $(seq ${START:?} ${END:?})
do
  MON=$(printf "%02d" $m)

  echo "${YEAR:?}年${MON:?}月"
  curl http://calendar.infocharge.net/cal/${YEAR:?}/$m/ |
  awk '
    BEGIN{
      out = 0;
    }
    {
      if (match($0, /<\/table/) > 0) {
        out = 0;
      }
      if (match($0, /<table/) > 0){
        out = 1;
      }
      if (out == 1) {
        print;
      }
    }
    END{
    }' |
  sed 's#<tr class="#\n<tr class="#' |
  grep '^<tr class'                  |
  sed 's#<tr class="[^"]*"><td>##'   |
  sed 's#</td><td></td></tr>##'      |
  sed 's#</td><td>##'                |
  tee ${YEAR:?}${MON:?}.debug        |
  sed 's#</td></tr>##'               |
  sed 's#\(^[0-9]日\)#0\1#'
done
