#!/bin/sh
###############################################################################
# DESCRIPTION:macbook上のubuntuで、タッチパッドを無効にする。
#
###############################################################################
case $1 in
on) switch=1 ;;
off) switch=0 ;;
*)
  cat <<EOT 1>&2
Usage:
# `basename $0` on|off
EOT
  exit 1
  ;;
esac

set -e

id=`xinput list | grep -i touch | sed "s/.*id=\([0-9][0-9]*\).*/\1/"`

xinput set-prop ${id:?} "Device Enabled" ${switch:?}
