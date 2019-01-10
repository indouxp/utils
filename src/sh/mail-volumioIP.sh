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

ADDRESS=$(grep -o '^(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3} ([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$' ${TMP:?})

echo ${ADDRESS:?}

exit 0
