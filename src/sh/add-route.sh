#!/bin/sh
SCRIPT_NAME=`basename $0`

RC=1
# wzr-hp-g450hに振られている可能性のあるアドレスを順に処理
for wzr_hp_g450h in \
  192.168.0.2\
  192.168.0.3\
  192.168.0.4\
  192.168.0.5\
  192.168.0.6
do
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
