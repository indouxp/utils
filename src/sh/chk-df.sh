#!/bin/sh
TMP=/tmp/${0##*/}.tmp
MAX_USE=90

DONE(){
  rm -f /tmp/${0##*/}.tmp*
}

trap 'DONE' 0 

DETAIL=0
while getopts v OPT
do
  case $OPT in
    v) DETAIL=1
       ;;
  esac
done
shift $((OPTIND - 1))

LANG=C df -h |
awk -vMAX_USE=${MAX_USE:?} -vDETAIL=${DETAIL:?} '
  BEGIN{
    ERR=0;
  }
  {
    if ($1 == "Filesystem") {
      if (DETAIL == 1) {
        printf("       ");
        print $0;
      }
      next;
    }
    USE=$5; # Use%
    sub(/%/, "", USE);
    #printf("DEBUG:%s\n", (USE+0));
    if (MAX_USE <= (USE+0)){
      if (DETAIL == 1) {
        printf("NG:%3d:", USE);
        print $0;
      }
      ERR = 1;
    }
    if (ERR == 0) {
      if (DETAIL == 1) {
        printf("OK:%3d:", USE);
        print $0;
      }
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
if [ "${DETAIL:?}" -ne "0" ]; then
  echo "`hostname`"
  echo "`cat ${TMP:?}`"
fi
if [ "${RC:?}" -ne "0" ]; then
  echo "`hostname`"
  echo "`cat ${TMP:?}`"
  exit ${RC:?}
fi
