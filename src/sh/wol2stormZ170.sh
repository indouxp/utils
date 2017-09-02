#!/bin/sh

sudo ufw disable
#wakeonlan 90:b1:1c:7a:83:93	# t3600
wakeonlan F8:32:E4:71:19:94	# stormZ170
RC=$?
echo "wol:${RC:?}"
sudo ufw -f enable
sudo ufw status


