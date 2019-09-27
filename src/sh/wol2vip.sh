#!/bin/sh

#[ -x /usr/sbin/ufw ] && sudo ufw disable
#wakeonlan 00:26:18:3A:F6:1C # vip #2
wakeonlan 00:26:18:3A:F6:1D # vip
RC=$?
echo "wol:${RC:?}"
#[ -x /usr/sbin/ufw ] && sudo ufw -f enable
#[ -x /usr/sbin/ufw ] && sudo ufw status

NAME=${0##*/}
LOG=/var/log/${0##*/}.log
sudo touch ${LOG:?} && sudo chmod a+w ${LOG:?}
echo "${NAME:?} done. `date '+%Y%m%dT%H%M%S'`" >> ${LOG:?}
