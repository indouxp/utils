#!/bin/sh
SCRIPT_NAME=`basename $0`

RC=1
# wzr-hp-g450hに振られている可能性のあるアドレスを順に処理
for fourth in `seq 1 244`
do
  wzr_hp_g450h="192.168.0.${fourth:?}"
  if ping -c1 $wzr_hp_g450h >/dev/null 2>&1; then
    # routeに192.168.11.0ネットワークを登録し、192.168.11.1へのpingを見る
    # wzr-hp-g450hには、192.168.11.1がLAN側のIP ADDRESSとして振られている
    route add -net 192.168.11.0 netmask 255.255.255.0 gw $wzr_hp_g450h
    if ping -c1 192.168.11.1 >/dev/null 2>&1; then
      echo "OK" $wzr_hp_g450h
      logger "${SCRIPT_NAME:?}: routing done."
      date  >   /var/log/${SCRIPT_NAME:?}.log
      route >>  /var/log/${SCRIPT_NAME:?}.log
      # pingが通ればOK
      RC=0
      break
    else
      echo "NG" $wzr_hp_g450h
      logger "${SCRIPT_NAME:?}:${wzr_hp_g450h:?}:ng."
    fi
    route del -net 192.168.11.0 netmask 255.255.255.0
  else
    echo "NG" $wzr_hp_g450h
    logger "${SCRIPT_NAME:?}: $wzr_hp_g450h not found."
  fi
done
exit ${RC:?}
