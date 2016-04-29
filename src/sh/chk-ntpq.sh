#!/bin/sh
SCRIPT=${0##*/}
TMPFILE=/tmp/${SCRIPT:?}.$$
###############################################################################
#
# raspberrypi の動作確認用
#
###############################################################################
term() {
  rm -f /tmp/${0##*/}.$$
}

trap 'term' 0 1 2 3 15

# ntpq確認
result=$(ntpq -p | tee $TMPFILE | /bin/grep "^\*")

# 「ntpq -p」を実行して同期が取れていない場合
[ -z "$result" ] &&\
  # ログをコピーしてサービスの再起動
  cp $TMPFILE /var/log/chk-ntpq.sh.`date '+%d'`.fail &&\
  logger -i "${SCRIPT:?}:ntpq fail" &&\
  service ntp restart &&\
  exit 1

#logger -i "${SCRIPT:?}:ntpq ok"
cp $TMPFILE /var/log/chk-ntpq.sh.success
exit 0
