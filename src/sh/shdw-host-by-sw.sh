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
  while [ "$rc" != "0" ]; do
    /home/pi/utils/src/sh/chk-ntpq.sh # ntpにより、時刻が正しいか
    rc=$?
    sleep 1 
  done
fi

msg="`date '+%Y%m%d.%H%M%S'`:${0##*/}:start"
echo ${msg:?} | tee -a ${LOG:?} | logger

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

#/home/pi/utils/src/sh/shdw-raspi.sh               >> ${LOG:?} 2>&1
HOSTS="192.168.11.170 192.168.11.171 192.168.0.80 192.168.0.81"
for HOST in $HOSTS
do
  su pi -c "ssh pi@$HOST 'sudo shutdown -h now' &"  >> ${LOG:?} 2>&1
done

msg="`date '+%Y%m%d.%H%M%S'`:${0##*/}:shutdown"
echo ${msg:?} | tee -a ${LOG:?} | logger
shutdown -h now
