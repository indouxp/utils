#!/bin/sh

<<<<<<< HEAD
NAMES="ml110g7 ml110g7-2 t3600 vip rpi-bp rpi2 rpi-b macbook macmini2010 rpi3-1 rpi3-2"
=======
NAMES="ml110g7 ml110g7-2 t3600 vip rpi-bp rpi2 rpi-b macbook stormZ170 r60e"
>>>>>>> de455610509be9b0dcf1ee73af4bb546a8fcf3e6

for NAME in ${NAMES:?}
do
  ( ping -c 1 $NAME > /dev/null; RC=$?; echo "${RC:?}:ping $NAME" > /tmp/${0##*/}.${NAME:?} ) &
done
wait
for NAME in /tmp/${0##*/}.*
do
  cat $NAME
done | sed 's/^0:ping/UP  /g' | sed 's/^[^0]:ping/DOWN/g' | sort
