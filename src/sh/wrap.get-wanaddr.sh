#!/bin/bash
###############################################################################
#
#
#
###############################################################################
NAME=${0##*/}
LOG_DIR=/home/pi/log
LOG_NAME=${NAME:?}.log
LOG_PATH=${LOG_DIR:?}/${LOG_NAME:?}
PY_DIR=/home/pi/utils/src/py
MAILTO="indou.tsystem@gmail.com"

RC=0

###############################################################################
set -eu

function catch {
  RC=12
}
trap catch ERR

function finally {
  exit ${RC:?}
}
trap finally EXIT

###############################################################################

if [ ! -x $(which python3) ]; then
  echo "${NAME:?}: python3 not exist" 1>&2
  RC=12
fi
if [ ! -d ${PY_DIR:?} ]; then
  echo "${NAME:?}: ${PY_DIR:?} not exist" 1>&2
  RC=12
fi
###############################################################################
IPADDR=$(python3 ${PY_DIR:?}/get-wanaddr.py)
mail -s "${NAME:?}: ${IPADDR:?}" ${MAILTO:?} <<EOT
$(who am i | awk '{print $1;}')@$(hostname)
$(date '+%Y-%m-%d %H:%M:%S.%3N')
WAN: ${IPADDR:?}
EOT
