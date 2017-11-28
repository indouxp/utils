#!/bin/sh
###############################################################################
# tmpfsを作成~/dataにmountし、~/data.src/*を、~/dataにコピーする。
#
###############################################################################
LOG=/home/pi/log/${0##*/}.log

date  >> ${LOG:?}
df -h >> ${LOG:?}
if [ ! -d ~/data ]; then
  mkdir ~/data
fi

sudo mount -t tmpfs -o size=64m tmpfs /dev/shm
sudo mount -t tmpfs -o size=64m /dev/shm ~/data

cp ~/data.src/* ~/data

df -h >> ${LOG:?}
