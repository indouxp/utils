#!/bin/sh
###############################################################################
# $B;E;v$NF|$N%"%i!<%`(B
#
#
###############################################################################
LOG=/home/pi/log/${0##*/}.log
export LANG=C

# $B;E;v$NF|0J30$O=*N;$9$k(B
TODAY=`date +%A`
[ ${TODAY:?}  = "Sunday"    ] && exit 0
#[ ${TODAY:?} = "Monday"    ] && exit 0
#[ ${TODAY:?} = "Tuesday"   ] && exit 0
[ ${TODAY:?}  = "Wednesday" ] && exit 0
#[ ${TODAY:?} = "Thursday"  ] && exit 0
#[ ${TODAY:?} = "Friday"    ] && exit 0
[ ${TODAY:?}  = "Saturday"  ] && exit 0

# ~/data$B0J2<$N(Bogg$B$N<B9T(B
for FILE in `ls -1 /home/pi/data/*.ogg`
do
  echo $FILE                >> ${LOG:?}
  sudo /usr/bin/aumix -v 50 >> ${LOG:?} 2>&1
  /usr/bin/ogg123 $FILE     >> ${LOG:?}
done

exit 0
