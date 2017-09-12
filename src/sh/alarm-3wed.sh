#!/bin/sh
###############################################################################
#
# crontabで、0 8 * * * CMD に実行され、第三水曜日の場合音楽鳴らす
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
  BEGIN {
    targetline = 0;             # 第三水曜のある行
  }
  {
    if (NR == 2) {              # タイトル行の次の行
      if (NF < 4) {             # 列数が4未満なら先頭行に水曜日はない
        targetline = 5;         #  つまり第三水曜日は五行目
      } else {                  # 列数が4以上なら先頭行に水曜日がある
        targetline = 4;         #  つまり第三水曜日は四行目
      } 
      if (targetline == 0) {
        printf("ERR01\n") > /dev/stderr;
        exit 9;
      }
    }
    if (NR == targetline) {     # 第三水曜の行
      if (length($4) == 6) {    # 第三水曜日は4フィールド目で、calの出力は当日の場合制御文字を含むため文字列長が6
        wed3 = sprintf("%s%s", substr($4, 3, 1), substr($4, 6, 1));
        if (wed3 == today) {      
          exit 9;
        }
      }
    }
  }
'
RC=$?
[ $RC = 9 ] && mpg321 /home/pi/data/song_22_ixia.mp3 &

if [ ! -e /home/pi/data/song_22_ixia.mp3 ]; then
  echo "ERROR"
  exit 9
fi
