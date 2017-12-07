#!/bin/sh
###############################################################################
# 仕事の日のアラーム
#
#
###############################################################################
LOG=/home/pi/log/${0##*/}.log
export LANG=C

# 仕事の日以外は終了する
TODAY=`date +%A`
[ ${TODAY:?}  = "Sunday"    ] && exit 0
#[ ${TODAY:?} = "Monday"    ] && exit 0
#[ ${TODAY:?} = "Tuesday"   ] && exit 0
[ ${TODAY:?}  = "Wednesday" ] && exit 0
#[ ${TODAY:?} = "Thursday"  ] && exit 0
#[ ${TODAY:?} = "Friday"    ] && exit 0
[ ${TODAY:?}  = "Saturday"  ] && exit 0

date '+%Y%m%d.%H%M%S'       >> ${LOG:?}
## ~/data以下のoggの実行
#for FILE in `ls -1 /home/pi/data/*.ogg`
#do
#  echo $FILE                >> ${LOG:?}
#  sudo /usr/bin/aumix -v 50 >> ${LOG:?} 2>&1
#  /usr/bin/ogg123 $FILE     >> ${LOG:?}
#done
#
ssh volumio@rpi2 'volumio random'
ssh volumio@rpi2 'volumio play'
exit 0
