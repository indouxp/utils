#!/bin/sh
#
SCRIPT=${0##*/}
TMP=/tmp/${SCRIPT:?}.$$.tmp
MAILTO="indou.tsystem@docomo.ne.jp,toshikoyumechan@yahoo.ne.jp"

TERM() {
  rm -f /tmp/${0##*/}.$$.tmp
}

trap 'TERM' 0

DATE=`date '+%Y%m%d %H%M%S'`

ping -s1 -c1 -W1 volumio.local > ${TMP:?} # １アドレス毎、256パラ
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "${SCRIPT:?}: ping fail. ${RC:?}" | mail -s "${DATE:?} ${SCRIPT:?}: ping fail." ${MAILTO:?}
  exit 9
fi

ADDRESS=$(grep -o '([0-9]{1,3}\.){3}[0-9]{1,3}' ${TMP:?})
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "${SCRIPT:?}: grep fail. ${RC:?}" | mail -s "${DATE:?} ${SCRIPT:?}: ping fail." ${MAILTO:?}
  exit 9
fi

cat <<EOT | mail -s "${DATE:?} Volumio's IP" ${MAILTO:?}
<!doctype html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
</head>
<body>
<p>${DATE:?}</p>
<a href="https://${ADDRESS:?}/">volumio</a>
</body>
EOT

exit 0
