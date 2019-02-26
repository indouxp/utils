#!/bin/sh

set -e

for host in c7-1 c7-2
do
	NUM=$(lxc ls ${host:?} | grep eth0 | wc -l)
	if [ "$NUM" -eq "2" ]; then
		break
	fi
done

for ip in $(lxc ls ${host:?} | grep -o "[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]")
do
	:
done

HOST=$(curl -s ${ip:?} | grep -o "<h1>[^<]*</h1>" | sed 's/<h1>//; s/<\/h1>//')

echo $HOST active
