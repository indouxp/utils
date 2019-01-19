#!/bin/sh
# サーバ/インフラを支える技術 P.9
#
#
SCRIPT=`basename $0`
VIP="192.168.0.254"  # 仮想IP
DEV="eth0"           # NIC名
LOG=/tmp/${0##*/}.log
FMT='+%Y%m%d%H%M%S'
HFMT='+%Y%m%d%H'

main() {
  echo "${SCRIPT:?}: $(date ${FMT:?}): START" > ${LOG:?} 
  BEF=$(date ${HFMT:?})
  while healthcheck
  do
    echo -n "." >> ${LOG:?}
    sleep 1
    if [ "${BEF:?}" -ne "$(date ${HFMT:?})" ]; then
      echo "" >> ${LOG:?}
      echo -n "${SCRIPT:?}: $(date ${FMT:?}): WAIT" >>${LOG:?}
    fi
    BEF=$(date ${HFMT:?})
  done
  echo "${SCRIPT:?}: $(date ${FMT:?}): fail over!" >> ${LOG:?}
  ip_takeover
  echo "${SCRIPT:?}: $(date ${FMT:?}): DONE" >> ${LOG:?} 
}

# $VIPの生死監視
# 0 :生
# 0<:死
healthcheck() {
  # c1 1 : 一回
  # -w 1 : タイムアウト1sec
  #ping -c 1 -w 1 $VIP >/dev/null
  
  curl $VIP > /dev/null 2>&1
  return $?
}

# $VIPと、$DEVのMACアドレスをGratuitous ARPで、ブロードキャスト
ip_takeover() {
  # $DEVのMACを取得
  MAC=`ip link show $DEV | egrep -o '([0-9a-f]{2}:){5}[0-9a-f]{2}' | head -n1 | tr -d :`
  # $DEVに、$VIPをlabel付きで追加する
  ip addr add $VIP/24 dev $DEV label $DEV:V1
  ip addr show
  ifconfig
  # $VIPと$MACをブロードキャスト
  send_arp ${VIP:?} ${MAC:?} 255.255.255.255 ffffffffffff
}

main
