#!/bin/sh

[ -x /usr/sbin/ufw ] && sudo ufw disable

ML110G7_2="e4:11:5b:ae:d6:64"
wakeonlan ${ML110G7_2:?}
RC=$?
echo "wol:${RC:?}"

[ -x /usr/sbin/ufw ] && sudo ufw -f enable
[ -x /usr/sbin/ufw ] && sudo ufw status

NAME=${0##*/}
LOG=/var/log/${0##*/}.log
sudo touch ${LOG:?} && sudo chmod a+w ${LOG:?}
echo "${NAME:?} done. `date '+%Y%m%dT%H%M%S'`" >> ${LOG:?}
