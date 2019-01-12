#!/bin/sh
TMP=/tmp/${0##*/}.tmp
DEVICE=$1
set -e

main() {
  cat <<EOT
■パーティション
EOT
  /sbin/fdisk -l ${DEVICE:?} </dev/null | tee ${TMP:?}

  grep "^/dev/" ${TMP:?}|
  awk '{print $1;}' > ${TMP:?}

  cat <<EOT
■不良セクタ調査
EOT
  while read PARTITION
  do
    echo ${PARTITION:?}
    umount ${PARTITION:?}
    /sbin/hdparm -i ${PARTITION:?} | fgrep Model
    /sbin/badblocks -v -s ${PARTITION:?}
    /sbin/e2fsck -l /tmp/${PARTITION##*/}.badblocks ${PARTITION:?}
  done < ${TMP:?}
}
usage(){
cat <<EOT
Usage
\$ ${0##*/} DEVICE
ex)
\$ ${0##*/} /dev/sde
EOT
}

if [ "$#" -eq "0" ]; then
  usage
  exit 9
fi
main
exit 0
