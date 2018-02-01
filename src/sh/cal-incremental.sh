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
  FROM_BYTE=$(du -sk ${DIR:?} | awk '{print $1;}')
  sleep ${SEC:?}
  TO_EPOCH=$(date '+%s')
  TO_BYTE=$(du -sk ${DIR:?} | awk '{print $1;}')
  if [ "$(which bc)" != "" ]; then
    RESULT=`echo "scale=2; (${TO_BYTE:?} - ${FROM_BYTE:?}) / (${TO_EPOCH:?} - ${FROM_EPOCH:?})" | bc`
    echo "${RESULT:?} Kbytes/sec"
  else
    expr "(${TO_BYTE:?} - ${FROM_BYTE:?}) / (${TO_EPOCH:?} - ${FROM_EPOCH:?}) "
    echo "echo \"(${TO_BYTE:?} - ${FROM_BYTE:?}) / (${TO_EPOCH:?} - ${FROM_EPOCH:?})\" | bc"
    #expr (${TO_BYTE:?} - ${FROM_BYTE:?}) / (${TO_EPOCH:?} - ${FROM_EPOCH:?})
  fi
}

if [ $# -eq 0 ]; then
  USAGE
  exit 1
fi
MAIN "$@"
