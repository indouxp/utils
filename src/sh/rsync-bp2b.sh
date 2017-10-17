#!/bin/sh

rsync -r -e "/usr/bin/ssh -i /home/pi/.ssh/id_rsa4rpi-bp" \
  pi@rpi-bp:/home/pi/backup-rpi-bp \
  /home/pi/backup
RC=$?
exit ${RC:?}
