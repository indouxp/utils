#!/bin/sh

sudo ufw disable
wakeonlan 90:b1:1c:7a:83:93	# t3600
RC=$?
echo "wol:${RC:?}"
sudo ufw enable
sudo ufw status


