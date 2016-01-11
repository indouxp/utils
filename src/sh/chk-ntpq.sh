#!/bin/sh
SCRIPT=${0##*/}
TMPFILE=/tmp/${SCRIPT:?}.$$
###############################################################################
#
# raspberrypi の動作確認用
#
###############################################################################
term() {
  rm -f /tmp/${0##*}.$$
}

trap 'term' 0 1 2 3 15

# ntpq確認
result=$(ntpq -p | tee $TMPFILE | /bin/grep "^\*")
[ -z "$result" ] && logger -i "${SCRIPT:?}:ntpq fail"
logger -i "${SCRIPT:?}:ntpq ok"
