#!/bin/sh
###############################################################################
#
# 192.168.1.0/24へのrouteを、c7に向ける

# 20180201:sudoがないとエラーとなるので、sudoなしで実行する。
#
###############################################################################
C7_IP=192.168.0.57
sudo route || route

sudo route add -net 192.168.1.0 netmask 255.255.255.0 gw ${C7_IP:?} || route add -net 192.168.1.0 netmask 255.255.255.0 gw ${C7_IP:?}

sudo route || route

