#!/bin/sh
###############################################################################
# $B;E;v$NF|$N%"%i!<%`(B
#
#
###############################################################################
export LANG=C

[ `date +%A` = "Sunday" ] && exit 0
#[ `date +%A` = "Monday" ] && exit 0
#[ `date +%A` = "Tuesday" ] && exit 0
[ `date +%A` = "Wednesday" ] && exit 0
#[ `date +%A` = "Thursday" ] && exit 0
#[ `date +%A` = "Friday" ] && exit 0
[ `date +%A` = "Saturday" ] && exit 0

for FILE in `ls -1 /home/pi/data/*.ogg`
do
  ogg123 $FILE
done

exit 0
