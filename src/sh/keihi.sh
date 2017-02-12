#!/bin/sh
MAXRC=0

###############################################################################
main() {
  keihi=`echo "scale=0; $1/2" | bc`
  keep_maxrc
  jigyoushu_kashi=`echo "scale=0; $1 - $keihi" | bc`
  keep_maxrc

  echo "390 事業主貸:$jigyoushu_kashi"
  echo "712 経費:$keihi"
}

###############################################################################
keep_maxrc() {
  RC=$?
  if [ ${RC:?} -lt ${MAXRC:?} ]; then
    MAXRC=${RC:?}
  fi
}

###############################################################################
main $*
exit ${MAXRC:?}

