#!/bin/sh
TMP=/tmp/${0##*/}.tmp

LANG=C df -h |
awk '
  BEGIN{ERR=0;}
  {
    RETIO=$5;
    sub(/%/, "", RETIO);
    if (90 <= (RETIO+0)){
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
