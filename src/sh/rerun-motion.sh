#!/bin/sh
###############################################################################
#
# motion$B$,%3%1$F$$$?$i!"F0$+$9(B
#
###############################################################################
NAME=${0##*/}
FORMAT='+%Y%m%d.%H%M%S'
LOG_PATH=/tmp/$NAME.log
if systemctl status motion | grep stop >/dev/null; then
  systemctl restart motion >/dev/null
  echo "$(date $FORMAT):restart:$?" >>$LOG_PATH
fi
