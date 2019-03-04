#!/bin/sh
###############################################################################
# lxc上のCentOS7コンテナを作成
#
# CREATE: 201903??
# UPDATE: 20190304
###############################################################################
NAME=${0##*/}
DF='+%Y%m%d.%H%M%S'

if [ "$#" -eq "0" ]; then
  cat <<EOT
\$ ${NAME:?} CONTAINER_NAME CONTAINER_IP IMAGE
CONTAINER_NAME: コンテナ名
CONTAINER_IP  : コンテナIPアドレス
IMAGE         : イメージ
EOT
  exit 9
fi

CNAME=$1
CIP=$2
if [ "$3" != "" ]; then
  IMAGE=$3
else
  IMAGE="centos/7"
fi

echo "${NAME:?} $(date ${DF:?}) "
cat <<EOT
CONTAINER NAME : ${CNAME:?}
          ADDR : ${CIP:?}
          IMAGE: ${IMAGE:?}
EOT
echo "OK? or Ctrl-C\c"; read OK

while true
do
  if lxc ls ${CNAME:?} | grep ${CNAME:?}; then
    echo CONTAINER OK
    break
  else
    lxc launch images:${IMAGE:?} ${CNAME:?}
  fi
done

lxc network attach lxdbr0 ${CNAME:?} eth0 eth0
if lxc config device set ${CNAME:?} eth0 ipv4.address ${CIP:?}; then
  lxc ls ${CNAME:?}
  lxc stop ${CNAME:?}
  lxc start ${CNAME:?}
  lxc ls ${CNAME:?}
fi

exit 0
