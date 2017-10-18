#!/bin/sh
# https://qiita.com/koara-local/items/1fac13704123717f5cc8
#

if cd /sys/devices/platform/coretemp.0/hwmon/hwmon1
then
  for FILE in *input
  do
    echo $FILE
    echo "scale=2; `cat $FILE` / 1000" | bc
  done
fi
