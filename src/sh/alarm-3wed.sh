#!/bin/sh
###############################################################################
#
# crontabで、0 8 * * * CMD に実行され、第三水曜日の場合きゃーという
#
###############################################################################
TMP=/tmp/${0##*/}.tmp.$$

TERM() {
  rm -f /tmp/${0##*/}.tmp.$$
}

trap 'TERM' 0

LANG=C cal > $TMP

TODAY=`date '+%d'`

sed -n '/Su Mo Tu We Th Fr Sa/,$p' $TMP |
awk -v today=$TODAY '
  {
    if (NR == 4) {              # title行より3行目
      if (length($4) == 6) {    # 第三水曜日は4フィールド目で、当日の場合制御文字を含むため文字列長が6
        wed3 = sprintf("%s%s", substr($4, 3, 1), substr($4, 6, 1));
        if (wed3 == today) {      
          exit 9;
        }
      }
    }
  }
'
RC=$?
[ $RC = 9 ] && mpg321 /home/pi/data/se_maoudamashii_voice_human02.mp3
[ $RC = 9 ] && mpg321 /home/pi/data/se_maoudamashii_voice_human02.mp3
[ $RC = 9 ] && mpg321 /home/pi/data/se_maoudamashii_voice_human02.mp3 &
