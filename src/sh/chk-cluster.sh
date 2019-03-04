#!/bin/sh
###############################################################################
#
# lxc上の$NODE1と$NODE2のeth0のIPと、VIPを取得し、
#
#
###############################################################################
set -e

# lxc上の$NODE1と$NODE2のeth0のIPと、VIPを取得
for host in c7-1 c7-2
do
	NUM=$(lxc ls ${host:?} | grep eth0 | wc -l)
	if [ "$NUM" -eq "2" ]; then
		break
	fi
done

# 二つのIP(VIP)を持つアドレスを取得。後ろ側のアドレスが変数ipに代入される
for ip in $(lxc ls ${host:?} | grep -o "[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]")
do
	:
done

後ろ側が、VIPなので、hタグの内容を取得する
HOST=$(curl -s ${ip:?} | grep -o "<h1>[^<]*</h1>" | sed 's/<h1>//; s/<\/h1>//')

if [ "${HOST}" == "" ]; then
  echo no active
else
  echo $HOST active
fi
