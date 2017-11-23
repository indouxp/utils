#!/bin/sh

rsync -a -e "/usr/bin/ssh -i /home/pi/.ssh/id_rsa4rpi-bp" \
  pi@rpi-bp:/home/pi/backup-rpi-bp \
  /home/pi/backup
RC=$?
[ ${RC:?} != 0 ] && exit ${RC:?}

rsync -a -e "/usr/bin/ssh -i /home/pi/.ssh/id_rsa4rpi-bp" \
  pi@rpi-bp:/mnt/usb8G/important-documents \
  /home/pi/backup
RC=$?
[ ${RC:?} != 0 ] && exit ${RC:?}
