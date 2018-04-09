#!/bin/sh
###############################################################################
#
# secureログ
#
###############################################################################
NAME=${0##*/}
SECURELOG_PATH="/var/log/secure*"

echo "接続成功"
sudo grep "Accepted" /var/log/secure* | awk '{print $9, $11;}' | sort | uniq -c | more

echo -n "OK?:"
read OK

echo "接続失敗"
sudo grep -E "Failed|Invalid" /var/log/secure* | awk '{print $10;}' | sort | uniq -c | sort | more

echo "done"

