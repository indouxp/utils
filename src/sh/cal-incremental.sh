#!/bin/sh
NAME=${0##*/}

USAGE() {
  cat <<EOT
\$ ${NAME:?} DIR SEC
  DIRの増分をSEC後に確認する
EOT
}

MAIN() {
  DIR=$1
  SEC=$2
  if [ ! -d "${DIR:?}" ]; then
    echo "${NAME:?}:${DIR:?} is not directory." 1>&2
    USAGE
    exit 1
  fi
  if [ "${SEC}" = "" ]; then
    USAGE
    exit 1
  fi

  FROM_EPOCH=$(date '+%s')
  FROM_KBYTE=$(du -sk ${DIR:?} | awk '{print $1;}')
  sleep ${SEC:?}
  TO_EPOCH=$(date '+%s')
  TO_KBYTE=$(du -sk ${DIR:?} | awk '{print $1;}')

  if [ "$(which bc)" != "" ]; then
    RESULT1=`echo "scale=2; (${TO_KBYTE:?} - ${FROM_KBYTE:?}) / (${TO_EPOCH:?} - ${FROM_EPOCH:?})" | bc`
    RESULT2=`echo "scale=2; (${TO_KBYTE:?} - ${FROM_KBYTE:?}) / (${TO_EPOCH:?} - ${FROM_EPOCH:?}) / 1024" | bc`
    echo "${RESULT1:?} Kbytes/sec, ${RESULT2:?} Mbytes/sec"
  else
    expr "(${TO_KBYTE:?} - ${FROM_KBYTE:?}) / (${TO_EPOCH:?} - ${FROM_EPOCH:?}) "
    echo "echo \"(${TO_KBYTE:?} - ${FROM_KBYTE:?}) / (${TO_EPOCH:?} - ${FROM_EPOCH:?})\" | bc"
    #expr (${TO_KBYTE:?} - ${FROM_KBYTE:?}) / (${TO_EPOCH:?} - ${FROM_EPOCH:?})
  fi
}

if [ $# -eq 0 ]; then
  USAGE
  exit 1
fi
MAIN "$@"
