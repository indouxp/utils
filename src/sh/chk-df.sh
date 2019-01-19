#!/bin/sh
###############################################################################
#
# ID         : chk-df.sh
# EXPLANATION: df -hの出力のUSE%がMAX_USEを超える場合は戻り値0以外を戻す
#
# pi@rpi3-2:~/utils/src/sh $ ./chk-df.sh -v
# rpi3-2
#        Filesystem      Size  Used Avail Use% Mounted on
# OK: 18:/dev/root        30G  4.8G   24G  18% /
# OK:  0:devtmpfs        426M     0  426M   0% /dev
# OK:  0:tmpfs           430M     0  430M   0% /dev/shm
# OK:  2:tmpfs           430M  6.0M  425M   2% /run
# OK:  1:tmpfs           5.0M  4.0K  5.0M   1% /run/lock
# OK:  0:tmpfs           430M     0  430M   0% /sys/fs/cgroup
# OK:  1:tmpfs            32M  136K   32M   1% /tmp
# OK:  0:tmpfs            16M     0   16M   0% /var/tmp
# OK: 52:/dev/mmcblk0p1   41M   21M   20M  52% /boot
# OK:  0:tmpfs            86M     0   86M   0% /run/user/109
# OK:  0:tmpfs            86M     0   86M   0% /run/user/1000
# pi@rpi3-2:~/utils/src/sh $ ./chk-df.sh -v /tmp /
# rpi3-2
#        Filesystem      Size  Used Avail Use% Mounted on
# OK:  1:tmpfs            32M  136K   32M   1% /tmp
# OK: 18:/dev/root        30G  4.8G   24G  18% /
# pi@rpi3-2:~/utils/src/sh $ 
# 
###############################################################################
#
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

if [ "$#" -eq "0" ]; then
  TARGET=""
else
  TARGET=$*
fi

LANG=C df -h ${TARGET} |
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
