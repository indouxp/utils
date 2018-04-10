#!/bin/sh
TMP=/tmp/${0##*/}.tmp
MAX_USE=90

DONE(){
  rm -f /tmp/${0##*/}.tmp*
}

trap 'DONE' 0 

LANG=C df -h |
awk -vMAX_USE=${MAX_USE:?} '
  BEGIN{
    ERR=0;
  }
  {
    USE=$5; # Use%
    sub(/%/, "", USE);
    if (MAX_USE <= (USE+0)){
      print $0; ERR = 1;
    }
  }
  END{
    if (ERR==0){
      exit 0;
    } else {
      exit 1;
    }
  }' > ${TMP:?}
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "`hostname`:`cat ${TMP:?}`"
  exit ${RC:?}
fi
