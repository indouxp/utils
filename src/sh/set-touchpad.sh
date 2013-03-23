#!/bin/sh
case $1 in
on)
  switch=1
  ;;
off)
  switch=0
  ;;
esac

set -e

id=`xinput list | grep -i touch | sed "s/.*id=\([0-9][0-9]*\).*/\1/"`

xinput set-prop ${id:?} "Device Enabled" ${switch:?}
