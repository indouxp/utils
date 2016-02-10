#!/bin/sh
###############################################################################
# shoutdown host by switch
#
###############################################################################
LOG=/var/log/${0##*/}.log
# GPIO_7を(Pin26)使用
GPIO_NO=7

if [ -x /home/pi/utils/src/sh/chk-ntpq.sh ]; then
  rc=""
  while [ $rc -ne 0 ]; do
    /home/pi/utils/src/sh/chk-ntpq.sh # ntpにより、時刻が正しいか
    rc=$?
  done
fi

echo "`date '+%Y%m%d.%H%M%S'`:${0##*/}:start"   >> ${LOG:?}
echo ${GPIO_NO:?} > /sys/class/gpio/export

while [ ! -f /sys/class/gpio/gpio${GPIO_NO:?}/direction ]
do 
  sleep 1
done

# ${GPIO_NO}をデジタル入力用に設定
echo in > /sys/class/gpio/gpio${GPIO_NO:?}/direction

# 内蔵抵抗が働くように(high:プルアップ、low:プルダウン)
echo high > //sys/class/gpio/gpio${GPIO_NO:?}/direction

export GPIO_NO
while [ `cat /sys/class/gpio/gpio${GPIO_NO:?}/value` -eq 1 ]
do
  sleep 1
done

echo ${GPIO_NO:?} > /sys/class/gpio/unexport

/home/pi/utils/src/sh/shdw-raspi.sh               >> ${LOG:?}
echo "`date '+%Y%m%d.%H%M%S'`:${0##*/}:shutdown"  >> ${LOG:?}
shutdown -h now
