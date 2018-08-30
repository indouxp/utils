#!/bin/sh

# ping
# -s: $B%G!<%?$N%P%$%H?t(B
# -c: $B%Q%1%C%H?t(B
# -W: $B%l%9%]%s%9$NBT$A;~4V(B($BIC(B)

NAMES="ml110g7 ml110g7-2 t3600 vip rpi-bp rpi2 rpi-b macbook macmini2010 rpi3-1 rpi3-2 stormZ170 r60e $*"

for NAME in ${NAMES:?}
do
  ( ping -W 1 -s 1 -c 1 $NAME > /dev/null; RC=$?; echo "${RC:?}:ping $NAME" > /tmp/${0##*/}.${NAME:?} ) &
done
wait
for NAME in /tmp/${0##*/}.*
do
  cat $NAME
done | sed 's/^0:ping/UP  /g' | sed 's/^[^0]:ping/DOWN/g' | sort
