#!/bin/sh

NAMES="ml110g7 t3600 vip rpi-bp rpi2"

for NAME in ${NAMES:?}
do
  ( ping -c 1 $NAME > /dev/null; RC=$?; echo "${RC:?}:ping $NAME" > /tmp/${0##*/}.${NAME:?} ) &
done
wait
for NAME in /tmp/${0##*/}.*
do
  cat $NAME
done | sed 's/^0:ping/UP  /g' | sed 's/^[^0]:ping/DOWN/g' | sort
