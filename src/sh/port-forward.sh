#!/bin/sh
###############################################################################
#
# ssh port forwarding
#
###############################################################################
NAME=${0##*/}
ROUTER="106.158.220.236"
TARGET="192.168.0.40"
[ "1" -le "$#" ] && ROUTER=$1
[ "2" -le "$#" ] && TARGET=$2

usage(){
cat <<EOT
\$ ${NAME:?} ROUTER-ADDRESS TARGET-ADDRESS
ROUTER-ADDRESS:default ${ROUTER}
TARGET-ADDRESS:default ${TARGET}
EOT
}

while getopts h OPT
do
  case $OPT in
    h) usage
       exit
       ;;
  esac
done

shift $((OPTIND - 1))

USER=pi
LOCALPORT=10010
PORT=22
CMD="ssh ${USER:?}@${ROUTER:?} -L ${LOCALPORT:?}:${TARGET:?}:${PORT:?} -N"

cat <<EOT
このターミナルで、${CMD:?}を実行します。
他ターミナル上で、${TARGET:?}:${PORT:?}への接続を、localhost:${LOCALPORT:?}宛てに
実行できます。
ex)
$ scp -P 10010 ./rhel-server-7.3-x86_64-dvd.iso indou@localhost:/tmp
$ ssh indou@localhost -p 10010

EOT
${CMD:?}

exit 0

