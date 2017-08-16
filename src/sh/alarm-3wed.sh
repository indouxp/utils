#!/bin/sh
###############################################################################
#
# crontabで、0 8 * * * CMD に実行され、第三水曜日の場合音楽鳴らす
#
###############################################################################
TMP=/tmp/${0##*/}.tmp.$$
LOG=/var/log/${0##*/}.log

TERM() {
  rm -f /tmp/${0##*/}.tmp.$$
}

trap 'TERM' 0

LANG=C cal > $TMP

TODAY=`date '+%d'`

sed -n '/Su Mo Tu We Th Fr Sa/,$p' $TMP |
awk -v today=$TODAY '
  BEGIN{
    printf("%s\n", system(date));
  }
  {
    if (NR == 4) {                               # title行より3行目
      if (length($4) == 6 || length($4) == 3) {  # 第三水曜日は4フィールド目で、当日の場合制御文字を含むため文字列長が6
        if (length($4) == 3) {
          wed3 = sprintf("%s", substr($4, 3, 1));
        } else {
          wed3 = sprintf("%s%s", substr($4, 3, 1), substr($4, 6, 1));
        }
        if (wed3 == today) {      
          printf("%s は、第三水曜\n", today);
          exit 9;
        }
      }
    }
  }
' >> ${LOG:?}
RC=$?
[ $RC = 9 ] && mpg321 /home/pi/data/se_maoudamashii_voice_human02.mp3
[ $RC = 9 ] && mpg321 /home/pi/data/se_maoudamashii_voice_human02.mp3
[ $RC = 9 ] && mpg321 /home/pi/data/song_22_ixia.mp3 &
if [ $RC -ne 0 && $RC -ne 9 ]; then
  echo "ERROR"
  exit $RC
fi
