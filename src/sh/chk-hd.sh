#!/bin/sh
###############################################################################
#
# 不良セクタを調べる
# REFERENCE:http://kaworu.jpn.org/ubuntu/Linux%E3%81%A7%E3%83%87%E3%82%A3%E3%82%B9%E3%82%AF%E3%81%AE%E3%82%A8%E3%83%A9%E3%83%BC%E3%82%84%E4%B8%8D%E8%89%AF%E3%82%BB%E3%82%AF%E3%82%BF%E3%81%AE%E3%83%81%E3%82%A7%E3%83%83%E3%82%AF%E3%81%A8%E4%BF%AE%E6%AD%A3%E3%82%92%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95
#
###############################################################################
DEVICE=$1
LOG=/tmp/${0##*/}.log
DATEFORMAT='+%Y%m%d.%H%M%S'

main() {
  if [ ! -b ${DEVICE:?} ]; then
    usage
    exit 1
  fi

  echo "${0##*/}:`date ${DATEFORMAT:?}`:DEVICE:${DEVICE:?}" | tee -a ${LOG:?}
  sudo badblocks -v -s ${DEVICE:?}                          | tee -a ${LOG:?}
  echo "LOG:${LOG:?}"                  > /dev/tty
}

usage() {
  cat <<EOT
\$ ./${0##*/} DEVICE
ex)
\$ ./${0##*/} /dev/sdb
EOT
}

main
exit 0
