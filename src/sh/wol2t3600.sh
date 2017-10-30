#!/bin/sh

[ -x /usr/sbin/ufw ] && sudo ufw disable
wakeonlan 90:b1:1c:7a:83:93	# t3600
RC=$?
echo "wol:${RC:?}"
[ -x /usr/sbin/ufw ] && sudo ufw -f enable
[ -x /usr/sbin/ufw ] && sudo ufw status

NAME=${0##*/}
LOG=/var/log/${0##*/}.log
sudo touch ${LOG:?} && sudo chmod a+w ${LOG:?}
echo "${NAME:?} done. `date '+%Y%m%dT%H%M%S'`" >> ${LOG:?}
