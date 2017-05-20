#!/bin/sh
###############################################################################
#
# sudo もしくは、rootで実行する
# lastコマンドを実行し、前回の処理の出力との差分を取得し、差がある場合は、メールする
#
###############################################################################
SCRIPT=${0##*/}
LOG=/var/log/${SCRIPT:?}.log
MAIL=indou.tsystem@docomo.ne.jp
MASTER=/var/log/${SCRIPT:?}.master
NOW=/var/log/${SCRIPT:?}.now
TMP=/tmp/${SCRIPT:?}.tmp
tolog() {
  echo "${SCRIPT:?}:`date '+%Y%m%d.%H%M%S'`:$1" >> ${LOG:?}
}
main() {

  tolog "START"

  # last
  # -a:ホスト名を最後の欄に表示する。
  # -d:IP アドレスをホスト名に変換し直して表示する。
  # -n:n行表示
  last -a -d -n 10 |
  awk '
    BEGIN{
    }
    {
      if ($1 == "reboot") {
        next;
      }
      if ($NF ~ /192\.168\./) {
        next;
      }
      if ($NF ~ /tsystem\.gr\.jp/) {
        next;
      }
      if ($NF ~ /0\.0\.0\.0/) {
        next;
      }
      print;
    }
    END{
    }' > ${NOW:?}
  RC=$?
  [ ${RC:?} -ne 0 ] && msg="${SCRIPT:?}:fail. at 010" && logger $msg && tolog $msg && exit 9

  touch ${MASTER:?}
  #diff ${MASTER:?} ${NOW:?} | head -2 | tail -1 > ${TMP:?}
  diff ${MASTER:?} ${NOW:?} | grep ">" > ${TMP:?}  # >のみ出力
  RC=$?
  [ ${RC:?} -ne 0 ] && msg="${SCRIPT:?}:fail. at 020" && logger $msg && tolog $msg && exit 9

  if [ -s ${TMP:?} ]; then
    cat ${TMP:?} >> ${LOG:?}
    cat ${TMP:?} | mail -s "Invasion information" ${MAIL:?}
    [ ${RC:?} -ne 0 ] && msg="${SCRIPT:?}:fail. at 030" && logger $msg && tolog $msg && exit 9
    for i in `awk 'BEGIN{for (i = 0; i < 5; i++) {print i;}}'`
    do
      mpg321 /home/pi/data/se_maoudamashii_chime01.mp3 &
    done
  fi

  mv ${NOW:?} ${MASTER:?}

  tolog "DONE"
}
main
exit 0
