#!/bin/sh
#
SCRIPT=${0##*/}
TMP=/tmp/${SCRIPT:?}.$$.tmp
LOG=/tmp/${SCRIPT:?}.$$.log


date '+%Y%m%d %H%M%S' > ${LOG:?}

ping -s1 -c1 -W1 volumio.local > ${TMP:?} # １アドレス毎、256パラ
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "${SCRIPT:?}: ping fail. ${RC:?}" >> ${LOG:?}
  exit 9
fi

ADDRESS=$(grep -o '([0-9]{1,3}\.){3}[0-9]{1,3}' ${TMP:?})
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "${SCRIPT:?}: grep fail. ${RC:?}" >> ${LOG:?}
  exit 9
fi

echo ${ADDRESS:?}

exit 0
