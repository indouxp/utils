#!/bin/sh
###############################################################################
# tmpfs$B$r:n@.(B~/data$B$K(Bmount$B$7!"(B~/data.src/*$B$r!"(B~/data$B$K%3%T!<$9$k!#(B
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
