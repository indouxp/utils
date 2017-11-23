#!/bin/sh
###############################################################################
# 仕事の日のアラーム
#
#
###############################################################################
LOG=/home/pi/${0##*/}.log
export LANG=C

TODAY=`date +%A`
[ ${TODAY:?} = "Sunday" ] && exit 0
#[ ${TODAY:?} = "Monday" ] && exit 0
#[ ${TODAY:?} = "Tuesday" ] && exit 0
[ ${TODAY:?} = "Wednesday" ] && exit 0
#[ ${TODAY:?} = "Thursday" ] && exit 0
#[ ${TODAY:?} = "Friday" ] && exit 0
[ ${TODAY:?} = "Saturday" ] && exit 0

for FILE in `ls -1 /home/pi/data/*.ogg`
do
  ogg123 $FILE >>${LOG:?}
done

exit 0
