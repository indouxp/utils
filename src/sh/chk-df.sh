#!/bin/sh
TMP=/tmp/${0##*/}.tmp
MAX_RETIO=90

DONE(){
  rm -f /tmp/${0##*/}.tmp*
}

trap 'DONE' 0 

LANG=C df -h |
awk -vMAX_RETIO=${MAX_RETIO:?} '
  BEGIN{ERR=0;}
  {
    RETIO=$5;
    sub(/%/, "", RETIO);
    if (MAX_RETIO <= (RETIO+0)){
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
