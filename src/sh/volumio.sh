#!/bin/sh
###############################################################################
#
# volumioのリモート実行
#
###############################################################################
NAME=${0##*/}
LOG_DIR=/home/pi/log
LOG_PATH=$LOG_DIR/$NAME.log

echo -n "`date '+%Y%m%d.%H%M%S'`:"     >> ${LOG_PATH:?}
if [ "$1" = "stop" -o "$1" = "play" -o "$1" = "start" ]; then
  ssh volumio@rpi2 "volumio $1"        2>> ${LOG_PATH:?} | jq '.response' >> ${LOG_PATH:?}
else
  ssh volumio@rpi2 "volumio volume $1" 2>> ${LOG_PATH:?} | jq '.response' >> ${LOG_PATH:?}
fi
echo "$0 $@ :$?"                                                          >> ${LOG_PATH:?}
