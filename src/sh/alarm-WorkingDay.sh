#!/bin/sh
###############################################################################
# 仕事の日のアラーム
#
#
###############################################################################
LOG=/home/pi/log/${0##*/}.log
export LANG=C

DONE() {
  echo "skip" >> ${LOG:?}
  exit 1
}


# 仕事の日以外は終了する
TODAY=`date +%A`
[ ${TODAY:?}  = "Sunday"    ] && DONE
#[ ${TODAY:?} = "Monday"    ] && DONE
#[ ${TODAY:?} = "Tuesday"   ] && DONE
[ ${TODAY:?}  = "Wednesday" ] && DONE
#[ ${TODAY:?} = "Thursday"  ] && DONE
#[ ${TODAY:?} = "Friday"    ] && DONE
[ ${TODAY:?}  = "Saturday"  ] && DONE

date '+%Y%m%d.%H%M%S'       >> ${LOG:?}
## ~/data以下のoggの実行
#for FILE in `ls -1 /home/pi/data/*.ogg`
#do
#  echo $FILE                >> ${LOG:?}
#  sudo /usr/bin/aumix -v 50 >> ${LOG:?} 2>&1
#  /usr/bin/ogg123 $FILE     >> ${LOG:?}
#done
#
ssh volumio@rpi2 'volumio random' >> ${LOG:?}
echo ""                           >> ${LOG:?}
ssh volumio@rpi2 'volumio play'   >> ${LOG:?}
echo ""                           >> ${LOG:?}
exit 0
