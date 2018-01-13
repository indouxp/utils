#!/bin/sh
# https://qiita.com/koara-local/items/1fac13704123717f5cc8
# cpu温度取得(macbook)

hostname

case `uname -m` in
armv6l)
  if cd  /sys/class/thermal/thermal_zone0
  then
    echo "scale=2; `cat temp` / 1000" | bc
  fi
  ;;
*)
  if cd /sys/devices/platform/coretemp.0/hwmon/hwmon[01]
  then
    for FILE in *input
    do
      echo $FILE
      echo "scale=2; `cat $FILE` / 1000" | bc
    done
  fi
  ;;
esac
