#!/bin/sh
# https://qiita.com/koara-local/items/1fac13704123717f5cc8
# cpu温度取得(raspberry pi)

for FILE in /sys/class/thermal/thermal_zone0/temp
do
  echo $FILE
  echo "scale=2; `cat $FILE` / 1000" | bc
done
