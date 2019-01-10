#!/bin/sh
#
SCRIPT=${0##*/}
TMP=/tmp/${SCRIPT:?}.$$.tmp
MAILTO="indou.tsystem@gmail.com,toshikoyumechan@yahoo.ne.jp"

TERM() {
  rm -f /tmp/${0##*/}.$$.tmp
}

#trap 'TERM' 0

DATE=`date '+%Y%m%d %H%M%S'`

ping -s1 -c1 -W1 volumio.local | grep "ttl" >  ${TMP:?} # １アドレス毎、256パラ
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "${SCRIPT:?}: ping fail. ${RC:?}" | mail -s "${DATE:?} ${SCRIPT:?}: ping fail." ${MAILTO:?}
  exit 9
fi

ADDRESS=$(egrep -o 'from ([0-9]{1,3}\.){3}[0-9]{1,3}' ${TMP:?} | sed 's/from //')
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "${SCRIPT:?}: grep fail. ${RC:?}" | mail -s "${DATE:?} ${SCRIPT:?}: ping fail." ${MAILTO:?}
  exit 9
fi

cat <<EOT | mail -s "${DATE:?} Volumio's IP" ${MAILTO:?}
   ** volumio **
http://${ADDRESS:?}
EOT

exit 0
