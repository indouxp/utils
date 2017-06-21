#!/bin/sh

sudo ufw disable
#wakeonlan 00:26:18:3A:F6:1C # vip #2
wakeonlan 00:26:18:3A:F6:1D # vip
RC=$?
echo "wol:${RC:?}"
sudo ufw -f enable
sudo ufw status


