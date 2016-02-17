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

[ -z "$result" ] &&\
  cp $TMPFILE /var/log/chk-ntpq.sh.`date '+%d'` &&\
  logger -i "${SCRIPT:?}:ntpq fail" &&\
  exit 1

logger -i "${SCRIPT:?}:ntpq ok"
exit 0
