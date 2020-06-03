#!/bin/sh
Usage() {
  cat <<EOT
https://tech-mmmm.blogspot.com/2018/05/linuxping.html
Usage
# $0 server
server: [送信先IPアドレス|ホスト名]
ex)
indou@ml110g7:~$ ./get-Mbps.sh 192.168.0.1
3.219 ms
325.74 Mbps
indou@ml110g7:~$
EOT
}
DEST=$1
if [ -z "${DEST}" ]; then
  Usage
  exit 9
fi
TIMES=10
SIZE=65507
RTT=`ping -q -c ${TIMES:?} -s ${SIZE:?} ${DEST:?} | grep avg | cut -d"/" -f 5`
echo "${RTT} ms"
SPEED=`echo "scale=2; (${SIZE:?} * 8 * 2) / ${RTT:?} / 1024" | bc`
echo "${SPEED} Mbps"
exit 0
