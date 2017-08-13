#!/bin/sh

sudo ufw disable
#wakeonlan e8:39:35:2a:8a:08 # ml110g7
wakeonlan e4:11:5b:ae:d6:64 # ml110g7-2
RC=$?
echo "wol:${RC:?}"
sudo ufw -f enable
sudo ufw status


