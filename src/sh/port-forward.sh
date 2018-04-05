#!/bin/sh
###############################################################################
#
# ssh port forwarding
#
###############################################################################
NAME=${0##*/}
ROUTER="106.158.220.236"
if [ "$#" -ne "0" ]; then
  ROUTER=$1
fi

USER=pi
TARGET=192.168.0.40
LOCALPORT=10010
PORT=22
CMD="ssh ${USER:?}@${ROUTER:?} -L ${LOCALPORT:?}:${TARGET:?}:${PORT:?} -N"

cat <<EOT
このターミナルで、${CMD:?}を実行します。
他ターミナル上で、${TARGET:?}:${PORT:?}への接続を、localhost:${LOCALPORT:?}宛てに
実行できます。
EOT
${CMD:?}

exit 0

