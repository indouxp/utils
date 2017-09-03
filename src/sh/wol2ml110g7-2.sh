#!/bin/sh

[ -x /usr/sbin/ufw ] && sudo ufw disable
#wakeonlan e8:39:35:2a:8a:08 # ml110g7
wakeonlan e4:11:5b:ae:d6:64 # ml110g7-2
RC=$?
echo "wol:${RC:?}"
[ -x /usr/sbin/ufw ] && sudo ufw -f enable
[ -x /usr/sbin/ufw ] && sudo ufw status


