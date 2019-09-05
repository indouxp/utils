#!/bin/sh
################################################################################
#
# rdesktop.shで、接続
#
################################################################################
NAME=${0##*/}
DIR=${0%/*}
if [ "$#" -eq "0" ]; then
  cat <<EOT
Usage
\$ ${NAME:?} HOST USER 
EOT
  exit 0
fi

HOST=$1
USER=$2

if [ ! -x ${DIR:?}/rdesktop.sh ]; then
  echo "${NAME:?}: ${DIR:?}/rdesktop.sh not exist" 1>&2
  exit 9
fi

while true
do
  if ping -c 1 ${HOST:?}; then
    nmap -P0 ${HOST:?} | grep 3389
    RC=$?
    if [ "${RC:?}" -eq "0" ]; then
      break
    fi
    echo ".\c"
  else
    echo "_\c"
  fi
  sleep 1
done

${DIR:?}/rdesktop.sh ${HOST:?} ${USER:?}
exit $?

