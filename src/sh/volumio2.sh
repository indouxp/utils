#!/bin/sh
###############################################################################
#
# volumioのリモート実行
#
###############################################################################
NAME=${0##*/}
LOG_DIR=/home/pi/log
LOG_PATH=$LOG_DIR/$NAME.log

if [ ! -x $(which curl) ]; then
  echo "${NAME:?}: curl not found."
fi
if [ ! -x $(which jq) ]; then
  echo "${NAME:?}: jq not found."
fi

PLAYLIST=$1
VOL=$2

curl "http://rpi2/api/v1/commands?cmd=playplaylist&name=${PLAYLIST:?}" \
  >> ${LOG_PATH:?} 2>&1                                      |\
  jq '.response' >> ${LOG_PATH:?}

curl "http://rpi2/api/v1/commands?cmd=volume&volume=${VOL:?}" \
  >> ${LOG_PATH:?} 2>&1                                      |\
  jq '.response' >> ${LOG_PATH:?}
